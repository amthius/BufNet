local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)()

return function<T>(data: Types.TypeStruct<any>): Types.TypeStruct<T?>
    local bdata = {}
  
    bdata.size = (function(sent)

        if sent == nil then
            return 1
        end

        local size = 1 -- u8 

        if typeof(data.size) == "function" then
            size += data.size(sent)
        else
            size += data.size
        end

        return size
    end)

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local result = u8.read(buf, cursor)

        if result == 1 then
            return data.read(buf, cursor)
        else
            return nil
        end

    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: any)

        if value then
            u8.write(buf, cursor, 1)
            data.write(buf, cursor, value)
        else
            u8.write(buf, cursor, 0)
        end

    end

    return bdata
end