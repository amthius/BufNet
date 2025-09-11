local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Types = require(script.Parent.Types)

local RunContext = if RunService:IsServer() then "Server" else "Client"

local RuntimeHandler
if RunContext == "Server" then
    RuntimeHandler = require(ReplicatedStorage.BufNet.RunTime.Server)
elseif RunContext == "Client" then
    RuntimeHandler = require(ReplicatedStorage.BufNet.RunTime.Client)
end

return function(props: Types.ChannelProps)
    local struct = {
		packets = {},

        max_packet_process = props.max_packet_process or 20,
        max_buffer_size = props.max_buffer_size or 10000,

		instances = {
            outgoing = {},
            incoming = {}
        }
    } :: any

	return RuntimeHandler.build_channel(props, struct)
end
