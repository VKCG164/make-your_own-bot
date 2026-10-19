
var espacamento = 80;
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

for (var i = 0; i < qtd; i++)
{
    var diferenca = i - pos;

    var _x = display_get_gui_width() - 250
        + abs(diferenca) * 60;

    var _y = display_get_gui_height() * 0.5
        + diferenca * espacamento;

    var _escala = texto_escala_ini;
    var _w = larg_ini;
    var _h = alt_ini;
    var _cor = c_white;

    if (i == indice)
    {
        _w = larg;
        _h = alt;
        _cor = c_red;
        _escala = texto_escala;
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

    draw_text_transformed(
        _x,
        _y,
        menu_ref[i],
        _escala,
        _escala,
        0
    );
}

draw_set_color(c_white);

var wave_x = sin(current_time * 0.003) * 20;
var wave_y = cos(current_time * 0.004) * 15;
var angulo = sin(current_time * 0.002) * 5;

var caveira_x = 180 + wave_x;
var caveira_y = display_get_gui_height() * 0.5 + wave_y;

draw_sprite_ext(
    Spr_icone, 0,
    caveira_x - 90, caveira_y - 140,
    6, 6, angulo, c_white, 1
);

draw_sprite_ext(
    Spr_titulo, 0,
    caveira_x + 100, caveira_y - 370,
    4, 4, 0, c_white, 1
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_color(c_white);
