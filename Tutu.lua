local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

getgenv().ItemSystemConfig = {
    AssetID = 212641536,
    AutoMode = "All"
}

local function distributeItems()
    local targetID = tostring(getgenv().ItemSystemConfig.AssetID)
    local players = Players:GetPlayers()
    local found = false
    
    for _, obj in ipairs(game:GetDescendants()) do
        if obj:IsA("Tool") or obj:IsA("HopperBin") then
            local handle = obj:FindFirstChild("Handle")
            local mesh = handle and (handle:FindFirstChildOfClass("SpecialMesh") or handle:FindFirstChildOfClass("MeshPart"))
            local isMatch = (obj.ToolTip == targetID) or (mesh and (string.find(mesh.MeshId, targetID) or string.find(mesh.TextureId, targetID)))
            
            if isMatch then
                found = true
                for _, p in ipairs(players) do
                    local bp = p:FindFirstChild("Backpack")
                    if bp and not (bp:FindFirstChild(obj.Name) or (p.Character and p.Character:FindFirstChild(obj.Name))) then
                        local clone = obj:Clone()
                        clone.Parent = bp
                    end
                end
            end
        end
    end
    return found
end

local function createUI()
    local sg = Instance.new("ScreenGui")
    sg.Name = "Manual_Distributor_UI"
    sg.ResetOnSpawn = false
    sg.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 220, 0, 180)
    main.Position = UDim2.new(0.5, -110, 0.5, -90)
    main.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = sg
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

    local dragging, dragStart, startPos
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
    title.Text = " Item Distributor (ALL)"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBold
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

    local layout = Instance.new("UIListLayout", container)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.Padding = UDim.new(0, 10)

    local sendBtn = Instance.new("TextButton")
    sendBtn.Size = UDim2.new(0, 180, 0, 45)
    sendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    sendBtn.Text = "DISTRIBUTE ALL"
    sendBtn.TextColor3 = Color3.new(1, 1, 1)
    sendBtn.Font = Enum.Font.GothamBold
    sendBtn.Parent = container
    Instance.new("UICorner", sendBtn)

    local exitBtn = Instance.new("TextButton")
    exitBtn.Size = UDim2.new(0, 180, 0, 35)
    exitBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    exitBtn.Text = "Stop Script"
    exitBtn.TextColor3 = Color3.new(1, 1, 1)
    exitBtn.Font = Enum.Font.GothamBold
    exitBtn.Parent = container
    Instance.new("UICorner", exitBtn)

    local minimized = false
    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        container.Visible = not minimized
        if minimized then
            main:TweenSize(UDim2.new(0, 220, 0, 35), "Out", "Quad", 0.3, true)
            minBtn.Text = "+"
        else
            main:TweenSize(UDim2.new(0, 220, 0, 180), "Out", "Quad", 0.3, true)
            minBtn.Text = "-"
        end
    end)

    sendBtn.MouseButton1Click:Connect(function()
        sendBtn.Text = "SENDING TO ALL..."
        local result = distributeItems()
        if result then
            sendBtn.Text = "SUCCESS!"
            sendBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
        else
            sendBtn.Text = "ITEM NOT FOUND"
            sendBtn.BackgroundColor3 = Color3.fromRGB(200, 100, 0)
        end
        task.wait(1)
        sendBtn.Text = "DISTRIBUTE ALL"
        sendBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    end)

    exitBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
end

createUI()
