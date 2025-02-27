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
MusicRecord("stage", "assets/music/stage.mp3", 120 + 16, 120 + 13)
MusicRecord("title", "assets/music/title.wav", 120 + 3, 120 + 0)
MusicRecord("boss", "assets/music/boss.mp3", 180 + 51, 180 + 51)
MusicRecord("spellcard", "assets/music/spellcard.ogg", 120 + 23, 120 + 23)
musicentry = {
    stage = {
        name = "Traversing The Sky Across this Starry Night",
        comment = 
[[Author:Delusion
With this track i've tried to get a bit more explorative with my harmonies. 
I think it's very satisfying to see that, and it's a testament of how much 
I've improved over years of making touhou music. With that said, I really 
love the bass and overall melodies here, it really gives the feeling of 
Satori flying at night.]],
        id = "stage"
    },
    title = {
        name = "Memoirs Scattered Across Fantasy",
        comment = 
[[Author:Plazzap
A shimmering and contemplative piece.
Sometimes troublesome memories haunt the mind. One must strive for peace 
in these moments - even if it means confronting the memories directly. 
But I suppose a game or a good nap could drown out the noise. Those are 
routes I tend to take, at least.
By the way, this was composed a while ago. It could very well be considered 
a scattered memory at this point.]],
        id = "title"
    },
    boss = {
        name = "Eternal Imitation Dance ~ Spell Collector",
        comment = 
[[Author:SylviaTheGhost
Honestly, there's needs to be more covers and remixes of Len'en songs, 
they're soooo good! This is also my first time transcribing a song too, 
the transcription may be a bit rough and some notes may be off so I 
apologize for that. I hope you enjoy the song regardless though.]],
        id = "boss"
    },
    spellcard = {
        name = "Call of the Vulpes Lagopus",
        comment = 
[[Author:PumpkinPielex
This is the theme from act 4 of AoUK. At the time of writing this the
theme is almost 6 years old, it had originally been recycled to be used
in another game and now this game. It's so old, why do people enjoy it
so much? Haha. Maybe it's just nostalgia, I still like it a bit too
despite its age.]],
        id = "spellcard"
    },
}
musicorder = {
    "title", "stage", "boss", "spellcard"
}
for index, value in ipairs(musicorder) do
    LoadMusicRecord(value)
end

LoadImageFromFile("reddebug","debug_red.png",true,0,0,false)
local hud = require "game.ui.hud"
local bg = require "game.background"

stage.group.New('MainGame', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('MainGame', '1@MainGame', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('1@MainGame', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
    New(mask_fader,'open')
    New(satori_player)
    New(hud)
    New(bg)
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
                

                local terminal = false 
                local terminal_press = false
                local terminal_pre = false

                while true do
                    terminal_pre = terminal
                    terminal = KEY.GetKeyState(KEY.R)
                    terminal_press = terminal and not terminal_pre
                    if not IsValid(lstg.tmpvar.console) and terminal_press then
                        stage.Restart()
                    end
                    task.Wait(1)
                end
            end)
        end
        --cardmanager:use_card("corolla")
        --cardmanager:use_card("rblade")
        --PlayMusic('spellcard', 0.5, 0)
        local stagefunc = lstg.DoFile("game/stage/main.lua")
        print(stagefunc)
        stagefunc(self)
        --task.Wait(180)
        New(haiji_boss)
        task.Wait(60)
        New(mask_fader,'close')
        task.Wait(30)
        stage.group.FinishGroup()
    end)
end)
stage.group.DefStageFunc('1@MainGame', "render", function(self)
end)

if lstg.settings["spell"] then
    require("game.debug.spellcard.stage")
elseif lstg.settings["card"] then
    require("game.debug.shotcard.stage")
elseif lstg.settings["bg"] then
    require("game.debug.background.stage")
elseif lstg.settings["stage"] then
    stage_init = stage.New("init",true,true)
    function stage_init:init()
        stage.group.Start('MainGame')
    end
end
