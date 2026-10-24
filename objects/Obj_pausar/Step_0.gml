
if (keyboard_check_pressed(vk_escape)) {
    pausado = !pausado;
}

if (mouse_check_button_pressed(mb_middle)) {
    if (current_time - ultimo_clique_scroll <= 350) {
        pausado = !pausado;
        ultimo_clique_scroll = -1000;
    } else {
        ultimo_clique_scroll = current_time;
    }
}

animacao_menu = lerp(
    animacao_menu,
    pausado ? 1 : 0,
    velocidade_menu
);

if (abs(animacao_menu - (pausado ? 1 : 0)) < 0.005) {
    animacao_menu = pausado ? 1 : 0;
}

if (!pausado) {
    exit;
}

var qtd = array_length(opcoes);
var gh = display_get_gui_height();
var gw = display_get_gui_width();
var espacamento = min(gh * 0.12, 95);

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

var _up = keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(vk_down);
var _input = _down - _up;

for (var i = 0; i < qtd; i++) {
    var diferenca = i - pos;

    var _x = gw - 280 + abs(diferenca) * 60;
    var _y = gh * 0.5 + diferenca * espacamento;

    if (i == indice) {
        _x += 50;
    }

    var _w = (i == indice) ? larg : larg_ini;
    var _h = (i == indice) ? alt : alt_ini;

    if (mx >= _x - _w * 0.5 &&
        mx <= _x + _w * 0.5 &&
        my >= _y - _h * 0.5 &&
        my <= _y + _h * 0.5) {
        if (indice != i) {
            indice = i;
            audio_play_sound(So_slide, 2, false);
        }
    }
}

if (_input != 0) {
    indice += _input;

    if (indice >= qtd) {
        indice = 0;
    }

    if (indice < 0) {
        indice = qtd - 1;
    }

    larg = larg_ini;
    alt = alt_ini;
    texto_escala = texto_escala_ini;

    audio_play_sound(So_slide, 2, false);
}

indice = clamp(indice, 0, qtd - 1);

pos = lerp(pos, indice, 0.1);
larg = lerp(larg, larg_fim, 0.1);

if (larg > larg_fim - 2) {
    alt = lerp(alt, alt_fim, 0.1);
}

texto_escala = lerp(texto_escala, texto_escala_fim, 0.1);
texto_pulso += 0.15;

if (texto_clique > 0) {
    texto_clique = max(0, texto_clique - 0.12);
}

var confirmar = mouse_check_button_pressed(mb_left)
    || keyboard_check_pressed(vk_enter);

if (confirmar) {
    texto_clique = 1;
    texto_clique_indice = indice;

    switch (indice) {
        case 0:
            pausado = false;
        break;

        case 1:
            global.fundo++;
        break;

        case 2:
            global.musica = !global.musica;
        break;

        case 3:
            global.contador = !global.contador;

            if (instance_exists(Obj_Gordo)) {
                with (Obj_Gordo) {
                    contador_streaming = 0;
                    tocou_streaming = false;
                }
            }
        break;

        case 4:
            if (instance_exists(Obj_Gordo)) {
                with (Obj_Gordo) {
                    ini_open("botConfig.ini");
                    ini_write_real("botConfig", "x", x);
                    ini_write_real("botConfig", "y", y);
                    ini_write_real("botConfig", "escala_x", image_xscale);
                    ini_write_real("botConfig", "escala_y", image_yscale);
                    ini_write_real("botConfig", "skin", global.skin);
                    ini_close();
                }

                show_debug_message("Posicao, escala e skin salvas!");
            }
        break;

        case 5:
            pausado = false;
            room_goto(menu);
        break;
    }

    audio_play_sound(So_slide, 2, false);
}
