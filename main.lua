local mod = RegisterMod("Power Coin", 1)
local powerCoin = Isaac.GetItemIdByName("Power Coin")
local powerCoinDamage = 1

function mod:EvaluateCache(player, cacheFlags)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local itemCount = player:GetCollectibleNum(powerCoin)
        local damageToAdd = powerCoinDamage * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)

local powerMorpher = Isaac.GetItemIdByName("Power Morpher")

function mod:PowerMorpherUse(item)
    local player = Isaac.GetPlayer(0)
    local itemCount = player:GetCollectibleNum(powerCoin)
    if itemCount > 0 then
        player.Damage = (player.Damage * 1.5) + 1.5 else
            player.Damage = player.Damage + 1.5
    end

    return {
        Discharge = true,
        Remove = false,
        ShowAnim = true
    }
end

mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, powerMorpher)