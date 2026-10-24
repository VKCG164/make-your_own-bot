randomise();

aba = 0;
skin_selecionada = 0;
audio_selecionado = -1;
audio_tocando = -1;
if (!variable_global_exists("sons")) {
    global.sons = [Sd_test1, Sd_test2];
}
cor_fundo = make_color_rgb(19, 29, 43);
cor_painel = make_color_rgb(35, 49, 65);
cor_destaque = make_color_rgb(244, 55, 39);
cor_celula = make_color_rgb(48, 64, 81);
cor_verde = make_color_rgb(80, 210, 110);

gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

if (!variable_global_exists("lista_skins")) {
    global.lista_skins = ["Padrao", "Robo"];
    global.skins_idle = [Spr_GDidle, Spr_GDdroid];
    global.skins_falando = [Spr_GDf_falando, Spr_GDdroid_falando];
}

if (!variable_global_exists("skin")) {
    global.skin = 0;
}

skin_selecionada = clamp(
    global.skin,
    0,
    array_length(global.lista_skins) - 1
);

if (!variable_global_exists("sons")) {
    global.sons = [Sd_test1, Sd_test2];
}

if (!variable_global_exists("sons")) {
    global.sons = [];
}
