---@section StormSL 1 _STORM_SL_CLASS_
do	--hides the upvalues so that there's no chance of name conflict for locals below
	local Vectors, Matrices, Bitformatting, Control, Anim, Compression, Debug

	--it's declared as a global so that it can be accessed from anywhere in the script, always
	---@class StormSL
	---@field version_SL string
	---@field clamp_SL fun(minimum:number, maximum:number, value:number):number
	---@field ewmaClass_SL fun(alpha:number?, innitialValue:number?):table
	---@field ewmaClosure_SL fun(alpha:number?, value:number?):fun(newValue:number,optAlpha:number?):number
	---@field deltaClosure_SL fun(innitialValue:number?):fun(newValue:number):number
	---@field getPulseToToggleClosure_SL fun(initialState:boolean?):function
	---@field getPushToPulseClosure_SL fun(initialState:boolean?):function
	---@field thresholdEx_SL fun(x:number, min:number, max:number):boolean
	---@field thresholdInc_SL fun(x:number, min:number, max:number):boolean
	---@field fixNanTo0_SL fun(value:number):number
	---@field fixNanToAny_SL fun(value:number, fixValue:number):any
	---@field checkNan_SL fun(value:number):boolean
	---@field fixInfToAny_SL fun(value:number, fixValue:number):number
	---@field checkInf_SL fun(value:number):boolean
	---@field fixNanInfTo0_SL fun(value:number):number
	---@field lerpX_SL fun(x:number, x1:number, y1:number, x2:number, y2:number):number
	---@field lerpT_SL fun(t:number, l:number, h:number):number
	---@field inverseLerpT_SL fun(v:number, l:number, h:number):number
	---@field inverseLerpX_SL fun(y:number, x1:number, y1:number, x2:number, y2:number):number
	---@field remap_SL fun(value:number, x1:number, y1:number, x2:number, y2:number):number
	---@field simpleCopy_SL fun(tableIn:table, tableOut:table?, allowOverwrite:boolean?):table
	---@field deepCopy_SL fun(tableIn:table, tableOut:table?):table
	---@field xorShift64_SL fun(int64:integer):integer
	---@field xorShift32_SL fun(int32:integer):integer
	---@field xorShift_SL fun(int:integer, l1:integer, r2:integer, l3:integer):integer
	---@field xoshiro256ss_SL fun(seed0:integer, seed1:integer, seed2:integer, seed3:integer):integer,integer,integer,integer,integer
	---@field createRngClosure_SL fun(seed:integer?, boundLow:number?, boundHigh:number?, integerMode:boolean?):fun(newSeed:integer?):number
	---@field createRngClass_SL fun(seed:integer?, boundLow:number?, boundHigh:number?, integerMode:boolean?):table
	---@field getIntMask_SL fun(maskBits:integer, shift:integer?):integer
	---@field getNextPower2SignedInt_SL fun(integer:integer):integer
	---@field getNextPower2UnsignedInt_SL fun(integer:integer):integer
	---@field getPower2Float_SL fun(float:number):number
	---@field getPower2Exponent_SL fun(float:number):integer
	---@field stringToWordTable_SL fun(string:string):table
	---@field getAverage_SL fun(...:number):number
	---@field createStack_SL fun():table
	---@field createStackUpval_SL fun():table
	---@field createQueue_SL fun():table
	---@field createQueueUpval_SL fun():table
	---@field cache_SL table
	---@field Vectors Vectors Standard Stormworks Vector functions
	---@field Matrices Matrices Standard Stormworks matrix functions
	---@field Bitformatting Bitformatting Encoding and decoding between numbers of different sizes, [tables , and strings]
	---@field Control Control Essential Stormworks feedback control algorithms.
	---@field Anim Anim Simple, useful, animation related functions.
	---@field Compression Compression Used to encode tables into bytes to prepare it for transmission or storage
	---@field Debug Debug Prints to console internal representations of various datatypes and allows for profiling and timing execution times
	---The Storm standard library for Stormworks Lua.
	StormSL = {

		---@section version_SL
		version_SL='0.0.0',
		---@endsection

		---@section cache_SL
		---@type table
		---To not be used. Is for internal usage to store repeated data for speedups.
		cache_SL = {},
		---@endsection

		---@section clamp_SL
		---@param minimum number
		---@param maximum number
		---@param value number
		---@return number
		clamp_SL = function(minimum, maximum, value)
			return math.min(maximum, math.max(minimum, value))
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
				---@param self EWMA self Table
				---@param newValue number new value to smooth
				---@return number smoothed Output of the EWMA
				update = function(self, newValue)
					self.value = (1 - self.alpha) * self.value + self.alpha * newValue
					return self.value
				end
			}
		end,
		---@endsection

		---@section ewmaClosure_SL
		---@param defaultAlpha number? the INITIAL! smoothing factor of the EWMA, default 0.1
		---@param initialValue number? the INITIAL! value of the EWMA. Default to 0.
		---@return fun(newValue:number,optAlpha:number?):number run Updates & runs the EWMA smoothing on the new value.
		ewmaClosure_SL = function (initialValue, defaultAlpha)
			defaultAlpha = defaultAlpha or 0.1
			initialValue = initialValue or 0
			---@param newValue number new value to smooth
			---@param optAlpha number? if present, will overwrite the defaultAlpha permamently
			---@return number smoothed Output of the EWMA
			return function(newValue, optAlpha)
				defaultAlpha = optAlpha or defaultAlpha
				initialValue = (1 - defaultAlpha) * initialValue + defaultAlpha * newValue
				return initialValue
			end
		end,
		---@endsection

		---@section deltaClosure_SL
		---@param innitialValue number?
		---@return fun(newValue:number):number delta
		deltaClosure_SL = function (innitialValue)
			innitialValue = innitialValue or 0
			---@param newValue number
			---@return number delta
			return function(newValue)
				local delta = newValue - innitialValue
				innitialValue = newValue
				return delta
			end
		end,
		---@endsection

		---@section getPulseToToggleClosure_SL
		---Returns a function that will manage your pulse to toggle
		---@param initialState boolean? the initial state of the switch
		---@return function
		getPulseToToggleClosure_SL = function(initialState)
			---@param boolean boolean
			---@return boolean toggle
			return function(boolean)
				if boolean then
					initialState = not initialState
				end
				return initialState
			end
		end,
		---@endsection

		---@section getPushToPulseClosure_SL
		---Returns a function that will manage your push to pulse
		---@param initialState boolean? the initial state of the switch
		---@return function
		getPushToPulseClosure_SL = function(initialState)
			---@param boolean boolean
			---@return boolean pulse
			return function(boolean)
				local pulse = boolean and not initialState
				initialState = boolean
				return pulse
			end
		end,
		---@endsection

		---@section thresholdEx_SL
		---Returns true if x is within the exclusive range from min to max. i.e. min < x < max
		---@param x number
		---@param min number
		---@param max number
		---@return boolean
		thresholdEx_SL = function(x, min, max)
			return min<x and x<max
		end,
		---@endsection

		---@section thresholdInc_SL
		---Returns true if x is on the inclusive range from and including min to and including max. i.e. min ≤ x ≤ max
		---@param x number
		---@param min number
		---@param max number
		---@return boolean
		thresholdInc_SL = function(x, min, max)
			return min<=x and x<=max
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
			if math.abs(value) == 1/0 then
				return fixValue
			end
			return value
		end,
		---@endsection

		---@section checkInf_SL
		---@param value number
		---@return boolean
		checkInf_SL = function(value)
			return math.abs(value) == 1/0
		end,
		---@endsection

		---@section fixNanInfTo0_SL
		---Replaces NaN and ±inf with a 0.
		---@param value number value to correct
		---@return number corrected will be 0 if NaN or ±inf, otherwise the provided value
		fixNanInfTo0_SL = function(value)
			return (math.abs(value) == 1/0 or value ~= value) and 0 or value
		end,
		---@endsection

		---@section fixNanInfToAny_SL
		---Replaces NaN and ±inf with corresponding values.
		---@param value number value to correct
		---@param fixNanTo number a value to replace NaN with
		---@param fixInfTo number a value to replace Inf with
		---@param signedInfFixFlag any if truthy then fixInfTo will have the same sign as inf, otherwise is absolute
		---@return number corrected will be 0 if NaN or ±inf, otherwise the provided value
		fixNanInfToAny_SL = function(value, fixNanTo, fixInfTo, signedInfFixFlag)
			if math.abs(value) == 1/0 then
				value = signedInfFixFlag and value<0 and -fixInfTo or fixInfTo
			elseif value ~= value then
				value = fixNanTo
			end
			return value
		end,
		---@endsection

		---@section checkInfNan_SL
		---@param value number
		---@return boolean
		checkInfNan_SL = function(value)
			return math.abs(value) == 1/0 or value ~= value
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

		---@section remap_SL
		---Remaps a number from one range to another. It takes value assumed to be within input range and linearly maps it to a corresponding value in output range.
		---@param value number value to remap
		---@param fromLow number start of the input range
		---@param fromHigh number end of the input range
		---@param toLow number start of the output range
		---@param toHigh number end of the output range
		---@return number transformedValue in new range
		remap_SL = function(value, fromLow, fromHigh, toLow, toHigh)
			return fromLow + (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow)
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
			for key, copiedValue in pairs(tableIn) do
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
				for key,copiedValue in pairs(nested_table) do
					key = (type(key) == check) and (tables_list[key] or recursive(key, {}) ) or key
					output_table[key] = (type(copiedValue) == check) and (tables_list[copiedValue] or recursive(copiedValue, {}) ) or copiedValue
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

		---@section xoshiro256ss_SL
		---Very large and pretty advanced pseudoRNG. Is only marginally better than 64 bit xorshift, so consider using that instead. This however has extremely long period.
		---@param seed0 integer
		---@param seed1 integer
		---@param seed2 integer
		---@param seed3 integer
		---@return integer result
		---@return integer seed0
		---@return integer seed1
		---@return integer seed2
		---@return integer seed3
		xoshiro256ss_SL = function(seed0, seed1, seed2, seed3)
			--inlined roll
			local result, t = ( (seed1 * 5 << 7) | (seed1 * 5 >> 57) ) * 9, seed1 << 17
			seed2 = seed2 ~ seed0
			seed3 = seed3 ~ seed1
			seed1 = seed1 ~ seed2
			seed0 = seed0 ~ seed3
			seed2 = seed2 ~ t
			--inlined roll
			seed3 = (seed3 << 45) | (seed3 >> 19)
			return result, seed0, seed1, seed2, seed3
		end,
		---@endsection

		---@section createRngClosure_SL
		---Creates a random number generator closure. Uses xorShift64 masked to middle 32 bits.
		---@param seed integer?
		---@param boundLow number? default to 0
		---@param boundHigh number? default to 1
		---@param integerMode boolean?
		---@return fun():number
		createRngClosure_SL = function(seed, boundLow, boundHigh, integerMode)
			seed = seed or 1
			boundLow = boundLow or 0
			boundHigh = boundHigh or 1

			local xorShift64_SL, floor, mask, x = StormSL.xorShift64_SL, math.floor, 0xFFFFFFFF
			return function()
				seed = xorShift64_SL(seed)
				x = ( (seed >> 16) & mask) / mask
				x = boundLow + x *(boundHigh - boundLow)
				return integerMode and floor( x + 0.5) or x
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
			local xorShiftSL, floor, mask, x = StormSL.xorShift64_SL, math.floor, 4294967295
			return {
				seed = seed or 1,
				boundLow = boundLow or 0,
				boundHigh = boundHigh or 1,
				integerMode = integerMode,
				generate = function(self)
					self.seed = xorShiftSL(self.seed)
					x = ( (self.seed >> 16) & mask) / mask
					x = self.boundLow + x *(self.boundHigh - self.boundLow)
					return self.integerMode and floor(x + 0.5) or x
				end
			}
		end,
		---@endsection

		---@section getIntMask_SL
		---Will return an 64 bit integer mask of specified size and shifted left by specified amount.
		---@param maskBits integer the number of 1s in the mask
		---@param shift integer? optional argument to how many least signifact zeroes there should be
		---@return integer mask
		getIntMask_SL = function(maskBits, shift)
			maskBits = maskBits >= 64 and -1 or maskBits<54 and 2^maskBits-1 or 2^maskBits-1024
			--doubles will drop least significant 11 bits at extreme sizes, +1 because I'm paranoid
			return (maskBits | (maskBits >> 12) ) << (shift or 0)
		end,
		---@endsection

		---@section getNextPower2SignedInt_SL
		---will return an integer larger or equal in absolute value compared to input integer, and the output will be an exact power of 2 or 0
		---@param integer integer
		---@return integer power2
		getNextPower2SignedInt_SL = function(integer)
			local power = math.abs(integer) - 1
			power = power | (power >> 1)
			power = power | (power >> 2)
			power = power | (power >> 4)
			power = power | (power >> 8)
			power = power | (power >> 16)
			return integer == 0 and 0 or (integer < 0 and -1 or 1) * (power | (power >> 32) + 1)
		end,

		---@section getNextPower2UnsignedInt_SL
		---will return an integer larger or equal integer, and the output will be an exact power of 2. Returns -1 for negative inputs.
		---@param integer integer
		---@return integer power2
		getNextPower2UnsignedInt_SL = function(integer)
			integer = integer | (integer >> 1)
			integer = integer | (integer >> 2)
			integer = integer | (integer >> 4)
			integer = integer | (integer >> 8)
			integer = integer | (integer >> 16)
			return integer | (integer >> 32) + 1
		end,
		---@endsection

		---@section getPower2Float_SL
		---Will accept and return a floating point. Returns the next closest or equal power of two while maintaining the sign. May return an infinity for extremely large values. 
		---@param float number
		---@return number power2
		getPower2Float_SL = function(float)
			local binary = ('i8'):unpack( ('d'):pack(float) )
			local exponentAndSign, mantissa = binary >> 52, binary & 0xFFFFFFFFFFFFF
			--infinities and nans
			if exponentAndSign & 2047 == 2047 then
				return float
			end
			exponentAndSign = mantissa ~= 0 and exponentAndSign + 1 or exponentAndSign
			--extra parentheses to only return 1 value
			return ( ('d'):unpack( ('i8'):pack(exponentAndSign << 52) ) )
		end,
		---@endsection

		---@section getPower2Exponent_SL
		---Returns the rounded down exponent of a number, presumably floating point. It is in fact the exact exponent value of a floating point number.
		---@param float number
		---@return integer exponent
		getPower2Exponent_SL = function(float)
			return ( ( ('i8'):unpack( ('d'):pack(float) ) >> 52) & 2047) - 1023
		end,
		---@endsection

		---@section stringToWordTable_SL
		---Cuts the string into words based on whitespace and returns a table of strings.
		---@param string string
		---@return table
		stringToWordTable_SL = function(string)
			local outputTable = {}
			for word in string:gmatch('%g+') do
				table.insert(outputTable, word)
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
			for key,value in ipairs(inputs) do
				sum = sum + value
			end
			return sum / #inputs
		end,
		---@endsection

		---@section createStack_SL 1 STORMSL_STACK_CLASS
		---Creates an object storing everything directly. The result has to be used with method calls.
		---@return table stack
		createStack_SL = function()
			return {
				_n = 0,

				---@section push_SL
				---Will push the value onto the top of the stack
				---@param stack table
				---@param value any
				push_SL = function(stack, value)
					stack._n = stack._n + 1
					stack[stack._n] = value
				end,

				---@section pop_SL
				---Will pop off the stack and return the value there if it's not empty
				---@param stack table
				---@return any
				pop_SL = function(stack)
					local n, value = stack._n
					if n > 0 then
						value = stack[n]
						stack._n = n - 1
						return value
					end
				end,
				---@endsection 

				---@section size_SL
				---Returns the size of the stack
				---@param stack table
				---@return integer
				size_SL = function(stack)
					return stack._n
				end,
				---@endsection 

				---@section read_SL
				---Will read a position down from the top of the stack. Optional removal
				---@param stack table
				---@param position integer
				---@param remove boolean? If true will remove the position from the stack, making it not stack like but you do you
				---@return any
				read_SL = function(stack, position, remove)
					local n, value = stack._n
					if n > 0 then
						value = stack[n - position]
						if remove then
							table.remove(stack, n - position)
							stack.n = n - 1
						end
					end
					return value
				end,
				---@endsection 

				---@section write_SL
				---Will write the value a position down from the top of the stack. Optional insert, pushing everything on top of it up, making it not stack-like
				---@param stack table
				---@param position integer
				---@param value any
				---@param insert boolean?
				write_SL = function(stack, position, value, insert)
					if insert then
						table.insert(stack, stack._n - position, value)
						stack._n = stack._n + 1
					else
						stack[stack._n - position] = value
					end
				end
				---@endsection 
			}
		end,
		---@endsection STORMSL_STACK_CLASS

		---@section createStackUpval_SL 1 STORMSL_UPVALSTACK_CLASS
		---Creates an object with functions referencing an upvalue stack, instead of storing everything directly. The result can't be used with method functions.
		---@return table stack
		createStackUpval_SL = function()
			local stack, n = {}, 0
			return {
				---@section push_SL
				---Will push the value onto the top of the stack
				---@param value any
				push_SL = function(value)
					n = n + 1
					stack[n] = value
				end,

				---@section pop_SL
				---Will pop off the stack and return the value there if it's not empty
				---@return any
				pop_SL = function()
					if n > 0 then
						n = n - 1
						return stack[n + 1]
					end
				end,
				---@endsection 

				---@section size_SL
				---Returns the size of the stack
				---@return integer
				size_SL = function()
					return n
				end,
				---@endsection 

				---@section read_SL
				---Will read a position down from the top of the stack. Optional removal
				---@param position integer
				---@param remove boolean? If true will remove the position from the stack, making it not stack like but you do you
				---@return any
				read_SL = function(position, remove)
					local ret = stack[n - position]
					if remove then
						table.remove(stack, n-position)
					end
					return ret
				end,
				---@endsection 

				---@section write_SL
				---Will write the value a position down from the top of the stack. Optional insert, pushing everything on top of it up, making it not stack-like
				---@param position integer
				---@param value any
				---@param insert boolean?
				write_SL = function(position, value, insert)
					if insert then
						table.insert(stack, n - position, value)
						n = n + 1
					else
						stack[n - position] = value
					end
				end
				---@endsection 
			}
		end,
		---@endsection STORMSL_UPVALSTACK_CLASS

	}

	--again using upvalues for internal speedups as those end up being upvalues
	--build require is a copypaste, hence it works as VectorSL will be able to access itself for example
	require('Modules.Vectors')
	require('Modules.Matrices')
	require('Modules.Bitformatting')
	require('Modules.Control')
	require('Modules.Anim')
	require('Modules.Compression')
	require('Modules.Debug')
end
--speeds up every access while in game as it's an upvalue of both onTick and onDraw
--it's declared after global declaration so that there is also a reference in the _ENV table
local StormSL = StormSL

---@endsection _STORM_SL_CLASS
