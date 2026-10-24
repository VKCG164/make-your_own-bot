
gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

var painel_x = 24;
var painel_y = 62;
var painel_w = gui_w - 48;
var painel_h = gui_h - 86;

draw_set_alpha(0.97);
draw_set_color(cor_fundo);
draw_rectangle(0, 0, gui_w, gui_h, false);
draw_set_alpha(1);

draw_set_color(cor_painel);
draw_rectangle(painel_x, painel_y, painel_x + painel_w, painel_y + painel_h, false);

draw_set_color(cor_destaque);
draw_rectangle(painel_x, painel_y, painel_x + painel_w, painel_y + 5, false);

draw_set_halign(fa_left);
draw_set_valign(fa_middle);
draw_set_color(c_white);
draw_set_font(Fonte_jogo2);
draw_set_color(aba == 0 ? cor_destaque : cor_celula);
draw_rectangle(painel_x, 18, painel_x + 120, 50, false);

draw_set_color(aba == 1 ? cor_destaque : cor_celula);
draw_rectangle(painel_x + 128, 18, painel_x + 248, 50, false);

draw_set_color(c_white);
draw_set_halign(fa_center);
draw_text_transformed(painel_x + 60, 34, "SKINS", 0.65, 0.65, 0);
draw_text_transformed(painel_x + 188, 34, "AUDIOS", 0.65, 0.65, 0);

draw_set_color(make_color_rgb(130, 40, 40));
draw_rectangle(gui_w - 145, 18, gui_w - 25, 50, false);

draw_set_color(c_white);
draw_text_transformed(gui_w - 85, 34, "VOLTAR", 0.65, 0.65, 0);

if (aba == 0) {
    draw_set_halign(fa_left);
    draw_text_transformed(painel_x + 18, painel_y + 52, "SELECIONE SUA SKIN", 0.65, 0.65, 0);

    var grade_x = painel_x + 18;
    var grade_y = painel_y + 66;
    var grade_w = painel_w * 0.57;
    var cel_w = (grade_w - 24) / 4;
    var cel_h = min(112, (painel_h - 105) / 2);

    for (var i = 0; i < array_length(global.lista_skins); i++) {
        var col = i mod 4;
        var lin = i div 4;
        var sx = grade_x + col * (cel_w + 8);
        var sy = grade_y + lin * (cel_h + 8);

        draw_set_color(i == skin_selecionada ? cor_destaque : cor_celula);
        draw_rectangle(sx, sy, sx + cel_w, sy + cel_h, false);

        var spr = global.skins_idle[i];

        if (spr != -1 && sprite_exists(spr)) {
            var escala = min(
                (cel_w - 14) / max(1, sprite_get_width(spr)),
                (cel_h - 30) / max(1, sprite_get_height(spr))
            );

            draw_sprite_ext(spr, 0, sx + cel_w / 2, sy + cel_h / 2 - 8, escala, escala, 0, c_white, 1);
        }

        draw_set_halign(fa_center);
        draw_set_color(c_white);
        draw_text_transformed(sx + cel_w / 2, sy + cel_h - 12, global.lista_skins[i], 0.55, 0.55, 0);

        if (i == global.skin) {
            draw_set_color(cor_verde);
            draw_text_transformed(sx + cel_w / 2, sy + 10, "EQUIPADA", 0.5, 0.5, 0);
        }
    }

    var preview_x = painel_x + painel_w * 0.79;
    var preview_y = painel_y + painel_h * 0.40;

    draw_set_halign(fa_center);
    draw_set_color(c_white);
    draw_text_transformed(preview_x, painel_y + 65, "PRÉ-VISUALIZAÇÃO", 0.6, 0.6, 0);

    var spr_preview = global.skins_idle[skin_selecionada];

    if (spr_preview != -1 && sprite_exists(spr_preview)) {
        var escala_preview = min(
            (painel_w * 0.25) / max(1, sprite_get_width(spr_preview)),
            (painel_h * 0.48) / max(1, sprite_get_height(spr_preview))
        );

        draw_sprite_ext(spr_preview, 0, preview_x, preview_y, escala_preview, escala_preview, 0, c_white, 1);
    }

    draw_set_color(c_white);
    draw_text_transformed(preview_x, preview_y + painel_h * 0.27, global.lista_skins[skin_selecionada], 0.65, 0.65, 0);

    var bx = painel_x + painel_w * 0.65;
    var by = painel_y + painel_h - 60;
    var bw = painel_w * 0.30;

    draw_set_color(global.skin == skin_selecionada ? make_color_rgb(50, 105, 65) : cor_destaque);
    draw_rectangle(bx, by, bx + bw, by + 42, false);

    draw_set_color(c_white);
    draw_text_transformed(bx + bw / 2, by + 21, global.skin == skin_selecionada ? "EQUIPADA" : "EQUIPAR SKIN", 0.65, 0.65, 0);
}

if (aba == 1) {
    draw_set_halign(fa_left);
    draw_set_color(c_white);
    draw_text_transformed(painel_x + 18, painel_y + 35, "CLIQUE EM UM SOM PARA OUVIR", 0.65, 0.65, 0);

    var grade_x = painel_x + 18;
    var grade_y = painel_y + 65;
    var colunas = 5;
    var espacamento = 7;
    var total_sons = array_length(global.sons);
    var cel_w = (painel_w - 36 - (colunas - 1) * espacamento) / colunas;
    var cel_h = min(58, (painel_h - 100) / 6);

    for (var i = 0; i < total_sons; i++) {
        var col = i mod colunas;
        var lin = i div colunas;
        var sx = grade_x + col * (cel_w + espacamento);
        var sy = grade_y + lin * (cel_h + espacamento);

        draw_set_color(i == audio_selecionado ? cor_destaque : cor_celula);
        draw_rectangle(sx, sy, sx + cel_w, sy + cel_h, false);

        draw_set_color(c_white);
        draw_set_halign(fa_center);
        draw_text_transformed(sx + cel_w / 2, sy + cel_h / 2, "ÁUDIO " + string(i + 1), 0.6, 0.6, 0);
    }

    draw_set_color(make_color_rgb(130, 40, 40));
    draw_rectangle(gui_w - 155, gui_h - 63, gui_w - 35, gui_h - 25, false);

    draw_set_color(c_white);
    draw_set_halign(fa_center);
    draw_text_transformed(gui_w - 95, gui_h - 44, "PARAR ÁUDIO", 0.6, 0.6, 0);

    draw_set_halign(fa_left);

    if (audio_tocando != -1) {
        draw_text_transformed(painel_x + 18, gui_h - 17, "Reproduzindo: áudio " + string(audio_selecionado + 1), 0.55, 0.55, 0);
    }
}

draw_set_alpha(1);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);
