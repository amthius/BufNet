--!native
local RunService = game:GetService("RunService")

local u8 = require(script.Parent.Parent.DataTypes.u8)()
local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)

local PacketData = ReferenceTables.Packets

return function(buf: buffer, player: Player?) 
    local retrieved = {}

    local cursor = {value = 0}
    local len = buffer.len(buf)

    while cursor.value < len do
        local id = u8.read(buf, cursor)

        local packet = PacketData[id]
        local data
        local send

        if not packet.props.received then
            data = packet.props.data
            send = data
        else
            if RunService:IsServer() then
                data = packet.props.data
                send = packet.props.received
            else
                data = packet.props.received
            end
        end

        local read = data.read(buf, cursor)
        local invokes = packet.invokes

        if invokes then
            for i = 1, #invokes do
                task.spawn(invokes[1], read)
                table.remove(invokes, 1)
            end
        end

        for _, callback in packet.connections do
            local returned = callback(read, player)
            if not invokes then continue end

            table.insert(retrieved, {
                Id = id,
                data = send,
                sent = returned
            })
        end
        
    end

    return if #retrieved == 0 then nil else retrieved
end