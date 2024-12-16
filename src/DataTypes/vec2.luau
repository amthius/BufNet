local Types = require(script.Parent.Parent.Types)
local f32 = require(script.Parent.f32)()

local read = f32.read
local write = f32.write

return function(): Types.TypeStruct<Vector2>

    local bdata = {}
    bdata.size = 8

    function bdata.read(buf: buffer, cursor: Types.cursor)
        return Vector2.new(read(buf, cursor), read(buf, cursor))
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: Vector2)
        write(buf, cursor, value.X)
        write(buf, cursor, value.Y)
    end

    return bdata
end