-- Server

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BufRepository = require(ReplicatedStorage.BufRepository)

BufRepository.SomeEvent.Connect(function(data, player)
    print(data, player)
end)

-- basic cooldown example to handle spam
local cooldown = {}
BufRepository.NothingEvent.Connect(function(_, player)
    if not cooldown[player] then
        cooldown[player] = true

        task.delay(1, function()
            cooldown[player] = nil
        end)
    else
        return
    end

    print(`{player} is calling event`)
end)

BufRepository.SomeFunction.Callback(function(data, player)
    warn(player, "called SomeFunction")

    if data then
        return "The result is true!"
    else
        return "The result is false!"
    end
end)

Players.PlayerAdded:Connect(function(player)
    BufRepository.SomeEvent.Fire({
        LargeTypes = {
            vec2 = Vector2.new(0, 0.5),
            vec3 = Vector3.new(100, 123.2345, 11),
            cframe = CFrame.new(1010.3, 5, 10) * CFrame.Angles(0, math.rad(22), 0),
            color3 = Color3.fromRGB(147, 28, 216)
        },
    
        SomeArray = {
            true,
        },
    
    }, player)
end)
