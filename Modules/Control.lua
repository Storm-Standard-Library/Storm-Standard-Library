

---@section __LB_SIMULATOR_ONLY_STORMSL_CONTROL_START__
do
	local StormSL, math_SL = StormSL, math
	---@endsection
	
	---@section Control 1 STORMSL_CONTROL_CLASS
	---@class Control
	---@field bangBangClosure fun(minOutput: number, maxOutput: number): fun(setpoint: number, processVar: number): number
	---@field bangBangClass fun(minOutput: number, maxOutput: number): bangBangClassInstance
	---@field PClosure fun(kp: number): fun(setpoint: number, processVar: number): number
	---@field PClass fun(kp: number): PClassInstance
	---@field IClosure fun(ki: number, lowerIntegralClamp: number, upperIntegralClamp: number, optIntegralOvershootZeroing: boolean|nil): fun(setpoint: number, processVar: number): number
	---@field IClass fun(ki: number, lowerIntegralClamp: number, upperIntegralClamp: number, optIntegralOvershootZeroing: boolean|nil): IClassInstance
	---@field PDClosure fun(kp: number, kd: number): fun(setpoint: number, processVar: number): number
	---@field PDClass fun(kp: number, kd: number): PDClassInstance
	---@field simplePIClosure fun(kp: number, ki: number, lowerIntegralClamp: number, upperIntegralClamp: number): fun(setpoint: number, processVar: number): number
	---@field advancedPIClosure fun(kp: number, ki: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): fun(setpoint: number, processVar: number): number
	---@field simplePIClass fun(kp: number, ki: number, lowerIntegralClamp: number, upperIntegralClamp: number): simplePIClassInstance
	---@field advancedPIClass fun(kp: number, ki: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): advancedPIClassInstance
	---@field simpleIDClosure fun(ki: number, kd: number, lowerIntegralClamp: number, upperIntegralClamp: number): fun(setpoint: number, processVar: number): number
	---@field advancedIDClosure fun(ki: number, kd: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): fun(setpoint: number, processVar: number): number
	---@field simpleIDClass fun(ki: number, kd: number, lowerIntegralClamp: number, upperIntegralClamp: number): simpleIDClassInstance
	---@field advancedIDClass fun(ki: number, kd: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): advancedIDClassInstance
	---@field simplePIDClosure fun(kp: number, ki: number, kd: number, lowerIntegralClamp: number, upperIntegralClamp: number): fun(setpoint: number, processVar: number): number
	---@field advancedPIDClosure fun(kp: number, ki: number, kd: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): fun(setpoint: number, processVar: number): number
	---@field simplePIDClass fun(kp: number, ki: number, kd: number, lowerIntegralClamp: number, upperIntegralClamp: number): simplePIDClassInstance
	---@field advancedPIDClass fun(kp: number, ki: number, kd: number, lowerBackCalcSatLimit: number, upperBackCalcSatLimit: number, optIntegralOvershootZeroing: boolean|nil): advancedPIDClassInstance
	---Essential Stormworks feedback control algorithms.
	Control = {


		---@section bangBangClosure
		---A simple bang-bang controller, implemented as a closure.
		---@param minOutput number The value to output when processVar is below setpoint
		---@param maxOutput number The value to output when processVar is above setpoint
		---@return fun(setpoint:number, processVar:number): number
		bangBangClosure = function(minOutput,maxOutput)
			return function(setpoint,processVar) return processVar < setpoint and maxOutput or minOutput end
		end,
		---@endsection

		---@section bangBangClass
		
		---@class bangBangClassInstance
		---@field minOutput number
		---@field maxOutput number
		---@field run fun(setpoint:number, processVar:number): number

		---A simple bang-bang controller, implemented as a closure.
		---@param minOutput number The value to output when processVar is below setpoint
		---@param maxOutput number The value to output when processVar is above setpoint
		---@return bangBangClassInstance
		bangBangClass = function(minOutput,maxOutput)
			return {
				minOutput=minOutput,
				maxOutput=maxOutput,
				run=function(self,setpoint,processVar) return processVar < setpoint and self.maxOutput or self.minOutput end,
			}
		end,
		---@endsection




		---@section PCLosure
		---A P-controller, implemented as a closure.
		---@param kp number Tuned P-constant
		---@return fun(setpoint:number, processVar:number): number
		PClosure = function(kp)
			return function(setpoint, processVar) return (setpoint-processVar)*kp end
		end,
		---@endsection 

		---@section PClass
		
		---@class PClassInstance
		---@field kp number
		---@field run fun(self: PClassInstance, setpoint:number, processVar:number): number
		
		---A P-controller, implemented as a class.
		---@param kp number Tuned P-constant
		---@return PClassInstance
		PClass = function(kp)
			return {
				kp = kp,
				run = function(self, setpoint, processVar)
					return (setpoint-processVar)*self.kp
				end
			}
				
		end,
		---@endsection




		---@section ICLosure
		---An I-controller with integral clamp and optional clegg integration, implemented as a closure.
		---@param ki number Tuned I-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return fun(setpoint:number, processVar:number): number
		IClosure = function(ki, lowerIntegralClamp, upperIntegralClamp, optIntegralOvershootZeroing)
			local integral, lastError = 0,0
			return function(setpoint, processVar)
				
				local error = setpoint-processVar
				integral = math_SL.min( math_SL.max(integral + error*ki, lowerIntegralClamp) , upperIntegralClamp)

				if optIntegralOvershootZeroing and lastError*error>=0 then
					integral = 0
				end

				lastError = error
				return integral
			end
		end,
		---@endsection 

		---@section IClass

		---@class IClassInstance
		---@field ki number
		---@field lowerIntegralClamp number
		---@field upperIntegralClamp number
		---@field optIntegralOvershootZeroing boolean|nil
		---@field integral number
		---@field lastError number
		---@field run fun(self: IClassInstance, setpoint:number, processVar:number): number

		---An I-controller with integral clamp and clegg integration, implemented as a class.
		---@param ki number Tuned I-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return IClassInstance
		IClass = function(ki,lowerIntegralClamp,upperIntegralClamp,optIntegralOvershootZeroing)
			return {
				ki = ki,
				lowerIntegralClamp = lowerIntegralClamp,
				upperIntegralClamp = upperIntegralClamp,
				optIntegralOvershootZeroing = optIntegralOvershootZeroing,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error = setpoint-processVar
					self.integral = math_SL.min( math_SL.max(self.integral + error*self.ki, self.lowerIntegralClamp) , self.upperIntegralClamp)
	
					if self.optIntegralOvershootZeroing and self.lastError*error>=0 then
						self.integral = 0
					end
					self.lastError = error
	
					return self.integral
				end
			}
				
		end,
		---@endsection




		---@section PDCLosure
		---A PD-controller, implemented as a closure.
		---@param kp number Tuned P-constant
		---@param kd number Tuned D-constant
		---@return fun(setpoint:number, processVar:number): number
		PDClosure = function(kp,kd)
			local errorPrior = 0
			return function(setpoint, processVar)
				local error, deltaPreMul = setpoint-processVar,0
				deltaPreMul = error-errorPrior
				errorPrior = error
				return error*kp + deltaPreMul*kd
			end
		end,
		---@endsection

		---@section PDClass
		
		---@class PDClassInstance
		---@field kp number
		---@field kd number
		---@field errorPrior number
		---@field run fun(self: PDClassInstance, setpoint:number, processVar:number): number
		
		---A PD-controller, implemented as a class.
		---@param kp number Tuned P-constant
		---@param kd number Tuned D-constant
		---@return PDClassInstance
		PDClass = function(kp,kd)
			return {
				kp = kp,
				kd = kd,
				errorPrior = 0,
				run = function(self, setpoint, processVar)
					local error, deltaPreMul = setpoint-processVar,0
					deltaPreMul = error - self.errorPrior
					self.errorPrior = error
					return error*kp + deltaPreMul*kd
				end
			}
				
		end,
		---@endsection




		---@section simplePIClosure
		---A PI-controller with integral clamp, implemented as a closure.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return fun(setpoint:number, processVar:number): number
		simplePIClosure = function(kp, ki, lowerIntegralClamp, upperIntegralClamp)
			local integral = 0
			return function(setpoint, processVar)
				
				local error = setpoint-processVar
				integral = math_SL.min( math_SL.max(integral + error*ki, lowerIntegralClamp) , upperIntegralClamp)

				return error*kp + integral
			end
		end,
		---@endsection
		
		---@section advancedPIClosure
		---A PI-controller with clegg integration and back calculation anti integral windup, implemented as a closure.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return fun(setpoint:number, processVar:number): number
		advancedPIClosure = function(kp, ki, lowerBackCalcSatLimit, upperBackCalcSatLimit, optIntegralOvershootZeroing)
			local integral, lastError = 0,0
			return function(setpoint, processVar)
				
				local error,proportional = setpoint-processVar,0
				proportional = error*kp
				integral = integral + error*ki

				local unsaturated = proportional + integral
				local saturated = math_SL.min( math_SL.max(unsaturated, lowerBackCalcSatLimit) , upperBackCalcSatLimit)
				local anti_windup_correction = saturated - unsaturated
				integral = integral - anti_windup_correction

				if optIntegralOvershootZeroing and lastError*error<=0 then
					integral = 0
				end
				lastError = error

				return proportional + integral
			end
		end,
		---@endsection

		---@section simplePIClass

		---@class simplePIClassInstance
		---@field kp number
		---@field ki number
		---@field lowerIntegralClamp number
		---@field upperIntegralClamp number
		---@field integral number
		---@field run fun(self: simplePIClassInstance, setpoint:number, processVar:number): number

		---A PI-controller with integral clamp, implemented as a class.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return simplePIClassInstance
		simplePIClass = function(kp, ki,lowerIntegralClamp,upperIntegralClamp)
			return {
				kp = kp,
				ki = ki,
				lowerIntegralClamp = lowerIntegralClamp,
				upperIntegralClamp = upperIntegralClamp,
				integral = 0,
				run = function(self, setpoint, processVar)
					local error = setpoint-processVar
					self.integral = math_SL.min( math_SL.max(self.integral + error*self.ki, self.lowerIntegralClamp) , self.upperIntegralClamp)
	
					return self.integral
				end
			}
				
		end,
		---@endsection
		
		---@section advancedPIClass

		---@class advancedPIClassInstance
		---@field kp number
		---@field ki number
		---@field lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@field upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@field optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@field integral number
		---@field lastError number
		---@field run fun(self: advancedPIClassInstance, setpoint:number, processVar:number): number

		---A PI-controller with clegg integration and back calculation anti integral windup, implemented as a class.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return advancedPIClassInstance
		advancedPIClass = function(kp, ki,lowerBackCalcSatLimit,upperBackCalcSatLimit,optIntegralOvershootZeroing)
			return {
				kp = kp,
				ki = ki,
				lowerBackCalcSatLimit = lowerBackCalcSatLimit,
				upperBackCalcSatLimit = upperBackCalcSatLimit,
				optIntegralOvershootZeroing = optIntegralOvershootZeroing,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error,proportional = setpoint-processVar,0
					proportional = error*self.kp
					self.integral = self.integral + error*self.ki
					
					local unsaturated = proportional + self.integral
					local saturated = math_SL.min(math_SL.max(unsaturated,lowerBackCalcSatLimit),upperBackCalcSatLimit)
					local anti_windup_correction = saturated - unsaturated
					self.integral = self.integral - anti_windup_correction

					if optIntegralOvershootZeroing and self.lastError*error<0 then
						self.integral = 0
					end
					self.lastError = error

					return proportional + self.integral
				end
			}
				
		end,
		---@endsection




		---@section simpleIDClosure
		---An ID-controller with integral clamp, implemented as a closure.
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return fun(setpoint:number, processVar:number): number
		simpleIDClosure = function(ki, kd, lowerIntegralClamp, upperIntegralClamp)
			local integral = 0
			local lastError = 0
			return function(setpoint, processVar)

				local error,derivative = setpoint-processVar,0
				integral = math_SL.min( math_SL.max(integral + error*ki, lowerIntegralClamp) , upperIntegralClamp)
				derivative = error - lastError
				lastError = error

				return integral + derivative*kd
			end
		end,
		---@endsection
		
		---@section advancedIDClosure
		---An ID-controller with clegg integration and back calculation anti integral windup, implemented as a closure.
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return fun(setpoint:number, processVar:number): number
		advancedIDClosure = function(ki, kd, lowerBackCalcSatLimit, upperBackCalcSatLimit, optIntegralOvershootZeroing)
			local integral, lastError = 0,0
			return function(setpoint, processVar)
				
				local error,derivative = setpoint-processVar,0
				integral = integral + error*ki

				derivative = (error - lastError)*kd

				local unsaturated = derivative + integral
				local saturated = math_SL.min( math_SL.max(unsaturated, lowerBackCalcSatLimit) , upperBackCalcSatLimit)
				local anti_windup_correction = saturated - unsaturated
				integral = integral - anti_windup_correction

				if optIntegralOvershootZeroing and lastError*error<=0 then
					integral = 0
				end
				lastError = error

				return derivative + integral
			end
		end,
		---@endsection

		---@section simpleIDClass

		---@class simpleIDClassInstance
		---@field ki number
		---@field kd number
		---@field lowerIntegralClamp number
		---@field upperIntegralClamp number
		---@field integral number
		---@field lastError number
		---@field run fun(self: simpleIDClassInstance, setpoint:number, processVar:number): number

		---An ID-controller with integral clamp, implemented as a class.
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return simpleIDClassInstance
		simpleIDClass = function(ki, kd,lowerIntegralClamp,upperIntegralClamp)
			return {
				ki = ki,
				kd = kd,
				lowerIntegralClamp = lowerIntegralClamp,
				upperIntegralClamp = upperIntegralClamp,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error,derivative = setpoint-processVar,0
					self.integral = math_SL.min( math_SL.max(self.integral + error*self.ki, self.lowerIntegralClamp) , self.upperIntegralClamp)
					derivative = error - self.lastError
					self.lastError = error
					
					return self.integral + derivative*kd
				end
			}
				
		end,
		---@endsection
		
		---@section advancedIDClass

		---@class advancedIDClassInstance
		---@field ki number
		---@field kd number
		---@field lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@field upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@field optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@field integral number
		---@field lastError number
		---@field run fun(self: advancedIDClassInstance, setpoint:number, processVar:number): number

		---An ID-controller with clegg integration and back calculation anti integral windup, implemented as a class.
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return advancedIDClassInstance
		advancedIDClass = function(ki, kd,lowerBackCalcSatLimit,upperBackCalcSatLimit,optIntegralOvershootZeroing)
			return {
				ki = ki,
				kd = kd,
				lowerBackCalcSatLimit = lowerBackCalcSatLimit,
				upperBackCalcSatLimit = upperBackCalcSatLimit,
				optIntegralOvershootZeroing = optIntegralOvershootZeroing,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error,derivative = setpoint-processVar,0
					self.integral = self.integral + error*self.ki
					derivative = (error - self.lastError)*kd

					local unsaturated = self.integral + derivative
					local saturated = math_SL.min(math_SL.max(unsaturated,lowerBackCalcSatLimit),upperBackCalcSatLimit)
					local anti_windup_correction = saturated - unsaturated
					self.integral = self.integral - anti_windup_correction

					if optIntegralOvershootZeroing and self.lastError*error<0 then
						self.integral = 0
					end
					self.lastError = error

					return self.integral + derivative
				end
			}
				
		end,
		---@endsection




		---@section simplePIDClosure
		---A PID-controller with integral clamp, implemented as a closure.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return fun(setpoint:number, processVar:number): number
		simplePIDClosure = function(kp, ki, kd, lowerIntegralClamp, upperIntegralClamp)
			local integral = 0
			local lastError = 0
			return function(setpoint, processVar)
				
				local error,proportional,derivative = setpoint-processVar,0,0

				proportional = error*kp
				integral = math_SL.min( math_SL.max(integral + error*ki, lowerIntegralClamp) , upperIntegralClamp)
				derivative = error - lastError
				
				lastError = error

				return proportional + integral + derivative*kd
			end
		end,
		---@endsection
		
		---@section advancedPIDClosure
		---A PID-controller with clegg integration and back calculation anti integral windup, implemented as a closure.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return fun(setpoint:number, processVar:number): number
		advancedPIDClosure = function(kp, ki, kd, lowerBackCalcSatLimit, upperBackCalcSatLimit, optIntegralOvershootZeroing)
			local integral, lastError = 0,0
			return function(setpoint, processVar)
				
				local error,proportional,derivative = setpoint-processVar,0,0
				proportional = error*kp
				integral = integral + error*ki

				derivative = (error - lastError)*kd

				local unsaturated = proportional + integral + derivative
				local saturated = math_SL.min( math_SL.max(unsaturated, lowerBackCalcSatLimit) , upperBackCalcSatLimit)
				local anti_windup_correction = saturated - unsaturated
				integral = integral - anti_windup_correction

				if optIntegralOvershootZeroing and lastError*error<=0 then
					integral = 0
				end
				lastError = error

				return proportional + integral + derivative
			end
		end,
		---@endsection

		---@section simplePIDClass

		---@class simplePIDClassInstance
		---@field kp number
		---@field ki number
		---@field kd number
		---@field lowerIntegralClamp number
		---@field upperIntegralClamp number
		---@field integral number
		---@field lastError number
		---@field run fun(self: simplePIDClassInstance, setpoint:number, processVar:number): number

		---An ID-controller with integral clamp, implemented as a class.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerIntegralClamp number Total integral will never go below max(integral,lowerIntegralClamp). To not use, set to -inf (-1/0)
		---@param upperIntegralClamp number Total integral will never exceed min(integral,upperIntegralClamp). To not use, set to inf (1/0)
		---@return simplePIDClassInstance
		simplePIDClass = function(kp, ki, kd,lowerIntegralClamp,upperIntegralClamp)
			return {
				kp = kp,
				ki = ki,
				kd = kd,
				lowerIntegralClamp = lowerIntegralClamp,
				upperIntegralClamp = upperIntegralClamp,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error,proportional,derivative = setpoint-processVar,0,0
					
					proportional = error*kp
					self.integral = math_SL.min( math_SL.max(self.integral + error*self.ki, self.lowerIntegralClamp) , self.upperIntegralClamp)
					derivative = error - self.lastError

					self.lastError = error
					
					return proportional + self.integral + derivative*kd
				end
			}
				
		end,
		---@endsection
		
		---@section advancedPIDClass

		---@class advancedPIDClassInstance
		---@field kp number
		---@field ki number
		---@field kd number
		---@field lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@field upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@field optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@field integral number
		---@field lastError number
		---@field run fun(self: advancedPIDClassInstance, setpoint:number, processVar:number): number

		---An ID-controller with clegg integration and back calculation anti integral windup, implemented as a class.
		---@param kp number Tuned P-constant
		---@param ki number Tuned I-constant
		---@param kd number Tuned D-constant
		---@param lowerBackCalcSatLimit number This number should be the lower saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. a velocity pivot's lower saturation limit is -1.
		---@param upperBackCalcSatLimit number This number should be the upper saturation limit for your actuator, and will be used to unwind integral using back-calculation. I.e. both of the axes on the missile fin have an upper saturation limit of 10.
		---@param optIntegralOvershootZeroing boolean|nil If set to true, integral will get set to 0 when processVar moves across the setpoint. (clegg integration)
		---@return advancedPIDClassInstance
		advancedPIDClass = function(kp, ki, kd,lowerBackCalcSatLimit,upperBackCalcSatLimit,optIntegralOvershootZeroing)
			return {
				kp = kp,
				ki = ki,
				kd = kd,
				lowerBackCalcSatLimit = lowerBackCalcSatLimit,
				upperBackCalcSatLimit = upperBackCalcSatLimit,
				optIntegralOvershootZeroing = optIntegralOvershootZeroing,
				integral = 0,
				lastError = 0,
				run = function(self, setpoint, processVar)
					local error,proportional,derivative = setpoint-processVar,0,0
					proportional = error*kp
					self.integral = self.integral + error*self.ki
					derivative = (error - self.lastError)*kd

					local unsaturated = proportional + self.integral + derivative
					local saturated = math_SL.min(math_SL.max(unsaturated,lowerBackCalcSatLimit),upperBackCalcSatLimit)
					local anti_windup_correction = saturated - unsaturated
					self.integral = self.integral - anti_windup_correction

					if optIntegralOvershootZeroing and self.lastError*error<0 then
						self.integral = 0
					end
					self.lastError = error

					return proportional + self.integral + derivative
				end
			}
				
		end,
		---@endsection
		

	}
	
	StormSL.Control = Control
	---@endsection STORMSL_CONTROL_CLASS

	---@section __LB_SIMULATOR_ONLY_STORMSL_CONTROL_END__
end
---@endsection