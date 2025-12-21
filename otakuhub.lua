---

-- ⚡ 💧otaku Target-TeleDrop + ⚙️ AutoCollect Target Ver. (Final GUI + Safe MultiTarget + Chat)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

--=== 共通状態 ===--
local autoEnabled = false
local targetName = nil
local character, humanoidRoot
local fallen = false
local running = true
local falling = false

--=== 設定値 ===--
local TELEPORT_SPEED = 0.005
local DROP_DELAY = 0.006
local BACK_OFFSET = -7.5
local FALL_DISTANCE = 2.5
local VOID_Y = -500
local FALL_TIME = 0.15

local NEAR_DISTANCE = 2.5
local NEAR_REQUIRED = 2

local multiTargets = {}
local currentIndex = 1
local multiMode = false
local lastNearTargets = {}
local lastFallTime = 0


---

-- 💧 otaku取得＆ドロップ関数

local function getotaku()
for _, tool in ipairs(player.Backpack:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
end
for _, tool in ipairs(player.Character:GetChildren()) do
if tool:IsA("Tool") and tool.Name:lower():find("otaku") then return tool end
end
return nil
end

local function dropotakuAt(pos)
local kap = getotaku()
if not kap then return false end
kap.Parent = player.Character
task.wait(0.05)
local handle = kap:FindFirstChild("Handle")
if not handle then return false end
kap.Parent = workspace
handle.Anchored = false
handle.CanCollide = true
handle.Velocity = Vector3.zero
handle.CFrame = CFrame.new(pos + Vector3.new(0,0.5,0))
task.delay(0.05, function() if handle then handle.Anchored=false end end)
return true
end


---

-- 🌌 共通奈落落下関数

local function fallToVoid(y, fallTime)
if falling or not humanoidRoot then return end
falling = true
local startPos = humanoidRoot.Position
local endPos = Vector3.new(startPos.X, y, startPos.Z)
local startTime = tick()
while tick()-startTime < fallTime do
local alpha = (tick()-startTime)/fallTime
humanoidRoot.CFrame = CFrame.new(startPos:Lerp(endPos, alpha))
task.wait()
end
humanoidRoot.CFrame = CFrame.new(endPos)
falling = false
end


---

-- 👤 キャラ更新

local function updateCharacter()
character = player.Character or player.CharacterAdded:Wait()
humanoidRoot = character:WaitForChild("HumanoidRootPart")
fallen = false
end
updateCharacter()
player.CharacterAdded:Connect(updateCharacter)


---

-- 🎯 TeleDropループ

local function startTeleDropLoop()
task.spawn(function()
while running do
task.wait(TELEPORT_SPEED)
if autoEnabled and targetName and humanoidRoot and not fallen then
local target = Players:FindFirstChild(targetName)
if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
local targetRoot = target.Character.HumanoidRootPart
local distance = (targetRoot.Position - humanoidRoot.Position).Magnitude
if distance <= FALL_DISTANCE then
fallen = true
fallToVoid(VOID_Y,FALL_TIME)
else
local lookVec = targetRoot.CFrame.LookVector
local dropPos = targetRoot.Position + (lookVec*BACK_OFFSET)
humanoidRoot.CFrame = CFrame.new(dropPos,targetRoot.Position)
task.spawn(function() task.wait(DROP_DELAY); dropotakuAt(dropPos) end)
end
end
end
end
end)
end
startTeleDropLoop()


---

-- ⚙️ GUI 作成

local gui = Instance.new("ScreenGui")
gui.Name="KapTeleDropGUI"
gui.ResetOnSpawn=false
gui.Parent=player:WaitForChild("PlayerGui")

-- Frame1: TeleDrop
local frame1=Instance.new("Frame")
frame1.Size=UDim2.new(0,220,0,300)
frame1.Position=UDim2.new(0.75,0,0.3,0)
frame1.BackgroundColor3=Color3.fromRGB(25,25,25)
frame1.BackgroundTransparency=0.1
frame1.Active=true
frame1.Draggable=true
frame1.Parent=gui

local title1=Instance.new("TextLabel")
title1.Size=UDim2.new(1,0,0,30)
title1.BackgroundTransparency=1
title1.TextColor3=Color3.fromRGB(255,255,255)
title1.Text="🎯 Target-TeleDrop"
title1.Font=Enum.Font.SourceSansBold
title1.TextSize=18
title1.Parent=frame1

local playerList=Instance.new("ScrollingFrame")
playerList.Size=UDim2.new(1,0,0,200)
playerList.Position=UDim2.new(0,0,0,35)
playerList.CanvasSize=UDim2.new(0,0,0,0)
playerList.ScrollBarThickness=6
playerList.BackgroundTransparency=1
playerList.Parent=frame1

local autoButton1=Instance.new("TextButton")
autoButton1.Size=UDim2.new(1,-10,0,30)
autoButton1.Position=UDim2.new(0,5,1,-40)
autoButton1.Text="Auto: OFF"
autoButton1.TextColor3=Color3.fromRGB(255,255,255)
autoButton1.BackgroundColor3=Color3.fromRGB(60,60,60)
autoButton1.Font=Enum.Font.SourceSansBold
autoButton1.TextSize=16
autoButton1.Parent=frame1

-- Refresh player list
local function refreshPlayerList()
for _, b in ipairs(playerList:GetChildren()) do
if b:IsA("TextButton") then b:Destroy() end
end
local y=0
for _, plr in ipairs(Players:GetPlayers()) do
if plr~=player then
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(1,-10,0,25)
btn.Position=UDim2.new(0,5,0,y)
btn.Text=plr.DisplayName
btn.TextColor3=Color3.new(1,1,1)
btn.BackgroundColor3=Color3.fromRGB(40,40,40)
btn.Font=Enum.Font.SourceSansBold
btn.TextSize=15
btn.MouseButton1Click:Connect(function()
targetName=plr.Name
title1.Text="🎯 Target: "..plr.DisplayName
fallen=false
end)
btn.Parent=playerList
y+=28
end
end
playerList.CanvasSize=UDim2.new(0,0,0,y)
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(refreshPlayerList)
refreshPlayerList()

-- Frame2: AutoCollect
local frame2=Instance.new("Frame")
frame2.Size=UDim2.new(0,200,0,120)
frame2.Position=UDim2.new(0,100,1,-220)
frame2.BackgroundColor3=Color3.fromRGB(40,40,40)
frame2.Visible=false
frame2.Active=true
frame2.Draggable=true
frame2.Parent=gui
Instance.new("UICorner",frame2).CornerRadius=UDim.new(0,10)

local title2=Instance.new("TextLabel")
title2.Text="AutoCollect Target"
title2.Size=UDim2.new(1,0,0,30)
title2.BackgroundTransparency=1
title2.TextColor3=Color3.fromRGB(255,255,255)
title2.Font=Enum.Font.GothamBold
title2.TextSize=18
title2.Parent=frame2

local statusLabel=Instance.new("TextLabel")
statusLabel.Text="ターゲット: なし"
statusLabel.Size=UDim2.new(1,0,0,25)
statusLabel.Position=UDim2.new(0,0,0,30)
statusLabel.BackgroundTransparency=1
statusLabel.TextColor3=Color3.fromRGB(200,200,200)
statusLabel.TextSize=16
statusLabel.Font=Enum.Font.Gotham
statusLabel.Parent=frame2

local toggleButton=Instance.new("TextButton")
toggleButton.Size=UDim2.new(1,-20,0,40)
toggleButton.Position=UDim2.new(0,10,0,70)
toggleButton.BackgroundColor3=Color3.fromRGB(120,120,120)
toggleButton.TextColor3=Color3.fromRGB(255,255,255)
toggleButton.Text="OFF"
toggleButton.Font=Enum.Font.GothamBold
toggleButton.TextSize=20
toggleButton.Parent=frame2
Instance.new("UICorner",toggleButton).CornerRadius=UDim.new(0,8)

-- Gear button
local gearButton=Instance.new("ImageButton")
gearButton.Size=UDim2.new(0,45,0,45)
gearButton.Position=UDim2.new(0,40,1,-120)
gearButton.BackgroundTransparency=1
gearButton.Image="rbxassetid://6034509993"
gearButton.Parent=gui
gearButton.MouseButton1Click:Connect(function() frame2.Visible = not frame2.Visible end)

-- Dragging gear button
local dragging=false
local dragStart,startPos
gearButton.InputBegan:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
dragging=true
dragStart=input.Position
startPos=gearButton.Position
end
end)
gearButton.InputChanged:Connect(function(input)
if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
local delta=input.Position-dragStart
gearButton.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then dragging=false end
end)

-- ボタン同期
local function updateButtons()
if autoEnabled then
autoButton1.Text="Auto: ON"
autoButton1.BackgroundColor3=Color3.fromRGB(0,200,100)
toggleButton.Text="ON"
toggleButton.BackgroundColor3=Color3.fromRGB(0,200,100)
else
autoButton1.Text="Auto: OFF"
autoButton1.BackgroundColor3=Color3.fromRGB(60,60,60)
toggleButton.Text="OFF"
toggleButton.BackgroundColor3=Color3.fromRGB(120,120,120)
end
end
autoButton1.MouseButton1Click:Connect(function() autoEnabled=not autoEnabled; updateButtons() end)
toggleButton.MouseButton1Click:Connect(function() autoEnabled=not autoEnabled; updateButtons() end)

-- AutoCollectクリック
local targetClick=nil
mouse.Button1Down:Connect(function()
if mouse.Target and mouse.Target:FindFirstChildOfClass("ClickDetector") then
targetClick=mouse.Target:FindFirstChildOfClass("ClickDetector")
statusLabel.Text="ターゲット: "..mouse.Target.Name
end
end)
task.spawn(function()
while true do
task.wait(0.3)
if autoEnabled and targetClick then
pcall(function() fireclickdetector(targetClick) end)
end
end
end)

-- 🎯 MultiTarget & Skip (Chat対応) - 奈落ループ防止版

local function switchToNextTarget()
if #multiTargets == 0 then return end
currentIndex += 1
if currentIndex > #multiTargets then currentIndex = 1 end
local nextTarget = Players:FindFirstChild(multiTargets[currentIndex])
if nextTarget then
targetName = nextTarget.Name
title1.Text = "🎯 skip to: "..nextTarget.DisplayName.." ("..currentIndex.."/"..#multiTargets..")"
statusLabel.Text = "ターゲット: "..nextTarget.DisplayName
updateButtons()
end
end

player.Chatted:Connect(function(msg)
msg = msg:lower()
if msg:sub(1,7) == "target " then
local args = {}
for word in msg:gmatch("%S+") do table.insert(args, word) end
table.remove(args,1)
if #args == 1 and args[1] == "off" then
multiTargets = {}
currentIndex = 1
multiMode = false
targetName = nil
autoEnabled = false
updateButtons()
title1.Text = "🎯 Target-TeleDrop"
statusLabel.Text = "ターゲット: なし"
print("[Multi OFF]")
return
end
multiTargets = {}
for _, arg in ipairs(args) do
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player and (plr.Name:lower():find(arg) or plr.DisplayName:lower():find(arg)) then
table.insert(multiTargets, plr.Name)
break
end
end
end
if #multiTargets > 0 then
multiMode = true
currentIndex = 1
targetName = multiTargets[currentIndex]
autoEnabled = true
updateButtons()
local target = Players:FindFirstChild(targetName)
if target then
title1.Text = "🎯 MultiTarget: "..target.DisplayName.." ("..currentIndex.."/"..#multiTargets..")"
statusLabel.Text = "ターゲット: "..target.DisplayName
print("[MultiTarget ON] "..target.DisplayName)
end
else
print("[ERROR] 該当プレイヤーが見つかりません")
end
end
if msg == "skip" and multiMode then switchToNextTarget() end
end)

-- キャラクター再生成時の処理（奈落ループ防止）
player.CharacterAdded:Connect(function(char)
task.wait(0.5)
character = char
humanoidRoot = char:WaitForChild("HumanoidRootPart")

-- フラグをリセット
fallen = false
falling = false

-- MultiTargetが有効なら次のターゲットに切替（奈落落下は呼ばない）
if multiMode and #multiTargets > 0 then
switchToNextTarget()
end

end)

-- HeartBeat MultiTarget近接判定
RunService.Heartbeat:Connect(function()
if falling or not autoEnabled or #multiTargets == 0 or not humanoidRoot then return end
local now = tick()
if now - lastFallTime < 1 then return end

local nearTargets = {}
for _, name in ipairs(multiTargets) do
local t = Players:FindFirstChild(name)
if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
local dist = (t.Character.HumanoidRootPart.Position - humanoidRoot.Position).Magnitude
if dist <= NEAR_DISTANCE then table.insert(nearTargets, name) end
end
end

-- 離脱スキップ
for _, oldName in ipairs(lastNearTargets) do
local stillNear = false
for _, newName in ipairs(nearTargets) do
if newName == oldName then stillNear = true; break end
end
if not stillNear and #multiTargets > 1 then switchToNextTarget() end
end

-- 同時接近判定
if #multiTargets > 1 and #nearTargets >= NEAR_REQUIRED then
lastFallTime = now
fallToVoid(VOID_Y, FALL_TIME)
end

lastNearTargets = nearTargets

end)


---

-- 🎨 プレイヤー状態色管理（歩行/座る/ターゲット）

local walkingTime = {}

RunService.Heartbeat:Connect(function()
for _, btn in ipairs(playerList:GetChildren()) do
if not btn:IsA("TextButton") then continue end

-- 対応プレイヤー取得
local plr
for _, p in ipairs(Players:GetPlayers()) do
if p.DisplayName == btn.Text then
plr = p
break
end
end
if not plr or not plr.Character then continue end

local humanoid = plr.Character:FindFirstChildOfClass("Humanoid")
local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
if not humanoid or not hrp then continue end

-- 歩行判定初期化
if not walkingTime[plr] then walkingTime[plr] = { lastMove = tick(), moving = false } end

-- 歩行判定
if hrp.Velocity.Magnitude > 1 then
if not walkingTime[plr].moving then
walkingTime[plr].moving = true
walkingTime[plr].lastMove = tick()
end
else
if walkingTime[plr].moving and tick() - walkingTime[plr].lastMove > 3 then
walkingTime[plr].moving = false
end
end

local isWalkingLong = walkingTime[plr].moving and tick() - walkingTime[plr].lastMove >= 3
local isSitting = humanoid.SeatPart ~= nil
local isTarget = (targetName == plr.Name)

-- TeleDrop GUIボタン色更新
if isSitting then
btn.BackgroundColor3 = Color3.fromRGB(255,60,60) -- 赤
btn.TextColor3 = Color3.fromRGB(255,255,255)
elseif isWalkingLong then
btn.BackgroundColor3 = Color3.fromRGB(0,120,255) -- 青
btn.TextColor3 = Color3.fromRGB(255,255,255)
elseif isTarget then
btn.BackgroundColor3 = Color3.fromRGB(0,200,100) -- 緑
btn.TextColor3 = Color3.fromRGB(255,255,255)
else
btn.BackgroundColor3 = Color3.fromRGB(40,40,40) -- デフォルト
btn.TextColor3 = Color3.fromRGB(200,200,200)
end

-- AutoCollect GUI statusLabel色も連動
if statusLabel.Text:find(plr.DisplayName) then
if isSitting then
statusLabel.TextColor3 = Color3.fromRGB(255,60,60)
elseif isWalkingLong then
statusLabel.TextColor3 = Color3.fromRGB(0,120,255)
elseif isTarget then
statusLabel.TextColor3 = Color3.fromRGB(0,200,100)
else
statusLabel.TextColor3 = Color3.fromRGB(200,200,200)
end
end
end

end)

-- 💬 Commander Target System（司令役チャット制御）

local commanderName = nil
local commanderFrame = Instance.new("Frame")
commanderFrame.Size = UDim2.new(0, 220, 0, 120)
commanderFrame.Position = UDim2.new(0.75, 0, 0.65, 0)
commanderFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
commanderFrame.BackgroundTransparency = 0.1
commanderFrame.Active = true
commanderFrame.Draggable = true
commanderFrame.Parent = gui

local titleC = Instance.new("TextLabel")
titleC.Size = UDim2.new(1, 0, 0, 25)
titleC.Text = "🗣️ Commander Control"
titleC.Font = Enum.Font.SourceSansBold
titleC.TextSize = 18
titleC.TextColor3 = Color3.fromRGB(255, 255, 255)
titleC.BackgroundTransparency = 1
titleC.Parent = commanderFrame

local commanderList = Instance.new("ScrollingFrame")
commanderList.Size = UDim2.new(1, 0, 0, 70)
commanderList.Position = UDim2.new(0, 0, 0, 30)
commanderList.CanvasSize = UDim2.new(0, 0, 0, 0)
commanderList.ScrollBarThickness = 6
commanderList.BackgroundTransparency = 1
commanderList.Parent = commanderFrame

local cmdStatus = Instance.new("TextLabel")
cmdStatus.Size = UDim2.new(1, 0, 0, 25)
cmdStatus.Position = UDim2.new(0, 0, 1, -25)
cmdStatus.BackgroundTransparency = 1
cmdStatus.TextColor3 = Color3.fromRGB(200, 200, 200)
cmdStatus.TextSize = 16
cmdStatus.Text = "司令役: なし"
cmdStatus.Font = Enum.Font.SourceSans
cmdStatus.Parent = commanderFrame

-- Commander list refresh
local function refreshCommanderList()
for _, b in ipairs(commanderList:GetChildren()) do
if b:IsA("TextButton") then b:Destroy() end
end
local y = 0
for _, plr in ipairs(Players:GetPlayers()) do
if plr ~= player then
local btn = Instance.new("TextButton")
btn.Size = UDim2.new(1, -10, 0, 25)
btn.Position = UDim2.new(0, 5, 0, y)
btn.Text = plr.DisplayName
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 15
btn.MouseButton1Click:Connect(function()
commanderName = plr.Name
cmdStatus.Text = "司令役: " .. plr.DisplayName
print("[Commander set to " .. plr.DisplayName .. "]")
end)
btn.Parent = commanderList
y += 28
end
end
commanderList.CanvasSize = UDim2.new(0, 0, 0, y)
end
Players.PlayerAdded:Connect(refreshCommanderList)
Players.PlayerRemoving:Connect(refreshCommanderList)
refreshCommanderList()

-- Commander Chat listener
Players.PlayerAdded:Connect(function(plr)
plr.Chatted:Connect(function(msg)
if commanderName and plr.Name == commanderName then
local text = msg:lower()
if text == "off" then
autoEnabled = false
targetName = nil
multiTargets = {}
multiMode = false
updateButtons()
title1.Text = "🎯 Target-TeleDrop"
statusLabel.Text = "ターゲット: なし"
print("[Commander OFF]")
return
end

for _, t in ipairs(Players:GetPlayers()) do
if t ~= player and (t.Name:lower():find(text) or t.DisplayName:lower():find(text)) then
targetName = t.Name
autoEnabled = true
updateButtons()
title1.Text = "🎯 CmdTarget: " .. t.DisplayName
statusLabel.Text = "ターゲット: " .. t.DisplayName
print("[Commander Target] " .. t.DisplayName)
return
end
end
end
end)

end)

-- Also attach for existing players
for _, plr in ipairs(Players:GetPlayers()) do
plr.Chatted:Connect(function(msg)
if commanderName and plr.Name == commanderName then
local text = msg:lower()
if text == "off" then
autoEnabled = false
targetName = nil
multiTargets = {}
multiMode = false
updateButtons()
title1.Text = "🎯 Target-TeleDrop"
statusLabel.Text = "ターゲット: なし"
print("[Commander OFF]")
return
end

for _, t in ipairs(Players:GetPlayers()) do
if t ~= player and (t.Name:lower():find(text) or t.DisplayName:lower():find(text)) then
targetName = t.Name
autoEnabled = true
updateButtons()
title1.Text = "🎯 CmdTarget: " .. t.DisplayName
statusLabel.Text = "ターゲット: " .. t.DisplayName
print("[Commander Target] " .. t.DisplayName)
return
end
end
end
end)

end
-- 💀 死亡時にループ停止
local function onDeath()
autoEnabled = false -- Auto動作停止
fallen = true -- TeleDrop停止フラグ
falling = false -- 奈落落下停止
targetName = nil -- ターゲット解除
multiTargets = {} -- マルチターゲット解除
multiMode = false
updateButtons() -- GUI更新
title1.Text = "🎯 Target-TeleDrop"
statusLabel.Text = "ターゲット: なし"
print("[Player Died] TeleDropループ停止")
end

-- キャラクター死亡イベント接続
if character then
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
humanoid.Died:Connect(onDeath)
end
end

-- キャラクター再生成時も死亡イベントを再接続
player.CharacterAdded:Connect(function(char)
character = char
humanoidRoot = char:WaitForChild("HumanoidRootPart")
fallen = false
falling = false

local humanoid = char:WaitForChild("Humanoid")
humanoid.Died:Connect(onDeath)

-- MultiTargetが有効なら次ターゲットに切替（奈落落下は呼ばない）
if multiMode and #multiTargets > 0 then
switchToNextTarget()
end

end)
-- 🪑 ターゲットが椅子に座ったら自動死亡（即死）

RunService.Heartbeat:Connect(function()
if not autoEnabled or not targetName then return end
local target = Players:FindFirstChild(targetName)
if not target or not target.Character then return end

local humanoid = target.Character:FindFirstChildOfClass("Humanoid")
if humanoid and humanoid.SeatPart then
-- 座った瞬間に自分を殺す
local myHumanoid = character and character:FindFirstChildOfClass("Humanoid")
if myHumanoid and myHumanoid.Health > 0 then
print("[AUTO-DEATH] Target "..target.DisplayName.." is sitting! Killing self.")
myHumanoid:TakeDamage(999999)
end
end
end)
-- 🚫 自分が椅子に座れないようにする（ローカル防止）
RunService.Heartbeat:Connect(function()
local char = player.Character
if not char then return end
local hum = char:FindFirstChildOfClass("Humanoid")
if hum and hum.SeatPart then
hum.Sit = false -- 強制で立たせる
hum:ChangeState(Enum.HumanoidStateType.GettingUp)
end
end)
