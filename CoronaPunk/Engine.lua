--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:58 PM
-- To change this template use File | Settings | File Templates.
--

local scene=scene
_G.require("Base.Class")
local Engine=Class()

local CP=require("CP")
local World=require("World")
local Entity=require("Entity")
local Input=require("Input")
local getTimer=system.getTimer

function Engine:initialize(width,height,frameRate)
    CP.WIDTH=width
    CP.HEIGHT=height
    CP.HALFWIDTH=width/2
    CP.HALFHEIGHT=height/2
    CP.FRAMERATE=frameRate

    CP.ENGINE=self
    CP._WORLD=World:new()
    CP.ENTITY=Entity:new()
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

--Event handler for stage entry
function Engine:onScene()
    self:setScenePropierties()
    Input.enable()
    if(CP._GOTO~=nil)then self:checkWorld() end
    self:init()
    self.rate=1000/CP.FRAMERATE

    self.laste=getTimer()
    Runtime:addEventListener("enterFrame",self:onEnterFrame)

end

function Engine:onEnterFrame(event)
    self.time,self.gameTime=getTimer(),getTimer()
    self.updateTime=self.time
    CP.ELAPSED=(self.time-self.last)/1000
    if(CP.ELAPSED>self.maxElapsed)then CP.ELAPSED=self.maxElapsed end
    self.last=self.time

    --Update Loop
    if(self.paused~=false)then self:update() end

    --Update Input Loop
    Input.update()

    self.time=getTimer()
    CP.UPDATETIME=self.time-self.updateTime
    CP.GAMETIME=self.time-self.gameTime

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

return Engine