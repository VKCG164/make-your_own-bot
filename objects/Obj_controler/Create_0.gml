global.musica = true;
global.fundo = 0;
global.contador = false;
global.skin = 0;

var appdata = environment_get_variable("APPDATA");
var pasta_skins = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/Skins";

if (!directory_exists(pasta_skins)) {
    directory_create(pasta_skins);
}