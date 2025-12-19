local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("map FTAP hub", "Midnight")

local Main = Window:NewTab("Main")
local PlayerSection = Main:NewSection("Player Mods")

PlayerSection:NewSlider("WalkSpeed", "Speed Hack", 500, 16, function(s)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = s
end)

PlayerSection:NewSlider("JumpPower", "Jump Hack", 500, 50, function(s)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = s
end)

PlayerSection:NewToggle("Infinite Jump", "Inf Jump", function(state)
    _G.InfJump = state
    game:GetService("UserInputService").JumpRequest:Connect(function()
        if _G.InfJump then
            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
        end
    end)
end)

PlayerSection:NewToggle("Fly", "Flight Mode", function(state)
    _G.FlyEnabled = state
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")
    if _G.FlyEnabled then
        local bodyVel = Instance.new("BodyVelocity", hrp)
        bodyVel.Name = "FlyVel"
        bodyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while _G.FlyEnabled do
                local camCFrame = workspace.CurrentCamera.CFrame
                local moveDir = Vector3.new(0, 0, 0)
                local uis = game:GetService("UserInputService")
                if uis:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camCFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camCFrame.LookVector end
                if uis:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - camCFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + camCFrame.RightVector end
                bodyVel.Velocity = moveDir * 100
                task.wait()
            end
            if hrp:FindFirstChild("FlyVel") then hrp.FlyVel:Destroy() end
        end)
    end
end)

local ESPTab = Window:NewTab("ESP")
local ESPSection = ESPTab:NewSection("Visuals")

ESPSection:NewToggle("Player ESP", "Show Players", function(state)
    _G.ESP = state
    while _G.ESP do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v ~= game.Players.LocalPlayer and v.Character and not v.Character:FindFirstChild("Highlight") then
                local hl = Instance.new("Highlight", v.Character)
                hl.FillColor = Color3.fromRGB(255, 255, 0)
            end
        end
        task.wait(1)
        if not _G.ESP then
            for _, v in pairs(game.Players:GetPlayers()) do
                if v.Character and v.Character:FindFirstChild("Highlight") then
                    v.Character.Highlight:Destroy()
                end
            end
        end
    end
end)

local AVTab = Window:NewTab("Anti-Void")
local AVSection = AVTab:NewSection("Protection")

AVSection:NewToggle("Enable Anti-Void", "Fall Save", function(state)
    _G.AntiVoid = state
    game:GetService("RunService").Heartbeat:Connect(function()
        if _G.AntiVoid and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            if game.Players.LocalPlayer.Character.HumanoidRootPart.Position.Y < -50 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(0, 20, 0)
                game.Players.LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
end)

local Troll = Window:NewTab("Troll")
local TrollSection = Troll:NewSection("Fling All")

TrollSection:NewButton("Fling All Players", "Launch Everyone", function()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            task.spawn(function()
                local t = tick()
                while tick() - t < 3 do
                    hrp.Velocity = Vector3.new(0, 5000, 0)
                    hrp.RotVelocity = Vector3.new(5000, 5000, 5000)
                    task.wait()
                end
            end)
        end
    end
end)

local Settings = Window:NewTab("Settings")
local SetSection = Settings:NewSection("Controls")

SetSection:NewKeybind("Toggle UI", "Open/Close", Enum.KeyCode.RightControl, function()
    Library:ToggleUI()
end)

SetSection:NewButton("Destroy Hub", "警告: 終了しますか？", function()
    local Notification = Library:Notification("警告", "本当にHubを終了しますか？", "はい", "いいえ", function(val)
        if val then
            game:GetService("CoreGui"):FindFirstChild("map FTAP hub"):Destroy()
        end
    end)
end)
