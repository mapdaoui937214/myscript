local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

if CoreGui:FindFirstChild("UniversalVoidGUI") then
    CoreGui.UniversalVoidGUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalVoidGUI"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local function createCorner(parent)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = parent
end

local WarningFrame = Instance.new("Frame")
WarningFrame.Size = UDim2.new(0, 320, 0, 180)
WarningFrame.Position = UDim2.new(0.5, -160, 0.5, -90)
WarningFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WarningFrame.BorderSizePixel = 0
WarningFrame.Parent = ScreenGui
createCorner(WarningFrame)

local WTitle = Instance.new("TextLabel")
WTitle.Size = UDim2.new(1, 0, 0, 40)
WTitle.Text = "SYSTEM WARNING"
WTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
WTitle.BackgroundTransparency = 1
WTitle.TextSize = 20
WTitle.Font = Enum.Font.GothamBold
WTitle.Parent = WarningFrame

local WMsg = Instance.new("TextLabel")
WMsg.Size = UDim2.new(0.9, 0, 0.4, 0)
WMsg.Position = UDim2.new(0.05, 0, 0.25, 0)
WMsg.Text = "全プレイヤーを奈落へ転送します。\nこの操作は同期されます。実行しますか？"
WMsg.TextColor3 = Color3.new(1, 1, 1)
WMsg.BackgroundTransparency = 1
WMsg.TextSize = 14
WMsg.TextWrapped = true
WMsg.Font = Enum.Font.Gotham
WMsg.Parent = WarningFrame

local AcceptBtn = Instance.new("TextButton")
AcceptBtn.Size = UDim2.new(0.4, 0, 0, 35)
AcceptBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
AcceptBtn.Text = "実行"
AcceptBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
AcceptBtn.TextColor3 = Color3.new(1, 1, 1)
AcceptBtn.Parent = WarningFrame
createCorner(AcceptBtn)

local CancelBtn = Instance.new("TextButton")
CancelBtn.Size = UDim2.new(0.4, 0, 0, 35)
CancelBtn.Position = UDim2.new(0.55, 0, 0.75, 0)
CancelBtn.Text = "キャンセル"
CancelBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
CancelBtn.TextColor3 = Color3.new(1, 1, 1)
CancelBtn.Parent = WarningFrame
createCorner(CancelBtn)

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
createCorner(MainFrame)

local TitleBar = Instance.new("TextLabel")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.Text = "Void Controller v1.0"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
TitleBar.Parent = MainFrame
createCorner(TitleBar)

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 45)
ToggleBtn.Position = UDim2.new(0.05, 0, 0.3, 0)
ToggleBtn.Text = "Drop Status: IDLE"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = MainFrame
createCorner(ToggleBtn)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0.42, 0, 0, 30)
MinBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
MinBtn.Text = "最小化"
MinBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = MainFrame
createCorner(MinBtn)

local ExitBtn = Instance.new("TextButton")
ExitBtn.Size = UDim2.new(0.42, 0, 0, 30)
ExitBtn.Position = UDim2.new(0.53, 0, 0.75, 0)
ExitBtn.Text = "完全終了"
ExitBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
ExitBtn.TextColor3 = Color3.new(1, 1, 1)
ExitBtn.Parent = MainFrame
createCorner(ExitBtn)

local isDropping = false
local voidPart = nil
local loopConnection = nil

local function toggle()
    isDropping = not isDropping
    if isDropping then
        ToggleBtn.Text = "DROP ACTIVE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        
        voidPart = Instance.new("Part")
        voidPart.Name = "DeathVoid"
        voidPart.Size = Vector3.new(2048, 2, 2048)
        voidPart.Anchored = true
        voidPart.CanCollide = true
        voidPart.Transparency = 0.5
        voidPart.Color = Color3.new(0, 0, 0)
        voidPart.Position = Players.LocalPlayer.Character.HumanoidRootPart.Position - Vector3.new(0, 50, 0)
        voidPart.Parent = workspace

        loopConnection = RunService.Heartbeat:Connect(function()
            if voidPart then
                voidPart.Position = voidPart.Position - Vector3.new(0, 1.5, 0)
                for _, p in pairs(Players:GetPlayers()) do
                    if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        p.Character.HumanoidRootPart.CFrame = voidPart.CFrame * CFrame.new(0, 4, 0)
                    end
                end
            end
        end)
    else
        ToggleBtn.Text = "Drop Status: IDLE"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        if loopConnection then loopConnection:Disconnect() end
        if voidPart then voidPart:Destroy() end
    end
end

AcceptBtn.MouseButton1Click:Connect(function()
    WarningFrame.Visible = false
    MainFrame.Visible = true
end)

CancelBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
ToggleBtn.MouseButton1Click:Connect(toggle)

MinBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset > 40 then
        MainFrame.Size = UDim2.new(0, 220, 0, 30)
        ToggleBtn.Visible = false
        MinBtn.Text = "展開"
    else
        MainFrame.Size = UDim2.new(0, 220, 0, 160)
        ToggleBtn.Visible = true
        MinBtn.Text = "最小化"
    end
end)

ExitBtn.MouseButton1Click:Connect(function()
    isDropping = false
    if loopConnection then loopConnection:Disconnect() end
    if voidPart then voidPart:Destroy() end
    ScreenGui:Destroy()
end)
