local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Constructor = require(script.Parent.Parent.Process.Constructor)
local Dispatcher = require(script.Parent.Parent.Process.Dispatcher)
local OIBridge = require(script.Parent.Parent.Process.OIBridge)

local Types = require(script.Parent.Parent.Types)

local Server = {}
local UserGroups = {} :: { [string]: { [Players]: {} } }
local ActiveChannels = {}

local ChannelContainer = Instance.new("Folder")
ChannelContainer.Name = "Channels"
ChannelContainer.Parent = script.Parent

function Server.build_channel(props: Types.ChannelProps, struct: Types.Channel)
	local type = props.type
	local name = props.name
	local inst: any

	assert(not ChannelContainer:FindFirstChild(name), `{name} already exists, use a different name`)

	if type == "Reliable" then
		inst = Instance.new("RemoteEvent")
	elseif type == "Unreliable" then
		inst = Instance.new("UnreliableRemoteEvent")
	end

	inst.Name = name
	inst.Parent = ChannelContainer

    local users = {}

	inst.OnServerEvent:Connect(function(player: Player, buf: buffer, instances: {[number]: Instance})
		if typeof(buf) ~= "buffer" then
			return
		end

		if buffer.len(buf) >= struct.max_buffer_size then
            return
        end

		OIBridge.OI = struct.instances

		if #instances ~= 0 and #instances < 256 then
			struct.instances.incoming = instances
		end

		local returned = Dispatcher(struct, buf, player)

        if returned then
			for i = 1, #returned do
				table.insert(users[player], returned[i])
			end
        end
	end)

	
	for _, player in Players:GetPlayers() do
		users[player] = {}
	end

	UserGroups[name] = users

	struct.instance = inst
	struct.users = users
	struct.type = type :: any

	table.insert(ActiveChannels, struct)
	return struct
end

function Server.start()
	local item
	local sent

	RunService.Heartbeat:Connect(function()
        local current_players = Players:GetPlayers()

		for p = 1, #current_players do
            local player = current_players[p]

			for i = 1, #ActiveChannels do
				item = ActiveChannels[i]
				sent = item.users[player]

				if #sent ~= 0 then
					OIBridge.OI = item.instances

					local buf = Constructor(sent)
					item.instance:FireClient(player, buf, item.instances.outgoing)

					table.clear(sent)
					table.clear(item.instances.outgoing)
				end
			end
		end
	end)

	Players.PlayerAdded:Connect(function(player)
		for name in UserGroups do
			UserGroups[name][player] = {}
		end
	end)

	Players.PlayerRemoving:Connect(function(player)
		for name in UserGroups do
			if UserGroups[name][player] then
				UserGroups[name][player] = nil
			end
		end
	end)
end

return Server
