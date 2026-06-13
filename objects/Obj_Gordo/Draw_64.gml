var segundos = ceil(contador / room_speed);

var mini = segundos div 60;
var seg = segundos mod 60;

var texto = string_format(mini, 2, 0) + ":" + string_format(seg, 2, 0);

draw_set_font(Fonte_jogo2);

var xx = display_get_gui_width() - string_width(texto) - 10;
var yy = display_get_gui_height() - string_height(texto) - 10;

draw_text(xx, yy, texto);

draw_set_font(-1);