--[[
    Doughan Hub | Total Domination Edition
    Version: 1.2
    Features: Ultra Fast Steal, UI Purge, Auto Rebirth, Server Hop
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Doughan Hub | TOTAL DOMINATION",
   Icon = 0, 
   LoadingTitle = "Doughan Hub: Ultimate",
   LoadingSubtitle = "by YourName",
   ConfigurationSaving = { Enabled = true, FolderName = "DoughanHub", FileName = "DominationConfig" },
   KeySystem = false
})

local player = game.Players.LocalPlayer
local activeSteal = false
local activeSell = false
local activeRebirthChar = false
local activeAutoRebirth = false

-- [[ 機能 1: UI残像の完全パージ ]]
local function purgeGhostUI()
    local pgui = player:FindFirstChild("PlayerGui")
    if pgui then
        for _, v in pairs(pgui:GetDescendants()) do
            if v:IsA("ScreenGui") and v.Name == "ProximityPromptGui" then
                v.Enabled = false
                for _, element in pairs(v:GetDescendants()) do
                    if element:IsA("Frame") or element:IsA("TextLabel") then
                        element.Visible = false
                    end
                end
            end
        end
    end
end

-- [[ 機能 2: 自動リバース (UI連打) ]]
local function startAutoRebirth()
    while activeAutoRebirth do
        local pgui = player:FindFirstChild("PlayerGui")
        if pgui then
            for _, btn in pairs(pgui:GetDescendants()) do
                if (btn:IsA("TextButton") or btn:IsA("ImageButton")) and btn.Name:lower():find("rebirth") then
                    firesignal(btn.MouseButton1Click)
                end
            end
        end
        task.wait(2)
    end
end

-- [[ 機能 3: コア回収ロジック (Steal & Rebirth Char) ]]
local function startMainLoop()
    while (activeSteal or activeRebirthChar) do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        if root then
            local descendants = game.Workspace:GetDescendants()
            for _, obj in pairs(descendants) do
                if not (activeSteal or activeRebirthChar) then break end
                
                -- ターゲット判定
                local isNormal = activeSteal and obj:IsA("ProximityPrompt") and (obj.Name:lower():find("steal") or obj.ObjectText:find("盗む"))
                local isRebirth = activeRebirthChar and obj:IsA("ProximityPrompt") and (obj.Name:lower():find("rebirth") or obj.ObjectText:lower():find("rebirth"))

                if isNormal or isRebirth then
                    local target = obj.Parent
                    if target and target:IsA("BasePart") then
                        -- ゴリ押しテレポート
                        root.CFrame = target.CFrame
                        task.wait(0.045) -- 同期待機
                        
                        if fireproximityprompt then fireproximityprompt(obj) end
                        
                        -- UI消去
                        obj.Enabled = false
                        task.wait(0.01)
                        obj.Enabled = true
                        purgeGhostUI()
                    end
                end
            end
        end
        task.wait()
    end
end

-- [[ タブ構成 ]]
local MainTab = Window:CreateTab("Auto Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

MainTab:CreateSection("Steal Options")

MainTab:CreateToggle({
   Name = "ABSOLUTE STEAL (Normal Items)",
   CurrentValue = false,
   Flag = "NormalSteal",
   Callback = function(Value)
      activeSteal = Value
      if activeSteal then task.spawn(startMainLoop) end
   end,
})

MainTab:CreateToggle({
   Name = "STEAL REBIRTH CHARACTERS",
   CurrentValue = false,
   Flag = "RebirthChar",
   Callback = function(Value)
      activeRebirthChar = Value
      if activeRebirthChar then task.spawn(startMainLoop) end
   end,
})

MainTab:CreateSection("Progression")

MainTab:CreateToggle({
   Name = "AUTO SELL (Instant TP)",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
      activeSell = Value
      if activeSell then
          task.spawn(function()
              while activeSell do
                  for _, obj in pairs(game.Workspace:GetDescendants()) do
                      if not activeSell then break end
                      if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("sell") or obj.ActionText:find("Sell")) then
                          player.Character.HumanoidRootPart.CFrame = obj.Parent.CFrame
                          task.wait(0.045)
                          if fireproximityprompt then fireproximityprompt(obj) end
                          purgeGhostUI()
                      end
                  end
                  task.wait()
              end
          end)
      end
   end,
})

MainTab:CreateToggle({
   Name = "AUTO REBIRTH (UI Click)",
   CurrentValue = false,
   Flag = "AutoRebirth",
   Callback = function(Value)
      activeAutoRebirth = Value
      if activeAutoRebirth then task.spawn(startAutoRebirth) end
   end,
})

-- [[ 設定タブ機能 ]]
SettingsTab:CreateSection("Server Management")

SettingsTab:CreateButton({
   Name = "Server Hop (別のサーバーへ移動)",
   Callback = function()
      local HttpService = game:GetService("HttpService")
      local TPS = game:GetService("TeleportService")
      local Servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
      for _, s in pairs(Servers.data) do
         if s.playing < s.maxPlayers and s.id ~= game.JobId then
            TPS:TeleportToPlaceInstance(game.PlaceId, s.id)
            break
         end
      end
   end,
})

SettingsTab:CreateSection("Character & UI")

SettingsTab:CreateButton({
   Name = "Anti-AFK (放置対策)",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      player.Idled:Connect(function()
          vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
          wait(1)
          vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
      Rayfield:Notify({Title = "Success", Content = "Anti-AFK Enabled", Duration = 2})
   end,
})

SettingsTab:CreateButton({
   Name = "Force Purge UI",
   Callback = function() purgeGhostUI() end,
})

Rayfield:LoadConfiguration()
