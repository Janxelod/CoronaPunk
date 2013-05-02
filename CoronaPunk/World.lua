--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:58 PM
-- To change this template use File | Settings | File Templates.
--

local scene=scene
require("CoronaPunk.table_AS3")
_G.require("Base.Class")
local World=Class()

function World:initialize(...)
   self.visible=true
   --Adding and Removal
   self._add={}
   self._remove={}

   --Update Information
    self._updateFirst=nil
    self._count=0

    --Render Information
    self._typeFirst={}
    self._typeCount={}
    self._entityName={}
    self.active=true
end

--[[
* Override this; called when World is switch to, and set to the currently active world.
]]--
function World:begin()

end

--[[
* Override this; called when World is changed, and the active world is no longer this.
]]--
function World:finish()

end

function World:update()
   local e=self._updateFirst
   while(e~=nil)do
       if(e.active==true)then
           e:update()

       end
       --Podria ir codigo para actualizar grupo de entidades
       e=e._updateNext
   end
end

function World:add(e)
    self._add[#self._add+1]=e
    return e
end

function World:remove(e)
   self. _remove[#self._remove]=e
    return e
end

function World:removeAll()
    local e=self._updateFirst
    while(e~=nil)do
        self._remove[#self._remove]=e
        e=e._updateNext
    end
end

--[[
* Returns the first Entity that collides with the rectangular area.
* @param	type		The Entity type to check for.
* @param	rX			X position of the rectangle.
* @param	rY			Y position of the rectangle.
* @param	rWidth		Width of the rectangle.
* @param	rHeight		Height of the rectangle.
* @return	The first Entity to collide, or null if none collide.
]]--
function World:collideRect(type,rX,rY,rWidth,rHeight)
    local e=self._typeFirst[type]
    while(e~=nil)do
        if(e:collideRect(e.x,e.y,rX,rY,rWidth,rHeight))then
            return e
        end
        e=e._typeNext
    end
    return nil
end

--[[
* Returns the first Entity found that collides with the position.
* @param	type		The Entity type to check for.
* @param	pX			X position.
* @param	pY			Y position.
* @return	The collided Entity, or null if none collide.
*/
]]--
function World:collidePoint(type,pX,pY)
    local e=self._typeFirst[type]
    while(e~=nil)do
        if(e:collidePoint(e.x,e.y,pX,pY)==true)then
            return e
        end
        e=e._typeNext
    end
end

--[[
* Populates an array with all Entities that collide with the rectangle. This
* function does not empty the array, that responsibility is left to the user.
* @param	type		The Entity type to check for.
* @param	rX			X position of the rectangle.
* @param	rY			Y position of the rectangle.
* @param	rWidth		Width of the rectangle.
* @param	rHeight		Height of the rectangle.
* @param	into		The Array or Vector to populate with collided Entities.
*/
]]--
function World:collideRectInto(type,rX,rY,rWidth,rHeight,into)
    if(into==nil)then into={} end
    local e=self._typeFirst[type]
    n=#into
    while(e~=nil)do
        if(e:collideRect(e.x,e.y,rX,rY,rWidth,rHeight)==true)then
            n=n+1
            into[n]=e
        end
        e=e._typeNext
    end
end

function World:typeCount(type)
    return #self._typeCount[type]
end

function World:getFirst()
    return self._updateFirst
end

--[[
* Pushes all Entities in the World of the type into the Array or Vector.
* @param	type		The type to check.
* @param	into		The Array or Vector to populate.
* @return	The same array, populated.
]]--
function World:getType(type,into)
    if(into==nil)then into={} end
    local e=self._typeFirst[type]
    n=#into
    while(e~=nil)do
        n=n+1
        into[n]=e
        e=e._typeNext
    end
end

function World:getInstance(name)
    return self._entityNames[name]
end

function World:updateLists()
    local e=nil
    local remove= self._remove
    local add=self._add
    --remove Entities
    if(#remove>0)then
        for i, e in ipairs(remove) do
            if(e._world==nil)then
                if(table.indexOf(add,e)>=1)then
                    table.splice(add,table.indexOf(add,e),1)
                end
            elseif(e._world~=self) then
            else
                e:removed()
                e._world=nil
                self:removeUpdate(e)
                --"" used for type and name from an entity for simulate nil value
                if(e._type~="")then self:removeType(e) end
                if(e._name~="")then self:unregisterName(e) end
            end
        end
        self._remove={}
    end
    --add entities
    if(#add>0)then

        for i,e in ipairs(add)do
            if(e._world~=nil)then
                --continue statement
            else
	            print("Agrego nueva entidad"..#add)
                self:addUpdate(e)
                if(e._type~="")then self:addType(e) end
                if(e._type~="")then self:registerName(e) end
                e._world=self
                e:added()
            end
        end
	    self._add={}
    end
end

function World:addUpdate(e)
    local updateFirst=self._updateFirst
    if(updateFirst~=nil)then
        updateFirst._updatePrev=e
        e._updateNext=updateFirst
    else
        e._updateNext=nil
    end
    e._updatePrev=nil
    self._updateFirst=e
    self._count=self._count+1
end

function World:removeUpdate(e)
    local updateFirst=self._updateFirst
    if(updateFirst==e)then self._updateFirst=e._updateNext end
    if(e._updateNext~=nil)then e._updateNext._updatePrev=e._updatePrev end
    if(e._updatePrev~=nil)then e._updatePrev._updateNext=e._updateNext end
    e._updateNext,e._updatePrev=nil,nil

    self._count=self._count-1
end

function World:addType(e)
    local typeFirst=self._typeFirst
    if(typeFirst[e._type]~=nil)then
	    self._typeFirst[e._type]._typePrev=e
        e._typeNext=self._typeFirst[e._type]
	    self._typeCount[e._type]=self._typeCount[e._type]+1
    else
       e._typeNext=nil
       self._typeCount[e._type]=1
    end
    e._typePrev=nil
    self._typeFirst[e._type]=e
end

function World:removeType(e)
   --Remove from the type List
    if(self._typeFirst[e._type]==e)then
        self._typeFirst[e._type]=e._typeNext
    end
    if(e._typeNext~=nil)then
        e._typeNext._typePrev=e._typePrev
    end
    if(e._typePrev~=nil)then
        e._typePrev._typeNext=e._typeNext
    end
    e._typeNext,e._typePrev=nil,nil
    self._typeCount[e._type]=self._typeCount[e._type]+1
end

function World:registerName(e)
    self._entityNames[e._name]=e
end

function World:unregisterName(e)
   if(self._entityNames[e._name]==e)then
       self._entityNames[e._name]=nil
   end
end



return World