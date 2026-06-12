var _up = keyboard_check_pressed(vk_up)
var _down =keyboard_check_pressed(vk_down)
var _input = _down - _up;

var menu_ref;

if (menu_atual == 0)
    menu_ref = meno;
else
    menu_ref = meno2;

qtd = array_length(menu_ref);
if (_input !=0){
	indice+=_input;
	larg=larg_ini
	alt= alt_ini
    texto_escala = texto_escala_ini;
	audio_play_sound(So_slide,2,0)
}
if (indice>qtd-1)
{indice =0}
if (indice<0){ indice = qtd-1}

pos = lerp(pos,indice,.1)
larg = lerp(larg,larg_fim,.1)
if (larg> larg_fim-2){
 alt= lerp(alt,alt_fim,.1)
}

texto_escala = lerp(texto_escala, texto_escala_fim, .1);
if (keyboard_check_pressed(vk_enter))
{
    if (menu_atual == 0)
    {
        switch (indice)
        {
            case 0: // Gravar
                room_goto(video);
            break;

            case 1: // Streaming
                room_goto(Streaming);
            break;

            case 2: // Tela
                menu_atual = 1;
                indice = 0;
                pos = 0;
            break;

            case 3: // Sair
                game_end();
            break;
        }
    }
    else
    {
        switch (indice)
        {
            case 0:
			if keyboard_check_pressed(vk_enter){
			global.fundo++
			}
            break;

            case 1: // Musica
                global.musica = !global.musica;

                if (global.musica)
                    show_message("Musica ON");
                else
                    show_message("Musica OFF");
            break;

            case 2: // Voltar
                menu_atual = 0;
                indice = 0;
                pos = 0;
            break;
        }
    }

    audio_play_sound(So_slide,2,false);
}