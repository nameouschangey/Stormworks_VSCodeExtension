require("Utils.LBBase")

-- avoid conflicts between local scoped variables called matrix, and the api
local _matrixapi = matrix

---@class LBMatrix : LBBaseClass
---@field matrix number[] matrix as represented in game as 16 numbers
LBMatrix = {
    ---@param matrix table matrix from the game's api
    ---@return LBMatrix
    new = function(this, matrix)
        this = LBBaseClass.new(this)
        this.matrix = matrix
        return this
    end;

    identity = function(this)
        return LBMatrix:new(_matrixapi.identity())
    end;

    ---@param vec3 LBVec
    translation = function(this, vec3)
        return LBMatrix:new(_matrixapi.translation(vec3.x,vec3.y,vec3.z))
    end;

    ---@param radians number
    rotationX = function(this, radians)
        return LBMatrix:new(_matrixapi.rotationX(radians))
    end;

    ---@param radians number
    rotationY = function(this, radians)
        return LBMatrix:new(_matrixapi.rotationY(radians))
    end;

    ---@param radians number
    rotationZ = function(this, radians)
        return LBMatrix:new(_matrixapi.rotationZ(radians))
    end;

    ---@param other LBMatrix
    multiplyMatrix = function(this, other)
        return LBMatrix:new(_matrixapi.multiply(this.matrix, other.matrix))
    end;

    ---@param vec LBVec
    ---@return LBVec result vector
    multiplyVec = function(this, vec)
        return LBVec:vec4(_matrixapi.multiplyXYZW(this.matrix, vec.x, vec.y, vec.z, vec.w))
    end;

    ---@return LBMatrix
    inverted = function(this)
        return LBMatrix:new(_matrixapi.invert(this.matrix))
    end;

    ---@return LBMatrix
    transposed = function(this)
        return LBMatrix:new(_matrixapi.transpose(this.matrix))
    end;

    ---@return LBVec
    position = function(this)
        return LBVec:vec4(_matrixapi.position(this.matrix))
    end;

    ---@return number
    distance = function(this, other)
        return _matrixapi.distance(this.matrix, other.matrix)
    end;
}
LBClass(LBMatrix)

