local MY_USER_ID = 9391592113
local lp = game:GetService("Players").LocalPlayer

local sg = Instance.new("ScreenGui", lp:WaitForChild("PlayerGui"))
sg.ResetOnSpawn = false

local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 150, 0, 50)
btn.Position = UDim2.new(0.5, -75, 0.1, 0)
btn.Text = "Activate Admin"
btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Draggable = true
btn.Active = true

local function GetKAI()
    local api = _G.Admins or _G.KohlAdmin or (getgenv and (getgenv().Admins or getgenv().KohlAdmin))
    if not api and getreg then
        for _, v in pairs(getreg()) do
            if type(v) == "table" and rawget(v, "AddAdmin") and rawget(v, "RemoveAdmin") then
                return v
            end
        end
    end
    return api
end

btn.MouseButton1Click:Connect(function()
    if lp.UserId ~= MY_USER_ID then return end
    
    local KAI = GetKAI()
    if KAI then
        KAI.AddAdmin(lp, 6)
        btn.Text = "Success!"
        btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "Admin System",
            Text = "Rank: Creator Activated",
            Duration = 5
        })

        if not _G.AdminCmdLoaded then
            _G.AdminCmdLoaded = true
            lp.Chatted:Connect(function(msg)
                local args = msg:split(" ")
                if #args < 2 then return end
                local cmd, name = args[1]:lower(), args[2]:lower()
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Name:lower():find(name) then
                        if cmd == ";give" then KAI.AddAdmin(p, 3)
                        elseif cmd == ";take" then KAI.RemoveAdmin(p) end
                    end
                end
            end)
        end
    else
        btn.Text = "KAI Not Found"
        btn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
    end
end)
