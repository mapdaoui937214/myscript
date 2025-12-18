local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapHub"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 200, 0, 200)
Main.Position = UDim2.new(0.5, -100, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 10)
Corner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
Title.Text = "MapHub"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main
local TCorner = Instance.new("UICorner")
TCorner.Parent = Title

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.85, 0, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = Main

local function createToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Main
    local bCorner = Instance.new("UICorner")
    bCorner.Parent = btn

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(50, 180, 50) or Color3.fromRGB(180, 50, 50)
        callback(state)
    end)
end

local flying = false
local infJump = false

createToggle("Fly", UDim2.new(0.1, 0, 0.25, 0), function(s)
    flying = s
    local char = player.Character
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "MapFly"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        task.spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * 50
                task.wait()
            end
            bv:Destroy()
        end)
    end
end)

createToggle("Inf Jump", UDim2.new(0.1, 0, 0.55, 0), function(s)
    infJump = s
end)

UIS.JumpRequest:Connect(function()
    if infJump then
        player.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
    end
end)

local min = false
MinBtn.MouseButton1Click:Connect(function()
    min = not min
    Main:TweenSize(min and UDim2.new(0, 200, 0, 40) or UDim2.new(0, 200, 0, 200), "Out", "Quad", 0.3, true)
    MinBtn.Text = min and "+" or "-"
end)
