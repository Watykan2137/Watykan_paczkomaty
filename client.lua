ESX = nil
local PlayerData = {}

local propLockers = {
    { coords = vector3(417.2494, -991.9, 28.3929), street = 'Mission Row', name = 'Paczkomat #1', id = 1 },
    { coords = vector3(-664.67730712891, 311.68566894531, 83.085739135742), street = 'Eclipse', name = 'Paczkomat #2', id = 2 },
    { coords = vector3(889.4495, -12.918, 77.814), street = 'Casino', name = 'Paczkomat #3', id = 3 },
    { coords = vector3(1130.282, -480.1451, 65.0274), street = 'Mirror Park', name = 'Paczkomat #4', id = 4 },
    { coords = vector3(-263.1639, -821.2453, 30.8299), street = 'Pillbox Hill', name = 'Paczkomat #5', id = 5 },
    { coords = vector3(-476.5048828125, -286.62161254883, 35.640636444092), street = 'Mount Zonah', name = 'Paczkomat #6', id = 6 },
    { coords = vector3(-718.6859, -821.0955, 22.4979), street = 'Little Seoul', name = 'Paczkomat #7', id = 7 },
    { coords = vector3(-1304.6841, -638.525, 25.565), street = 'Del Perro', name = 'Paczkomat #8', id = 8 },
    { coords = vector3(33.785709381104, -1762.5584716797, 29.302043914795), street = 'Davis Ave', name = 'Paczkomat #9', id = 9 },
    { coords = vector3(-1039.6363525391, -2649.3601074219, 14.07004737854), street = 'Airport', name = 'Paczkomat #10', id = 10 },
    { coords = vector3(1166.0137939453, -1503.0218505859, 34.692531585693), street = 'St Fiacre', name = 'Paczkomat #11', id = 11 },
    { coords = vector3(1953.0906, 3743.0361, 31.2326), street = 'Sandy Shores', name = 'Paczkomat #12', id = 12 },
    { coords = vector3(2550.1189, 345.2232, 107.5198), street = 'Tataviam Mountains', name = 'Paczkomat #13', id = 13 },
    { coords = vector3(1853.3562011719, 2627.7092285156, 45.672016143799), street = 'Prison', name = 'Paczkomat #14', id = 14 },
    { coords = vector3(2742.1159667969, 3446.59375, 56.112369537354), street = 'Senora Fwy', name = 'Paczkomat #15', id = 15 },
    { coords = vector3(1694.8782958984, 4767.2919921875, 41.997329711914), street = 'Grapeseed', name = 'Paczkomat #16', id = 16 },
    { coords = vector3(-2960.4558, 469.338, 14.311), street = 'Banham Canyon', name = 'Paczkomat #17', id = 17 },
    { coords = vector3(-204.2306, 6227.4912, 30.7109), street = 'Paleto Bay', name = 'Paczkomat #18', id = 18 },
    { coords = vector3(615.92193603516, 79.857109069824, 91.299545288086), street = 'Vinewood hills', name = 'Paczkomat #19', id = 19 },
    { coords = vector3(-985.04718017578, -762.51147460938, 20.934234619141), street = 'Vespucci Canals', name = 'Paczkomat #20', id = 20 },
    { coords = vector3(577.65069580078, 2741.8190917969, 42.128803253174), street = 'Droga 68', name = 'Paczkomat #21', id = 21 },
    { coords = vector3(399.73345947266, -1630.1427001953, 29.291952133179), street = 'Innocence blvd', name = 'Paczkomat #22', id = 22 },
    { coords = vector3(787.22198486328, -2959.5959472656, 6.0388450622559), street = 'Doki', name = 'Paczkomat #23', id = 23 },
    { coords = vector3(259.27017211914, -780.92407226562, 30.552711486816), street = 'Parking główny', name = 'Paczkomat #24', id = 24 },

}

local packageList = {}

CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
	end

	Citizen.Wait(5000)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  	PlayerData = xPlayer
end)

CreateThread(function()
    Citizen.Wait(1000)
	for i=1, #propLockers, 1 do
		local blip = AddBlipForCoord(propLockers[i].coords)

		SetBlipSprite (blip, 514)
		SetBlipDisplay(blip, 4)
		SetBlipScale  (blip, 0.5)
		SetBlipColour (blip, 84)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString('Paczkomat')
		EndTextCommandSetBlipName(blip)
	end
end)

RegisterNetEvent('six_paczkomaty:powrot')
AddEventHandler('six_paczkomaty:powrot', function(items)
    if items[1] ~= nil then
        TriggerServerEvent('six_paczkomaty:powrocik', items)
        for i=1, #items, 1 do
            packageList[i] = nil
        end
    end
end)

CreateThread(function()
    while true do
        local isNear = GetClosestLocker()
        if isNear ~= nil then
            DisplayHelpText("Naciśnij ~INPUT_PICKUP~ aby skorzystać z paczkomatu")

            if IsControlJustPressed(1, 38) then
                ESX.ShowAdvancedNotification('Paczkomat', '~b~ALERT', 'Jeżeli ~o~odejdziesz ~w~od paczkomatu to oddamy twoje przedmioty', "char_bank_fleeca")
                OpenLockerMenu(isNear.id, isNear.name, isNear.street)
            end
        else
            if packageList[1] ~= nil then
                TriggerServerEvent('six_paczkomaty:powrocik', packageList)
                for i=1, #packageList, 1 do
                    packageList[i] = nil
                end
            end
            Citizen.Wait(1000)
        end

        Citizen.Wait(10)
    end
end)

GetClosestLocker = function()
    local playerlocation = GetEntityCoords(PlayerPedId())

    local nearObject = nil

    for i=1, #propLockers, 1 do
        if GetDistanceBetweenCoords(playerlocation, propLockers[i].coords, true) < 2.5 then
            nearObject = { id = propLockers[i].id, name = propLockers[i].name, street =  propLockers[i].street }
            break
        end
    end

    return nearObject
end

local itemsCount = 0

OpenLockerMenu = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'locker_' .. id, {
        title    = name .. " (" .. street .. ")",
        align    = 'center',
        elements = {
            {label = "Nadaj paczkę", value = 'send'},
            {label = 'Odbierz paczkę', value = 'receive'},
            {label = 'Anulowanie wysyłki', value = 'cancel'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'send' then
            nadawaniepaki(id, itemsCount)
        elseif data.current.value == 'receive' then
            odbierzpake(id, name, street)
        elseif data.current.value == 'cancel' then
            anulujpake(id, name, street)
        end
    end, function(data, menu)
        menu.close()
    end)
end

odbierzpake = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('six_paczkomaty:sprawdzskrytke', function(data)
        if data then
            local elements = {}
            for i=1, #data, 1 do
                table.insert(elements, { label = 'Paczka #'.. data[i].id ..' (' .. data[i].title .. ')', id = data[i].id, code = data[i].code, price = data[i].price, method = data[i].method, sender = data[i].sender, items = data[i].items })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
                title    = "Lista paczek do odbioru",
                align    = 'center',
                elements = elements
            }, function(data, menu)
                menu.close()
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'receivecode', {
                    title = ('Wprowadź kod odbioru paczki')
                }, function(data2, menu2)
                    menu2.close()
                    local codee, method, price, sender, items = data2.value, data.current.method, data.current.price, data.current.sender, data.current.items
                    if codee == data.current.code then
                        if method == 'cash' then
                            local elements2 = {
                                {label = "Płacę, odbieram", value = 'yes'},
                                {label = 'Nie odbieram', value = 'no'},
                                {label = 'Zwróć paczkę nadawcy', value = 'return'},
                                {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                            }
                            for i=1, #items, 1 do
                                table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
                                title    = "Paczka została nadana za pobraniem, aby ją odebrać należy zapłacić " .. price .. '$',
                                align    = 'center',
                                elements = elements2
                            }, function(data3, menu3)
                                menu3.close()
                                if data3.current.value == 'yes' then
                                    TriggerServerEvent('six_paczkomaty:odbierzpake', data.current.code, data.current.id, method, price, sender)
                                elseif data3.current.value == 'return' then
                                    TriggerServerEvent('six_paczkomaty:zwrocpake', sender, data.current.id, items)
                                end
                            end, function(data3, menu3)
                                menu3.close()
                            end)
                        else
                            local elements2 = {
                                {label = "Odbieram", value = 'yes'},
                                {label = 'Nie odbieram', value = 'no'},
                                {label = 'Zwróć paczkę nadawcy', value = 'return'},
                                {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                            }
                            for i=1, #items, 1 do
                                table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                            end
                            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask2', {
                                title    = "Czy napewno chcesz odebrać paczkę?",
                                align    = 'center',
                                elements = elements2
                            }, function(data4, menu4)
                                menu4.close()
                                if data4.current.value == 'yes' then
                                    TriggerServerEvent('six_paczkomaty:odbierzpake', data.current.code, data.current.id, method, 0, sender)
                                elseif data4.current.value == 'return' then
                                    TriggerServerEvent('six_paczkomaty:zwrocpake', sender, data.current.id, items)
                                end
                            end, function(data4, menu4)
                                menu4.close()
                            end)
                        end
                    else
                        ESX.ShowNotification('~b~Podany kod jest nieprawidłowy!')
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('~b~Brak paczek do odebrania przy tym paczkomacie')
        end
    end, id)
end

anulujpake = function(id, name, street)
    ESX.UI.Menu.CloseAll()
    ESX.TriggerServerCallback('six_paczkomaty:sprawdzpake', function(data)
        if data then
            local elements = {}
            for i=1, #data, 1 do
                table.insert(elements, { label = 'Paczka #'.. data[i].id ..' (' .. data[i].title .. ')', id = data[i].id, items = data[i].items, receiver = data[i].receiver })
            end
            ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_cancel', {
                title    = "Lista wysłanych paczek",
                align    = 'center',
                elements = elements
            }, function(data, menu)
                local items = data.current.items
                menu.close()
                local elements2 = {
                    {label = "Tak", value = 'yes'},
                    {label = 'Nie', value = 'no'},
                    {label = '== ZAWARTOŚĆ PACZKI ==', value = nil},
                }
                for i=1, #items, 1 do
                    table.insert(elements2, { label = items[i].label .. ' x' .. items[i].count, value = i })
                end
                ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask_cancel2', {
                    title    = "Czy napewno chcesz anulować wysyłkę?",
                    align    = 'center',
                    elements = elements2
                }, function(data2, menu2)
                    menu2.close()
                    if data2.current.value == 'yes' then
                        TriggerServerEvent('six_paczkomaty:anulujpake', data.current.id, data.current.receiver)
                    end
                end, function(data2, menu2)
                    menu2.close()
                end)
            end, function(data, menu)
                menu.close()
            end)
        else
            ESX.ShowNotification('~b~Brak wysłanych paczek do anulacji')
        end
    end)
end


startAnim = function()
	CreateThread(function()
	  RequestAnimDict("mp_common")
	  while not HasAnimDictLoaded("mp_common") do
	    Citizen.Wait(0)
	  end
	  TaskPlayAnim(Citizen.InvokeNative(0x43A66C31C68491C0, -1), "mp_common" ,"givetake2_a" ,8.0, -8.0, -1, 0, 0, false, false, false )
	end)
end

nadawaniepaki = function(id, itemsCount)
    local inventory = ESX.GetPlayerData().inventory
    while inventory == nil do
        Wait(100)
    end
    local playerPed = PlayerPedId()
	local elements = {}


	for k,v in ipairs(inventory) do
		if v.count > 0 then

			table.insert(elements, {
				label = ('%s x%s'):format(v.label, v.count),
                onlyLabel = v.label,
				count = v.count,
				type = 'item_standard',
				value = v.name,
				rare = v.rare,
			})
		end
	end

	for k,v in ipairs(Config.Weapons) do
		local weaponHash = GetHashKey(v.name)

		if HasPedGotWeapon(playerPed, weaponHash, false) then
			local ammo, label = GetAmmoInPedWeapon(playerPed, weaponHash)

			if v.ammo then
				label = ('%s - [%s]'):format(v.label, ammo)
			else
				label = v.label
			end

			table.insert(elements, {
				label = label,
                onlyLabel = label,
				count = 1,
				type = 'item_weapon',
				value = v.name,
				rare = false,
				ammo = ammo,
				canGiveAmmo = (v.ammo ~= nil),
			})
		end
	end

	ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'packing', {
		title    = ('Co chcesz zapakować?'),
		align    = 'center',
		elements = elements
	}, function(data, menu)
        menu.close()
        if data.current.type == 'item_weapon' and data.current.canGiveAmmo then
            if data.current.ammo < 1 then
                startAnim()
                itemsCount = itemsCount + 1
                TriggerServerEvent('six_paczkomaty:kochamcie', data.current.value, 0, data.current.type)
                table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = 1, value = data.current.value })
                smiledog(id, itemsCount, packageList)
            else
                ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'weapon_ammo', {
                    title = "Ilość"
                }, function(data3, menu3)
                    local quantity = tonumber(data3.value)
                    if quantity and quantity > 0 and data.current.ammo >= quantity then
                        startAnim()
                        itemsCount = itemsCount + 1
                        TriggerServerEvent('six_paczkomaty:kochamcie', data.current.value, quantity, data.current.type)
                        table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = quantity, value = data.current.value })
                        smiledog(id, itemsCount, packageList)
                    else
                        ESX.ShowNotification(_U('amount_invalid'))
                    end
                end, function(data3, menu3)
                    menu3.close()
                end)
            end
        elseif data.current.type == 'item_standard' and data.current.count > 0 then
            ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'inventory_item_count_give', {
                title = _U('amount')
            }, function(data3, menu3)
                local quantity = tonumber(data3.value)

                if quantity and quantity > 0 and data.current.count >= quantity then
                    startAnim()
                    itemsCount = itemsCount + 1
                    TriggerServerEvent('six_paczkomaty:kochamcie', data.current.value, quantity, data.current.type)
                    table.insert(packageList, { label = data.current.onlyLabel, type = data.current.type, count = quantity, value = data.current.value })
                    smiledog(id, itemsCount, packageList)
                    menu3.close()
                else
                    ESX.ShowNotification(_U('amount_invalid'))
                end
            end, function(data3, menu3)
                menu3.close()
            end)
		end
    end, function(data, menu)
        menu.close()
    end)
end

smiledog = function(id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Czy to wszystko?",
        align    = 'center',
        elements = {
            {label = "Tak, przechodzę dalej", value = 'next'},
            {label = 'Nie, chce spakować więcej', value = 'more'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'next' then
            przechodzedalej(id, itemsCount, packageList)
        elseif data.current.value == 'more' then
            if itemsCount < 3 then
                nadawaniepaki(id, itemsCount, packageList)
            else
                ESX.ShowNotification('~b~Nie możesz zapakować więcej do paczki')
                przechodzedalej(id, itemsCount)
            end
        end
    end, function(data, menu)
        menu.close()
    end)
end

przechodzedalej = function(id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Wybierz metode wysłki (koszt przesyłki)",
        align    = 'center',
        elements = {
            {label = "Standardowa (2500$)", value = 'default'},
            {label = 'Za Pobraniem (dodatkowe 2000$ od przedmiotu)', value = 'cash'},
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'default' then
            numertelefonu('default', id, itemsCount, packageList)
        elseif data.current.value == 'cash' then
            numertelefonu('cash', id, itemsCount, packageList)
        end
    end, function(data, menu)
        menu.close()
    end)
end

numertelefonu = function(method, id, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'phonee', {
        title = ('Wprowadź numer telefonu odbiorcy')
    }, function(data2, menu2)
        menu2.close()
        local phoneNumber = data2.value
        ESX.TriggerServerCallback('six_paczkomaty:numer', function(exist)
            if exist then
                if phoneNumber ~= nil then
                    if method == 'cash' then
                        cena(method, id, phoneNumber, itemsCount, packageList)
                    else
                        tytul(method, id, phoneNumber, 0, itemsCount, packageList)
                    end
                else
                    numertelefonu(method, id, itemsCount, packageList)
                    ESX.ShowNotification('~b~Niepoprawny numer telefonu')
                end
            else
                numertelefonu(method, id, itemsCount, packageList)
                ESX.ShowNotification('~b~Podany numer telefonu nie istnieje!')
            end
        end, phoneNumber)
    end, function(data2, menu2)
        menu2.close()
    end)
end

cena = function(method, id, phoneNumber, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'pricex', {
        title = ('Wprowadź kwotę przesyłki')
    }, function(data2, menu2)
        menu2.close()
        local price = data2.value
        if price ~= nil then
            if string.len(price) < 11 then
                if type(price) == 'number' then
                    tytul(method, id, phoneNumber, price, itemsCount, packageList)
                else
                    cena(method, id, phoneNumber, itemsCount, packageList)
                    ESX.ShowNotification('~b~Nieprawidłowa kwota')
                end
            else
                cena(method, id, phoneNumber, itemsCount, packageList)
                ESX.ShowNotification('~b~Podana kwota jest zbyt długa, max 11 cyfr')
            end
        else
            cena(method, id, phoneNumber, itemsCount, packageList)
            ESX.ShowNotification('~b~Nieprawidłowa kwota')
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

tytul = function(method, id, phoneNumber, price, itemsCount, packageList)
    ESX.UI.Menu.CloseAll()
    ESX.UI.Menu.Open('dialog', GetCurrentResourceName(), 'titlex', {
        title = ('Wprowadź tytuł przesyłki (max 20 znaków)')
    }, function(data2, menu2)
        menu2.close()
        local title = data2.value
        if title ~= nil then
            if string.len(tostring(title)) <= 20 then
                cenapaki(method, id, phoneNumber, price, itemsCount, packageList, title)
            else
                tytul(method, id, phoneNumber, price, itemsCount, packageList)
                ESX.ShowNotification('~b~Podano zbyt długi tytuł przesyłki')
            end
        else
            tytul(method, id, phoneNumber, itemsCount, packageList)
            ESX.ShowNotification('~b~Nieprawidłowy tytuł')
        end
    end, function(data2, menu2)
        menu2.close()
    end)
end

cenapaki = function(method, id, phoneNumber, price, itemsCount, packageList, title)
    ESX.UI.Menu.CloseAll()
    local elements = {}
    local lockerLabel = nil
    for i=1, #propLockers, 1 do
        local label
        if propLockers[i].id == id then
            label = '>> ' .. propLockers[i].name .. " (" .. propLockers[i].street .. ") <<"
        else
            label = propLockers[i].name .. " (" .. propLockers[i].street .. ")"
        end
        table.insert(elements, { label = label, value = propLockers[i].id, targetLabel = propLockers[i].name .. " (" .. propLockers[i].street .. ")" })
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Wybierz miejsce dostawy",
        align    = 'center',
        elements = elements
    }, function(data, menu)
        menu.close()
        if data.current.value then
            potwierdzonko(method, id, phoneNumber, price, itemsCount, packageList, data.current.targetLabel, title, data.current.value)
        end
    end, function(data, menu)
        menu.close()
    end)
end

potwierdzonko = function(method, id, phoneNumber, price, itemsCount, packageList, lockerLabel, title, targetLocker)
    ESX.UI.Menu.CloseAll()
    local deliveryPrice = 2500
    if method == 'cash' then
        deliveryPrice = 2000 * itemsCount
    end
    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'ask', {
        title    = "Czy napewno chcesz wysłać paczkę?",
        align    = 'center',
        elements = {
            {label = "Tak", value = 'yes'},
            {label = "Nie", value = 'cancel'},
            {label = "Ustaw nowego nadawce", value = 'return'}
        }
    }, function(data, menu)
        menu.close()
        if data.current.value == 'yes' then
            ESX.TriggerServerCallback('six_paczkomaty:sprawdzanko', function(can)
                if can then
                    TriggerServerEvent('six_paczkomaty:dodajpake', deliveryPrice, price, phoneNumber, id, method, packageList, lockerLabel, title, targetLocker)
                    if packageList[1] ~= nil then
                        for i=1, #packageList, 1 do
                            packageList[i] = nil
                        end
                    end
                else
                    potwierdzonko(method, id, phoneNumber, price, itemsCount, packageList, lockerLabel, title, targetLocker)
                    ESX.ShowNotification('~b~Nie możesz wysłać paczki sam do siebie! Aby zwrócić przedmioty, odejdź od paczkomatu')
                end
            end, phoneNumber)
        elseif data.current.value == 'return' then
            numertelefonu(method, id, itemsCount, packageList)
        end
    end, function(data, menu)
        menu.close()
    end)
end

DisplayHelpText = function(str)
    SetTextComponentFormat("STRING")
    AddTextComponentString(str)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
