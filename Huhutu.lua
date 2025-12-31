local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local ToggleBtn = Instance.new("TextButton")
local MinimizeBtn = Instance.new("TextButton")
local SliderBackground = Instance.new("Frame")
local SliderBar = Instance.new("Frame")
local SliderButton = Instance.new("TextButton")
local ValueDisplay = Instance.new("TextLabel")

-- GUIの設定
ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "CustomAutoClicker"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Active = true
MainFrame.Draggable = true -- ドラッグ可能

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.Text = "Super Clicker v2"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.BackgroundColor3 = Color3.fromRGB(45, 45, 45)

MinimizeBtn.Parent = MainFrame
MinimizeBtn.Position = UDim2.new(1, -30, 0, 0)
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Text = "-"
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)

ToggleBtn.Parent = MainFrame
ToggleBtn.Position = UDim2.new(0.1, 0, 0.25, 0)
ToggleBtn.Size = UDim2.new(0.8, 0, 0.3, 0)
ToggleBtn.Text = "START"
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)

-- スライダー部分
SliderBackground.Name = "SliderBackground"
SliderBackground.Parent = MainFrame
SliderBackground.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBackground.Position = UDim2.new(0.1, 0, 0.7, 0)
SliderBackground.Size = UDim2.new(0.8, 0, 0.1, 0)

SliderBar.Name = "SliderBar"
SliderBar.Parent = SliderBackground
SliderBar.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
SliderBar.Size = UDim2.new(0.5, 0, 1, 0)

SliderButton.Name = "SliderButton"
SliderButton.Parent = SliderBackground
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Position = UDim2.new(0.5, -5, -0.5, 0)
SliderButton.Size = UDim2.new(0, 10, 2, 0)
SliderButton.Text = ""

ValueDisplay.Parent = MainFrame
ValueDisplay.Position = UDim2.new(0, 0, 0.85, 0)
ValueDisplay.Size = UDim2.new(1, 0, 0, 20)
ValueDisplay.Text = "Speed: 0.05s"
ValueDisplay.TextColor3 = Color3.new(1, 1, 1)
ValueDisplay.BackgroundTransparency = 1

-- 変数
local clicking = false
local waitTime = 0.05
local minimized = false

-- スライダーのロジック
local function updateSlider()
    local mousePos = UserInputService:GetMouseLocation().X
    local btnPos = SliderBackground.AbsolutePosition.X
    local btnSize = SliderBackground.AbsoluteSize.X
    local percentage = math.clamp((mousePos - btnPos) / btnSize, 0, 1)
    
    SliderButton.Position = UDim2.new(percentage, -5, -0.5, 0)
    SliderBar.Size = UDim2.new(percentage, 0, 1, 0)
    
    -- 待機時間を 0.01秒 ~ 0.5秒 の間で調整
    waitTime = 0.01 + (percentage * 0.49)
    ValueDisplay.Text = string.format("Speed: %.2fs", waitTime)
end

local dragging = false
SliderButton.MouseButton1Down:Connect(function() dragging = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider()
    end
end)

-- 最小化
MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    MainFrame:TweenSize(minimized and UDim2.new(0, 200, 0, 30) or UDim2.new(0, 200, 0, 150), "Out", "Quad", 0.2, true)
    ToggleBtn.Visible = not minimized
    SliderBackground.Visible = not minimized
    ValueDisplay.Visible = not minimized
    MinimizeBtn.Text = minimized and "+" or "-"
end)

-- 連打実行
ToggleBtn.MouseButton1Click:Connect(function()
    clicking = not clicking
    ToggleBtn.Text = clicking and "STOP" or "START"
    ToggleBtn.BackgroundColor3 = clicking and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 150, 0)
end)

task.spawn(function()
    while true do
        if clicking then
            local tool = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
            if tool then tool:Activate() end
        end
        task.wait(waitTime)
    end
end)
