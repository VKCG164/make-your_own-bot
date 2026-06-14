// Atualizacao
wave += 0.1;
switch (global.skin)
{
    case 0:
        spr_idle =Spr_GDidle;
        spr_falando = Spr_GDf_falando;
    break;

    case 1:
        spr_idle = Spr_GDdroid;
        spr_falando = Spr_GDdroid_falando;
    break;

    case 2:
        spr_idle = Spr_GDjao;
        spr_falando = Spr_GDjao_falando;
    break;

    case 3:
        spr_idle = Spr_GDjemin;
        spr_falando = Spr_GDjeimin_falando;
    break;
}

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

// Falando
falando = false;

for (var i = 0; i < array_length(sons); i++)
{
    if (audio_is_playing(sons[i]))
    {
        falando = true;
        break;
    }
}

// Audio
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

// Editor

if (mouse_check_button(mb_left))
{
    x = mouse_x;
    y = mouse_y;
}

if (mouse_wheel_up())
{
    image_xscale += 0.1;
    image_yscale += 0.1;
}

if (mouse_wheel_down())
{
    image_xscale = max(0.5, image_xscale - 0.1);
    image_yscale = max(0.5, image_yscale - 0.1);
}

// Salvar
if (keyboard_check_pressed(vk_f1))
{
    ini_open("gordo.ini");

    ini_write_real("Gordo", "x", x);
    ini_write_real("Gordo", "y", y);
    ini_write_real("Gordo", "escala_x", image_xscale);
    ini_write_real("Gordo", "escala_y", image_yscale);

    ini_close();
}
// Editar contador
if (keyboard_check_pressed(ord("T")))
{
    digitando_tempo = !digitando_tempo;

    if (digitando_tempo)
    {
        texto_tempo = "";
    }
}

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
    var novo_tempo = real(texto_tempo);

    if (room == Streaming)
    {
        // Salva o limite maximo em segundos
        streaming = novo_tempo * 60;

        // Sorteia novamente usando o novo limite
        segundo_sorteado = irandom_range(60, streaming);
    }
    else
    {
        contador = novo_tempo * 60 * room_speed;
    }

    digitando_tempo = false;
}
}