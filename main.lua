mod = RegisterMod("Power Rangers", 1)

include("on_new_room.lua")
include("mod_active_items.lua")
include("mod_passive_items.lua")

function mod:EvaluateCache(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    
    CollectPowerCoin(player, cacheFlags)
    CheckIfPowerMorpherUsed(player, itemCount)
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.EnterNewRoom)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, BROKEN_POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)