---@section Anim 2 STORMSL_ANIM_CLASS
---@class Anim
---@field animator_SL fun(duration: number, start: number, finish: number, easingFn: fun(progress: number): number): fun(driveForward: boolean, ticksPassed: integer?): number
---@field driver_SL fun(ticksDuration: integer): fun(driveForward: boolean, ticksPassed: integer?): number
---@field easeInCirc_SL fun(progress: number): number
---@field easeOutCirc_SL fun(progress: number): number
---@field easeInOutCirc_SL fun(progress: number): number
---Simple, useful, animation related functions.
Anim = {

	---@section animator_SL
	---@param duration number Ticks the anim takes to go between start and finish.
	---@param start number Start value of the animation.
	---@param finish number End value of the animation.
	---@param easingFn fun(progress: number): number Easing function to use. For example easeInCirc_SL or easeOutCirc_SL.
	animator_SL=function(duration, start, finish, easingFn)
		local driver = Anim.driver_SL(duration)
		---@param driveForward boolean Will advance toward `finish` if true, otherwise toward `start`.
		---@param ticksPassed integer|nil Optional number of ticks to advance. Defaults to 1.
		---@return number
		return function(driveForward, ticksPassed)
			return StormSL.remap_SL(
				easingFn(driver(driveForward, ticksPassed)),
				0,1,
				start,finish)
		end
	end,
	---@endsection

	---@section driver_SL
	---Returns an instance that can be called every tick for example to drive an animation. Return of instance is in the [0,1] range.
	---@param ticksDuration integer
	driver_SL=function(ticksDuration)
		local currently = 0
		---@param driveForward boolean
		---@param ticksPassed integer|nil
		---@return number progressNorm
		return function(driveForward, ticksPassed)
			if driveForward then
				currently = math.min(currently + (ticksPassed or 1), ticksDuration)
			else
				currently = math.max(currently - (ticksPassed or 1), 0)
			end
			return currently/ticksDuration
		end
	end,
	---@endsection
	
	---@section easeInCirc_SL
	---@param progress number Must be in [0,1] range.
	---@return number
	easeInCirc_SL=function(progress)
		return 1 - math.sqrt(1 - progress^2);
	end,
	---@endsection
	
	---@section easeOutCirc_SL
	---@param progress number Must be in [0,1] range.
	---@return number
	easeOutCirc_SL=function(progress)
		return math.sqrt(1 - (progress - 1)^2);
	end,
	---@endsection
	
	---@section easeInOutCirc_SL
	---@param progress number Must be in [0,1] range.
	---@return number
	easeInOutCirc_SL=function(progress)
		if progress < 0.5 then
			return (1 - math.sqrt(1 - (2 * progress)^2)) / 2
		else
			return (math.sqrt(1 - (-2 * progress + 2)^2) + 1) / 2
		end
	end,
	---@endsection
	
}

StormSL.Anim = Anim
---@endsection STORMSL_ANIM_CLASS