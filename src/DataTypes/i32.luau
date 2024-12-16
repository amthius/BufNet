local Types = require(script.Parent.Parent.Types)

return function(): Types.TypeStruct<number>
    local bdata = {}
    bdata.size = 4

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local result = buffer.readi32(buf, cursor.value)
        cursor.value += bdata.size 
        return result
    end

    function bdata.write(buf: buffer, cursor: {value: number}, value: number)
        buffer.writei32(buf, cursor.value, value)
        cursor.value += bdata.size
    end

    return bdata
end