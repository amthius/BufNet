local u8 = require(script.Parent.Parent.DataTypes.u8)()
local Types = require(script.Parent.Parent.Types)

type Payload = {
	[number]: {
		id: number,
		outgoing: Types.TypeStruct<any>,
		sent: any,
	},
}

local function size(payload: Payload): number
	local buf_size = 0
    local data
	for i = 1, #payload do
		data = payload[i]
		buf_size += 1
		local size_type = data.outgoing.size

		if typeof(size_type) == "function" then
			buf_size += size_type(data.sent)
		else
			buf_size += size_type
		end
	end

	return buf_size
end

local function write(buf: buffer, cursor: Types.cursor, payload: Payload)
    local data
	for i = 1, #payload do
		data = payload[i]
		u8.write(buf, cursor, data.id)
		data.outgoing.write(buf, cursor, data.sent)
	end
end

return function(payload: Payload): buffer
	local cursor = { value = 0 }
	local buf = buffer.create(size(payload))
	write(buf, cursor, payload)
	
	return buf
end