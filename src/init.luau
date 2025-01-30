local RunService = game:GetService("RunService")

local Packet = require(script.Process.Packet)
local Client = require(script.Runtime.Client)
local Server = require(script.Runtime.Server)
local Types = require(script.Types)

local DataTypes = {
    bool = require(script.DataTypes.bool),
    f32 = require(script.DataTypes.f32),
    f64 = require(script.DataTypes.f64),
    i16 = require(script.DataTypes.i16),
    i32 = require(script.DataTypes.i32),
    i8 = require(script.DataTypes.i8),
    optional = require(script.DataTypes.optional),
    string = require(script.DataTypes.string),
    struct = require(script.DataTypes.struct),
    u16 = require(script.DataTypes.u16),
    u32 = require(script.DataTypes.u32),
    u8 = require(script.DataTypes.u8),
    none = require(script.DataTypes.none),
    instance = require(script.DataTypes.instance),
    array = require(script.DataTypes.array),
    map = require(script.DataTypes.map),
    vec3 = require(script.DataTypes.vec3),
    vec2 = require(script.DataTypes.vec2),
    cframe = require(script.DataTypes.cframe),
    color3 = require(script.DataTypes.color3),
}

if RunService:IsServer() then
    Server.Start()
else
    Client.Start()
end

return ({
    Types = DataTypes,
    Packet = Packet
} :: any) :: Types.BufNet