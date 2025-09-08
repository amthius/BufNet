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
	return RuntimeHandler.build_channel(props)
end
