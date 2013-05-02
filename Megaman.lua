--
-- Created by IntelliJ IDEA.
-- User: yusukejoan
-- Date: 2/05/13
-- Time: 02:09
-- To change this template use File | Settings | File Templates.
--

local scene=scene
local GlobalFunctions=require("CoronaPunk.GlobalFunctions")

require("CoronaPunk.table_AS3")
_G.require("Base.Class")
local super=require("CoronaPunk.Entity")

local Megaman=Class(super)



function Megaman:update()

	self.image.x=self.image.x+2
	self.image.y=self.image.y+2
end

return Megaman