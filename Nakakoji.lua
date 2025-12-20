local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local killMode = false

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local KillBtn = Instance.new("TextButton")
local SuccessLabel = Instance.new("TextLabel")

ScreenGui.Name = "MappHub_SeatVoid"
ScreenGui.Parent = game:GetService("CoreGui")

MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0, 150, 0, 70)
MainFrame.Position = UDim2.new(0.5, -75, 0.5, -35)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame)

KillBtn.Parent = MainFrame
KillBtn.Size = UDim2.new(0.9, 0, 0.7, 0)
KillBtn.Position = UDim2.new(0.05, 0, 0.15, 0)
KillBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
KillBtn.Text = "SEAT KILL"
KillBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
Instance.new("UICorner", KillBtn)

SuccessLabel.Parent = ScreenGui
SuccessLabel.Size = UDim2.new(0, 400, 0, 50)
SuccessLabel.Position = UDim2.new(0.5, -200, 0.3, 0)
SuccessLabel.BackgroundTransparency = 1
SuccessLabel.Font = Enum.Font.GothamBlack
SuccessLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
SuccessLabel.TextSize = 35
SuccessLabel.Visible = false

local function exploitSeat(target)
    local tChar = target.Character
    local tHum = tChar and tChar:FindFirstChild("Humanoid")
    
    -- 1. ゲーム内の座れる場所を探す
    local seat = game:GetService("Workspace"):FindFirstChildOfClass("Seat", true) or game:GetService("Workspace"):FindFirstChildOfClass("VehicleSeat", true)
    
    if tHum and seat then
        -- 2. ターゲットを強制的に座らせる（サーバーが許可しやすい動作）
        seat:Sit(tHum)
        task.wait(0.1)
        
        -- 3. 座った状態で椅子ごと奈落（Void）へ落とす
        -- ※自分の権限で動かせる椅子であれば、サーバー側でも相手が落ちます
        if seat:IsDescendantOf(game.Workspace) then
            for i = 1, 20 do
                seat.CFrame = CFrame.new(seat.Position.X, -10000, seat.Position.Z)
                task.wait()
            end
        end
        
        SuccessLabel.Text = "SEATED VOID: " .. target.Name
        SuccessLabel.Visible = true
        task.delay(2, function() SuccessLabel.Visible = false end)
    end
end

KillBtn.MouseButton1Click:Connect(function()
    killMode = not killMode
    KillBtn.BackgroundColor3 = killMode and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

mouse.Button1Down:Connect(function()
    if not killMode or not mouse.Target then return end
    local char = mouse.Target.Parent
    local tPlayer = game.Players:GetPlayerFromCharacter(char) or game.Players:GetPlayerFromCharacter(char.Parent)
    
    if tPlayer and tPlayer ~= player then
        exploitSeat(tPlayer)
    end
end)
