--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 03:00 PM
-- To change this template use File | Settings | File Templates.
--

local scene=scene
local GlobalFunctions=require("CoronaPunk.GlobalFunctions")

require("CoronaPunk.table_AS3")
_G.require("Base.Class")
local Entity=Class()

function Entity:initialize(x,y,image)
    if(x==nil)then x=0 end
    if(y==nil)then y=0 end
    self.active=true
    self.visible=true
    self.collidable=true
    self.x=x
    self.y=y
    self.image=display.newImage(image)
    self.width=image.width
    self.height=image.height
    self.originX=image.xOrigin
    self.originY=image.yOrigin

    --Entity information
    self._world=nil
    self._type=""
    self._name=""
    self._updatePrev=nil
    self._updateNext=nil
    self._typePrev=nil
    self._typeNext=nil
end

--[[
* Override this, called when the Entity is added to a World.
]]--
function Entity:added()

end

--[[
* Override this, called when the Entity is removed from a World.
]]--
function Entity:removed()

end

--[[
* Updates the Entity.
]]--
function Entity:update()

end

function Entity:collide(type)
   if(self._world==nil)then return nil end

   local e=self._world._typeFirst[type]

   if(e==nil)then return nil end

   while(e~=nil)do
       if(e.collidable==true and e~=self and GlobalFunctions:hasCollidedRect(self.image,e.image))then
           return e
       end
       e=e._typeNext
   end
   return nil
end
--[[
* Checks for collision against multiple Entity types.
* @param	types		An Array or Vector of Entity types to check for..
* @return	The first Entity collided with, or null if none were collided.
*/
]]--
function Entity:collideTypes(types)
    if(self._world==nil)then  return nil end

    if(type(types)=="string")then
        return self:collide(types)
    else
        for i,name in ipairs(types)do
            e=self:collide(name)
            if(e~=nil)then return e end
        end
    end
    return nil
end

--[[/**
* Checks if this Entity collides with a specific Entity.
* @param	e		The Entity to collide against.
* @return	The Entity if they overlap, or null if they don't.
*/
]]--
function Entity:collideWith(e)
   if(e.collidable==true)then
       if(GlobalFunctions:hasCollidedRect(self.image,e.image))then
           return e
       end
   end
   return nil
end


--[[
* Populates an array with all collided Entities of a type.
* @param	type		The Entity type to check for.
* @param	array		The Array or Vector object to populate.
* @return	The array, populated with all collided Entities.
--]]

function Entity:collideInto(type,array)
    if(array==nil)then array={} end
    if(self._world==nil)then return nil end

    local e=self._world._typeFirst[type]
    if(e~=nil)then return nil end

    local length=#array

    while(e~=nil)do
       if(e.collidable==true and e~=self and GlobalFunctions:hasCollidedRect(self.image,e.image))then
           length=length+1
           array[length]=e
       end
       e=e._typeNext
    end

   return array
end

--[[
* Populates an array with all collided Entities of multiple types.
* @param	types		An array of Entity types to check for.
* @param	array		The Array or Vector object to populate.
* @return	The array, populated with all collided Entities.
]]--

function Entity:collideTypesInto(types,array)
    if(self._world==nil)then return nil end
    for i,type in ipairs(types)do
       self:collideInto(type,array)
    end
    return array
end

function Entity:centerX()
    return self.x-self.originX+self.width/2
end

function Entity:centerY()
    return self.y-self.originY+self.height/2
end

function Entity:left()
    return self.image.contentBounds.xMin
end

function Entity:right()
    return self.image.contentBounds.xMax
end

function Entity:top()
    return self.image.contentBounds.yMin
end

function Entity:bottom()
    return self.image.contentBounds.yMax
end

function Entity:getType()
    return self._type;
end

function Entity:setType(value)
    if(_self._type~= value)then
       if(self._world==nil)then
           self._type=value
       else
           if(self._type~="")then
               self._world:removeType(self)
           end
           self._type=value
           if(value~=nil)then self._world:addType(self) end
       end
    end
end

function addGraphic(g)
    --if(graphic)
end


return Entity
