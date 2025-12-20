local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().FallResetConfig = {
    Enabled = true,
    ResetPos = Vector3.new(0, 10, 0),
    Threshold = -1,
    Interval = 0.1
}

local function createUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "System_Control_UI"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 220, 0, 160)
    main.Position = UDim2.new(0.5, -110, 0.5, -80)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = sg

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = main

    local dragging, dragInput, dragStart, startPos
    main.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 35)
    title.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    title.Text = " System Menu"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = main

    local minBtn = Instance.new("TextButton")
    minBtn.Size = UDim2.new(0, 30, 0, 30)
    minBtn.Position = UDim2.new(1, -35, 0, 2)
    minBtn.Text = "-"
    minBtn.TextColor3 = Color3.new(1, 1, 1)
    minBtn.BackgroundTransparency = 1
    minBtn.TextSize = 25
    minBtn.Parent = main

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 1, -35)
    container.Position = UDim2.new(0, 0, 0, 35)
    container.BackgroundTransparency = 1
    container.Parent = main

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Parent = container

    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Size = UDim2.new(0, 180, 0, 40)
    toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 0)
    toggleBtn.Text = "Fall Reset: ON"
    toggleBtn.TextColor3 = Color3.new(1, 1, 1)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.Parent = container
    Instance.new("UICorner", toggleBtn)

    local exitBtn = Instance.new("TextButton")
    exitBtn.Size = UDim2.new(0, 180, 0, 40)
    exitBtn.BackgroundColor3 = Color3.fromRGB(160, 0, 0)
    exitBtn.Text = "Cancel / Exit"
    exitBtn.TextColor3 = Color3.new(1, 1, 1)
    exitBtn.Font = Enum.Font.GothamBold
    exitBtn.Parent = container
    Instance.new("UICorner", exitBtn)

    local warning = Instance.new("Frame")
    warning.Size = UDim2.new(1, 0, 1, 0)
    warning.BackgroundColor3 = Color3.new(0, 0, 0)
    warning.BackgroundTransparency = 0.5
    warning.Visible = false
    warning.ZIndex = 10
    warning.Parent = main

    local warnBox = Instance.new("Frame")
    warnBox.Size = UDim2.new(0.9, 0, 0.8, 0)
    warnBox.Position = UDim2.new(0.05, 0, 0.1, 0)
    warnBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    warnBox.ZIndex = 11
    warnBox.Parent = warning
    Instance.new("UICorner", warnBox)

    local warnMsg = Instance.new("TextLabel")
    warnMsg.Size = UDim2.new(1, 0, 0.6, 0)
    warnMsg.Text = "Items will be cleared.\nAre you sure?"
    warnMsg.TextColor3 = Color3.new(1, 1, 1)
    warnMsg.BackgroundTransparency = 1
    warnMsg.ZIndex = 12
    warnMsg.Parent = warnBox

    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
    yesBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
    yesBtn.Text = "Confirm"
    yesBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
    yesBtn.TextColor3 = Color3.new(1, 1, 1)
    yesBtn.ZIndex = 12
    yesBtn.Parent = warnBox

    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
    noBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
    noBtn.Text = "No"
    noBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    noBtn.TextColor3 = Color3.new(1, 1, 1)
    noBtn.ZIndex = 12
    noBtn.Parent = warnBox

    minBtn.MouseButton1Click:Connect(function()
        container.Visible = not container.Visible
        main.Size = container.Visible and UDim2.new(0, 220, 0, 160) or UDim2.new(0, 220, 0, 35)
    end)

    toggleBtn.MouseButton1Click:Connect(function()
        getgenv().FallResetConfig.Enabled = not getgenv().FallResetConfig.Enabled
        toggleBtn.Text = getgenv().FallResetConfig.Enabled and "Fall Reset: ON" or "Fall Reset: OFF"
        toggleBtn.BackgroundColor3 = getgenv().FallResetConfig.Enabled and Color3.fromRGB(0, 160, 0) or Color3.fromRGB(160, 0, 0)
    end)

    exitBtn.MouseButton1Click:Connect(function() warning.Visible = true end)
    noBtn.MouseButton1Click:Connect(function() warning.Visible = false end)
    yesBtn.MouseButton1Click:Connect(function() sg:Destroy() getgenv().FallResetConfig.Enabled = false end)
end

local function loop(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    task.spawn(function()
        while char:IsDescendantOf(workspace) and getgenv().FallResetConfig do
            task.wait(getgenv().FallResetConfig.Interval)
            if getgenv().FallResetConfig.Enabled and hrp.Position.Y < getgenv().FallResetConfig.Threshold then
                hrp.CFrame = CFrame.new(getgenv().FallResetConfig.ResetPos)
                local bp = LocalPlayer:FindFirstChild("Backpack")
                if bp then bp:ClearAllChildren() end
                for _, v in ipairs(char:GetChildren()) do if v:IsA("Tool") then v:Destroy() end end
            end
        end
    end)
end

createUI()
if LocalPlayer.Character then loop(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(loop)
