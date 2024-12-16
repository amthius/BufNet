local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)

local size_chosen: Types.TypeStruct<any>

return function(
    index: Types.TypeStruct<any>,
    value: Types.TypeStruct<any>,
    size: Types.TypeStruct<any>?
): Types.TypeStruct<{[any]: any}>

    size_chosen = (size or u8() :: any)

    local offset = size_chosen.size :: number
    local write = size_chosen.write
    local read = size_chosen.read

    local bdata = {}

    bdata.size = (function(sent)
        local size = offset

        for i, v in sent do

            if typeof(index.size) == "function" then
                size += index.size(i)
            else
                size += index.size
            end

            if typeof(value.size) == "function" then
                size += value.size(v)
            else
                size += value.size
            end

        end

        return size
    end)

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local unpacked = {}
        local length = read(buf, cursor)

        for _ = 1, length do
            unpacked[index.read(buf, cursor)] = value.read(buf, cursor)
        end

        return unpacked
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, sent: {[any]: any})
        local length = 0

        for _ in sent do
            length += 1
        end

        write(buf, cursor, length)

        for i, v in sent do
            index.write(buf, cursor, i)
            value.write(buf, cursor, v)
        end

    end

    return bdata
end