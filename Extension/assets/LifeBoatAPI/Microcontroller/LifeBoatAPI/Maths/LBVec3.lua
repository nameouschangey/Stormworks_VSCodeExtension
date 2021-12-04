-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPI.Utils.LBCopy")

---@class LBVec3
---@field x number for viewspace coordinates: (0 => leftmost, 1=>rightmost) x position to convert
---@field y number for viewspace coordinates: (0 => topmost, 1=> bottommost) y position to convert
---@field z number for viewspace coordinates: (0 => topmost, 1=> bottommost) y position to convert
---@section LBVec3 LBVEC3CLASS
LBVec3 = {
    ---@param cls LBVec3
    ---@param x number x component
    ---@param y number y component
    ---@param z number z component
    ---@return LBVec3
    lbvec3_new = function(cls,x,y,z)
        return LBCopy(cls, {x=x,y=y,z=z})
    end;

    ---Adds the two vectors together
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return LBVec3 result
    ---@section lbvec3_add
    lbvec3_add = function(this,rhs)
        return this:lbvec3_new(this.x+rhs.x,this.y+rhs.y,this.z+rhs.z)
    end;
    ---@endsection

    ---Subtracts the given vector from this one
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return LBVec3 result
    ---@section lbvec3_sub
    lbvec3_sub = function (this,rhs)
        return this:lbvec3_new(this.x-rhs.x, this.y-rhs.y, this.z-rhs.z)
    end;
    ---@endsection

    ---Multiplies the components of each vector together
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return LBVec3 result
    ---@section lbvec3_multiply
    lbvec3_multiply = function (this,rhs)
        return this:lbvec3_new(this.x*rhs.x, this.y*rhs.y, this.z*rhs.z)
    end;
    ---@endsection

    ---Scales each component of this vector by the given quantity
    ---If you take a normalized LBVec3 as a direction, and scale it by a distance; you'll have a position
    ---@param this LBVec3
    ---@param scalar number factor to scale by
    ---@return LBVec3 result
    ---@section lbvec3_scale
    lbvec3_scale = function (this,scalar)
        return this:lbvec3_new(this.x*scalar, this.y*scalar, this.z*scalar)
    end;
    ---@endsection

    ---Sums the individual components of this vector
    ---@param this LBVec3
    ---@return number sum of the component parts
    ---@section lbvec3_sum
    lbvec3_sum = function (this)
        return this.x + this.y + this.z
    end;
    ---@endsection

    ---Calculates the Dot Product of the vectors
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return number
    ---@section lbvec3_dot
    lbvec3_dot = function (this,rhs)
        return this:lbvec3_multiply(rhs):lbvec3_sum()
    end;
    ---@endsection

    ---Gets the length (magnitude) of this vector
    ---i.e. gets the distance from this point; to the origin
    ---@param this LBVec3
    ---@return number length
    ---@section lbvec3_length
    lbvec3_length = function (this)
        return math.sqrt(this:lbvec3_multiply(this):lbvec3_sum())
    end;
    ---@endsection

    ---Gets the distance between two points represented as Vec2s
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return number distance
    ---@section lbvec3_distance
    lbvec3_distance = function(this,rhs)
        return this:lbvec3_sub(rhs):lbvec3_length()
    end;
    ---@endsection

    ---Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param this LBVec3
    ---@return LBVec3 result
    ---@section lbvec3_normalize
    lbvec3_normalize = function(this)
        return this:lbvec3_scale(1/this:lbvec3_length())
    end;
    ---@endsection

    --- Cross product of two 3d vectors
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "lhs", index finger is "rhs"
    ---@param this LBVec3
    ---@param rhs LBVec3
    ---@return LBVec3
    ---@section lbvec3_cross
    lbvec3_cross = function(this, rhs)
        return LBVec3:lbvec3_new((this.y*rhs.z - this.z*rhs.y),
                                 (this.z*rhs.x - this.x*rhs.z),
                                 (this.x*rhs.y - this.y*rhs.x))
    end;

    
    ---@endsection
};
---@endsection LBVEC3CLASS