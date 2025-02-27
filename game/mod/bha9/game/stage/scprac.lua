
local hud = require "game.ui.hud"
local bg = require "game.background"

stage.group.New('SpPrac', 'init', {lifeleft=0,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('SpPrac', '1@SpPrac', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('1@SpPrac', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    lstg.var.spprac = true
    New(mask_fader,'open')
    New(satori_player)
    New(hud)
    New(bg)
    --LoadMusicRecord('spellcard')

    task.New(self, function()
        _play_music('spellcard')
        --package.loaded[lstg.var.spellid] = nil
        local spell = require(lstg.var.spellid)
        local bossid = spell.boss 
        --package.loaded[bossid] = nil
        local bossclass = require(bossid)
        InitAllClass()

        local _ref = New(bossclass, {spell})
        while IsValid(_ref) do
            task.Wait(1)
        end
        task.Wait(60)
        New(mask_fader,'close')
        task.Wait(30)
        stage.group.FinishStage()
    end)
end)
stage.group.DefStageFunc('1@SpPrac', 'frame', stage.group.frame_sc_pr)
stage.group.DefStageFunc('1@SpPrac', 'render', function() end)