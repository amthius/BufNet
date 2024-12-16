local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)

local size_chosen: Types.TypeStruct<any>

return function(
    data: Types.TypeStruct<any>,
    size: Types.TypeStruct<any>?
): Types.TypeStruct<{[number]: any}>

    size_chosen = (size or u8() :: any)

    local offset = size_chosen.size :: number
    local write = size_chosen.write
    local read = size_chosen.read

    local bdata = {}

    bdata.size = (function(sent)
        local size = offset

        for i = 1, #sent do
            if typeof(data.size) == "function" then
                size += data.size(sent[i])
            else
                size += data.size
            end
        end

        return size
    end)

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local unpacked = {}
        local length = read(buf, cursor)

        for i = 1, length do
            table.insert(unpacked, data.read(buf, cursor))
        end

        return unpacked
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: {[number]: any})
        local length = #value
        write(buf, cursor, length)

        for i = 1, length do
            data.write(buf, cursor, value[i])
        end
    end

    return bdata
end