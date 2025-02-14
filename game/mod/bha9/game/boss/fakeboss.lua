local M = Class(enemybase)
local fakeboss = M
fakeboss[".render"] = true

function fakeboss:init(master)
    enemybase.init(self)

    self.master = master
    self.bound = false
    self.a = 32
    self.b = 32
end
function fakeboss:frame()
    SetAttr(self, 'colli', BoxCheck(self, lstg.world.boundl, lstg.world.boundr, lstg.world.boundb, lstg.world.boundt) and self._colli)

    local master = self.master
    if not IsValid(master) then
        Kill(self)
    end
    self.hp = master.hp
    self.maxhp = master.maxhp
    task.Do(self)
end
function fakeboss:colli(other)
    if not IsValid(self.master) then
        return
    end
    self.master.class.colli(self.master,other)
end


return M