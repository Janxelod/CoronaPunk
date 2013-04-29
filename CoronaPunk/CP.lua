--
-- Created by IntelliJ IDEA.
-- User: Joan
-- Date: 04/04/13
-- Time: 02:58 PM
-- To change this template use File | Settings | File Templates.
--

require("table_AS3")

local scene=scene

local CP={}

--Ancho del Juego
CP.WIDTH=0

--Altura del Juego
CP.HEIGHT=0

--Mitad de la anchura del Juego
CP.HALFHEIGHT=0

--Mitad de la anchura del Juego
CP.HALFWIDTH=0

--El Framerate asignado al Juego
CP.FRAMERATE=0

--Tiempo transcurrido desde el ultimo frame
CP.ELAPSED=0

--Mundo activo
CP._WORLD=nil

--Mundo antes de estar activo
CP._GOTO=nil

--Tiempo transcurrido
CP.TIME=0

--Tiempo que transcurrio el update
CP.UPDATETIME=0
CP.GAMETIME=0

--Para convertir de DEG a RAD o RAD a DEG
CP.DEG=-180/3.141592653589793
CP.RAD=3.141592653589793/-180

CP.ENGINE=nil
CP.ENTITY=nil

--Metodos para obtener o setear el mundo
function CP:world()
    return CP._WORLD
end
function CP:setWorld(world)
    if(CP._WORLD==world)then
        return false
    end
    CP._GOTO=world
    return true
end
--Metodos para obtener o setear el mundo

function CP:choose(array)
     return array[math.random(#array)]
end

function CP:sign(value)
    if(value<0)then
        return -1
    elseif (value>0)then
        return 1
    end
    return 0
end

function CP:lerp(a,b,t)
    return a+(b-a)*t
end

--Finds the angle (in degrees) from point 1 to point 2.
--@param	x1		The first x-position.
--@param	y1		The first y-position.
--@param	x2		The second x-position.
--@param	y2		The second y-position.
--@return	The angle from (x1, y1) to (x2, y2).
function CP:angle(x1,y1,x2,y2)
    a=math.atan2(x2-x1,y2-y1)*CP.DEG
    if(a<0)then
        return a+360
    end
    return a
end

--* Sets the x/y values of the provided object to a vector of the specified angle and length.
--* @param	object		The object whose x/y properties should be set.
--* @param	angle		The angle of the vector, in degrees.
--* @param	length		The distance to the vector from (0, 0).
--* @param	x			X offset.
--* @param	y			Y offset.

function CP:angleXY(object,angle,length,x,y)
    if(length==nil)then length=1 end
    if(x==nil)then x=1 end
    if(y==nil)then y=1 end

    angle=angle*CP.RAD
    object.x=Math.cos(angle)*length+x
    object.y=Math.sin(angle)*length+y
end
--[[
/**
* Gets the difference of two angles, wrapped around to the range -180 to 180.
* @param	a	First angle in degrees.
* @param	b	Second angle in degrees.
* @return	Difference in angles, wrapped around to the range -180 to 180.
*/  ]]--

function CP:angleDiff(a,b)
    diff=b-a
    while(diff>180)do diff=diff-360 end
    while(diff<=-180)do diff=diff+360 end
    return diff
end

function CP:distance(x1,y1,x2,y2)
    local sqrt=Math.sqrt
    return sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))
end

function CP:distanceRects(x1,y1,w1,h1,x2,y2,w2,h2)
    if(x1<x2+w2 and x2<x1+w1)then
        if(y1<y2+h2 and y2<y1+w1)then return 0 end
        if(y1>y2)then return y1-(y2-h2) end
        return y2-(y1+h1)
    end
    if(y1<y2+h2 and y2<y1+h1)then
        if(x1>x2)then return x1-(x2+w2) end
        return (x2-(x1+w1))
    end
    if(x1>x2)then
       if(y1>y2)then return CP.distance(x1,y1,(x2+w2),(y2+h2)) end
       return CP.distance(x1,y1+h1,x2+w2,y2)
    end
    if(y1>y2)then return CP:distance(x1+w1,y1,x2,y2+h2) end

    return CP:distance(x1+w1,y1+h1,x2,y2)
end

--[[
* Clamps the value within the minimum and maximum values.
* @param	value		The Number to evaluate.
* @param	min			The minimum range.
* @param	max			The maximum range.
* @return	The clamped value.
]]--
function CP:clamp(value,min,max)
    if(max>min)then
        if(value<min)then return min
        elseif (value>max)then return max
        else return value
        end
    else
        if(value<max)then return max
        elseif(value>max)then return min
        else return value
        end
    end
end

function CP:scale(value, min, max, min2, max2)
    return min2 + ((value - min) / (max - min)) * (max2 - min2)
end

function CP:swap(current,a,b)
    if(current==a)then return b end
    return a
end

function CP:frames(from,to,skip)
    local a={}
    if(skip==nil)then skip=0 end
    skip = skip + 1
    if(from<to)then
        while(from<=to)do
            table.push(a,from)
            from=from+skip
        end
    else
        while(from>=to)do
            table.push(a,from)
            from=from-skip
        end
    end
    return a
end

