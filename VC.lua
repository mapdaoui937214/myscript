local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VCSpy_Final_Mobile"

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 300)
MainFrame.Position = UDim2.new(0.5, -110, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true

local UICorner = Instance.new("UICorner", MainFrame)
UICorner.CornerRadius = UDim.new(0, 10)

local TitleBar = Instance.new("TextButton", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 35)
TitleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TitleBar.Text = "  VC SPY v2.0"
TitleBar.TextColor3 = Color3.new(1, 1, 1)
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left
TitleBar.AutoButtonColor = false

local TitleCorner = Instance.new("UICorner", TitleBar)
TitleCorner.CornerRadius = UDim.new(0, 10)

local MinBtn = Instance.new("TextButton", TitleBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -32, 0, 2)
MinBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)

local ListFrame = Instance.new("ScrollingFrame", MainFrame)
ListFrame.Size = UDim2.new(1, -10, 1, -45)
ListFrame.Position = UDim2.new(0, 5, 0, 40)
ListFrame.BackgroundTransparency = 1
ListFrame.ScrollBarThickness = 2
ListFrame.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", ListFrame)
Layout.Padding = UDim.new(0, 5)

local activeWires = {}
local isMinimized = false

local function dragGui(gui)
	local dragging, dragInput, dragStart, startPos
	gui.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = gui.Position
		end
	end)
	gui.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end
dragGui(MainFrame)

MinBtn.MouseButton1Click:Connect(function()
	isMinimized = not isMinimized
	if isMinimized then
		ListFrame.Visible = false
		MainFrame:TweenSize(UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.2)
		MinBtn.Text = "+"
	else
		MainFrame:TweenSize(UDim2.new(0, 220, 0, 300), "Out", "Quad", 0.2)
		task.wait(0.2)
		ListFrame.Visible = true
		MinBtn.Text = "-"
	end
end)

local function toggleSpy(target, btn)
	if activeWires[target.UserId] then
		activeWires[target.UserId]:Destroy()
		activeWires[target.UserId] = nil
		btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		btn.Text = target.Name .. " [OFF]"
	else
		local char = target.Character
		local input = char and (char:FindFirstChildOfClass("AudioDeviceInput") or char:FindFirstChild("AudioDeviceInput", true))
		local listener = LocalPlayer.Character and (LocalPlayer.Character:FindFirstChildOfClass("AudioListener") or LocalPlayer.Character:FindFirstChild("AudioListener", true))
		if input and listener then
			local wire = Instance.new("Wire")
			wire.Source = input
			wire.Target = listener
			wire.Parent = listener
			activeWires[target.UserId] = wire
			btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
			btn.Text = target.Name .. " [ON]"
		end
	end
end

local function updateList()
	for _, v in pairs(ListFrame:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
	for _, p in pairs(Players:GetPlayers()) do
		if p == LocalPlayer then continue end
		local b = Instance.new("TextButton", ListFrame)
		b.Size = UDim2.new(1, 0, 0, 40)
		b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		b.Text = p.Name .. " [OFF]"
		b.TextColor3 = Color3.new(1, 1, 1)
		b.Font = Enum.Font.SourceSansBold
		b.TextSize = 14
		Instance.new("UICorner", b)
		b.MouseButton1Click:Connect(function() toggleSpy(p, b) end)
	end
	ListFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end

updateList()
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)
