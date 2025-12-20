local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local CONFIG = {
	Enabled = true,
	ResetPosition = Vector3.new(0, 10, 0),
	FallThreshold = -20,
	CheckInterval = 0.5,
	ClearItems = true
}

local function clearInventory(player, character)
	if not CONFIG.ClearItems then return end
	
	local backpack = player:FindFirstChild("Backpack")
	if backpack then
		backpack:ClearAllChildren()
	end
	
	for _, item in ipairs(character:GetChildren()) do
		if item:IsA("Tool") then
			item:Destroy()
		end
	end
end

local function monitorCharacter(player, character)
	local hrp = character:WaitForChild("HumanoidRootPart", 5)
	if not hrp then return end

	local lastCheck = 0
	local connection
	
	connection = RunService.Heartbeat:Connect(function()
		if not character:IsDescendantOf(workspace) or not CONFIG.Enabled then
			if not CONFIG.Enabled then return end
			connection:Disconnect()
			return
		end

		local now = tick()
		if now - lastCheck >= CONFIG.CheckInterval then
			lastCheck = now
			
			if hrp.Position.Y < CONFIG.FallThreshold then
				clearInventory(player, character)
				hrp.CFrame = CFrame.new(CONFIG.ResetPosition)
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		monitorCharacter(player, character)
	end)
end)
