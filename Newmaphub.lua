local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local Config = {
    HubName = "New Map Hub",
    Keys = {"maphub", "Maphub"},
    DefaultSpeed = 16,
    DefaultJump = 50,
    FlySpeed = 50
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NewMapHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local function CreateRoundedFrame(parent, size, pos, color)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = color
    frame.BorderSizePixel = 0
    frame.Parent = parent
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    return frame
end

local MainFrame = CreateRoundedFrame(ScreenGui, UDim2.new(0, 300, 0, 350), UDim2.new(0.5, -150, 0.5, -175), Color3.fromRGB(30, 30, 30))
MainFrame.Active = true
MainFrame.Draggable = true

local MinButton = Instance.new("TextButton")
MinButton.Size = UDim2.new(0, 50, 0, 50)
MinButton.Position = UDim2.new(0, 20, 0.8, 0)
MinButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MinButton.Text = "MH"
MinButton.TextColor3 = Color3.new(1, 1, 1)
MinButton.Visible = false
MinButton.Parent = ScreenGui
local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(1, 0)
MinCorner.Parent = MinButton
MinButton.Active = true
MinButton.Draggable = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Text = Config.HubName
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local function CreateSlider(name, pos, min, max, default, callback)
    local label = Instance.new("TextLabel")
    label.Text = name .. ": " .. default
    label.Size = UDim2.new(0.8, 0, 0, 20)
    label.Position = pos
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Parent = MainFrame

    local bg = Instance.new("Frame")
    bg.Size = UDim2.new(0.8, 0, 0, 10)
    bg.Position = pos + UDim2.new(0, 0, 0, 25)
    bg.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bg.Parent = MainFrame
    
    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
    fill.BorderSizePixel = 0
    fill.Parent = bg

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = bg

    btn.MouseButton1Down:Connect(function()
        local connection
        connection = RunService.RenderStepped:Connect(function()
            local mousePos = UserInputService:GetMouseLocation().X
            local relativeX = math.clamp((mousePos - bg.AbsolutePosition.X) / bg.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            local val = math.floor(min + (relativeX * (max - min)))
            label.Text = name .. ": " .. val
            callback(val)
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if connection then connection:Disconnect() end
            end
        end)
    end)
end

CreateSlider("Speed", UDim2.new(0.1, 0, 0.2, 0), 16, 200, 16, function(v)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = v
    end
end)

CreateSlider("Jump", UDim2.new(0.1, 0, 0.4, 0), 50, 300, 50, function(v)
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.JumpPower = v
        Player.Character.Humanoid.UseJumpPower = true
    end
end)

local FlyBtn = Instance.new("TextButton")
FlyBtn.Size = UDim2.new(0.8, 0, 0, 30)
FlyBtn.Position = UDim2.new(0.1, 0, 0.65, 0)
FlyBtn.Text = "Toggle Fly"
FlyBtn.Parent = MainFrame

local flying = false
FlyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        local bv = Instance.new("BodyVelocity")
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Parent = Player.Character.HumanoidRootPart
        
        spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * Config.FlySpeed
                wait()
            end
            bv:Destroy()
        end)
    end
end)

local MinMainBtn = Instance.new("TextButton")
MinMainBtn.Text = "_"
MinMainBtn.Size = UDim2.new(0, 30, 0, 30)
MinMainBtn.Position = UDim2.new(1, -35, 0, 5)
MinMainBtn.Parent = MainFrame
MinMainBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinButton.Visible = true
end)

MinButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    MinButton.Visible = false
end)

local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(0.8, 0, 0, 30)
CancelBtn.Position = UDim2.new(0.1, 0, 0.85, 0)
CancelBtn.Text = "Cancel Hub"
CancelBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CancelBtn.Parent = MainFrame
CancelBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Key System
MainFrame.Visible = false
local KeyFrame = CreateRoundedFrame(ScreenGui, UDim2.new(0, 250, 0, 150), UDim2.new(0.5, -125, 0.5, -75), Color3.fromRGB(40, 40, 40))
local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0.8, 0, 0, 30)
KeyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.Parent = KeyFrame

local KeyBtn = Instance.new("TextButton")
KeyBtn.Size = UDim2.new(0.8, 0, 0, 30)
KeyBtn.Position = UDim2.new(0.1, 0, 0.6, 0)
KeyBtn.Text = "Verify"
KeyBtn.Parent = KeyFrame
KeyBtn.MouseButton1Click:Connect(function()
    for _, k in pairs(Config.Keys) do
        if KeyInput.Text == k then
            KeyFrame:Destroy()
            MainFrame.Visible = true
            return
        end
    end
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Invalid Key!"
end)
