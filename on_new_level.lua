function mod:EnterNewLevel()
    local player = Isaac.GetPlayer(0)

    if player:HasCollectible(COBRA_CURSE) then
        if (Game():GetLevel():GetStage() == LevelStage.STAGE6) then
            player:UseCard(Card.CARD_CREDIT, 1)
        end
    end
end