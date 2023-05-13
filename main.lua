mod = RegisterMod("Power Rangers", 1)

include("on_new_room.lua")
include("on_new_level.lua")
include("mod_active_items.lua")
include("mod_passive_items.lua")

function mod:EvaluateCache(player, cacheFlags)
    local itemCount = player:GetCollectibleNum(POWER_COIN)

    if player:HasCollectible(POWER_COIN, true) then
        CollectPowerCoin(player, cacheFlags)
    end
    if player:HasCollectible(POWER_MORPHER, true) or player:HasCollectible(BROKEN_POWER_MORPHER, true) then
        CheckIfPowerMorpherUsed(player, itemCount)
    end
    if player:HasCollectible(COBRA_CURSE, true) then
        CobraDeathOnCollect(player)
    end
end

function mod:FreeDevilDeal(entity)
    if (Game():GetLevel():GetStage() == LevelStage.STAGE6) and (Isaac.GetPlayer(0):HasCollectible(COBRA_CURSE, true))
        and (entity.Variant == EffectVariant.POOF01) then
            Isaac.GetPlayer(0):UseCard(Card.CARD_CREDIT, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, mod.FreeDevilDeal)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.EnterNewRoom)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, BROKEN_POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)