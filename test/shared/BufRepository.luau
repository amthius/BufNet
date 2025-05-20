local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BufNet = require(ReplicatedStorage.BufNet)
local Types = BufNet.Types

return {
    SomeEvent = BufNet.Packet.event({
        data = Types.struct({

             LargeTypes = Types.struct({
                vec2 = Types.vec2(),
                vec3 = Types.vec3(),
                cframe = Types.cframe(),
                color3 = Types.color3()
            }),

            SomeArray = Types.array(Types.bool(), Types.u16()),
            Something = Types.optional(Types.color3()),
         
        })
    }),

    SomeFunction = BufNet.Packet.funct({
        data = Types.bool(),
        received = Types.string()
    }),

    NothingEvent = BufNet.Packet.event({
        data = Types.none()
    }),
}