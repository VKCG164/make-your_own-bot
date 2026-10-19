
if (pausado)
{
    draw_set_font(Fonte_jogo2);
    draw_set_alpha(0.8);
    draw_set_color(c_black);

    draw_rectangle(
        0, 0,
        display_get_gui_width(),
        display_get_gui_height(),
        false
    );

    draw_set_alpha(1);

    var xx = display_get_gui_width() * 0.5;
    var yy = display_get_gui_height() * 0.5;

    draw_set_halign(fa_center);
    draw_set_valign(fa_top);

    draw_set_color(c_white);
    draw_text(xx, yy - 120, "PAUSA");

    for (var i = 0; i < array_length(opcoes); i++)
    {
        var texto_y = yy + i * 32;

        if (i == selecionado)
        {
            draw_set_color(c_yellow);
            draw_text(xx, texto_y, "> " + opcoes[i] + " <");
        }
        else
        {
            draw_set_color(c_white);
            draw_text(xx, texto_y, opcoes[i]);
        }
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}
