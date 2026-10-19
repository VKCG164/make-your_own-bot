
var _up = keyboard_check_pressed(vk_up);
var _down = keyboard_check_pressed(vk_down);
var _input = _down - _up;

var menu_ref;

if (menu_atual == 0)
{
    menu_ref = meno;
}
else
{
    menu_ref = meno2;
}

var qtd = array_length(menu_ref);
var espacamento = 80;

var mx = device_mouse_x_to_gui(0);
var my = device_mouse_y_to_gui(0);

// Selecionar com o mouse
for (var i = 0; i < qtd; i++)
{
    var diferenca = i - pos;

    var _x = display_get_gui_width() - 250 + abs(diferenca) * 60;
    var _y = display_get_gui_height() * 0.5 + diferenca * espacamento;

    if (i == indice)
    {
        _x += 50;
    }

    var _w = (i == indice) ? larg : larg_ini;
    var _h = (i == indice) ? alt : alt_ini;

    if (mx >= _x - _w * 0.5 &&
        mx <= _x + _w * 0.5 &&
        my >= _y - _h * 0.5 &&
        my <= _y + _h * 0.5)
    {
        if (indice != i)
        {
            indice = i;
            audio_play_sound(So_slide, 2, false);
        }
    }
}

// Navegação pelo teclado
if (_input != 0)
{
    indice += _input;

    if (indice > qtd - 1)
    {
        indice = 0;
    }

    if (indice < 0)
    {
        indice = qtd - 1;
    }

    larg = larg_ini;
    alt = alt_ini;
    texto_escala = texto_escala_ini;

    audio_play_sound(So_slide, 2, false);
}

// Limites da seleção
if (indice >= qtd)
{
    indice = 0;
}

if (indice < 0)
{
    indice = qtd - 1;
}

// Animações
pos = lerp(pos, indice, 0.1);
larg = lerp(larg, larg_fim, 0.1);

if (larg > larg_fim - 2)
{
    alt = lerp(alt, alt_fim, 0.1);
}

texto_escala = lerp(texto_escala, texto_escala_fim, 0.1);

// Confirmar com mouse ou Enter
var confirmar = mouse_check_button_pressed(mb_left)
    || keyboard_check_pressed(vk_enter);

if (confirmar)
{
    if (menu_atual == 0)
    {
        switch (indice)
        {
            case 0:
                room_goto(video);
            break;

            case 1:
                room_goto(Streaming);
            break;

            case 2:
                menu_atual = 1;
                indice = 0;
                pos = 0;
                larg = larg_ini;
                alt = alt_ini;
                texto_escala = texto_escala_ini;
            break;

            case 3:
                game_end();
            break;
        }
    }
    else
    {
        switch (indice)
        {
            case 0:
                global.fundo++;
            break;

            case 1:
                global.musica = !global.musica;

                if (global.musica)
                {
                    show_message("Musica ON");
                }
                else
                {
                    show_message("Musica OFF");
                }
            break;

            case 2:
                menu_atual = 0;
                indice = 0;
                pos = 0;
                larg = larg_ini;
                alt = alt_ini;
                texto_escala = texto_escala_ini;
            break;
        }
    }

    audio_play_sound(So_slide, 2, false);
}
