
var y_wave = y + sin(wave) * 4;

// Animacao de fala e de arrastar
var pulso_fala = sin(boing_fala * pi);

var escala_x_final = image_xscale * boing_x;
var escala_y_final = image_yscale * boing_y;

escala_x_final *= 1 - pulso_fala * 0.12;
escala_y_final *= 1 + pulso_fala * 0.18;

// Gordo
if (falando)
{
    draw_sprite_ext(
        spr_falando,
        image_index,
        x,
        y_wave,
        escala_x_final,
        escala_y_final,
        0,
        c_white,
        image_alpha
    );
}
else
{
    draw_sprite_ext(
        spr_idle,
        0,
        x,
        y_wave,
        escala_x_final,
        escala_y_final,
        0,
        c_white,
        image_alpha
    );
}

// Explosao por cima do Gordo
if (explosao)
{
    draw_sprite_ext(
        Spr_explosao,
        floor(explosao_frame),
        x,
        y_wave - 20,
        image_xscale,
        image_yscale,
        0,
        c_white,
        1
    );
}
