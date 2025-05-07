fx_version 'cerulean'
game 'gta5'

description 'Rain租车系统'
author 'Rain'
version '1.0.0'

shared_scripts {
    '@es_extended/imports.lua', -- ESX
    '@qb-core/shared/locale.lua', -- QB
    'config.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

dependencies {
    --'es_extended',
    --'qb-core',
    --'ox_target' -- ESX的target系统
}