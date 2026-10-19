// Pausa com Esc
if (keyboard_check_pressed(vk_escape))
{
    pausado = !pausado;
}

// Pausa com dois cliques no scroll
if (mouse_check_button_pressed(mb_middle))
{
    if (current_time - ultimo_clique_scroll <= 350)
    {
        pausado = !pausado;
        ultimo_clique_scroll = -1000;
    }
    else
    {
        ultimo_clique_scroll = current_time;
    }
}
if (pausado)
{
    var mx = device_mouse_x_to_gui(0);
    var my = device_mouse_y_to_gui(0);

    var xx = display_get_gui_width() * 0.5;
    var yy = display_get_gui_height() * 0.5;

    for (var i = 0; i < array_length(opcoes); i++)
    {
        var texto_y = yy + i * 32;
        
        if (mx >= xx - 120 && mx <= xx + 120 &&
            my >= texto_y && my <= texto_y + 28)
        {
            selecionado = i;

            if (mouse_check_button_pressed(mb_left))
            {
                switch (selecionado)
                {
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
                        with (Obj_Gordo)
                        {
                            contador = 0;
                        }
                    break;

                    case 4:
                        with (Obj_Gordo)
                        {
                            contador_streaming = 0;
                        }

                        global.contador = !global.contador;
                    break;

                    case 5:
                        global.skin++;

                        if (global.skin > 8)
                        {
                            global.skin = 0;
                        }
                    break;

                    case 6:
                        room_goto(menu);
                    break;
                }
            }
        }
    }

    if (keyboard_check_pressed(vk_up))
    {
        selecionado--;

        if (selecionado < 0)
        {
            selecionado = array_length(opcoes) - 1;
        }
    }

    if (keyboard_check_pressed(vk_down))
    {
        selecionado++;

        if (selecionado >= array_length(opcoes))
        {
            selecionado = 0;
        }
    }

    if (keyboard_check_pressed(vk_enter))
    {
        switch (selecionado)
        {
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
                with (Obj_Gordo)
                {
                    contador = 0;
                }
            break;

            case 4:
                with (Obj_Gordo)
                {
                    contador_streaming = 0;
                }

                global.contador = !global.contador;
            break;

            case 5:
                global.skin++;

                if (global.skin > 8)
                {
                    global.skin = 0;
                }
            break;

            case 6:
                room_goto(menu);
            break;
        }
    }
}
