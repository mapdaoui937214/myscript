local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FTAP MOBILE GOD V3 📱",
   LoadingTitle = "Ultimate Physics Suite",
   Theme = "Default",
   ConfigurationSaving = { Enabled = true, FolderName = "FTAP_God" }
})

-- タブ設定
local MainTab = Window:CreateTab("Main (物理)", 4483362458)
local PlayerTab = Window:CreateTab("Player (自分)", 4483362458)
local VisualTab = Window:CreateTab("Visuals (透視)", 4483362458)

-- 変数
local lp = game.Players.LocalPlayer
local RS = game:GetService("RunService")
local VU = game:GetService("VirtualUser")

--- [MAIN TAB: 物理制御] ---

local AntiFling = false
MainTab:CreateToggle({
   Name = "Anti-Fling (絶対不動)",
   CurrentValue = false,
   Callback = function(Value) AntiFling = Value end,
})

local GhostMode = false
MainTab:CreateToggle({
   Name = "Ghost Mode (掴み無効化)",
   CurrentValue = false,
   Callback = function(Value) GhostMode = Value end,
})

local FlingAura = false
MainTab:CreateToggle({
   Name = "Kill Aura Fling (自動撃退)",
   CurrentValue = false,
   Callback = function(Value) FlingAura = Value end,
})

local Magnet = false
MainTab:CreateToggle({
   Name = "Item Magnet (周囲の物を吸い寄せ)",
   CurrentValue = false,
   Callback = function(Value) Magnet = Value end,
})

--- [PLAYER TAB: 自己強化] ---

PlayerTab:CreateSlider({
   Name = "WalkSpeed (スピード)",
   Range = {16, 300},
   Increment = 1,
   CurrentValue = 16,
   Callback = function(Value)
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
          lp.Character.Humanoid.WalkSpeed = Value
      end
   end,
})

PlayerTab:CreateSlider({
   Name = "JumpPower (ジャンプ力)",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = 50,
   Callback = function(Value)
      if lp.Character and lp.Character:FindFirstChild("Humanoid") then
          lp.Character.Humanoid.UseJumpPower = true
          lp.Character.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateButton({
   Name = "Enable Anti-AFK (放置落ち防止)",
   Callback = function()
       lp.Idled:Connect(function()
           VU:CaptureController()
           VU:ClickButton2(Vector2.new(0,0))
       end)
       Rayfield:Notify({Title = "System", Content = "Anti-AFK Activated", Duration = 2})
   end,
})

--- [VISUAL TAB: 透視・ESP] ---

local ESPEnabled = false
VisualTab:CreateToggle({
   Name = "Player ESP (プレイヤー表示)",
   CurrentValue = false,
   Callback = function(Value) 
      ESPEnabled = Value 
      if not Value then
          for _, p in pairs(game.Players:GetPlayers()) do
              if p.Character and p.Character:FindFirstChild("Highlight") then p.Character.Highlight:Destroy() end
          end
      end
   end,
})

--- [CORE LOGIC: メイン動作] ---

-- 物理ループ (Steppedで実行することで物理エンジンに勝つ)
RS.Stepped:Connect(function()
    local char = lp.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hrp = char.HumanoidRootPart

    -- 絶対に飛ばされない
    if AntiFling then
        hrp.Velocity = Vector3.new(0, 0, 0)
        hrp.RotVelocity = Vector3.new(0, 0, 0)
    end

    -- 掴み判定を消す
    if GhostMode then
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end

    -- フリングオーラ (周囲の相手をバグらせる)
    if FlingAura then
        hrp.RotVelocity = Vector3.new(0, 20000, 0) -- 超高速回転
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local dist = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                if dist < 10 then -- 半径10以内の敵を飛ばす
                    p.Character.HumanoidRootPart.Velocity = Vector3.new(0, 1000, 0)
                end
            end
        end
    end
end)

-- アイテム磁石ループ
task.spawn(function()
    while true do
        if Magnet and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = lp.Character.HumanoidRootPart
            for _, v in pairs(workspace:GetChildren()) do
                -- プレイヤー以外の動かせる物体を対象
                if (v:IsA("Part") or v:IsA("Model")) and not game.Players:GetPlayerFromCharacter(v) then
                    local p = v:IsA("Part") and v or v:FindFirstChildWhichIsA("BasePart")
                    if p and (p.Position - hrp.Position).Magnitude < 25 then
                        p.CFrame = hrp.CFrame + Vector3.new(0, 7, 0) -- 頭上に浮かせる
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- ESPループ
task.spawn(function()
    while true do
        if ESPEnabled then
            for _, p in pairs(game.Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    if not p.Character:FindFirstChild("Highlight") then
                        local hl = Instance.new("Highlight", p.Character)
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                end
            end
        end
        task.wait(1)
    end
end)

Rayfield:LoadConfiguration()
