local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)()

local read = u8.read
local write = u8.write

return function(): Types.TypeStruct<Color3>

    local bdata = {}
    bdata.size = 3

    function bdata.read(buf: buffer, cursor: Types.cursor)
        return Color3.fromRGB(read(buf, cursor), read(buf, cursor), read(buf, cursor))
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: Color3)
        write(buf, cursor, value.R * 255)
        write(buf, cursor, value.G * 255)
        write(buf, cursor, value.B * 255)
    end

    return bdata
end