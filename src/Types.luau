export type cursor = {value: number}

export type TypeStruct<T> = {
    size: number | (data: any) -> number,
    read: (buf: buffer, cursor: cursor) -> T,
    write: (buf: buffer, cursor: cursor, value: T) -> (),
}

type ProtocolType = "Reliable" | "Unreliable"

export type OIInstances = {
    outgoing: {[number]: Instance},
    incoming: {[number]: Instance}
}

export type ChannelProps = {
    type: ProtocolType,
    name: string,

    max_packet_process: number?,
    max_buffer_size: number?,
    invoke_lifespan: number?
}

export type Channel = {
    instance: any,
    type: ProtocolType,
    users: {[Player]: any},
    packets: {any},

    max_packet_process: number,
    max_buffer_size: number,
    invoke_lifespan: number,

    instances: OIInstances 
}

export type EventProps<O> = {
    channel: Channel,
    outgoing: O
}

export type FunctProps<O, I> = {
    channel: Channel,
    outgoing: O,
    incoming: I,
}

export type StructEvent<S> = {
    Connect: (self: StructEvent<S>, callback: (sent: S, player: Player) -> ()) -> (),
    Fire: (self: StructEvent<S>, sent: S, player: Player?) -> (),
    FireAll: (self: StructEvent<S>, sent: S) -> (),
    FireList: (self: StructEvent<S>, sent: S, players: {Player}) -> (),
    _SENT: S
}

export type StructFunct<S, R> = {
    Invoke: (self: StructFunct<S, R>, sent: S) -> R,
    Callback: (self: StructFunct<S, R>, callback: (sent: S, player: Player?) -> R) -> (),
    _SENT: S,
    _RECEIVED: R,
}

return nil