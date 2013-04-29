--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:54 PM
-- To change this template use File | Settings | File Templates.
--

require("physics")
physics.start()

local circle=display.newRect(10,10,10,10)

physics.addBody(circle,"dynamic")
local i=1
local function rungame(evt)
    if(i<50)then

        physics.addBody(display.newRect(3+i*5,10,10,10),"dynamic")
    end
    i=i+1
end

Runtime:addEventListener("enterFrame",rungame)