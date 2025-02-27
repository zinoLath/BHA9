local M = Class(background)
local bha9bg = M
local particle = require("particle")

LoadModel("faggot", "game/background/faggot.glb")
LoadModel("foodtruck", "game/background/foodtruck.glb")
LoadImageFromFile("vignette","game/background/vignette.png")
LoadImageFromFile("particleBg","game/background/particle.png")
LoadTexture("skybox","game/background/skybox.png")
SetTextureSamplerState("skybox","linear+wrap")

local afor = require("zinolib.advancedfor")
function bha9bg:init()
	background.init(self,false)
	self.x, self.y, self.z = 0,0,0

	--set 3d camera and fog
	Set3D('eye',-3.8,3.6,5.2)
	--Set3D('eye',0,20,20)
	Set3D('at',4.8,-7.8,-20)
	Set3D('up',0,1,0.4)
	Set3D('z',0.01,100)
	--Set3D('z',1,100)
	Set3D('fovy',1)
	self.fagcolor = ColorS("FF071530")
	Set3D('fog',0.1,20,self.fagcolor)
	self.pool = particle.NewPool3D("particleBg", "hue+add", 1024)
	function self:spawnpart()
		local p = self.pool:AddParticle(0,0,0,0,0,0)
		p.x = ran:Float(-10,10)
		p.y = ran:Float(-2,1)
		p.z = ran:Float(-20,-10)
		p.vz = 0.12/1
		p.vx = ran:Float(-0.01,0.01)
		p.vy = ran:Float(-0.01,0.01)/2
		p.sx = 0.01
		p.sy = 0.01
		p.oy = ran:Float(-0.1,0.1)
		p.ox = ran:Float(-0.1,0.1)
		p.oz = ran:Float(-1,1)
		p.extra1 = ran:Float(50,70)
	end
	self.spawn_var = 0
end
function bha9bg:frame()
	--Set3D('at',4.8,7.8+1*sin(self.timer*0.7),-20)
	while self.spawn_var > 1 do
		self.spawn_var = self.spawn_var - 1
		self:spawnpart()
	end
	self.spawn_var = self.spawn_var + 0.4

	self.pool:Apply(function(unit)
		local t = math.clamp(unit.timer/60,0,1)
		unit.color = BulletColor(unit.extra1,nil,math.lerp(0,255,t))
		--unit.extra1 = unit.extra1 + 1
	end)
	self.pool:Update()
	--p.oz = ran:Float(-1,1)
end
function Wrap(x, x_min, x_max)
    return (((x - x_min) % (x_max - x_min)) + (x_max - x_min)) % (x_max - x_min) + x_min;
end
function bha9bg:render()
	SetViewMode'3d'
	background.WarpEffectCapture()
	ClearZBuffer(1)
	SetZBufferEnable(0)
	local scale = 20.9/16.3
    RenderClearViewMode(self.fagcolor)
	SetViewMode'world'
	local l,r,t,b = lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t
	local u,v, w,h = self.timer*0.1, 0, 512, 512
	local cw = Color(255,255,255,255)
	RenderTexture("skybox", "", 
						{l,t,0,u,v,cw},
						{r,t,0,u+w,v,cw},
						{r,b,0,u+w,v+h,cw},
						{l,b,0,u,v+h,cw}
				)
	
	SetViewMode'3d'
	Set3D('fog',0.1,20,self.fagcolor)
	local spd = 4
	for iter in afor(30) do
		local zoff = -iter.current + Wrap(self.timer*spd*0.4/120, 0, 6)+3
		local _scale = 0.2
		local modelsize = 20.9
		lstg.RenderModel("faggot",self.x,self.y-2,self.z+zoff*modelsize*_scale,
								  0,0,0,
								  _scale*1.8,_scale*1.8,_scale*1.2)
	end
	
	for iter1 in afor(12) do
		for iter in afor(40) do
			local modelsize = 16.3
			local zoff = -iter.current + Wrap(self.timer*spd/120, 0, 12)+3
			local _scale = 0.1
			--local xoff = -iter1.current+2 + 3 * sin(Wrap(iter.current*120, 0, modelsize)+3)
			--local xoff = -iter1.current+2
			local xoff = -(iter1.current)+4 + 0.5 * sin(iter.current*90+30)
			local yoff = -iter1.current*0.4+1 + 0.2 * sin(iter.current*90)
			lstg.RenderModel("foodtruck",self.x+xoff*modelsize*_scale,self.y+0.1+yoff,self.z+zoff*modelsize*_scale,
									  20,0,0,
									  _scale*1.1,_scale*2.2,_scale*1.2)
		end
	end
	SetFog(20,60,self.fagcolor)
	self.pool:Render()
	SetViewMode'world'
	SetImageState("vignette", "mul+rev", ColorS("61A59550"))
	RenderRect("vignette",lstg.world.l,lstg.world.r,lstg.world.b,lstg.world.t)

	background.WarpEffectApply()
	SetViewMode'world'
end

return M