POWER_COIN = Isaac.GetItemIdByName("Power Coin")
local POWER_COIN_DAMAGE = 1

function CollectPowerCoin(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local damageToAdd = POWER_COIN_DAMAGE * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end