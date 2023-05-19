POWER_MORPHER = Isaac.GetItemIdByName("Power Morpher")
BROKEN_POWER_MORPHER = Isaac.GetItemIdByName("Broken Power Morpher")
USE_COUNT = 0
local BROKEN_HEART_CHANCE = 0.3

function mod:PowerMorpherUse(item)
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    
    if itemCount > 0 then
        if item == BROKEN_POWER_MORPHER then
            local rng = player:GetCollectibleRNG(BROKEN_POWER_MORPHER)
            if rng:RandomFloat() < BROKEN_HEART_CHANCE then
                player:AddBrokenHearts(1)
            end
        elseif item == POWER_MORPHER then
            player:AddSoulHearts(2)
        end
    end
    
    if itemCount > 0 and USE_COUNT == 0 then
        player.Damage = (player.Damage * 1.5) + 1.5
        USE_COUNT = USE_COUNT + 1 elseif itemCount == 0 and USE_COUNT == 0 then
            player.Damage = player.Damage + 1.5
            USE_COUNT = USE_COUNT + 1
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

function CheckIfPowerMorpherUsed(player, itemCount)
    if USE_COUNT > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage * 1.5) + 1.5 elseif itemCount == 0 then
                player.Damage = player.Damage + 1.5
        end
    end
end

function mod:RemovePMStatsOnFlip(item)
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(POWER_COIN)

    if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS_B then
        if player:HasCollectible(POWER_MORPHER, true) or player:HasCollectible(BROKEN_POWER_MORPHER, true) then
            if USE_COUNT > 0 then
                if itemCount > 0 then
                    player.Damage = (player.Damage - 1.5)/1.5 else
                        player.Damage = player.Damage - 1.5
                end 
                USE_COUNT = 0
            end
        end
    end
end