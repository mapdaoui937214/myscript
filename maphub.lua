local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapHub_Final"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 620)
Main.Position = UDim2.new(0.5, -115, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "📍 MapHub COMPLETE"
Title.TextColor3 = Color3.new(1, 1, 1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = Main
Instance.new("UICorner", Title)

local function createToggle(name, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 25)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(120, 30, 30)
        callback(state)
    end)
end

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local flying, infJump, espEnabled, noclip = false, false, false, false
local savedPosition = nil

createToggle("Fly", UDim2.new(0.075, 0, 0.08, 0), function(s)
    flying = s
    local char = player.Character
    if not char then return end
    local hrp, hum = char:WaitForChild("HumanoidRootPart"), char:WaitForChild("Humanoid")
    if flying then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "MapFlyBV"
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        local bg = Instance.new("BodyGyro", hrp)
        bg.Name = "MapFlyBG"
        bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        hum.PlatformStand = true
        task.spawn(function()
            while flying do
                bv.Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                bg.CFrame = workspace.CurrentCamera.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy() hum.PlatformStand = false
        end)
    else hum.PlatformStand = false end
end)

createToggle("Noclip", UDim2.new(0.075, 0, 0.13, 0), function(s) noclip = s end)
createToggle("Inf Jump", UDim2.new(0.075, 0, 0.18, 0), function(s) infJump = s end)
createToggle("ESP", UDim2.new(0.075, 0, 0.23, 0), function(s) espEnabled = s end)
createToggle("Anti Chat", UDim2.new(0.075, 0, 0.28, 0), function(s) StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not s) end)

local fbConn
createToggle("Fullbright", UDim2.new(0.075, 0, 0.33, 0), function(s)
    if s then fbConn = RunService.RenderStepped:Connect(function() Lighting.Brightness = 2 Lighting.ClockTime = 14 Lighting.GlobalShadows = false end)
    else if fbConn then fbConn:Disconnect() end Lighting.GlobalShadows = true end
end)

local SaveBtn = Instance.new("TextButton", Main)
SaveBtn.Size = UDim2.new(0.4, 0, 0, 25)
SaveBtn.Position = UDim2.new(0.075, 0, 0.39, 0)
SaveBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 120)
SaveBtn.Text = "Save Pos"
SaveBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", SaveBtn)

local TpSavedBtn = Instance.new("TextButton", Main)
TpSavedBtn.Size = UDim2.new(0.4, 0, 0, 25)
TpSavedBtn.Position = UDim2.new(0.525, 0, 0.39, 0)
TpSavedBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 50)
TpSavedBtn.Text = "TP Saved"
TpSavedBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TpSavedBtn)

local PlayerBox = Instance.new("TextBox", Main)
PlayerBox.Size = UDim2.new(0.85, 0, 0, 25)
PlayerBox.Position = UDim2.new(0.075, 0, 0.45, 0)
PlayerBox.PlaceholderText = "Enter Player Name..."
PlayerBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlayerBox.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", PlayerBox)

local PlayerTpBtn = Instance.new("TextButton", Main)
PlayerTpBtn.Size = UDim2.new(0.85, 0, 0, 25)
PlayerTpBtn.Position = UDim2.new(0.075, 0, 0.51, 0)
PlayerTpBtn.BackgroundColor3 = Color3.fromRGB(40, 100, 40)
PlayerTpBtn.Text = "Teleport to Player"
PlayerTpBtn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", PlayerTpBtn)

SaveBtn.MouseButton1Click:Connect(function() if player.Character then savedPosition = player.Character.HumanoidRootPart.CFrame end end)
TpSavedBtn.MouseButton1Click:Connect(function() if savedPosition and player.Character then player.Character.HumanoidRootPart.CFrame = savedPosition end end)
PlayerTpBtn.MouseButton1Click:Connect(function()
    local target = PlayerBox.Text:lower()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Name:lower():find(target) and v.Character then
            player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
            break
        end
    end
end)

local function createSlider(text, pos, minVal, maxVal, defaultVal, callback)
    local label = Instance.new("TextLabel", Main)
    label.Size = UDim2.new(0.85, 0, 0, 20)
    label.Position = pos
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    local frame = Instance.new("Frame", Main)
    frame.Size = UDim2.new(0.85, 0, 0, 6)
    frame.Position = pos + UDim2.new(0, 0, 0, 22)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local dot = Instance.new("TextButton", frame)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal), -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Text = ""
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local drag = false
    dot.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local x = math.clamp((i.Position.X - frame.AbsolutePosition.X) / frame.AbsoluteSize.X, 0, 1)
            dot.Position = UDim2.new(x, -7, 0.5, -7)
            local val = math.floor(minVal + (x * (maxVal - minVal)))
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end

createSlider("WalkSpeed", UDim2.new(0.075, 0, 0.58, 0), 16, 300, 16, function(v) walkSpeed = v end)
createSlider("JumpPower", UDim2.new(0.075, 0, 0.71, 0), 50, 500, 50, function(v) jumpPower = v end)
createSlider("FlySpeed", UDim2.new(0.075, 0, 0.84, 0), 10, 500, 60, function(v) flySpeed = v end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local h = player.Character.Humanoid
        if not flying then h.WalkSpeed = walkSpeed end
        h.UseJumpPower = true h.JumpPower = jumpPower
    end
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Character then
            local hl = v.Character:FindFirstChild("MapHubESP")
            if espEnabled then
                if not hl then
                    hl = Instance.new("Highlight", v.Character)
                    hl.Name = "MapHubESP"
                    hl.FillColor = Color3.fromRGB(255, 0, 0)
                end
            elseif hl then hl:Destroy() end
        end
    end
end)

UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.85, 0, 0, 5)
MinBtn.Text = "-"
MinBtn.BackgroundTransparency = 1
MinBtn.TextColor3 = Color3.new(1, 1, 1)
local min = false
MinBtn.MouseButton1Click:Connect(function()
    min = not min
    Main:TweenSize(min and UDim2.new(0, 230, 0, 40) or UDim2.new(0, 230, 0, 620), "Out", "Quad", 0.3, true)
    MinBtn.Text = min and "+" or "-"
end)
