--[[
    Doughan Hub | Absolute Steal Special
    Version: 1.4
    Fix: Stable Server Hop & Fast Steal
]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Doughan Hub | ABSOLUTE STEAL",
   Icon = 0, 
   LoadingTitle = "Doughan Hub: Stable Edition",
   LoadingSubtitle = "Item Stealing Specialist",
   ConfigurationSaving = { Enabled = true, FolderName = "DoughanHub", FileName = "StealConfig" },
   KeySystem = false
})

local player = game.Players.LocalPlayer
local activeSteal = false
local activeSell = false

-- [[ UI残像パージ ]]
local function purgeGhostUI()
    local pgui = player:FindFirstChild("PlayerGui")
    if pgui then
        for _, v in pairs(pgui:GetDescendants()) do
            if v:IsA("ScreenGui") and v.Name == "ProximityPromptGui" then
                v.Enabled = false
            end
        end
    end
end

-- [[ 改良版サーバーホップ (エラー対策済み) ]]
local function stableServerHop()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local api_url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(api_url))
    end)
    
    if success and result and result.data then
        for _, server in pairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                Rayfield:Notify({Title = "Teleporting", Content = "空きサーバーを見つけました。移動します...", Duration = 3})
                local tpSuccess, tpError = pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, player)
                end)
                if not tpSuccess then
                    warn("Teleport Error: " .. tostring(tpError))
                end
                return
            end
        end
    end
    Rayfield:Notify({Title = "Error", Content = "サーバーが見つかりませんでした。もう一度試してください。", Duration = 3})
end

-- [[ 回収メインループ ]]
local function startStealLoop()
    while activeSteal do
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root then
            for _, obj in pairs(game.Workspace:GetDescendants()) do
                if not activeSteal then break end
                if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("steal") or obj.ObjectText:find("盗む")) then
                    local target = obj.Parent
                    if target and target:IsA("BasePart") then
                        root.CFrame = target.CFrame
                        task.wait(0.045)
                        if fireproximityprompt then fireproximityprompt(obj) end
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

-- [[ UI ]]
local MainTab = Window:CreateTab("Steal Farm", 4483362458)
local SettingsTab = Window:CreateTab("Settings", 4483362458)

MainTab:CreateToggle({
   Name = "ABSOLUTE STEAL (Full Map)",
   CurrentValue = false,
   Flag = "AbsSteal",
   Callback = function(Value)
      activeSteal = Value
      if activeSteal then task.spawn(startStealLoop) end
   end,
})

MainTab:CreateToggle({
   Name = "AUTO SELL (Instant TP)",
   CurrentValue = false,
   Flag = "AutoSell",
   Callback = function(Value)
      activeSell = Value
      if activeSell then
          task.spawn(function()
              while activeSell do
                  local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                  if root and activeSell then
                      for _, obj in pairs(game.Workspace:GetDescendants()) do
                          if not activeSell then break end
                          if obj:IsA("ProximityPrompt") and (obj.Name:lower():find("sell") or obj.ActionText:find("Sell")) then
                              root.CFrame = obj.Parent.CFrame
                              task.wait(0.045)
                              if fireproximityprompt then fireproximityprompt(obj) end
                          end
                      end
                  end
                  task.wait()
              end
          end)
      end
   end,
})

SettingsTab:CreateButton({
   Name = "Stable Server Hop (別のサーバーへ移動)",
   Callback = function()
      stableServerHop()
   end,
})

SettingsTab:CreateButton({
   Name = "Rejoin Server (現在のサーバーに入り直す)",
   Callback = function()
      game:GetService("TeleportService"):Teleport(game.PlaceId, player)
   end,
})

SettingsTab:CreateButton({
   Name = "Anti-AFK",
   Callback = function()
      local vu = game:GetService("VirtualUser")
      player.Idled:Connect(function()
          vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
          wait(1)
          vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
      end)
   end,
})

Rayfield:LoadConfiguration()
