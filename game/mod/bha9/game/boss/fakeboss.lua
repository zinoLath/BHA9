local M = Class(enemybase)
local fakeboss = M
fakeboss[".render"] = true

function fakeboss:init(master)
    enemybase.init(self)

    self.master = master
    self.bound = false
    self.a = 32
    self.b = 32
    self._wisys = BossWalkImageSystem(self)
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
    self._wisys:frame() --行走图系统帧逻辑
end
function fakeboss:colli(other)
    if not IsValid(self.master) then
        return
    end
    self.master.class.colli(self.master,other)
end
function fakeboss:render()

    self._wisys:render(0,1) --行走图渲染
end


return M