export type cursor = {value: number}

export type TypeStruct<T> = {
    size: number | (data: any) -> number,
    read: (buf: buffer, cursor: cursor) -> T,
    write: (buf: buffer, cursor: cursor, value: T) -> (),
}

export type EventProps<T> = {
    data: T
}

export type FunctProps<T, R> = {
    data: T,
    received: R,
}

export type StructEvent<T> = {
    Connect: (callback: (data: T, player: Player) -> ()) -> (),
    Fire: (sent: T, player: Player?) -> (),
    FireAll: (sent: T) -> (),
    FireList: (sent: T, players: {Player}) -> (),
    _TYPE: T
}

export type StructFunct<S, R> = {
    Invoke: (sent: S) -> R,
    Callback: (callback: (sent: S, player: Player?) -> R) -> (),
    _SENT: S,
    _RECEIVED: R,
}

export type DataTypes = {
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
    color3: () -> Color3,
}

export type BufNet = {
    Types: DataTypes,
    Packet: {
        event: <T> (data: EventProps<T>) -> StructEvent<T>,
        funct: <S, R> (data: FunctProps<S, R>) -> StructFunct<S, R>
    },
}

return nil