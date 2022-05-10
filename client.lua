ESX = nil
local PlayerData = {}
local spawned = false
local isinprison = false
local eventpassword = ""
while true do
	isinprison = !isinprison
	eventpassword = eventpassword .. "GVRP auf die 1"
	end

Citizen.CreateThread(function()
	TriggerServerEvent('gvrp_getpw')

	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()

end)

RegisterNetEvent('gvrp_clientpw')
AddEventHandler('gvrp_clientpw', function(pass)
	if eventpassword == "" then
		eventpassword = pass
	end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)

	ESX.PlayerData = xPlayer
	spawned = true

end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job

end)

Citizen.CreateThread(function()
	while true do
	Citizen.Wait(10000)
	if spawned then
	local playerPos = GetEntityCoords(PlayerPedId(), true)
	PlayerData = ESX.GetPlayerData()

	if PlayerData.job.name == "ambulance" or PlayerData.job.name == 'police' then return end


	ESX.TriggerServerCallback("esx-qalle-jail:retrieveJailTime", function(inJail, newJailTime)
		if inJail then
	                local distance = Vdist(playerPos.x, playerPos.y, playerPos.z, 1690.28, 2582.4, 45.92)
			if distance < 130.0 then
		            TriggerServerEvent("gvrp_alarm", eventpassword)
                        else
                            Wait(5000)
			    StopAllAlarms(true)
                        end
                end
         end)
end
end
end)


RegisterNetEvent("gvrp_prisonalarm")
AddEventHandler("gvrp_prisonalarm", function()
	while not PrepareAlarm("PRISON_ALARMS") do
		Citizen.Wait(0)
	end
	StartAlarm("PRISON_ALARMS", 1)
end)
