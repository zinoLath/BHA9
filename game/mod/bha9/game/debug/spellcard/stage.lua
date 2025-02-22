
local stage_init = stage.New('init', true, true)
function stage_init:init()
    stage.group.PracticeStart('SC Debugger@SC Debugger')
end
function stage_init:render()
end
local classthing = Class()
classthing[".render"] = true
function classthing:init()
    self.x = 0 self.y = 0
    self.hscale, self.vscale = 10,10
    self._blend = "hue+alpha"
    self.img = "reddebug"
    self.layer = LAYER_TOP
    self._color = BulletColor(0)
    self.hue = 0
end
function classthing:frame()
    self._color = BulletColor(self.hue)
    if KeyIsDown("special") then
        self.hue = self.hue +1
    end
end 
function classthing:render()
    DefaultRenderFunc(self)
    SetImageState(self.img,"",Color(255,255,255,255))
    Render(self.img,self.x,self.y,self.rot,self.hscale*0.75,self.vscale*0.75)
    RenderText("menu",tostring(self.hue),self.x,self.y,1,"vcenter","center")
end
local uiname = "game.ui.hud"
local console = require("game.debug.console")
stage.group.New('SC Debugger', 'init', {lifeleft=2,power=100,faith=30000,bomb=3}, false, 1)
stage.group.AddStage('SC Debugger', 'SC Debugger@SC Debugger', {lifeleft=8,power=400,faith=30000,bomb=8}, false)
stage.group.DefStageFunc('SC Debugger@SC Debugger', "init", function(self)
    _init_item(self)
    difficulty=self.group.difficulty
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
        end
        while true do
            local spells = {}
            local bossname = ""
            local __boss
            package.loaded[uiname] = nil
            local uiclass = require(uiname)

            for k, value in ipairs(lstg.settings["spell"]) do
                package.loaded[value] = nil
                table.insert(spells,require(value))
            end
            bossname = spells[1].boss
            package.loaded[bossname] = nil
            __boss = require(bossname)
            InitAllClass()
            New(uiclass)

            local delboss = false 
            local delboss_press = false
            local delboss_pre = false

            local restart = false 
            local restart_press = false
            local restart_pre = false
        
            local ref = New(__boss,spells)
            while IsValid(ref) do 
                restart_pre = restart
                restart = KEY.GetKeyState(KEY.E)
                restart_press = restart and not restart_pre
                if restart_press then
                    stage.Restart()
                end
                delboss_pre = delboss
                delboss = KEY.GetKeyState(KEY.R)
                delboss_press = delboss and not delboss_pre
                if delboss_press then
                    Del(ref)
                end
                task.Wait(1) 
            end
        end
        task.Wait(_infinite) -- wait 1 minute
        stage.group.FinishGroup()
    end)
end)
stage.group.DefStageFunc('SC Debugger@SC Debugger', "render", function(self)
end)