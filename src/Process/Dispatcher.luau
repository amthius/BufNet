local RunService = game:GetService("RunService")

local u8 = require(script.Parent.Parent.DataTypes.u8)()
local Types = require(script.Parent.Parent.Types)

local RunContext = if RunService:IsServer() then "Server" else "Client"

return function(channel: Types.Channel, buf: buffer, player: Player?)
	local cursor = {value = 0}
	local returned = {}
	
	local len = buffer.len(buf)
	local pamount = 0 

	while cursor.value < len do
        pamount += 1

        if pamount > channel.max_packet_process then
            break
        end

		local id = u8.read(buf, cursor)

		local packet = channel.packets[id]
		if not packet then continue end
		
		local identity = packet.Identifier
		local internal = packet._internal
		local outgoing = internal.outgoing
		local incoming = internal.incoming
		local callback = internal.callback
		
		local payload = {
			id = id,
			outgoing = incoming,
		}

		if identity == "Funct" then
				
            local read
            if RunContext == "Server" then
                if not callback then continue end

				read = outgoing.read(buf, cursor)
				payload.sent = callback(read, player)
				
				table.insert(returned, payload)
            elseif RunContext == "Client" then
				read = incoming.read(buf, cursor)
				payload.sent = read
		
                table.insert(returned, payload)

                local invokes = packet._internal.invokes

                if invokes[1] then
                    task.spawn(invokes[1].thread, read)
                    table.remove(invokes, 1)
                end
                
            end

        elseif identity == "Event" then
			local read = outgoing.read(buf, cursor)

            if callback then
				callback(read, player)
            end
		end
	end

	return if #returned == 0 then nil else returned
end