-- ===== Advanced Mobile Fly Script with Draggable Speed Slider =====
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")

-- Fly settings
local flying = false
local speed = 50

-- Body objects
local bodyGyro = Instance.new("BodyGyro")
bodyGyro.P = 9e4
bodyGyro.Parent = hrp

local bodyVel = Instance.new("BodyVelocity")
bodyVel.MaxForce = Vector3.new(9e9, 9e9, 9e9)
bodyVel.Velocity = Vector3.zero
bodyVel.Parent = hrp

humanoid.PlatformStand = false

-- ===== GUI Setup =====
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Fly ON/OFF Button
local flyBtn = Instance.new("TextButton")
flyBtn.Size = UDim2.new(0,100,0,50)
flyBtn.Position = UDim2.new(0.05,0,0.8,0)
flyBtn.Text = "Fly OFF"
flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
flyBtn.TextScaled = true
flyBtn.Parent = screenGui

-- Speed Slider Background
local sliderBG = Instance.new("Frame")
sliderBG.Size = UDim2.new(0,200,0,30)
sliderBG.Position = UDim2.new(0.05,0,0.7,0)
sliderBG.BackgroundColor3 = Color3.fromRGB(100,100,100)
sliderBG.Parent = screenGui

-- Slider Knob
local knob = Instance.new("Frame")
knob.Size = UDim2.new(0,20,0,30)
knob.Position = UDim2.new(0, (speed/200)*180,0,0) -- 初期位置
knob.BackgroundColor3 = Color3.fromRGB(0,255,0)
knob.Parent = sliderBG

-- Speed Label
local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1,0,1,0)
speedLabel.Position = UDim2.new(0,0,0,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..speed
speedLabel.TextScaled = true
speedLabel.TextColor3 = Color3.fromRGB(255,255,255)
speedLabel.Parent = sliderBG

local UIS = game:GetService("UserInputService")
local dragging = false

-- Drag logic
knob.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
	end
end)

knob.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
		local x = math.clamp(input.Position.X - sliderBG.AbsolutePosition.X - knob.AbsoluteSize.X/2,0,sliderBG.AbsoluteSize.X - knob.AbsoluteSize.X)
		knob.Position = UDim2.new(0,x,0,0)
		speed = math.floor((x/(sliderBG.AbsoluteSize.X - knob.AbsoluteSize.X))*200)
		speedLabel.Text = "Speed: "..speed
	end
end)

-- Fly toggle
flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyBtn.Text = "Fly ON"
		flyBtn.BackgroundColor3 = Color3.fromRGB(0,255,0)
	else
		flyBtn.Text = "Fly OFF"
		flyBtn.BackgroundColor3 = Color3.fromRGB(255,0,0)
		bodyVel.Velocity = Vector3.zero
	end
end)

-- ===== Fly Loop =====
game:GetService("RunService").RenderStepped:Connect(function()
	if flying then
		local camCF = workspace.CurrentCamera.CFrame
		bodyGyro.CFrame = camCF
		bodyVel.Velocity = camCF.LookVector * speed
	end
end)
