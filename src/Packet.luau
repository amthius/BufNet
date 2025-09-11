local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Types = require(script.Parent.Types)

local RunContext = if RunService:IsServer() then "Server" else "Client"

local Packet = {}

function Packet.Event<O>(props: Types.EventProps<O>)
    local channel = props.channel
    assert(channel, "Channel must be defined for packet.")

    local id = #channel.packets + 1
	local outgoing = props.outgoing

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
			local payload = {id = id, outgoing = outgoing, sent = sent}

			if RunContext == "Server" then
				assert(player, "Player not specified.")
				table.insert(channel.users[player], payload)
			elseif RunContext == "Client" then
				table.insert(channel.users[Players.LocalPlayer], payload)
			end

        end,

		FireAll = function(self, sent: any)
			assert(RunContext == "Server", "FireAll can only be called from the server.")
			local payload = {id = id, outgoing = outgoing, sent = sent}

			for _, player in Players:GetPlayers() do
				table.insert(channel.users[player], payload)
			end
		end,

		FireList = function(self, sent: any, players: {Player})
			assert(RunContext == "Server", "FireList can only be called from the server.")
			local payload = {id = id, outgoing = outgoing, sent = sent}

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

	local id = #channel.packets + 1
	local outgoing = props.outgoing
	local incoming = props.incoming

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
			local payload = {id = id, outgoing = outgoing, incoming = incoming, sent = sent}

			table.insert(channel.users[Players.LocalPlayer], payload)
			table.insert(self._internal.invokes, coroutine.running())

			return coroutine.yield()
		end,

		Callback = function(self, callback: (sent: any) -> any, player: Player?)
			assert(RunContext == "Server", "Call only works on server")
			self._internal.callback = callback
		end,
	}

	table.insert(channel.packets, struct)
	return (struct :: any) :: Types.StructFunct<O, I>
end

return Packet