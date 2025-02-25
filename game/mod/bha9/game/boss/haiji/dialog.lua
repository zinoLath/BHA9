local M = boss.dialog.New(true)
M.boss = "game.boss.haiji"
require("zinolib.misc")
require("math.additions")
---general help!!
---familar(master,x,y,hp,color,transfer rate)
---bullet(img,color,x,y,speed,ang,indes,add)

function M:init()
    lstg.player.dialog=true
    _dialog_can_skip=true
    self.dialog_displayer=New(dialog_displayer)
    boss.SetUIDisplay(self,false,false,false,false,true,false)
    task.New(self,function()
        boss.dialog.sentence(self,"img_void", 1, "girll", 300, 1, 1)
        boss.dialog.sentence(self,"white", 2, "what", 300, 1, 1)
        task.Wait(1000)
        _del(self,true)
    end)
end

return M