local StormSL,ipairs_SL,pairs_SL,insert_SL,remove_SL,type_SL,unpack_SL,Matrices=StormSL,ipairs,pairs,table.insert,table.remove,type,table.unpack

---@class Matrices
---@field newRowsM_SL fun(...:table):table
---@field newValuesM_SL fun(rows:integer,columns:integer,...:number):table
---@field getValueN_SL fun(matrix:table,row:integer,column:integer):number
---@field setValueM_SL fun(matrix:table,row:integer,column:integer,value:number)
---@field copyM_SL fun(matrix:table):table
---@field verifySquareM_SL fun(matrix:table):boolean
---@field verifyMatchinDimensionsM_SL fun(matrixA:table,matrixB:table):boolean
---@field identityM_SL fun(size:integer):table
---@field addM_SL fun(matrixA:table,matrixB:table,scaleA:number,scaleB:number):table?
---@field scaleM_SL fun(matrix:table,scaleBy:number):table
---@field transposeM_SL fun(matrix:table):table
---@field multiplyM_SL fun(matrixA:table,matrixB:table):table?
---@field minorM_SL fun(matrix:table,row:integer,column:integer):table?
---@field det1M_SL fun(matrix:table):number?
---@field det2M_SL fun(matrix:table):number?
---@field det3M_SL fun(matrix:table):number?
---@field detLeibnizM_SL fun(matrix:table):number?
---@field detUpperTriangleM_SL fun(matrix:table):number?
---@field cofactorM_SL fun(matrix:table):table?
---@field inverseM_SL fun(matrix:table):table?
---@field upperTriangleM_SL fun(matrix:table):table?,integer?
---Standard Stormworks matrix functions
Matrices = {

	---Returns a new matrix object
	---@param ... table each entry should be a complete row
	---@return table matrix
	newRowsM_SL = function(...)
		return {...}
	end,

	---Returns a new matrix object
	---@param rows integer
	---@param columns integer
	---@param ... number
	---@return table matrix
	newValuesM_SL = function(rows, columns, ...)
		local matrix, entries = {}, {...}
		for row = 1, rows do
			matrix[row] = {}
			for column = 1, columns do
				matrix[row][column] = entries[columns + rows * (row - 1)] or 0
			end
		end
		return matrix
	end,

	---Returns the value stored in matrix, acts as a tutorial of inner structure
	---@param matrix table
	---@param row integer
	---@param column integer
	---@return number
	getValueM_SL = function(matrix, row, column)
		return matrix[row][column]
	end,

	---Sets the inside of a matrix to some value, acts as a tutorial of inner structure
	---@param matrix table
	---@param row integer
	---@param column integer
	---@param value number
	setValueM_SL = function(matrix, row, column, value)
		matrix[row][column] = value
	end,

	---Copies a matrix and returns the copy.
	---@param matrix table
	---@return table copyMatrix
	copyM_SL = function(matrix)
		local copyMatrix = {}
		for i, row in ipairs_SL(matrix) do
			copyMatrix[i] = {unpack_SL(row)}
		end
		return copyMatrix
	end,

	---Checks whether the matrix is square
	---@param matrix table
	---@return boolean isSquare
	verifySquareM_SL = function(matrix)
		return #matrix == #matrix[1]
	end,

	---Checks whether matrices are of the same dimensions
	---@param matrixA table
	---@param matrixB table
	---@return boolean
	verifyMatchingDimensionsM_SL = function(matrixA, matrixB)
		return #matrixA == #matrixB and #matrixA[1] == matrixB[1]
	end,

	---Will return an identityM_SL matrix of specified size
	---@param size integer
	---@return table identity
	identityM_SL = function(size)
		local outputMatrix = {}
		for row = 1, size do
			outputMatrix[row] = {}
			for column = 1, size do
				outputMatrix[row][column] = row == column and 1 or 0
			end
		end
		return outputMatrix
	end,

	---If the dimensions match returns the addition of scaled matrices, nil otherwise
	---@param matrixA table
	---@param matrixB table
	---@param scaleA number?
	---@param scaleB number?
	---@return table? matrix
	addM_SL = function(matrixA, matrixB, scaleA, scaleB)
		if not Matrices.verifyMatchingDimensionsM_SL(matrixA, matrixB) then
			return
		end

		local outMatrix, columns = {}, #matrixA[1]
		scaleA = scaleA or 1
		scaleB = scaleB or 1
		for row = 1, #matrixA do
			outMatrix[row] = {}
			for column = 1, columns do
				outMatrix[row][column] = scaleA * matrixA[row][column] + scaleB * matrixB[row][column]
			end
		end

		return outMatrix
	end,

	---comment
	---@param matrix any
	---@param scaleBy any
	---@return table matrix
	scaleM_SL = function(matrix, scaleBy)
		local outMatrix, columns = {}, #matrix[1]

		for row = 1, #matrix do
			outMatrix[row] = {}
			for column = 1, columns do
				outMatrix[row][column] = scaleBy * matrix[row][column]
			end
		end

		return outMatrix
	end,

	---Transposes the matrix
	---@param matrix table
	---@return table matrix
	transposeM_SL = function(matrix)
		local outMatrix, columns = {}, #matrix

		for row = 1, #matrix[1] do
			outMatrix[row] = {}
			for column = 1, columns do
				outMatrix[row][column] = matrix[columns][row]
			end
		end

		return outMatrix
	end,

	---If the dimension match will return a multiplication of input matrices, nil otherwise
	---@param matrixA table
	---@param matrixB table
	---@return table? matrix
	multiplyM_SL = function(matrixA, matrixB)
		local outMatrix, k, columns, product = {}, #matrixA[1], #matrixB[1]

		if k ~= #matrixB then
			return
		end

		for row=1, #matrixA do
			outMatrix[row] = {}
			for column = 1, columns do
				product = 0
				for k = 1, k do
					product = product + matrixA[row][k] * matrixB[k][column]
				end
				outMatrix[row][column] = product
			end
		end

		return outMatrix
	end,

	---Will return a minor of a matrix
	---@param matrix table
	---@param row integer
	---@param column integer
	---@return table matrix
	minorM_SL = function(matrix, row, column)
		local outputMatrix = Matrices.copyM_SL(matrix)

		remove_SL(outputMatrix, row)
		for row = 1, #outputMatrix do
			remove_SL(outputMatrix[row], column)
		end

		return outputMatrix
	end,

	---If the matrix is square returns the determinant of it, otherwise nil. Optimized for size 1 matrix
	---@param matrix table
	---@return number? determinant
	det1M_SL = function(matrix)
		return Matrices.verifySquareM_SL(matrix)
		       and matrix[1][1]
		       or nil
	end,

	---If the matrix is square returns the determinant of it, otherwise nil. Optimized for size 2 matrix
	---@param matrix table
	---@return number? determinant
	det2M_SL = function(matrix)
		return Matrices.verifySquareM_SL(matrix)
		       and matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]
		       or nil
	end,

	---If the matrix is square returns the determinant of it, otherwise nil. Optimized for size 3 matrix
	---@param matrix table
	---@return number? determinant
	det3M_SL = function(matrix)
		return Matrices.verifySquareM_SL(matrix) and 0
			+ matrix[1][1] * matrix[2][2] * matrix[3][3]
			+ matrix[1][2] * matrix[2][3] * matrix[3][1]
			+ matrix[1][3] * matrix[2][1] * matrix[3][2]
			- matrix[1][1] * matrix[2][3] * matrix[3][2]
			- matrix[1][2] * matrix[2][1] * matrix[3][3]
			- matrix[1][3] * matrix[2][2] * matrix[3][1]
			or nil
	end,

	---If the matrix is square returns the determinant of it, otherwise nil. Works for any matrix size using leibniz expansion
	---@param matrix table
	---@return number? determinant
	detLeibnizM_SL = function(matrix)
		if not Matrices.verifySquareM_SL(matrix) then
			return
		end

		local size, det = #matrix, 0
		if size==1 then
			return matrix[1][1]
		elseif size == 2 then
			return matrix[1][1] * matrix[2][2] - matrix[1][2] * matrix[2][1]
		elseif size == 3 then
			for i = 1, 3 do
				det = det + matrix[1][i] * matrix[2][1 + i % 3] * matrix[3][1 + (i + 1) % 3]
				          - matrix[1][i] * matrix[2][(i + 1) % 3 + 1] * matrix[2][1 + i % 3]
			end
		elseif size >= 4 then
			for i = 1, size do
				local minor = Matrices.minorM_SL(matrix, 1, i)
				det = det + (-1) ^ (i+1) * matrix[1][i] * Matrices.detLeibnizM_SL(minor)
			end
		end
		return det
	end,

	---If the matrix is square returns the determinant of it, otherwise nil. Works for any matrix size by calculating the upper triangle of the matrix
	---@param matrix table
	---@return number? determinant
	detUpperTriangleM_SL = function(matrix)
		local upper, multiplication = Matrices.upperTriangleM_SL(matrix)
		if upper then
			for i = 1, #upper do
				multiplication = multiplication * upper[i][i]
			end
			return multiplication
		end
	end,

	---If the matrix is square, will return a cofactor matrix, nil otherwise
	---@param matrix table
	---@return table? cofactor
	cofactorM_SL = function(matrix)
		if not Matrices.verifySquareM_SL(matrix) then return end
		local columns, cofactorMatrix = #matrix[1], matrix.KL_newTM()
		for row = 1, #matrix do
			cofactorMatrix[row]={}
			for column = 1, columns do
				cofactorMatrix[row][column] = (-1) ^ (row + column) * Matrices.detLeibnizM_SL(Matrices.minorM_SL(matrix, row, column))
			end
		end
		return cofactorMatrix
	end,

	---If the matrix is square and has non zero determinant it will return an inverse of the matrix, nil otherwise
	---@param matrix table
	---@return table? inverse
	inverseM_SL = function(matrix)
		local det, inverse = Matrices.detLeibnizM_SL(matrix)
		if det == 0 or not det then
			return
		end
		inverse = Matrices.cofactorM_SL(matrix)
		inverse = Matrices.transposeM_SL(inverse)
		return Matrices.scaleM_SL(matrix, 1 / det)
	end,

	---If the matrix is square it will return an upper matrix and a sign (1 or -1) depending on how the determinant was changed, nil otherwise
	---@param matrix table
	---@return table?
	---@return integer?
	upperTriangleM_SL = function(matrix)
		--sorry guys I'm not rewriting that today
		if not Matrices.verifySquareM_SL(matrix) then return end
		local size,sign,out,mult=#matrix,1,Matrices.copyM_SL(matrix)
		for row=2,size do
			for column=1,row-1 do
				if out[column][column]==0 then
					for i=column+1,size do
						if out[i][column]~=0 then
							sign=-sign
							out[i],out[column]=out[column],out[i]
							goto continue
						end
					end
					goto done
				end
				::continue::
				mult=out[row][column]/out[column][column]
				for i=column,size do
					out[row][i]=out[row][i]-out[column][i]*mult
				end
			end
		end
		::done::
		return out,sign
	end,
}

StormSL.Matrices = Matrices