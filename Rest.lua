local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

workspace.FallenPartsDestroyHeight = -math.huge

local function stabilize(character)
	local root = character:WaitForChild("HumanoidRootPart")
	local humanoid = character:WaitForChild("Humanoid")

	humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)

	RunService.Stepped:Connect(function()
		if root and root.Parent then
			local vel = root.AssemblyLinearVelocity
			if vel.Magnitude > 100 then
				root.AssemblyLinearVelocity = vel.Unit * 100
			end
		end
	end)
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(stabilize)
end)
