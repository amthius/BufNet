--!native

local u8 = require(script.Parent.Parent.DataTypes.u8)()
local Types = require(script.Parent.Parent.Types)

type Payload = {
	[number]: {
		Id: number,
		data: Types.TypeStruct<any>,
		sent: any,
	},
}

local function size(payload: Payload): number
    local size = 0

    for _, item in payload do
      
        size += 1 -- Id u8
        local size_type = item.data.size

        if typeof(size_type) == "function" then
            size += size_type(item.sent)
        else
            size += size_type
        end

    end

    return size
end

local function write(buf: buffer, cursor: Types.cursor, payload: Payload)
    for _, item in payload do
        u8.write(buf, cursor, item.Id)
        item.data.write(buf, cursor, item.sent)
    end
end

return function(payload: Payload): buffer
    local cursor = {value = 0}
    local buf = buffer.create(size(payload))
    write(buf, cursor, payload)
    return buf
end