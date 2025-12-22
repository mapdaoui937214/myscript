local MY_USER_ID = 9391592113
local lp = game:GetService("Players").LocalPlayer

local old = lp.PlayerGui:FindFirstChild("UltimateSystem")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
sg.Name = "UltimateSystem"
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 180, 0, 55)
btn.Position = UDim2.new(0.5, -90, 0.2, 0)
btn.Text = "INITIALIZE SYSTEM"
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.TextColor3 = Color3.fromRGB(0, 255, 150)
btn.Font = Enum.Font.SourceSansBold
btn.TextSize = 18
btn.BorderSizePixel = 2
btn.BorderColor3 = Color3.fromRGB(0, 255, 150)
btn.Active = true

local dragging, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
btn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

local function Execute()
    if lp.UserId ~= MY_USER_ID then return end
    
    local KAI = _G.Admins or _G.KohlAdmin or (getgenv and (getgenv().Admins or getgenv().KohlAdmin))
    if not KAI and getreg then
        for _, v in pairs(getreg()) do
            if type(v) == "table" and rawget(v, "AddAdmin") and rawget(v, "RemoveAdmin") then
                KAI = v
                break
            end
        end
    end

    if KAI then
        KAI.AddAdmin(lp, 6)
        btn.Text = "SYSTEM: CREATOR"
        btn.BackgroundColor3 = Color3.fromRGB(0, 80, 0)
        
        if not _G.GlobalHandler then
            _G.GlobalHandler = true
            lp.Chatted:Connect(function(msg)
                local args = msg:split(" ")
                if #args < 2 then return end
                local cmd, name = args[1]:lower(), args[2]:lower()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Name:lower():find(name) then
                        if cmd == ".give" then KAI.AddAdmin(p, 3)
                        elseif cmd == ".take" then KAI.RemoveAdmin(p) end
                    end
                end
            end)
        end
    else
        for _, v in ipairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") and (v.Name:find("Admin") or v.Name:find("Kohl")) then
                v:FireServer("AddAdmin", lp, 6)
            end
        end
        btn.Text = "FORCED OVERRIDE"
        btn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    end
end

btn.MouseButton1Click:Connect(Execute)

task.spawn(function()
    while true do
        pcall(Execute)
        task.wait(10)
    end
end)
