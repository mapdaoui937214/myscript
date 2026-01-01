local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "FTAP Master Hub (Complete)",
   Icon = 0, -- アイコンはニーズに合わせて変更してください (例: 4483362458 など)
   LoadingTitle = "Ultimate FTAP Tools",
   LoadingSubtitle = "by Sirius",
   ShowText = "Open Menu", -- モバイル用メニューボタン
   Theme = "Default",
   ToggleUIKeybind = Enum.KeyCode.RightControl, -- モバイル非推奨、PC向けキーバインド
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "FTAP_MasterConfig",
      FileName = "FullSettings"
   },
   Discord = { Enabled = false, Invite = "noinvitelink" },
   KeySystem = false
})

-- // Global Variables & Settings //
local player = game.Players.LocalPlayer
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local currentSettings = {
    flyEnabled = false,
    flySpeed = 50,
    noclipEnabled = false,
    infJumpEnabled = false,
    wsValue = 16,
    jpValue = 50,
    antiFling = false,
    reachDistance = 50,
    autoGrab = false,
    grabRange = 25,
    autoThrow = false,
    throwForce = 150,
    freezeTarget = false,
    wingEquipped = false,
    targetPlayer = nil, -- テレポートターゲット用
}

local wingParts = {} -- 木の羽のパーツ
local grabbedObject = nil -- 掴んでいるオブジェクトを追跡

-- // Utility Functions //
local function getChar() return player.Character or player.CharacterAdded:Wait() end
local function getHum() return getChar() and getChar():FindFirstChild("Humanoid") end
local function getRoot() return getChar() and getChar():FindFirstChild("HumanoidRootPart") end
local function getCamera() return Workspace.CurrentCamera end

-- Finds the Grab tool in player's backpack or character
local function getGrabTool()
    return player.Backpack:FindFirstChild("Grab") or getChar() and getChar():FindFirstChild("Grab")
end

-- // Feature Implementations //

-- Noclip Logic
RunService.Stepped:Connect(function()
    if currentSettings.noclipEnabled and player.Character then
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Infinite Jump Logic
UserInputService.JumpRequest:Connect(function()
    if currentSettings.infJumpEnabled and getHum() then
        getHum():ChangeState("Jumping")
    end
end)

-- Anti-Fling Logic
RunService.Stepped:Connect(function()
    if currentSettings.antiFling then
        local root = getRoot()
        if root and root.Velocity.Magnitude > 70 then -- 閾値を調整可能
            root.Velocity = Vector3.new(0, 0, 0)
            root.RotVelocity = Vector3.new(0, 0, 0)
            getHum():ChangeState(Enum.HumanoidStateType.Running) -- 状態をリセット
        end
    end
end)

-- Fly V3 Logic (Mobile & Reset Compatible)
local flyBodyVelocity, flyBodyGyro
local function startFly()
    local root = getRoot()
    if not root then return end

    -- Existing Body objects cleanup
    for _, v in pairs(root:GetChildren()) do
        if v:IsA("BodyVelocity") or v:IsA("BodyGyro") then v:Destroy() end
    end

    flyBodyVelocity = Instance.new("BodyVelocity", root)
    flyBodyGyro = Instance.new("BodyGyro", root)
    flyBodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    flyBodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)

    task.spawn(function()
        while currentSettings.flyEnabled and root and root.Parent and getChar() do
            local camera = getCamera()
            local moveDir = getHum() and getHum().MoveDirection or Vector3.new(0,0,0)
            local vertical = 0
            
            -- Mobile: Jump button for ascend, Q/E for PC
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vertical = 1 end
            if UserInputService:IsKeyDown(Enum.KeyCode.Q) then vertical = -1 end -- PC Descend
            if UserInputService:IsKeyDown(Enum.KeyCode.E) then vertical = 1 end -- PC Ascend

            flyBodyVelocity.Velocity = (moveDir * currentSettings.flySpeed) + (Vector3.new(0, vertical, 0) * currentSettings.flySpeed)
            flyBodyGyro.CFrame = camera.CFrame
            task.wait()
        end
        if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
        if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
    end)
end

-- // Wood Wings Logic //
local function createWings()
    for _, v in pairs(wingParts) do if v and v.Parent then v:Destroy() end end
    wingParts = {}

    local root = getRoot()
    if not root then return end
    
    local function makePlank(side, angle)
        local p = Instance.new("Part")
        p.Size = Vector3.new(0.5, 4, 1.2) -- Adjust size for better look
        p.Material = Enum.Material.Wood
        p.BrickColor = BrickColor.new("Dark orange")
        p.CanCollide = false
        p.CanQuery = false
        p.Anchored = false
        p.Parent = getChar() -- Attach to character model

        local weld = Instance.new("Weld")
        weld.Part0 = root
        weld.Part1 = p
        weld.C0 = CFrame.new(side * 1.5, 0.5, 0.6) * CFrame.Angles(0, 0, math.rad(angle))
        weld.Parent = p
        table.insert(wingParts, p)
    end

    -- Right Wing (3 planks)
    makePlank(1, 45)
    makePlank(1.2, 55)
    makePlank(0.8, 35)
    -- Left Wing (3 planks)
    makePlank(-1, -45)
    makePlank(-1.2, -55)
    makePlank(-0.8, -35)

    currentSettings.wingEquipped = true
end

local function removeWings()
    for _, v in pairs(wingParts) do if v and v.Parent then v:Destroy() end end
    wingParts = {}
    currentSettings.wingEquipped = false
end

-- Auto Grab Logic
RunService.Stepped:Connect(function()
    if currentSettings.autoGrab and not grabbedObject then
        local root = getRoot()
        if not root then return end

        local closestPart = nil
        local minDist = currentSettings.grabRange

        for _, v in pairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide and v.Parent ~= player.Character then
                local dist = (root.Position - v.Position).Magnitude
                if dist < minDist then
                    closestPart = v
                    minDist = dist
                end
            end
        end

        if closestPart then
            local grabTool = getGrabTool()
            if grabTool then
                -- Simulate clicking the object
                grabTool:Activate() -- Ensure tool is active
                -- Attempt to 'grab' the part. This usually requires a remote event,
                -- but we can simulate the interaction if the tool is simple enough.
                -- For FTAP, it's often a click on the object.
                grabbedObject = closestPart
            end
        end
    end
end)

-- Auto Throw Logic
RunService.Stepped:Connect(function()
    if currentSettings.autoThrow and grabbedObject then
        local root = getRoot()
        if not root then return end

        local direction = (getCamera().CFrame.LookVector * currentSettings.throwForce)
        if grabbedObject:IsA("BasePart") then
            grabbedObject.AssemblyLinearVelocity = direction
            -- Additional force application if needed
            -- grabbedObject:ApplyImpulse(direction * grabbedObject:GetMass())
        end
        grabbedObject = nil -- Release after throwing
    end
end)

-- Freeze Target Logic
RunService.Stepped:Connect(function()
    if currentSettings.freezeTarget and grabbedObject then
        if grabbedObject:IsA("BasePart") then
            grabbedObject.Anchored = true
        elseif grabbedObject.Parent and grabbedObject.Parent:FindFirstChild("Humanoid") then
            -- If grabbed object is a player, anchor their root part
            local targetRoot = grabbedObject.Parent:FindFirstChild("HumanoidRootPart")
            if targetRoot then targetRoot.Anchored = true end
        end
    end
end)

-- // UI Creation //

local playerTab = Window:CreateTab("Player", 4483362458)
local ftapTab = Window:CreateTab("FTAP Combat", 4483362458)
local wingTab = Window:CreateTab("Wood Wings", 4483362458)
local teleportTab = Window:CreateTab("Teleport", 4483362458)

-- --- Player Tab ---
playerTab:CreateSlider({
   Name = "WalkSpeed",
   Range = {16, 200},
   Increment = 1,
   CurrentValue = currentSettings.wsValue,
   Callback = function(Value)
      currentSettings.wsValue = Value
      if getHum() then getHum().WalkSpeed = Value end
   end,
})

playerTab:CreateSlider({
   Name = "JumpPower",
   Range = {50, 500},
   Increment = 1,
   CurrentValue = currentSettings.jpValue,
   Callback = function(Value)
      currentSettings.jpValue = Value
      if getHum() then
          getHum().JumpPower = Value
          getHum().UseJumpPower = true
      end
   end,
})

playerTab:CreateToggle({
   Name = "Fly V3",
   CurrentValue = currentSettings.flyEnabled,
   Callback = function(Value)
      currentSettings.flyEnabled = Value
      if Value then startFly() else
          if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
          if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
      end
   end,
})

playerTab:CreateSlider({
   Name = "Fly Speed",
   Range = {10, 300},
   Increment = 5,
   CurrentValue = currentSettings.flySpeed,
   Callback = function(Value) currentSettings.flySpeed = Value end,
})

playerTab:CreateToggle({
   Name = "Noclip",
   CurrentValue = currentSettings.noclipEnabled,
   Callback = function(Value) currentSettings.noclipEnabled = Value end,
})

playerTab:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = currentSettings.infJumpEnabled,
   Callback = function(Value) currentSettings.infJumpEnabled = Value end,
})

playerTab:CreateToggle({
   Name = "Anti-Fling (被投げ無効)",
   CurrentValue = currentSettings.antiFling,
   Callback = function(Value) currentSettings.antiFling = Value end,
})

-- --- FTAP Combat Tab ---
ftapTab:CreateSection("Grab & Throw")

ftapTab:CreateToggle({
   Name = "Auto Grab (自動掴み)",
   CurrentValue = currentSettings.autoGrab,
   Callback = function(Value) currentSettings.autoGrab = Value end,
})

ftapTab:CreateSlider({
   Name = "Grab Range (掴み距離)",
   Range = {10, 100},
   Increment = 5,
   CurrentValue = currentSettings.grabRange,
   Callback = function(Value) currentSettings.grabRange = Value end,
})

ftapTab:CreateToggle({
   Name = "Auto Throw (自動投げ)",
   CurrentValue = currentSettings.autoThrow,
   Callback = function(Value) currentSettings.autoThrow = Value end,
})

ftapTab:CreateSlider({
   Name = "Throw Force (投擲力)",
   Range = {50, 500},
   Increment = 10,
   CurrentValue = currentSettings.throwForce,
   Callback = function(Value) currentSettings.throwForce = Value end,
})

ftapTab:CreateToggle({
   Name = "Freeze Grabbed (掴んだ物を固定)",
   CurrentValue = currentSettings.freezeTarget,
   Callback = function(Value) currentSettings.freezeTarget = Value end,
})

ftapTab:CreateButton({
   Name = "Remove All Fences (フェンス削除)",
   Callback = function()
      for _, v in pairs(Workspace:GetDescendants()) do
         if (v.Name == "Fence" or v.Name == "Gate" or v.Name:find("Barrier")) and v:IsA("BasePart") then
            v:Destroy()
         end
      end
   end,
})

-- --- Wood Wings Tab ---
wingTab:CreateToggle({
   Name = "Equip Wood Wings (木の羽を装備)",
   CurrentValue = currentSettings.wingEquipped,
   Callback = function(Value)
      if Value then createWings() else removeWings() end
   end,
})

-- --- Teleport Tab ---
teleportTab:CreateDropdown({
   Name = "Teleport Player",
   Options = (function()
       local options = {}
       for _, p in pairs(Players:GetPlayers()) do
           if p ~= player then table.insert(options, p.Name) end
       end
       return options
   end)(),
   CurrentValue = "None",
   Callback = function(Value)
       currentSettings.targetPlayer = Players:FindFirstChild(Value)
   end,
})

teleportTab:CreateButton({
   Name = "Teleport to Target",
   Callback = function()
       if currentSettings.targetPlayer and currentSettings.targetPlayer.Character and getRoot() then
           local targetRoot = currentSettings.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
           if targetRoot then
               getRoot().CFrame = targetRoot.CFrame + Vector3.new(0, 5, 0) -- ターゲットの少し上にテレポート
           end
       end
   end,
})

teleportTab:CreateButton({
   Name = "Teleport Target to Me",
   Callback = function()
       if currentSettings.targetPlayer and currentSettings.targetPlayer.Character and getRoot() then
           local targetRoot = currentSettings.targetPlayer.Character:FindFirstChild("HumanoidRootPart")
           if targetRoot then
               targetRoot.CFrame = getRoot().CFrame + Vector3.new(0, 5, 0) -- 自分の少し上にテレポート
           end
       end
   end,
})

-- // Reset Handling //
player.CharacterAdded:Connect(function()
    task.wait(0.5) -- Wait for character to fully load
    if getHum() then
        getHum().WalkSpeed = currentSettings.wsValue
        getHum().JumpPower = currentSettings.jpValue
    end
    if currentSettings.flyEnabled then startFly() end
    if currentSettings.wingEquipped then createWings() end -- Re-equip wings on reset
end)

Rayfield:LoadConfiguration()
