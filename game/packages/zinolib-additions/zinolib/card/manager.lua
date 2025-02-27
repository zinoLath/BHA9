---@diagnostic disable: inject-field
local M = {}
local cardmanager = M
local cm = cardmanager

LoadImageFromFile("card_bg","assets/card/background.png")
LoadImageFromFile("card_fg","assets/card/foreground.png")

cm.cardlist = {}
cm.cardorder = {}

cardmanager.TYPE_SKILL = 1
cardmanager.TYPE_CIRCLE = 2
cardmanager.TYPE_SPELL = 3
cardmanager.TYPE_SYSTEM = 4
cardmanager.maxhand = 5


local starting_deck = {
    crod = 4,
    corolla = 4,
    rblade = 4,
    tfan = 4,
    grimoire = 4,
}
local starting_unlock = {
    crod = true,
    corolla = true,
    rblade = true,
    tfan = true,
    grimoire = true,
    gourd = true
}
local shuffle = function (tbl)
    local maxSize = #tbl
    for i=maxSize,1,-1 do
        local tmp = tbl[i]
        local j = ran:Int(0,maxSize)
        tbl[i] = tbl[j]
        tbl[j] = tmp
    end
end
function cardmanager:init_save()
    if scoredata.deck == nil or is_debug then
        scoredata.deck = {}
        for key, value in pairs(starting_deck) do
            scoredata.deck[key] = value
        end
        SaveScoreData()
    end
    if scoredata.cardunlock == nil or is_debug then
        scoredata.cardunlock = {}
        for key, value in pairs(starting_unlock) do
            scoredata.cardunlock[key] = value
        end
        SaveScoreData()
    end
end

function cardmanager:unlock_card(card)
    scoredata.cardunlock[card] = true
end

function cardmanager:initialize()
    local deck = {}
    local deckdef = lstg.var.starting_deck or {
        crod = 4,
        clock = 4,
        gourd = 4,
        tfan = 4,
        grimoire = 4,
    }
    for k,v in pairs(deckdef) do
        for i = 1, v do
            table.insert(deck,k)
        end
    end
    shuffle(deck)
    lstg.var.card_context = {
        cards = {},
        hand = {},
        deck = deck,
        gauge = 0
    }
    if lstg.var.card_context.deck == nil then
        lstg.var.card_context.deck = {}
    end
    cardmanager.context = lstg.var.card_context
end

function cardmanager:get_gauge(amount)
    if #cm.context.hand >= cardmanager.maxhand then
        return
    end
    cm.context.gauge = cm.context.gauge + amount
    while cardmanager.context.gauge >= 100 do
        cm.context.gauge = cm.context.gauge - 100
        cm:get_card()
    end
end

function cardmanager:get_card(card)
    if #cm.context.hand >= 5 then
        return 
    end
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
        cm.context.cards[card.id].enabled = true

        if (not IsValid(player.cards[card.id]) and cm.context.cards[card.id].enabled == false) then
            local cardobj = New(card,player.slow)
            if card.type == cm.TYPE_SKILL then
                if player.slow == 1 then
                    if player.focus_card ~= nil and player.focus_card.class.id ~= card.id then
                        Kill(player.focus_card)
                    end
                    player.focus_card = cardobj
                else
                    if player.unfocus_card ~= nil and player.unfocus_card.class.id ~= card.id then
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
local afor = require("zinolib.advancedfor")
function cardmanager:RenderCard(card,x,y,rot,hscale,vscale,color,outline,outlinec)
    rot = rot or 0
    hscale = hscale or 1
    vscale = vscale or hscale
    color = color or Color(255,255,255,255)
    local ww, wh  = GetImageSize("white")
    local w,h = GetImageSize("card_bg")
    outline = outline or (10*hscale)
    outlinec = outlinec or Color(color.a,0,0,0)
    outlinec.a = color.a
    SetImageState("white","", outlinec)
    for iter in afor(4) do
        local vec = math.polar(Vector(w+outline,h+outline)*Vector(hscale,vscale)*0.5,iter:circle() + rot) + Vector(x,y)
        local scale1 = Vector((w+outline*2)*hscale/ww, (outline)*hscale/wh)
        local scale2 = Vector((h+outline*2)*vscale/ww, (outline)*vscale/wh)
        local scale = math.lerp(scale1,scale2,math.abs(sin(iter:circle() + rot+90)))
        Render("white", vec.x, vec.y,iter:circle() + rot+90,scale.x,scale.y)
    end

    SetImageState("card_bg", "", color)
    SetImageState(card, "", color)
    SetImageState("card_fg", "", color)

    Render("card_bg",x,y,rot,hscale,vscale)
    Render(card,x,y,rot,hscale,vscale)
    Render("card_fg",x,y,rot,hscale,vscale)
end
function cardmanager:LoadCardIcon(name,texname)
    name = "cardicon:" .. name
    LoadImageFromFile(name,cardmanager.iconpath .. texname .. ".png",true)
    return name
end
cardmanager.iconpath = "assets/card/icon/"

return M