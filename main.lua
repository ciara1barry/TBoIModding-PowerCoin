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