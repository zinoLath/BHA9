local M = Class(player_class)
local satori_player = M
satori_player[".render"] = true
LoadTexture('marisa_player','game/player/marisa.png')
LoadImageGroup('marisa_player','marisa_player',0,0,32,48,8,3,1,1)
LoadImage('marisa_support','marisa_player',144,144,16,16)

function satori_player:init()

    self.drawlist = {
        "satoriLegL",
        "satoriLegR",
        "satoriSkirt",
        "satoriTorso",
        "satoriArmL1",
        "satoriArmL2",
        "satoriHead",
        "satoriArmR",
    }
    self.anglist = {}
    for k,v in pairs(self.drawlist) do
        self.anglist[v] = 0
    end
    package.loaded["game.player.positions"] = nil
    self.poslist = require("game.player.positions")
	player_class.init(self)
    
    self.name = "Satori"
    self.imgs={}
    self.A = 1 self.B = 1
    for i=1,24 do self.imgs[i]='marisa_player'..i end
    self.charge_value = 0
    self.stats = {
        card_rate = 1,
        speed = 1,
        damage = 1,
        shot_damage = 1,
        spell_damage = 1,
        item_damage = 1,
        spell_rate = 1,
        shot_rate = 1,
        spell_size = 1,
    }
    self.base_speed = {4.5, 2}
    self.modifiers = {}
	self.slist=
	{
		{            nil,          nil,              nil,            nil},
		{{  0,32,  0,29},          nil,              nil,            nil},
		{{-30,10, -8,23},{30,10, 8,23},              nil,            nil},
		{{-30,0,-10,24},{   0,32,   0,32},{30,0,10,24},            nil},
		{{-30,10,-15,20},{-12,32,-7.5,29},{12,32,7.5,29},{30,10,15,20}},
		{{-30,10,-15,20},{-7.5,32,-7.5,29},{7.5,32,7.5,29},{30,10,15,20}},
	}
    function self:spell()
        self.nextspell = 300 * self.stats.spell_rate
        self.protect = math.max(self.protect, 60)
        local bomb = New(satori_player.default_bomb,self)
        task.New(bomb, function()
            task.Wait(120)
            ex.SmoothSetValueTo("size",0,10,MOVE_DECEL,nil,0,MODE_SET)
            Del(bomb)
        end)
    end
    function self:shoot()
        while true do
            local dmg = 1
            if lstg.var.spprac then
                dmg = 2
            end
            while self.fire > 0 do
                local obj = New(satori_player.shot,"amulet", self.x-10, self.y, 16, 90, dmg)
                obj._blend = "hue+alpha"
                obj._color = BulletColor(-30,nil,128)
                local obj = New(satori_player.shot,"amulet", self.x+10, self.y, 16, 90, dmg)
                obj._blend = "hue+alpha"
                obj._color = BulletColor(-30,nil,128)
                task.Wait(4)
            end
            task.Wait(1)
        end
    end
    task.NewNamed(self,"shot_1",self.shoot)
    task.NewNamed(self,"shot_0",self.shoot)
end
function satori_player:add_modifier(priority, name, func)
    table.insert(self.modifiers, {priority = priority, name = name, func = func})
end
function satori_player:remove_modifier(name)
    for k, mod in self.modifiers do
        if mod.name == name then
            table.remove(self.modifiers, k)
            return
        end
    end
end
local function priosort(mod1, mod2)
    return mod1.priority < mod2.priority
end

function satori_player:frame()
    local prevspell = self.nextspell
	player_class.frame(self)
    self.slist = {
        {            nil,          nil,              nil,            nil},
		{{ 0,0,0,0},          nil,              nil,            nil},
		{{ 0,0,0,0}, { 0,0,0,0},               nil,            nil},
		{{ 0,0,0,0}, { 0,0,0,0}, { 0,0,0,0},             nil},
		{{ 0,0,0,0}, { 0,0,0,0}, { 0,0,0,0}, { 0,0,0,0}},
		{{ 0,0,0,0}, { 0,0,0,0}, { 0,0,0,0}, { 0,0,0,0}},
    }
    task.Do(self)
    for k,v in pairs(self.stats) do
        self.stats[k] = 1
    end
    --self.stats.shot_rate = 0.5
    table.sort(self.modifiers,priosort)
    for k, mod in ipairs(self.modifiers) do
        mod.func(self.stats)
    end
    self.hspeed = self.base_speed[1] * self.stats.speed
    self.lspeed = self.base_speed[2]
    
    if self.dx > 0 then
        for index, value in pairs(self.anglist) do
            self.anglist[index] = math.lerp(value, self.poslist.anglist[index][4],0.23)
        end
    elseif self.dx < 0 then
        for index, value in pairs(self.anglist) do
            self.anglist[index] = math.lerp(value, self.poslist.anglist[index][3],0.23)
        end
    else
        for index, value in pairs(self.anglist) do
            local tgtang = math.lerp(self.poslist.anglist[index][1],self.poslist.anglist[index][2],nsin(self.timer*5))
            self.anglist[index] = math.lerp(value, tgtang,0.1)
        end
    end
    if self.nextspell == 0 and prevspell > 0 then
        PlaySound('lgodsget',0.6)
    end
end

function satori_player:shoot()

end

function satori_player:spell()
    PlaySound('lgods3',0.6)
    self:spell()
end

function satori_player:render()
	for i=1,4 do
		if self.sp[i] and self.sp[i][3]>0.5 then
			--Render('marisa_support',self.supportx+self.sp[i][1],self.supporty+self.sp[i][2],self.timer*3)
		end
	end
    local c = self._color
    if self.protect % 3 == 1 then
        c = Color(self._a, 0, 0, 255)
    end
    for k,v in ipairs(self.drawlist)do
        local pos = self.poslist[v]
        if pos == nil then
            pos = {{x = -1000, y = 1000},0}
        end
        local scale = 0.15
        local finalpos = Vector(pos[1].x, pos[1].y) * scale + math.vecfromobj(self) + Vector(0,6)
        SetImageState(v,self._blend,c)
        Render(v, finalpos.x, finalpos.y,self.anglist[v],scale,scale)
    end
	--player_class.render(self)
    if self.charge_value > 0 then
        local w = 64
        local h = 4
        local y = self.y-35
        local l = self.x-w/2+4
        SetImageState("white","mul+alpha",Color(128, 0, 0, 0))
        RenderRect("white",l, l+w*self.charge_value,y-h/2,y+h/2)
        y = self.y-32
        l = self.x-w/2
        SetImageState("white","mul+alpha",Color(255, 189, 255, 235))
        RenderRect("white",l, l+w*self.charge_value,y-h/2,y+h/2)
    end
end


satori_player.default_bomb = Class()
local bomb = satori_player.default_bomb
function bomb:init(player)
    self.x, self.y = player.x, player.y
    self.size_mul = player.stats.spell_size
    self.dmg_mul = player.stats.spell_damage
    self.sizemax = 60 * self.size_mul
    self.size = 0
    self.rect = false 
    self.group = GROUP_SPELL
    self.layer = LAYER_PLAYER_BULLET-50
    self.dmg = 1000
    task.New(self, function()
        ex.SmoothSetValueTo("size",self.sizemax,10,MOVE_DECEL,nil,0,MODE_SET)
    end)
end

function bomb:frame()
    task.Do(self)
    self.a = self.size
    self.b = self.size
end

function bomb:colli(other)
    if other.group == GROUP_ENEMY_BULLET and other.timer % 2 == 1 then
        other.pause = 1
    end
end

function bomb:render()
    SetImageState('_sub_white', 'mul+sub',
            Color(255, 100, 100, 100),
            Color(255, 255, 255, 255),
            Color(255, 0, 0, 0),
            Color(255, 0, 0, 0)
    )
    rendercircle(self.x, self.y, self.size, 60)
end

satori_player.shot = Class(player_bullet_straight)
local shot = satori_player.shot
shot[".render"] = true
shot.damage_delay = 4
shot.damage_factor = 0.8
shot.dmgtype = "shot"

return M