local Types = require(script.Parent.Parent.Types)

return function(): Types.TypeStruct<nil>
    local bdata = {}
    bdata.size = 0

    function bdata.read()
        return nil
    end

    function bdata.write()
    end

    return bdata
end