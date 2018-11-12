local Str = ""
local function TableToXML_(Tab, Key2, Depth, Attributes2)
	for Key, Value in pairs(Tab) do
		if type(Key) == "string" and type(Value) == "table" then
			if Key ~= "_attr" then
				if Value[1] then
					local Attributes = ""
					
					if Value._attr then
						Attributes = " "
						for Key, Value in pairs(Value._attr) do
							Attributes = Attributes .. tostring(Key) .. "=\"" .. tostring(Value) .. "\" "
						end
					end
					
					Attributes = string.sub(Attributes, 1, #Attributes - 1)
					
					TableToXML_(Value, Key, Depth, Attributes)
				else
					local Attributes = ""
					
					if Value._attr then
						Attributes = " "
						for Key, Value in pairs(Value._attr) do
							Attributes = Attributes .. tostring(Key) .. "=\"" .. tostring(Value) .. "\" "
						end
					end
					
					Attributes = string.sub(Attributes, 1, #Attributes - 1)
					
					Str = Str .. string.rep("\t", Depth) .. "<" .. tostring(Key) .. Attributes .. ">\n"
					
					TableToXML_(Value, Key, Depth + 1, Attributes)
					
					Str = Str .. string.rep("\t", Depth) ..  "</" .. tostring(Key) .. ">\n"
				end
			end
		elseif type(Key) == "number" and type(Value) == "table" then
			local Attributes = ""
				
			if Value._attr then
				Attributes = " "
				for Key, Value in pairs(Value._attr) do
					Attributes = Attributes .. tostring(Key) .. "=\"" .. tostring(Value) .. "\" "
				end
			end
			
			Attributes = string.sub(Attributes, 1, #Attributes - 1)
		
			Str = Str .. string.rep("\t", Depth) ..  "<" .. tostring(Key2) .. Attributes .. ">\n"
			
			TableToXML_(Value, Key, Depth + 1, Attributes)
			
			Str = Str .. string.rep("\t", Depth) ..  "</" .. tostring(Key2) .. ">\n"
		
		elseif type(Key) == "string" then
			Str = Str .. string.rep("\t", Depth) ..  "<" .. tostring(Key) .. ">" .. tostring(Value) .. "</" .. tostring(Key) .. ">\n"
		else
			Attributes2 = Attributes2 or ""
			Str = Str .. string.rep("\t", Depth) ..  "<" .. tostring(Key2) .. Attributes2 .. ">" .. tostring(Value) .. "</" .. tostring(Key2) .. ">\n"
		end
	end
end 

function TableToXML(Tab, filename)
	Str = ""
	
	TableToXML_(Tab, "", 0)
	
	local file = io.open( filename, "wb" )

	file:write(Str)
	file:close()
end

function readXML()
	local readSTR = ""
	for line in io.lines("MapMakerList.xml") do
		readSTR = readSTR.."\n "..line
	end

	return readSTR

end

