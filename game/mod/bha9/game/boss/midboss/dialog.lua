local M = boss.dialog.New(true)
M.boss = "game.boss.midboss"
require("zinolib.misc")
require("math.additions")
package.loaded["game.boss.portraits"]=nil
require("game.boss.portraits")
---general help!!
---familar(master,x,y,hp,color,transfer rate)
---bullet(img,color,x,y,speed,ang,indes,add)
--boss.dialog.sentence(self,"Satori_6", "left", "", t, h,v,3)
function M:init()
    lstg.player.dialog=true
    _dialog_can_skip=false
    self.dialog_displayer=New(dialog_displayer)
    boss.SetUIDisplay(self,false,false,false,false,true,false)
    task.New(self,function()
        local t = 180
        local h, v = 0.5/2.25, 0.5/2.25
        task.New(self.belle, function()
            task.MoveTo(100,120,60,MOVE_DECEL)
        end)
        task.New(self.misaki, function()
            task.MoveTo(-100,120,60,MOVE_DECEL)
        end)
        boss.dialog.sentence(self,"Belle_4", "right", "Hey you!", t, h,v,1,1)
        boss.dialog.sentence(self,"Belle_5", "right", "Are you the one causing all this mess?", t, h,v,1,1)
        boss.dialog.sentence(self,"Misaki_8", "right", "Because we won't stop until we\nfind the culprit!", t, h,v,1,2)
        boss.dialog.sentence(self,"Misaki_6", "right", "We don't want to get in trouble\nwith the shrine maiden again...", t, h,v,1,2)
        --task.Wait(1000)
        --_del(self,true)
        boss.SetUIDisplay(self,false,true,true,true,true,true)
    end)
end

return M