local Types = require(script.Parent.Parent.Types)

return function(): Types.TypeStruct<number>
    local bdata = {}
    bdata.size = 8

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local result = buffer.readf64(buf, cursor.value)
        cursor.value += bdata.size 
        return result
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: number)
        buffer.writef64(buf, cursor.value, value)
        cursor.value += bdata.size
    end

    return bdata
end