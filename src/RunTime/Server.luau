local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Constructor = require(ReplicatedStorage.BufNet.Process.Constructor)
local Dispatcher = require(ReplicatedStorage.BufNet.Process.Dispatcher)
local Types = require(ReplicatedStorage.BufNet.Types)

local Server = {}
local UserGroups = {} :: { [string]: { [Players]: {} } }
local ActiveChannels = {}

local ChannelContainer = Instance.new("Folder")
ChannelContainer.Name = "Channels"
ChannelContainer.Parent = script.Parent

function Server.build_channel(props: Types.ChannelProps)
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
	local channel

	inst.OnServerEvent:Connect(function(player: Player, buf: buffer)
		if typeof(buf) ~= "buffer" then
			return
		end

		Dispatcher(channel, buf, player)
	end)

	local users = {}
	for _, player in Players:GetPlayers() do
		users[player] = {}
	end

	UserGroups[name] = users
	channel = {
		instance = inst,
		users = users,
		packets = {},
	}

	table.insert(ActiveChannels, channel)
	return channel
end

function Server.start()
	local item
	local sent

	RunService.Heartbeat:Connect(function()
        local current_players = Players:GetPlayers()

		for p = 1, #Players:GetPlayers() do
            local player = current_players[p]

			for i = 1, #ActiveChannels do
				item = ActiveChannels[i]
				sent = item.users[player]

				if #sent ~= 0 then
					local buf = Constructor(sent)
					item.instance:FireClient(player, buf)
					table.clear(sent)
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
