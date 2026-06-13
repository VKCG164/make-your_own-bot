var y_wave = y + sin(wave) * 4;

// Gordo
if (falando)
{
    draw_sprite_ext(
        Spr_GDfalando,
        image_index,
        x,
        y_wave,
         image_xscale, image_yscale, 0,
        c_white,
        image_alpha
    );
}
else
{
    draw_sprite_ext(
        Spr_GDidle,
        0,
        x,
        y_wave,
         image_xscale, image_yscale, 0,
        c_white,
        image_alpha
    );
}

// Explosao por cima do gordo
if (explosao)
{
    draw_sprite_ext(
        Spr_explosao,
        floor(explosao_frame),
        x,
        y_wave - 20,
        image_xscale, image_yscale,
        0,
        c_white,
        1
    );
}