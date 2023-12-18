fx_version 'cerulean'
games { 'gta5' }

shared_scripts {
  '@qb-core/shared/locale.lua',
  'config.lua',
}

client_script 'client.lua'

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server.lua'
}
