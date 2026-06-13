wave += 0.1;

// So funciona quando o menu liberar
if (global.contador)
{
    contador--;
}

// Verifica se esta falando
falando = false;

for (var i = 0; i < array_length(sons); i++)
{
    if (audio_is_playing(sons[i]))
    {
        falando = true;
        break;
    }
}

// ROOM VIDEO
if (room == video)
{
    // Fade out quando nao esta falando
    if (!falando && !audio_is_playing(So_vineBoom))
    {
        image_alpha = max(0, image_alpha - 0.02);
    }

    if (global.contador && contador <= 0)
    {
        contador = room_speed * tempo_troca;

        var novo_som = ultimo_som;

        while (novo_som == ultimo_som)
        {
            novo_som = irandom(array_length(sons) - 1);
        }

        ultimo_som = novo_som;

        image_alpha = 1;

        explosao = true;
        explosao_frame = 0;

        audio_play_sound(So_vineBoom, 0, false);

        alarm[0] = room_speed;
        proximo_som = novo_som;
    }
}
else
{
    if (global.contador && contador <= 0)
    {
        contador = room_speed * tempo_troca;

        var novo_som = ultimo_som;

        while (novo_som == ultimo_som)
        {
            novo_som = irandom(array_length(sons) - 1);
        }

        ultimo_som = novo_som;

        audio_play_sound(sons[ultimo_som], 0, false);
    }
}

// Animacao da explosao
if (explosao)
{
    explosao_frame += 0.4;

    if (explosao_frame >= sprite_get_number(Spr_explosao))
    {
        explosao = false;
    }
}