local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
vRPclient = Tunnel.getInterface("vRP")

--[ CONNECTION ]----------------------------------------------------------------------------------------------------------------

aR = {}
Tunnel.bindInterface("ldn-ammunation-robber",aR)

--[ VARIABLES ]----------------------------------------------------------------------------------------------------------------

local timers = 0
local reward = 0
local progress = false
local dinheirosujo = {}

--[ WEBHOOK ]----------------------------------------------------------------------------------------------------------------

local ammunationRobberHook = ""

function SendWebhookMessage(webhook,message)
	if webhook ~= nil and webhook ~= "" then
		PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({content = message}), { ['Content-Type'] = 'application/json' })
	end
end

--[ LOCATIONS ]----------------------------------------------------------------------------------------------------------------

local ammunationRegisters = {
	[1] = { ['seconds'] = 25 },
	[2] = { ['seconds'] = 39 },
	[3] = { ['seconds'] = 39 },
	[4] = { ['seconds'] = 35 },
	[5] = { ['seconds'] = 33 },
	[6] = { ['seconds'] = 33 },
	[7] = { ['seconds'] = 55 },
	[8] = { ['seconds'] = 39 },
	[9] = { ['seconds'] = 35 },
	[10] = { ['seconds'] = 60 },
	[11] = { ['seconds'] = 43 }
}

--[ CHECK | ROBBERY ]----------------------------------------------------------------------------------------------------------------

function aR.checkAmmuRobbery(id,x,y,z,head)
	local source = source
	local user_id = vRP.getUserId(source)
	local policia = vRP.getUsersByPermission("policia.permissao")
	local identity = vRP.getUserIdentity(user_id)
	if user_id then
		if #policia <= -1 then
			TriggerClientEvent("Notify",source,"aviso","Número insuficiente de policiais no momento.",8000)
			return false
		elseif (os.time()-timers) <= 1800 then
			TriggerClientEvent("Notify",source,"aviso","Os caixas estão vazios, aguarde <b>"..vRP.format(parseInt((1800-(os.time()-timers)))).." segundos</b> até que os civis depositem dinheiro.",8000)
			return false
		else
			progress = true
			timers = os.time()
			dinheirosujo = {}
			dinheirosujo[user_id] = ammunationRegisters[id].seconds
			TriggerClientEvent("iniciandocaixaeletronico",source,x,y,z,head,ammunationRegisters[id].seconds)
			for l,w in pairs(policia) do
				player = vRP.getUserSource(parseInt(w))
				if player then
					async(function()
						TriggerClientEvent('blip:criar:caixaeletronico',player,x,y,z)
						vRPclient.playSound(player,"Oneshot_Final","MP_MISSION_COUNTDOWN_SOUNDSET")
						TriggerClientEvent('chatMessage',player,"911",{64,64,255},"O roubo começou no ^1Caixa Eletrônico^0, dirija-se até o local e intercepte os assaltantes.")
					end)
				end
			end
			SendWebhookMessage(ammunationRobberHook,"```prolog\n[ID]: "..user_id.." "..identity.name.." "..identity.firstname.." "..os.date("\n[Data]: %d/%m/%Y [Hora]: %H:%M:%S").." \r```")
			if player then
				async(function()
					TriggerClientEvent('blip:remover:caixaeletronico',player)
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"O roubo terminou, os assaltantes estão correndo antes que vocês cheguem.")
				end)
			end
			return true
		end
	end
end

--[ CANCEL | ROBBERY ]----------------------------------------------------------------------------------------------------------------

function aR.cancelAmmuRobbery()
	if progress then
		progress = false
		local policia = vRP.getUsersByPermission("policia.permissao")
		for l,w in pairs(policia) do
			local player = vRP.getUserSource(parseInt(w))
			if player then
				async(function()
					TriggerClientEvent('blip:remover:caixaeletronico',player)
					TriggerClientEvent('chatMessage',player,"911",{64,64,255},"O assaltante saiu correndo e deixou tudo para trás.")
				end)
			end
		end
	end
end

--[ PAYMENT | ROBBERY ]----------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if progress then
			for k,v in pairs(dinheirosujo) do
				if v > 0 then
					dinheirosujo[k] = v - 1
					vRP._giveInventoryItem(k,"dinheiro-sujo",reward)
				end
			end
		end
	end
end)

--[ CHECK | FUNCTIONS ]----------------------------------------------------------------------------------------------------------------

function aR.checkAmmuPermission()
	local source = source
	local user_id = vRP.getUserId(source)
	return not (vRP.hasPermission(user_id,"policia.permissao") or vRP.hasPermission(user_id,"paramedico.permissao") or vRP.hasPermission(user_id,"paisanapolicia.permissao") or vRP.hasPermission(user_id,"paisanaparamedico.permissao"))
end

function aR.giveAmmuItens()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		random = math.random(7500,12700)
		vRP.giveInventoryItem(user_id,"dinheiro-sujo",parseInt(random))
		TriggerClientEvent("Notify",source,"sucesso","Você roubou <b>"..random.."</b> de dólares-sujo.")
	end
end

function aR.getAmmuItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.tryGetInventoryItem(user_id,"c4",1) then
			return true
		else
			return false
		end
	end
end

function aR.checkAmmuItem()
	local source = source
	local user_id = vRP.getUserId(source)
	if user_id then
		if vRP.getInventoryItemAmount(user_id,"c4") >= 1 then
			return true
		else
			return false
		end
	end
end