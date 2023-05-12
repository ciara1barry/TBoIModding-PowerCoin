local whiteDinoGem = Isaac.GetTrinketIdByName("White Dino Gem")
local SLOW_COLOUR = Color(100, 100, 100)
local blackDinoGem = Isaac.GetTrinketIdByName("Black Dino Gem")
local CAMO_COLOUR = Color(1, 1, 1, 0.3, 1, 1, 1)
local redDinoGem = Isaac.GetTrinketIdByName("Red Dino Gem")
local DINO_GEM_CHANCE = 0.10
local RED_DINO_GEM_MOVE_SPEED = false
local yellowDinoGem = Isaac.GetTrinketIdByName("Yellow Dino Gem")
local YELLOW_DINO_GEM_REVELATION = false
local blueDinoGem = Isaac.GetTrinketIdByName("Blue Dino Gem")
local BLUE_DINO_GEM_WAFER = false

function mod:EnterNewRoom()
    local player = Isaac.GetPlayer(0)
    local entities = Isaac.GetRoomEntities()
    local rng = player.GetTrinketRNG(player, redDinoGem)
    local trinket0 = player:GetTrinket(0)
    local trinket1 = player:GetTrinket(1)
    
    local itemCount = player:GetCollectibleNum(POWER_COIN)
    if USE_COUNT > 0 then
        if itemCount > 0 then
            player.Damage = (player.Damage - 1.5)/1.5 else
                player.Damage = player.Damage - 1.5
        end 
        USE_COUNT = 0
    end

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
            RED_DINO_GEM_MOVE_SPEED = true else
                if RED_DINO_GEM_MOVE_SPEED == true then
                    player.MoveSpeed = player.MoveSpeed - 1
                    RED_DINO_GEM_MOVE_SPEED = false
                end
        end
    elseif (trinket0 or trinket1) == blueDinoGem then
        if rng:RandomFloat() < DINO_GEM_CHANCE then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_WAFER)
            BLUE_DINO_GEM_WAFER = true else
                if BLUE_DINO_GEM_WAFER == true then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_WAFER)
                    BLUE_DINO_GEM_WAFER = false
                end
        end
    elseif (trinket0 or trinket1) == yellowDinoGem then
        if rng:RandomFloat() < DINO_GEM_CHANCE then
            player:GetEffects():AddCollectibleEffect(CollectibleType.COLLECTIBLE_REVELATION)
            YELLOW_DINO_GEM_REVELATION = true else
                if YELLOW_DINO_GEM_REVELATION == true then
                    player:RemoveCollectible(CollectibleType.COLLECTIBLE_REVELATION)
                    YELLOW_DINO_GEM_REVELATION = false
                end
        end
    end
end