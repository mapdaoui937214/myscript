local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FTAP 究極マスターハック | Mobile",
   Icon = 0,
   LoadingTitle = "FTAP Ultimate Suite",
   LoadingSubtitle = "by Sirius",
   ShowText = "Menu", 
   Theme = "Default",
   ConfigurationSaving = { Enabled = false },
   KeySystem = false
})

-- // 変数管理 //
local player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local flySpeed = 70
local flyActive = false
local wsValue = 16 
local reachValue = 15
local throwPower = 1
local antiGrab = false
local wingParts = {}

local function getChar() return player.Character end
local function getHum() return getChar() and getChar():FindFirstChild("Humanoid") end
local function getRoot() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end

-- // 1. コア・ロジック (スピード/リーチ/投げ/アンチグラブ) //
task.spawn(function()
    while task.wait() do
        pcall(function()
            local char = getChar()
            local hum = getHum()
            local root = getRoot()
            
            -- スピードハック (CFrameテレポート方式でアンチチート突破)
            if hum and root and not flyActive and wsValue > 16 then
                if hum.MoveDirection.Magnitude > 0 then
                    root.CFrame = root.CFrame + (hum.MoveDirection * (wsValue / 50))
                end
            end
            
            -- FTAP ツール強化 (リーチと投げ)
            local grab = player.Backpack:FindFirstChild("Grab") or char:FindFirstChild("Grab")
            if grab then
                -- 掴み距離の書き換え
                for _, v in pairs(grab:GetDescendants()) do
                    if v.Name == "MaxDistance" or v.Name == "Distance" then v.Value = reachValue end
                end
                -- 投げ飛ばす力の強化
                if grab:FindFirstChild("ThrowForce") then
                    grab.ThrowForce.Value = 100 * throwPower
                end
            end

            -- アンチ・グラブ (他人に掴ませない)
            if antiGrab and char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanTouch = false end
                end
            elseif char then
                for _, v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanTouch = true end
                end
            end
        end)
    end
end)

-- // 2. 木の羽 (ウィング) 装着機能 //
local function equipWings()
    for _, v in pairs(wingParts) do if v then v:Destroy() end end
    wingParts = {}
    local root = getRoot()
    if not root then return end
    
    -- 画像を元にした「木の板」の配置データ
    local offsets = {
        {off = Vector3.new(1.5, 0.5, 0.6), ang = 45}, {off = Vector3.new(1.8, 1, 0.6), ang = 65},
        {off = Vector3.new(-1.5, 0.5, 0.6), ang = -45}, {off = Vector3.new(-1.8, 1, 0.6), ang = -65}
    }
    for _, d in ipairs(offsets) do
        local p = Instance.new("Part", getChar())
        p.Size = Vector3.new(0.5, 4, 1.2)
        p.Material = Enum.Material.Wood
        p.BrickColor = BrickColor.new("Dark orange")
        p.CanCollide = false
        local w = Instance.new("Weld", p)
        w.Part0 = root
        w.Part1 = p
        w.C0 = CFrame.new(d.off) * CFrame.Angles(0, 0, math.rad(d.ang))
        table.insert(wingParts, p)
    end
end

-- // UI タブ構築 //
local MainTab = Window:CreateTab("メイン", 4483362458)
local FtapTab = Window:CreateTab("FTAP 強化", 4483362458)

-- --- メインタブ ---
MainTab:CreateSlider({
   Name = "移動スピード (CFrame)",
   Range = {16, 250},
   Increment = 5,
   CurrentValue = 16,
   Callback = function(V) wsValue = V end,
})

MainTab:CreateToggle({
   Name = "ボタン Fly (カメラ方向)",
   CurrentValue = false,
   Callback = function(V)
      flyActive = V
      if V then
          local bv = Instance.new("BodyVelocity", getRoot())
          bv.Name = "FlyForce"
          bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
          task.spawn(function()
              while flyActive do
                  if getRoot() then
                      getRoot().Velocity = workspace.CurrentCamera.CFrame.LookVector * flySpeed
                      if getRoot():FindFirstChild("FlyForce") then getRoot().FlyForce.Velocity = getRoot().Velocity end
                  end
                  task.wait()
              end
              if getRoot() and getRoot():FindFirstChild("FlyForce") then getRoot().FlyForce:Destroy() end
          end)
      end
   end,
})

MainTab:CreateSlider({
   Name = "飛行スピード",
   Range = {10, 500},
   Increment = 10,
   CurrentValue = 70,
   Callback = function(V) flySpeed = V end,
})

MainTab:CreateButton({
   Name = "木の羽を装備 (画像再現)",
   Callback = function() equipWings() end,
})

MainTab:CreateToggle({
   Name = "無限ジャンプ",
   CurrentValue = false,
   Callback = function(V) _G.InfJump = V end,
})

-- --- FTAP タブ ---
FtapTab:CreateSlider({
   Name = "掴み距離 (Reach)",
   Range = {10, 150},
   Increment = 5,
   CurrentValue = 15,
   Callback = function(V) reachValue = V end,
})

FtapTab:CreateSlider({
   Name = "投げ飛ばし倍率",
   Range = {1, 10},
   Increment = 1,
   CurrentValue = 1,
   Callback = function(V) throwPower = V end,
})

FtapTab:CreateToggle({
   Name = "アンチ・グラブ (掴まれない)",
   CurrentValue = false,
   Callback = function(V) antiGrab = V end,
})

FtapTab:CreateToggle({
   Name = "プレイヤー透視 (ESP)",
   CurrentValue = false,
   Callback = function(V)
      _G.ESP = V
      while _G.ESP do
          for _, p in pairs(game.Players:GetPlayers()) do
              if p ~= player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                  if not p.Character.HumanoidRootPart:FindFirstChild("Highlight") then
                      local h = Instance.new("Highlight", p.Character.HumanoidRootPart)
                      h.FillColor = Color3.fromRGB(255, 0, 0)
                  end
              end
          end
          task.wait(1)
      end
      -- OFF時に削除
      for _, p in pairs(game.Players:GetPlayers()) do
          if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character.HumanoidRootPart:FindFirstChild("Highlight") then
              p.Character.HumanoidRootPart.Highlight:Destroy()
          end
      end
   end,
})

FtapTab:CreateButton({
   Name = "邪魔なフェンスを全削除",
   Callback = function()
      for _, v in pairs(workspace:GetDescendants()) do
         if (v.Name == "Fence" or v.Name:find("Barrier")) and v:IsA("BasePart") then v:Destroy() end
      end
   end,
})

-- 無限ジャンプ実行部
game:GetService("UserInputService").JumpRequest:Connect(function()
    if _G.InfJump and getHum() then getHum():ChangeState("Jumping") end
end)

Rayfield:LoadConfiguration()
