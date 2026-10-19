
wave += 0.1;


var total_skins = array_length(global.lista_skins);

if (total_skins > 0) {
    global.skin = clamp(global.skin, 0, total_skins - 1);

    if (skin_aplicada != global.skin) {
        var estava_falando = (sprite_index == spr_falando);

        spr_idle = global.skins_idle[global.skin];
        spr_falando = global.skins_falando[global.skin];

        if (estava_falando) {
            sprite_index = spr_falando;
        } else {
            sprite_index = spr_idle;
        }

        skin_aplicada = global.skin;
    }
}


// Contador
if (global.contador)
{
    contador--;
}

// Streaming
if (room == Streaming && global.contador)
{
    contador_streaming++;

    if (!tocou_streaming &&
        contador_streaming >= segundo_sorteado * room_speed)
    {
        var novo_som = ultimo_som;

        while (novo_som == ultimo_som)
        {
            novo_som = irandom(array_length(sons) - 1);
        }

        ultimo_som = novo_som;
        tocou_streaming = true;
        contador_streaming = 0;

        audio_play_sound(sons[ultimo_som], 0, false);
    }

    if (contador_streaming >= streaming * room_speed)
    {
        contador_streaming = 0;
        segundo_sorteado = irandom_range(60, streaming);
        tocou_streaming = false;
    }
}

// Verificar se esta falando
falando = false;

for (var i = 0; i < array_length(sons); i++)
{
    if (audio_is_playing(sons[i]))
    {
        falando = true;
        break;
    }
}

// Boing ao comecar ou parar de falar
if (falando != falando_anterior)
{
    boing_fala = 1;
    falando_anterior = falando;
}
else
{
    boing_fala = max(0, boing_fala - 0.08);
}

// Audio do contador
if (global.contador && contador <= 0)
{
    contador = room_speed * tempo_troca;

    var novo_som = ultimo_som;

    while (novo_som == ultimo_som)
    {
        novo_som = irandom(array_length(sons) - 1);
    }

    ultimo_som = novo_som;

    if (room == video)
    {
        image_alpha = 1;
        explosao = true;
        explosao_frame = 0;

        audio_play_sound(So_vineBoom, 0, false);

        proximo_som = novo_som;
        alarm[0] = room_speed;
    }
    else
    {
        audio_play_sound(sons[ultimo_som], 0, false);
    }
}

// Video
if (room == video)
{
    if (!falando && !audio_is_playing(So_vineBoom))
    {
        image_alpha = max(0, image_alpha - 0.02);
    }
}

// Explosao
if (explosao)
{
    explosao_frame += 0.4;

    if (explosao_frame >= sprite_get_number(Spr_explosao))
    {
        explosao = false;
    }
}

// Arrastar o Gordo
if (mouse_check_button_pressed(mb_left))
{
    var mx = mouse_x;
    var my = mouse_y;

    var largura = 100 * abs(image_xscale);
    var altura = 100 * abs(image_yscale);

    if (sprite_index != -1)
    {
        largura = sprite_get_width(sprite_index) * abs(image_xscale);
        altura = sprite_get_height(sprite_index) * abs(image_yscale);
    }

    if (mx >= x - largura / 2 &&
        mx <= x + largura / 2 &&
        my >= y - altura / 2 &&
        my <= y + altura / 2)
    {
        arrastando = true;
        arrasto_offset_x = x - mx;
        arrasto_offset_y = y - my;
    }
}

if (arrastando && mouse_check_button(mb_left))
{
    x = mouse_x + arrasto_offset_x;
    y = mouse_y + arrasto_offset_y;
}

if (mouse_check_button_released(mb_left))
{
    arrastando = false;
}

// Boing ao segurar
if (arrastando)
{
    escala_boing += 0.3;

    boing_y = 1 + sin(escala_boing) * 0.08;
    boing_x = 1 - sin(escala_boing) * 0.05;
}
else
{
    boing_x = lerp(boing_x, 1, 0.2);
    boing_y = lerp(boing_y, 1, 0.2);
}

// Aumentar tamanho
if (mouse_wheel_up())
{
    image_xscale += 0.1;
    image_yscale += 0.1;
}

// Diminuir tamanho
if (mouse_wheel_down())
{
    image_xscale = max(0.5, image_xscale - 0.1);
    image_yscale = max(0.5, image_yscale - 0.1);
}

// Salvar posicao e escala
if (keyboard_check_pressed(vk_f1))
{
    ini_open("gordo.ini");

    ini_write_real("Gordo", "x", x);
    ini_write_real("Gordo", "y", y);
    ini_write_real("Gordo", "escala_x", image_xscale);
    ini_write_real("Gordo", "escala_y", image_yscale);

    ini_close();
}

// Ativar edicao do contador
if (keyboard_check_pressed(ord("T")))
{
    digitando_tempo = !digitando_tempo;

    if (digitando_tempo)
    {
        texto_tempo = "";
    }
}

// Digitar tempo
if (digitando_tempo)
{
    for (var i = ord("0"); i <= ord("9"); i++)
    {
        if (keyboard_check_pressed(i))
        {
            texto_tempo += chr(i);
        }
    }

    for (var i = vk_numpad0; i <= vk_numpad9; i++)
    {
        if (keyboard_check_pressed(i))
        {
            texto_tempo += string(i - vk_numpad0);
        }
    }

    if (keyboard_check_pressed(vk_backspace))
    {
        if (string_length(texto_tempo) > 0)
        {
            texto_tempo = string_delete(
                texto_tempo,
                string_length(texto_tempo),
                1
            );
        }
    }

    if (keyboard_check_pressed(vk_enter))
    {
        if (string_length(texto_tempo) > 0)
        {
            var novo_tempo = max(1, real(texto_tempo));

            if (room == Streaming)
            {
                streaming = novo_tempo * 60;
                segundo_sorteado = irandom_range(60, streaming);
            }
            else
            {
                contador = novo_tempo * 60 * room_speed;
            }
        }

        digitando_tempo = false;
    }
}
