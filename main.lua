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

function mod:FreeDevilDealOnDarkRoom(entity)
    if (Game():GetLevel():GetStage() == LevelStage.STAGE6) and (Isaac.GetPlayer(0):HasCollectible(COBRA_CURSE, true))
        and (entity.Variant == EffectVariant.POOF01) then
            Isaac.GetPlayer(0):UseCard(Card.CARD_CREDIT, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
    end
end

--[Add External Item Descriptions]
if EID then
    EID:addCollectible(POWER_COIN, "↑ +1 Damage Up")
    EID:addCollectible(POWER_MORPHER,
    "Upon use gives +1.5 damage up which lasts for the current room#If holding 'Power Coin', also gives: x1.5 damage multipler and a soul heart")
    EID:addCollectible(BROKEN_POWER_MORPHER,
    "Upon use gives +1.5 damage up which lasts for the current room#If holding 'Power Coin', also gives: x1.5 damage multipler and a 30% chance of a broken heart")
    EID:addCollectible(COBRA_CURSE,
    "All devil deals are now free, including those provided by items like 'Pound of Flesh'#3% chance of being killed every time a collectible is picked up#Upon death, 'Cobra' is removed from the inventory")
    
    EID:addTrinket(WHITE_DINO_GEM, "Enemies have a 10% chance of being severely slowed for 5 seconds upon entering a new room")
    EID:addTrinket(BLACK_DINO_GEM, "10% chance of Isaac becoming camoflauged and enemies being confused for 5 seconds upon entering a new room")
    EID:addTrinket(RED_DINO_GEM, "10% chance of +1 speed upon entering a new room")
    EID:addTrinket(YELLOW_DINO_GEM, "10% chance of granting Isaac flight upon entering a new room")
    EID:addTrinket(BLUE_DINO_GEM, "10% chance of reducing all damage taken to half a heart upon entering a new room")
end

mod:AddCallback(ModCallbacks.MC_POST_EFFECT_INIT, mod.FreeDevilDealOnDarkRoom)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.EnterNewRoom)
mod:AddCallback(ModCallbacks.MC_PRE_USE_ITEM, mod.RemovePMStatsOnFlip, 711)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_USE_ITEM, mod.PowerMorpherUse, BROKEN_POWER_MORPHER)
mod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, mod.EvaluateCache)