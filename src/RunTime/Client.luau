local Player = game:GetService("Players").LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Constructor = require(ReplicatedStorage.BufNet.Process.Constructor)
local Dispatcher = require(ReplicatedStorage.BufNet.Process.Dispatcher)
local Types = require(ReplicatedStorage.BufNet.Types)

local Client = {}
local UserGroups = {} :: { [string]: { [Players]: {} } }
local ActiveChannels = {}

local ChannelContainer = script.Parent:FindFirstChild("Channels")

function Client.build_channel(props: Types.ChannelProps)
	local name = props.name
	local inst = ChannelContainer:WaitForChild(name) :: any
    local channel

    inst.OnClientEvent:Connect(function(buf: buffer)
        Dispatcher(channel, buf, Player)
    end)

    local users = {[Player] = {}}
    UserGroups[name] = users

    channel = {
        instance = inst,
        users = users,
        packets = {},
    }

    table.insert(ActiveChannels, channel)
	return channel 
end

function Client.start()
    local item
    local sent

    RunService.Heartbeat:Connect(function()
        for i = 1, #ActiveChannels do
            item = ActiveChannels[i]
            sent = item.users[Player]

            if #sent ~= 0 then
                local buf = Constructor(sent)
                item.instance:FireServer(buf)
                table.clear(sent)
            end

        end
    end)
end

return Client