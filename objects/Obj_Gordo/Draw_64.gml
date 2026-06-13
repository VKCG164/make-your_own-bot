var texto;

if (room == Streaming)
{
    var segundos = floor(contador_streaming / room_speed);

    var mini = segundos div 60;
    var seg = segundos mod 60;

    texto = string_format(mini, 2, 0) + ":" +
            string_format(seg, 2, 0);
}
else
{
    var segundos = ceil(contador / room_speed);

    var mini = segundos div 60;
    var seg = segundos mod 60;

    texto = string_format(mini, 2, 0) + ":" +
            string_format(seg, 2, 0);
}

draw_set_font(Fonte_jogo2);

// Tempo no topo central
draw_set_halign(fa_center);
draw_set_valign(fa_top);

draw_text(
    display_get_gui_width() * 0.5,
    10,
    texto
);

// Campo de edicao
if (digitando_tempo)
{
    draw_text(
        display_get_gui_width() * 0.5,
        50,
        "Minutos: " + texto_tempo + "_"
    );
}

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_font(-1);