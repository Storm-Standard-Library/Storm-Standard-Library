--version 0.0.0

---@section StormSL 1 _STORM_SL_CLASS_
do	--hides the upvalues so that there's no chance of name conflict for locals below
	local ipairs_SL,pairs_SL,insert_SL,remove_SL,type_SL,unpack_SL=ipairs,pairs,table.insert,table.remove,type,table.unpack

	--it's declared as a global so that it can be accessed from anywhere in the script, always

	---@class StormSL
	---@field version_SL string
	---@field clamp_SL fun(minimum:number, maximum:number, value:number):number
	---@field ewma_SL fun(old:number, new:number, gamma:number):number
	---@field ewmaClass_SL fun(alpha:number?, innitialValue:number?):table
	---@field threshold_SL fun(x:number, min:number, max:number):boolean
	---@field CatchNaN_SL fun(x:number):any
	---@field parseLineCSV_SL fun(line:string):...
	---@field lerpX_SL fun(x:number, x1:number, y1:number, x2:number, y2:number):number
	---@field lerpT_SL fun(t:number, t0_value:number, t1_value:number):number
	---@field simpleCopy_SL fun(tableIn:table, tableOut:table?, allowOverwrite:boolean?):table
	---@field deepCopy_SL fun(tableIn:table, tableOut:table?):table
	---@field xorShift_SL fun(int64:integer):integer
	---@field createRngClosure_SL fun(seed:integer?, boundLow:number?, boundHigh:number?, integerMode:boolean?):function
	---@field stringToWordTable_SL fun(string:string):table
	---@field getAverage_SL fun(...:number):number
	---@field Vector table Vector---The standard library for Stormworks Lua.
	---The standard library for Stormworks Lua.
	StormSL = {
		---@section version_SL
		version_SL='0.0.0',
		---@endsection

		---@section clamp_SL
		---@param minimum number
		---@param maximum number
		---@param value number
		---@return number
		clamp_SL = function(minimum, maximum, value)
			--using ternary is faster than if-else or math.min/max
			return value > maximum and maximum or value < minimum and minimum or value
		end,
		---@endsection

		---@section ewma_SL
		---Exponential weighted moving average. Smoothes out the input number.
		---@param old number previous smoothed number
		---@param new number number to add and smooth, output approuches new
		---@param gamma number how strong smoothing is
		---@return number smoothed
		ewma_SL = function(old, new, gamma)
			return ( (gamma-1) * old + new) / gamma
		end,
		---@endsection

		---@section ewmaClass_SL
		---@class EWMA
		---@field alpha number the smoothing factor of the EWMA, default 0.1
		---@field value number the current smoothed value of the EWMA
		---@field update fun(self:EWMA, newValue:number):number updates the value of the EWMA
		---@param alpha number? the smoothing factor of the EWMA, default 0.1
		---@param innitialValue number? the initial value of the EWMA, default 0
		---@return table EWMA object
		ewmaClass_SL = function (alpha, innitialValue)
			return {
				alpha = alpha or 0.1,
				value = innitialValue or 0,
				---Updates & runs the EWMA smoothing on the new value.
				---@param s EWMA self Table
				---@param newValue number new value to smooth
				---@return number smoothed Output of the EWMA
				update = function(s, newValue)
					s.value = (1 - s.alpha) * s.value + s.alpha * newValue
					return s.value
				end
			}
		end,
		---@endsection

		---@section threshold_SL
		---Checks if the value is between the min and max.
		---@param x number
		---@param min number
		---@param max number
		---@return boolean
		threshold_SL = function(x, min, max)
			return x>min and x<max
		end,
		---@endsection

		---@section fixNaN_SL
		---Replaces NaN with an optionally provided value, or defaults it to 0.
		---@param x number value to correct
		---@param fixValue number? value to replace NaN with. Defaults to 0
		---@return any y Will be x if x isn't NaN, or fixValue if it is (or 0 if one isn't provided).
		fixNaN_SL = function(x, fixValue)
			return x == x and x or fixValue or 0
		end,
		---@endsection

		---@section lerpX_SL
		---Linearly interpolate between {x1,y1} and {x2,y2}. Produces y for a given x.
		---@param x number more commonly denoted as "t", I however used x because it's better than just working in 0-1 range
		---@param x1 number input 1
		---@param y1 number output 1
		---@param x2 number input 2
		---@param y2 number output 2
		---@return number y output of x on line {x1,y1} {x2,y2}
		lerpX_SL = function(x, x1, y1, x2, y2)
			return (x - x1) * (y2 - y1) / (x2 - x1) + y1
		end,
		---@endsection

		---@section lerpT_SL
		---Linearly interpolate between y1 and y2.
		---@param t number control input
		---@param t0_value number output for when t is 0
		---@param t1_value number output for when t is 1
		---@return number y linear interpolation between y1 for t=0 and y2 for t=1
		lerpT_SL = function(t, t0_value, t1_value)
			return t0_value + t * (t1_value - t0_value)
		end,
		---@endsection

		---@section simpleCopy_SL
		---Will copy the provided table and all it's nested contents including tables.
		---@param tableIn table table to copy
		---@param tableOut table? table to copy into, if not provided will create a new table
		---@param allowOverwrite boolean? if true and tableOut is present, it'll have it's indices overwritten
		---@return table 
		simpleCopy_SL = function(tableIn, tableOut, allowOverwrite)
			tableOut = tableOut or {}
			local disableOverwrite = not allowOverwrite
			for key,copiedValue in pairs_SL(tableIn) do
				tableOut[key] = disableOverwrite and tableOut[key] or copiedValue
			end
			return tableOut
		end,
		---@endsection

		---@section deepCopy_SL
		---Will copy the provided table and all it's nested contents including tables.
		---@param tableIn table table to copy
		---@param tableOut table? table to copy into, if not provided will create a new table
		---@return table 
		deepCopy_SL = function(tableIn, tableOut)
			tableOut = tableOut or {}
			local check, tables_list, recursive = 'table', {}

			recursive=function(nested_table, output_table)
				tables_list[nested_table] = output_table
				for key,copiedValue in pairs_SL(nested_table) do
					key = (type_SL(key) == check) and (tables_list[key] or recursive(key, {}) ) or key
					output_table[key] = (type_SL(copiedValue) == check) and (tables_list[copiedValue] or recursive(copiedValue, {}) ) or copiedValue
				end
				return output_table
			end

			return recursive(tableIn, tableOut)
		end,
		---@endsection

		---@section xorShift_SL
		---@param int64 integer
		---@return integer
		xorShift_SL = function(int64)
			int64 = int64 ~ (int64 << 13)
			int64 = int64 ~ (int64 >> 7)
			return int64 ~ (int64 << 17)
		end,
		---@endsection

		---@section createRngClosure_SL
		---Creates a random number generator closure.
		---@param seed integer?
		---@param boundLow number?
		---@param boundHigh number?
		---@param integerMode boolean?
		---@return function
		createRngClosure_SL = function(seed, boundLow, boundHigh, integerMode)
			seed = seed or 1
			boundLow = boundLow or 0
			boundHigh = boundHigh or 1

			--4294967295 is 2^32-1, the maximum value of a 32 bit unsigned integer
			local xorShiftSL, floor, mask = StormSL.xorShift_SL, math.floor, 4294967295

			return function()
				seed = xorShiftSL(seed)
				local x = ( (seed >> 16) & mask) / mask
				if integerMode then
					return floor(boundLow + x *(boundHigh - boundLow) + 0.5)
				end
				return boundLow + x * (boundHigh - boundLow)
			end
		end,
		---@endsection

		---@section stringToWordTable_SL
		---Cuts the string into words based on whitespace and returns a table of strings.
		---@param string string
		---@return table
		stringToWordTable_SL = function(string)
			local outputTable = {}
			for word in string:gmatch('%g+') do
				insert_SL(outputTable, word)
			end
			return outputTable
		end,
		---@endsection

		---@section getAverage_SL
		---Creates an average of the arguments given to it.
		---@param ... number
		---@return number
		getAverage_SL=function(...)
			local inputs, sum = {...}, 0
			for key,value in ipairs_SL(inputs) do
				sum = sum + value
			end
			return sum / #inputs
		end,
		---@endsection
	}

	--again using upvalues for internal speedups as those end up being upvalues
	--build require is a copypaste, hence it works as VectorSL will be able to access itself for example
	local Vector, Matrix
	require('StormSL.Vector')
	require('StormSL.Matrix') --unimplemented!
end
--speeds up every access while in game as it's an upvalue of both onTick and onDraw
--it's declared after global declaration so that there is also a reference in the _ENV table
local StormSL = StormSL

---@endsection _STORM_SL_CLASS