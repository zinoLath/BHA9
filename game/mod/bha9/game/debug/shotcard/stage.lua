
local stage_init = stage.New('init', true, true)
function stage_init:init()
    stage.group.PracticeStart('CARDDEBUG@CARDDEBUG')
end
function stage_init:render()
end

local cardmanager = require("zinolib.card.manager")
lstg.cm = cardmanager
local afor = require("zinolib.advancedfor")
local bullet = require("zinolib.bullet")
local familiar = require("game.enemy.familiar")

local uiname = "game.ui.hud"
local cuiname = "game.ui.cardui"
local console = require("game.debug.console")
stage.group.New('CARDDEBUG', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('CARDDEBUG', 'CARDDEBUG@CARDDEBUG', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('CARDDEBUG@CARDDEBUG', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(mask_fader,'open')

    lstg.var.starting_deck = {
        crod = 4,
        clock = 4,
        gourd = 4,
        tfan = 4,
        grimoire = 4,
    }
    New(satori_player)
    New(temple_background)
    --LoadMusicRecord('spellcard')

    task.New(self, function()
        if is_debug then
            
            task.New(self,function()

                local terminal = false 
                local terminal_press = false
                local terminal_pre = false

                while true do
                    terminal_pre = terminal
                    terminal = KEY.GetKeyState(KEY.T)
                    terminal_press = terminal and not terminal_pre
                    if not IsValid(lstg.tmpvar.console) and terminal_press then
                        lstg.tmpvar.console = New(console)
                    end
                    task.Wait(1)
                end
            end)
            task.New(self, function()
                local em = New(enemy,2, 9000000, false, true, false)
                while true do
                    em.x = 0
                    em.y = 120
                    for iter in afor(15) do
                        bullet("amulet",BulletColor(120),em.x,em.y,4,iter:circle())
                        --familiar(em,em.x,em.y,100,BulletColor(120),0)
                    end
                    task.Wait(6)
                end
            end)
        end
        while true do
            task.Wait(1)
            local cards = {}

            for k, value in ipairs(lstg.settings["card"]) do
                package.loaded[value] = nil
                table.insert(cards,require(value))
            end
            package.loaded[uiname] = nil
            local uiclass = require(uiname)
            package.loaded[cuiname] = nil
            local cuiclass = require(cuiname)
            InitAllClass()
            New(uiclass)
            New(cuiclass)
            task.Clear(player)
            item.PlayerInit()
            for k, v in ipairs(cards) do
                cardmanager:use_card(v.id)
            end

            local delboss = false 
            local delboss_press = false
            local delboss_pre = false
        
            while true do 
                delboss_pre = delboss
                delboss = KEY.GetKeyState(KEY.R)
                delboss_press = delboss and not delboss_pre
                if delboss_press then
                    stage.Restart()
                    break
                end
                task.Wait(1) 
            end
        end
        task.Wait(_infinite) -- wait 1 minute
        stage.group.FinishGroup()
    end)
end)
stage.group.DefStageFunc('CARDDEBUG@CARDDEBUG', "render", function(self)
end)