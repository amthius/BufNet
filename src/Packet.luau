local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Types = require(script.Parent.Types)

local RunContext = if RunService:IsServer() then "Server" else "Client"

local Packet = {}
local InvokeRepositories = if RunContext == "Client" then {} else nil :: any

function Packet.Event<O>(props: Types.EventProps<O>)
    local channel = props.channel
    assert(channel, "Channel must be defined for packet.")

    local id = #channel.packets + 1
	local outgoing = props.outgoing

	local payload = {}
	payload.outgoing = outgoing
	payload.id = id

    local struct = {
		_internal = {
			callback = nil,
			outgoing = outgoing,
		},

		Identifier = "Event",

		Connect = function(self, callback: (sent: any, player: Player?) -> ()) 
			self._internal.callback = callback
        end,

		Fire = function(self, sent: any, player: Player?) 
			payload.sent = sent

			if RunContext == "Server" then
				assert(player, "Player not specified.")
				table.insert(channel.users[player], payload)
			elseif RunContext == "Client" then
				table.insert(channel.users[Players.LocalPlayer], payload)
			end

        end,

		FireAll = function(self, sent: any)
			assert(RunContext == "Server", "FireAll can only be called from the server.")
			payload.sent = sent

			for _, player in Players:GetPlayers() do
				table.insert(channel.users[player], payload)
			end
		end,

		FireList = function(self, sent: any, players: {Player})
			assert(RunContext == "Server", "FireList can only be called from the server.")
			payload.sent = sent

			for _, player in players do
				table.insert(channel.users[player], payload)
			end
		end,
	}

    table.insert(channel.packets, struct)
	return (struct :: any) :: Types.StructEvent<O>
end

function Packet.Funct<O, I>(props: Types.FunctProps<O, I>)
	local channel = props.channel
	assert(channel, "Channel must be defined for packet.")
	assert(channel.type ~= "Unreliable", `{channel.instance.Name} is Unreliable. It is not encouraged to use this protocol for Funct packet types due to potential data loss.`)

	local id = #channel.packets + 1
	local outgoing = props.outgoing
	local incoming = props.incoming

	local payload = {}
	payload.outgoing = outgoing
	payload.incoming = incoming
	payload.id = id

	local struct = {
		_internal = {
			callback = nil,
			outgoing = outgoing,
			incoming = incoming,
			invokes = {},
		},

		Identifier = "Funct",

		Invoke = function(self, sent: any)
			assert(RunContext == "Client", "Invoke can only be called from the client")
			payload.sent = sent

			table.insert(channel.users[Players.LocalPlayer], payload)
			local thread = coroutine.running()
			table.insert(self._internal.invokes, {thread = thread, creation = os.clock(), lifespan = channel.invoke_lifespan})

			return coroutine.yield()
		end,

		Callback = function(self, callback: (sent: any) -> any, player: Player?)
			assert(RunContext == "Server", "Call only works on server")
			self._internal.callback = callback
		end,
	}

	if RunContext == "Client" then
		table.insert(InvokeRepositories, struct._internal.invokes)
	end
	
	table.insert(channel.packets, struct)
	return (struct :: any) :: Types.StructFunct<O, I>
end

if RunContext == "Client" then
	RunService.Heartbeat:Connect(function()
		local current = os.clock()

		for i = 1, #InvokeRepositories do
			local holder = InvokeRepositories[i]

			for j = 1, #holder do
				local data = holder[i]
				if data.creation + data.lifespan < current then
					task.spawn(data.thread, nil)	
					table.remove(holder, 1)
				end
			end

		end
	end)
end

return Packet