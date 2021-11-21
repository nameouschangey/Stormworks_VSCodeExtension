require("Utils.LBBase")

---@class LBVec : LBBaseClass
---@field x number x component
---@field y number y component
---@field z number z component
---@field w number w component
LBVec = {
    ---vector from x,y,z,w components
    ---@param x number x component
    ---@param y number y component
    ---@param z number z component
    ---@param w number w component
    vec4 = function(this, x, y, z, w)
        return this:new(x,y,z,w)
    end;

    ---vector from x,y,z components
    ---@param x number x component
    ---@param y number y component
    ---@param z number z component
    vec3 = function(this, x, y, z)
        return this:new(x,y,z)
    end;

    ---vector from x,y component
    ---@param x number x component
    ---@param y number y component
    vec2 = function(this, x, y)
        return this:new(x,y)
    end;

    ---vec4 with all elements zero
    zero = function(this)
        return this:new()
    end;


    new = function(this, x, y, z, w)
        this = LBBaseClass.new(this)
        this.x = x or 0
        this.y = y or 0
        this.z = z or 0
        this.w = w or 0
    end;

    ---subtract vectors and return new vector representing the result
    ---@param rhs LBVec vector to subtract from this one
    ---@return LBVec new vector
    sub = function(this, rhs)
        return LBVec:new(this.x - rhs.x,
                         this.y - rhs.y,
                         this.z - rhs.z,
                         this.w - rhs.w)
    end;

    ---add vectors and return new vector representing the result
    ---@param rhs LBVec vector to add to this one
    ---@return LBVec new vector
    add = function(this, rhs)
        return LBVec:vec4(this.x + rhs.x,
                          this.y + rhs.y,
                          this.z + rhs.z,
                          this.w + rhs.w)
    end;

    ---scales the vector and return new vector representing the result
    ---@param scalar number scalar to multiply each component by
    ---@return LBVec new vector
    scale = function(this, scalar)
        return LBVec:vec4(this.x * scalar,
                          this.y * scalar,
                          this.z * scalar,
                          this.w * scalar)
    end;

    ---dot product of two vectors
    ---@param rhs LBVec vector to add to this one
    ---@return number
    dot = function(this, rhs)
        return (this.x * rhs.x) + (this.y * rhs.y) + (this.z * rhs.z) + (this.w * rhs.w)
    end;

    ---gets the squared-magnitude of this vector, useful for some thing
    ---@return number
    magnitudeSquared = function(this)
        return this:dot(this)
    end;

    ---gets the magnitude of this vector
    ---@return number
    magnitude = function(this)
        return math.sqrt(this:dot(this))
    end;

    ---distance between two vectors
    ---@param rhs LBVec vector to get distance to
    ---@return number
    distance = function(this, rhs)
        return this:sub(rhs):magnitude()
    end;

    ---create a normalized version of this vector
    ---@return LBVec new vector
    normalize = function(this)
        local magnitude = this:magnitude()
        if(magnitude == 0) then
            return LBVec:zero()
        end

        return this:scale(1 / magnitude)
    end;

    ---linear interpolation between two vectors, returns result as new vector
    ---@return LBVec new vector
    lerp = function(this, rhs, t)
        return this:scale(1-t):add(rhs:scale(t))
    end;

}
LBClass(LBVec)
