var _up = keyboard_check_pressed(vk_up)
var _down =keyboard_check_pressed(vk_down)
var _input = _down - _up;

if (_input !=0){
	indice+=_input;
	larg=larg_ini
	alt= alt_ini
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