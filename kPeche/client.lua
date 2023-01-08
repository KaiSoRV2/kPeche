
ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

local MenuShopOuvert = false
local MenuPrincipal = RageUI.CreateMenu("", "Magasin de Pêche")
MenuPrincipal.Closed = function() MenuShopOuvert = false FreezeEntityPosition(PlayerPedId(), false) end
SpawnVehicleVerif = false

function ShopMenu()
    if MenuShopOuvert then 
        MenuShopOuvert = false 
        return 
    else
        MenuShopOuvert = true 
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(MenuPrincipal, true)
        Citizen.CreateThread(function()
            while MenuShopOuvert do 
                RageUI.IsVisible(MenuPrincipal, function()
                    RageUI.Separator("~b~ ↓ Catalogue Magasin de Pêche ↓")
                    for k, v in pairs(Config.Shop) do 
                        RageUI.Button(v.name, nil, {RightLabel = "~r~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                            onSelected = function()
                                TriggerServerEvent("kPeche:AchatsItems", v.item, v.name, v.price)
                            end,
                        })    
                    end

                    RageUI.Separator("~b~ ↓ Louer un Bateau pour Pêcher ↓")

                    for k, v in pairs(Config.Garage) do
                        RageUI.Button(v.label, nil, {RightLabel = "~r~"..ESX.Math.GroupDigits(v.price).."$"}, true, {
                            onSelected = function()
                                if SpawnVehicleVerif == false then
                                    TriggerServerEvent("kPeche:LouerBateau", v.label, v.price)
                                    price_caution = v.caution
                                    bateau = v.name
                                    SpawnVehicle(bateau)
                                    RageUI.CloseAll()
                                    MenuShopOuvert = false
                                    FreezeEntityPosition(PlayerPedId(), false)
                                else 
                                    ESX.ShowNotification("Vous avez déjà une location en cours !")
                                    RageUI.CloseAll()
                                    MenuShopOuvert = false
                                    FreezeEntityPosition(PlayerPedId(), false)
                                end
                            end,
                        })
                    end

                end)
                Wait(1.0)
            end
        end)
    end
end


--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Ped - Shop ] --
--------------------------------------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    for k, v in pairs(Config.Ped) do 
        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.position, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do  
        local wait = 750
        for k, v in pairs(Config.Ped) do 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.position.x, v.position.y, v.position.z)
            if dist <= 3.0 then 
                wait = 0
                Draw3DText(v.position.x, v.position.y, v.position.z-0.600, v.TalkPed, 4, 0.1, 0.05)
                if IsControlJustPressed(1,51) then
                    ShopMenu()
                    MenuShopOuvert = true
                end
            end
        end
    Citizen.Wait(wait)
    end
end)


--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Ped - Acheteur ] --
--------------------------------------------------------------------------------------------------------------------------
 
local MenuVenteOuvert = false
local MenuPrincipal = RageUI.CreateMenu("", "Magasin de Pêche")
MenuPrincipal.Closed = function() MenuVenteOuvert = false FreezeEntityPosition(PlayerPedId(), false) end

function VenteMenu()
    if MenuVenteOuvert then 
        MenuVenteOuvert = false 
        return 
    else
        MenuVenteOuvert = true 
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(MenuPrincipal, true)
        Citizen.CreateThread(function()
            while MenuVenteOuvert do 
                RageUI.IsVisible(MenuPrincipal, function()
                    RageUI.Separator("~b~ ↓ Vendre vos Poissons ↓")
                    RageUI.Button("Vendre l'intégralité de vos Poissons", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true, {
                        onSelected = function()
                        for k, v in pairs(Config.Vente) do 
                            TriggerServerEvent("kPeche:VentePoissons", v.item, v.name, v.price)
                        end
                    end,
                    })    
                end)
                Wait(1.0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.Ped2) do 
        while not HasModelLoaded(v.pedModel) do
            RequestModel(v.pedModel)
            Wait(1)
        end
        Ped = CreatePed(2, GetHashKey(v.pedModel), v.position, v.heading, 0, 0)
        FreezeEntityPosition(Ped, 1)
        TaskStartScenarioInPlace(Ped, v.pedModel, 0, false)
        SetEntityInvincible(Ped, true)
        SetBlockingOfNonTemporaryEvents(Ped, 1)
    end
    while true do  
        local wait = 750
        for k, v in pairs(Config.Ped2) do 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, v.position.x, v.position.y, v.position.z)
            if dist <= 3.0 then 
                wait = 0
                Draw3DText(v.position.x, v.position.y, v.position.z-0.600, v.TalkPed, 4, 0.1, 0.05)
                if IsControlJustPressed(1,51) then
                    VenteMenu()
                    MenuVenteOuvert = true
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Fonction DrawText ] --
--------------------------------------------------------------------------------------------------------------------------
 
function Draw3DText(x,y,z,textInput,fontId,scaleX,scaleY)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = GetDistanceBetweenCoords(px,py,pz, x,y,z, 1)    
    local scale = (1/dist)*20
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov   
    SetTextScale(scaleX*scale, scaleY*scale)
    SetTextFont(fontId)
    SetTextProportional(1)
    SetTextColour(250, 250, 250, 255)      
    SetTextDropshadow(1, 1, 1, 1, 255)
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

--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Config Blips ] --
--------------------------------------------------------------------------------------------------------------------------
 

local blips = {
    {title = Config.Blips.BlipsMaps.Title, colour = Config.Blips.BlipsMaps.Color, id = Config.Blips.BlipsMaps.Type, x = Config.Blips.BlipsMaps.Position.x, y = Config.Blips.BlipsMaps.Position.y, z = Config.Blips.BlipsMaps.Position.z, radius = 100.01}
}

Citizen.CreateThread(function()
    for _, info in pairs(blips) do
        info.blip = AddBlipForCoord(info.x, info.y, info.z)
        SetBlipSprite(info.blip, info.id)
        SetBlipDisplay(info.blip, 4)
        SetBlipScale(info.blip, 0.9)
        SetBlipColour(info.blip, info.colour)
        SetBlipAsShortRange(info.blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(info.title)
        EndTextCommandSetBlipName(info.blip)

        info.blip = AddBlipForRadius(info.x, info.y, info.z, info.radius)
        SetBlipColour(info.blip, info.colour)
        SetBlipAlpha(info.blip, 44)
    end

end)


--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Fonction Spawn Vehicule ] --
--------------------------------------------------------------------------------------------------------------------------

function SpawnVehicle(x, y, z)  

    local vehicle = bateau
	local typevehicule = GetHashKey(vehicle)                                                   
	RequestModel(typevehicule)
	while not HasModelLoaded(typevehicule) do
		Wait(1)
	end

	if not DoesEntityExist(typevehicule) then
        SpawnVehicleVerif = true

        for k, v in pairs(Config.Garage) do 
            if v.name == vehicle then 
                Boat_Vehicle = CreateVehicle(typevehicule, v.spawnpos, v.Heading_Bateau, true, false)   
            end 
        end 

        ClearAreaOfVehicles(GetEntityCoords(Boat_Vehicle), 5000, false, false, false, false, false);  
        SetVehicleOnGroundProperly(Boat_Vehicle)
		SetVehicleNumberPlateText(Boat_Vehicle, "Pêche")
		SetEntityAsMissionEntity(Boat_Vehicle, true, true)
		SetVehicleEngineOn(Boat_Vehicle, true, true, false)

        FreezeEntityPosition(Boat_Vehicle, true)
                	
        Boat_Vehicle_Blip = AddBlipForEntity(Boat_Vehicle)                                                        	
        SetBlipFlashes(Boat_Vehicle_Blip, true)  
        SetBlipColour(Boat_Vehicle_Blip, 5)

    end 

end

--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Config de la Pêche ] --
--------------------------------------------------------------------------------------------------------------------------

function Peche()
    local xPlayer = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    ESX.TriggerServerCallback('kPeche:AssezCAP', function(hasEnoughCAP) 
        if hasEnoughCAP then  
            ESX.TriggerServerCallback('kPeche:AssezAppats', function(hasEnoughAppats)
                if hasEnoughAppats then
                    FreezeEntityPosition(PlayerPedId(), true)
                    RequestAnimDict('amb@world_human_stand_fishing@idle_a')
                    while not HasAnimDictLoaded('amb@world_human_stand_fishing@idle_a') do
                        Wait(100)
                    end

                    TaskPlayAnim(PlayerPedId(), 'amb@world_human_stand_fishing@idle_a', 'idle_a', 8.0, -8, -1, 49, 0, 0, 0, 0)
                    prop = CreateObject(GetHashKey("prop_fishing_rod_01"), plyCoords.x, plyCoords.y, plyCoords.z+0.2,  true,  true, true)
                    AttachEntityToEntity(prop, PlayerPedId(), GetPedBoneIndex(PlayerPedId(), 60309), 0.0,0.0,0.0,0.0,0.0,0.0, true, true, false, true, 1, true)
   
                    Wait(2000)
                    DeleteEntity(prop) 
                    RandomFish()

                else 
                    ESX.ShowNotification("Vous n'avez plus d'appâts pour pêcher !")
                end 
            end)
        else 
            ESX.ShowNotification("Vous n'avez pas de canne à pêche !")
        end
    end)
end


function RandomFish()
	Active = true

    for k, v in pairs(Config.Shop) do
        if v.item == 'appats' then 
            xappats = v.item
            number = v.count
        end 
    end 

	while Active do

		for k,v in pairs(Config.Random_Poisson) do
			random = math.random(1, #Config.Random_Poisson)
			id = v.id
			item = v.item
            name = v.name
            count = v.number

			if random == id then
				Active = false
                TriggerServerEvent('kPeche:UtilisationAppat', xappats, number)
                TriggerServerEvent('kPeche:RandomPoisson', item, count, name)
                FreezeEntityPosition(PlayerPedId(), false)
                ClearPedTasks(PlayerPedId())                     
                break
		    end
        end
		Citizen.Wait(1000)
	end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Blips.BlipsMaps.Position.x, Config.Blips.BlipsMaps.Position.y, Config.Blips.BlipsMaps.Position.z)

        if dist <= 100 then
            wait = 0
            vehicle_perso = GetVehiclePedIsIn(GetPlayerPed(-1), true)

            if not IsPedSittingInVehicle(GetPlayerPed(-1), vehicle_perso) then

                ESX.ShowHelpNotification(Config.Blips.BlipsMaps.Texte_Zone)

                if IsControlJustPressed(1,51) then
                    Peche()
                end

            elseif IsPedSittingInVehicle(GetPlayerPed(-1), vehicle_perso) then
                ESX.ShowHelpNotification(Config.Blips.BlipsMaps.Texte_Zone)

                if IsControlJustPressed(1,51) then
                    ESX.ShowNotification('Vous ne pouvez pas pêcher assis !')    
                end
            end
        end
    Citizen.Wait(wait)
    end
end)


--------------------------------------------------------------------------------------------------------------------------
                                -- [ Config Menu Retour Location ] --
--------------------------------------------------------------------------------------------------------------------------


local MenuOuvert = false
local MenuPrincipal = RageUI.CreateMenu("", "Retour Location")
MenuPrincipal.Closed = function() MenuOuvert = false FreezeEntityPosition(PlayerPedId(), false) end
local playerPed = GetPlayerPed(-1)
local TP_NPC = Config.SpawnVehicle.TP_NPC

function MenuRetourLocation()
    if MenuOuvert then 
        MenuOuvert = false 
        RageUI.Visible(MenuPrincipal, false)
        return 
    else
        MenuOuvert = true 
        FreezeEntityPosition(PlayerPedId(), true)
        RageUI.Visible(MenuPrincipal, true)
        Citizen.CreateThread(function()
            while MenuOuvert do 
                RageUI.IsVisible(MenuPrincipal,function() 
                    RageUI.Separator("↓ ~b~ Retour Bateaux de Location ↓")
      
                    RageUI.Button("Rendre le Bateau de Location", nil, {RightBadge = RageUI.BadgeStyle.Tick}, true , {
                        onSelected = function()
                            TriggerServerEvent("kPeche:RetourLocation", price_caution)
                            DeleteEntity(Boat_Vehicle)
                            ESX.ShowNotification('Votre location a bien été réceptionnée !')
                            RageUI.CloseAll()
                            SetEntityCoordsNoOffset(playerPed, TP_NPC.x, TP_NPC.y, TP_NPC.z, false, false, false, true)
                            FreezeEntityPosition(PlayerPedId(), false)
                            SpawnVehicleVerif = false
                        end
                    })    
                end)
                Wait(1.0)
            end
        end)
    end
end

--------------------------------------------------------------------------------------------------------------------------
                                -- [ Fonction Retour Location ] --
--------------------------------------------------------------------------------------------------------------------------


Citizen.CreateThread(function()
    while true do 
        local wait = 750
        local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
        local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.SpawnVehicle.Retour_location.x, Config.SpawnVehicle.Retour_location.y, Config.SpawnVehicle.Retour_location.z)
    
        if IsPedSittingInVehicle(GetPlayerPed(-1), Boat_Vehicle) then
            FreezeEntityPosition(Boat_Vehicle, false)
            RemoveBlip(Boat_Vehicle_Blip)
        end

        if dist <= 100 then 
            wait = 0
            DrawMarker(22, Config.SpawnVehicle.Retour_location.x, Config.SpawnVehicle.Retour_location.y, Config.SpawnVehicle.Retour_location.z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 255, 0, 0, 255, true, p19)  
        end

        if dist <= 10 then
            wait = 0
            ESX.ShowHelpNotification(Config.SpawnVehicle.TextMenuGarage) 
            if IsControlJustPressed(1,51) then
                if IsPedSittingInVehicle(GetPlayerPed(-1), Boat_Vehicle) then
                    MenuRetourLocation()
                else 
                    ESX.ShowNotification('Vous devez être dans le bateau que vous avez loué !')
                end
            end
        end
    Citizen.Wait(wait)
    end
end)


--------------------------------------------------------------------------------------------------------------------------
                                    -- [ Fonction Caution Bateau Détruit ] --
--------------------------------------------------------------------------------------------------------------------------

Citizen.CreateThread(function()
	while true do
        Citizen.Wait(5000)
		    if SpawnVehicleVerif == true then
			    if GetVehicleEngineHealth(Boat_Vehicle) < 5 and Boat_Vehicle ~= nil then
				    DeleteEntity(Boat_Vehicle)
                    SpawnVehicleVerif = false
                    price_bateau_detruit = Config.SpawnVehicle.Bateau_Detruit
                    TriggerServerEvent("kPeche:BateauDetruit", price_bateau_detruit)
			    end
		    end
	    end
end)

