
ui_page 'notifs/index.html'

files {
	'notifs/index.html',
	'notifs/hotsnackbar.css',
	'notifs/hotsnackbar.js'
}


client_script 'notifs.lua'


client_script 'objectsList.lua'
client_script 'config.lua'
client_script 'GUI.lua'
client_script 'categories.lua'
client_script 'client.lua'
client_script 'menus.lua'

server_script 'config.lua'
server_script 'parser.lua'
server_script 'serialize.lua'
server_script 'server.lua'
