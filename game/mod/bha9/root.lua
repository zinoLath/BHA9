-- Empty stage test script for THlib.

Include('THlib.lua')

--require("doremy.main")
require("game.menu.main")
satori_player = require("game.player.satori")
AddPlayerToPlayerList('Satori Komeiji','satori_player','Satori')

require("game.card.main")
local cardui = require("game.ui.cardui")

require("game.debug.imgui")

lstg.var.starting_deck = {
    crod = 4,
    clock = 4,
    gourd = 4,
    tfan = 4,
    grimoire = 4,
}
local cardmanager = require("zinolib.card.manager")
local haiji_boss = require("game.boss.haiji")
local console = require("game.debug.console")


LoadImageFromFile("reddebug","debug_red.png",true,0,0,false)

stage.group.New('Test', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('Test', '1@Test', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('1@Test', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(mask_fader,'open')
    New(marisa_player)
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
        end
        cardmanager:use_card("rblade")
        --PlayMusic('spellcard', 0.5, 0)
        New(haiji_boss)
        task.Wait(_infinite) -- wait 1 minute
        stage.group.FinishGroup()
    end)
end)

if lstg.settings["spell"] then
    require("game.debug.spellcard.stage")
elseif lstg.settings["card"] then
    require("game.debug.shotcard.stage")
elseif lstg.settings["bg"] then
    require("game.debug.background.stage")
end
