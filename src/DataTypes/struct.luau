local Types = require(script.Parent.Parent.Types)

return function(data: {[any]: Types.TypeStruct<any>}): Types.TypeStruct<{}>
    local bdata = {}

    bdata.size = (function(sent)
        local size = 0

        for key, struct in data do
            if typeof(struct.size) == "function" then
                size += struct.size(sent[key])
            else
                size += struct.size
            end
        end

        return size
    end)
   
    function bdata.read(buf: buffer, cursor: Types.cursor)
        local unpacked = {}

        for key, struct in data do
            unpacked[key] = struct.read(buf, cursor)
        end

        return unpacked
    end

   function bdata.write(buf: buffer, cursor: Types.cursor, value: {[any]: any})
        for key, struct in data do
            struct.write(buf, cursor, value[key])
        end
    end 

    return bdata
end
