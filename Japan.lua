local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Library:CreateWindow({
    Name = "GitHub | Executor Universal Script",
    LoadingTitle = "Loading Utility...",
    LoadingSubtitle = "by Gemini",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "UniversalConfig",
        FileName = "Config"
    }
})

local Tab = Window:CreateTab("Main", 4483362458)
local Section = Tab:CreateSection("Player Hacks")

local WalkSpeed = 16
local JumpPower = 50

Tab:CreateSlider({
    Name = "WalkSpeed",
    Range = {16, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Callback = function(Value)
        WalkSpeed = Value
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,
})

Tab:CreateSlider({
    Name = "JumpPower",
    Range = {50, 500},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Callback = function(Value)
        JumpPower = Value
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,
})

Tab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(Value)
        _G.InfJump = Value
        game:GetService("UserInputService").JumpRequest:Connect(function()
            if _G.InfJump then
                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
            end
        end)
    end,
})

local Visuals = Window:CreateTab("Visuals", 4483362458)
local ESPSection = Visuals:CreateSection("ESP")

Visuals:CreateToggle({
    Name = "Player ESP",
    CurrentValue = false,
    Callback = function(Value)
        _G.ESP = Value
        while _G.ESP do
            for _, v in pairs(game.Players:GetPlayers()) do
                if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and not v.Character.Head:FindFirstChild("ESP_Tag") then
                    local b = Instance.new("BillboardGui", v.Character.Head)
                    b.Name = "ESP_Tag"
                    b.AlwaysOnTop = true
                    b.Size = UDim2.new(0, 100, 0, 50)
                    local t = Instance.new("TextLabel", b)
                    t.Size = UDim2.new(1, 0, 1, 0)
                    t.BackgroundTransparency = 1
                    t.Text = v.Name
                    t.TextColor3 = Color3.fromRGB(255, 255, 255)
                    t.TextStrokeTransparency = 0
                end
            end
            task.wait(1)
            if not _G.ESP then
                for _, v in pairs(game.Players:GetPlayers()) do
                    if v.Character and v.Character.Head:FindFirstChild("ESP_Tag") then
                        v.Character.Head.ESP_Tag:Destroy()
                    end
                end
            end
        end
    end,
})

game.Players.LocalPlayer.CharacterAdded:Connect(function(Char)
    task.wait(0.5)
    Char:WaitForChild("Humanoid").WalkSpeed = WalkSpeed
    Char:WaitForChild("Humanoid").JumpPower = JumpPower
end)

Library:Notify({
    Title = "Executed",
    Content = "Script loaded successfully from GitHub",
    Duration = 5
})
