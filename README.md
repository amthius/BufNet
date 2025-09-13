
# BufNet v2
The new and improved version.
## Quickstart
```lua
--> Repository.luau 
local BufNet = require(...) --> path to BufNet

local Channel = BufNet.Channel
local Packet = BufNet.Packet
local Types = BufNet.Types

local ChannelA = Channel({
	type = "Reliable",
	name = "ChannelA",

    --> default values
	--max_calls = 20, 
	--max_buffer_size = 5000,
	--invoke_lifespan = 5
})

local ChannelB = Channel({
	type = "Unreliable",
	name = "ChannelB",

    max_calls = 10,
    max_buffer_size = 900
})

return {
	SomeFunct = Packet.Funct({
		channel = ChannelA,
		outgoing = Types.u8(),
		incoming = Types.u8()
	}),

	SomeEvent = Packet.Event({
		channel = ChannelB,
		outgoing = Types.bool()
	}),

}
```
```lua
--> Server.luau
local Repository = require(...) --> Repository.luau

Repository.SomeFunct:Callback(function()
	return 0
end)

Repository.SomeEvent:Connect(function(b, player)
	print(b, player) --> true, player
end)
```
```lua
--> Client.luau
local Repository = require(...) --> Repository.luau

local result = Repository.SomeFunct:Invoke(1)
print(result) --> 0

Repository.SomeEvent:Fire(true)
```