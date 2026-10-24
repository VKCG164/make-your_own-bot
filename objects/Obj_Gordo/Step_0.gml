
if (instance_exists(Obj_pausar) && Obj_pausar.pausado) exit;

audioExtStep();

if (!is_array(fila_sons)) fila_sons = [];
if (!is_array(sons)) sons = global.sons;

sons = global.sons;

if (!variable_instance_exists(id, "tempo_aparicao")) tempo_aparicao = 0;
if (!variable_instance_exists(id, "gordo_visivel")) gordo_visivel = true;

if (som_tocando != -1) {
    som_tempo_restante--;

    if (som_tempo_restante <= 0) {
        som_tocando = -1;
        som_recurso_tocando = -1;
        som_voz = -1;
        som_tempo_restante = 0;
    }
}

if (som_tocando == -1 && array_length(fila_sons) > 0) {
    var som_fila = fila_sons[0];
    fila_sons = array_delete(fila_sons, 0, 1);

    if (som_fila != -1 && !is_undefined(som_fila)) {
        var duracao_som = audio_sound_length(som_fila);

        if (duracao_som <= 0) duracao_som = 3;

        som_voz = audio_play_sound(som_fila, 0, false);

        if (som_voz != -1) {
            som_tocando = som_fila;
            som_recurso_tocando = som_fila;
            som_tempo_restante = max(1, ceil(duracao_som * room_speed));
        } else {
            som_tocando = -1;
            som_recurso_tocando = -1;
            som_voz = -1;
            som_tempo_restante = 0;
        }
    }
}

if (keyboard_check_pressed(ord("Q"))) {
    var som_sorteado = sortear_som();

    if (som_sorteado != -1) {
        if (room == video) {
            image_alpha = 1;
            gordo_visivel = true;
            explosao = true;
            explosao_frame = 0;

            audio_play_sound(So_vineBoom, 0, false);

            proximo_som = som_sorteado;
            alarm[0] = room_speed;
        } else {
            colocar_som_na_fila(som_sorteado);
        }
    }
}

falando = som_tocando != -1 && som_recurso_tocando != So_vineBoom;

if (falando) {
    image_alpha = 1;
    gordo_visivel = true;
    tempo_aparicao = ceil(room_speed * 0.5);

    if (sprite_index != spr_falando) {
        sprite_index = spr_falando;
        image_index = 0;
    }
} else {
    if (sprite_index != spr_idle) {
        sprite_index = spr_idle;
        image_index = 0;
    }
}

if (room == video) {
    if (falando || audio_is_playing(So_vineBoom)) {
        image_alpha = 1;
        gordo_visivel = true;
    } else {
        image_alpha = max(0, image_alpha - 0.02);

        if (image_alpha <= 0) {
            gordo_visivel = false;
        }
    }
} else {
    image_alpha = 1;
    gordo_visivel = true;
}

if (falando != falando_anterior) {
    boing_fala = 1;
    falando_anterior = falando;
} else {
    boing_fala = max(0, boing_fala - 0.08);
}

if (keyboard_check_pressed(ord("W"))) global.contador = !global.contador;
if (keyboard_check_pressed(ord("E"))) global.interface_oculta = !global.interface_oculta;

wave += 0.1;

var total_skins = array_length(global.lista_skins);

if (total_skins > 0) {
    global.skin = clamp(global.skin, 0, total_skins - 1);

    if (skin_aplicada != global.skin) {
        spr_idle = global.skins_idle[global.skin];
        spr_falando = global.skins_falando[global.skin];
        skin_aplicada = global.skin;
        sprite_index = falando ? spr_falando : spr_idle;
        image_index = 0;
		ini_open("botConfig.ini");
        ini_write_real("botConfig", "skin", global.skin);
        ini_close();

        show_debug_message("Skin salva: " + string(global.skin));
    }
}

if (global.contador) contador--;

if (room == Streaming && global.contador) {
    contador_streaming++;

    if (!tocou_streaming && contador_streaming >= segundo_sorteado * room_speed) {
        var som_streaming = sortear_som();

        if (som_streaming != -1) {
            tocou_streaming = true;
            contador_streaming = 0;
            colocar_som_na_fila(som_streaming);
        }
    }

    if (contador_streaming >= streaming * room_speed) {
        contador_streaming = 0;
        segundo_sorteado = irandom_range(1, max(1, streaming));
        tocou_streaming = false;
    }
}

if (global.contador && contador <= 0) {
    contador = room_speed * tempo_troca;

    var som_timer = sortear_som();

    if (som_timer != -1) {
        if (room == video) {
            image_alpha = 1;
            gordo_visivel = true;
            explosao = true;
            explosao_frame = 0;

            audio_play_sound(So_vineBoom, 0, false);

            proximo_som = som_timer;
            alarm[0] = room_speed;
        } else {
            colocar_som_na_fila(som_timer);
        }
    }
}

if (explosao) {
    explosao_frame += 0.4;

    if (explosao_frame >= sprite_get_number(Spr_explosao)) {
        explosao = false;
    }
}

if (mouse_check_button_pressed(mb_left)) {
    var mx = mouse_x;
    var my = mouse_y;

    var largura = sprite_index != -1
        ? sprite_get_width(sprite_index) * abs(image_xscale)
        : 100 * abs(image_xscale);

    var altura = sprite_index != -1
        ? sprite_get_height(sprite_index) * abs(image_yscale)
        : 100 * abs(image_yscale);

    if (mx >= x - largura / 2 && mx <= x + largura / 2
    && my >= y - altura / 2 && my <= y + altura / 2) {
        arrastando = true;
        arrasto_offset_x = x - mx;
        arrasto_offset_y = y - my;
    }
}

if (arrastando && mouse_check_button(mb_left)) {
    x = mouse_x + arrasto_offset_x;
    y = mouse_y + arrasto_offset_y;
}

if (mouse_check_button_released(mb_left)) arrastando = false;

if (arrastando) {
    escala_boing += 0.3;
    boing_y = 1 + sin(escala_boing) * 0.08;
    boing_x = 1 - sin(escala_boing) * 0.05;
} else {
    boing_x = lerp(boing_x, 1, 0.2);
    boing_y = lerp(boing_y, 1, 0.2);
}

if (mouse_wheel_up()) {
    image_xscale += 0.1;
    image_yscale += 0.1;
}

if (mouse_wheel_down()) {
    image_xscale = max(0.5, image_xscale - 0.1);
    image_yscale = max(0.5, image_yscale - 0.1);
}

if (keyboard_check_pressed(ord("R"))) {
    ini_open("botConfig.ini");
    ini_write_real("botConfig", "x", x);
    ini_write_real("botConfig", "y", y);
    ini_write_real("botConfig", "escala_x", image_xscale);
    ini_write_real("botConfig", "escala_y", image_yscale);
    ini_close();

    mensagem_salva = "Posição salva!";
    alpha_mensagem = 0;
    tempo_mensagem = room_speed * 2;
}

if (tempo_mensagem > 0) {
    tempo_mensagem--;

    if (tempo_mensagem > room_speed) {
        alpha_mensagem = min(1, alpha_mensagem + 0.08);
    } else {
        alpha_mensagem = max(0, alpha_mensagem - 0.04);
    }
} else {
    alpha_mensagem = 0;
}

if (keyboard_check_pressed(ord("T"))) {
    digitando_tempo = !digitando_tempo;

    if (digitando_tempo) texto_tempo = "";
}

if (digitando_tempo) {
    for (var i = ord("0"); i <= ord("9"); i++) {
        if (keyboard_check_pressed(i)) {
            texto_tempo += chr(i);
        }
    }

    for (var j = vk_numpad0; j <= vk_numpad9; j++) {
        if (keyboard_check_pressed(j)) {
            texto_tempo += string(j - vk_numpad0);
        }
    }

    if (keyboard_check_pressed(vk_backspace) && string_length(texto_tempo) > 0) {
        texto_tempo = string_delete(texto_tempo, string_length(texto_tempo), 1);
    }

    if (keyboard_check_pressed(vk_enter)) {
        if (string_length(texto_tempo) > 0) {
            var novo_tempo = max(1, real(texto_tempo));

            if (room == Streaming) {
                streaming = novo_tempo * 60;
                segundo_sorteado = irandom_range(1, max(1, streaming));
                contador_streaming = 0;
                tocou_streaming = false;
            } else {
                contador = novo_tempo * 60 * room_speed;
            }
        }

        digitando_tempo = false;
    }
}
ini_open("botConfig.ini");
ini_write_real("botConfig", "skin", global.skin);
ini_close();