
local OIBridge = require(script.Parent.Parent.Process.OIBridge)
local Types = require(script.Parent.Parent.Types)
local u8 = require(script.Parent.u8)()

return function(): Types.TypeStruct<Instance>
    local bdata = {}
    bdata.size = 1

    function bdata.read(buf: buffer, cursor: Types.cursor)
        local index = u8.read(buf, cursor) + 1
        local OI = OIBridge.OI
        return OI.incoming[index]
    end

    function bdata.write(buf: buffer, cursor: Types.cursor, value: Instance)
        local OI = OIBridge.OI

        if not OI.outgoing then
            OI.outgoing = {}
        end

        local index = #OI.outgoing + 1

        u8.write(buf, cursor, index - 1)
        OI.outgoing[index] = value
    end

    return bdata
end