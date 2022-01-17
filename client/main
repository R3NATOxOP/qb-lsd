local QBCore = exports['qb-core']:GetCoreObject()
isLoggedIn = true

local menuOpen = false
local wasOpen = false

Citizen.CreateThread(function() 
    while true do
        Citizen.Wait(10)
        if QBCore == nil then
            TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)    
            Citizen.Wait(200)
        end
    end
end)

local spawnedMushrooms = 0
local mushroomGrowth = {}
local isPickingUp, isProcessing = false, false

local f = true
local b = 0


function DrawText2D(x, y, text)  
			SetTextFont(0)
			SetTextProportional(1)
			SetTextScale(0.0, 0.3)
			SetTextColour(128, 128, 128, 255)
			SetTextDropshadow(0, 0, 0, 0, 255)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextDropShadow()
			SetTextOutline()
			SetTextEntry("STRING")
			DrawText(x, y)

end

Citizen.CreateThread(
    function()
        local g = false
        while true do
            Citizen.Wait(5000)
            if f then
				local h = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), Config.CircleZones.MushroomField.coords, true)
                if h < 100 and not g then
                    SpawnmushroomGrowth()
                    g = true
                elseif h > 250 and g then
                    Citizen.Wait(900000)
                    g = false
                end
            else
                Citizen.Wait(10000)
            end
        end
    end
)

RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)

		if GetDistanceBetweenCoords(coords, Config.CircleZones.MushroomProcessing.coords, true) < 0.5 then

			DrawText3D(Config.CircleZones.MushroomProcessing.coords.x, Config.CircleZones.MushroomProcessing.coords.y, Config.CircleZones.MushroomProcessing.coords.z, 'Press ~r~[ E ] to process')


			if IsControlJustReleased(0, 38) and not isProcessing then
				QBCore.Functions.TriggerCallback('mushroom:ingredient', function(HasItem, type)
					if HasItem then
						ProcessMushroom()
					else
						QBCore.Functions.Notify('You dont have enough Materials', 'error')
					end
				end)
			end
		else
			Citizen.Wait(500)
		end
	end
end)

function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(true)
	AddTextComponentString(text)
	SetDrawOrigin(x,y,z, 0)
	DrawText(0.0, 0.0)
	local factor = (string.len(text)) / 370
	DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
	ClearDrawOrigin()
end

function ProcessMushroom()
	isProcessing = true
	local playerPed = PlayerPedId()

	
	TaskStartScenarioInPlace(playerPed, "PROP_HUMAN_PARKING_METER", 0, true)

	QBCore.Functions.Progressbar("search_register", "Processing..", 15000, false, true, {
		disableMovement = true,
		disableCarMovement = true,
		disableMouse = false,
		disableCombat = true,
	}, {}, {}, {}, function() -- Done
		QBCore.Functions.TriggerCallback('mushroom:ingredient', function(HasItem, type)
			if HasItem then	
				TriggerServerEvent('qb-lsd:processMushroom')
			else
				QBCore.Functions.Notify("You dont have enough Materials", "error")
				FreezeEntityPosition(GetPlayerPed(-1),false)
			end
		end)
		
		local timeLeft = Config.Delays.MushroomProcessing / 1000

		while timeLeft > 0 do
			Citizen.Wait(1000)
			timeLeft = timeLeft - 1

			if GetDistanceBetweenCoords(GetEntityCoords(playerPed), Config.CircleZones.MushroomProcessing.coords, false) > 4 then
				TriggerServerEvent('qb-lsd:cancelProcessing')
				break
			end
		end
		ClearPedTasks(GetPlayerPed(-1))
	end, function()
		ClearPedTasks(GetPlayerPed(-1))
	end) -- Cancel
		
	
	isProcessing = false
end



-- Mushroom Grown

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)

		local playerPed = PlayerPedId()
		local coords = GetEntityCoords(playerPed)
		local nearbyObject, nearbyID

		for i=1, #mushroomGrowth, 1 do
			if GetDistanceBetweenCoords(coords, GetEntityCoords(mushroomGrowth[i]), false) < 1 then
				nearbyObject, nearbyID = mushroomGrowth[i], i
			end
		end

		if nearbyObject and IsPedOnFoot(playerPed) then

			if not isPickingUp then
				DrawText2D(0.4, 0.8, '~w~Press ~g~[E]~w~ to pickup Mushroom')
			end

			if IsControlJustReleased(0, 38) and not isPickingUp then
				isPickingUp = true
				TaskStartScenarioInPlace(playerPed, 'world_human_gardener_plant', 0, false)

				QBCore.Functions.Notify("wait please have patience", "error", 10000)
				QBCore.Functions.Progressbar("search_register", "Picking up Mushroom..", 10000, false, true, {
					disableMovement = true,
					disableCarMovement = true,
					disableMouse = false,
					disableCombat = true,
				}, {}, {}, {}, function() -- Done
					ClearPedTasks(GetPlayerPed(-1))
					DeleteObject(nearbyObject)

					table.remove(mushroomGrowth, nearbyID)
					spawnedMushrooms = spawnedMushrooms - 1
	
					TriggerServerEvent('qb-lsd:pickedMushroom')
					

				end, function()
					ClearPedTasks(GetPlayerPed(-1))
				end) -- Cancel

				isPickingUp = false
			end
		else
			Citizen.Wait(500)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(mushroomGrowth) do
			DeleteObject(v)
		end
	end
end)

function SpawnmushroomGrowth()
	
	math.randomseed(GetGameTimer())
    local random = math.random(20, 30)
	print(random)
    RequestModel(3267161942)
    while not HasModelLoaded(3267161942) do
        Citizen.Wait(1)
    end
    while b < random do
		Citizen.Wait(1)
		local D = GenerateMushroomCoords()
		

        local E = CreateObject(3267161942, Config.CircleZones.MushroomField.coords.x + math.random(-tonumber(Config.CircleZones.MushroomField.radius), tonumber(Config.CircleZones.MushroomField.radius)), Config.CircleZones.MushroomField.coords.y + math.random(-tonumber(Config.CircleZones.MushroomField.radius), tonumber(Config.CircleZones.MushroomField.radius)), D.z +45.0, false, false, true)
        PlaceObjectOnGroundProperly(E)
        FreezeEntityPosition(E, true)
        table.insert(mushroomGrowth, E)
        b = b + 1
    end
end

function ValidateMushroomCoord(growthCoords)
	if spawnedMushrooms > 0 then
		
		local validate = true

		for k, v in pairs(mushroomGrowth) do
			if GetDistanceBetweenCoords(growthCoords, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(growthCoords, Config.CircleZones.MushroomField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateMushroomCoords()
	while true do
		Citizen.Wait(1)

		local mushroomCoordX, mushroomCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-90, 90)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-90, 90)
		mushroomCoordX = Config.CircleZones.MushroomField.coords.x + modX
		mushroomCoordY = Config.CircleZones.MushroomField.coords.y + modY

		local coordZ = GetCoordZ(mushroomCoordX, mushroomCoordY)
		local coord = vector3(mushroomCoordX, mushroomCoordY, coordZ)

		if ValidateMushroomCoord(coord) then
			return coord
		end
	end
end


function GetCoordZ(x, y)
    local groundCheckHeights = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0 }
	for i, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

        if foundGround then
            return z
        end
    end

    return 1.0
end
