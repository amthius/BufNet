local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local Client = require(script.Parent.Parent.Runtime.Client)
local Server = require(script.Parent.Parent.Runtime.Server)
local ReferenceTables = require(script.Parent.Parent.Stored.ReferenceTables)
local Types = require(script.Parent.Parent.Types)

local PacketData = ReferenceTables.Packets
local RunContext = if RunService:IsServer() then "Server" else "Client"

local RuntimeHandlers = {
    Client = Client,
    Server = Server,
}

local Packet = {}
Packet.Stored = PacketData

local Stored = Packet.Stored

local Id = -1 

function Packet.event(data: Types.EventProps<any>)
    Id += 1
    local Id = Id

    Stored[Id] = {props = data, connections = {}}

    return {
        Connect = function(callback: (sent: any, player: Player?) -> ())
            Stored[Id].connections.callback = callback
        end,
    
        Fire = function(sent: any, player: Player?)
            local package = {Id = Id, data = data.data, sent = sent}
            RuntimeHandlers[RunContext].Deliver(package, player)
        end,
    
        FireAll = function(sent: any)
            assert(RunContext == "Server", "FireAll can only be called from the server.")

            local package = {Id = Id, data = data.data, sent = sent}

            for _, player in Players:GetPlayers() do
                RuntimeHandlers[RunContext].Deliver(package, player)
            end
        end,
    
        FireList = function(sent: any, players: {Player})
            assert(RunContext == "Server", "FireList can only be called from the server.")

            local package = {Id = Id, data = data.data, sent = sent}

            for _, player in players do
                RuntimeHandlers[RunContext].Deliver(package, player)
            end
    
        end,
    }
end

function Packet.funct(data: Types.FunctProps<any, any>)
    Id += 1
    local Id = Id

    Stored[Id] = {props = data, connections = {}, invokes = {}}

    return {

        Invoke = function(sent: any)
            assert(RunContext == "Client", "Invoke can only be called from the client")

            local package = {Id = Id, data = data.data, sent = sent}
            RuntimeHandlers[RunContext].Deliver(package)

            table.insert(Stored[Id].invokes, coroutine.running()) 
            return coroutine.yield()
        end,

        Callback = function(callback: (sent: any) -> any) 
            assert(RunContext == "Server", "Call only works on server")
            Stored[Id].connections.callback = callback
        end,

    }
end

return Packet