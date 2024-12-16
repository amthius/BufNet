local Types = require(script.Parent.Parent.Types)
local f32 = require(script.Parent.f32)()

local read = f32.read
local write = f32.write

return function(): Types.TypeStruct<Vector3>

    local bdata = {}
    bdata.size = 12

    function bdata.read(buf: buffer, cursor: Types.cursor)
        return Vector3.new(read(buf, cursor), read(buf, cursor), read(buf, cursor))
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: Vector3)
        write(buf, cursor, value.X)
        write(buf, cursor, value.Y)
        write(buf, cursor, value.Z)
    end

    return bdata
end