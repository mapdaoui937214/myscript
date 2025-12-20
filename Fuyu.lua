local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CONFIG = {
	Enabled = true,
	ResetPosition = Vector3.new(0, 10, 0),
	FallThreshold = -1,
	CheckInterval = 0.1
}

local function setupGui(player)
	local sg = Instance.new("ScreenGui")
	sg.Name = "FallResetControl"
	sg.ResetOnSpawn = false
	sg.Parent = player:WaitForChild("PlayerGui")

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 200, 0, 50)
	btn.Position = UDim2.new(0, 20, 0, 20)
	btn.Text = "System: ON"
	btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
	btn.TextColor3 = Color3.new(1, 1, 1)
	btn.Font = Enum.Font.SourceSansBold
	btn.TextSize = 24
	btn.Parent = sg

	btn.MouseButton1Click:Connect(function()
		CONFIG.Enabled = not CONFIG.Enabled
		if CONFIG.Enabled then
			btn.Text = "System: ON"
			btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		else
			btn.Text = "System: OFF"
			btn.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
		end
	end)
end

local function handleFall(player, character)
	local hrp = character:WaitForChild("HumanoidRootPart")
	local backpack = player:WaitForChild("Backpack")
	local lastCheck = 0

	RunService.Heartbeat:Connect(function()
		if not CONFIG.Enabled then return end
		
		local now = tick()
		if now - lastCheck >= CONFIG.CheckInterval then
			lastCheck = now
			
			if hrp.Position.Y < CONFIG.FallThreshold then
				backpack:ClearAllChildren()
				for _, item in ipairs(character:GetChildren()) do
					if item:IsA("Tool") then
						item:Destroy()
					end
				end
				hrp.CFrame = CFrame.new(CONFIG.ResetPosition)
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	setupGui(player)
	player.CharacterAdded:Connect(function(character)
		handleFall(player, character)
	end)
end)
