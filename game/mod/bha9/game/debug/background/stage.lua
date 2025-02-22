
local stage_init = stage.New('init', true, true)
function stage_init:init()
    stage.group.PracticeStart('CARDDEBUG@CARDDEBUG')
end
function stage_init:render()
end

local cardmanager = require("zinolib.card.manager")
lstg.cm = cardmanager
local uiname = "game.ui.hud"
SetResLoadInfo(false)
local console = require("game.debug.console")
local bgname = "game.background"
stage.group.New('CARDDEBUG', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('CARDDEBUG', 'CARDDEBUG@CARDDEBUG', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('CARDDEBUG@CARDDEBUG', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(satori_player)
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
        end
        while true do
            lstg.var.starting_deck = {
                crod = 4,
                clock = 4,
                gourd = 4,
                tfan = 4,
                grimoire = 4,
            }
            bgname = lstg.settings["bg"][1]
            package.loaded[bgname] = nil
            local bgclass = require(bgname)
            package.loaded[uiname] = nil
            local uiclass = require(uiname)
            InitAllClass()
            New(bgclass)
            New(uiclass)
            print("deck")
            print(PrintTable(lstg.var.card_context.deck))
            task.Wait(1)

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