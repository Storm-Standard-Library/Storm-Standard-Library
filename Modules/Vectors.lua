local StormSL,ipairs_SL,pairs_SL,insert_SL,remove_SL,type_SL,unpack_SL,Vectors=StormSL,ipairs,pairs,table.insert,table.remove,type,table.unpack

--[[
	lacking:
		exterior/wedge product
		outer product -- for matrices
		tensor product
		clifford algebra whatever it is
		exterior algebra whatever it is
		quaternions
		tripple and quadruple products in scalar and vector
		scalar projection (just the magnitude of projection)
		jacobi and lagrange identity

		pointwise multiplication and division as SIMD for VMs
]]

---@class Vectors
---@field newV2_SL fun(x:number?,y:number?):table
---@field newV3_SL fun(x:number?,y:number?,z:number?):table
---@field newV4_SL fun(x:number?,y:number?,z:number?,w:number?):table
---@field newVA_SL fun(...:number):table
---@field pruneVA_SL fun(vector:table,size:number):table
---@field setV2_SL fun(vector:table,x:number,y:number):table
---@field setV3_SL fun(vector:table,x:number,y:number,z:number):table
---@field setV4_SL fun(vector:table,x:number,y:number,z:number,w:number):table
---@field setVA_SL fun(vector:table,...:number):table
---@field setToV2_SL fun(vectorToChange:table,vectorToCopyFrom:table):table
---@field setToV3_SL fun(vectorToChange:table,vectorToCopyFrom:table):table
---@field setToV4_SL fun(vectorToChange:table,vectorToCopyFrom:table):table
---@field setToVA_SL fun(vectorToChange:table,vectorToCopyFrom:table):table
---@field copyV2_SL fun(vectorToCopy:table):table
---@field copyV3_SL fun(vectorToCopy:table):table
---@field copyV4_SL fun(vectorToCopy:table):table
---@field copyVA_SL fun(vectorToCopy:table):table
---@field dotV2_SL fun(vectorA:table,vectorB:table):number
---@field dotV3_SL fun(vectorA:table,vectorB:table):number
---@field dotV4_SL fun(vectorA:table,vectorB:table):number
---@field dotVA_SL fun(vectorA:table,vectorB:table):number
---@field magnitudeV2_SL fun(vector:table):number
---@field magnitudeV3_SL fun(vector:table):number
---@field magnitudeV4_SL fun(vector:table):number
---@field magnitudeVA_SL fun(vector:table):number
---@field angleV2_SL fun(vectorA:table,vectorB:table):number
---@field angleV3_SL fun(vectorA:table,vectorB:table):number
---@field angleV4_SL fun(vectorA:table,vectorB:table):number
---@field angleVA_SL fun(vectorA:table,vectorB:table):number
---@field scaleV2Q_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV2_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV2S_SL fun(vector:table,scalar:number):table
---@field scaleV3Q_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV3_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV3S_SL fun(vector:table,scalar:number):table
---@field scaleV4Q_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV4_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleV4S_SL fun(vector:table,scalar:number):table
---@field scaleVAQ_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleVA_SL fun(vector:table,scalar:number,outputVector:table?):table
---@field scaleVAS_SL fun(vector:table,scalar:number):table
---@field unitV2Q_SL fun(vector:table,outputVector:table?):table
---@field unitV2_SL fun(vector:table,outputVector:table?):table
---@field unitV2S_SL fun(vector:table):table
---@field unitV3Q_SL fun(vector:table,outputVector:table?):table
---@field unitV3_SL fun(vector:table,outputVector:table?):table
---@field unitV3S_SL fun(vector:table):table
---@field unitV4Q_SL fun(vector:table,outputVector:table?):table
---@field unitV4_SL fun(vector:table,outputVector:table?):table
---@field unitV4S_SL fun(vector:table):table
---@field unitVAQ_SL fun(vector:table,outputVector:table?):table
---@field unitVA_SL fun(vector:table,outputVector:table?):table
---@field unitVAS_SL fun(vector:table):table
---@field addV2Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV2_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV2S_SL fun(vectorA:table,vectorB:table):table
---@field addV3Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV3_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV3S_SL fun(vectorA:table,vectorB:table):table
---@field addV4Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV4_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV4S_SL fun(vectorA:table,vectorB:table):table
---@field addVAQ_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addVA_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addVAS_SL fun(vectorA:table,vectorB:table):table
---@field subV2Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV2_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV2S_SL fun(vectorA:table,vectorB:table):table
---@field subV3Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV3_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV3S_SL fun(vectorA:table,vectorB:table):table
---@field subV4Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV4_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subV4S_SL fun(vectorA:table,vectorB:table):table
---@field subVAQ_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subVA_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field subVAS_SL fun(vectorA:table,vectorB:table):table
---@field addMultV2Q_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV2_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV2S_SL fun(vectorA:table,vectorB:table,scalarForB:number):table
---@field addMultV3Q_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV3_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV3S_SL fun(vectorA:table,vectorB:table,scalarForB:number):table
---@field addMultV4Q_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV4_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultV4S_SL fun(vectorA:table,vectorB:table,scalarForB:number):table
---@field addMultVAQ_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultVA_SL fun(vectorA:table,vectorB:table,scalarForB:number,outputVector:table?):table
---@field addMultVAS_SL fun(vectorA:table,vectorB:table,scalarForB:number):table
---@field crossV3Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field crossV3_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field crossV3S_SL fun(vectorA:table,vectorB:table):table
---@field projectV2Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV2_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV2S_SL fun(vector:table,vectorB:table):table
---@field projectV3Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV3_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV3S_SL fun(vector:table,vectorB:table):table
---@field projectV4Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV4_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectV4S_SL fun(vector:table,vectorB:table):table
---@field projectVAQ_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectVA_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field projectVAS_SL fun(vector:table,vectorB:table):table
---@field rejectV2Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV2_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV2S_SL fun(vector:table,vectorB:table):table
---@field rejectV3Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV3_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV3S_SL fun(vector:table,vectorB:table):table
---@field rejectV4Q_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV4_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectV4S_SL fun(vector:table,vectorB:table):table
---@field rejectVAQ_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectVA_SL fun(vector:table,vectorB:table,outputVector:table?):table
---@field rejectVAS_SL fun(vector:table,vectorB:table):table
---@field lerpV2Q_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV2_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV2S_SL fun(vectorA:table,vectorB:table,t:number):table
---@field lerpV3Q_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV3_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV3S_SL fun(vectorA:table,vectorB:table,t:number):table
---@field lerpV4Q_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV4_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpV4S_SL fun(vectorA:table,vectorB:table,t:number):table
---@field lerpVAQ_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpVAQ_SL fun(vectorA:table,vectorB:table,t:number,outputVector:table?):table
---@field lerpVAS_SL fun(vectorA:table,vectorB:table,t:number):table
---@field matMultV2Q_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV2_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV2S_SL fun(vector:table,matrix:table):table
---@field matMultV3Q_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV3_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV3S_SL fun(vector:table,matrix:table):table
---@field matMultV4Q_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV4_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultV4S_SL fun(vector:table,matrix:table):table
---@field matMultVAQ_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultVA_SL fun(vector:table,matrix:table,outputVector:table?):table
---@field matMultVAS_SL fun(vector:table,matrix:table):table
---Standard Stormworks Vector functions
Vectors = {
	---Creates a new 2D vector, if any of the arguments are nil, it will default to 0.
	---@param x number?
	---@param y number?
	---@return table vector vector
	newV2_SL = function(x, y)
		return {
			x or 0,
			y or 0,
		}
	end,

	---Creates a new 3D vector, if any of the arguments are nil, it will default to 0.
	---@param x number?
	---@param y number?
	---@param z number?
	---@return table vector
	newV3_SL = function(x, y, z)
		return {
			x or 0,
			y or 0,
			z or 0
		}
	end,

	---Creates a new 4D vector, if any of the arguments are nil, it will default to 0.
	---@param x number?
	---@param y number?
	---@param z number?
	---@param w number?
	---@return table vector
	newV4_SL = function(x, y, z, w)
		return {
			x or 0,
			y or 0,
			z or 0,
			w or 0
		}
	end,

	---Creates a new vector of any size.
	---@param ... number values of the vector, if only one argument is given, it will create a vector of that size filled with 0s
	---@return table vector
	newVA_SL = function(...)
		local newVector = {...}
		if #newVector == 1 then
			for i = 1, newVector[1] do
				newVector[i] = 0
			end
		end
		return newVector
	end,




	---Prunes the vector to the given size by deleting it's dimensions.
	---@param vector table
	---@param size number
	---@return table vector
	pruneVA_SL=function(vector, size)
		for i = #vector, size + 1, -1 do
			remove_SL(vector, i)
		end
		return vector
	end,

	---Sets the values of a vector to the given values.
	---@param vectorToChange table vector to change
	---@param x number new x value
	---@param y number new y value
	---@return table vector
	setV2_SL = function(vectorToChange, x, y)
		vectorToChange[1] = x
		vectorToChange[2] = y
		return vectorToChange
	end,

	---Sets the values of a vector to the given values.
	---@param vectorToChange table vector to change
	---@param x number new x value
	---@param y number new y value
	---@param z number new z value
	---@return table vector
	setV3_SL = function(vectorToChange, x, y, z)
		vectorToChange[1] = x
		vectorToChange[2] = y
		vectorToChange[3] = z
		return vectorToChange
	end,

	---Sets the values of a vector to the given values.
	---@param vectorToChange table
	---@param x number new x value
	---@param y number new y value
	---@param z number new z value
	---@param w number new w value
	---@return table vector
	setV4_SL = function(vectorToChange, x, y, z, w)
		vectorToChange[1] = x
		vectorToChange[2] = y
		vectorToChange[3] = z
		vectorToChange[4] = w
		return vectorToChange
	end,

	---Sets the values of a vector to the given values.
	---@param vectorToChange table
	---@param ... number
	---@return table vector
	setVA_SL = function(vectorToChange, ...)
		local args = {...}
		for i = 1, #args do
			vectorToChange[i] = args[i]
		end
		Vectors.pruneVA_SL(vectorToChange, #args)
		return vectorToChange
	end,

	---Copies the values of a vector to another vector.
	---@param vectorToChange table
	---@param vectorToCopyFrom table
	---@return table vector
	setToV2_SL = function(vectorToChange, vectorToCopyFrom)
		vectorToChange[1] = vectorToCopyFrom[1]
		vectorToChange[2] = vectorToCopyFrom[2]
		return vectorToChange
	end,

	---Copies the values of a vector to another vector.
	---@param vectorToChange table
	---@param vectorToCopyFrom table
	---@return table vector
	setToV3_SL = function(vectorToChange, vectorToCopyFrom)
		vectorToChange[1] = vectorToCopyFrom[1]
		vectorToChange[2] = vectorToCopyFrom[2]
		vectorToChange[3] = vectorToCopyFrom[3]
		return vectorToChange
	end,

	---Copies the values of a vector to another vector.
	---@param vectorToChange table
	---@param vectorToCopyFrom table
	---@return table vector
	setToV4_SL = function(vectorToChange, vectorToCopyFrom)
		vectorToChange[1] = vectorToCopyFrom[1]
		vectorToChange[2] = vectorToCopyFrom[2]
		vectorToChange[3] = vectorToCopyFrom[3]
		vectorToChange[4] = vectorToCopyFrom[4]
		return vectorToChange
	end,

	---Copies the values of a vector to another vector.
	---@param vectorToChange table
	---@param vectorToCopyFrom table
	---@return table vector
	setToVA_SL = function(vectorToChange, vectorToCopyFrom)
		for i, v in ipairs_SL(vectorToCopyFrom) do
			vectorToChange[i] = v
		end
		Vectors.pruneVA_SL(vectorToChange, #vectorToCopyFrom)
		return vectorToChange
	end,

	---Copies the vector and returns it.
	---@param vectorToCopy table
	---@return table vector
	copyV2_SL = function(vectorToCopy)
		return {vectorToCopy[1], vectorToCopy[2]}
	end,

	---Copies the vector and returns it.
	---@param vectorToCopy table
	---@return table vector
	copyV3_SL = function(vectorToCopy)
		return {vectorToCopy[1], vectorToCopy[2], vectorToCopy[3]}
	end,

	---Copies the vector and returns it.
	---@param vectorToCopy table
	---@return table vector
	copyV4_SL = function(vectorToCopy)
		return {vectorToCopy[1], vectorToCopy[2], vectorToCopy[3], vectorToCopy[4]}
	end,

	---Copies the vector and returns it.
	---@param vectorToCopy table
	---@return table vector
	copyVA_SL = function(vectorToCopy)
		return {unpack_SL(vectorToCopy)}
	end,




	---Returns a dot product of 2 vectors in 2D space.
	---@param vectorA table
	---@param vectorB table
	---@return number dot
	dotV2_SL = function(vectorA, vectorB)
		return vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2]
	end,

	---Returns a dot product of 2 vectors in 3D space.
	---@param vectorA table
	---@param vectorB table
	---@return number dot
	dotV3_SL = function(vectorA, vectorB)
		return vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3]
	end,

	---Returns a dot product of 2 vectors in 4D space.
	---@param vectorA table
	---@param vectorB table
	---@return number dot
	dotV4_SL = function(vectorA, vectorB)
		return vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3] + vectorA[4] * vectorB[4]
	end,

	---Returns a dot product of 2 vectors.
	---@param vectorA table is dominant in the size of the dot product
	---@param vectorB table
	---@return number dot
	dotVA_SL = function(vectorA, vectorB)
		local dot = 0
		for i, vec1Value in ipairs_SL(vectorA) do
			dot = dot + vec1Value * vectorB[input]
		end
		return dot
	end,

	---Returns a magnitude of the vector in 2D space.
	---@param vector table
	---@return number magnitude
	magnitudeV2_SL = function(vector)
		return (vector[1]^2 + vector[2]^2)^0.5
	end,

	---Returns a magnitude of the vector in 3D space.
	---@param vector table
	---@return number magnitude
	magnitudeV3_SL = function(vector)
		return (vector[1]^2 + vector[2]^2 + vector[3]^2)^0.5
	end,

	---Returns a magnitude of the vector in 4D space.
	---@param vector table
	---@return number magnitude
	magnitudeV4_SL = function(vector)
		return (vector[1]^2 + vector[2]^2 + vector[3]^2 + vector[4]^2)^0.5
	end,

	---Returns a magnitude of the vector.
	---@param vector table
	---@return number magnitude
	magnitudeVA_SL = function(vector)
		local mag = 0
		for i, value in ipairs_SL(vector) do
			mag = mag + value * value
		end
		return mag^0.5
	end,

	---Returns an angle between 2 vectors in radians.
	---@param vectorA table
	---@param vectorB table
	---@return number radians
	angleV2_SL = function(vectorA, vectorB)
		--the return below is documented in angleVA_SL
		return math.acos(StormSL.clamp_SL(-1, 1, Vectors.dotV2_SL(vectorA, vectorB) / (Vectors.magnitudeV2_SL(vectorA) * Vectors.magnitudeV2_SL(vectorB) ) ) )
	end,

	---Returns an angle between 2 vectors in radians.
	---@param vectorA table
	---@param vectorB table
	---@return number radians
	angleV3_SL = function(vectorA, vectorB)
		--the return below is documented in angleVA_SL
		return math.acos(StormSL.clamp_SL(-1, 1, Vectors.dotV3_SL(vectorA, vectorB) / (Vectors.magnitudeV3_SL(vectorA) * Vectors.magnitudeV3_SL(vectorB) ) ) )
	end,

	---Returns an angle between 2 vectors in radians.
	---@param vectorA table
	---@param vectorB table
	---@return number radians
	angleV4_SL = function(vectorA, vectorB)
		--the return below is documented in angleVA_SL
		return math.acos(StormSL.clamp_SL(-1, 1, Vectors.dotV4_SL(vectorA, vectorB) / (Vectors.magnitudeV4_SL(vectorA) * Vectors.magnitudeV4_SL(vectorB) ) ) )
	end,

	---Returns an angle between 2 vectors in radians.
	---@param vectorA table
	---@param vectorB table
	---@return number radians
	angleVA_SL = function(vectorA, vectorB)
		--local dot, magA, magB, angle
		--dot = Vectors.dotVA_SL(vectorA, vectorB)
		--magA = Vectors.magnitudeVA_SL(vectorA)
		--magB = Vectors.magnitudeVA_SL(vectorB)
		--angle = dot / (magA * magB)
		--angle = math.acos(StormSL.clamp_SL(-1, 1, angle))
		return math.acos(StormSL.clamp_SL(-1, 1, Vectors.dotVA_SL(vectorA, vectorB) / (Vectors.magnitudeVA_SL(vectorA) * Vectors.magnitudeVA_SL(vectorB) ) ) )
	end,




	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV2Q_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vector[1] * scalar
		outputVector[2] = vector[2] * scalar

		return outputVector
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV2_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		Vectors.setV2_SL(outputVector,
			vector[1] * scalar,
			vector[2] * scalar
		)

		return outputVector
	end,

	---A smaller variant of scaling vectors.
	---@param vector table
	---@param scalar number
	---@return table vector
	scaleV2S_SL = function(vector, scalar)
		return {
			vector[1] * scalar,
			vector[2] * scalar
		}
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV3Q_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vector[1] * scalar
		outputVector[2] = vector[2] * scalar
		outputVector[3] = vector[3] * scalar

		return outputVector
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV3_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		Vectors.setV3_SL(outputVector,
			vector[1] * scalar,
			vector[2] * scalar,
			vector[3] * scalar
		)

		return outputVector
	end,

	---A smaller variant of scaling vectors.
	---@param vector table
	---@param scalar number
	---@return table vector
	scaleV3S_SL = function(vector, scalar)
		return {
			vector[1] * scalar,
			vector[2] * scalar,
			vector[3] * scalar
		}
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV4Q_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vector[1] * scalar
		outputVector[2] = vector[2] * scalar
		outputVector[3] = vector[3] * scalar
		outputVector[4] = vector[4] * scalar

		return outputVector
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleV4_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		Vectors.setV4_SL(outputVector,
			vector[1] * scalar,
			vector[2] * scalar,
			vector[3] * scalar,
			vector[4] * scalar
		)

		return outputVector
	end,

	---A smaller variant of scaling vectors.
	---@param vector table
	---@param scalar number
	---@return table vector
	scaleV4S_SL = function(vector, scalar)
		return {
			vector[1] * scalar,
			vector[2] * scalar,
			vector[3] * scalar,
			vector[4] * scalar
		}
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleVAQ_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		for i, vecValue in ipairs_SL(vector) do
			outputVector[i] = vecValue * scalar
		end

		for i = #outputVector, #vector + 1, -1 do
			remove_SL(outputVector, i)
		end
		return outputVector
	end,

	---A quick vector scaling, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param scalar number
	---@param outputVector table?
	---@return table vector
	scaleVA_SL = function(vector, scalar, outputVector)
		outputVector = outputVector or {}

		for i, vecValue in ipairs_SL(vector) do
			outputVector[i] = vecValue * scalar
		end

		return Vectors.pruneVA_SL(outputVector, #vector)
	end,

	---A smaller variant of scaling vectors.
	---@param vector table
	---@param scalar number
	---@return table vector
	scaleVAS_SL = function(vector, scalar)
		local newVec = {}

		for i = 1, #vector do
			newVec[i] = vector[i] * scalar
		end

		return newVec
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV2Q_SL = function(vector, outputVector)
		outputVector = outputVector or {}

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = (vector[1]^2 + vector[2]^2)^0.5
		magnitude = magnitude == 0 and 1 or magnitude

		outputVector[1] = vector[1] / magnitude
		outputVector[2] = vector[2] / magnitude

		return outputVector
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses other functions instead of inlining.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV2_SL = function(vector, outputVector)
		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = Vectors.magnitudeV2_SL(vector)
		magnitude = magnitude == 0 and 1 or magnitude

		return Vectors.scaleV2Q_SL(vector, 1 / magnitude, outputVector)
	end,

	---A smaller variant of normalizing vectors.
	---@param vector table
	---@return table vector
	unitV2S_SL = function(vector)
		local magnitude = Vectors.magnitudeV2_SL(vector)

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		return Vectors.scaleV2S_SL(vector, 1 / (magnitude == 0 and 1 or magnitude))
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV3Q_SL = function(vector, outputVector)
		outputVector = outputVector or {}

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = (vector[1]^2 + vector[2]^2 + vector[3]^2)^0.5
		magnitude = magnitude == 0 and 1 or magnitude

		outputVector[1] = vector[1] / magnitude
		outputVector[2] = vector[2] / magnitude
		outputVector[3] = vector[3] / magnitude

		return outputVector
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses other functions instead of inlining.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV3_SL = function(vector, outputVector)
		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = Vectors.magnitudeV3_SL(vector)
		magnitude = magnitude == 0 and 1 or magnitude

		return Vectors.scaleV3Q_SL(vector, 1 / magnitude, outputVector)
	end,

	---A smaller variant of normalizing vectors.
	---@param vector table
	---@return table vector
	unitV3S_SL = function(vector)
		local magnitude = Vectors.magnitudeV3_SL(vector)

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		return Vectors.scaleV3S_SL(vector, 1 / (magnitude == 0 and 1 or magnitude))
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV4Q_SL = function(vector, outputVector)
		outputVector = outputVector or {}

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = (vector[1]^2 + vector[2]^2 + vector[3]^2 + vector[4]^2)^0.5
		magnitude = magnitude == 0 and 1 or magnitude

		outputVector[1] = vector[1] / magnitude
		outputVector[2] = vector[2] / magnitude
		outputVector[3] = vector[3] / magnitude
		outputVector[4] = vector[4] / magnitude

		return outputVector
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses other functions instead of inlining.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitV4_SL = function(vector, outputVector)
		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = Vectors.magnitudeV4_SL(vector)
		magnitude = magnitude == 0 and 1 or magnitude

		return Vectors.scaleV4Q_SL(vector, 1 / magnitude, outputVector)
	end,

	---A smaller variant of normalizing vectors.
	---@param vector table
	---@return table vector
	unitV4S_SL = function(vector)
		local magnitude = Vectors.magnitudeV4_SL(vector)

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		return Vectors.scaleV4S_SL(vector, 1 / (magnitude == 0 and 1 or magnitude))
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitVAQ_SL = function(vector, outputVector)
		outputVector = outputVector or {}

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = 0
		for i, vecValue in ipairs_SL(vector) do
			magnitude = magnitude + vecValue*vecValue
		end
		magnitude = magnitude == 0 and 1 or magnitude

		for i, vecValue in ipairs_SL(vector) do
			outputVector[i] = vecValue / magnitude
		end

		for i = #outputVector, #vector + 1, -1 do
			remove_SL(outputVector, i)
		end
		return outputVector
	end,

	---A quick vector normalization, by giving it output vector, you avoid garbage collector. Uses other functions instead of inlining.
	---@param vector table
	---@param outputVector table?
	---@return table vector
	unitVA_SL = function(vector, outputVector)
		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		local magnitude = Vectors.magnitudeVA_SL(vector)
		magnitude = magnitude == 0 and 1 or magnitude

		return Vectors.scaleVAQ_SL(vector, 1 / magnitude, outputVector)
	end,

	---A smaller variant of normalizing vectors.
	---@param vector table
	---@return table vector
	unitVAS_SL = function(vector)
		local magnitude = Vectors.magnitudeVA_SL(vector)

		--doesn't produce NaNs but doesn't normalize to 1 either if the vector is 0
		return Vectors.scaleVAS_SL(vector, 1 / (magnitude == 0 and 1 or magnitude))
	end,




	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV2Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + vectorB[1]
		outputVector[2] = vectorA[2] + vectorB[2]

		return outputVector
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV2_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV2_SL(outputVector,
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2]
		)
	end,

	---A smaller variant of adding vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	addV2S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2]
		}
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV3Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + vectorB[1]
		outputVector[2] = vectorA[2] + vectorB[2]
		outputVector[3] = vectorA[3] + vectorB[3]

		return outputVector
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV3_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV3_SL(outputVector,
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2],
			vectorA[3] + vectorB[3]
		)
	end,

	---A smaller variant of adding vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	addV3S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2],
			vectorA[3] + vectorB[3]
		}
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV4Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + vectorB[1]
		outputVector[2] = vectorA[2] + vectorB[2]
		outputVector[3] = vectorA[3] + vectorB[3]
		outputVector[3] = vectorA[4] + vectorB[4]

		return outputVector
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addV4_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV4_SL(outputVector,
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2],
			vectorA[3] + vectorB[3],
			vectorA[4] + vectorB[4]
		)
	end,

	---A smaller variant of adding vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	addV4S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2],
			vectorA[3] + vectorB[3],
			vectorA[4] + vectorB[4]
		}
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addVAQ_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value + vectorB[i]
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector, i)
		end
		return outputVector
	end,

	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	addVA_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value + vectorB[i]
		end

		return Vectors.pruneVA_SL(outputVector,#vectorA)
	end,

	---A smaller variant of adding vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	addVAS_SL = function(vectorA, vectorB)
		local newVec = {}

		for i = 1, #vectorA do
			newVec[i] = vectorA[i] + vectorB[i]
		end

		return newVec
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV2Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] - vectorB[1]
		outputVector[2] = vectorA[2] - vectorB[2]

		return outputVector
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV2_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV2_SL(outputVector,
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2]
		)
	end,

	---A smaller variant of subracting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	subV2S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2]
		}
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV3Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] - vectorB[1]
		outputVector[2] = vectorA[2] - vectorB[2]
		outputVector[3] = vectorA[3] - vectorB[3]

		return outputVector
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV3_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV3_SL(outputVector,
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2],
			vectorA[3] - vectorB[3]
		)
	end,

	---A smaller variant of subracting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	subV3S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2],
			vectorA[3] - vectorB[3]
		}
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV4Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] - vectorB[1]
		outputVector[2] = vectorA[2] - vectorB[2]
		outputVector[3] = vectorA[3] - vectorB[3]
		outputVector[3] = vectorA[4] - vectorB[4]

		return outputVector
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subV4_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV4_SL(outputVector,
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2],
			vectorA[3] - vectorB[3],
			vectorA[4] - vectorB[4]
		)
	end,

	---A smaller variant of subracting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	subV4S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] - vectorB[1],
			vectorA[2] - vectorB[2],
			vectorA[3] - vectorB[3],
			vectorA[4] - vectorB[4]
		}
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subVAQ_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value - vectorB[i]
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector, i)
		end
		return outputVector
	end,

	---A quick sub, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	subVA_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value - vectorB[i]
		end
		return Vectors.pruneVA_SL(outputVector, #vectorA)
	end,

	---A smaller variant of subracting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	subVAS_SL = function(vectorA, vectorB)
		local newVec = {}

		for i = 1, #vectorA do
			newVec[i] = vectorA[i] - vectorB[i]
		end

		return newVec
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV2Q_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + scalarForB * vectorB[1]
		outputVector[2] = vectorA[2] + scalarForB * vectorB[2]

		return outputVector
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV2_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV2_SL(outputVector,
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2]
		)
	end,

	---A smaller variant of vector add multiply.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@return table vector
	addMultV2S_SL = function(vectorA, vectorB, scalarForB)
		return {
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2]
		}
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV3Q_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + scalarForB * vectorB[1]
		outputVector[2] = vectorA[2] + scalarForB * vectorB[2]
		outputVector[3] = vectorA[3] + scalarForB * vectorB[3]

		return outputVector
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV3_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV3_SL(outputVector,
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2],
			vectorA[3] + scalarForB * vectorB[3]
		)
	end,

	---A smaller variant of vector add multiply.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@return table vector
	addMultV3S_SL = function(vectorA, vectorB, scalarForB)
		return {
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2],
			vectorA[3] + scalarForB * vectorB[3]
		}
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV4Q_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + scalarForB * vectorB[1]
		outputVector[2] = vectorA[2] + scalarForB * vectorB[2]
		outputVector[3] = vectorA[3] + scalarForB * vectorB[3]
		outputVector[3] = vectorA[4] + scalarForB * vectorB[4]

		return outputVector
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultV4_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV4_SL(outputVector,
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2],
			vectorA[3] + scalarForB * vectorB[3],
			vectorA[4] + scalarForB * vectorB[4]
		)
	end,

	---A smaller variant of vector add multiply.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@return table vector
	addMultV4S_SL = function(vectorA, vectorB, scalarForB)
		return {
			vectorA[1] + scalarForB * vectorB[1],
			vectorA[2] + scalarForB * vectorB[2],
			vectorA[3] + scalarForB * vectorB[3],
			vectorA[4] + scalarForB * vectorB[4]
		}
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultVAQ_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value + scalarForB * vectorB[i]
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector, i)
		end
		return outputVector
	end,

	---A quick add multiply, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@param outputVector table?
	---@return table vector
	addMultVA_SL = function(vectorA, vectorB, scalarForB, outputVector)
		outputVector = outputVector or {}

		for i, vec1Value in ipairs_SL(vectorA) do
			outputVector[i] = vec1Value + scalarForB * vectorB[i]
		end

		return Vectors.pruneVA_SL(outputVector, #vectorA)
	end,

	---A smaller variant of vector add multiply.
	---@param vectorA table
	---@param vectorB table
	---@param scalarForB number
	---@return table vector
	addMultVAS_SL = function(vectorA, vectorB, scalarForB)
		local newVec = {}

		for i = 1, #vectorA do
			newVec[i] = vectorA[i] + scalarForB * vectorB[i]
		end

		return newVec
	end,

	---A quick cross product, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	crossV3Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[2] * vectorB[3] - vectorA[3] * vectorB[2]
		outputVector[2] = vectorA[3] * vectorB[1] - vectorA[1] * vectorB[3]
		outputVector[3] = vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1]

		return outputVector
	end,

	---A quick cross product, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	crossV3_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		return Vectors.setV3_SL(outputVector,
			vectorA[2] * vectorB[3] - vectorA[3] * vectorB[2],
			vectorA[3] * vectorB[1] - vectorA[1] * vectorB[3],
			vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1]
		)
	end,

	---A smaller variant of cross product.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	crossV3S_SL = function(vectorA, vectorB)
		return {
			vectorA[2] * vectorB[3] - vectorA[3] * vectorB[2],
			vectorA[3] * vectorB[1] - vectorA[1] * vectorB[3],
			vectorA[1] * vectorB[2] - vectorA[2] * vectorB[1]
		}
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV2Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2]
		dotBB = vectorB[1]^2 + vectorB[2]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorB[1] * scalar
		outputVector[2] = vectorB[2] * scalar

		return outputVector
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV2_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--computed early in case A and out are same reference
		local dotAB = Vectors.dotV2_SL(vectorA, vectorB)
		Vectors.setToV2_SL(outputVector, vectorB)
		Vectors.scaleV2Q_SL(
			outputVector,
			dotAB / Vectors.dotV2_SL(vectorB,vectorB),
			outputVector
		)

		return outputVector
	end,

	---A smaller variant of projecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	projectV2S_SL = function(vectorA, vectorB)
		return Vectors.scaleV2S_SL(vectorB,
			Vectors.dotV2_SL(vectorA, vectorB) / Vectors.dotV2_SL(vectorB,vectorB)
		)
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV3Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3]
		dotBB = vectorB[1]^2 + vectorB[2]^2 + vectorB[3]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorB[1] * scalar
		outputVector[2] = vectorB[2] * scalar
		outputVector[3] = vectorB[3] * scalar

		return outputVector
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV3_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--computed early in case A and out are same reference
		local dotAB = Vectors.dotV3_SL(vectorA, vectorB)
		Vectors.setToV3_SL(outputVector, vectorB)
		Vectors.scaleV3Q_SL(
			outputVector,
			dotAB / Vectors.dotV3_SL(vectorB,vectorB),
			outputVector
		)

		return outputVector
	end,

	---A smaller variant of projecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	projectV3S_SL = function(vectorA, vectorB)
		return Vectors.scaleV3S_SL(vectorB,
			Vectors.dotV3_SL(vectorA, vectorB) / Vectors.dotV3_SL(vectorB,vectorB)
		)
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV4Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3] + vectorA[4] * vectorB[4]
		dotBB = vectorB[1]^2 + vectorB[2]^2 + vectorB[3]^2 + vectorB[4]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorB[1] * scalar
		outputVector[2] = vectorB[2] * scalar
		outputVector[3] = vectorB[3] * scalar
		outputVector[4] = vectorB[4] * scalar

		return outputVector
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectV4_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--computed early in case A and out are same reference
		local dotAB = Vectors.dotV4_SL(vectorA, vectorB)
		Vectors.setToV4_SL(outputVector, vectorB)
		Vectors.scaleV4Q_SL(
			outputVector,
			dotAB / Vectors.dotV4_SL(vectorB,vectorB),
			outputVector
		)

		return outputVector
	end,

	---A smaller variant of projecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	projectV4S_SL = function(vectorA, vectorB)
		return Vectors.scaleV4S_SL(vectorB,
			Vectors.dotV4_SL(vectorA, vectorB) / Vectors.dotV4_SL(vectorB,vectorB)
		)
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectVAQ_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar = 0, 0
		outputVector = outputVector or {}

		for i=1, #vectorA do
			dotAB = dotAB + vectorA[i] * vectorB[i]
			dotBB = dotBB + vectorB[i] * vectorB[i]
		end
		scalar = dotAB / dotBB

		for i=1, #vectorA do
			outputVector[i] = vectorB[i] * scalar
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector,i)
		end
		return outputVector
	end,

	---Projects vector A onto vector B, by giving it output vector, you avoid garbage collector. Uses function instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	projectVA_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--computed early in case A and out are same reference
		local dotAB = Vectors.dotVA_SL(vectorA, vectorB)
		Vectors.setToVA_SL(outputVector, vectorB)
		Vectors.scaleVAQ_SL(
			outputVector,
			dotAB / Vectors.dotVA_SL(vectorB,vectorB),
			outputVector
		)

		return outputVector
	end,

	---A smaller variant of projecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	projectVAS_SL = function(vectorA, vectorB)
		return Vectors.scaleVAS_SL(vectorB,
			Vectors.dotVA_SL(vectorA, vectorB) / Vectors.dotVA_SL(vectorB,vectorB)
		)
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV2Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2]
		dotBB = vectorB[1]^2 + vectorB[2]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorA[1] - vectorB[1] * scalar
		outputVector[2] = vectorA[2] - vectorB[2] * scalar

		return outputVector
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV2_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--safeguard for when A and out are the same reference
		vectorA = outputVector == vectorA and Vectors.copyV2_SL(vectorA) or vectorA

		Vectors.projectV2Q_SL(vectorA, vectorB, outputVector)
		Vectors.subV2Q_SL(vectorA, outputVector, outputVector)

		return outputVector
	end,

	---A smaller variant of rejecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	rejectV2S_SL = function(vectorA, vectorB)
		return Vectors.subV2S_SL(vectorA, Vectors.projectV2S_SL(vectorA, vectorB) )
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV3Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3]
		dotBB = vectorB[1]^2 + vectorB[2]^2 + vectorB[3]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorA[1] - vectorB[1] * scalar
		outputVector[2] = vectorA[2] - vectorB[2] * scalar
		outputVector[3] = vectorA[3] - vectorB[3] * scalar

		return outputVector
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV3_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--safeguard for when A and out are the same reference
		vectorA = outputVector == vectorA and Vectors.copyV2_SL(vectorA) or vectorA

		Vectors.projectV3Q_SL(vectorA, vectorB, outputVector)
		Vectors.subV3Q_SL(vectorA, outputVector, outputVector)

		return outputVector
	end,

	---A smaller variant of rejecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	rejectV3S_SL = function(vectorA, vectorB)
		return Vectors.subV3_SL(vectorA, Vectors.projectV3_SL(vectorA, vectorB) )
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV4Q_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar
		outputVector = outputVector or {}

		dotAb = vectorA[1] * vectorB[1] + vectorA[2] * vectorB[2] + vectorA[3] * vectorB[3] + vectorA[4] * vectorB[4]
		dotBB = vectorB[1]^2 + vectorB[2]^2 + vectorB[3]^2 + vectorB[4]^2
		scalar = dotAB / dotBB

		outputVector[1] = vectorA[1] - vectorB[1] * scalar
		outputVector[2] = vectorA[2] - vectorB[2] * scalar
		outputVector[3] = vectorA[3] - vectorB[3] * scalar
		outputVector[4] = vectorA[4] - vectorB[4] * scalar

		return outputVector
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectV4_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--safeguard for when A and out are the same reference
		vectorA = outputVector == vectorA and Vectors.copyV2_SL(vectorA) or vectorA

		Vectors.projectV4Q_SL(vectorA, vectorB, outputVector)
		Vectors.subV4Q_SL(vectorA, outputVector, outputVector)

		return outputVector
	end,

	---A smaller variant of rejecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	rejectV4S_SL = function(vectorA, vectorB)
		return Vectors.subV4S_SL(vectorA, Vectors.projectV4S_SL(vectorA, vectorB) )
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectVAQ_SL = function(vectorA, vectorB, outputVector)
		local dotAB, dotBB, scalar = 0, 0
		outputVector = outputVector or {}

		for i=1, #vectorA do
			dotAB = dotAB + vectorA[i] * vectorB[i]
			dotBB = dotBB + vectorB[i] * vectorB[i]
		end
		scalar = dotAB / dotBB

		for i=1, #vectorA do
			outputVector[i] = vectorA - vectorB[i] * scalar
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector,i)
		end
		return outputVector
	end,

	---Rejects vector A from vector B, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table vector
	rejectVA_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		--safeguard for when A and out are the same reference
		vectorA = outputVector == vectorA and Vectors.copyV2_SL(vectorA) or vectorA

		Vectors.projectV4Q_SL(vectorA, vectorB, outputVector)
		Vectors.subV4Q_SL(vectorA, outputVector, outputVector)

		return outputVector
	end,

	---A smaller variant of rejecting vectors.
	---@param vectorA table
	---@param vectorB table
	---@return table vector
	rejectVAS_SL = function(vectorA, vectorB)
		return Vectors.subV4S_SL(vectorA, Vectors.projectV4S_SL(vectorA, vectorB) )
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV2Q_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = (1-t) * vectorA[1] + t * vectorB[1]
		outputVector[2] = (1-t) * vectorA[2] + t * vectorB[2]

		return outputVector
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV2_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		vectorB = Vectors.scaleV2Q_SL(vectorB, t) --necessitates a garbage creation
		Vectors.scaleV2Q_SL(vectorA, 1-t, outputVector)
		Vectors.addV2Q_SL(outputVector, vectorB, outputVector)

		return outputVector
	end,

	---A smaller variant of lerping vectors.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@return table vector
	lerpV2S_SL = function(vectorA, vectorB, t)
		return Vectors.addV2S_SL(
			Vectors.scaleV2S_SL(vectorA, 1-t),
			Vectors.scaleV2S_SL(vectorB, t)
		)
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV3Q_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = (1-t) * vectorA[1] + t * vectorB[1]
		outputVector[2] = (1-t) * vectorA[2] + t * vectorB[2]
		outputVector[3] = (1-t) * vectorA[3] + t * vectorB[3]

		return outputVector
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV3_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		vectorB = Vectors.scaleV3Q_SL(vectorB, t) --necessitates a garbage creation
		Vectors.scaleV3Q_SL(vectorA, 1-t, outputVector)
		Vectors.addV3Q_SL(outputVector, vectorB, outputVector)

		return outputVector
	end,

	---A smaller variant of lerping vectors.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@return table vector
	lerpV3S_SL = function(vectorA, vectorB, t)
		return Vectors.addV3S_SL(
			Vectors.scaleV3S_SL(vectorA, 1-t),
			Vectors.scaleV3S_SL(vectorB, t)
		)
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV4Q_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = (1-t) * vectorA[1] + t * vectorB[1]
		outputVector[2] = (1-t) * vectorA[2] + t * vectorB[2]
		outputVector[3] = (1-t) * vectorA[3] + t * vectorB[3]
		outputVector[4] = (1-t) * vectorA[4] + t * vectorB[4]

		return outputVector
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpV4_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		vectorB = Vectors.scaleV4Q_SL(vectorB, t) --necessitates a garbage creation
		Vectors.scaleV4Q_SL(vectorA, 1-t, outputVector)
		Vectors.addV4Q_SL(outputVector, vectorB, outputVector)

		return outputVector
	end,

	---A smaller variant of lerping vectors.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@return table vector
	lerpV4S_SL = function(vectorA, vectorB, t)
		return Vectors.addV4S_SL(
			Vectors.scaleV4S_SL(vectorA, 1-t),
			Vectors.scaleV4S_SL(vectorB, t)
		)
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpVAQ_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		for i=1, #vectorA do
			outputVector[i] = (1-t) * vectorA[i] + t * vectorB[i]
		end

		for i = #outputVector, #vectorA + 1, -1 do
			remove_SL(outputVector,i)
		end
		return outputVector
	end,

	---A quick lerp, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@param outputVector table?
	---@return table vector
	lerpVA_SL = function(vectorA, vectorB, t, outputVector)
		outputVector = outputVector or {}

		vectorB = Vectors.scaleVAQ_SL(vectorB, t) --necessitates a garbage creation
		Vectors.scaleVAQ_SL(vectorA, 1-t, outputVector)
		Vectors.addVAQ_SL(outputVector, vectorB, outputVector)

		return outputVector
	end,

	---A smaller variant of lerping vectors.
	---@param vectorA table
	---@param vectorB table
	---@param t number
	---@return table vector
	lerpVAS_SL = function(vectorA, vectorB, t)
		return Vectors.addVAS_SL(
			Vectors.scaleVAS_SL(vectorA, 1-t),
			Vectors.scaleVAS_SL(vectorB, t)
		)
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV2Q_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, v1, v2
		row1 = matrix[1]
		row2 = matrix[2]
		v1 = vector[1]
		v2 = vector[2]

		outputVector[1] = row1[1]*v1 + row1[2]*v2
		outputVector[2] = row2[1]*v1 + row2[2]*v2

		return outputVector
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV2_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, v1, v2
		row1 = matrix[1]
		row2 = matrix[2]
		v1 = vector[1]
		v2 = vector[2]

		return Vectors.setV2_SL(outputVector,
			row1[1]*v1 + row1[2]*v2,
			row2[1]*v1 + row2[2]*v2
		)
	end,

	---A smaller variant of vector matrix multiplication.
	---@param vector table
	---@param matrix table
	---@return table vector
	matMultV2S_SL = function(vector, matrix)
		--char saves documented in matMultV4S_SL
		local row1, row2, v1, v2
		row1 = matrix[1]
		row2 = matrix[2]
		v1 = vector[1]
		v2 = vector[2]
		return {
			row1[1]*v1 + row1[2]*v2,
			row2[1]*v1 + row2[2]*v2
		}
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV3Q_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, row3, v1, v2, v3
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]

		outputVector[1] = row1[1]*v1 + row1[2]*v2 + row1[3]*v3
		outputVector[2] = row2[1]*v1 + row2[2]*v2 + row2[3]*v3
		outputVector[3] = row3[1]*v1 + row3[2]*v2 + row3[3]*v3

		return outputVector
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV3_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, row3, v1, v2, v3
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]

		return Vectors.setV3_SL(outputVector,
			row1[1]*v1 + row1[2]*v2 + row1[3]*v3,
			row2[1]*v1 + row2[2]*v2 + row2[3]*v3,
			row3[1]*v1 + row3[2]*v2 + row3[3]*v3
		)
	end,

	---A smaller variant of vector matrix multiplication.
	---@param vector table
	---@param matrix table
	---@return table vector
	matMultV3S_SL = function(vector, matrix)
		--char saves documented in matMultV4S_SL
		local row1, row2, row3, v1, v2, v3
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]
		return {
			row1[1]*v1 + row1[2]*v2 + row1[3]*v3,
			row2[1]*v1 + row2[2]*v2 + row2[3]*v3,
			row3[1]*v1 + row3[2]*v2 + row3[3]*v3
		}
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV4Q_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, row3, row4, v1, v2, v3, v4
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		row4 = matrix[4]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]
		v4 = vector[4]

		outputVector[1] = row1[1]*v1 + row1[2]*v2 + row1[3]*v3 + row1[4]*v4
		outputVector[2] = row2[1]*v1 + row2[2]*v2 + row2[3]*v3 + row2[4]*v4
		outputVector[3] = row3[1]*v1 + row3[2]*v2 + row3[3]*v3 + row3[4]*v4
		outputVector[4] = row4[1]*v1 + row4[2]*v2 + row4[3]*v3 + row4[4]*v4

		return outputVector
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses functions instead of inlining.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultV4_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}
		local row1, row2, row3, row4, v1, v2, v3, v4
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		row4 = matrix[4]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]
		v4 = vector[4]

		return Vectors.setV4_SL(outputVector,
			row1[1]*v1 + row1[2]*v2 + row1[3]*v3 + row1[4]*v4,
			row2[1]*v1 + row2[2]*v2 + row2[3]*v3 + row2[4]*v4,
			row3[1]*v1 + row3[2]*v2 + row3[3]*v3 + row3[4]*v4,
			row4[1]*v1 + row4[2]*v2 + row4[3]*v3 + row4[4]*v4
		)
	end,

	---A smaller variant of vector matrix multiplication.
	---@param vector table
	---@param matrix table
	---@return table vector
	matMultV4S_SL = function(vector, matrix)
		--declaration costs: 6 + 8*2 = 22
		--each assignment costs: 6 for a total of 48 and plus 22 = 70
		--each rowx and vy has been used 4 times each, total 4*8 = 32 uses
		--each use saves 3 chars, for a total of 96
		--96 saves - 70 cost = 26 savings in theory
		--minification results in saves of 25, maybe I slipped a char somewhere, a newline?
		local row1, row2, row3, row4, v1, v2, v3, v4
		row1 = matrix[1]
		row2 = matrix[2]
		row3 = matrix[3]
		row4 = matrix[4]
		v1 = vector[1]
		v2 = vector[2]
		v3 = vector[3]
		v4 = vector[4]
		return {
			row1[1]*v1 + row1[2]*v2 + row1[3]*v3 + row1[4]*v4,
			row2[1]*v1 + row2[2]*v2 + row2[3]*v3 + row2[4]*v4,
			row3[1]*v1 + row3[2]*v2 + row3[3]*v3 + row3[4]*v4,
			row4[1]*v1 + row4[2]*v2 + row4[3]*v3 + row4[4]*v4
		}
	end,

	---A quick vector matrix multiplication, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vector table
	---@param matrix table
	---@param outputVector table?
	---@return table vector
	matMultVAQ_SL = function(vector, matrix, outputVector)
		outputVector = outputVector or {}

		vector = outputVector == vector and Vectors.copyV2_SL(vector) or vector

		for i, row in ipairs_SL(matrix) do
			local v = 0
			for j, weight in ipairs_SL(row) do
				v = v + weight * vector[j]
			end
			outputVector[i] = v
		end

		for i = #outputVector, #matrix + 1, -1 do
			remove_SL(outputVector,i)
		end
		return outputVector
	end,

	---A smaller variant of vector matrix multiplication.
	---@param vector table
	---@param matrix table
	---@return table vector
	matMultVAS_SL = function(vector, matrix)
		local outputVector, v = {}

		for i, row in ipairs_SL(matrix) do
			v = 0
			for j, weight in ipairs_SL(row) do
				v = v + weight * vector[j]
			end
			outputVector[i] = v
		end

		return outputVector
	end,
}

StormSL.Vectors = Vectors