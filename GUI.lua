



GUI = {}
Menu = {}

GUI.maxVisOptions = 27

GUI.titleText = {255, 255, 255, 255, 7}
GUI.titleRect = {52, 73, 94, 255}
GUI.optionText = {255, 255, 255, 255, 6}
GUI.optionRect = {40, 40, 40, 190}
GUI.scroller = {127, 140, 140, 240}

local menuX = 0.15
local selectPressed = false
local leftPressed = false
local rightPressed = false
local currentOption = 2
local optionCount = 0

inOptions = false

askDel = false

object = -1
lastObjectModel = ""

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function GUI.Text(text, color, position, size, center)
	SetTextCentre(center)
	SetTextColour(color[1], color[2], color[3], color[4])
	SetTextFont(color[5])
	SetTextScale(size[1], size[2])
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(position[1], position[2])
end

function GUI.Rect(color, position, size)
	DrawRect(position[1], position[2], size[1], size[2], color[1], color[2], color[3], color[4])
end

function Menu.Title(title)
	GUI.Text(title, GUI.titleText, {menuX, 0.095}, {0.85, 0.85}, true)
	GUI.Rect(GUI.titleRect, {menuX, 0.1175}, {0.27, 0.085})
end

function Menu.Option(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - 0.1, optionCount * 0.035 + 0.125},  {0.5, 0.5 }, false)
		GUI.Rect(GUI.optionRect, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, { menuX - 0.1, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, false);
		GUI.Rect(GUI.optionRect, { menuX, optionCount - (currentOption - GUI.maxVisOptions) * 0.035+0.1415 }, { 0.27, 0.035 });
		if(thisOption) then
			GUI.Rect(GUI.scroller, { menuX, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.1415 }, { 0.27, 0.035 })
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end


local lastKey = 0
function Menu.SpeOption(option)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - 0.1, optionCount * 0.035 + 0.125},  {0.5, 0.5 }, false)
		GUI.Rect(GUI.optionRect, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		if(thisOption) then

			if(lastObjectModel ~= option) then
				if(DoesEntityExist(object)) then
					DeleteObject(object)
				end


				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

				object = CreateObject(GetHashKey(option), x-0.5,y,z,  false, true, false)
				FreezeEntityPosition(object, true)
				SetEntityCollision(object, false)
				if(lastKey == 60) then
					TriggerEvent("GUI:requestGo", currentOption, function(result)
						if(result) then
							currentOption = currentOption -1
							lastObjectModel = option
						end
					end)
				end
				lastObjectModel = option
			end

			GUI.Rect(GUI.scroller, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, { menuX - 0.1, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, false);
		GUI.Rect(GUI.optionRect, { menuX, optionCount - (currentOption - GUI.maxVisOptions) * 0.035+0.1415 }, { 0.27, 0.035 });
		if(thisOption) then

			if(lastObjectModel ~= option) then
				if(DoesEntityExist(object)) then
					DeleteObject(object)
				end

				local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1)))

				object = CreateObject(GetHashKey(option), x-0.5,y,z,  false, true, false)
				FreezeEntityPosition(object, true)
				SetEntityCollision(object, false)

				if(lastKey == 60) then
					TriggerEvent("GUI:requestGo", currentOption, function(result)
						if(result) then
							currentOption = currentOption -1
							lastObjectModel = option
						end
					end)
				end
				Wait(50)
				lastObjectModel = option
			end

			GUI.Rect(GUI.scroller, { menuX, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.1415 }, { 0.27, 0.035 })
			
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end



function Menu.DelOption(option, objectToDel)
	optionCount = optionCount + 1

	local thisOption = nil
	if(currentOption == optionCount) then
		thisOption = true
	else
		thisOption = false
	end

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(option, GUI.optionText, {menuX - 0.1, optionCount * 0.035 + 0.125},  {0.5, 0.5 }, false)
		GUI.Rect(GUI.optionRect, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		if(thisOption) then

			if(DoesEntityExist(objectToDel)) then
				object = objectToDel

				TriggerEvent("GUI:requestGo", currentOption, function(result)
					if(result) then
						currentOption = currentOption -1
						lastObjectModel = option
					end
				end)
			end

			GUI.Rect(GUI.scroller, { menuX, optionCount * 0.035 + 0.1415 }, { 0.27, 0.035 })
		end
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(option, GUI.optionText, { menuX - 0.1, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, false);
		GUI.Rect(GUI.optionRect, { menuX, optionCount - (currentOption - GUI.maxVisOptions) * 0.035+0.1415 }, { 0.27, 0.035 });
		if(thisOption) then

			if(DoesEntityExist(objectToDel)) then
				object = objectToDel

				TriggerEvent("GUI:requestGo", currentOption, function(result)
					if(result) then
						currentOption = currentOption -1
						lastObjectModel = option
					end
				end)
			end

			GUI.Rect(GUI.scroller, { menuX, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.1415 }, { 0.27, 0.035 })
			
		end
	end

	if (optionCount == currentOption and selectPressed) then
		return true
	end

	return false
end



function Menu.Bool(option, bool, cb)
	Menu.Option(option)

	if(currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		end
	elseif(optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		if(bool) then
			GUI.Text("~g~ON", GUI.optionText, { menuX + 0.068, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		else
			GUI.Text("~r~OFF", GUI.optionText, { menuX + 0.068, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
		end
	end

	if (optionCount == currentOption and selectPressed) then
		cb(not bool)
		return true
	end

	return false
end

function Menu.Int(option, int, min, max, cb)
	int = round(int)
	Menu.Option(option);

	if (optionCount == currentOption) then
		if (leftPressed) then
			if(int > min) then int = round(int - 1) else int = round(max) end-- : _int = max;
		end
		if (rightPressed) then
			if(int < max) then int = round(int + 1) else int = round(min) end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(tostring(int), GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(tostring(int), GUI.optionText, { menuX + 0.068, optionCount - (currentOption - maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(int) return true
	elseif (optionCount == currentOption and leftPressed) then cb(int) return true
	elseif (optionCount == currentOption and rightPressed) then cb(int) return true end

	return false
end

function Menu.StringArray(option, array, position, cb)

	Menu.Option(option);

	if (optionCount == currentOption) then
		local max = tablelength(array)
		local min = 1
		if (leftPressed) then
			if(position >= min) then position = position - 1 else position = max end
		end
		if (rightPressed) then
			if(position < max) then position = position + 1 else position = min end
		end
	end

	if (currentOption <= GUI.maxVisOptions and optionCount <= GUI.maxVisOptions) then
		GUI.Text(array[position], GUI.optionText, { menuX + 0.068, optionCount * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	elseif (optionCount > currentOption - GUI.maxVisOptions and optionCount <= currentOption) then
		GUI.Text(array[position], GUI.optionText, { menuX + 0.068, optionCount - (currentOption - GUI.maxVisOptions) * 0.035 + 0.125 }, { 0.5, 0.5 }, true)
	end

	if (optionCount == currentOption and selectPressed) then cb(position) return true
	elseif (optionCount == currentOption and leftPressed) then cb(position) return true
	elseif (optionCount == currentOption and rightPressed) then cb(position) return true end

	return false
end

function Menu.updateSelection()
	selectPressed = false;
	leftPressed = false;
	rightPressed = false;

	if IsControlJustPressed(1, 60)  then
		if(currentOption < optionCount) then
			currentOption = currentOption + 1
		else
			currentOption = 1
		end
		lastKey = 60
	elseif IsControlJustPressed(1, 61) then
		if(currentOption > 1) then
			currentOption = currentOption - 1
		else
			currentOption = optionCount
		end
		lastKey = 61
	elseif IsControlJustPressed(1, 108) then
		leftPressed = true
	elseif IsControlJustPressed(1, 107) then
		rightPressed = true
	elseif IsControlJustPressed(1, 176)  then
		selectPressed = true
	end
	optionCount = 0
end


RegisterNetEvent("GUI:MapTitle")
AddEventHandler("GUI:MapTitle", function(title)
	Menu.Title(title)
end)

RegisterNetEvent("GUI:MapOption")
AddEventHandler("GUI:MapOption", function(option, cb)
	inOptions = false
	cb(Menu.Option(option))
end)

RegisterNetEvent("GUI:MapSpawnOption")
AddEventHandler("GUI:MapSpawnOption", function(option, cb)
	inOptions = true

	cb(Menu.SpeOption(option))
end)

RegisterNetEvent("GUI:MapDelOption")
AddEventHandler("GUI:MapDelOption", function(option, objectToDel, cb)
	inOptions = true

	cb(Menu.DelOption(option, objectToDel))
end)

RegisterNetEvent("GUI:MapBool")
AddEventHandler("GUI:MapBool", function(option, bool, cb)
	inOptions = false
	Menu.Bool(option, bool, function(data)
		cb(data)
	end)
end)

RegisterNetEvent("GUI:MapInt")
AddEventHandler("GUI:MapInt", function(option, int, min, max, cb)
	inOptions = false
	Menu.Int(option, int, min, max, function(data)
		cb(data)
	end)

end)

RegisterNetEvent("GUI:MapStringArray")
AddEventHandler("GUI:MapStringArray", function(option, array, position, cb)
	inOptions = false
	Menu.StringArray(option, array, position, function(data)
		cb(data)
	end)
	
end)

RegisterNetEvent("GUI:MapUpdate")
AddEventHandler("GUI:MapUpdate", function()
	if(askDel) then
		if(DoesEntityExist(object)) then
			DeleteObject(object)
			object = -1
			lastObjectModel = ""
		end
		askDel = false
	end
	Menu.updateSelection()
end)




function round(num, dec)
  local mult = 10^(dec or 0)
  return math.floor(num * mult + 0.5) / mult
end


function askDelete()
	askDel = true
end