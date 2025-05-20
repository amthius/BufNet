--!native

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Construct = require(script.Parent.Parent.Process.Construct)
local Dispatch = require(script.Parent.Parent.Process.Dispatch)
local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)

local Server = {}
local Sent = {}

local active_ids = {}
local caller_frequency = {}

local function OnServerEvent(player: Player, buf: buffer?, instances: {[number]: Instance}?) 
    if typeof(buf) ~= "buffer" then return end

    if not caller_frequency[player] then
        caller_frequency[player] = 1
    else
        caller_frequency[player] += 1
    end

    if caller_frequency[player] and caller_frequency[player] > 10 then
        player:Kick("[BUFNET: FLOOD CHECK] Do not spam packets")
    end

    local id = buffer.readu8(buf, 0)
    local length = buffer.len(buf)
    
    if length > 40000 then
        warn(`[{player} :: {player.UserId}] is sending too big of a packet!`)
        return 
    end

    if active_ids[id] then 
        return 
    end

    active_ids[id] = true

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
        table.clear(active_ids)
        table.clear(caller_frequency)
    end)
end

return Server