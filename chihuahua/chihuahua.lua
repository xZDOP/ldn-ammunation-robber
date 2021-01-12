local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

aR = Tunnel.getInterface("ldn-ammunation-robber")

--[ VARIABLES ]----------------------------------------------------------------------------------------------------------------

local progress = false
local ammuTime = 0
local seconds = 0
local robberMD = 0

--[ ROBBER LOCATION ]----------------------------------------------------------------------------------------------------------------

local locations = {
	{ ['id'] = 1, ['x'] = 1691.29, ['y'] = 3757.76, ['z'] = 34.71, ['h'] = 134.66 },
	{ ['id'] = 2, ['x'] = 253.4, ['y'] = -47.41, ['z'] = 69.95, ['h'] = 342.06 }, 
	{ ['id'] = 3, ['x'] = 845.41, ['y'] = -1033.82, ['z'] = 28.2, ['h'] = 266.83 }, 
	{ ['id'] = 4, ['x'] = -332.73, ['y'] = 6081.72, ['z'] = 31.46, ['h'] = 130.45 }, 
	{ ['id'] = 5, ['x'] = -665.43, ['y'] = -935.11, ['z'] = 21.83, ['h'] = 89.62 }, 
	{ ['id'] = 6, ['x'] = -1304.78, ['y'] = -391.22, ['z'] = 36.7, ['h'] = 342.23 }, 
	{ ['id'] = 7, ['x'] = -1120.27, ['y'] = 2696.55, ['z'] = 18.56, ['h'] = 128.94 }, 
	{ ['id'] = 8, ['x'] = 2571.06, ['y'] = 294.15, ['z'] = 108.74, ['h'] = 269.56 }, 
	{ ['id'] = 9, ['x'] = -3173.38, ['y'] = 1084.91, ['z'] = 20.84, ['h'] = 154.15 }, 
	{ ['id'] = 10, ['x'] = 4.56, ['y'] = -1108.58, ['z'] = 29.8, ['h'] = 109.52 }, 
	{ ['id'] = 11, ['x'] = 826.17, ['y'] = -2149.93, ['z'] = 29.62, ['h'] = 310.09 }
}

local locationsBlips = {
	{ ['id'] = 1, ['x'] = 1690.88, ['y'] = 3757.52, ['z'] = 34.71 },
	{ ['id'] = 2, ['x'] = 253.84, ['y'] = -46.83, ['z'] = 69.95 },
	{ ['id'] = 3, ['x'] = 845.76, ['y'] = -1034.04, ['z'] = 28.2 },
	{ ['id'] = 4, ['x'] = -333.05, ['y'] = 6081.75, ['z'] = 31.46 },
	{ ['id'] = 5, ['x'] = -665.77, ['y'] = -934.81, ['z'] = 21.83 }, 
	{ ['id'] = 6, ['x'] = -1304.47, ['y'] = -391.05, ['z'] = 36.7 },
	{ ['id'] = 7, ['x'] = -1120.61, ['y'] = 2696.51, ['z'] = 18.56 },
	{ ['id'] = 8, ['x'] = 2571.44, ['y'] = 293.9, ['z'] = 108.74 },
	{ ['id'] = 9, ['x'] = -3173.71, ['y'] = 1084.7, ['z'] = 20.84 },
	{ ['id'] = 10, ['x'] = 3.87, ['y'] = -1108.5, ['z'] = 29.8 }, 
	{ ['id'] = 11, ['x'] = 826.85, ['y'] = -2149.84, ['z'] = 29.62 }
}

--[ START/CANCEL ]----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5)
		local ped = PlayerPedId()
		local x,y,z = GetEntityCoords(ped)
		if GetSelectedPedWeapon(ped) == GetHashKey("WEAPON_UNARMED") and not IsPedInAnyVehicle(ped) then
			for k,v in pairs(locations) do
				if Vdist(v.x,v.y,v.z,x,y,z) <= 1 and not progress then
					if IsControlJustPressed(0,47) and aR.checkAmmuPermission() then
						if aR.checkAmmuItem() then
							if aR.checkAmmuRobbery(v.id,v.x,v.y,v.z,v.h) then
								aR.getAmmuItem()
								SetEntityCoords(ped,v.x,v.y,v.z-1,false,false,false,false)
								SetEntityHeading(ped,v.h)
								if v.id == 1 then
									t_roubo = 25
								elseif v.id == 2 or v.id == 3 or v.id == 8 then
									t_roubo = 39
								elseif v.id == 4 or v.id == 9 then
									t_roubo = 35
								elseif v.id == 5 or v.id == 6 then
									t_roubo = 33
								elseif v.id == 7 then
									t_roubo = 55
								elseif v.id == 10 then
									t_roubo = 60
								elseif v.id == 11 then
									t_roubo = 43
								end
								local distance = GetDistanceBetweenCoords(v.x, v.y, v.z, x,y,z,true)
								if distance <= 3 then
									TaskGoStraightToCoord(ped, v.x,v.y,v.z,1.0, 100000, v.h, 2.0)
									if distance <= 0.3 then
									  ClearPedTasks(ped)
									 --[[ SetEntityHeading(ped, v.h)
									  SetEntityCoords(ped,v.x,v.y,v.z-1,false,false,false,false)]]
									end
								end
								local ped = PlayerPedId()
								local thermal_hash = GetHashKey("hei_prop_heist_thermite_flash")
								local bagHash4 = GetHashKey('p_ld_heist_bag_s_pro_o')
								local coords = GetEntityCoords(ped)
								loadModel(thermal_hash)
								Wait(10)
								loadModel(bagHash4)
								Wait(10)

								thermalentity = CreateObject(thermal_hash, (v.x+v.y+v.z)-20, true, true)
								local bagProp4 = CreateObject(bagHash4, coords-20, true, false)
								SetEntityAsMissionEntity(thermalentity, true, true)
								SetEntityAsMissionEntity(bagProp4, true, true)
								termitacolocando = true
								local boneIndexf1 = GetPedBoneIndex(PlayerPedId(), 28422)
								local bagIndex1 = GetPedBoneIndex(PlayerPedId(), 57005)
								Wait(500)
								SetPedComponentVariation(PlayerPedId(), 5, 0, 0, 0)
								AttachEntityToEntity(thermalentity, PlayerPedId(), boneIndexf1, 0.0, 0.0, 0.0, 180.0, 180.0, 0, 1, 1, 0, 1, 1, 1)
								AttachEntityToEntity(bagProp4, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)


								RequestAnimDict('anim@heists@ornate_bank@thermal_charge')
								while not HasAnimDictLoaded('anim@heists@ornate_bank@thermal_charge') do
									Wait(100)
								end
								vRP._playAnim(false,{{'anim@heists@ornate_bank@thermal_charge','thermal_charge'}},false)


								Wait(2500)
								DetachEntity(bagProp4, 1, 1)
								FreezeEntityPosition(bagProp4, true)
								Wait(2500)
								FreezeEntityPosition(bagProp4, false)
								AttachEntityToEntity(bagProp4, PlayerPedId(), bagIndex1, 0.3, -0.25, -0.3, 300.0, 200.0, 300.0, true, true, false, true, 1, true)
								Wait(1000)
								DeleteEntity(bagProp4)
								SetPedComponentVariation(PlayerPedId(), 5, 40, 0, 0)
								DeleteEntity(thermalentity)
								ClearPedTasks(player)
								progress = true	
								TriggerEvent("Notify","importante","Você plantou a bomba! Cuidado com a explosão...")
								contador_id = 0		
								while contador_id <= t_roubo do
									if t_roubo == 25 then
										TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
										Wait(25000)
										contador_id = t_roubo + 1
									elseif t_roubo == 39 then
										if contador_id <= 14 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 35 then
										if contador_id <= 10 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 33 then
										if contador_id <= 8 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end	
									elseif t_roubo == 55 then
										if contador_id <= 20 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 60 then
										if contador_id <= 35 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									elseif t_roubo == 43 then
										if contador_id <= 18 then
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)  
											Wait(1000)
										else
											TriggerEvent("vrp_sound:distance", source, 0.8, 'bomb_25', 0.5)
											Wait(25000)
											contador_id = t_roubo + 1
										end
									end
									contador_id = contador_id + 1
								end
								AddExplosion(v.x,v.y,v.z,2 , 100.0, true, false, true)
								local dinheiro_prop = "hei_prop_heist_cash_pile"
								RequestModel(dinheiro_prop)
								while not HasModelLoaded(dinheiro_prop) do
									Citizen.Wait(10)
								end
								if not HasModelLoaded(dinheiro_prop) then
									SetModelAsNoLongerNeeded(dinheiro_prop)
								else
									SetModelAsNoLongerNeeded(dinheiro_prop)
									contador = 4
									contador_dinheiro_spawn = 4
									local boneIndex = GetPedBoneIndex(PlayerPedId(), 57005)
									while contador >= 0 do 
										Citizen.Wait(10)
										local ped = PlayerPedId()
										x,y,z = table.unpack(GetEntityCoords(ped))
										distance2 = GetDistanceBetweenCoords(v.x,v.y,v.z,x,y,z,true)
										if contador_dinheiro_spawn >= 0 then
											dinheiro_object = CreateObjectNoOffset(dinheiro_prop, v.x, v.y, v.z, 1, 0, 1)
											x2,y2,z2 = table.unpack(GetEntityCoords(dinheiro_object))
											contador_dinheiro_spawn = contador_dinheiro_spawn - 1
										end
										if distance2 <= 3 then
											DrawText3D(x2,y2,z2-0.8,"~b~[G] ~w~PEGAR")
											if IsControlJustPressed(0,47) and not IsPedInAnyVehicle(ped) and not IsEntityDead(ped) then
												vRP._playAnim(false,{{'pickup_object','pickup_low'}},false)
												Wait(1000)
												SetEntityVisible(dinheiro_object, true)
												aR.giveAmmuItens()
												AttachEntityToEntity(dinheiro_object, PlayerPedId(), boneIndex, 0.125, 0.0, -0.05, 360.0, 150.0, 360.0, true, true, false, true, 1, true)
												Wait(800)
												SetEntityVisible(dinheiro_object, false)
												contador = contador - 1
											end
										elseif Vdist(v.x,v.y,v.z,x,y,z) > 15 then
											aR.cancelAmmuRobbery()
											TriggerEvent("Notify","negado","Você fugiu do roubo e deixou tudo para trás.")
											contador = -1
										end
									end
									DeleteEntity(dinheiro_object)
								end
							end
						else
							TriggerEvent("Notify","negado","Você não possui um <b>Explosivo (C4)</b>.") 
						end
					end
				end
			end
		end
	end
end)

--[ SHOW | BLIP ]-------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		local idle = 1000
		for k,v in pairs(locationsBlips) do
			local ped = PlayerPedId()
			local x,y,z = table.unpack(GetEntityCoords(ped))
			local bowz,cdz = GetGroundZFor_3dCoord(v.x,v.y,v.z)
			local distance = GetDistanceBetweenCoords(v.x,v.y,cdz,x,y,z,true)
			local locationsBlips = locationsBlips[k]
			
				if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), locationsBlips.x, locationsBlips.y, locationsBlips.z, true ) <= 1.5 and not progress then
					idle = 5
					DrawText3D(locationsBlips.x, locationsBlips.y, locationsBlips.z, "PRESSIONE ~g~G~w~ PARA EXPLODIR O ~g~COFRE~w~")
				end
			end
		Citizen.Wait(idle)
	end
end)

--[ STARTING ]----------------------------------------------------------------------------------------------------------------

RegisterNetEvent("iniciandocaixaeletronico")
AddEventHandler("iniciandocaixaeletronico",function(x,y,z,head,secs)
	seconds = secs
	--progress = true
	SetEntityCoords(PlayerPedId(),x,y,z-1,false,false,false,false)
	SetEntityHeading(PlayerPedId(),head)
	SetPedComponentVariation(PlayerPedId(),5,45,0,2)
	-- TriggerEvent('cancelando',true)
end)


--[ SCORE ]----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if progress then
			seconds = seconds - 1
			if seconds <= 0 then
				progress = false
				ClearPedTasks(PlayerPedId())
				TriggerEvent('cancelando',false)
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		local timeDistance = 750
		if progress then
			for k,v in pairs(locationsBlips) do
				local distance = #(GetEntityCoords(PlayerPedId()) - vector3(v.x,v.y,v.z))		

				if distance <= 10 then 
					timeDistance = 5
					DrawText3D(v.x,v.y,v.z,"AFASTE-SE... A ~g~BOMBA~w~, EM ~g~"..seconds.." SEGUNDOS ~w~ EXPLODIRÁ")
				end 
			end
		end
		Citizen.Wait(timeDistance)
	end
end)
--[ FUNCTIONS ]----------------------------------------------------------------------------------------------------------------

function drawTxt(text,font,x,y,scale,r,g,b,a)
	SetTextFont(font)
	SetTextScale(scale,scale)
	SetTextColour(r,g,b,a)
	SetTextOutline()
	SetTextCentre(1)
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x,y)
end

function DrawText3D(x,y,z, text)
	local onScreen,_x,_y=World3dToScreen2d(x,y,z)
	local px,py,pz=table.unpack(GetGameplayCamCoords())
	
	SetTextScale(0.28, 0.28)
	SetTextFont(4)
	SetTextProportional(1)
	SetTextColour(255, 255, 255, 215)
	SetTextEntry("STRING")
	SetTextCentre(1)
	AddTextComponentString(text)
	DrawText(_x,_y)
	local factor = (string.len(text)) / 370
	DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 41, 11, 41, 68)
end

function loadModel(model)
    Citizen.CreateThread(function()
        while not HasModelLoaded(model) do
            RequestModel(model)
          Citizen.Wait(1)
        end
    end)
end

--[ THREAD | COOLDOWN ]----------------------------------------------------------------------------------------------------------------

--[[Citizen.CreateThread(function()
	while true do
			Citizen.Wait(1000)
			if processoleiteiro then
					if segundosleiteiro > 0 then
							segundosleiteiro = segundosleiteiro - 1
							if segundosleiteiro == 0 then
									processoleiteiro = false
							end
					end
			end
	end
end)]]

--[ MARKER ]----------------------------------------------------------------------------------------------------------------

local blip = nil
RegisterNetEvent('blip:criar:caixaeletronico')
AddEventHandler('blip:criar:caixaeletronico',function(x,y,z)
	if not DoesBlipExist(blip) then
		blip = AddBlipForCoord(x,y,z)
		SetBlipScale(blip,0.5)
		SetBlipSprite(blip,1)
		SetBlipColour(blip,59)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString("Roubo: Caixa Eletrônico")
		EndTextCommandSetBlipName(blip)
		SetBlipAsShortRange(blip,false)
		SetBlipRoute(blip,true)
	end
end)

RegisterNetEvent('blip:remover:caixaeletronico')
AddEventHandler('blip:remover:caixaeletronico',function()
	if DoesBlipExist(blip) then
		RemoveBlip(blip)
		blip = nil
	end
end)