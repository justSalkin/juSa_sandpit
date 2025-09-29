game 'rdr3'
fx_version 'adamant'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

author 'justSalkin'
description 'A Script which adds a sandpit to dig in and get clay and sand.'
version '1.0.1'


client_script {
    'client.lua', 
}

server_script {
    'server.lua', 
}

shared_scripts {
    'config.lua',
}

dependencies {
    'vorp_core',
    'vorp_inventory',
    'vorp_progressbar',
}