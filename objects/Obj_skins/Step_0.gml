gui_w = display_get_gui_width();
gui_h = display_get_gui_height();

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var painel_x = 24;
var painel_y = 62;
var painel_w = gui_w - 48;
var painel_h = gui_h - 86;

var tab_w = 120;
var tab_h = 32;
var voltar_x = gui_w - 145;
var voltar_y = 18;

if (mouse_check_button_pressed(mb_left)) {
    if (point_in_rectangle(mx, my,
        painel_x, 18, painel_x + tab_w, 18 + tab_h)) {
        aba = 0;
    }
    else if (point_in_rectangle(mx, my,
        painel_x + tab_w + 8, 18,
        painel_x + tab_w * 2 + 8, 18 + tab_h)) {
        aba = 1;
    }
    else if (point_in_rectangle(mx, my,
        voltar_x, voltar_y, voltar_x + 120, voltar_y + tab_h)) {

        if (audio_tocando != -1) {
            audio_stop_sound(audio_tocando);
            audio_tocando = -1;
        }

        room_goto(menu);
    }
    else if (aba == 0) {
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

            if (point_in_rectangle(mx, my,
                sx, sy, sx + cel_w, sy + cel_h)) {
                skin_selecionada = i;
            }
        }

        var bx = painel_x + painel_w * 0.65;
        var by = painel_y + painel_h - 60;
        var bw = painel_w * 0.30;

        if (point_in_rectangle(mx, my, bx, by, bx + bw, by + 42)) {
            global.skin = skin_selecionada;
        }
    }
    else if (aba == 1) {
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

            if (point_in_rectangle(mx, my,
                sx, sy, sx + cel_w, sy + cel_h)) {

                audio_selecionado = i;

                if (audio_tocando != -1) {
                    audio_stop_sound(audio_tocando);
                    audio_tocando = -1;
                }

                audio_tocando = audio_play_sound(global.sons[i], 1, false);
            }
        }

        var px = gui_w - 155;
        var py = gui_h - 63;

        if (point_in_rectangle(mx, my, px, py, px + 120, py + 38)) {
            if (audio_tocando != -1) {
                audio_stop_sound(audio_tocando);
                audio_tocando = -1;
            }
        }
    }
}