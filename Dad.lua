local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local Scroll = Instance.new("ScrollingFrame")
local UIList = Instance.new("UIListLayout")
local MinBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Name = "Bringer_AntiLocal_Bypass"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -125)
MainFrame.Size = UDim2.new(0, 200, 0, 250)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Title.Text = "Force Bringer"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.TextSize = 14

MinBtn.Parent = MainFrame
MinBtn.Text = "-"
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
MinBtn.TextColor3 = Color3.new(1, 1, 1)

CloseBtn.Parent = MainFrame
CloseBtn.Text = "X"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 40)
CloseBtn.TextColor3 = Color3.new(1, 1, 1)

Scroll.Parent = MainFrame
Scroll.Size = UDim2.new(1, -10, 1, -40)
Scroll.Position = UDim2.new(0, 5, 0, 35)
Scroll.BackgroundTransparency = 1
Scroll.ScrollBarThickness = 4

UIList.Parent = Scroll
UIList.Padding = UDim.new(0, 5)

local function ForceBring(target)
	if target and target.Character and LocalPlayer.Character then
		local tRoot = target.Character:FindFirstChild("HumanoidRootPart")
		local tHum = target.Character:FindFirstChildOfClass("Humanoid")
		local mRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if tRoot and tHum and mRoot then
			tHum.Sit = false
			
			local hb
			local t = 0
			hb = RunService.Heartbeat:Connect(function()
				if t < 10 then
					tRoot.Velocity = Vector3.new(0, 0, 0)
					tRoot.RotVelocity = Vector3.new(0, 0, 0)
					tRoot.CFrame = mRoot.CFrame * CFrame.new(0, 0, -5)
					t = t + 1
				else
					hb:Disconnect()
				end
			end)
		end
	end
end

local function refresh()
	for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local b = Instance.new("TextButton")
			b.Size = UDim2.new(1, 0, 0, 30)
			b.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
			b.Text = p.DisplayName
			b.TextColor3 = Color3.new(1, 1, 1)
			b.Parent = Scroll
			b.MouseButton1Click:Connect(function() ForceBring(p) end)
		end
	end
	Scroll.CanvasSize = UDim2.new(0, 0, 0, UIList.AbsoluteContentSize.Y)
end

MinBtn.MouseButton1Click:Connect(function()
	Scroll.Visible = not Scroll.Visible
	MainFrame:TweenSize(Scroll.Visible and UDim2.new(0, 200, 0, 250) or UDim2.new(0, 200, 0, 30), "Out", "Quad", 0.2, true)
end)

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

Players.PlayerAdded:Connect(refresh)
Players.PlayerRemoving:Connect(refresh)
refresh()
