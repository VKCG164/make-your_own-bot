// Abre e fecha o menu
if (keyboard_check_pressed(vk_escape))
{
    pausado = !pausado;
}

if (pausado)
{
    // Navegação
    if (keyboard_check_pressed(vk_up))
    {
        selecionado--;
        if (selecionado < 0)
            selecionado = array_length(opcoes) - 1;
    }

    if (keyboard_check_pressed(vk_down))
    {
        selecionado++;
        if (selecionado >= array_length(opcoes))
            selecionado = 0;
    }

    // Selecionar opção
    if (keyboard_check_pressed(vk_enter))
    {
        switch (selecionado)
        {
            case 0: // Continuar
                pausado = false;
            break;

            case 1: // Cor de Fundo
              global.fundo++
            break;

            case 2: // Música
                global.musica = !global.musica;
            break;

            case 3: 
			Obj_Gordo.contador=0;
            break;
            case 4: 
				Obj_Gordo.contador_streaming=0
				global.contador= !global.contador
            break;// Sair
			case 5:
				global.skin++
			break;
			case 6:
			room_goto(menu)
			break
        }
    }
}