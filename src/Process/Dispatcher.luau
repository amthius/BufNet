local ReplicatedStorage = game:GetService("ReplicatedStorage")

local u8 = require(ReplicatedStorage.BufNet.DataTypes.u8)()
local Types = require(ReplicatedStorage.BufNet.Types)

local cursor = {value = 0}

return function (channel: Types.Channel, buf: buffer, player: Player?)
    cursor.value = 0
    local len = buffer.len(buf)

    while cursor.value < len do
        local id = u8.read(buf, cursor)

        local packet = channel.packets[id]
        local internal = packet._internal

        local outgoing = internal.outgoing
        local callback = internal.callback
        
        local read = outgoing.read(buf, cursor)
        callback(read, player)

    end

end
