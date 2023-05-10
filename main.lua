local mod = RegisterMod("Power Coin", 1)
local powerCoin = Isaac.GetItemIdByName("Power Coin")
local powerCoinDamage = 1
local powerMorpher = Isaac.GetItemIdByName("Power Morpher")
local brokenPowerMorpher = Isaac.GetItemIdByName("Broken Power Morpher")
local useCount = 0

function mod:EnterNewRoom()
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(powerCoin)
    if useCount > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage - 1.5)/1.5 else
                player.Damage = player.Damage - 1.5
        end 
        useCount = 0
    end
end

function mod:EvaluateCache(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(powerCoin)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local damageToAdd = powerCoinDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
    
    if useCount > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage * 1.5) + 1.5 elseif itemCount == 0 then
                player.Damage = player.Damage + 1.5
        end
    end
end

function mod:PowerMorpherUse(item)
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(powerCoin)
    
    if itemCount > 0 then
        if item == brokenPowerMorpher then
            local brokenHeartChance = math.random(1, 10)
            if brokenHeartChance <= 5 then
                player:AddBrokenHearts(1)
            end
        elseif item == powerMorpher then
            player:AddSoulHearts(2)
        end
    end
    
    if itemCount > 0 and useCount == 0 then
        player.Damage = (player.Damage * 1.5) + 1.5
        useCount = useCount + 1 elseif itemCount == 0 and useCount == 0 then
            player.Damage = player.Damage + 1.5
            useCount = useCount + 1
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.EnterNewRoom)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, powerMorpher)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, brokenPowerMorpher)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)