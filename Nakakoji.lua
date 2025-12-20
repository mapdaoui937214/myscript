local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Status = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_Kick_Final"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 160, 0, 70)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -35)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
KillBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "KICK PLAYER"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 12
Instance.new("UICorner", KillBtn)

Status.Parent = MainFrame
Status.Size = UDim2.new(1, 0, 0, 20)
Status.BackgroundTransparency = 1
Status.Font = Enum.Font.Code
Status.Text = "まっぷhub: READY"
Status.TextColor3 = Color3.fromRGB(255, 255, 255)
Status.TextSize = 9

local function fireKick(target)
    local remotes = {}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            local n = v.Name:lower()
            if n:find("kick") or n:find("ban") or n:find("admin") or n:find("mod") or n:find("report") then
                table.insert(remotes, v)
            end
        end
    end

    for _, r in pairs(remotes) do
        pcall(function()
            r:FireServer(target, "Banned")
            r:FireServer(target.UserId)
            r:FireServer("Kick", target.Name)
        end)
    end

    local tChar = target.Character
    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
    if tHrp then
        local st = tick()
        local con
        con = game:GetService("RunService").Heartbeat:Connect(function()
            if tick() - st > 2 then con:Disconnect() return end
            tHrp.CFrame = CFrame.new(0, 0/0, 0)
            tHrp.Velocity = Vector3.new(1e38, 1e38, 1e38)
        end)
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
    Status.Text = killMode and "SELECT TARGET" or "まっぷhub: READY"
end)

mouse.Button1Down:Connect(function()
    if killMode and mouse.Target then
        local t = game.Players:GetPlayerFromCharacter(mouse.Target.Parent) or game.Players:GetPlayerFromCharacter(mouse.Target.Parent.Parent)
        if t and t ~= player then
            fireKick(t)
            Status.Text = "KICK SENT: " .. t.Name
        end
    end
end)
