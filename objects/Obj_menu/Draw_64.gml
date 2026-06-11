var espacamento = 80;

for (var i = 0; i < qtd; i++)
{
    var diferenca = i - pos;

    var _x = display_get_gui_width() - 250 + abs(diferenca) * 60;
    var _y = display_get_gui_height() * 0.5 + diferenca * espacamento;

    var _w = larg_ini;
    var _h = alt_ini;
    var _cor = c_white;

	var _marg = 0;
	
    if (i == indice)
    {
        _w = larg;
        _h = alt;
        _cor = c_red;
        _x += 50;
    }

    draw_sprite_stretched(
        Spr_butum,
        0,
        _x - _w * 0.5,
        _y - _h * 0.5,
        _w,
        _h
    );

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_cor);
    draw_text(_x, _y, meno[i]);
	draw_set_color(c_white)
	
var wave_x = sin(current_time * 0.003) * 20;
var wave_y = cos(current_time * 0.004) * 15;
var angulo = sin(current_time * 0.002) * 5;

draw_sprite_ext(
    Spr_icone,
    0,
    180 + wave_x,
    display_get_gui_height() * 0.5 + wave_y,
    5, 5,
    angulo,
    c_white,
    1
);

}