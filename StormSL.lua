--version 0.0.0

---@section StormSL 1 _STORM_SL_CLASS_
do	--hides the upvalues so that there's no chance of name conflict for locals below
	local ipairs_SL,pairs_SL,insert_SL,remove_SL,type_SL,unpack_SL=ipairs,pairs,table.insert,table.remove,type,table.unpack

	--it's declared as a global so that it can be accessed from anywhere in the script, always

	---@class StormSL
	---@field version_SL string
	---@field clampS_SL fun(minimum:number, maximum:number, value:number):number
	---@field clampQ_SL fun(minimum:number, maximum:number, value:number):number
	---@field ewma_SL fun(old:number, new:number, gamma:number):number
	---@field ewmaClass_SL fun(alpha:number?, innitialValue:number?):table
	---@field ewmaClosure_SL fun(alpha:number?, value:number?):fun(newValue:number):number
	---@field threshold_SL fun(x:number, min:number, max:number):boolean
	---@field fixNanTo0_SL fun(value:number):number
	---@field fixNanToAny_SL fun(value:number, fixValue:number):any
	---@field checkNan_SL fun(value:number):boolean
	---@field fixInfToAny_SL fun(value:number, fixValue:number):number
	---@field checkInf_SL fun(value:number):boolean
	---@field lerpX_SL fun(x:number, x1:number, y1:number, x2:number, y2:number):number
	---@field lerpT_SL fun(t:number, l:number, h:number):number
	---@field inverseLerpT_SL fun(v:number, l:number, h:number):number
	---@field inverseLerpX_SL fun(y:number, x1:number, y1:number, x2:number, y2:number):number
	---@field simpleCopy_SL fun(tableIn:table, tableOut:table?, allowOverwrite:boolean?):table
	---@field deepCopy_SL fun(tableIn:table, tableOut:table?):table
	---@field xorShift64_SL fun(int64:integer):integer
	---@field xorShift32_SL fun(int32:integer):integer
	---@field xorShift_SL fun(int:integer, l1:integer, r2:integer, l3:integer):integer
	---@field createRngClosure_SL fun(seed:integer?, boundLow:number?, boundHigh:number?, integerMode:boolean?):fun(newSeed:integer?):number
	---@field createRngClass_SL fun(seed:integer?, boundLow:number?, boundHigh:number?, integerMode:boolean?):table
	---@field stringToWordTable_SL fun(string:string):table
	---@field getAverage_SL fun(...:number):number
	---@field Vector table Vector---The standard library for Stormworks Lua.
	---The standard library for Stormworks Lua.
	StormSL = {
		---@section version_SL
		version_SL='0.0.0',
		---@endsection

		---@section clamp_SL
		---a couple chars smaller than clamQ but twice as slow which won't matter in casual usage
		---@param minimum number
		---@param maximum number
		---@param value number
		---@return number
		clampS_SL = function(minimum, maximum, value)
			return math.min(maximum, math.max(minimum, value))
		end,
		---@endsection

		---@section clamp_SL
		---a couple chars larger than clampS but twice as fast which won't matter in casual usage
		---@param minimum number
		---@param maximum number
		---@param value number
		---@return number
		clampQ_SL = function(minimum, maximum, value)
			return value > maximum and maximum or (value < minimum and minimum or value)
		end,
		---@endsection

		---@section ewma_SL
		---Exponential weighted moving average. Smoothes out the input number.
		---@param oldValue number previous smoothed number
		---@param newValue number number to add and smooth, output approuches new
		---@param alpha number how strong smoothing is
		---@return number
		ewma_SL = function(oldValue, newValue, alpha)
			return (1 - alpha) * oldValue + newValue * alpha
		end,
		---@endsection

		---@section ewmaClass_SL
		---@class EWMA
		---@field alpha number the smoothing factor of the EWMA, default 0.1
		---@field value number the current smoothed value of the EWMA
		---@field update fun(self:EWMA, newValue:number):number updates the value of the EWMA
		---@param alpha number? the smoothing factor of the EWMA, default 0.1
		---@param initialValue number? the initial value of the EWMA, default 0
		---@return table EWMA object
		ewmaClass_SL = function (alpha, initialValue)
			return {
				alpha = alpha or 0.1,
				value = initialValue or 0,
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

		---@section ewmaClosure_SL
		---@param alpha number? the smoothing factor of the EWMA, default 0.1
		---@param value number? the INITIAL! value of the EWMA. Default to 0.
		---@return fun(newValue:number):number run Updates & runs the EWMA smoothing on the new value.
		ewmaClosure_SL = function (alpha, value)
			alpha = alpha or 0.1
			value = value or 0
			---@param newValue number new value to smooth
			---@return number smoothed Output of the EWMA
			return function(newValue)
				value = (1 - alpha) * value + alpha * newValue
				return value
			end
		end,
		---@endsection

		---@section threshold_SL
		---Checks if the value is between the min and max. Exclusive.
		---@param x number
		---@param min number
		---@param max number
		---@return boolean
		threshold_SL = function(x, min, max)
			return x>min and x<max
		end,
		---@endsection

		---@section fixNanTo0_SL
		---Replaces NaN with a 0.
		---@param value number value to correct
		---@return number corrected will be 0 if NaN, otherwise the provided value
		fixNanTo0_SL = function(value)
			return value ~= value and 0 or value
		end,
		---@endsection

		---@section fixNanToAny_SL
		---Replaces NaN with a provided value.
		---@param value number value to correct
		---@param fixValue any value to replace NaNs with
		---@return any corrected will be fixValue if NaN, otherwise the provided value
		fixNanToAny_SL = function(value, fixValue)
			if value == value then
				return value
			end
			return fixValue
		end,
		---@endsection

		---@section checkNan_SL
		---Checks if the value is NaN.
		---@param value number
		---@return boolean
		checkNan_SL = function(value)
			return value ~= value
		end,
		---@endsection

		---@section fixInfToAny_SL
		---@param value number
		---@param fixValue number
		---@return number
		fixInfToAny_SL = function(value, fixValue)
			if value == 1/0 or value == -1/0 then
				return fixValue
			end
			return value
		end,
		---@endsection

		---@section checkInf_SL
		---@param value number
		---@return boolean
		checkInf_SL = function(value)
			return value == 1/0 or value == -1/0
		end,
		---@endsection

		---@section lerpT_SL
		---Linearly interpolate between y1 and y2.
		---@param t number control input
		---@param l number output for when t is 0
		---@param h number output for when t is 1
		---@return number y linear interpolation between y1 for t=0 and y2 for t=1
		lerpT_SL = function(t, l, h)
			return l + t * (h - l)
		end,
		---@endsection

		---@section lerpX_SL
		---Linearly interpolate between {x1,y1} and {x2,y2}. Produces y for a given x.
		---@param x number more commonly denoted as "t", however x was used because it's better than just working in 0-1 range
		---@param x1 number input 1
		---@param y1 number output 1
		---@param x2 number input 2
		---@param y2 number output 2
		---@return number y output of x on line {x1,y1} {x2,y2}
		lerpX_SL = function(x, x1, y1, x2, y2)
			return (x - x1) * (y2 - y1) / (x2 - x1) + y1
		end,
		---@endsection

		---@section inverseLerpT_SL
		---@param v number value to find the t for
		---@param l number lower bound
		---@param h number higher bound
		---@return number t value for v between l and h
		inverseLerpT_SL = function(v, l, h)
			return (v - l) / (h - l)
		end,
		---@endsection

		---@section inverseLerpX_SL
		---@param y number value to find the x for
		---@param x1 number input 1
		---@param y1 number output 1
		---@param x2 number input 2
		---@param y2 number output 2
		---@return number x value for y between x1 and x2
		inverseLerpX_SL = function(y, x1, y1, x2, y2)
			return (x1*y - x1*y2 - x2*y + x2*y1) / (y1 - y2)
		end,
		---@endsection

		---@section simpleCopy_SL
		---Will copy the provided table and all it's nested contents including tables AS A REFERENCE! Does not deep copy!
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

		---@section xorShift64_SL
		---Xorshift random number generator for 64 bit integers. Preferable over others.
		---@param int64 integer
		---@return integer
		xorShift64_SL = function(int64)
			int64 = int64 ~ (int64 << 13)
			int64 = int64 ~ (int64 >> 7)
			return int64 ~ (int64 << 17)
		end,
		---@endsection

		---@section xorShift32_SL
		---Xorshift random number generator for 32 bit integers. xorShift64 is preferable over this one.
		---@param int32 integer
		---@return integer
		xorShift32_SL = function(int32)
			int32 = int32 & 0xFFFFFFFF
			int32 = int32 ~ (int32 << 13)
			int32 = int32 ~ (int32 >> 17)
			return (int32 ~ (int32 << 5) ) & 0xFFFFFFFF
		end,
		---@endsection

		---@section xorShift_SL
		---Xorshift random number generator with custom shifts. xorShift64 is preferable over this one.
		---@param int integer
		---@param l1 integer
		---@param r2 integer
		---@param l3 integer
		---@return integer
		xorShift_SL = function(int, l1, r2, l3)
			int = int ~ (int << l1)
			int = int ~ (int >> r2)
			return int ~ (int << l3)
		end,
		---@endsection

		---@section createRngClosure_SL
		---Creates a random number generator closure. Uses xorShift64 masked to middle 32 bits.
		---@param seed integer?
		---@param boundLow number? default to 0
		---@param boundHigh number? default to 1
		---@param integerMode boolean?
		---@return fun(newSeed:integer?):number
		createRngClosure_SL = function(seed, boundLow, boundHigh, integerMode)
			seed = seed or 1
			boundLow = boundLow or 0
			boundHigh = boundHigh or 1

			--4294967295 is 2^32-1, the maximum value of a 32 bit unsigned integer
			local xorShiftSL, floor, mask = StormSL.xorShift64_SL, math.floor, 4294967295

			return function(newSeed)
				seed = xorShiftSL(newSeed or seed)
				local x = ( (seed >> 16) & mask) / mask
				if integerMode then
					return floor(boundLow + x *(boundHigh - boundLow) + 0.5)
				end
				return boundLow + x * (boundHigh - boundLow)
			end
		end,
		---@endsection

		---@section createRngClass_SL
		---@class RNG
		---@field seed integer the seed of the RNG
		---@field boundLow number the lower bound of the RNG
		---@field boundHigh number the higher bound of the RNG
		---@field integerMode boolean if true, will return integers, otherwise floats
		---@field generate fun(self:RNG):number generates a new random number
		---@param seed integer? the seed of the RNG, default 1
		---@param boundLow number? the lower bound of the RNG, default 0
		---@param boundHigh number? the higher bound of the RNG, default 1
		---@param integerMode boolean? if true, will return integers, otherwise floats
		---@return table
		createRngClass_SL = function (seed, boundLow, boundHigh, integerMode)
			local xorShiftSL, floor, mask = StormSL.xorShift64_SL, math.floor, 4294967295
			return {
				seed = seed or 1,
				boundLow = boundLow or 0,
				boundHigh = boundHigh or 1,
				integerMode = integerMode,
				generate = function(self)
					self.seed = xorShiftSL(self.seed)
					local x = ( (self.seed >> 16) & mask) / mask
					if self.integerMode then
						return floor(self.boundLow + x *(self.boundHigh - self.boundLow) + 0.5)
					end
					return self.boundLow + x * (self.boundHigh - self.boundLow)
				end
			}
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