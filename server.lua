ESX = nil
TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

function logiwyslij (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "EssentillRP",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function logianulowanie (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "EssentillRP",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function logianulowanieswojejpaki (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "EssentillRP",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function logizwrotpaki (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "EssentillRP",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

function logiodbieranie (name, message, color)
	local embeds = {
		{
			["description"]=message,
			["type"]="rich",
			["color"] =color,
			["footer"]=  {
			["text"]= "EssentillRP",
			},
		}
	}
	  if message == nil or message == '' then return FALSE end
		PerformHttpRequest('', function(err, text, headers) end, 'POST', json.encode({ username = name,embeds = embeds}), { ['Content-Type'] = 'application/json' })
end

RegisterServerEvent('six_paczkomaty:kochamcie')
AddEventHandler('six_paczkomaty:kochamcie', function(item, count, type)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local itemLabel = nil
    local xcount = nil

    if type == 'item_standard' then
		local sourceItem = xPlayer.getInventoryItem(item)

		if count > 0 and sourceItem.count >= count then
			xPlayer.removeInventoryItem(item, count)
            xcount = count and 'x' .. count

            TriggerClientEvent('FeedM:showNotification', _source, ('Spakowano ~b~' .. sourceItem.label .. ' ' .. xcount .. '~w~ do paczki'))
		end
    elseif type == 'item_weapon' then
        if xPlayer.hasWeapon(item) then
            local weaponLabel = ESX.GetWeaponLabel(item)

            local _, weapon = xPlayer.getWeapon(item)
            local _, weaponObject = ESX.GetWeapon(item)

            if count > 0 then
                count = count
            else
                count = 1
            end

            xPlayer.removeWeapon(item, count)

            if weaponObject.ammo and count > 0 then
                local ammoLabel = weaponObject.ammo.label
                TriggerClientEvent('FeedM:showNotification', _source, ('Spakowano ~b~' .. sourceItem.label .. ' ' .. xcount .. '~w~ do paczki'))
            else
                TriggerClientEvent('FeedM:showNotification', _source, ('Spakowano ~b~' .. weaponLabel .. ' ~w~ do paczki'))
            end
        end
    end
end)

RegisterServerEvent('six_paczkomaty:dodajpake')
AddEventHandler('six_paczkomaty:dodajpake', function(deliveryPrice, price, phoneNumber, id, method, allItems, lockerLabel, title, targetLocker)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local _target = getIdentifierByPhoneNumber(tonumber(phoneNumber))
    local tPlayer = ESX.GetPlayerFromIdentifier(_target)
    local str = nil

    if xPlayer.getAccount('bank').money >= deliveryPrice then
        xPlayer.removeAccountMoney('bank', deliveryPrice)
    else
        TriggerClientEvent('FeedM:showNotification', _source, ('~b~Potrzebujesz ' .. deliveryPrice .. '$, aby wys??a?? paczk??.'))
        TriggerClientEvent('six_paczkomaty:powrot', _source, allItems)
        return
    end

    local code = GenerateCode()
    local czas = os.date("%Y/%m/%d %X")

    str = 'Twoja paczka w??a??nie dotar??a, znajduje si?? ona w ' .. lockerLabel .. '. Tytu?? przesy??ki: ' .. title .. '. Kod potrzebny do odbioru: ' .. code


    MySQL.Async.execute('INSERT INTO six_paczkomat (sender, receiver, targetid, price, title, lockerid, targetLockerid, method, code, items) VALUES (@sender, @receiver, @targetid, @price, @title, @lockerid, @targetLockerid, @method, @code, @items)',
	{
		['@sender']   = xPlayer.identifier,
		['@receiver']  = tonumber(phoneNumber),
        ['@targetid'] = tPlayer and tPlayer.identifier or _target,
		['@price'] = tonumber(price),
        ['@title'] = tostring(title),
		['@lockerid']  = tonumber(id),
        ['@targetLockerid'] = tonumber(targetLocker),
        ['@method'] = method,
        ['@code'] = code,
		['@items'] 	= json.encode(allItems)
	}, function(rowsChanged)
        TriggerClientEvent('FeedM:showNotification', _source, ('~g~Pomy??lnie wys??ano paczk??. Zap??acono za przesy??k?? ' .. deliveryPrice .. '$'))
        logiwyslij('Paczkomaty wysy??anie', '**Nadawca:** '..xPlayer.name..'\n**Numer Odbiorcy: **' .. phoneNumber ..'\n**ID:** ['..xPlayer.source..']\n**Koszt wysy??ki: **' .. deliveryPrice .. '\n**Tytu?? przesy??ki: **' .. title .. '\n**Znajduje si?? w: **' ..lockerLabel ..'\n**Data: **'..czas,56108)

		if tPlayer then
            TriggerEvent('gcPhone:_internalAddMessage', 'Esenpaczko', phoneNumber, str, 0, function (smsMess)
                TriggerClientEvent("gcPhone:receiveMessage", tPlayer.source, smsMess)
            end)
        else
            MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
            {
                ['@transmitter'] = 'Esenpaczko',
                ['@receiver'] = tonumber(phoneNumber),
                ['@message'] = str,
                ['@isRead'] = 0,
                ['@owner'] = 0
            })
		end
	end)

end)


RegisterServerEvent('six_paczkomaty:powrocik')
AddEventHandler('six_paczkomaty:powrocik', function(packageList)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local czas = os.date("%Y/%m/%d %X")
    if packageList[1] ~= nil then
        local inventory = packageList
        TriggerClientEvent('FeedM:showNotification', _source, ('~b~Anulowano przesy??k??, oddano przedmioty z paczki'))
        logianulowanie('Paczkomaty anulowanie', '**Nadawca:** '..xPlayer.name..'\n**ID:** ['..xPlayer.source..']\n**Data: **'..czas,2061822)
        for i=1, #inventory, 1 do
            if inventory[i].type == 'item_standard' then
                xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
            elseif inventory[i].type == 'item_weapon' then
                if not xPlayer.hasWeapon(inventory[i].value) then
                    local _, weapon = xPlayer.getWeapon(inventory[i].value)
                    local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                    local itemCount = inventory[i].count

                    if itemCount ~= nil then
                        itemCount = itemCount
                    else
                        itemCount = 1
                    end

                    xPlayer.addWeapon(inventory[i].value, itemCount)
                end
            end
        end
    end
end)

RegisterServerEvent('six_paczkomaty:anulujpake')
AddEventHandler('six_paczkomaty:anulujpake', function(id, receiver)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local _target = getIdentifierByPhoneNumber(receiver)
    while _target == nil do
        Wait(100)
    end
    local tPlayer = ESX.GetPlayerFromIdentifier(_target)
    
    if tPlayer then
        TriggerClientEvent('FeedM:showNotification', _source, ('~b~Aby anulowa?? wysy??k??, odbiorca musi i???? spa??'))
        return
    else
        MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
        {
            ['@transmitter'] = 'Esenpaczko',
            ['@receiver'] = tonumber(receiver),
            ['@message'] = 'Wysy??ka Paczki #' .. id .. ' zosta??a anulowana przez nadawc??',
            ['@isRead'] = 0,
            ['@owner'] = 0
        })

        MySQL.Async.fetchAll('SELECT items FROM six_paczkomat WHERE sender = @sender AND id = @id', {
            ['@sender']  = xPlayer.identifier,
            ['@id'] = id,
        }, function(data)
            if data[1] ~= nil then
                local inventory = json.decode(data[1].items)
                local czas = os.date("%Y/%m/%d %X")
                TriggerClientEvent('FeedM:showNotification', _source, ('~g~Pomy??lnie anulowano wysy??k??, zwr??cono przedmioty z paczki'))
                logianulowanieswojejpaki('Paczkomaty anulowanie wys??anej paczki', '**Nadawca:** '..xPlayer.name..'\n**Numer paczki: **#' .. id ..'\n**ID:** ['..xPlayer.source..']\n**Data: **'..czas,16654197)
                for i=1, #inventory, 1 do
                    if inventory[i].type == 'item_standard' then
                        xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                    elseif inventory[i].type == 'item_weapon' then
                        if not xPlayer.hasWeapon(inventory[i].value) then
                            local _, weapon = xPlayer.getWeapon(inventory[i].value)
                            local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                            local itemCount = inventory[i].count

                            if itemCount ~= nil then
                                itemCount = itemCount
                            else
                                itemCount = 1
                            end

                            xPlayer.addWeapon(inventory[i].value, itemCount)
                        else
                            TriggerClientEvent('FeedM:showNotification', _source, ('~b~Bro?? znajduj??c?? si?? w paczkomacie posiadasz przy sobie, od?????? j?? i odbierz paczk?? ponownie!'))
                            return
                        end
                    end
                end
                MySQL.Async.execute('DELETE FROM six_paczkomat WHERE sender = @sender AND id = @id', {
                    ['@sender']  = xPlayer.identifier,
                    ['@id'] = id,
                })
            end
        end)
    end
end)

RegisterServerEvent('six_paczkomaty:zwrocpake')
AddEventHandler('six_paczkomaty:zwrocpake', function(sender, id, packageList)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromIdentifier(sender)

    if tPlayer then
        if packageList[1] ~= nil then
            local inventory = packageList
            local czas = os.date("%Y/%m/%d %X")
            xPlayer.showNotification('~g~Pomy??lnie zwr??cono paczk??')
            tPlayer.showNotification('~g~Paczka #' .. id .. ' zosta??a zwr??cona')
            logizwrotpaki('Paczkomaty zwrot paczki', '**Zwracaj??cy:** '..xPlayer.name..'\n**Numer paczki: **#' .. id ..'\n**ID:** ['..xPlayer.source..']\n**Data: **'..czas,2096808)
            for i=1, #inventory, 1 do
                if inventory[i].type == 'item_standard' then
                    tPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                elseif inventory[i].type == 'item_weapon' then
                    if not tPlayer.hasWeapon(inventory[i].value) then
                        local _, weapon = tPlayer.getWeapon(inventory[i].value)
                        local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                        local itemCount = inventory[i].count

                        if itemCount ~= nil then
                            itemCount = itemCount
                        else
                            itemCount = 1
                        end

                        tPlayer.addWeapon(inventory[i].value, itemCount)
                    end
                end
            end
            MySQL.Async.execute('DELETE FROM six_paczkomat WHERE sender = @sender AND id = @id', {
                ['@sender']  = sender,
                ['@id'] = id,
            })
        end
    else
        TriggerClientEvent('FeedM:showNotification', _source, ('~b~Aby zwr??ci?? paczk??, nadawca musi znajdowa?? si?? na wyspie'))
    end
end)

RegisterServerEvent('six_paczkomaty:odbierzpake')
AddEventHandler('six_paczkomaty:odbierzpake', function(code, id, method, price, sender)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local tPlayer = ESX.GetPlayerFromIdentifier(sender)
    local tPhone = getNumberPhone(sender)

    if method == 'cash' then
        if xPlayer.getMoney() >= tonumber(price) then
            xPlayer.removeMoney(tonumber(price))
            if tPlayer then
                tPlayer.showNotification('~y~Otrzyma??e?? przelew~w~ na kwot?? ~g~' .. price .. '$ ~w~za wys??an?? ~y~paczk??')
				tPlayer.addAccountMoney('bank', tonumber(price))
            else
                MySQL.Async.fetchAll('SELECT bank FROM users WHERE identifier = @identifier',
                {
                    ['@identifier'] = sender
                }, function(result)
                    if result[1] ~= nil then
                        local currentBank = result[1].bank
                        MySQL.Async.execute('UPDATE users SET bank = @bank WHERE identifier = @identifier',
                        {
                            ['@identifier'] = sender,
                            ['@bank'] = currentBank + price
                        })
                        MySQL.Async.execute('INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES (@transmitter, @receiver, @message, @isRead, @owner);',
                        {
                            ['@transmitter'] = 'Esenpaczko',
                            ['@receiver'] = tonumber(tPhone),
                            ['@message'] = 'Otrzyma??e?? przelew na kwot?? ' .. price .. '$ za wys??an?? paczk??',
                            ['@isRead'] = 0,
                            ['@owner'] = 0
                        })
                    end
                end)
            end
        else
            TriggerClientEvent('FeedM:showNotification', _source, ('~b~Potrzebujesz ' .. price .. '$, aby odebra?? paczk??.'))
            return
        end
    end

    TriggerClientEvent('FeedM:showNotification', _source, ('~g~Pomy??lnie odebrano paczk??'))
    MySQL.Async.fetchAll('SELECT items FROM six_paczkomat WHERE code = @code', {
        ['@targetid']  = xPlayer.identifier,
		['@code'] = code,
    }, function(data)
        if data[1] ~= nil then
            local inventory = json.decode(data[1].items)
            local czas = os.date("%Y/%m/%d %X")
            TriggerClientEvent('FeedM:showNotification', _source, ('~g~Pomy??lnie odebrano paczk??'))
            logiodbieranie('Paczkomaty odbi??r paczki', '**Odbiorca:** '..xPlayer.name..'\n**Numer paczki: **#' .. id ..'\n**ID:** ['..xPlayer.source..']\n**Data: **'..czas,7732767)
            for i=1, #inventory, 1 do
                if inventory[i].type == 'item_standard' then
                    xPlayer.addInventoryItem(inventory[i].value, inventory[i].count)
                elseif inventory[i].type == 'item_weapon' then
                    if not xPlayer.hasWeapon(inventory[i].value) then
                        local _, weapon = xPlayer.getWeapon(inventory[i].value)
        				local _, weaponObject = ESX.GetWeapon(inventory[i].value)
                        local itemCount = inventory[i].count

                        if itemCount ~= nil then
        					itemCount = itemCount
        				else
        					itemCount = 1
        				end

                        xPlayer.addWeapon(inventory[i].value, itemCount)
                    else
                        TriggerClientEvent('FeedM:showNotification', _source, ('~b~Bro?? znajduj??c?? si?? w paczkomacie posiadasz przy sobie, od?????? j?? i odbierz paczk?? ponownie!'))
                        return
                    end
                end
            end
            MySQL.Async.execute('DELETE FROM six_paczkomat WHERE targetid = @targetid AND code = @code', {
                ['@targetid']  = xPlayer.identifier,
        		['@code'] = code,
            })
        end
    end)
end)

ESX.RegisterServerCallback('six_paczkomaty:numer', function(source, cb, phoneNumber)
    local checkNumber = getIdentifierByPhoneNumber(tonumber(phoneNumber))

    while checkNumber == nil do
        Wait(100)
    end

	if checkNumber then
        cb(true)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('six_paczkomaty:sprawdzanko', function(source, cb, phoneNumber)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local checkNumber = getIdentifierByPhoneNumber(tonumber(phoneNumber))

    while checkNumber == nil do
        Wait(100)
    end

    if checkNumber == xPlayer.identifier then
        cb(false)
    else
        cb(true)
    end
end)

ESX.RegisterServerCallback('six_paczkomaty:sprawdzskrytke', function(source, cb, id)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local xNumber = getNumberPhone(xPlayer.identifier)
    local data = {}
    local itemsLabel = {}

    local result = MySQL.Sync.fetchAll('SELECT id, title, code, method, price, sender, items FROM six_paczkomat WHERE targetid = @targetid AND targetLockerid = @targetLockerid AND receiver = @receiver',
	{
		['@targetLockerid'] = id,
		['@targetid'] = xPlayer.identifier,
        ['@receiver'] = xNumber,
	})

    if result[1] ~= nil then
        for i=1, #result, 1 do
            table.insert(data, {
                id = result[i].id,
                title = result[i].title,
                code = result[i].code,
                method = result[i].method,
                price = result[i].price,
                sender = result[i].sender,
                items = json.decode(result[i].items)
            })
        end
        cb(data)
    else
        cb(false)
    end
end)

ESX.RegisterServerCallback('six_paczkomaty:sprawdzpake', function(source, cb)
    local _source = source
  	local xPlayer = ESX.GetPlayerFromId(_source)
    local data = {}

    local result = MySQL.Sync.fetchAll('SELECT id, title, items, receiver FROM six_paczkomat WHERE sender = @sender',
	{
		['@sender'] = xPlayer.identifier
	})

    if result[1] ~= nil then
        for i=1, #result, 1 do
            table.insert(data, {
                id = result[i].id,
                title = result[i].title,
                items = json.decode(result[i].items),
                receiver = result[i].receiver
            })
        end
        cb(data)
    else
        cb(false)
    end
end)

GenerateCode = function()
    return tostring(math.random(111111,999999))
end

getIdentifierByPhoneNumber = function(phone_number)
    local result = MySQL.Sync.fetchAll("SELECT identifier FROM users WHERE phone_number = @phone_number", {
        ['@phone_number'] = phone_number
    })
    if result[1] ~= nil then
        return result[1].identifier
    end
    return false
end

getNumberPhone = function(identifier)
    local result = MySQL.Sync.fetchAll("SELECT users.phone_number FROM users WHERE users.identifier = @identifier", {
        ['@identifier'] = identifier
    })
    if result[1] ~= nil then
        return result[1].phone_number
    end
    return nil
end
