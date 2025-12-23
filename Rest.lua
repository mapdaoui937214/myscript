local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ControlGui"
screenGui.ResetOnSpawn = false
screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 150, 0, 100)
mainFrame.Position = UDim2.new(0.5, -75, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true 
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "Stabilizer"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = mainFrame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.8, 0, 0, 30)
toggleBtn.Position = UDim2.new(0.1, 0, 0, 40)
toggleBtn.Text = "OFF"
toggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
toggleBtn.Parent = mainFrame

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -25, 0, 5)
minBtn.Text = "-"
minBtn.Parent = mainFrame

local enabled = false
local minimized = false

toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "ON" or "OFF"
	toggleBtn.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)

minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		mainFrame.Size = UDim2.new(0, 150, 0, 30)
		toggleBtn.Visible = false
		minBtn.Text = "+"
	else
		mainFrame.Size = UDim2.new(0, 150, 0, 100)
		toggleBtn.Visible = true
		minBtn.Text = "-"
	end
end)

RunService.RenderStepped:Connect(function()
	if enabled then
		local char = Players.LocalPlayer.Character
		if char then
			local root = char:FindFirstChild("HumanoidRootPart")
			local hum = char:FindFirstChild("Humanoid")
			if root and hum then
				hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
				hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
				local vel = root.AssemblyLinearVelocity
				if vel.Magnitude > 100 then
					root.AssemblyLinearVelocity = vel.Unit * 100
				end
			end
		end
	end
end)

workspace.FallenPartsDestroyHeight = -math.huge
