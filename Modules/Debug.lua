
---@section Debug 1 STORMSL_DEBUG_CLASS
---@class Debug
---@field printIntRepresentation_SL fun(integer:integer,...:any)
---@field printTable_SL fun(tab:table, text:string?)
Debug = {

	---@section printIntRepresentation_SL
	---Prints a binary representation of an integer
	---@param integer integer
	---@param ... any
	printIntRepresentation_SL = function(integer, ...)
		local text = ''
		for i = 0, 63 do
			text=( (integer >> i) & 1) .. text
		end
		print(text, ...)
	end,
	---@endsection

	---@section printTable_SL
	---@param tab table
	---@param text string? name of the table, purely cosmetical
	printTable_SL = function(tab, text)
		local cyclics = {}
		text = text or 'table main'
		local function recursive(tab, tabs, indices)
			cyclics[tab] = true
			local accessedArrayKeys = {}
			for i,v in ipairs(tab) do
				accessedArrayKeys[i] = true
				local type = type(v)
				if type=='table' then
					if not cyclics[v] then
						print((' '):rep(tabs*4)..i..' = '..type)
						recursive(v,tabs+1,indices..'['..i..']')
					else
						print((' '):rep(tabs*4)..i..' = cyclic table: '..indices)
					end
				else
					print((' '):rep(tabs*4)..i..' = '..type..' '..tostring(v))
				end
			end
			for i,v in pairs(tab) do
				if not accessedArrayKeys[i] then
					local vtype = type(v)
					if vtype=='table' then
						if not cyclics[v] then
							print((' '):rep(tabs*4)..tostring(i)..' = '..vtype)
							recursive(v,tabs+1,indices..'['..tostring(i)..']')
						else
							print((' '):rep(tabs*4)..tostring(i)..' = cyclic table: '..indices)
						end
					else
						print((' '):rep(tabs*4)..tostring(i)..' = '..vtype..' '..tostring(v))
					end
				end
			end
		end
		print(text)
		recursive(tab, 1, text)
	end,
	---@endsection

}
---@endsection STORMSL_DEBUG_CLASS