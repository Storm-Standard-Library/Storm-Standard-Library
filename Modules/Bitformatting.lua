
---@section Bitformatting 2 STORMSL_BITFORMATTING_CLASS
---@class Bitformatting
---@field uint32ToChannel_SL fun(channel:integer,uint32:integer):nil
---@field channelToUint32_SL fun(channel:integer):integer
---@field fourBytesToChannel_SL fun(channel:integer,byte0:integer,byte1:integer,byte2:integer,byte3:integer):nil
---@field channelToFourBytes_SL fun(channel:integer):integer,integer,integer,integer
---@field floatToInt_SL fun(float:number,bits:integer,custom_exponentBits:integer?,custom_shift:integer?,custom_unsigned:boolean?,custom_forceDouble:boolean?,custom_disableDouble:boolean?,custom_roundAwayFrom0:boolean?,custom_roundToward0:boolean?):integer
---@field intToFloat_SL fun(int:integer,bits:integer,custom_exponentBits:integer?,custom_shift:integer?,custom_unsigned:boolean?,custom_forceDouble:boolean?,custom_disableDouble:boolean?):number
---@field fixedTableEncode_SL fun(int:integer,bits:integer,count:integer,outputTable:table?):table
---@field fixedTableDecode_SL fun(tab:table,bits:integer,count:integer,index:integer?):integer,integer
---@field variableTableEncode_SL fun(int:integer,bits:integer,out:table?):table
---@field variableTableDecode_SL fun(tab:table,bits:integer,index:integer?):integer,integer
---@field sixBitTableToString_SL fun(tab:table,startIndex:integer?,endIndex:integer?):string
---@field stringToSixBitTable_SL fun(str:string,startChar:integer?,endChar:integer?):table
---@field transcribeTableBits_SL fun(tab:table,bitsIn:integer,bitsOut:integer,totalOutputValues:integer?,index:integer?):table
---Encoding and decoding between numbers of different sizes, tables [, and strings]
Bitformatting = {
	---@section uint32ToChannel_SL
	---Sends 32 bit unsigned integer through stormworks composite number and boolean
	---@param channel integer channel trough which the data is sent
	---@param uint32 integer 32 bit unsigned integer to encode and send over composite
	uint32ToChannel_SL=function(channel, uint32)
		--[[
		1 11111110 11111111111111111111111
		l lllllllp rrrrrrrrrrrrrrrrrrrrrrr
		right has all the mantissa
		left has sign and 7 bits of of exponent
		bool has the 8th bit (reading from left) of the exponent
		parity can be used to fix something like a broken subnormal or -0 if these happen to cause issues
		so far I have not seen any issues so I've simplified to the bare minimum
		]]
		output.setNumber(channel, ( ('f'):unpack( ('I'):pack((uint32 & 0xFF000000) | (uint32 & 0x7FFFFF)) ) ))
		output.setBool(channel, uint32 & 0x800000 ~= 0)
	end,
	---@endsection

	---@section channelToUint32_SL
	---Receives 32 bit unsigned integer from stormworks composite number and boolean
	---@param channel integer channel from which to read the data
	---@return decoded integer
	channelToUint32_SL=function(channel)
		return ( ('I'):unpack( ('f'):pack(input.getNumber(channel)) ) ) | (input.getBool(channel) and 0x800000 or 0)
	end,
	---@endsection

	---@section fourBytesToChannel_SL
	---Sends 4 bytes through stormworks composite number and boolean
	---@param channel integer channel trough which the data is sent
	---@param byte0 integer
	---@param byte1 integer
	---@param byte2 integer
	---@param byte3 integer
	fourBytesToChannel_SL = function(channel, byte0, byte1, byte2, byte3)
		local uint32 = byte0 | (byte1 << 8) | (byte2 << 16) | (byte3 << 24)
		output.setNumber(channel, ( ('f'):unpack( ('I'):pack((uint32 & 0xFF000000) | (uint32 & 0x7FFFFF)) ) ))
		output.setBool(channel, uint32 & 0x800000 ~= 0)
	end,
	---@endsection

	---@section channelToFourBytes_SL
	---Receives 4 bytes from stormworks composite number and boolean
	---@param channel integer channel from which to read the data
	---@return integer byte0
	---@return integer byte1
	---@return integer byte2
	---@return integer byte3
	channelToFourBytes_SL = function(channel)
		local uint32 = ( ('I'):unpack( ('f'):pack(input.getNumber(channel)) ) ) | (input.getBool(channel) and 0x800000 or 0)
		return uint32 & 255, (uint32 >> 8) & 255,  (uint32 >> 16) & 255,  (uint32 >> 24) & 255
	end,
	---@endsection

	---@section floatToInt_SL
	---Has subnormals but deliberately skips infs and nans, variable shift and exp bits, can toggle off sign bit or use enforce classic conversion. Check source and comments for notable bit sizes.
	---@param float number float to store in an int
	---@param bits integer amount of bits used by the float format, mini - 8, half - 16, float - 32, double - 64 and anything inbetween
	---@param custom_exponentBits integer? optional - sets the amount of bits used by exponent, can be used to force a certain range regardless of standard formats (allows bfloat, tensorfloat)
	---@param custom_shift integer? optional - overrules the halfshift of floats to shift the range towards more low end precision or larger numbers
	---@param custom_unsigned boolean? optional - flag to use unsigned format, extra bit goes to mantissa, messes up everything, don't use unless you know what you're doing
	---@param custom_forceDouble boolean? optional - flag to always use lua string pack unpack to convert numbers
	---@param custom_disableDouble boolean? optional - flag to disable automatic lua string pack unpack conversion when there's more than 42 bits
	---@param custom_roundAwayFrom0 boolean? optional - flag to round away from 0 when can't represent exactly, is dominant over rounding toward 0
	---@param custom_roundToward0 boolean? optional - flag to round toward 0 when can't represent exactly
	---@return integer
	floatToInt_SL=function(
			float,
			bits,
			custom_exponentBits,
			custom_shift,
			custom_unsigned,
			custom_forceDouble,
			custom_disableDouble,
			custom_roundAwayFrom0,
			custom_roundToward0
		)
		--[[
		according to my (brute force) testing float32 is fully representible
		(with the exception of NaNs and infs)
		I remember seeing issues when mantissa was getting up to around 40 bits however
		probably numerical instability in lua double
		hence for sizes above 42 when mantissa would grow beyond 32 bits (plenty of safe space)
		it defaults to string pack upack using doubles
		also at that point the exponent is already 10 bits, just 1 shy of double's 11 so why not

		notable sizes for bytes assuming default settings:
			8 - minifloat	4 bit exp, 3 bit mant, largest num 480
			16 - half 		5 bit exp, 10 bit mant, largest num 131008
			24 - pixar fp24	8 bit exp, 15 bit mant, largest num 6.8e+34, range of fp32 and precision of uint16 (unsigned short)
			32 - float		8 bit exp, 23 bit mant, largest num 6.805e+38 (twice the range of normal float because no inf/nan)
			40 - no format	9 bit exp, 30 bit mant, largest num 2.315e+77 full precision of signed int32 and increased range
			43 and above defaults to 11 bit exp using lua double format (truncated mantissa)
		notable sizes for char usage (multiples of 6)
			6	-	4 bit exp,	1 bit mant, largest num 384, very very bad precision
			12	-	5 bit exp,	6 bit mant, largest num 130048
			18	-	6 bit exp,	11 bit mant, largest num 8587837440
			24	-	pixar fp24	8 bit exp, 15 bit mant, largest num 6.8e+34, range of fp32 and precision of uint16 (unsigned short)
			30	-	8 bit exp,	21 bit mant, largest num 6.805e+38
			36	-	9 bit exp,	26 bit mant, largest num 2.315e+77
			42	-	10 bit exp,	31 bit mant, largest num 2.681e+154 full uint32 precision
			any size mentioned here -1 has one less bit for exponent with the same mantissa, having same precision but decreased range
			43 and above defaults to 11 bit exp using lua double format (truncated mantissa)
		]]
		local expBits,mantissa,floor,clamp,mantissaBits,maxMantissa,expLow,expHigh,expShift,expRepresentation,expValue,int=custom_exponentBits or bits==24 and 8 or (3+bits//6),math.abs(float),math.floor,StormSL.clamp_SL
		if not custom_disableDouble and bits>42 or custom_forceDouble then
			--is normal double but truncated mantissa
			return ('i8'):unpack( ('d'):pack(float) ) >> clamp(0, 64, 64 - bits)
		end

		--figure out the size of mantissa
		mantissaBits = bits - expBits - (custom_unsigned and 0 or 1)
		--mantissa can be this -1 but it's used as this for division
		maxMantissa = 2 ^ mantissaBits

		--default shift compliant with ieee
		expShift = custom_shift or 2 ^ (expBits - 1) - 1
		--max possible exponent is 2 ^ expbits - 1 and minus the shift
		expHigh = 2 ^ expBits - 1 - expShift
		--lowest possible exponent is at 0 minut the shift
		expLow = -expShift

		--quick and dirty approximation, log is however inaccurate
		expValue = floor( math.log(mantissa, 2) )
		--mantissa / 2 ^ exp should be between 1 and 2, so floored is 1, minus 1 is 0
		--that ensures that if log failed then it's corrected
		expValue = expValue + floor(mantissa / 2 ^ expValue) - 1
		--clamp to be in range
		expValue = clamp(expLow, expHigh, expValue)
		--and apply the shift, that's the exponent ready to be put in return
		expRepresentation = expValue + expShift

		--because of subnormals we have to ensure the divider is never the lowest possible representation
		--that's because the math is weird for subnormals, dunno how to explain
		mantissa = mantissa / 2 ^ math.max(expLow + 1, expValue)
		--at normal values the mantissa is 1.something but we only want the something so we subtract 1
		--at subnormals it's already 0.something so we have the something
		mantissa = expRepresentation == 0 and mantissa or mantissa - 1 --mantissa - math.min(expRepresentation, 1)
		--now that we have 0.something we can start encoding
		mantissa = mantissa * maxMantissa
		--rounding, default is closest
		mantissa = custom_roundAwayFrom0 and math.ceil(mantissa) or floor( mantissa + (custom_roundToward0 and 0 or 0.5) )
		--if value is out of range because minifloat for example, ensure it doesn't spill
		mantissa = math.min(maxMantissa - 1, mantissa)

		--join the exponent representation and mantissa
		int = (expRepresentation << mantissaBits) | mantissa
		--apply sign unless unsigned, float is not less than 0 or representation is 0, we don't want -0
		int = int | ( not custom_unsigned and float < 0 and int ~= 0 and 1 << (bits - 1) or 0 )

		return int
	end,
	---@endsection

	---@section intToFloat_SL
	---Has subnormals but deliberately skips infs and nans, variable shift and exp bits, can toggle off sign bit or use enforce classic conversion. Refer to float_To_Int for notable bit sizes.
	---@param int integer integer storing the float
	---@param bits integer amount of bits used by the float format, mini - 8, half - 16, float - 32, double - 64 and anything inbetween
	---@param custom_exponentBits integer? optional - sets the amount of bits used by exponent, can be used to force a certain range regardless of standard formats (allows bfloat, tensorfloat)
	---@param custom_shift integer? optional - overrules the halfshift of floats to shift the range towards more low end precision or larger numbers
	---@param custom_unsigned boolean? optional - flag to use unsigned format, extra bit goes to mantissa, messes up everything, don't use unless you know what you're doing
	---@param custom_forceDouble boolean? optional - flag to always use lua string pack unpack to convert numbers
	---@param custom_disableDouble boolean? optional - flag to disable automatic lua string pack unpack conversion when there's more than 42 bits
	---@return float
	intToFloat_SL=function(
			int,
			bits,
			custom_exponentBits,
			custom_shift,
			custom_unsigned,
			custom_forceDouble,
			custom_disableDouble
		)

		if not custom_disableDouble and bits>42 or custom_forceDouble then
			--is normal double but truncated mantissa
			--+0 ensures only one return
			return ( ('d'):unpack( ('i8'):pack(int << StormSL.clampS_SL(0, 64, 64 - bits)) ) )
		end
		local expBits,sign,check,mantissaBits=custom_exponentBits or bits==24 and 8 or (3+bits//6),custom_unsigned and 1 or (-1)^(int>>(bits-1)&1)
		mantissaBits = bits - expBits - (custom_unsigned and 0 or 1)
		local mantissa, exponent = int & (2 ^ mantissaBits - 1), (int >> mantissaBits) & (2 ^ expBits - 1) --not much to say it's just reading the representation
		check = exponent == 0 and 0 or 1 --that little bugger is for subnormals (and the damn 0)
		--when exponent representation is 0, the exponent is this-shift (-127 in case of float32)
		exponent = exponent - ( custom_shift or 2 ^ (expBits - 1) - 1 )--default to -127 shift for float32
		return sign * 2 ^ (exponent + 1 - check) * (check + mantissa / 2 ^ mantissaBits)
		--exponent+1-check is usually just exponent, except for subnormals (and the damn 0) so it goes up from -127 to -126 (in case of float32)
		--mantissa with the subnormal check again is 1.X for normal numbers and 0.X for subnormals
	end,
	---@endsection

	---@section fixedTableEncode_SL
	---Encodes an integer into smaller fixed size integers in an output table
	---@param int integer input integer
	---@param bits integer how many bits each table entry will have
	---@param count integer to how many entries the integer is split into
	---@param outputTable table? if present, appends the encoding at the end, else creates it's own table
	---@return table 
	fixedTableEncode_SL = function(int, bits, count, outputTable)
		local t, mask, size = outputTable or {}, 2 ^ bits - 1
		size = #t + 1
		for i = 0, count - 1 do
			t[size + i] = ( int >> (bits * i) ) & mask
		end
		return t
	end,
	---@endsection

	---@section fixedTableDecode_SL
	---Decodes an integer from a table and crafts it into a bigger size, original integer
	---@param tab table table with encoded data
	---@param bits integer size of each entry in the table
	---@param count integer how many entries there are per encoded integer
	---@param index integer? defaults to 1, the index at which to decode
	---@return integer value original value
	---@return integer index position right after ending the encoding
	fixedTableDecode_SL=function(tab,bits,count,index)
		local int = 0
		index = index or 1
		for i = 0, count - 1 do
			int = int | ( tab[index + i] << (bits * i) )
		end
		return int, index + count
	end,
	---@endsection

	---@section variableTableEncode_SL
	---Encodes an int in a variable amount of table entires as needed, each storing bits-1 bits, last bit reserved to denoute a continuation
	---@param int integer input integer
	---@param bits integer how many bits each table entry will have
	---@param out table? if present, appends the encoding at the end, else creates it's own table
	---@return table
	variableTableEncode_SL=function(int, bits, out)
		local t, mask, i = out or {}, (2 ^ bits >> 1) - 1
		i=#t
		bits = bits - 1
		repeat
			i = i + 1
			t[i] = int & mask
			int = int >> bits
		until int == 0
		t[i] = t[i] | (mask + 1)
		return t
	end,
	---@endsection

	---@section variableTableDecode_SL
	---Decodes an integer from a table and crafts it into a bigger size, original integer
	---@param tab table table with encoded data
	---@param bits integer size of each entry in the table
	---@param index integer? defaults to 1, the index at which to decode
	---@return integer integer original value
	---@return integer index position right after ending the encoding
	variableTableDecode_SL=function(tab,bits,index)
		local int, iter, mask, v = 0, 0, (2 ^ bits >> 1) - 1
		index = index or 1
		bits = bits - 1
		repeat
			v = tab[index + iter]
			int = int | ( (v & mask) << (bits * iter) )
			iter = iter + 1
		until v > mask
		return int, index + iter
	end,
	---@endsection

	---@section sixBitTableToString_SL
	---Changes a table into a string on the presumption that it's arraylike and that every entry inside is an integer between 0 and 63
	---@param tab table
	---@param startIndex integer? defaults to 1, the position from which to start encoding, inclusive
	---@param endIndex integer? default to #tab, the position at which encoding ends, inclusive
	---@return string str
	sixBitTableToString_SL = function(tab, startIndex, endIndex)
		local t2, value = {}
		for index = startIndex or 1, endIndex or #tab do
			value = tab[index] + 40
			t2[index] = value > 90 and value + 6 or value
		end
		return string.char( table.unpack(t2) )
	end,
	---@endsection

	---@section stringToSixBitTable_SL
	---Changes a string into a table with values between 0 and 63
	---@param str string
	---@param startChar integer? defaults to 1, the position from which to start encoding, inclusive
	---@param endChar integer? default to #str, the position at which encoding ends, inclusive
	---@return tab table
	stringToSixBitTable_SL = function(str, startChar, endChar)
		local tab, value = {string.byte(str, 1, #str)}
		startChar = (startChar or 1) - 1
		for i = startChar + 1, endChar or #tab do
			value = tab[i]
			tab[i - startChar] = (value > 90 and value - 6 or value) - 40
		end
		return tab
	end,
	---@endsection

	---@section transcribeTableBits_SL
	---Changes a table with integers lets say 8 bits (bits in) larger into a larger output table with 4 bits (bits out) integers and returns that. Works in any direction but when bringing back, totalOutputValues might be needed to prune the end
	---@param tab table
	---@param bitsIn integer
	---@param bitsOut integer
	---@param totalOutputValues integer? used to trim the end when transcribing back due to edge cases and accidental 0 pads
	---@param index integer? defaults to 1, can be used to skip a header or smfn
	---@return table transcribed into different bit size
	transcribeTableBits_SL=function(tab,bitsIn,bitsOut,totalOutputValues,index)
		local output, buffer, shift, insertLocal, removeLocal topValue = {}, 0, 0, table.insert, table.remove
		index = index or 1

		for i, value in ipairs(tab), tab, index - 1 do
			buffer = (buffer << bitsIn) | value
			shift = shift + bitsIn
			while shift >= bitsOut do
				topValue = buffer >> (shift - bitsOut)
				insertLocal(output, topValue)
				buffer = buffer ~ (topValue << (shift - bitsOut))
				shift = shift - bitsOut
			end
		end
		while shift > 0 do
			insertLocal(output, buffer >> (shift - bitsOut))
			shift = shift - bitsOut
		end
		for i = (totalOutputValues or math.huge) + 1, #output, -1 do
			removeLocal(output, i)
		end
		return output
	end,
	---@endsection
}

StormSL.Bitformatting = Bitformatting
---@endsection STORMSL_BITFORMATTING_CLASS
