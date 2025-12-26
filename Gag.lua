local MyAuraRank = 10
local StealDelay = 0.6
local SearchRadius = 300
local AuraConfig = {dist = 60, color = Color3.fromRGB(255, 0, 0)}

local lplr = game.Players.LocalPlayer
local runService = game:GetService("RunService")
local StealEnabled = false
local AuraEnabled = false

-- GUI作成
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
local TitleBar = Instance.new("Frame", MainFrame)
local TitleLabel = Instance.new("TextLabel", TitleBar)
local MinButton = Instance.new("TextButton", TitleBar)
local ContentFrame = Instance.new("Frame", MainFrame)
local StealToggle = Instance.new("TextButton", ContentFrame)
local AuraToggle = Instance.new("TextButton", ContentFrame)

MainFrame.Size = UDim2.new(0, 200, 0, 150)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -75)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
TitleLabel.Text = "Brainrot Stealer V2"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundTransparency = 1

MinButton.Size = UDim2.new(0.2, 0, 1, 0)
MinButton.Position = UDim2.new(0.8, 0, 0, 0)
MinButton.Text = "-"
MinButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
MinButton.TextColor3 = Color3.new(1, 1, 1)

ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

local function styleBtn(btn, text, pos)
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.Position = pos
    btn.Text = text .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
end

styleBtn(StealToggle, "Auto Steal", UDim2.new(0.05, 0, 0.1, 0))
styleBtn(AuraToggle, "Freeze Aura", UDim2.new(0.05, 0, 0.55, 0))

-- トグル処理
StealToggle.MouseButton1Click:Connect(function()
    StealEnabled = not StealEnabled
    StealToggle.Text = "Auto Steal: " .. (StealEnabled and "ON" or "OFF")
    StealToggle.BackgroundColor3 = StealEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

AuraToggle.MouseButton1Click:Connect(function()
    AuraEnabled = not AuraEnabled
    AuraToggle.Text = "Freeze Aura: " .. (AuraEnabled and "ON" or "OFF")
    AuraToggle.BackgroundColor3 = AuraEnabled and Color3.fromRGB(50, 150, 50) or Color3.fromRGB(60, 60, 60)
end)

-- 自分の基地のコレクターを特定
local function getMyCollector()
    local plots = game.Workspace:FindFirstChild("Plots")
    if plots then
        for _, plot in pairs(plots:GetChildren()) do
            local o = plot:FindFirstChild("Owner")
            if o and (o.Value == lplr.Name or o.Value == lplr.DisplayName) then
                return plot:FindFirstChild("Collector") or plot:FindFirstChild("CollectPart")
            end
        end
    end
    return nil
end

-- メイン盗みループ
task.spawn(function()
    while true do
        if StealEnabled then
            local char = lplr.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            local collector = getMyCollector()

            if root and collector then
                -- Workspace内から「盗めるNPC」を探す
                for _, npc in pairs(game.Workspace:GetDescendants()) do
                    -- 盗める条件: HumanoidがあるNPCで、かつ自分のキャラではない
                    if npc:IsA("Humanoid") and npc.Parent ~= char and not game.Players:GetPlayerFromCharacter(npc.Parent) then
                        local npcRoot = npc.Parent:FindFirstChild("HumanoidRootPart")
                        if npcRoot and (root.Position - npcRoot.Position).Magnitude < SearchRadius then
                            
                            -- 1. ターゲットへTP
                            root.CFrame = npcRoot.CFrame
                            task.wait(0.2)
                            
                            -- 2. クリック/接触をシミュレート
                            -- ほとんどの「盗む」はClickDetectorまたはProximityPromptなので両方試す
                            local cd = npc.Parent:FindFirstChildOfClass("ClickDetector")
                            local prompt = npc.Parent:FindFirstChildOfClass("ProximityPrompt")
                            
                            if cd then fireclickdetector(cd) end
                            if prompt then fireproximityprompt(prompt) end
                            
                            -- 接触判定も送る
                            if firetouchinterest then
                                firetouchinterest(root, npcRoot, 0)
                                firetouchinterest(root, npcRoot, 1)
                            end
                            
                            task.wait(StealDelay)

                            -- 3. 自分の基地へ戻って納品
                            root.CFrame = collector.CFrame
                            task.wait(0.2)
                            
                            if firetouchinterest then
                                firetouchinterest(root, collector, 0)
                                firetouchinterest(root, collector, 1)
                            end
                            
                            task.wait(StealDelay)
                        end
                    end
                end
            end
        end
        task.wait(1)
    end
end)

-- フリーズオーラ (物理的に座標を固定する試み)
runService.Heartbeat:Connect(function()
    if not AuraEnabled then return end
    local char = lplr.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= lplr and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local tRoot = plr.Character.HumanoidRootPart
            if (root.Position - tRoot.Position).Magnitude < AuraConfig.dist then
                -- クライアント側だけでなく、ネットワークオーナーシップの隙を突いて固定を試みる
                tRoot.Velocity = Vector3.new(0, 0, 0)
                tRoot.RotVelocity = Vector3.new(0, 0, 0)
                -- 座標を毎フレーム固定
                tRoot.CFrame = tRoot.CFrame
            end
        end
    end
end)
