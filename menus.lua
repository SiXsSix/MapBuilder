menuId = 0 -- Menu principal
searchMenu = false
local menuInt = 0
local menuAuto = true

local currentParent = 0

inSubMod = false
local subCategories = {}

Citizen.CreateThread(function()

	while true do
		Citizen.Wait(0)

		if(activate and mainMenu) then
			drawTxt(settings[lang].menuInstruction1,0,1,0.5,0.8,0.6,255,255,255,255)
			if(not inSubMod) then
				if(menuId == 0) then
					renderDefaultMenu()
				elseif(menuId > 0) then
					showCategorieMenu(menuId)
				elseif(menuId == -2) then -- In sub menu
					renderSubMenu()
				elseif(menuId == -3) then -- In del menu
					renderDelMenu()
				end
			else
				renderSubMod()
			end
		end
	end

end)


function renderDefaultMenu()
	TriggerEvent("GUI:MapTitle", "Map Maker")


	TriggerEvent("GUI:MapInt", settings[lang].deplacementPrecision.." : ", precision, 1, 10, function(cb)
		precision = cb
	end)

	TriggerEvent("GUI:MapInt", settings[lang].camPrecision.." : ", camPrecision, 1, 10, function(cb)
		camPrecision = cb
	end)

	TriggerEvent("GUI:MapOption",settings[lang].delCurrent, function(cb)
		if(cb) then
			askDelete()
		else
					
		end
	end)

	TriggerEvent("GUI:MapOption",settings[lang].spawnByName, function(cb)
		if(cb) then
			placeObjectByName()
		else
						
		end
	end)


	TriggerEvent("GUI:MapOption",settings[lang].searchObject, function(cb)
		if(cb) then
			searchObjectModel()
		else
						
		end
	end)


	TriggerEvent("GUI:MapOption",settings[lang].confirm, function(cb)
		if(cb) then
			placeMenu(lastObjectModel,0)
		else
			
		end
	end)


	TriggerEvent("GUI:MapOption",settings[lang].cancel, function(cb)
		if(cb) then
			askDelete()
			DeleteObject(fakeobject)
			DeleteObject(object)
			object = -1
			lastObjectModel = ""
			showWarnNotif(settings[lang].deleteSuccess)
			mainMenu = true
			menuId = 0
			activate = false
			launchSystem()
		else
				
		end
	end)


	TriggerEvent("GUI:MapOption",settings[lang].deleteObject, function(cb)
		if(cb) then
			menuId = -3
			countMin = 0
			countMax = 23
			searchObjectModelArrayCount = #lData
		else
						
		end
	end)



	for _,k in pairs(categories) do
		TriggerEvent("GUI:MapOption",k.name, function(cb)
			if(cb) then
				if(k.c) then
					inSubMod = false
					subCategories = {}
					menuId = -2
					for i,c in pairs(sous_categories) do
						if(c.parent_id == k.id) then
							table.insert(subCategories, c)
						end
					end
				else
					menuId = k.id
				end
			else
					
			end
		end)

	end

	TriggerEvent("GUI:MapUpdate")
end

function showCategorieMenu(id)

	TriggerEvent("GUI:MapTitle", "Map Maker")

	TriggerEvent("GUI:MapOption","< return", function(cb)
		if(cb) then
				menuId = 0
		else
					
		end
	end)

	for _,k in pairs(categories_id[id]) do
		TriggerEvent("GUI:MapSpawnOption",k, function(cb)
			if(cb) then
				menuId = -1
				placeMenu(k,id)
			else
					
			end
		end)
	end

	TriggerEvent("GUI:MapUpdate")
end


XDifference = 0
YDifference = 0
function placeMenu(name, id)

	local menuXDifference = 0
	local menuYDifference = 0

	local x,y,z = table.unpack(GetEntityCoords(object))

   	_, gH = GetGroundZFor_3dCoord(x,y,z+1000)
	fakeobject = CreateObject(GetHashKey("prop_a4_sheet_01"), x,y,gH + generatedHeight,  false,  true, false)

	Citizen.CreateThread(function()
		local stopped = false

		mainMenu = false
		while activate and not stopped do
			Wait(0)
			drawTxt(settings[lang].menuInstruction2,0,1,0.5,0.8,0.6,255,255,255,255)
			setPlaceCamera()
			TriggerEvent("GUI:MapTitle", "Place object")

			TriggerEvent("GUI:MapOption","< return", function(cb)
				if(cb) then
					menuId = 0
					stopped = true
					inSubMod = false
					mainMenu = true
				else
						
				end
			end)

			TriggerEvent("GUI:MapInt", settings[lang].height.." : ", menuInt, -50, 50, function(cb)
				objZAdder = (cb/precision)
				menuInt = 0
				SetEntityCoords(object, x, y, z+objZAdder)
				x,y,z = table.unpack(GetEntityCoords(object))
   				_, gH = GetGroundZFor_3dCoord(x,y,z+1000)
				lastCoords = -1
			end)



			TriggerEvent("GUI:MapInt", "X : ", menuXDifference, -50, 50, function(cb)
				XDifference = (cb/precision)
				menuXDifference = 0
				SetEntityCoords(object,x+XDifference,y,z)
				x,y,z = table.unpack(GetEntityCoords(object))
   				_, gH = GetGroundZFor_3dCoord(x,y,z+1000)
			end)


			TriggerEvent("GUI:MapInt", "Y : ", menuYDifference, -50, 50, function(cb)
				YDifference = (cb/precision)
				menuYDifference = 0
				SetEntityCoords(object,x,y+YDifference,z)
				x,y,z = table.unpack(GetEntityCoords(object))
   				_, gH = GetGroundZFor_3dCoord(x,y,z+1000)
			end)




			TriggerEvent("GUI:MapInt", settings[lang].deplacementPrecision.." : ", precision, 1, 10, function(cb)
				precision = cb
			end)

			TriggerEvent("GUI:MapInt", settings[lang].camPrecision.." : ", camPrecision, 1, 10, function(cb)
				camPrecision = cb
			end)


			TriggerEvent("GUI:MapOption",settings[lang].confirm, function(cb)
				if(cb) then
					SetEntityCollision(object, true)
					FreezeEntityPosition(object, true)
					local x,y,z = table.unpack(GetEntityCoords(object))
					TriggerServerEvent("MapMaker:addObject",name,x,y,z,GetEntityHeading(object))
					SetEntityCoords(object, x,y,z)
					mainMenu = true
					menuId = 0
					DeleteObject(fakeobject)
					object = -1
					lastObjectModel = ""
					activate = false
					launchSystem()
				else
					
				end
			end)


			TriggerEvent("GUI:MapOption",settings[lang].cancel, function(cb)
				if(cb) then
					askDelete()
					DeleteObject(fakeobject)
					DeleteObject(object)
					object = -1
					lastObjectModel = ""
					showWarnNotif(settings[lang].deleteSuccess)
					mainMenu = true
					menuId = 0
					activate = false
					launchSystem()
				else
						
				end
			end)

			TriggerEvent("GUI:MapUpdate")
		end
	end)
end



function renderSubMenu()
	TriggerEvent("GUI:MapTitle", "Map Maker")

	TriggerEvent("GUI:MapOption","< return", function(cb)
		if(cb) then
			menuId = 0
		else
						
		end
	end)


	for _,k in pairs(subCategories) do
		TriggerEvent("GUI:MapOption",k.name, function(cb)
			if(cb) then
				menuId = k.child_id
				currentParent = k.parent_id
				print(menuId)
				print(currentParent)
				inSubMod = true
			else
						
			end
		end)

	end

	TriggerEvent("GUI:MapUpdate")
end




function renderSubMod()
	TriggerEvent("GUI:MapTitle", "Map Maker")

	TriggerEvent("GUI:MapOption","< return", function(cb)
		if(cb) then
			inSubMod = false
			menuId = 0
		else
			
		end
	end)

	if(inSubMod) then
		for _,k in ipairs(sub_categorie[menuId]) do
			TriggerEvent("GUI:MapSpawnOption",k, function(cb)
				if(cb) then
					menuId = -1
					placeMenu(k,id)
				else
					
				end
			end)
		end
	end

	TriggerEvent("GUI:MapUpdate")
end



function drawTxt(text,font,centre,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextProportional(0)
	SetTextScale(scale, scale)
	SetTextColour(r, g, b, a)
	SetTextDropShadow(0, 0, 0, 0,255)
	SetTextEdge(1, 0, 0, 0, 255)
	SetTextDropShadow()
	SetTextOutline()
	SetTextCentre(centre)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x , y)
end




function placeObjectByName()
	Citizen.CreateThread(function()
		local objectName = ""
		local edmenu = { show = 0, row = 0, input = 0, name = "", inp = 0, cur = 0 }
		local Ed = { id = {}, x = {}, y = {}, x1 = {}, y1 = {}, scale = {}, r = {}, g = {}, b = {}, a = {}, text = {}, font = {}, jus = {} }

		if edmenu.inp > 0 then
			edmenu.show = 2
			edmenu.row = 0
		else
			edmenu.input = 1
			edmenu.row = 1
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
			PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)

		end

		local stop = false

		while stop == false do
			Wait(0)



			if edmenu.input == 1 then
				if UpdateOnscreenKeyboard() == 3 then
					edmenu.input = 0
					edmenu.show = 1
					edmenu.row = 0
				elseif UpdateOnscreenKeyboard() == 1 then
					local inputText = GetOnscreenKeyboardResult()
						if string.len(inputText) > 0 then
							edmenu.inp = 1
							edmenu.cur = 0
							objectName = inputText
							edmenu.show = 2
							edmenu.row = 0
							edmenu.input = 0
							stop = true
						end
				elseif UpdateOnscreenKeyboard() == 2 then
						edmenu.input = 0
						if edmenu.show == 1 and edmenu.row == 1 then
							edmenu.show = 1
							edmenu.row = 0
						end
				

				end
			else 
				stop = true
			end
		end

		if(DoesEntityExist(object)) then
			DeleteObject(object)
		end
		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		object = CreateObject(GetHashKey(objectName), x-0.5,y,z,  false, true, false)
	end)
end


local countMin = 0
local countMax = 23
local searchObjectModelArrayCount = 0
function searchObjectModel()
	mainMenu = false
	Citizen.CreateThread(function()
		local stopped = false
		local objectName = ""
		local edmenu = { show = 0, row = 0, input = 0, name = "", inp = 0, cur = 0 }
		local Ed = { id = {}, x = {}, y = {}, x1 = {}, y1 = {}, scale = {}, r = {}, g = {}, b = {}, a = {}, text = {}, font = {}, jus = {} }

		if edmenu.inp > 0 then
			edmenu.show = 2
			edmenu.row = 0
		else
			edmenu.input = 1
			edmenu.row = 1
			DisplayOnscreenKeyboard(false, "FMMC_KEY_TIP8", "", "", "", "", "", 64)
			PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)

		end

		local stop = false

		while stop == false do
			Wait(0)



			if edmenu.input == 1 then
				if UpdateOnscreenKeyboard() == 3 then
					edmenu.input = 0
					edmenu.show = 1
					edmenu.row = 0
				elseif UpdateOnscreenKeyboard() == 1 then
					local inputText = GetOnscreenKeyboardResult()
						if string.len(inputText) > 0 then
							edmenu.inp = 1
							edmenu.cur = 0
							objectName = inputText
							edmenu.show = 2
							edmenu.row = 0
							edmenu.input = 0
							stop = true
							
						end
				elseif UpdateOnscreenKeyboard() == 2 then
						edmenu.input = 0
						if edmenu.show == 1 and edmenu.row == 1 then
							edmenu.show = 1
							edmenu.row = 0
						end
				

				end
			else 
				stop = true
				menuId = 0
				stopped = true
				inSubMod = false
				mainMenu = true
				searchMenu = false
			end
		end

		local count = 0
		local awnserArray = {}
		for i,k in pairs(searchArray) do
			if(string.find(tostring(i), tostring(objectName))) then
				table.insert(awnserArray, tostring(i))
				count = count+1
			end
		end
		
		searchObjectModelArrayCount = count
		countMin = 1
		countMax = 23

		
		searchMenu = true
		while activate and not stopped do
			Citizen.Wait(0)
			TriggerEvent("GUI:MapTitle", "Result for "..tostring(objectName))

			TriggerEvent("GUI:MapOption","< return", function(cb)
				if(cb) then
					menuId = 0
					stopped = true
					inSubMod = false
					mainMenu = true
					searchMenu = false
				else
						
				end
			end)
			for i,k in pairs(awnserArray) do
				if(i>=countMin and i<=countMax) then
					TriggerEvent("GUI:MapSpawnOption",k, function(cb)
						if(cb) then
							menuId = -1
							stopped = true
							placeMenu(k,id)
							searchMenu = false
						else
					
						end
					end)
				end
			end

			TriggerEvent("GUI:MapUpdate")

		end

	end)

end



function renderDelMenu()
	TriggerEvent("GUI:MapTitle", settings[lang].deleteObject)

	TriggerEvent("GUI:MapOption","< return", function(cb)
		if(cb) then
			inSubMod = false
			menuId = 0
		else
			
		end
	end)


	for i,k in pairs(lData) do
		print(i)
		print(k)
		if(i>=countMin and i<=countMax) then
			TriggerEvent("GUI:MapDelOption",k.n, k.oID, function(cb)
				if(cb) then
					TriggerServerEvent("MapMaker:askDeleteObject", i, k.oID)
					menuId = 0
				else
			
				end
			end)
		end
	end

	TriggerEvent("GUI:MapUpdate")
end


RegisterNetEvent("GUI:requestGo")
AddEventHandler("GUI:requestGo", function(current, cb)
	local changed = false
	if(current > 23 and countMax+1<=searchObjectModelArrayCount) then
		countMin = countMin+1
		countMax = countMax+1
		changed = true
	end

	cb(changed)
end)