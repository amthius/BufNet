local Types = require(script.Parent.Parent.Types)

return function(): Types.TypeStruct<boolean>
    local bdata = {}
    bdata.size = 1

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local result = buffer.readu8(buf, cursor.value)
        cursor.value += bdata.size 

        if result == 1 then
            return true
        else
            return false
        end

    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: boolean)

        if value then
            buffer.writeu8(buf, cursor.value, 1)   
        else
            buffer.writeu8(buf, cursor.value, 0)
        end

        cursor.value += bdata.size
    end

    return bdata
end