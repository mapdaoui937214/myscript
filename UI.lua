local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "K-HUB: FTAP MOBILE GOD 📱",
   LoadingTitle = "Initializing Ultimate Physics...",
   Theme = "DarkBlue",
   ConfigurationSaving = { Enabled = true, FolderName = "K_Hub_FTAP" }
})

-- タブ設定
local MainTab = Window:CreateTab("Physics (物理)", 4483362458)
local PlayerTab = Window:CreateTab("Movement (移動)", 4483362458)
local TargetTab = Window:CreateTab("Gather (集結)", 4483362458)

-- 共通変数
local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

--- [PHYSICS TAB: 物理と攻撃] ---

local FlingAura = false
MainTab:CreateToggle({
   Name = "Safe Fling Aura (触れた奴を飛ばす)",
   CurrentValue = false,
   Callback = function(Value) FlingAura = Value end,
})

local ReachEnabled = false
local ReachDistance = 100
MainTab:CreateToggle({
   Name = "Infinite Reach (無限リーチ)",
   CurrentValue = false,
   Callback = function(Value) ReachEnabled = Value end,
})

MainTab:CreateSlider({
   Name = "Reach Dist (掴み距離)",
   Range = {10, 5000},
   Increment = 50,
   CurrentValue = 100,
   Callback = function(Value) ReachDistance = Value end,
})

MainTab:CreateButton({
   Name = "Reset Physics (バグ解除/リセット)",
   Callback = function()
       local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
       if hrp then
           hrp.Velocity, hrp.RotVelocity = Vector3.new(0,0,0), Vector3.new(0,0,0)
           for _, v in pairs(lp.Character:GetDescendants()) do
               if v:IsA("BasePart") then v.CanCollide = true end
           end
       end
   end,
})

--- [GATHER TAB: アイテム・プレイヤー集結] ---

local BringAll = false
local BringPlayers = false
local GatherPos = Vector3.new(0, 0, 0)
local GatherMode = "Self"

TargetTab:CreateToggle({
   Name = "Bring All Items (全アイテム集結)",
   CurrentValue = false,
   Callback = function(Value) BringAll = Value end,
})

TargetTab:CreateToggle({
   Name = "Bring All Players (全員集結)",
   CurrentValue = false,
   Callback = function(Value) BringPlayers = Value end,
})

TargetTab:CreateDropdown({
   Name = "Gather Mode (集結場所)",
   Options = {"Self (自分)", "Point (指定場所)"},
   CurrentOption = "Self (自分)",
   Callback = function(Option)
      GatherMode = (Option == "Self (自分)") and "Self" or "Point"
      if GatherMode == "Point" then
          Rayfield:Notify({Title = "Notice", Content = "画面をタップして場所を指定してください"})
      end
   end,
})

-- タップ場所の取得
lp:GetMouse().Button1Down:Connect(function()
    if GatherMode == "Point" then GatherPos = lp:GetMouse().Hit.p end
end)

--- [MOVEMENT TAB: 移動と防御] ---

local AntiFling = false
local GhostMode = false

PlayerTab:CreateToggle({
   Name = "Anti-Fling (絶対不動)",
   CurrentValue = false,
   Callback = function(Value) AntiFling = Value end,
})

PlayerTab:CreateToggle({
   Name = "Ghost Mode (掴み/衝突無効)",
   CurrentValue = false,
   Callback = function(Value) GhostMode = Value end,
})

PlayerTab:CreateSlider({
   Name = "Speed",
   Range = {16, 250},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(v) if lp.Character then lp.Character.Humanoid.WalkSpeed = v end end,
})

--- [CORE LOGIC: メイン動作] ---

RS.Stepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- 防御ロジック
    if AntiFling then hrp.Velocity, hrp.RotVelocity = Vector3.new(0,0,0), Vector3.new(0,0,0) end
    if GhostMode then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- 攻撃/集結ロジック
    local targetCFrame
    if GatherMode == "Self" then
        targetCFrame = hrp.CFrame * CFrame.new(0, 7, -5)
    else
        targetCFrame = CFrame.new(GatherPos + Vector3.new(0, 5, 0))
    end

    if BringAll then
        for _, v in pairs(workspace:GetChildren()) do
            if (v:IsA("Part") or v:IsA("Model")) and not game.Players:GetPlayerFromCharacter(v) then
                local p = v:IsA("Part") and v or v:FindFirstChildWhichIsA("BasePart")
                if p and not p.Anchored then p.CFrame = targetCFrame end
            end
        end
    end

    if BringPlayers then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = targetCFrame
            end
        end
    end

    if FlingAura then
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local tHrp = p.Character.HumanoidRootPart
                if (tHrp.Position - hrp.Position).Magnitude < 10 then
                    tHrp.Velocity = Vector3.new(0, 5000, 0)
                    tHrp.RotVelocity = Vector3.new(500, 5000, 500)
                end
            end
        end
    end
end)

-- 無限リーチ反映
task.spawn(function()
    while true do
        if ReachEnabled and lp.Character then
            local tool = lp.Character:FindFirstChildOfClass("Tool")
            if tool then
                -- FTAPの掴み距離に関連する数値を強制書き換え
                pcall(function()
                    if tool:FindFirstChild("Handle") then
                        tool.Handle.Size = Vector3.new(ReachDistance, ReachDistance, ReachDistance)
                        tool.Handle.Transparency = 0.9 -- 巨大化しても邪魔にならないよう透明に
                    end
                end)
            end
        end
        task.wait(0.5)
    end
end)

Rayfield:Notify({Title = "K-HUB LOADED", Content = "Physics God Mode Ready", Duration = 5})
