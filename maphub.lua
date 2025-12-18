local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MapHub_Final_Integrated"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 230, 0, 350)
Main.Position = UDim2.new(0.5, -115, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.Active = true
Main.Draggable = true
Main.ClipsDescendants = true
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

local ScrollFrame = Instance.new("ScrollingFrame")
ScrollFrame.Size = UDim2.new(1, 0, 1, -40)
ScrollFrame.Position = UDim2.new(0, 0, 0, 40)
ScrollFrame.BackgroundTransparency = 1
ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 750)
ScrollFrame.ScrollBarThickness = 2
ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(200, 200, 200)
ScrollFrame.Parent = Main

local flySpeed, walkSpeed, jumpPower = 60, 16, 50
local flying, noclip, infJump, tracerEnabled, antiAfk = false, false, false, false, false
local tracers = {}

local function createToggle(name, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85, 0, 0, 30)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(120, 30, 30)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.Parent = ScrollFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = name .. (state and ": ON" or ": OFF")
        btn.BackgroundColor3 = state and Color3.fromRGB(30, 120, 30) or Color3.fromRGB(120, 30, 30)
        callback(state)
    end)
end

createToggle("Anti AFK", 10, function(s)
    antiAfk = s
    if s then
        player.Idled:Connect(function()
            if antiAfk then
                VirtualUser:CaptureController()
                VirtualUser:ClickButton2(Vector2.new())
            end
        end)
    end
end)

createToggle("ESP Tracers", 50, function(s) tracerEnabled = s end)

local function createLine()
    local line = Drawing.new("Line")
    line.Visible = false
    line.Color = Color3.new(1, 1, 1)
    line.Thickness = 1
    return line
end

createToggle("Fly (Camera)", 90, function(s)
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
                local moveDir = hum.MoveDirection
                if moveDir.Magnitude > 0 then
                    bv.Velocity = camera.CFrame.LookVector * (moveDir.Magnitude * flySpeed)
                else
                    bv.Velocity = Vector3.new(0, 0.1, 0)
                end
                bg.CFrame = camera.CFrame
                task.wait()
            end
            bv:Destroy() bg:Destroy() hum.PlatformStand = false
        end)
    else hum.PlatformStand = false end
end)

createToggle("Noclip", 130, function(s) noclip = s end)
createToggle("Inf Jump", 170, function(s) infJump = s end)
createToggle("Hide Chat", 210, function(s) StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, not s) end)

local function createSlider(text, yPos, minVal, maxVal, defaultVal, callback)
    local label = Instance.new("TextLabel", ScrollFrame)
    label.Size = UDim2.new(0.85, 0, 0, 20)
    label.Position = UDim2.new(0.075, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. defaultVal
    label.TextColor3 = Color3.new(1, 1, 1)
    local frame = Instance.new("Frame", ScrollFrame)
    frame.Size = UDim2.new(0.85, 0, 0, 6)
    frame.Position = UDim2.new(0.075, 0, 0, yPos + 25)
    frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    local dot = Instance.new("TextButton", frame)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new((defaultVal-minVal)/(maxVal-minVal), -7, 0.5, -7)
    dot.BackgroundColor3 = Color3.new(1, 1, 1)
    dot.Text = ""
    Instance.new("UICorner", dot)
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

createSlider("WalkSpeed", 260, 16, 300, 16, function(v) walkSpeed = v end)
createSlider("FlySpeed", 310, 10, 500, 60, function(v) flySpeed = v end)

RunService.Stepped:Connect(function()
    if noclip and player.Character then
        for _, p in pairs(player.Character:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end
    end
end)

RunService.RenderStepped:Connect(function()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        if not flying then player.Character.Humanoid.WalkSpeed = walkSpeed end
    end
    if not tracerEnabled then
        for _, l in pairs(tracers) do l.Visible = false end
    else
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                local pos, onScreen = camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
                if not tracers[v] then tracers[v] = createLine() end
                if onScreen then
                    tracers[v].From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
                    tracers[v].To = Vector2.new(pos.X, pos.Y)
                    tracers[v].Visible = true
                else tracers[v].Visible = false end
            elseif tracers[v] then tracers[v].Visible = false end
        end
    end
end)

UIS.JumpRequest:Connect(function() if infJump and player.Character then player.Character.Humanoid:ChangeState("Jumping") end end)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(0.85, 0, 0, 5)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.new(1, 1, 1)
MinBtn.BackgroundTransparency = 1
local min = false

MinBtn.MouseButton1Click:Connect(function()
    min = not min
    if min then
        ScrollFrame.Visible = false
        Main:TweenSize(UDim2.new(0, 230, 0, 40), "Out", "Quad", 0.3, true)
        MinBtn.Text = "+"
    else
        Main:TweenSize(UDim2.new(0, 230, 0, 350), "Out", "Quad", 0.3, true, function()
            ScrollFrame.Visible = true
        end)
        MinBtn.Text = "-"
    end
end)
