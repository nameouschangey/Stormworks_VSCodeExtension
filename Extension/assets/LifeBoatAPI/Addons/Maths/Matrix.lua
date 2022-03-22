---@class LifeBoatAPI.Matrix
LifeBoatAPI.Matrix = {
    IndexX = 13,
    IndexY = 14,
    IndexZ = 15,

    --(yaw, y)
    --(roll, z)
    --(pitch, x)
    ---@overload fun(this, x: number, y:number, z:number, rotX:number, rotY:number, rotZ:number)
    ---@return LifeBoatAPI.Matrix
    new = function(this, posX, posY, posZ, pitch, yaw, roll)
        yaw     = yaw or 0
        pitch   = pitch or 0
        roll    = roll or 0

        -- Y - yaw, P - pitch, R - roll, in most diagrams that would be A-yaw, B-pitch, Y-roll
        sinRoll = roll ~=0 and math.sin(-roll) or 0
        cosRoll = roll ~=0 and math.cos(-roll) or 1

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

    ---@return LifeBoatAPI.Matrix
    newFromSWMatrix = function(this, swMatrix)
        return LifeBoatAPI.Classes.instantiate(this, swMatrix)
    end;

    ---@return LifeBoatAPI.Matrix
    newIdentity = function(this)
        return LifeBoatAPI.Classes.instantiate(this, {
            -- first 16 numerical values match what gets sent to the game
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            0,0,0,1 -- translations in x=13, y=14, z=15
        })
    end;

    -- check two matrices are equal, by checking their contents
    equals = function(this, other)
        for i=1,16 do
            if other[i] ~= this[i] then
                return false
            end
        end
        return true
    end;

    -- Multiplies the COLUMNS of this matrix by the ROWS of the given matrix
    -- this results in a matrix order of "affect RHS by the transformation in this"
    --                                or, "do this, then RHS"
    -- e.g. if this was a rotation matrix and rhs was a translation matrix
    --          it'd mean "rotate first, then translate"
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
        return LifeBoatAPI.Classes.instantiate(this, result)
    end;

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

    --- Multiplies the given vector, with assumed w=1 component (respects translations)
    --- Modifies the given 'vec' param, saving the cost of a new instantiation
    --- Re-normalizes the w-component of the vector unless specified not to
    ---@param this LifeBoatAPI.Matrix
    ---@param vec LifeBoatAPI.Vector
    ---@param w number optional, vector "w" component, 1 by default. 0 => direction only, 1 => position+direction
    ---@param skipNormalization boolean optional, false by default. If true, doesn't normalize the components back to w=1.
    ---@overload fun(this, vec:LifeBoatAPI.Vector) : LifeBoatAPI.Vector
    ---@overload fun(this, vec:LifeBoatAPI.Vector, w: number) : LifeBoatAPI.Vector,number
    ---@return LifeBoatAPI.Vector result,number w
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

    --- Gets the "true" position, applying the full transform represented by this matrix
    --- If this matrix was built from a combination of multiple other matrices this gets the accurate 
    position = function(this)
        return this:multiplyVectorInPlace(LifeBoatAPI.Vector:new(0,0,0))
    end;

    --- Faster alternative to position(), only applicable to very simple rotation+translation matrices
    --- Provided as the majority of matrices from the game will be "simple" and this may provide a performance benefit
    --- Note, it will be inaccurate if scaling or multiple rotation/translation steps have been applied one after another
    quickPosition = function(this)
        return LifeBoatAPI.Vector:new(this[this.IndexX], this[this.IndexY], this[this.IndexZ])
    end;


    --- Gets the current "forward" vector from the orientation this matrix represents, useful for vehicle/object maths
    forward = function(this)
        return this:multiplyVectorInPlace(LifeBoatAPI.Vector:new(0,0,1),0)
    end;

    --- Gets the current "up" vector from the orientation this matrix represents, useful for vehicle/object maths
    up = function(this)
        return this:multiplyVectorInPlace(LifeBoatAPI.Vector:new(0,1,0),0)
    end;

    --- Gets the current "left" vector from the orientation this matrix represents, useful for vehicle/object maths
    left = function(this)
        return this:multiplyVectorInPlace(LifeBoatAPI.Vector:new(1,0,0),0)
    end;

    --- swap rows with columns
    transpose = function (this)
        return LifeBoatAPI.Classes.instantiate(this, {
            this[1],    this[5],    this[9],    this[13],
            this[2],    this[6],    this[10],   this[14],
            this[3],    this[7],    this[11],   this[15],
            this[4],    this[8],    this[12],   this[16]
        })
    end;

    -- mutable transpose, saves an instantiation
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

    --- gets the inverse of this Matrix; which "undoes" the transformation done by this Matrix
    --- extremely rare that you'd want this
    --- very slow, calls the game matrix functions
    invert = function (this)
        return LifeBoatAPI.Matrix:newFromSWMatrix(matrix.invert(this))
    end;

    --- for simple/rotation matrices the inverse is just the transpose of the rotation part
    --- and then inverting the translation part
    quickInvert = function(this)
        return LifeBoatAPI.Classes.instantiate(this, {
            this[1],        this[5],        this[9],    this[4],
            this[2],        this[6],        this[10],   this[8],
            this[3],        this[7],        this[11],   this[12],
            -this[13],     -this[14],      -this[15],   this[16]
        })
    end;

    -- mutable quickInvert, saves an instantiation
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