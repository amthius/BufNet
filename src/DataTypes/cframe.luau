local Types = require(script.Parent.Parent.Types)
local f32 = require(script.Parent.f32)()

local read = f32.read
local write = f32.write

return function(): Types.TypeStruct<CFrame>

    local bdata = {}
    bdata.size = 24

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local x, y, z = read(buf, cursor), read(buf, cursor), read(buf, cursor)
        local rx, ry, rz = read(buf, cursor), read(buf, cursor), read(buf, cursor)

        return CFrame.new(x, y, z) * CFrame.Angles(rx, ry, rz)
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: CFrame)
        local x, y, z = value.X, value.Y, value.Z
        local rx, ry, rz = value:ToEulerAnglesXYZ()

        write(buf, cursor, x)
        write(buf, cursor, y)
        write(buf, cursor, z)
        write(buf, cursor, rx)
        write(buf, cursor, ry)
        write(buf, cursor, rz)

    end

    return bdata
end