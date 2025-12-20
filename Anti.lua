local ITEM_NAME = "otaku"
local FLING_SPEED = 999999
local VOID_DEPTH = -1000
local RANGE = 10

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
sg.Name = "GlobalVoidSystem"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 200, 0, 100)
frame.Position = UDim2.new(0.5, -100, 0.8, -50)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local corner = Instance.new("UICorner", frame)

local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(1, -20, 1, -20)
toggle.Position = UDim2.new(0, 10, 0, 10)
toggle.BackgroundColor3 = Color3.fromRGB(40, 0, 0)
toggle.Text = "AUTO VOID: OFF"
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 14
Instance.new("UICorner", toggle)

local isRunning = false

local function doAdvancedFling(targetChar)
    local hrp = targetChar:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local item = nil
    for _, v in pairs(game.Workspace:GetDescendants()) do
        if v.Name == ITEM_NAME and (v:IsA("Tool") or v:IsA("Part")) then
            item = v
            break
        end
    end

    if item then
        hrp.CFrame = (item:IsA("Tool") and (item:FindFirstChild("Handle") or item).CFrame) or item.CFrame
        task.wait(0.03)
    end

    local bv = Instance.new("BodyVelocity", hrp)
    bv.Velocity = Vector3.new(0, 5000, 0)
    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    
    local bav = Instance.new("BodyAngularVelocity", hrp)
    bav.AngularVelocity = Vector3.new(FLING_SPEED, FLING_SPEED, FLING_SPEED)
    bav.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bav.P = 1500000

    task.wait(0.05)
    hrp.CFrame = CFrame.new(hrp.Position.X, VOID_DEPTH, hrp.Position.Z)
    
    task.wait(0.2)
    bv:Destroy()
    bav:Destroy()
end

RunService.Heartbeat:Connect(function()
    if not isRunning then return end
    local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not myRoot then return end

    for _, other in pairs(Players:GetPlayers()) do
        if other ~= player and other.Character then
            local oRoot = other.Character:FindFirstChild("HumanoidRootPart")
            local oHum = other.Character:FindFirstChild("Humanoid")
            if oRoot and oHum and oHum.Health > 0 then
                if (myRoot.Position - oRoot.Position).Magnitude <= RANGE then
                    doAdvancedFling(other.Character)
                end
            end
        end
    end
end)

toggle.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    toggle.Text = isRunning and "AUTO VOID: ON" or "AUTO VOID: OFF"
    toggle.BackgroundColor3 = isRunning and Color3.fromRGB(0, 100, 0) or Color3.fromRGB(100, 0, 0)
end)
