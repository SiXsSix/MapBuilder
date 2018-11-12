camera = -1
camZAdder = 10
camPrecision = 1

objZAdder = 0

activate = false
automaticZ = true

precision = 1

mainMenu = true

fakeobject = -1


freecam = false


local coordsBefore = -1


lData = {}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		if(IsControlJustPressed(1, 289)) then
			if(MenuCanBeOpen) then
				TriggerServerEvent("MapMaker:CheckIfCanOpenMenu")
			end
		end

		tick()
	end

end)


lastCoords = -1

local isEntityGrabbed = false
local ObjectSelector = {}
function tick()

	if((activate and mainMenu) or (activate and searchMenu)) then

		if(IsControlJustPressed(1, 97)) then
			freecam = not freecam

			if(not freecam) then
				showWarnNotif("Freecam disactivated")
				if(DoesEntityExist(object)) then
					SetEntityCoords(GetPlayerPed(-1), GetEntityCoords(object).x+0.5, GetEntityCoords(object).y, GetEntityCoords(object).z)
				else
					local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
					local _, gH = GetGroundZFor_3dCoord(x,y,z+1000)
					SetEntityCoords(GetPlayerPed(-1), x,y,gH)
				end
			else
				showWarnNotif("Freecam activated")				
			end
		end

		if(not freecam) then
		
			local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
			local _, gH = GetGroundZFor_3dCoord(x,y,z+1000)
		
			if(lastCoords ~= GetEntityCoords(GetPlayerPed(-1))) then
			
				SetEntityCoords(GetPlayerPed(-1),x,y,gH+0.5)
				SetEntityCoords(object, x-0.5,y,gH)

				lastCoords = GetEntityCoords(GetPlayerPed(-1))

			end

		


			if(IsControlPressed(1, 27)) then -- UP
				x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				_, gH = GetGroundZFor_3dCoord(x+0.2,y+(0.5/precision),z+1000)
				SetEntityCoords(GetPlayerPed(-1),x,y+(0.5/precision),gH)
			end

			if(IsControlPressed(1, 173)) then -- DOWN
				x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				_, gH = GetGroundZFor_3dCoord(x+0.2,y-(0.5/precision),z+1000)
				SetEntityCoords(GetPlayerPed(-1),x,y-(0.5/precision),gH)	
			end

			if(IsControlPressed(1, 174)) then -- LEFT
				x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				_, gH = GetGroundZFor_3dCoord(x-(0.5/precision)+0.2,y,z+1000)
				SetEntityCoords(GetPlayerPed(-1), x-(0.5/precision),y,gH)
			end

			if(IsControlPressed(1, 175)) then -- RIGHT
				x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
				_, gH = GetGroundZFor_3dCoord(x+(0.5/precision)+0.2,y,z+1000)
				SetEntityCoords(GetPlayerPed(-1), x+(0.5/precision),y,gH)
			end


			if(IsControlPressed(1, 44)) then
				SetEntityHeading(object, GetEntityHeading(object) - (0.5/precision))
			end

			if(IsControlPressed(1, 38)) then
				SetEntityHeading(object, GetEntityHeading(object) + (0.5/precision))
			end



			if(IsControlPressed(1, 11)) then -- PAGE DOWN
				if(camZAdder-(0.5/camPrecision) > 1 and camZAdder-(0.5/camPrecision) > objZAdder) then
					camZAdder = camZAdder-(0.5/camPrecision)
				end
			end

			if(IsControlPressed(1, 10)) then -- PAGE UP
				camZAdder = camZAdder+(0.5/camPrecision)
			end

			if(DoesEntityExist(object)) then
				 x,y,z = table.unpack(GetEntityCoords(object))
			else
				 x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
			end
			SetCamCoord(camera, x,y,gH+camZAdder)
			SetCamRot(camera, -90.0, 0.0, 0.0)

		else

			SetEntityCoords(GetPlayerPed(-1), GetCamCoord(camera))
			SetEntityHeading(GetPlayerPed(-1), GetCamRot(camera).z)

			local x,y,z = table.unpack(GetCamCoord(camera))

			if(IsControlPressed(1, 32)) then
				x,y,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0,  0.5, 0.0))
				SetCamCoord(camera, x,y,z+(GetCamRot(camera).x/50))
			end


			if(IsControlPressed(1, 8)) then
				x,y,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0,  -0.5, 0.0))

				SetCamCoord(camera, x,y,z-(GetCamRot(camera).x/50))
			end


			if(IsControlPressed(1, 34)) then
				x,y,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), -0.5,  0.0, 0.0))

				SetCamCoord(camera, x,y,z)
			end


			if(IsControlPressed(1, 9)) then
				x,y,z2 = table.unpack(GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.5, 0.0, 0.0))

				SetCamCoord(camera, x,y,z)
			end
			

			local rightAxisX = GetDisabledControlNormal(0, 220)
			local rightAxisY = GetDisabledControlNormal(0, 221)
			local rotation = GetCamRot(camera, 2)

			if rightAxisX ~= 0.0 or rightAxisY ~= 0.0 then
				new_z = rotation.z + rightAxisX*-1.0*4
				new_x = math.max(math.min(20.0, rotation.x + rightAxisY*-1.0*2), -89.5)
				SetCamRot(camera, new_x, 0.0, new_z, 2)
			end

		end
	end
end



function launchSystem()

	if(activate) then

		local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))
		local _, gH = GetGroundZFor_3dCoord(x,y,z+1000)


		coordsBefore = GetEntityCoords(GetPlayerPed(-1))
		SetEntityVisible(GetPlayerPed(-1), false)
		SetEntityCollision(GetPlayerPed(-1), false)

		FreezeEntityPosition(GetPlayerPed(-1), true)

		camera = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)

		SetCamRot(camera, -90.0, 0.0, 0.0)
		SetCamActive(camera,  true)
		RenderScriptCams(true,  false,  0,  true,  true)

	else
		SetEntityCoords(GetPlayerPed(-1), coordsBefore)
		camera = -1

		RenderScriptCams(false, false, 0, 1, 0)
		DestroyCam(camera, false)

		DeleteObject(object)

		SetEntityVisible(GetPlayerPed(-1), true)
		SetEntityCollision(GetPlayerPed(-1), true)
		FreezeEntityPosition(GetPlayerPed(-1), false)
	end

end


generatedHeading = 0
generatedHeight = 1

local espacement = 3

function setPlaceCamera()

	local HeadingRad = math.rad(generatedHeading)
    local a = math.cos(HeadingRad)
   	local b = math.sin(HeadingRad)

   	local x,y,z = table.unpack(GetEntityCoords(object))

   	_, gH = GetGroundZFor_3dCoord(x,y,z+1000)


   	SetEntityCoords(fakeobject, x,y,gH+generatedHeight)
	PointCamAtEntity(camera, fakeobject, 0.0, 0.0, 0.0, true)

	SetCamCoord(camera, x-(b*espacement),y+(a*espacement),gH+generatedHeight)

	if(IsControlPressed(1, 10)) then
		generatedHeight = generatedHeight+(0.5/camPrecision)
	end

	if(IsControlPressed(1, 11)) then
		generatedHeight = generatedHeight-(0.5/camPrecision)
	end


	if(IsControlPressed(1, 44)) then
		if(generatedHeading-(0.5/camPrecision) < 0) then
			generatedHeading = 350
		else
			generatedHeading = generatedHeading - (0.5/camPrecision)
		end
	end

	if(IsControlPressed(1, 38)) then
		if(generatedHeading+(0.5/camPrecision) > 350) then
			generatedHeading = 0
		else
			generatedHeading = generatedHeading + (0.5/camPrecision)
		end
	end


	if(IsControlPressed(1, 32)) then
		espacement = espacement + (0.5/camPrecision)
	end

	if(IsControlPressed(1, 8)) then
		espacement = espacement - (0.5/camPrecision)
	end
end



RegisterNetEvent("MapMaker:sendData")
AddEventHandler("MapMaker:sendData", function(data)
	print("get")
	print(#data)
	for i,k in pairs(data) do
		print(k.n)
		local toSpawn = CreateObject(GetHashKey(k.n), k.x, k.y, k.z, false, true, false)
		FreezeEntityPosition(toSpawn, true)
		SetEntityHeading(toSpawn, k.h)
		SetEntityCoords(toSpawn, k.x, k.y, k.z)
		lData[i] = {oID = toSpawn,n=k.n,x=k.x,y=k.y,z=k.z,h=k.h}
	end

end)


RegisterNetEvent("MapMaker:askToSpawnNew")
AddEventHandler("MapMaker:askToSpawnNew", function(array, number)

	local toSpawn = CreateObject(GetHashKey(array.n), array.x, array.y, array.z, false, true, false)
	FreezeEntityPosition(toSpawn, true)
	SetEntityHeading(toSpawn, array.h)
	SetEntityCoords(toSpawn, array.x, array.y, array.z)

	lData[number] = {oID = toSpawn, x = array.x, y = array.y, z = array.z, h = array.h}

end)


AddEventHandler("playerSpawned", function()
	TriggerServerEvent("MapMaker:RequestData")
end)







RegisterNetEvent("MapMaker:openMenu")
AddEventHandler("MapMaker:openMenu", function(canOpen)

	if(canOpen) then

		if(DoesEntityExist(object)) then
			DeleteObject(object)
		end

		activate = not activate
		mainMenu = true
		menuId = 0
		inSubMod = false
		launchSystem()
	end
		
end)



RegisterNetEvent("MapMaker:askDeleteObject_c")
AddEventHandler("MapMaker:askDeleteObject_c", function(objectID)
	DeleteObject(objectID)

	local newArray = {}
	for i,k in pairs(lData) do
		if(k.oID ~= objectID) then
			newArray[i] = k
		end
	end

	lData = {}
	lData = newArray
end)


function RotAnglesToVec(rot) -- input vector3
	local z = math.rad(rot.z)
	local x = math.rad(rot.x)
	local num = math.abs(math.cos(x))
	return vector3(-math.sin(z)*num, math.cos(z)*num, math.sin(x))
end


function Info(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end



function Draw3DText(x, y, z, textInput, fontId, scaleX, scaleY)
      local px,py,pz=table.unpack(GetGameplayCamCoords())
      local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)

      local scale = (1/dist)*20
      local fov = (1/GetGameplayCamFov())*100
      local scale = scale*fov

      SetTextScale(scaleX*scale, scaleY*scale)
      SetTextFont(fontId)
      SetTextProportional(1)
      SetTextColour(255, 255, 255, 150)
      SetTextDropshadow(0, 0, 0, 0, 255)
      SetTextEdge(2, 0, 0, 0, 150)
      SetTextDropShadow()
      SetTextOutline()
      SetTextEntry("STRING")
      SetTextCentre(1)
      AddTextComponentString(textInput)
      SetDrawOrigin(x,y,z+2, 0)
      DrawText(0.0, 0.0)
      ClearDrawOrigin()
end
