local mod = RegisterMod("Power Coin", 1)
local powerCoin = Isaac.GetItemIdByName("Power Coin")
local powerCoinDamage = 1
local powerMorpher = Isaac.GetItemIdByName("Power Morpher")
local useCount = 0

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(powerCoin)
        local damageToAdd = powerCoinDamage * itemCount
        player.Damage = player.Damage + damageToAdd
        useCount = 0
    end
end

function mod:PowerMorpherUse(item)
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(powerCoin)

    --[[ old code
    if useCount > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage - 1.5)/1.5 else
                player.Damage = player.Damage - 1.5
        end 
        useCount = 0 else
            if itemCount > 0 then
                player:AddSoulHearts(2)
            end
    end
    --]]
    
    if itemCount > 0 then
        player:AddSoulHearts(2)
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

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, powerMorpher)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)
