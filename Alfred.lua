local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Name = "StableSpinGui"
ScreenGui.Parent = game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
MainFrame.Size = UDim2.new(0, 160, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true

local MainCorner = UICorner:Clone()
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

Title.Name = "Title"
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Font = Enum.Font.GothamBold
Title.Text = "Spin Fling (5000)"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13

local TitleCorner = UICorner:Clone()
TitleCorner.Parent = Title

MinimizeButton.Name = "MinimizeButton"
MinimizeButton.Parent = MainFrame
MinimizeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
MinimizeButton.Position = UDim2.new(1, -25, 0, 2)
MinimizeButton.Size = UDim2.new(0, 20, 0, 20)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)

ToggleButton.Name = "ToggleButton"
ToggleButton.Parent = MainFrame
ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
ToggleButton.Position = UDim2.new(0, 10, 0, 45)
ToggleButton.Size = UDim2.new(0, 140, 0, 50)
ToggleButton.Font = Enum.Font.GothamSemibold
ToggleButton.Text = "SPIN: OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 16

local ButtonCorner = UICorner:Clone()
ButtonCorner.Parent = ToggleButton

local spinning = false
local minified = false
local lp = game.Players.LocalPlayer

MinimizeButton.MouseButton1Click:Connect(function()
    minified = not minified
    if minified then
        ToggleButton.Visible = false
        MainFrame.Size = UDim2.new(0, 160, 0, 30)
        MinimizeButton.Text = "+"
    else
        ToggleButton.Visible = true
        MainFrame.Size = UDim2.new(0, 160, 0, 110)
        MinimizeButton.Text = "-"
    end
end)

ToggleButton.MouseButton1Click:Connect(function()
    spinning = not spinning
    local char = lp.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    
    if spinning then
        ToggleButton.Text = "SPIN: ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(180, 60, 60)
        
        local bAV = Instance.new("BodyAngularVelocity")
        bAV.Name = "FlingSpin"
        bAV.Parent = hrp
        bAV.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        bAV.AngularVelocity = Vector3.new(0, 5000, 0) -- 5000に調整
        
        local bV = Instance.new("BodyVelocity")
        bV.Name = "FlingFloat"
        bV.Parent = hrp
        bV.Velocity = Vector3.new(0, 0.1, 0)
        bV.MaxForce = Vector3.new(0, math.huge, 0)
    else
        ToggleButton.Text = "SPIN: OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
        
        if hrp then
            if hrp:FindFirstChild("FlingSpin") then hrp.FlingSpin:Destroy() end
            if hrp:FindFirstChild("FlingFloat") then hrp.FlingFloat:Destroy() end
        end
    end
end)

lp.CharacterAdded:Connect(function()
    spinning = false
    ToggleButton.Text = "SPIN: OFF"
    ToggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 60)
end)
