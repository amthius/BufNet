--!native

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Construct = require(script.Parent.Parent.Process.Construct)
local Dispatch = require(script.Parent.Parent.Process.Dispatch)
local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)

local Server = {}
local Sent = {}

local function OnServerEvent(player: Player, buf: buffer?, instances: {[number]: Instance}?) 
    if typeof(buf) ~= "buffer" then return end

    if instances then
        assert(#instances <= 256, "Instance limit exceeded (256)")
        ReferenceTables.Instances.In = instances
    end

    local data = Dispatch(buf, player)

    if data then
        for i = 1, #data do
            Server.Deliver(data[i], player)
        end
    end

    ReferenceTables.Instances.In = nil
end

function Server.Deliver(data: any, player: Player)
    if not Sent[player] then
        Sent[player] = {}
    end

    table.insert(Sent[player], data)
end

function Server.Start()
    local Container = Instance.new("Folder")
    Container.Name = "BufContainer"
    Container.Parent = ReplicatedStorage

    local Remote = Instance.new("RemoteEvent")
    Remote.Name = "BufRemote"
    Remote.Parent = Container

    Remote.OnServerEvent:Connect(OnServerEvent)

    RunService.Heartbeat:Connect(function()

        for _, player in Players:GetPlayers() do
            local data = Sent[player]

            if data and #data ~= 0 then 
                local buf = Construct(data)

                Remote:FireClient(player, buf, ReferenceTables.Instances.Out)
                ReferenceTables.Instances.Out = nil
            end
        end

        table.clear(Sent)
    end)
end

return Server