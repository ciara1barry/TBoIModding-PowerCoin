POWER_COIN = Isaac.GetItemIdByName("Power Coin")
COBRA_CURSE = Isaac.GetItemIdByName("Cobra")
local totalCollectibles = 0
local POWER_COIN_DAMAGE = 1
local COBRA_DEATH_CHANCE = 0.03

function CollectPowerCoin(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local damageToAdd = POWER_COIN_DAMAGE * itemCount
        player.Damage = player.Damage + damageToAdd
    end
end

function CobraDeathOnCollect(player)
    if player:GetCollectibleCount() > totalCollectibles then
        local rng = player:GetCollectibleRNG(COBRA_CURSE)
        if rng:RandomFloat() < COBRA_DEATH_CHANCE then
            player:Kill()
        end
        totalCollectibles = player:GetCollectibleCount()
    end
end