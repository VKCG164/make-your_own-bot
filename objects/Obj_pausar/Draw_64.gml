
if (pausado || animacao_menu > 0.01) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();

    var entrada = animacao_menu;
    var vermelho = c_red;

    var deslocamento_menu = (1 - entrada) * gw * 0.35;
    var espacamento = min(gh * 0.12, 95);


    draw_set_alpha(entrada);
    draw_set_color(vermelho);

    draw_triangle(
        gw * 0.69, gh,
        gw, gh,
        gw, 0,
        false
    );

    draw_triangle(
        gw * 0.69, gh,
        gw, 0,
        gw * 0.83, 0,
        false
    );

    var titulo_x = gw * 0.18 - deslocamento_menu;
    var titulo_y = gh * 0.10;

    draw_sprite_stretched(
        Spr_butum,
        0,
        titulo_x - 165,
        titulo_y - 30,
        330,
        60
    );

    draw_set_font(Fonte_jogo2);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);

    draw_text_transformed(
        titulo_x,
        titulo_y,
        "PAUSE",
        1.2,
        1.2,
        0
    );

    var qtd = array_length(opcoes);

    for (var i = 0; i < qtd; i++) {
        var diferenca = i - pos;

        var _x = gw - 280 + abs(diferenca) * 60;
        var _y = gh * 0.5 + diferenca * espacamento;

        _x += deslocamento_menu;
        _y += (1 - entrada) * 25;

        var _w = larg_ini;
        var _h = alt_ini;
        var _escala = texto_escala_ini;
        var _cor = c_white;

        if (i == indice) {
            _w = larg;
            _h = alt;
            _cor = c_red;
            _escala = texto_escala;
            _x += 50;
        }

        draw_set_alpha(entrada);

        draw_sprite_stretched(
            Spr_butum,
            0,
            _x - _w * 0.5,
            _y - _h * 0.5,
            _w,
            _h
        );

        var escala_x = _escala;
        var escala_y = _escala;
        var deslocamento_y = 0;

        if (i == indice && pausado) {
            var pulso = sin(texto_pulso) * 0.06;
            escala_x += pulso;
            escala_y += pulso;
        }

        if (i == texto_clique_indice && texto_clique > 0) {
            var impacto = sin(texto_clique * pi * 4);

            escala_x += impacto * 0.12 * texto_clique;
            escala_y -= impacto * 0.12 * texto_clique;

            deslocamento_y = impacto * 4 * texto_clique;
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(_cor);

        draw_text_transformed(
            _x,
            _y + deslocamento_y,
            opcoes[i],
            escala_x,
            escala_y,
            0
        );
    }

    draw_set_alpha(1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
    draw_set_font(-1);
}
