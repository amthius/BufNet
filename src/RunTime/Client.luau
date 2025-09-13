local Player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")

local Constructor = require(script.Parent.Parent.Process.Constructor)
local Dispatcher = require(script.Parent.Parent.Process.Dispatcher)
local OIBridge = require(script.Parent.Parent.Process.OIBridge)

local Types = require(script.Parent.Parent.Types)

local Client = {}
local UserGroups = {} :: { [string]: { [Players]: {} } }
local ActiveChannels = {}

local ChannelContainer = script.Parent:FindFirstChild("Channels")

function Client.build_channel(props: Types.ChannelProps, struct: Types.Channel)
	local name = props.name
    local type = props.type
	local inst = ChannelContainer:WaitForChild(name) :: any

    inst.OnClientEvent:Connect(function(buf: buffer, instances: {[number]: Instance})
        if buffer.len(buf) >= struct.max_buffer_size then
            return
        end

        OIBridge.OI = struct.instances

        struct.instances.incoming = instances
        Dispatcher(struct, buf, Player)
    end)

    local users = {[Player] = {}}
    UserGroups[name] = users

    struct.instance = inst
	struct.users = users
	struct.type = type :: any

    table.insert(ActiveChannels, struct)
	return struct 
end

function Client.start()
    local item
    local sent

    RunService.Heartbeat:Connect(function()
        for i = 1, #ActiveChannels do
            item = ActiveChannels[i]
            sent = item.users[Player]

            if #sent ~= 0 then
                OIBridge.OI = item.instances

                local buf = Constructor(sent)
                item.instance:FireServer(buf, item.instances.outgoing)

                table.clear(sent)
                table.clear(item.instances.outgoing)
            end

        end
    end)
end

return Client