---@diagnostic disable: inject-field
local M = {}
local cardmanager = M
local cm = cardmanager

cm.cardlist = {}

cardmanager.TYPE_SKILL = 1
cardmanager.TYPE_CIRCLE = 2
cardmanager.TYPE_SPELL = 3
cardmanager.TYPE_SYSTEM = 4

function cardmanager:initialize()
    lstg.var.card_context = {
        cards = {},
        hand = {},
        deck = lstg.var.starting_deck,
        gauge = 0
    }
    if lstg.var.card_context.deck == nil then
        lstg.var.card_context.deck = {}
    end
    cardmanager.context = lstg.var.card_context
end

function cardmanager:get_gauge(amount)
    cm.context.gauge = cm.context.gauge + amount
    while cardmanager.context.gauge >= 100 do
        cm.context.gauge = cm.context.gauge - 100
        cm:get_card()
    end
end

function cardmanager:get_card(card)
    if card == nil then
        card = table.remove(cm.context.deck,1)
    end
    table.insert(cm.context.hand, card)
end

function cardmanager:scroll_hand()
    table.insert(cm.context.hand, table.remove(cm.context.hand,1))
end

function cardmanager:use_card(cardname)
    local card
    if not cardname then
        if #cm.context.hand == 0 then
            return
        end
        if #cm.context.hand < cm.cardlist[cm.context.hand[1]].cost then
            return
        end
        cardname = table.remove(cm.context.hand,1)
        card = cm.cardlist[cardname]
        local cost = card.cost
        for i=1, cost-1 do
            local sacrifice = table.remove(cm.context.hand,1)
            if not card.discard then
                table.insert(cm.context.deck,sacrifice)
            end
        end
    else
        card = cm.cardlist[cardname]
    end
    if cm.context.cards[card.id] then
        if cm.context.cards[card.id].lvl >= 4 then
            return
        end
        cm.context.cards[card.id].lvl = cm.context.cards[card.id].lvl + 1
        if not IsValid(player.cards[card.id]) or cm.context.cards[card.id].enabled == false then
            local cardobj = New(card,player.slow)
            if card.type == cm.TYPE_SKILL then
                if player.slow == 1 then
                    if player.focus_card ~= nil then
                        Kill(player.focus_card)
                    end
                    player.focus_card = cardobj
                else
                    if player.unfocus_card ~= nil then
                        Kill(player.unfocus_card)
                    end
                    player.unfocus_card = cardobj
                end
            end
        end
        card.lvlup(card)
    else
        local cardobj = New(card,player.slow)
        if card.type == cm.TYPE_SKILL then
            if player.slow == 1 then
                if player.focus_card ~= nil then
                    Kill(player.focus_card)
                end
                player.focus_card = cardobj
            else
                if player.unfocus_card ~= nil then
                    Kill(player.unfocus_card)
                end
                player.unfocus_card = cardobj
            end
        end
    end
end

return M