mod = RegisterMod("Power Rangers", 1)

include("on_new_room.lua")
include("active_items.lua")

POWER_COIN = Isaac.GetItemIdByName("Power Coin")
local POWER_COIN_DAMAGE = 1

USE_COUNT = 0

function mod:EvaluateCache(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    if cacheFlags & CacheFlag.CACHE_DAMAGE == CacheFlag.CACHE_DAMAGE then
        local damageToAdd = POWER_COIN_DAMAGE * itemCount
        player.Damage = player.Damage + damageToAdd
    end
    
    if USE_COUNT > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage * 1.5) + 1.5 elseif itemCount == 0 then
                player.Damage = player.Damage + 1.5
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.EnterNewRoom)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, BROKEN_POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)