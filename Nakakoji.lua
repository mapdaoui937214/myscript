local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local Title = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_Tool_v5"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 160, 0, 70)
MainFrame.Position = UDim2.new(0.5, -80, 0.5, -35)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

Title.Parent = MainFrame
Title.Size = UDim2.new(1, 0, 0, 25)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "まっぷhub [Ownership]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 10

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.9, 0, 0.5, 0)
KillBtn.Position = UDim2.new(0.05, 0, 0.4, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(130, 0, 0)
KillBtn.Font = Enum.Font.GothamBold
KillBtn.Text = "OWNER KILL"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
KillBtn.TextSize = 11
Instance.new("UICorner", KillBtn)

local function ownerKill(target)
    local tChar = target.Character
    local tHrp = tChar and tChar:FindFirstChild("HumanoidRootPart")
    local tool = player.Backpack:FindFirstChildOfClass("Tool") or player.Character:FindFirstChildOfClass("Tool")
    
    if tHrp and tool then
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart")
        if handle then
            local connection
            local start = tick()
            connection = game:GetService("RunService").Heartbeat:Connect(function()
                if tick() - start > 1.5 or not tHrp then 
                    connection:Disconnect() 
                    return 
                end
                handle.CFrame = tHrp.CFrame
                handle.Velocity = Vector3.new(0, -10000, 0)
                tHrp.CFrame = CFrame.new(tHrp.Position.X, -1000, tHrp.Position.Z)
                tHrp.Velocity = Vector3.new(0, -10000, 0)
            end)
        end
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 130, 0) or Color3.fromRGB(130, 0, 0)
    KillBtn.Text = killMode and "READY (USE TOOL)" or "OWNER KILL"
end)

mouse.Button1Down:Connect(function()
    if killMode and mouse.Target then
        local char = mouse.Target.Parent
        local tPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)
        if tPlayer and tPlayer ~= player then
            ownerKill(tPlayer)
        end
    end
end)

game:GetService("RunService").Stepped:Connect(function()
    if killMode then
        pcall(function()
            sethiddenproperty(player, "SimulationRadius", 1e9)
            sethiddenproperty(player, "MaxSimulationRadius", 1e9)
        end)
    end
end)
