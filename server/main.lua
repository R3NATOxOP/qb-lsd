local QBCore = exports['qb-core']:GetCoreObject()

TriggerEvent("QBCore:GetObject", function(obj) QBCore = obj end)

local playersProcessingMushroom = {}

RegisterServerEvent('qb-lsd:pickedMushroom')
AddEventHandler('qb-lsd:pickedMushroom', function()
	local src = source
	local Player = QBCore.Functions.GetPlayer(src)

	  if TriggerClientEvent("QBCore:Notify", src, "Picked up mushroom!!", "Success", 8000) then
		  Player.Functions.AddItem('mushroom', 1) ---- change this shit 
		  TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['mushroom'], "add")
	  end
  end)



RegisterServerEvent('qb-lsd:processMushroom')
AddEventHandler('qb-lsd:processMushroom', function()
		local src = source
    	local Player = QBCore.Functions.GetPlayer(src)

		Player.Functions.RemoveItem('mushroom', 1)----change this
		Player.Functions.RemoveItem('sodiumoxide', 1)----change this
		Player.Functions.RemoveItem('aspirine', 1)-----change this
        Player.Functions.RemoveItem('gbottle', 1)-----change this

        Player.Functions.AddItem('pmushroom', 1)-----change this
        Player.Functions.AddItem('vacid', 1)-----change this

		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['mushroom'], "remove")
		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['sodiumoxide'], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['aspirine'], "remove")
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['gbottle'], "remove")

		TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['pmushroom'], "add")
        TriggerClientEvent("inventory:client:ItemBox", source, QBCore.Shared.Items['vacid'], "add")
		TriggerClientEvent('QBCore:Notify', src, 'mushroom_processed', "success")                                                                         				
end)



function CancelProcessing(playerId)
	if playersProcessingMushroom[playerId] then
		ClearTimeout(playersProcessingMushroom[playerId])
		playersProcessingMushroom[playerId] = nil
	end
end

RegisterServerEvent('qb-lsd:cancelProcessing')
AddEventHandler('qb-lsd:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('qb-lsd:playerDropped', function(playerId, reason)
	CancelProcessing(playerId)
end)

RegisterServerEvent('qb-lsd:onPlayerDeath')
AddEventHandler('qb-lsd:onPlayerDeath', function(data)
	local src = source
	CancelProcessing(src)
end)


QBCore.Functions.CreateCallback('mushroom:ingredient', function(source, cb)
    local src = source
    local Ply = QBCore.Functions.GetPlayer(src)
    local mushroom = Ply.Functions.GetItemByName("mushroom")
	local sodiumoxide = Ply.Functions.GetItemByName("sodiumoxide")
	local aspirine = Ply.Functions.GetItemByName("aspirine")
    local gbottle = Ply.Functions.GetItemByName("gbottle")

    if mushroom ~= nil and sodiumoxide ~= nil and aspirine ~= nil and gbottle ~= nil then
        cb(true)
    else
        cb(false)
    end
end)
