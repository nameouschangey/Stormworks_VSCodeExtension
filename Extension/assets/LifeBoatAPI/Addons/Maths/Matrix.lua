
-- moving the matrix maths into lua gives a performance gain
-- as each call to the game is incredibly slow
Matrix = {
    IndexX = 13,
    IndexY = 14,
    IndexZ = 15,

    new = function(this, posX, posY, posZ, rotX, rotY, rotZ)
        


        return LifeBoatAPI.Classes.instantiate(this, {
            -- first 16 numerical values match what gets sent to the game
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            posX,posY,posZ,1
        })
    end;

    newTranslation = function(this, posX, posY, posZ)
        return this:new(posX, posY, posZ, 0, 0, 0)
    end;

    newRotation = function(this, rotX, rotY, rotZ)
        return this:new(0, 0, 0, rotX, rotY, rotZ)
    end;

    newIdentity = function(this)
        return LifeBoatAPI.Classes.instantiate(this, {
            -- first 16 numerical values match what gets sent to the game
            1,0,0,0,
            0,1,0,0,
            0,0,1,0,
            0,0,0,1 -- translations in x=13, y=14, z=15
        })
    end;

    multiplyMatrix = function(this, rhs)
        local result = {}
        for row=0, 3 do
            for col=1,4 do
                result[row * 4 + col] = (this[row*4+1] * rhs[0 + col])
                                      + (this[row*4+2] * rhs[4 + col])
                                      + (this[row*4+3] * rhs[8 + col])
                                      + (this[row*4+4] * rhs[12 + col])
            end
        end
        return LifeBoatAPI.Classes.instantiate(this, result)
    end;

    translateVector = function(this, vec)
        return LifeBoatAPI.Vector:new(vec.x + this[Matrix.IndexX], vec.y + this[Matrix.IndexY], vec.z + this[Matrix.IndexZ])
    end;

    translateVectorInPlace = function(this, vec)
        vec.x = vec.x + this[Matrix.IndexX]
        vec.y = vec.y + this[Matrix.IndexY]
        vec.z = vec.z + this[Matrix.IndexZ]
        return vec
    end;

    rotateVector = function(this, vec)
        return this:multiplyVector(vec, 0)
    end;

    rotateVectorInPlace = function(this, vec)
        return this:multiplyVectorInPlace(vec, 0)
    end;

    multiplyVector = function(this, vec, w, skipNormalization)
        w = w or 1

        local result = LifeBoatAPI.Vector:new(
            vec.x * this[1] + vec.y * this[5] + vec.z * this[9]  + vec.w * this[13],
            vec.x * this[2] + vec.y * this[6] + vec.z * this[10] + vec.w * this[14],
            vec.x * this[3] + vec.y * this[7] + vec.z * this[11] + vec.w * this[15])

        w = vec.x * this[4] + vec.y * this[8] + vec.z * this[12] + w * this[16]

        if w ~= 0 and not skipNormalization then
            result.x = result.x / w
            result.y = result.y / w
            result.z = result.z / w
        end

        return result, w
    end;

    --- Mutable version of multiplyVector
    --- Slightly improved performance characteristics, reduced function calls
    multiplyVectorInPlace = function(this, vec, w, skipNormalization)
        w = w or 1

        vec.x = vec.x * this[1] + vec.y * this[5] + vec.z * this[9]  + vec.w * this[13]
        vec.y = vec.x * this[2] + vec.y * this[6] + vec.z * this[10] + vec.w * this[14]
        vec.z = vec.x * this[3] + vec.y * this[7] + vec.z * this[11] + vec.w * this[15]

        w = vec.x * this[4] + vec.y * this[8] + vec.z * this[12] + w * this[16]

        if w ~= 0 and not skipNormalization then
            vec.x = vec.x / w
            vec.y = vec.y / w
            vec.z = vec.z / w
        end

        return vec, w
    end;

    getRotationPart = function(this)
        local newMatrix = Matrix:newIdentity()
        for i=1, 12 do
            newMatrix[i] = this[i]
        end
        return newMatrix
    end;

    setRotationPart = function(this, other)
        for i=1, 12 do
            this[i] = other[i]
        end
    end;

    getTranslationPart = function(this)
        return LifeBoatAPI.Vector:new(this[Matrix.IndexX], this[Matrix.IndexY], this[Matrix.IndexZ])
    end;

    setTranslationPart = function(this, vector)
        this[Matrix.IndexX] = vector.x
        this[Matrix.IndexY] = vector.y
        this[Matrix.IndexZ] = vector.z
    end;

    inverted = function (this)
        
    end;

    --- Flip column/row ordering
    transposed = function (this)
        return LifeBoatAPI.Classes.instantiate(this, {
            this[1],    this[5],    this[9],    this[13],
            this[2],    this[6],    this[10],   this[14],
            this[3],    this[7],    this[11],   this[15],
            this[4],    this[8],    this[12],   this[16]
        })
    end;
}
LifeBoatAPI.Classes:register("LifeBoatAPI.Matrix", LifeBoatAPI.Matrix)

--[[
     Matrix Manipulation    
     Stormworks provides a limited set of matrix functions that are useful for transforming positions of objects in scripts:
    
	Multiply two matrices together. 
	out_matrix = matrix.multiply(matrix1, matrix2)  
	
	Invert a matrix.  
	out_matrix = matrix.invert(matrix1) 
	
	Transpose a matrix. 
	out_matrix = matrix.transpose(matrix1)  
	
	Return an identity matrix.  
	out_matrix = matrix.identity()  
	
	Return a rotation matrix rotated in the X axis. 
	out_matrix = matrix.rotationX(radians)  
	
	Return a rotation matrix rotated in the Y axis. 
	out_matrix = matrix.rotationY(radians)  
	
	Return a rotation matrix rotated in the Z axis. 
	out_matrix = matrix.rotationZ(radians)
	
	Return a translation matrix translated by x,y,z.
	out_matrix = matrix.translation(x,y,z)  
	
	Get the x,y,z position from a matrix.   
	x,y,z = matrix.position(matrix1)    
	
	Find the distance between two matrices
	dist = matrix.distance(matrix1, matrix2)
	
	Multiplies a matrix by a vec 4.
	out_x, out_y, out_z, out_w = matrix.multiplyXYZW(matrix1, x, y, z, w)   
	
	Returns the rotation required to face an X Z vector 
	out_rotation = matrix.rotationToFaceXZ(x, z)
    
	Most API functions take a matrix as a parameter so users that do not wish to use matrices directly can convert between matrices and coordinates as follows:     
	-- Teleport peer_1 10m up
	peer_1_pos, is_success = server.getPlayerPos(1)
	if is_success then
		local x, y, z = matrix.position(peer_1_pos)
		y = y + 10
		server.setPlayerPos(1, matrix.translation(x,y,z))
	end




]]