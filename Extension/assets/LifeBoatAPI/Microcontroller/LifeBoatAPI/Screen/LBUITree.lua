-------------------------------------------------------------------------------------------
require("LifeBoatAPI.Maths.LBVec2")

-- use a copy of the tree for this
function lb_uielement(type,x,y,rx,ry,element)
    return LBCopy({
        type      = type,
        pos       = LBVec2:new(x,y),
        z         = 0,
        angle     = 0,
        points    = {},
        size      = LBVec2:new(rx,ry),
        children  = {},
        ontouch   = LBEmptyFunction,
        touch     = {isDown = false}
    },element or {})
end

function lb_circle(x,y,radius,element)
    return lb_uielement(lb_drawCircle,x,y,radius,radius,element)
end

function lb_rect(x,y,width,height,element)
    return lb_uielement(lb_drawRect,x,y,width,height,element)
end

function lb_text(x,y,text,element)
    element.text = text
    return lb_uielement(lb_drawText,x,y,4*#text,5,element)
end

function lb_line(x,y,points,element)
    element.points = points
    return lb_uielement(lb_drawLine,x,y,0,0,element)
end

function lb_polygon(x,y,step,points,element)
    element.points = points
    element.step = step
    return lb_uielement(lb_drawPolygon,x,y,0,0,element)
end

-------------------------------------------------------------------------------------------
function lb_drawTree(drawables,_drawable)
    for i=#drawables,1,-1 do
        _drawable = drawables[i]
        screen.setColor(_drawable.colour.r, _drawable.colour.g, _drawable.colour.b, _drawable.colour.a)
        _drawable.type(_drawable)
    end
end

function lb_drawRect(element)
    (element.drawFunc or screen.drawRectF)(element.aabb1.x, element.aabb1.y, element.size.x, element.size.y)
end

function lb_drawCircle(element)
    (element.drawFunc or screen.drawCircleF)(element.pos.x, element.pos.y, element.size.x)
end

function lb_drawText(element)
    screen.drawText(element.aabb1.x, element.pos.y - 2, element.text)
end

function lb_drawLine(element)
    for i=1,#element.points-1 do
        screen.drawLine(
            element.points[i].x,
            element.points[i].y,
            element.points[i+1].x,
            element.points[i+1].y)
    end
end

function lb_drawPolygon(element)
    for i=1,#element.points-2,element.step do
        (element.drawFunc or screen.drawTriangleF)(
            element.points[i].x,
            element.points[i].y,
            element.points[i+1].x,
            element.points[i+1].y,
            element.points[i+2].x,
            element.points[i+2].y)
    end
end

-------------------------------------------------------------------------------------------
---@return table flattened ui-tree
function lb_prepareTree(root)
    function lb_prepareTree_internal(parent)
        drawables[#drawables + 1] = parent
        for _,child in pairs(parent.children) do -- regular pairs, because if we like we can use named trees
            --child           = LBCopy(child)
            child.angle     = child.angle + parent.angle
            child.pos       = child.pos:lbvec2_rotate(child.angle):lbvec2_add(parent.pos)
            child.z         = child.z + parent.z
            child.colour    = child.colour or parent.colour
            child.aabb1     = child.pos:lb_vec2_add(child.size)
            child.aabb2     = child.pos:lb_vec2_sub(child.size)
            for i=1,#child.points do
                child.points[i] = child.points[i]:lbvec2_rotate(child.angle):lbvec2_add(child.pos)
            end
            lb_prepareTree_internal(child)
        end
    end
    drawables = {}
    lb_prepareTree_internal(root)
    table.sort(drawables, function(a,b) return a.z > b.z end)
    return drawables
end

function lb_touchTree(drawables, touchpos, wasDown, isDown, _drawable, _hovering, _wasDown)
    for i=1,#drawables do
        _drawable = drawables[i]
        -- do something to figure out touch and how we do this
        -- could end up being 90% of the code which is frustrating
        _hovering = not (
            _drawable.aabb1.x > touchpos.x or
            _drawable.aabb1.y > touchpos.y or
            _drawable.aabb2.x < touchpos.x or
            _drawable.aabb2.x < touchpos.y
        )
        
        _wasDown = _drawable.touch.isDown
        _drawable.touch.isDown = _hovering and ((isDown and not wasDown) or (_wasDown and isDown))
        if (_wasDown or _drawable.touch.isDown) and _drawable:ontouch(_hovering, _wasDown, _drawable.touch.isDown) then
            return -- swallow touch event on first UI that claims it
        end
    end
end
-------------------------------------------------------------------------------------------