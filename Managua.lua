local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingMasterV3"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 280)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(45, 45, 45)
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "FLING GENERATOR"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -40)
Content.Position = UDim2.new(0, 0, 0, 40)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local flingMode = false
local powerValue = 10000
local grabbing = false
local grabbedPart = nil

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0.85, 0, 0, 40)
ToggleBtn.Position = UDim2.new(0.075, 0, 0.05, 0)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleBtn.Text = "MODE: OFF"
ToggleBtn.TextColor3 = Color3.new(1, 1, 1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.Parent = Content
Instance.new("UICorner", ToggleBtn)

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0.3, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "POWER: 10000"
SliderLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
SliderLabel.Font = Enum.Font.Gotham
SliderLabel.Parent = Content

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(0.8, 0, 0, 4)
SliderBG.Position = UDim2.new(0.1, 0, 0.45, 0)
SliderBG.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SliderBG.Parent = Content

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 180, 255)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBG

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0, 16, 0, 16)
SliderBtn.Position = UDim2.new(0.5, -8, 0.5, -8)
SliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
SliderBtn.Text = ""
SliderBtn.Parent = SliderBG
Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0, 7)
MinBtn.Text = "-"
MinBtn.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 7)
CloseBtn.Text = "X"
CloseBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
CloseBtn.Parent = MainFrame

ToggleBtn.MouseButton1Click:Connect(function()
	flingMode = not flingMode
	ToggleBtn.Text = flingMode and "MODE: ON" or "MODE: OFF"
	ToggleBtn.BackgroundColor3 = flingMode and Color3.fromRGB(0, 180, 80) or Color3.fromRGB(180, 50, 50)
end)

Mouse.Button1Down:Connect(function()
	if not flingMode then return end
	local target = Mouse.Target
	if target and target:IsA("BasePart") and not target.Anchored then
		grabbing = true
		grabbedPart = target
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		if grabbing and grabbedPart then
			local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if root then
				local dir = (Mouse.Hit.Position - root.Position).Unit
				grabbedPart.AssemblyLinearVelocity = (dir * powerValue) + Vector3.new(0, powerValue * 0.4, 0)
				grabbedPart.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100), 200, math.random(-100, 100))
			end
		end
		grabbing = false
		grabbedPart = nil
	end
end)

RunService.RenderStepped:Connect(function()
	if grabbing and grabbedPart and Player.Character then
		local root = Player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			local holdPos = root.Position + (root.CFrame.LookVector * 12)
			grabbedPart.AssemblyLinearVelocity = (holdPos - grabbedPart.Position) * 20
		end
	end
end)

local dragToggle, dragStart, startPos
MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragToggle = true dragStart = input.Position startPos = MainFrame.Position
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end end)

local sliding = false
local function updateSlider(input)
	local x = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
	SliderFill.Size = UDim2.new(x, 0, 1, 0)
	SliderBtn.Position = UDim2.new(x, -8, 0.5, -8)
	powerValue = math.floor(x * 50000)
	SliderLabel.Text = "POWER: " .. powerValue
end
SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true end end)
UserInputService.InputChanged:Connect(function(input) if sliding then updateSlider(input) end end)
UserInputService.InputEnded:Connect(function() sliding = false end)

MinBtn.MouseButton1Click:Connect(function()
	Content.Visible = not Content.Visible
	MainFrame:TweenSize(Content.Visible and UDim2.new(0, 260, 0, 280) or UDim2.new(0, 260, 0, 40), "Out", "Quad", 0.2, true)
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
