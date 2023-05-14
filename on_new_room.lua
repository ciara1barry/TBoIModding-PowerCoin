local whiteDinoGem = Isaac.GetTrinketIdByName("White Dino Gem")
local SLOW_COLOUR = Color(100, 100, 100)
local blackDinoGem = Isaac.GetTrinketIdByName("Black Dino Gem")
local CAMO_COLOUR = Color(1, 1, 1, 0.3, 1, 1, 1)
local redDinoGem = Isaac.GetTrinketIdByName("Red Dino Gem")
local DINO_GEM_CHANCE = 0.50
local yellowDinoGem = Isaac.GetTrinketIdByName("Yellow Dino Gem")
local blueDinoGem = Isaac.GetTrinketIdByName("Blue Dino Gem")
local DINO_GEM_EFFECTS = {false, false, false}

--[[
Instead of calling the API to get the IDs of this vanilla item and trinket by their names, just set the ID manually
This is because the ID is far less likely to change than the name with a future update, so the code won't break here
--]]
local DEVILS_CROWN = 146
local POUND_OF_FLESH = 672

function mod:EnterNewRoom()
    local player = Isaac.GetPlayer(0)
    local trinket0 = player:GetTrinket(0)
    local trinket1 = player:GetTrinket(1)
    local room = Game():GetRoom()

    if player:HasCollectible(COBRA_CURSE) then
        if (room:GetType() == RoomType.ROOM_DEVIL) or
            (room:GetType() == RoomType.ROOM_SHOP and player:HasCollectible(POUND_OF_FLESH, true)) or
            (room:GetType() == RoomType.ROOM_TREASURE and ((trinket0 or trinket1) == DEVILS_CROWN)) or
            (Game():GetLevel():GetStage() == LevelStage.STAGE6 and room:GetType() == RoomType.ROOM_DEFAULT) then
                player:UseCard(Card.CARD_CREDIT, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER)
        end
    end
    
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    if USE_COUNT > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage - 1.5)/1.5 else
                player.Damage = player.Damage - 1.5
        end 
        USE_COUNT = 0
    end

    CheckTrinkets(player, room, trinket0, trinket1)
end

function CheckTrinkets(player, room, trinket0, trinket1)
    local entities = Isaac.GetRoomEntities()
    local rng = player.GetTrinketRNG(player, redDinoGem)

    if room:IsClear() == false then
        if (trinket0 or trinket1) == whiteDinoGem then
            for _, entity in ipairs(entities) do
                if entity:IsActiveEnemy() then
                    entity:AddSlowing(EntityRef(player), 240, 0.1, SLOW_COLOUR)
                end
            end
        elseif (trinket0 or trinket1) == blackDinoGem then
            for _, entity in ipairs(entities) do
                if entity:IsActiveEnemy() then
                    entity:AddConfusion(EntityRef(player), 150, false)
                end
            end
            player:SetColor(CAMO_COLOUR, 150, 1, false, false)
        elseif (trinket0 or trinket1) == redDinoGem then
            if rng:RandomFloat() < DINO_GEM_CHANCE then
                player.MoveSpeed = player.MoveSpeed + 1
                DINO_GEM_EFFECTS[0] = true
            elseif DINO_GEM_EFFECTS[0] == true then
                player.MoveSpeed = player.MoveSpeed - 1
                DINO_GEM_EFFECTS[0] = false
            end
        elseif (trinket0 or trinket1) == blueDinoGem then
            if rng:RandomFloat() < DINO_GEM_CHANCE then
                player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER)
                DINO_GEM_EFFECTS[1] = true
            elseif DINO_GEM_EFFECTS[1] == true then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_WAFER)
                DINO_GEM_EFFECTS[1] = false
            end
        elseif (trinket0 or trinket1) == yellowDinoGem then
            if rng:RandomFloat() < DINO_GEM_CHANCE then
                player:UseCard(Card.CARD_HANGED_MAN, UseFlag.USE_NOANIM | UseFlag.USE_NOANNOUNCER | UseFlag.USE_NOCOSTUME)
                player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_DEAD_DOVE)
                DINO_GEM_EFFECTS[2] = true
            elseif DINO_GEM_EFFECTS[2] == true then
                player:RemoveCollectible(CollectibleType.COLLECTIBLE_DEAD_DOVE)
                DINO_GEM_EFFECTS[2] = false
            end
        end
    end
end