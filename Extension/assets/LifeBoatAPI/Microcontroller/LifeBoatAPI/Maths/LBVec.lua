-- developed by nameouschangey (Gordon Mckendrick) for use with LifeBoat Modding framework
-- please see: https://github.com/nameouschangey/STORMWORKS for updates

require("LifeBoatAPILocal.Utils.LBCopy")

---@class LBVec
---@field x number for viewspace coordinates: (0 => leftmost, 1=>rightmost) x position to convert
---@field y number for viewspace coordinates: (0 => topmost, 1=> bottommost) y position to convert
---@field z number only used in 3D calculations
---@section LBVec 1 LBVECCLASS
LifeBoatAPI.LBVec = {
    ---@param cls LBVec
    ---@param x number x component
    ---@param y number y component
    ---@param z number z component; conventially represents the altitude
    ---@overload fun(cls:LBVec, x:number, y:number):LBVec creates a vector2 (z-component is 0)
    ---@overload fun(cls:LBVec):LBVec creates a new zero-initialized vector3
    ---@return LBVec
    new = function(cls,x,y,z)
        return LifeBoatAPI.lb_copy(cls, {x=x or 0,y=y or 0,z=z or 0})
    end;

    --- from: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    --- x=Rcos(el)cos(az)
    --- y=Rcos(el)sin(az)
    --- z=Rsin(el)
    ---@return LBVec
    ---@section newFromAzimuthElevation
    newFromAzimuthElevation = function(cls, azimuth, elevation, distance)
        return cls:new(
            distance * math.cos(elevation) * math.sin(azimuth),
            distance * math.cos(elevation) * math.cos(azimuth),
            distance * math.sin(elevation))
    end;
    ---@endsection

    ---Adds the two vectors together
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    ---@section lbvec_add
    lbvec_add = function(this,rhs)
        return this:new(this.x+rhs.x,this.y+rhs.y,this.z+rhs.z)
    end;
    ---@endsection

    ---Subtracts the given vector from this one
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    ---@section lbvec_sub
    lbvec_sub = function (this,rhs)
        return this:new(this.x-rhs.x, this.y-rhs.y, this.z-rhs.z)
    end;
    ---@endsection

    ---Subtracts the given vector from this one
    ---@param this LBVec
    ---@param rhs LBVec
    ---@param t number 0->1 expected
    ---@return LBVec result
    ---@section lbvec_sub
    lbvec_lerp = function (this,rhs, t)
        oneMinusT = 1 - t
        return this:new(oneMinusT*this.x + t*rhs.x,
                        oneMinusT*this.y + t*rhs.y,
                        oneMinusT*this.z + t*rhs.z)
    end;
    ---@endsection

    ---Multiplies the components of each vector together
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return LBVec result
    ---@section lbvec_multiply
    lbvec_multiply = function (this,rhs)
        return this:new(this.x*rhs.x, this.y*rhs.y, this.z*rhs.z)
    end;
    ---@endsection

    ---Scales each component of this vector by the given quantity
    ---If you take a normalized LBVec3 as a direction, and scale it by a distance; you'll have a position
    ---@param this LBVec
    ---@param scalar number factor to scale by
    ---@return LBVec result
    ---@section lbvec_scale
    lbvec_scale = function (this,scalar)
        return this:new(this.x*scalar, this.y*scalar, this.z*scalar)
    end;
    ---@endsection

    ---Sums the individual components of this vector
    ---@param this LBVec
    ---@return number sum of the component parts
    ---@section lbvec_sum
    lbvec_sum = function (this)
        return this.x + this.y + this.z
    end;
    ---@endsection

    ---Calculates the Dot Product of the vectors
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return number
    ---@section lbvec_dot
    lbvec_dot = function (this,rhs)
        return this:lbvec_multiply(rhs):lbvec_sum()
    end;
    ---@endsection

    ---Gets the length (magnitude) of this vector
    ---i.e. gets the distance from this point; to the origin
    ---@param this LBVec
    ---@return number length
    ---@section lbvec_length
    lbvec_length = function (this)
        return math.sqrt(this.x*this.x + this.y*this.y + this.z*this.z)
    end;
    ---@endsection

    ---Gets the distance between two points represented as Vec2s
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return number distance
    ---@section lbvec_distance
    lbvec_distance = function(this,rhs)
        return this:lbvec_sub(rhs):lbvec_length()
    end;
    ---@endsection

    ---Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param this LBVec
    ---@return LBVec result
    ---@section lbvec_normalize
    lbvec_normalize = function(this)
        return this:lbvec_scale(1/this:lbvec_length())
    end;
    ---@endsection

    --- Cross product of two 3d vectors
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "lhs", index finger is "rhs"
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return LBVec
    ---@section lbvec_cross
    lbvec_cross = function(this, rhs)
        return this:new(this.y*rhs.z - this.z*rhs.y,
                        this.z*rhs.x - this.x*rhs.z,
                        this.x*rhs.y - this.y*rhs.x)
    end;
    ---@endsection

    --- Reflects this vector about the given normal
    --- Normal is expected to be in the same direction as this vector, and will return the reflection circularly about that vector
    ---@param this LBVec
    ---@param normal LBVec
    ---@return LBVec
    ---@section lbvec_reflect
    lbvec_reflect = function(this, normal)
        -- r=d−2(d⋅n)n where r is the reflection, d is the vector, v is the normal to reflect over
        -- normally expects rays to be like light, coming into the mirror and bouncing off. We negate the parts to make this work in our favour
        normal = normal:lbvec_normalize() -- ensure the vectors are the right direction
        this = this:lbvec_scale(-1)
        return this:lbvec_sub(normal:lbvec_scale(2 * this:lbvec_dot(normal)))
    end;
    ---@endsection

    ---Calculates the shortest angle between two vectors
    ---Note, angle is NOT signed
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return number
    ---@section lbvec_anglebetween
    lbvec_anglebetween = function(this, rhs)
        return math.acos(this:lbvec_dot(rhs) / (this:lbvec_length() * rhs:lbvec_length()))
    end;
    ---@endsection

    ---Converts the vector into spatial coordinates as an azimuth, elevation, distance triplet
    ---Formula from mathworks: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    ---R=sqrt(x2+y2+z2)
    ---az=tan−1(y/x)
    ---el=tan−1(z/sqrt(x2+y2))
    ---@param this LBVec
    ---@return number,number,number components azimuth (North is 0), elevation (Horizon is 0), distance
    ---@section lbvec_azimuthElevation
    lbvec_azimuthElevation= function(this)
        normalized = this:lbvec_normalize()
        return  math.atan(normalized.x, normalized.y),
                math.atan(normalized.z, math.sqrt(normalized.x*normalized.x + normalized.y*normalized.y)),
                this:lbvec_length()
    end;
    ---@endsection

---------------------- special cases for 2D vector maths, generally used for displaying on screen
    ---Rotates the clockwise around the origin
    ---@param this LBVec
    ---@param radians number radians to rotate this vector by, clockwise about the origin
    ---@return LBVec rotated vector rotated about the origin by the given radians
    ---@section lbvec_rotate2D
    lbvec_rotate2D = function (this, radians)
        return this:new(this.x * math.cos(radians) - this.y * math.sin(radians),
                        this.x * math.sin(radians) + this.y * math.cos(radians),
                        this.z)
    end;
    ---@endsection

    ---Rotates clockwise around the given point, by the given number of radians
    ---@param this LBVec
    ---@param radians number radians to rotate, clockwise around
    ---@param point LBVec point to rotate around
    ---@return LBVec rotated
    ---@section lbvec_rotateAround2D
    lbvec_rotateAround2D = function(this, radians, point)
        return this:lbvec_sub(point):lbvec_rotate2D(radians):lbvec_add(point)
    end;
    ---@endsection

    --- Cross product of two 2D vectors
    --- Returned result is the magnitude of a vector on the "z" plane (which doesn't exist for these vectors)
    --- As such, returns a scalar; even though this should technically be a vector3
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "this", index finger is "rhs"
    ---@param this LBVec
    ---@param rhs LBVec
    ---@return number 2D cross product, as a scalar (Note cross product is poorly defined for Vec2 - but has some uses)
    ---@section lbvec_cross2D
    lbvec_cross2D = function(this, rhs)
        return this.x*rhs.y - this.y*rhs.x
    end;
    ---@endsection

    --- Calculates the angle between this vector and the vertical (0,1)
    --- If this is a position vector; the line is between this vector (x,y) to the origin (0,0)
    ---@param this LBVec
    ---@return number radians the positive clockwise angle between this vector and the vertical (0,1)
    ---@section lbvec_angle2D
    lbvec_angle2D = function(this)
        local angle = math.atan(this.x, this.y) -- intentionally using atan the "wrong" way around so that (0,1) is 0*; and +degrees is clockwise, which is easier for most people to conceptualize
        return angle >= 0 and angle or math.pi * 2 + angle
    end;
    ---@endsection

    ---Gets the clockwise angle from vertical (0,1), of this point around the given point
    ---@param this LBVec
    ---@return number radians
    ---@section lbvec_angleAround2D
    lbvec_angleAround2D = function(this, point)
        return this:lbvec_sub(point):lbvec_angle2D()
    end;
    ---@endsection
}
---@endsection LBVECCLASS