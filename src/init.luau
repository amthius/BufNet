local RunService = game:GetService("RunService")

local Channel = require(script.Channel)
local array = require(script.DataTypes.array)
local bool = require(script.DataTypes.bool)
local cframe = require(script.DataTypes.cframe)
local color3 = require(script.DataTypes.color3)
local f32 = require(script.DataTypes.f32)
local f64 = require(script.DataTypes.f64)
local i16 = require(script.DataTypes.i16)
local i32 = require(script.DataTypes.i32)
local i8 = require(script.DataTypes.i8)
local instance = require(script.DataTypes.instance)
local map = require(script.DataTypes.map)
local none = require(script.DataTypes.none)
local optional = require(script.DataTypes.optional)
local string = require(script.DataTypes.string)
local struct = require(script.DataTypes.struct)
local u16 = require(script.DataTypes.u16)
local u32 = require(script.DataTypes.u32)
local u8 = require(script.DataTypes.u8)
local vec2 = require(script.DataTypes.vec2)
local vec3 = require(script.DataTypes.vec3)
local Packet = require(script.Packet)

if RunService:IsServer() then
    require(script.RunTime.Server).start()
else
    require(script.RunTime.Client).start()
end

return table.freeze({
    Channel = Channel,
    Packet = Packet,
    Types = ({
        array = array,
        bool = bool,
        cframe = cframe,
        color3 = color3,
        f32 = f32,
        f64 = f64,
        i16 = i16,
        i32 = i32,
        i8 = i8,
        map =  map,
        none = none,
        optional = optional,
        string = string,
        struct = struct,
        u16 = u16,
        u32 = u32,
        u8 = u8,
        vec2 = vec2,
        vec3 = vec3,
        instance = instance
    } :: any) :: {
        bool: () -> boolean,
        f32: () -> number,
        f64: () -> number,
        i16: () -> number,
        i32: () -> number,
        i8: () -> number,
        optional: <T>(data: T) -> T?,
        string: (data: number?) -> string,
        struct: <T>(data: T) -> T,
        u16: () -> number,
        u32: () -> number,
        u8: () -> number,
        none: () -> nil,
        instance: () -> Instance,
        array: <T, S>(data: T, size: S?) -> {[number]: T},
        map: <I, V, S>(index: I, value: V, size: S?) -> {[I]: V},
        vec3: () -> Vector3,
        vec2: () -> Vector2,
        cframe: () -> CFrame,
        color3: () -> Color3
    }
})