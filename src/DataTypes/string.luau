local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)

local size_chosen: Types.TypeStruct<any>
local string_ids = {}

return function(size: Types.TypeStruct<any>?): Types.TypeStruct<string>
    size_chosen = (size or u8() :: any)

    local offset = size_chosen.size :: number
    local write = size_chosen.write
    local read = size_chosen.read

    local bdata = {}

    bdata.size = (function(str: string)
        local length = str:len() + offset :: any 
        table.insert(string_ids, length)
        return length
    end)

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local length = read(buf, cursor)

        local value = buffer.readstring(buf, cursor.value, length)
        cursor.value += length
        return value
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: string)
        local length = string_ids[1]
        table.remove(string_ids, 1)

        write(buf, cursor, length - offset)
        buffer.writestring(buf, cursor.value, value)
        cursor.value += length - offset 
    end

    return bdata
end