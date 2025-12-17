local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 120)
Frame.Position = UDim2.new(0, 20, 0.5, -60) -- 画面左側に寄せる
Frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
Frame.Active = true
Frame.Draggable = true
Frame.Parent = ScreenGui

local ToggleButton = Instance.new("TextButton")
ToggleButton.Size = UDim2.new(0, 150, 0, 60)
ToggleButton.Position = UDim2.new(0, 50, 0, 30)
ToggleButton.Text = "OFF"
ToggleButton.TextScaled = true
ToggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
ToggleButton.Parent = Frame

local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
MinimizeButton.Position = UDim2.new(0, 210, 0, 0)
MinimizeButton.Text = "_"
MinimizeButton.TextScaled = true
MinimizeButton.Parent = Frame

local noclip = false
ToggleButton.MouseButton1Click:Connect(function()
    noclip = not noclip
    if noclip then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(0,255,0)
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(255,0,0)
    end
end)

MinimizeButton.MouseButton1Click:Connect(function()
    Frame.Size = Frame.Size == UDim2.new(0,250,0,120) and UDim2.new(0,250,0,40) or UDim2.new(0,250,0,120)
end)

RunService.RenderStepped:Connect(function()
    if noclip then
        if Humanoid then
            Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        end
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)
