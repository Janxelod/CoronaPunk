--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:54 PM
-- To change this template use File | Settings | File Templates.
--

local Engine=require("CoronaPunk.Engine")
local display=require("display")
local CP=require("CoronaPunk.CP")
local Megaman=require("Megaman")

local engine=Engine:new(display.contentWidth,display.contentHeight,60)

local player=Megaman:new(200,300,"megaman.png")

CP._WORLD:add(player)

