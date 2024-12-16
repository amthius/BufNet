local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)
local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)()

local Instances = ReferenceTables.Instances

return function(): Types.TypeStruct<Instance>
    local bdata = {}
    bdata.size = 1

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local index = u8.read(buf, cursor) + 1
        return Instances.In[index]
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: Instance)

        if not Instances.Out then
            Instances.Out = {}
        end

        local index = #Instances.Out + 1

        u8.write(buf, cursor, index - 1)
        Instances.Out[index] = value
    end

    return bdata
end