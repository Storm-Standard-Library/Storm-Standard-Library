
--is necessary for simulation to work properly as well as it uses a loadfile() and call it instantly without returns
--it's a cheeky hidden do end that only exists in simulation so that the execution in simulation and build is the same
--however
--MatrixSL is not declared yet so it while it would work in build due to it being prematurely declared
--in simulation, it just didn't happen yet, and StormSL.MatrixSL would be nil
--hence there has to be a rule of a module not being able to access another module as an upvalue
--only through StormSL.ModuleSL
--but yeah VectorSL.newV3() is fine
---@section __LB_SIMULATOR_ONLY_STORMSL_VECTORS_START__
do
local StormSL,ipairs_SL,pairs_SL,insert_SL,remove_SL,type_SL,Vector=StormSL,ipairs,pairs,table.insert,table.remove,type
---@endsection

---@section Vector 1 STORMSL_VECTOR_CLASS
---@class Vector
---@field newV3_SL fun(x:number?,y:number?,z:number?):table
---@field setV3_SL fun(vector:table,x:number,y:number,z:number):nil
---@field addV3Q_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---@field addV3S_SL fun(vectorA:table,vectorB:table,outputVector:table?):table
---Standard Stormworks Vector functions
Vector = {
	---@section newV3_SL
	---Creates a new 3D vector, if any of the arguments are nil, it will default to 0
	---@param x number?
	---@param y number?
	---@param z number?
	---@return table
	newV3_SL = function(x, y, z)
		return {
			x or 0,
			y or 0,
			z or 0
		}
	end,
	---@endsection

	---@section setV3_SL
	---Sets the values of a vector to the given values
	---@param vector table vector to change
	---@param x number new x value
	---@param y number new y value
	---@param z number new z value
	---@return nil
	setV3_SL = function(vector, x, y, z)
		vector[1]=x
		vector[2]=y
		vector[3]=z
	end,
	---@endsection

	---@section addV3Q_SL
	---A quick add vector, by giving it output vector, you avoid garbage collector. Uses inlined operations.
	---@param vectorA table
	---@param vectorB table
	---@param outputVector table?
	---@return table
	addV3Q_SL = function(vectorA, vectorB, outputVector)
		outputVector = outputVector or {}

		outputVector[1] = vectorA[1] + vectorB[1]
		outputVector[2] = vectorA[2] + vectorB[2]
		outputVector[3] = vectorA[3] + vectorB[3]

		return outputVector
	end,
	---@endsection

	---@section addV3S_SL
	---A smaller variant of adding vectors, setting the vector using another function call for longterm char gains.
	---@param vectorA table
	---@param vectorB table
	---@return table
	addV3S_SL = function(vectorA, vectorB)
		return {
			vectorA[1] + vectorB[1],
			vectorA[2] + vectorB[2],
			vectorA[3] + vectorB[3]
		}
	end,
	---@endsection
}

StormSL.Vector = Vector
---@endsection STORMSL_VECTOR_CLASS


---@section __LB_SIMULATOR_ONLY_STORMSL_VECTORS_END__
end
---@endsection