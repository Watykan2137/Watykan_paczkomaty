fx_version 'adamant'

game 'gta5'

version '1.0.0'


server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'server.lua'
}

client_scripts {
  'client.lua',
  'config.weapons.lua',
}

exports {
	'IsEnabled'
}