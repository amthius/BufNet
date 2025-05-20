-- Client

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BufRepository = require(ReplicatedStorage.BufRepository)

BufRepository.SomeEvent.Fire({
    LargeTypes = {
        vec2 = Vector2.new(1, 5),
        vec3 = Vector3.new(1, 0.5, 10),
        cframe = CFrame.new(10, 5, 10) * CFrame.Angles(0, math.rad(45), 0),
        color3 = Color3.fromRGB(202, 154, 22)
    },

    SomeArray = {
        true,
        false,
        true,
        false,
    },

    Something = Color3.fromRGB(255, 0, 0)
})

BufRepository.SomeEvent.Connect(function(data)
    print(data)
end)

local result = BufRepository.SomeFunction.Invoke(true)
print(result)

-- Hit packet limit.
for i = 1, 40001 do
    BufRepository.NothingEvent.Fire()
end

task.wait(2)

-- Extreme Spam
game:GetService("RunService").Heartbeat:Connect(function()
    for i = 1, 100 do
        BufRepository.NothingEvent.Fire()
    end
end)
