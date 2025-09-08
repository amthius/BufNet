export type cursor = {value: number}

export type TypeStruct<T> = {
    size: number | (data: any) -> number,
    read: (buf: buffer, cursor: cursor) -> T,
    write: (buf: buffer, cursor: cursor, value: T) -> (),
}

export type ChannelProps = {
    type: "Reliable" | "Unreliable",
    name: string,
}

export type Channel = {
    instance: any,
    users: {[Player]: any},
    packets: {any},
}

export type EventProps<S> = {
    channel: Channel,
    outgoing: S
}

export type FunctProps<S, R> = {
    channel: Channel,
    outgoing: S,
    incoming: R,
}

export type StructEvent<S> = {
    Connect: (self: StructEvent<S>, callback: (sent: S, player: Player) -> ()) -> (),
    Fire: (self: StructEvent<S>, sent: S, player: Player?) -> (),
    FireAll: (self: StructEvent<S>, sent: S) -> (),
    FireList: (self: StructEvent<S>, sent: S, players: {Player}) -> (),
    _SENT: S
}

export type StructFunct<S, R> = {
    Invoke: (sent: S) -> R,
    Callback: (callback: (sent: S, player: Player?) -> R) -> (),
    _SENT: S,
    _RECEIVED: R,
}

return nil