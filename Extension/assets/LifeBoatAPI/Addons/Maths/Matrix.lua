---@section LifeBoatAPI.MatrixBOILERPLATE
-- Author: Nameous Changey
-- GitHub: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension
-- Workshop: https://steamcommunity.com/id/Bilkokuya/myworkshopfiles/?appid=573090
--- Developed using LifeBoatAPI - Stormworks Lua plugin for VSCode - https://code.visualstudio.com/download (search "Stormworks Lua with LifeboatAPI" extension)
--- If you have any issues, please report them here: https://github.com/nameouschangey/STORMWORKS_VSCodeExtension/issues - by Nameous Changey
---@endsection


-- moving the matrix maths into lua gives a performance gain
-- as each call to the game is incredibly slow

-- note the world is an XZ plane with Y altitude
-- (map coordinate xy is actually xz. x positive left->right, z positive bottom->top, y positive lower -> higher)
-- default "forward" for objects is facing down z-axis

--- Represents a very simple version of a 4x4 matrix
--- note: Provides mutable (m_) and immutable () variants of relevant functions for performance
--- "quick" versions of functions expect the Matrix is a simple "Rotate then Translate" matrix, with large performance gains (can be used for 99% of SW cases)
--- If you are reading the source, please bear in mind everything has been "unrolled" for function-use reduction, at the expense of severely less maintainable
---     This is only justifiable here where Matrix maths can become a serious performance issue if used extensively
---@class LifeBoatAPI.Matrix : SWMatrix
---@field IndexX number helper constant myMatrix[LifeBoatAPI.Matrix.IndexX]
---@field IndexY number helper constant myMatrix[LifeBoatAPI.Matrix.IndexY]
---@field IndexZ number helper constant myMatrix[LifeBoatAPI.Matrix.IndexZ]
LifeBoatAPI.Matrix = {
    IndexX = 13,
    IndexY = 14,
    IndexZ = 15,

    ---Creates a new simple 4x4 matrix, compatible with Stormworks functions
    ---Holds a translation (posXYZ) and an orientation (yaw,pitch,roll)
    ---@param this LifeBoatAPI.Matrix
    ---@param posX number x-position/translation component
    ---@param posY number y-position/translation component
    ---@param posZ number z-position/translation component
    ---@param pitch number pitch angle (x-axis rotation) in radians
    ---@param yaw number yaw angle (y-axis rotation) in radians
    ---@param roll number roll angle (z-axis rotation) in radians
    ---@overload fun(this, x: number, y:number, z:number, rotX:number, rotY:number, rotZ:number)
    ---@return LifeBoatAPI.Matrix
    new = function(this, posX, posY, posZ, pitch, yaw, roll)
        yaw     = yaw or 0
        pitch   = pitch or 0
        roll    = roll or 0

        -- Y - yaw, P - pitch, R - roll, in most diagrams that would be A-yaw, B-pitch, Y-roll
        sinRoll = roll ~= 0 and math.sin(-roll) or 0
        cosRoll = roll ~= 0 and math.cos(-roll) or 1

        sinYaw = yaw ~= 0 and math.sin(-yaw) or 0
        cosYaw = yaw ~= 0 and math.cos(-yaw) or 1

        sinPitch = pitch ~= 0 and math.sin(-pitch) or 0
        cosPitch = pitch ~= 0 and math.cos(-pitch) or 1

        return LifeBoatAPI.Classes.instantiate(this, {
            -- first 16 numerical values match what gets sent to the game
            cosRoll*cosYaw,  cosRoll*sinYaw*sinPitch - sinRoll*cosPitch, cosRoll*sinYaw*cosPitch + sinRoll*sinPitch,     0,
            sinRoll*cosYaw,  sinRoll*sinYaw*sinPitch + cosRoll*cosPitch, sinRoll*sinYaw*cosPitch - cosRoll*sinPitch,     0,
            -sinYaw,      cosYaw*sinPitch,                  cosYaw*cosPitch,                      0,
            posX,       posY,                       posZ,                           1
        })
    end;

    ---Creates a new LifeBoatAPI.Matrix instance from an existing array of 16 entries
    ---Can be used for wrapping stormworksAPI matrices, cloning matrixes or easily extending this matrix class (e.g. projection matrices etc.)
    ---@param this LifeBoatAPI.Matrix
    ---@param other number[] any array with 16 numerical entries as a matrix
    ---@overload fun(this:LifeBoatAPI.Matrix, other:LifeBoatAPI.Matrix):LifeBoatAPI.Matrix
    ---@overload fun(this:LifeBoatAPI.Matrix, other:SWMatrix):LifeBoatAPI.Matrix
    newFromExisting = function(this, other)
        this = LifeBoatAPI.Classes.instantiate(LifeBoatAPI.Matrix, {})
        for i=1, 16 do
            this[i] = other[i]
        end
        return this
    end;

    ---Creates a new identity matrix
    ---@return LifeBoatAPI.Matrix
    newIdentity = function(this)
        return LifeBoatAPI.Classes.instantiate(LifeBoatAPI.Matrix, {
            -- first 16 numerical values match what gets sent to the game
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            0,0,0,1 -- translations in x=13, y=14, z=15
        })
    end;

    --- Check if two matrices have identical array components
    ---@param this LifeBoatAPI.Matrix
    ---@param other LifeBoatAPI.Matrix
    ---@return boolean equal true if the matrices are numerical identical
    equals = function(this, other)
        for i=1,16 do
            if other[i] ~= this[i] then
                return false
            end
        end
        return true
    end;

    -- (Immutable) Multiplies the columns of this matrix by the row of the given matrix
    -- this results in a matrix order of "affect rhs by the transformation in this" or, "do this, then rhs"
    -- e.g. if this was a rotation matrix and rhs was a translation matrix - it'd mean "rotate first, then translate"
    ---@param this LifeBoatAPI.Matrix
    ---@param rhs LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix result new matrix
    multiplyMatrix = function(this, rhs)
        local result = {}
        for row=0, 3 do
            for col=1,4 do
                result[row * 4 + col] = (rhs[row*4+1] * this[0 + col])
                                      + (rhs[row*4+2] * this[4 + col])
                                      + (rhs[row*4+3] * this[8 + col])
                                      + (rhs[row*4+4] * this[12 + col])
            end
        end
        return LifeBoatAPI.Classes.instantiate(LifeBoatAPI.Matrix, result)
    end;

    -- (Mutable - modifies self) Multiplies the columns of this matrix by the row of the given matrix
    -- this results in a matrix order of "affect rhs by the transformation in this" or, "do this, then rhs"
    -- e.g. if this was a rotation matrix and rhs was a translation matrix - it'd mean "rotate first, then translate"
    ---@param this LifeBoatAPI.Matrix
    ---@param rhs LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix this modified reference to self
    m_multiplyMatrix = function(this, rhs)
        local result = {}
        for row=0, 3 do
            for col=1,4 do
                result[row * 4 + col] = (rhs[row*4+1] * this[0 + col])
                                      + (rhs[row*4+2] * this[4 + col])
                                      + (rhs[row*4+3] * this[8 + col])
                                      + (rhs[row*4+4] * this[12 + col])
            end
        end

        for i=1,16 do
            this[i] = result[i]
        end
        return result
    end;

    ---(Immutable) Multiplies the given vector, with assumed w=1 component (respects translations)
    --- Returns a new vector, that has been transformed
    --- Re-normalizes the w-component of the vector unless specified not to
    ---@param this LifeBoatAPI.Matrix
    ---@param vec LifeBoatAPI.Vector
    ---@param w number optional, vector "w" component, 1 by default. 0 => direction only, 1 => position+direction
    ---@param skipNormalization boolean optional, false by default. If true, doesn't normalize the components back to w=1.
    ---@overload fun(this, vec:LifeBoatAPI.Vector) : LifeBoatAPI.Vector
    ---@overload fun(this, vec:LifeBoatAPI.Vector, w: number) : LifeBoatAPI.Vector,number
    ---@return LifeBoatAPI.Vector result,number w
    multiplyVector = function(this, vec, w, skipNormalization)
        w = w or 1

        local result = LifeBoatAPI.Vector:new(
            vec.x * this[1] + vec.y * this[5] + vec.z * this[9]  + w * this[13],
            vec.x * this[2] + vec.y * this[6] + vec.z * this[10] + w * this[14],
            vec.x * this[3] + vec.y * this[7] + vec.z * this[11] + w * this[15])

        w = vec.x * this[4] + vec.y * this[8] + vec.z * this[12] + w * this[16]

        if w ~= 0 and w ~= 1 and not skipNormalization then
            vec.x = vec.x / w
            vec.y = vec.y / w
            vec.z = vec.z / w
            w = 1
        end

        return result, w
    end;

    --- (Mutable - modifies vec) Multiplies the given vector, with assumed w=1 component (respects translations)
    --- Modifies the given 'vec' param, saving the cost of a new instantiation
    --- Re-normalizes the w-component of the vector unless specified not to
    ---@param this LifeBoatAPI.Matrix
    ---@param vec LifeBoatAPI.Vector vector to multiply (will be modified in-place)
    ---@param w number optional, vector "w" component, 1 by default. 0 => direction only, 1 => position+direction
    ---@param skipNormalization boolean optional, false by default. If true, doesn't normalize the components back to w=1.
    ---@overload fun(this, vec:LifeBoatAPI.Vector) : LifeBoatAPI.Vector
    ---@overload fun(this, vec:LifeBoatAPI.Vector, w: number) : LifeBoatAPI.Vector,number
    ---@return LifeBoatAPI.Vector vec,number w
    m_multiplyVector = function(this, vec, w, skipNormalization)
        w = w or 1

        vec.x = vec.x * this[1] + vec.y * this[5] + vec.z * this[9]  + w * this[13]
        vec.y = vec.x * this[2] + vec.y * this[6] + vec.z * this[10] + w * this[14]
        vec.z = vec.x * this[3] + vec.y * this[7] + vec.z * this[11] + w * this[15]

        w = vec.x * this[4] + vec.y * this[8] + vec.z * this[12] + w * this[16]

        if w ~= 0 and w ~= 1 and not skipNormalization then
            vec.x = vec.x / w
            vec.y = vec.y / w
            vec.z = vec.z / w
            w = 1
        end
        return vec, w
    end;

    ---(Immutable) Multiplies the given vector, with assumed w=1 component (respects translations)
    --- Returns a new vector, that has been transformed
    --- Re-normalizes the w-component of the vector unless specified not to
    ---@param this LifeBoatAPI.Matrix
    ---@param x number
    ---@param y number
    ---@param z number
    ---@param w number optional, vector "w" component, 1 by default. 0 => direction only, 1 => position+direction
    ---@param skipNormalization boolean optional, false by default. If true, doesn't normalize the components back to w=1.
    ---@overload fun(this, vec:LifeBoatAPI.Vector) : LifeBoatAPI.Vector
    ---@overload fun(this, vec:LifeBoatAPI.Vector, w: number) : LifeBoatAPI.Vector,number
    ---@return number x,number y,number z,number w
    multiplyXYZW = function(this, x, y, z, w, skipNormalization)
        w = w or 1
        
        local rx = x * this[1] + y * this[5] + z * this[9]  + w * this[13]
        local ry = x * this[2] + y * this[6] + z * this[10] + w * this[14]
        local rz = x * this[3] + y * this[7] + z * this[11] + w * this[15]
        local rw = x * this[4] + y * this[8] + z * this[12] + w * this[16]

        if rw ~= 0 and rw ~= 1 and not skipNormalization then
            rx = rx / w
            ry = ry / w
            rz = rz / w
            w = 1
        end

        return rx, ry, rz, rw
    end;  

    ---(Mutable - modifies self) Quick version of translating the existing Matrix
    --- Only usable on simple matrices, but significantly faster than multiplying
    ---@param this LifeBoatAPI.Matrix
    ---@param vec LifeBoatAPI.Vector amount to translate by
    ---@return LifeBoatAPI.Matrix this chainable reference
    m_quickTranslate = function(this, vec)
        this[this.IndexX] = vec.x
        this[this.IndexY] = vec.y
        this[this.IndexZ] = vec.z
        return this
    end;

    ---(Mutable - modifies self) Quick version of translating the existing Matrix
    --- Only usable on simple matrices, but significantly faster than multiplying
    ---@param this LifeBoatAPI.Matrix
    ---@param x number x translation
    ---@param y number y translation
    ---@param z number z translation
    ---@return LifeBoatAPI.Matrix this chainable reference
    m_quickTranslateXYZ = function(this, x, y, z)
        this[this.IndexX] = this[this.IndexX] + x
        this[this.IndexY] = this[this.IndexY] + y
        this[this.IndexZ] = this[this.IndexZ] + z
        return this
    end;

    ---(Mutable - modifies self) Quick & direct way to set the position this matrix represents
    --- Only usable on simple matrices, but significantly faster than multiplying
    ---@param this LifeBoatAPI.Matrix
    ---@param vec LifeBoatAPI.Vector new position
    ---@return LifeBoatAPI.Matrix this chainable reference
    m_quickSetPosition = function(this, vec)
        this[this.IndexX] = vec.x
        this[this.IndexY] = vec.y
        this[this.IndexZ] = vec.z
        return this
    end;

    ---(Mutable - modifies self) Quick & direct way to set the position this matrix represents
    --- Only usable on simple matrices, but significantly faster than multiplying
    ---@param this LifeBoatAPI.Matrix
    ---@param x number x position
    ---@param y number y position
    ---@param z number z position
    ---@return LifeBoatAPI.Matrix this chainable reference
    m_quickSetPositionXYZ = function(this, x, y, z)
        this[this.IndexX] = x
        this[this.IndexY] = y
        this[this.IndexZ] = z
        return this
    end;

    --- Gets the "true" position, applying the full transform represented by this matrix
    --- If this matrix was built from a combination of multiple other matrices this gets the accurate position vector
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Vector position position calculated from the current transformations
    position = function(this)
        return this:m_multiplyVector(LifeBoatAPI.Vector:new(0,0,0))
    end;

    --- (Recommended) Faster alternative to position(), only applicable to simple rotation+translation matrices
    --- Provided as the majority of matrices from the game will be "simple" and this may provide a performance benefit
    --- Note, it will be inaccurate if scaling or multiple rotation/translation steps have been applied one after another
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Vector position position taken directly from the matrix
    quickPosition = function(this)
        return LifeBoatAPI.Vector:new(this[this.IndexX], this[this.IndexY], this[this.IndexZ])
    end;

    --- Faster alternative to position(), only applicable to very simple rotation+translation matrices
    --- Provided as the majority of matrices from the game will be "simple" and this may provide a performance benefit
    --- Note, it will be inaccurate if scaling or multiple rotation/translation steps have been applied one after another
    ---@param this LifeBoatAPI.Matrix
    ---@return number x,number y,number z position taken directly from the matrix as an x,y,z triplet. Avoids instantiating a vector
    quickPositionXYZ = function(this)
        return this[this.IndexX], this[this.IndexY], this[this.IndexZ]
    end;

    --- Gets the current "forward" vector from the orientation this matrix represents, useful for vehicle/object maths
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Vector forward
    forward = function(this)
        return this:m_multiplyVector(LifeBoatAPI.Vector:new(0,0,1),0)
    end;

    --- Gets the current "up" vector from the orientation this matrix represents, useful for vehicle/object maths
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Vector forward
    up = function(this)
        return this:m_multiplyVector(LifeBoatAPI.Vector:new(0,1,0),0)
    end;

    --- Gets the current "left" vector from the orientation this matrix represents, useful for vehicle/object maths
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Vector forward
    left = function(this)
        return this:m_multiplyVector(LifeBoatAPI.Vector:new(1,0,0),0)
    end;

    ---(Immutable) Swap rows with columns
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix transposed matrix with columns and rows swapped
    transpose = function (this)
        return LifeBoatAPI.Classes.instantiate(LifeBoatAPI.Matrix, {
            this[1],    this[5],    this[9],    this[13],
            this[2],    this[6],    this[10],   this[14],
            this[3],    this[7],    this[11],   this[15],
            this[4],    this[8],    this[12],   this[16]
        })
    end;

    -- (Mutable - modifies self) transpose, saves an instantiation
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix transposed matrix with columns and rows swapped
    m_transpose = function (this)
        local result = {
            this[1],    this[5],    this[9],    this[13],
            this[2],    this[6],    this[10],   this[14],
            this[3],    this[7],    this[11],   this[15],
            this[4],    this[8],    this[12],   this[16]
        }
        for i=1,16 do
            this[i] = result[i]
        end
        return result
    end;

    --- (!!NOT RECOMMENDED!!) gets the inverse of this Matrix; which "undoes" the transformation done by this Matrix
    --- extremely rare that you'd want this
    --- very slow, calls the game matrix functions
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix inverted 
    invert = function (this)
        return LifeBoatAPI.Matrix:newFromExisting(matrix.invert(this))
    end;

    --- (Immutable) Highly performant inverse for simple rotate->translate matrices
    ---     Note that for rotation-only matrices, the transpose of the rotation part is the inverse
    ---     And simple translation is inverted just by negation
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix inverted inverse
    quickInvert = function(this)
        return LifeBoatAPI.Classes.instantiate(LifeBoatAPI.Matrix, {
            this[1],        this[5],        this[9],    this[4],
            this[2],        this[6],        this[10],   this[8],
            this[3],        this[7],        this[11],   this[12],
            -this[13],     -this[14],      -this[15],   this[16]
        })
    end;

    --- (Mutable - modifies self) Highly performant inverse for simple rotate->translate matrices
    ---     Note that for rotation-only matrices, the transpose of the rotation part is the inverse
    ---     And simple translation is inverted just by negation
    ---@param this LifeBoatAPI.Matrix
    ---@return LifeBoatAPI.Matrix this chainable reference
    m_quickInvert = function(this)
        local result = {
            this[1],        this[5],        this[9],    this[4],
            this[2],        this[6],        this[10],   this[8],
            this[3],        this[7],        this[11],   this[12],
            -this[13],     -this[14],      -this[15],   this[16]
        }
        for i=1, 16 do
            this[i] = result[i]
        end
        return this;
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.Matrix", LifeBoatAPI.Matrix)