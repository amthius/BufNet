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

    for _, item in payload do
        buf_size += 1 
        local size_type = item.outgoing.size

        if typeof(size_type) == "function" then
            buf_size += size_type(item.sent)
        else
            buf_size += size_type
        end
    end

    return buf_size  
end

local function write(buf: buffer, cursor: Types.cursor, payload: Payload)
    for _, item in payload do
        u8.write(buf, cursor, item.id)
        item.outgoing.write(buf, cursor, item.sent)
    end
end

return function(payload: Payload): buffer
    local cursor = {value = 0}
    local buf = buffer.create(size(payload))
    write(buf, cursor, payload)
    return buf
end