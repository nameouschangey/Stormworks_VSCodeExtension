-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates
require("LifeBoatAPI.Vehicle.Utils.LBCopy")

---@class LBVec2
---@field x number for viewspace coordinates: (0 => leftmost, 1=>rightmost) x position to convert
---@field y number for viewspace coordinates: (0 => topmost, 1=> bottommost) y position to convert
---@section LBVec2 LBVEC2CLASS
LBVec2 = {
    ---@param cls LBVec2 class to instantiate
    ---@param x number x component of the new vector
    ---@param y number y component of the new vector
    ---@return LBVec2
    new = function(cls, x,y)
        return LBCopy(cls, {x=x,y=y})
    end;

    ---Adds the two vectors together
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return LBVec2 result
    ---@section lbvec2_add
    lbvec2_add = function(this,rhs)
        return this:new(this.x+rhs.x,this.y+rhs.y)
    end;
    ---@endsection

    ---Subtracts the given vector from this one
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return LBVec2 result
    ---@section lbvec2_sub
    lbvec2_sub = function (this,rhs)
        return this:new(this.x-rhs.x, this.y-rhs.y)
    end;
    ---@endsection

    ---Multiplies the components of each vector together
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return LBVec2 result
    ---@section lbvec2_multiply
    lbvec2_multiply = function (this,rhs)
        return this:new(this.x*rhs.x, this.y*rhs.y)
    end;
    ---@endsection

    ---Scales each component of this vector by the given quantity
    ---If you take a normalized LBVec2 as a direction, and scale it by a distance; you'll have a position
    ---@param this LBVec2
    ---@param scalar number factor to scale by
    ---@return LBVec2 result
    ---@section lbvec2_scale
    lbvec2_scale = function (this,scalar)
        return this:new(this.x*scalar, this.y*scalar)
    end;
    ---@endsection

    ---Sums the individual components of this vector
    ---@param this LBVec2
    ---@return number sum of the component parts
    ---@section lbvec2_sum
    lbvec2_sum = function (this)
        return this.x + this.y
    end;
    ---@endsection

    ---Calculates the Dot Product of the vectors
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return number
    ---@section lbvec2_dot
    lbvec2_dot = function (this,rhs)
        return this:lbvec2_multiply(rhs):lbvec2_sum()
    end;
    ---@endsection

    ---Gets the length (magnitude) of this vector
    ---i.e. gets the distance from this point; to the origin
    ---@param this LBVec2
    ---@return number length
    ---@section lbvec2_length
    lbvec2_length = function (this)
        return math.sqrt(this:lbvec2_multiply(this):lbvec2_sum())
    end;
    ---@endsection

    ---Gets the distance between two points represented as Vec2s
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return number distance
    ---@section lbvec2_distance
    lbvec2_distance = function(this,rhs)
        return this:lbvec2_sub(rhs):lbvec2_length()
    end;
    ---@endsection

    ---Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param this LBVec2
    ---@return LBVec2 result
    ---@section lbvec2_normalize
    lbvec2_normalize = function(this)
        return this:lbvec2_scale(1/this:lbvec2_length())
    end;
    ---@endsection

    ---Rotates the clockwise around the origin
    ---@param this LBVec2
    ---@param radians number radians to rotate this vector by, clockwise about the origin
    ---@return LBVec2 rotated vector rotated about the origin by the given radians
    ---@section lbvec2_rotate
    lbvec2_rotate = function (this, radians)
        return this:new(this.x * math.cos(radians) - this.y * math.sin(radians),
                        this.x * math.sin(radians) + this.y * math.cos(radians))
    end;
    ---@endsection

    ---Rotates clockwise around the given point, by the given number of radians
    ---@param this LBVec2
    ---@param radians number radians to rotate, clockwise around
    ---@param point LBVec2 point to rotate around
    ---@return LBVec2 rotated
    ---@section lbvec2_rotateAround
    lbvec2_rotateAround = function(this, radians, point)
        return this:lbvec2_sub(point):lbvec2_rotate(radians):lbvec2_add(point)
    end;
    ---@endsection

    --- Cross product of two 2D vectors
    --- Returned result is the magnitude of a vector on the "z" plane (which doesn't exist for these vectors)
    --- As such, returns a scalar; even though this should technically be a vector3
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "this", index finger is "rhs"
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return number 2D cross product, as a scalar (Note cross product is poorly defined for Vec2 - but has some uses)
    ---@section lbvec2_cross
    lbvec2_cross = function(this, rhs)
        return this.x*rhs.y - this.y*rhs.x
    end;
    ---@endsection

    --- Cross product of two 2D vectors, resulting in a 3D vector
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "this", index finger is "rhs"
    ---@param this LBVec2
    ---@param rhs LBVec2
    ---@return LBVec3 resulting vector3, that will point "out" of the screen along the z axis
    ---@section lbvec2_crossVec3
    lbvec2_crossVec3 = function(this, rhs)
        return LBVec3(0,0,this.x*rhs.y - this.y*rhs.x)
    end;
    ---@endsection

    --- Calculates the angle between this vector and the vertical (0,1)
    --- If this is a position vector; the line is between this vector (x,y) to the origin (0,0)
    ---@param this LBVec2
    ---@return number radians the positive clockwise angle between this vector and the vertical (0,1)
    ---@section lbvec2_angle
    lbvec2_angle = function(this)
        local angle = math.atan(this.x, this.y) -- intentionally using atan the "wrong" around so that (0,1) is 0*; and +degrees is clockwise, which is easier for most people to conceptualize
        return (angle >= 0 and angle) or (LBAngles_2PI + angle)
    end;
    ---@endsection

    ---Gets the clockwise angle from vertical (0,1), of this point around the given point
    ---@param this LBVec2
    ---@return number radians
    ---@section lbvec2_angleAround
    lbvec2_angleAround = function(this, point)
        return this:lbvec2_sub(point):lbvec2_angle()
    end;
    ---@endsection
};
---@endsection LBCANVASCLASS
