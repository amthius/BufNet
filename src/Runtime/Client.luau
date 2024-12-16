--!native

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Construct = require(script.Parent.Parent.Process.Construct)
local Dispatch = require(script.Parent.Parent.Process.Dispatch)
local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)

local Client = {}
local Sent = {}

local function OnClientEvent(buf: buffer, instances: {[number]: Instance}?)
    if typeof(buf) ~= "buffer" then return end

    if instances then
        ReferenceTables.Instances.In = instances
    end

    Dispatch(buf)
    ReferenceTables.Instances.In = nil 
end

function Client.Deliver(data: any)
    table.insert(Sent, data)
end

function Client.Start()
    local Container = ReplicatedStorage:WaitForChild("BufContainer", 5)
    local Remote: RemoteEvent = Container:WaitForChild("BufRemote", 5)

    Remote.OnClientEvent:Connect(OnClientEvent)

    RunService.Heartbeat:Connect(function()
        if #Sent ~= 0 then 
            local buf = Construct(Sent)
            Remote:FireServer(buf, ReferenceTables.Instances.Out)

            table.clear(Sent)
            ReferenceTables.Instances.Out = nil
        end
    end)

end

return Client