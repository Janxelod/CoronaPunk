local scene=scene
require("Class")
local Object =Class()--herencia de Base Class

function Object:initialize(img)
    
    local image=display.newImage(img)
    self.image=image
    self.colidable=true
end


function Object:show(config)
    local image=self.image
    image.x,image.y=config.x,config.y
    image.isVisible=true
end

function Object:hide()
    local image=self.image
    image.isVisible=false
end

function Object:update()
    
end
return Object
