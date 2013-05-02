--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:58 PM
-- To change this template use File | Settings | File Templates.
--
require("system")
local scene=scene
_G.require("Base.Class")
local Engine=Class()

local CP=require("CoronaPunk.CP")
local World=require("CoronaPunk.World")
local Entity=require("CoronaPunk.Entity")
local Input=require("CoronaPunk.Input")
local getTimer=system.getTimer

local tempTime=0
--You have to overwrite
function Engine:init()

end

function Engine:update()
    if(CP._WORLD.active==true)then
       CP._WORLD:update()
    end
    CP._WORLD:updateLists()
    if(CP._GOTO~=nil)then self:checkWorld() end

end

function Engine:setScenePropierties()
   --Agregar configuracion del escenario

end

function Engine:enterFrame(event)

	self.time=getTimer()
	self.gameTime=getTimer()
	self.updateTime=self.time
	CP.ELAPSED=(self.time - self.last)/1000
	if(CP.ELAPSED>self.maxElapsed)then CP.ELAPSED=self.maxElapsed end
	--CP.ELAPSED=CP.ELAPSED*CP.FRAMERATE
	self.last=self.time

	--Update Loop

	tempTime=tempTime+CP.ELAPSED
	--print(tempTime)
	if(self.paused==false)then self:update() end

	--Update Input Loop
	--Input.update()

	self.time=getTimer()
	CP.UPDATETIME=self.time-self.updateTime
	CP.GAMETIME=self.time-self.gameTime


end

--Event handler for stage entry
function Engine:onScene()
    self:setScenePropierties()
--    Input.enable()
    if(CP._GOTO~=nil)then self:checkWorld() end
    self:init()
    self.rate=1000/CP.FRAMERATE

    self.last=getTimer()
    print("Valor de last: "..self.last)
    Runtime:addEventListener("enterFrame",self)--Its using an object listener

end



function Engine:checkWorld()
    if(CP._GOTO~=nil)then
        CP._WORLD:finish()
        CP._WORLD:updateLists()
        CP._WORLD=CP._GOTO
        CP._GOTO=nil
        CP._WORLD:updateLists()
        CP._WORLD:begin()
        CP._WORLD:updateLists()
    end
end

function Engine:initialize(width,height,frameRate)
	CP.WIDTH=width
	CP.HEIGHT=height
	CP.HALFWIDTH=width/2
	CP.HALFHEIGHT=height/2
	CP.FRAMERATE=frameRate

	CP.ENGINE=self
	CP._WORLD=World:new()
	--CP.ENTITY=Entity:new()
	CP.TIME=system.getTimer()
	self.paused=false
	self.maxElapsed=0.0333

	--Timming Information
	self.time=0
	self.last=0
	self.rate=0
	--Debug timming information
	self.updateTime=0
	self.gameTime=0
	self.coronaTime=0

	self:onScene()
end
return Engine