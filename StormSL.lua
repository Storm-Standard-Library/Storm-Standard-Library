--version 0.0.0

---@section StormSL 1 _STORM_SL_CLASS_
---@class StormSL
---@field versionSL string
---The standard library for Stormworks Lua.
StormSL = {
	---@section versionSL
	versionSL='0.0.0',
	---@endsection

	---@section clampSL
	---@param minimum number
	---@param maximum number
	---@param value number
	---@return number
	clampSP = function(minimum, maximum, value)
		return value > maximum and maximum or value < minimum and minimum or value
	end,
	---@endsection
}

--speeds up every access while in game as it's an upvalue of both onTick and onDraw
--it's declared after global declaration so that there is also a reference in the _ENV table
local StormSL = StormSL
do
	local VectorSL, matrixSL	--again using upvalues for internal speedups as those end up being upvalues
	require('VectorSL')
	require('MatrixSL')
end

---@endsection _STORM_SL_CLASS