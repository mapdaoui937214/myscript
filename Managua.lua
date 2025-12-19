local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")
local Mouse = Player:GetMouse()

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlingFollowUltra"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 280, 0, 300)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(50, 50, 50)
UIStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundTransparency = 1
Title.Text = "ULTIMATE CONTROL"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -45)
Content.Position = UDim2.new(0, 0, 0, 45)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local flingActive = false
local followActive = false
local powerValue = 5000
local followTarget = nil

local function CreateButton(name, pos, color, text)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0.85, 0, 0, 45)
	btn.Position = pos
	btn.BackgroundColor3 = color
	btn.Text = text
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.GothamBold
	btn.TextSize = 14
	btn.AutoButtonColor = true
	btn.Parent = Content
	Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
	return btn
end

local FlingToggle = CreateButton("FlingToggle", UDim2.new(0.075, 0, 0.05, 0), Color3.fromRGB(180, 60, 60), "FLING MODE: OFF")
local FollowToggle = CreateButton("FollowToggle", UDim2.new(0.075, 0, 0.25, 0), Color3.fromRGB(60, 60, 60), "FOLLOW: OFF")

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20)
SliderLabel.Position = UDim2.new(0, 0, 0.5, 0)
SliderLabel.BackgroundTransparency = 1
SliderLabel.Text = "POWER: 5000"
SliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
SliderLabel.Font = Enum.Font.GothamMedium
SliderLabel.TextSize = 14
SliderLabel.Parent = Content

local SliderBG = Instance.new("Frame")
SliderBG.Size = UDim2.new(0.8, 0, 0, 6)
SliderBG.Position = UDim2.new(0.1, 0, 0.65, 0)
SliderBG.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
SliderBG.Parent = Content
Instance.new("UICorner", SliderBG)

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new(0.5, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
SliderFill.Parent = SliderBG
Instance.new("UICorner", SliderFill)

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(0, 18, 0, 18)
SliderBtn.Position = UDim2.new(0.5, -9, 0.5, -9)
SliderBtn.BackgroundColor3 = Color3.new(1, 1, 1)
SliderBtn.Text = ""
SliderBtn.Parent = SliderBG
Instance.new("UICorner", SliderBtn).CornerRadius = UDim.new(1, 0)

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -65, 0, 10)
MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.Parent = MainFrame
Instance.new("UICorner", MinBtn)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -35, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn)

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

FlingToggle.MouseButton1Click:Connect(function()
	flingActive = not flingActive
	FlingToggle.Text = flingActive and "FLING MODE: ON" or "FLING MODE: OFF"
	FlingToggle.BackgroundColor3 = flingActive and Color3.fromRGB(0, 160, 80) or Color3.fromRGB(180, 60, 60)
end)

FollowToggle.MouseButton1Click:Connect(function()
	followActive = not followActive
	if not followActive then
		followTarget = nil
		FollowToggle.Text = "FOLLOW: OFF"
		FollowToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	else
		FollowToggle.Text = "CLICK A TARGET"
		FollowToggle.BackgroundColor3 = Color3.fromRGB(200, 140, 0)
	end
end)

Mouse.Button1Down:Connect(function()
	local target = Mouse.Target
	if not target then return end
	if followActive and FollowToggle.Text == "CLICK A TARGET" then
		if target.Parent:FindFirstChild("Humanoid") then
			followTarget = target.Parent:FindFirstChild("HumanoidRootPart")
			FollowToggle.Text = "FOLLOWING: " .. target.Parent.Name
			FollowToggle.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
		end
	elseif flingActive and target:IsA("BasePart") and not target.Anchored then
		target.AssemblyLinearVelocity = Vector3.new(0, powerValue, 0) + (Player.Character.HumanoidRootPart.CFrame.LookVector * powerValue)
		target.AssemblyAngularVelocity = Vector3.new(math.random(-100, 100), 200, math.random(-100, 100))
	end
end)

RunService.RenderStepped:Connect(function()
	if followActive and followTarget and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
		local hrp = Player.Character.HumanoidRootPart
		local targetPos = followTarget.Position + (followTarget.CFrame.LookVector * -6)
		hrp.CFrame = CFrame.new(hrp.Position:Lerp(targetPos, 0.15), followTarget.Position)
	end
end)

local sliding = false
local function updateSlider(input)
	local x = math.clamp((input.Position.X - SliderBG.AbsolutePosition.X) / SliderBG.AbsoluteSize.X, 0, 1)
	SliderFill.Size = UDim2.new(x, 0, 1, 0)
	SliderBtn.Position = UDim2.new(x, -9, 0.5, -9)
	powerValue = math.floor(x * 15000)
	SliderLabel.Text = "POWER: " .. powerValue
end
SliderBtn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true end end)
UserInputService.InputChanged:Connect(function(input) if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end end)
UserInputService.InputEnded:Connect(function() sliding = false end)

MinBtn.MouseButton1Click:Connect(function()
	Content.Visible = not Content.Visible
	MainFrame:TweenSize(Content.Visible and UDim2.new(0, 280, 0, 300) or UDim2.new(0, 280, 0, 45), "Out", "Quart", 0.3, true)
end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
