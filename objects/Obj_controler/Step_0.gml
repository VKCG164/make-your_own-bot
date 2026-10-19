if (global.fundo>3){
global.fundo=0
}
if (variable_global_exists("lista_skins")) {
    var total_skins = array_length(global.lista_skins);

    if (total_skins > 0) {
        if (global.skin >= total_skins) {
            global.skin = 0;
        }

        if (global.skin < 0) {
            global.skin = total_skins - 1;
        }
    }
}