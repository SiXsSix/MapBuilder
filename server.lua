local MapObjects = {}
local players = {}



RegisterServerEvent("MapMaker:addObject")
AddEventHandler("MapMaker:addObject", function(name,x1,y1,z1,heading)
	local _source = source
	table.insert(MapObjects, {n=name,x=x1,y=y1,z=z1,h=heading})
	TableToXML(MapObjects, "MapMakerList.xml")

	for _,k in pairs(players) do
		if(k ~= _source) then
			TriggerClientEvent("MapMaker:askToSpawnNew", k, {n=name,x=x1,y=y1,z=z1,h=heading}, #MapObjects)
		end
	end

	TriggerClientEvent("showDoneNotif", _source, settings[lang].successfull)
end)



RegisterServerEvent("MapMaker:CheckIfCanOpenMenu")
AddEventHandler("MapMaker:CheckIfCanOpenMenu", function()
	local _source = source
	local player = getPlayerID(_source)

	local canOpen = false

	if(not MenuCanBeOpenByAllPlayers) then
		for _,k in pairs(MenuWhiteList) do
			if(k==player) then
				canOpen = true
				break;
			end
		end
	else
		canOpen = true
	end

	TriggerClientEvent("MapMaker:openMenu", _source, canOpen)
end)


RegisterServerEvent("MapMaker:RequestData")
AddEventHandler("MapMaker:RequestData", function()
	local _source = source
	table.insert(players,_source)
	TriggerClientEvent("MapMaker:sendData", _source, MapObjects)
end)



RegisterServerEvent("MapMaker:askDeleteObject")
AddEventHandler("MapMaker:askDeleteObject", function(id, objectID)

	local newArray = {}
	for i, k in pairs(MapObjects) do
		if(i~=id) then
			newArray[i] = k
		end
	end

	MapObjects = {}
	MapObjects = newArray

	TableToXML(MapObjects, "MapMakerList.xml")

	for _,k in pairs(players) do
		TriggerClientEvent("MapMaker:askDeleteObject_c", k, objectID)
	end

end)


function recupObjects()
	file = io.open("MapMakerList.xml", "a") -- Create file if doesn't exist
	file:close() 
	local callback = XmlParser:ParseXmlText(readXML())

	local nameValues = {}
	local xValues = {}
	local yValues = {}
	local zValues = {}
	local hValues = {}

	local count = 0

	for i,k in pairs(callback) do
		if(type(k) == "table") then
			if(i=="n") then
				for ind, val in pairs(k) do
					if(type(val) == "table") then
						for inde, valu in pairs(val) do
							if(type(valu) == "string" and valu ~= "n") then
								nameValues[count+1] = valu
								count = count+1
							end
						end
					end
				end
			end

			if(i=="x") then
				for ind, val in pairs(k) do
					if(type(val) == "table") then
						for inde, valu in pairs(val) do
							if(tonumber(valu)~=nil) then
								table.insert(xValues, tonumber(valu))
							end
						end
					end
				end
			end

			if(i=="y") then
				for ind, val in pairs(k) do
					if(type(val) == "table") then
						for inde, valu in pairs(val) do
							if(tonumber(valu)~=nil) then
								table.insert(yValues, tonumber(valu))
							end
						end
					end
				end
			end

			if(i=="z") then
				for ind, val in pairs(k) do
					if(type(val) == "table") then
						for inde, valu in pairs(val) do
							if(tonumber(valu)~=nil) then
								table.insert(zValues, tonumber(valu))
							end
						end
					end
				end
			end

			if(i=="h") then
				for ind, val in pairs(k) do
					if(type(val) == "table") then
						for inde, valu in pairs(val) do
							if(tonumber(valu)~=nil) then
								table.insert(hValues, tonumber(valu))
							end
						end
					end
				end
			end
		end
	end

	for i=1,count do
		table.insert(MapObjects, {n=nameValues[i],x=xValues[i],y=yValues[i],z=zValues[i],h=hValues[i]})
	end

end

recupObjects()



function getPlayerID(source)
    local identifiers = GetPlayerIdentifiers(source)
    local player = getIdentifiant(identifiers)
    return player
end

function getIdentifiant(id)
    for _, v in ipairs(id) do
        return v
    end
end