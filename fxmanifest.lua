fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Bolux'
description 'Advanced Notification'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/en.lua',
    'locales/*.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    'server/main.lua'
}

ui_page 'nuxtUI/dist/index.html'

files {
    'nuxtUI/dist/**/*',
}

