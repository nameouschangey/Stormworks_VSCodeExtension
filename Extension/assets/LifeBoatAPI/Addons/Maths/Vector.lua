---@section LifeBoatAPI.VectorBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection

--- note: Provides mutable (m_) and immutable () variants of relevant functions for performance
---@class LifeBoatAPI.Vector
---@field x number conventionally: mapX axis
---@field y number conventionally: altitude
---@field z number conventionally: mapZ axis
LifeBoatAPI.Vector = {

    ---@param this LifeBoatAPI.Vector
    ---@param x number x component
    ---@param y number y component; conventially represents the altitude
    ---@param z number z component
    ---@overload fun(cls:LifeBoatAPI.Vector, x:number, y:number):LifeBoatAPI.Vector creates a vector2 (z-component is 0)
    ---@overload fun(cls:LifeBoatAPI.Vector):LifeBoatAPI.Vector creates a new zero-initialized vector3
    ---@return LifeBoatAPI.Vector
    new = function(this, x, y, z)
        return LifeBoatAPI.Classes.instantiate(this, {
            x=x or 0,
            y=y or 0,
            z=z or 0})
    end;

    --- from: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    --- x=Rcos(el)cos(az)
    --- y=Rsin(el)
    --- z=Rcos(el)sin(az)
    ---@param azimuth number azimuth angle, 0 north -> 2pi north
    ---@param elevation number elevation +/- pi/2 radians from horizon
    ---@param distance number
    ---@return LifeBoatAPI.Vector
    newFromAzimuthElevation = function(cls, azimuth, elevation, distance)
        return cls:new(
            distance * math.cos(elevation) * math.sin(azimuth),
            distance * math.sin(elevation),
            distance * math.cos(elevation) * math.cos(azimuth))
    end;

    -- check two vectors are equal in contents
    ---@param this LifeBoatAPI.Vector
    ---@param other LifeBoatAPI.Vector
    ---@return boolean areEqual
    equals = function(this, other)
        return this.x == other.x and this.y == other.y and this.z == other.z
    end;

    ---(Mutable) sets the components of this vector directly
    ---@param this LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector this chainable
    m_set = function(this, x, y, z)
        this.x = x or this.x
        this.y = y or this.y
        this.z = z or this.z
        return this
    end;

    ---Unpacks the values of this vector for use in other functions parameter lists, etc.
    ---@param this LifeBoatAPI.Vector
    ---@return number x,number y,number z
    unpack = function(this)
        return this.x, this.y, this.z
    end;

    ---(Mutable) Adds the two vectors together
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    m_add = function(this, rhs)
        this.x = this.x + rhs.x
        this.y = this.y + rhs.y
        this.z = this.z + rhs.z
        return this
    end;

    ---Adds the two vectors together
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    add = function(this, rhs)
        return this:new(this.x+rhs.x,this.y+rhs.y,this.z+rhs.z)
    end;

    ---(Mutable) Subtracts the given vector from this one
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    m_sub = function (this, rhs)
        this.x = this.x - rhs.x
        this.y = this.y - rhs.y
        this.z = this.z - rhs.z
        return this
    end;

    ---Subtracts the given vector from this one
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    sub = function (this, rhs)
        return this:new(this.x-rhs.x, this.y-rhs.y, this.z-rhs.z)
    end;

    ---(Mutable) Lerp (linear interpolation) between the this vector and the given vector
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@param t number 0->1 expected
    ---@return LifeBoatAPI.Vector result
    m_lerp = function (this, rhs, t)
        oneMinusT = 1 - t
        this.x = oneMinusT*this.x + t*rhs.x
        this.y = oneMinusT*this.y + t*rhs.y
        this.z = oneMinusT*this.z + t*rhs.z
        return this
    end;

    --- Lerp (linear interpolation) between the this vector and the given vector
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@param t number 0->1 expected
    ---@return LifeBoatAPI.Vector result
    lerp = function (this, rhs, t)
        oneMinusT = 1 - t
        return this:new(oneMinusT*this.x + t*rhs.x,
                        oneMinusT*this.y + t*rhs.y,
                        oneMinusT*this.z + t*rhs.z)
    end;

    ---(Mutable) Multiplies the components of each vector together
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    m_multiply = function (this, rhs)
        this.x = this.x * rhs.x
        this.y = this.y * rhs.y
        this.z = this.z * rhs.z
        return this
    end;

    ---Multiplies the components of each vector together
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    multiply = function (this, rhs)
        return this:new(this.x*rhs.x, this.y*rhs.y, this.z*rhs.z)
    end;

    ---(Mutable)Scales each component of this vector by the given quantity
    ---If you take a normalized LifeBoatAPI.Vector3 as a direction, and scale it by a distance; you'll have a position
    ---@param this LifeBoatAPI.Vector
    ---@param scalar number factor to scale by
    ---@return LifeBoatAPI.Vector result
    m_scale = function (this, scalar)
        this.x = this.x * scalar
        this.y = this.y * scalar
        this.z = this.z * scalar
        return this
    end;

    ---(Immutable) Scales each component of this vector by the given quantity
    ---If you take a normalized LifeBoatAPI.Vector3 as a direction, and scale it by a distance; you'll have a position
    ---@param this LifeBoatAPI.Vector
    ---@param scalar number factor to scale by
    ---@return LifeBoatAPI.Vector result
    scale = function (this, scalar)
        return this:new(this.x*scalar, this.y*scalar, this.z*scalar)
    end;

    ---Sums the individual components of this vector
    ---@param this LifeBoatAPI.Vector
    ---@return number sum of the component parts
    sum = function (this)
        return this.x + this.y + this.z
    end;

    ---Calculates the Dot Product of the vectors
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return number
    dot = function (this, rhs)
        return (this.x * rhs.x) + (this.y * rhs.y) + (this.z * rhs.z)
    end;

    ---Gets the length (magnitude) of this vector
    ---i.e. gets the distance from this point; to the origin
    ---@param this LifeBoatAPI.Vector
    ---@return number length
    length = function (this)
        return math.sqrt((this.x * this.x) + (this.y * this.y) + (this.z * this.z))
    end;

    ---Gets the length SQUARED (magnitude) of this vector
    ---i.e. gets the squared distance from this point; to the origin
    ---Useful for collision detection/distance comparisons
    ---@param this LifeBoatAPI.Vector
    ---@return number lengthSquared
    length2 = function (this)
        return (this.x * this.x) + (this.y * this.y) + (this.z * this.z)
    end;

    ---Gets the distance between two points represented as Vecs
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return number distance
    distance = function(this, rhs)
        local x = this.x - rhs.x
        local y = this.y - rhs.y
        local z = this.z - rhs.z
        return math.sqrt((x * x) + (y * y) + (z * z))
    end;

    ---Gets the SQUARED distance between two points represented as Vecs
    ---Useful for collision detection/distance comparisons
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return number distanceSquared
    distance2 = function(this, rhs)
        local x = this.x - rhs.x
        local y = this.y - rhs.y
        local z = this.z - rhs.z
        return (x * x) + (y * y) + (z * z)
    end;

    ---(Mutable)Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param this LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    m_normalize = function(this)
        local length = math.sqrt((this.x * this.x) + (this.y * this.y) + (this.z * this.z))
        local lengthReciprocal = length ~= 0 and 1/length or 0
        this.x = this.x * lengthReciprocal
        this.y = this.y * lengthReciprocal
        this.z = this.z * lengthReciprocal
    end;

    ---(Immutable) Normalizes the vector so the magnitude is 1
    ---Ideal for directions; as they can then be multipled by a scalar distance to get a position
    ---@param this LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector result
    normalize = function(this)
        local length = math.sqrt((this.x * this.x) + (this.y * this.y) + (this.z * this.z))
        local lengthReciprocal = length ~= 0 and 1/length or 0
        return this:new(this.x * lengthReciprocal, this.y * lengthReciprocal, this.z * lengthReciprocal)
    end;

    ---(Mutable)Cross product of two 3d vectors
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "lhs", index finger is "rhs"
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector
    m_cross = function(this, rhs)
        this.x = this.y*rhs.z - this.z*rhs.y
        this.y = this.z*rhs.x - this.x*rhs.z
        this.z = this.x*rhs.y - this.y*rhs.x
    end;

    --- (Immutable) Cross product of two 3d vectors
    --- Direction determined by left-hand-rule; thumb is result, middle finger is "lhs", index finger is "rhs"
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector
    cross = function(this, rhs)
        return this:new(this.y*rhs.z - this.z*rhs.y,
                        this.z*rhs.x - this.x*rhs.z,
                        this.x*rhs.y - this.y*rhs.x)
    end;

    --- Reflects this vector about the given normal
    --- Normal is expected to be in the same direction as this vector, and will return the reflection circularly about that vector
    ---@param this LifeBoatAPI.Vector
    ---@param normal LifeBoatAPI.Vector
    ---@return LifeBoatAPI.Vector
    reflected = function(this, normal)
        -- r=d−2(d⋅n)n where r is the reflection, d is the vector, v is the normal to reflect over
        -- normally expects rays to be like light, coming into the mirror and bouncing off. We negate the parts to make this work in our favour
        normal = normal:normalize()
        this = this:scale(-1)
        return this:m_sub(normal:m_scale(2 * this:dot(normal)))
    end;

    ---Calculates the shortest angle between two vectors
    ---Note, angle is NOT signed
    ---@param this LifeBoatAPI.Vector
    ---@param rhs LifeBoatAPI.Vector
    ---@return number
    anglebetween = function(this, rhs)
        return math.acos(this:dot(rhs) / (this:length() * rhs:length()))
    end;

    ---Converts the vector into spatial coordinates as an azimuth, elevation, distance triplet
    ---Formula from mathworks: https://www.mathworks.com/help/phased/ug/spherical-coordinates.html
    ---R=sqrt(x2+y2+z2)
    ---az=tan−1(y/x)
    ---el=tan−1(z/sqrt(x2+y2))
    ---@param this LifeBoatAPI.Vector
    ---@return number,number,number components azimuth (North is 0), elevation (Horizon is 0), distance
    azimuthElevation= function(this)
        normalized = this:normalize()
        return  math.atan(normalized.x, normalized.y),
                math.atan(normalized.z, math.sqrt(normalized.x*normalized.x + normalized.y*normalized.y)),
                this:length()
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.Vector", LifeBoatAPI.Vector)
