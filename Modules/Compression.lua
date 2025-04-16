

---@section Compression 2 STORMSL_COMPRESSION_CLASS
---@class Compression
---@field marker table
---@field flattenTableToBytes_SL fun(tab:table,optMinFpSizeInBytes:integer?,optMaxFpSizeInBytes:integer?):table,string?
---@field unflattenTableFromBytes_SL fun(tab:table):table?
Compression = {
	marker = {75, 114, 111, 108, 67, 109, 112, 114, 115, 86, 49}, --'KrolCmprsV1' used as a marker to ensure changes in the future can be safely detected

	---@section flattenTableToBytes_SL
	---@param tab table table to flatten
	---@param optMinFpSizeInBytes integer? defaults to 2
	---@param optMaxFpSizeInBytes integer? default to 8
	---@return table flat
	---@return string? error if it's not nil it's best to completely disregard it's output
	flattenTableToBytes_SL = function(tab, optMinFpSizeInBytes, optMaxFpSizeInBytes)
		--[[
			lua types
			- nil
			+ string
			- boolean
			+ float
			+ int
			+ table
			- userdata (/light)
			- function (C/lua but doesn't count)

			transmission value header byte
			zzz yyy xx
			xx for type
				0 integer
				1 float
				2 string
				3 table
			yyy
				numbers: size
				0-7 + 1 for 1 to 8 bytes per value

				strings:
				0 for a string
				1 for a boolean

				tables:
				unused
			zzz
				amount of consecutively repeated same types, for less headers

			integer:
				if single byte then is unsigned, 0-255
				if more then it's a signed int
		]]
		optMinFpSizeInBytes = optMinFpSizeInBytes or 2
		optMaxFpSizeInBytes = optMaxFpSizeInBytes or 8
		local cyclics, cyclicCounter, stringCache, stringCounter, errorDetected = {}, 0, {}, 0

		local function recursive(tab, outTable)
			if not cyclics[tab] then
				cyclicCounter = cyclicCounter + 1
				cyclics[tab] = cyclicCounter
			end

			local encodeInt,insertLocal, typeLocal, absLocal, logLocal = Bitformatting.fixedTableEncode_SL, table.insert, type, math.abs, math.log
			local numberType, tableType, stringType, booleanType = 'number', 'table', 'string', 'boolean'
			local buffer, accessedArrayKeys, countOfHeaders, index, value, count, type, size, nextType, nextSize, checkType, encodeValues = {}, {}, 0, 1, tab[1]

			function checkType(value)
				local type, size = typeLocal(value), 1
				if type == numberType then
					if value % 1 == 0 then
						if value&255==value then
							return 0, 1
						end
						value = absLocal(value) >> 8
						repeat
							value = value >> 8
							size = size + 1
						until value == 0
						return 0, size --either unsigned byte or signed int of that many bytes
					end
					--float
					--we want certain amount of accuracy so we do log to know how many mantissa bits we need
					--3 + every 6th extra bit in my fp encoder goes to exponent so * 6/5 to and get it back
					--+1 to accomodate for sign, +8 to ensure after //8 we dont loose accuracy
					--then we clamp it between 1 and 8 bytes for a mini or double
					return 1, StormSL.clamp_SL(optMinFpSizeInBytes, optMaxFpSizeInBytes, (logLocal(value, 2) * 1.2 + 12)//8 )
				end
				--check for string or type
				--alternatively, for booleans, give it same type as string but the size is set to 2 to differentiate
				--nils functions and whatever else are unsupported
				return type == stringType and 2 or type == tableType and 3 or type == booleanType and 6 or 4, type == booleanType and 2 or 1
			end
			function encodeValues(optValue)
				insertLocal(buffer, ( (count - 1) << 5) | ( (size - 1) << 2) | (type&3))
				for i = 0, count - 1 do
					local value, stringToCache =  optValue == nil and tab[index + i] or optValue
					if type == 0 then
						encodeInt(value, 8, size, buffer)
						--for j = 0, size - 1 do
						--	insertLocal(buffer, (value >> (8 * j) ) & 255)
						--end
					elseif type == 1 then
						value = Bitformatting.floatToInt_SL(value, 8 * size)
						encodeInt(value, 8, size, buffer)
						--for j = 0, size - 1 do
						--	insertLocal(buffer, (value >> (8 * j) ) & 255)
						--end
					elseif type&3 == 2 then
						if type == 2 then
							if stringCache[value] then
								encodeInt(stringCache[value], 8, 2, buffer)
							else
								insertLocal(buffer, 0)
								insertLocal(buffer, 0)
								stringToCache = value
								value = ' '..value
								size = #value
								value = {string.byte(value, 1, size)}
								for j = 1, size - 1 do
									insertLocal(buffer, value[j])
								end
								insertLocal(buffer, value[size] + 128)
								stringCounter = stringCounter + 1
								stringCache[stringToCache] = stringCounter
							end
						else
							insertLocal(buffer, value and 1 or 0)
						end
					elseif type == 3 then
						if cyclics[value] then
							--Bitformatting.variableTableEncode_SL(cyclics[value], 8, buffer)
							encodeInt(cyclics[value], 8, 2, buffer)
						else
							--Bitformatting.fixedTableEncode_SL(0, 8, 2, buffer)
							insertLocal(buffer, 0)
							insertLocal(buffer, 0)
							recursive(value, buffer)
						end
					else
						insertLocal(buffer, 0)
						errorDetected = 'unsupported type'
					end
				end
			end

			while value do
				type, size = checkType(value)
				count = 1
				nextType, nextSize = checkType(tab[index + count])
				while nextType == type and count<8 do
					count = count + 1
					size = nextSize > size and nextSize or size
					nextType, nextSize = checkType(tab[index + count])
				end
				encodeValues()
				for i = index, index + count - 1 do
					accessedArrayKeys[i] = true
				end
				index = index + count
				countOfHeaders = countOfHeaders + 1
				value = tab[index]
			end
			--Bitformatting.variableTableEncode_SL(countOfHeaders, 8, outTable)
			encodeInt(countOfHeaders, 8, 2, outTable)
			table.move(buffer, 1, #buffer, #outTable + 1, outTable)
			errorDetected = errorDetected or countOfHeaders>0xFFFF and 'header overflow, too many entries'
			buffer = {}
			count = 1
			countOfHeaders = 0
			for index, value in pairs(tab) do
				if not accessedArrayKeys[index] then
					type, size = checkType(index)
					encodeValues(index)
					type, size = checkType(value)
					encodeValues(value)
					countOfHeaders = countOfHeaders + 1
				end
			end
			--Bitformatting.variableTableEncode_SL(countOfHeaders, 8, outTable)
			encodeInt(countOfHeaders, 8, 2, outTable)
			table.move(buffer, 1, #buffer, #outTable + 1, outTable)
			errorDetected = errorDetected or countOfHeaders>0xFFFF and 'header overflow, too many entries'
			return outTable
		end

		return recursive(tab,{table.unpack(Compression.marker)}), errorDetected
	end,
	---@endsection

	---@section unflattenTableFromBytes_SL
	---@param flat table
	---@return table? original may be nil if the table was flattened by incompatible algorithm
	unflattenTableFromBytes_SL = function(flat)
		for i, char in ipairs(Compression.marker) do
			if char ~= flat[i] then
				return nil
			end
		end

		local cyclics, stringCache, stringCounter, index, insertLocal, decodeInt = {}, {}, 0, #Compression.marker+1, table.insert, Bitformatting.fixedTableDecode_SL

		local function recursive(outputTab)
			insertLocal(cyclics, outputTab)
			local readValues, count, key, value = function(autoInsert)
				local header, mask, sign, type, size, count, value = flat[index]
				index = index + 1
				type, size, count = header&3, ( (header >> 2) & 7) + 1, header >> 5
				sign = 1 << (8 * size - 1)
				mask = sign - 1
				for i = 0, count do
					if type == 0 then
						value, index = decodeInt(flat, 8, size, index)
						value = size == 1 and value or (value&mask) - (value&sign)
					elseif type == 1 then
						value, index = decodeInt(flat, 8, size, index)
						value = Bitformatting.intToFloat_SL(value, 8 * size)
					elseif type == 2 then
						if size==1 then
							value, index = decodeInt(flat, 8, 2, index)
							if stringCache[value] then
								value = stringCache[value]
							else
								value = {}
								repeat
									insertLocal(value,flat[index]&127)
									index = index + 1
								until flat[index-1]>127
								value = string.char(table.unpack(value)):sub(2)
								stringCounter = stringCounter + 1
								stringCache[stringCounter] = value
							end
						else
							value = flat[index] == 1
							index = index + 1
						end
					else
						value, index = decodeInt(flat, 8, 2, index)
						value = cyclics[value] or recursive({})
					end
					if autoInsert then
						insertLocal(outputTab, value)
					end
				end
				return value
			end



			count, index = decodeInt(flat, 8, 2, index)
			for i = 1, count do
				readValues(true)
			end
			count, index = decodeInt(flat, 8, 2, index)
			for i = 1, count do
				key = readValues()
				value = readValues()
				outputTab[key] = value
			end
			return outputTab
		end

		return recursive({})
	end
	---@endsection
}
StormSL.Compression = Compression
---@endsection STORMSL_COMPRESSION_CLASS