randomise()
if (file_exists("gordo.ini"))
{
    ini_open("gordo.ini");

    x = ini_read_real("Gordo", "x", x);
    y = ini_read_real("Gordo", "y", y);

    image_xscale = ini_read_real("Gordo", "escala_x", 4);
    image_yscale = ini_read_real("Gordo", "escala_y", 4);

    ini_close();
}
else
{
    image_xscale = 4;
    image_yscale = 4;
}

sons=[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10]

contador_streaming = 0;

// escolhe entre 0 e 10 minutos
segundo_sorteado = irandom_range(60, 300);

tocou_streaming = false;
tempo_troca = 10 * 60;

// Converte para frames
contador = room_speed * tempo_troca;

// Guarda o ultimo audio tocado
ultimo_som = -1;

// Toca um audio inicial
ultimo_som = irandom(array_length(sons) - 1);
audio_play_sound(sons[ultimo_som], 0, false);
wave = 0;
falando = false;
image_alpha = 1;
proximo_som = 0;
explosao = false;
explosao_frame = 0;
depth = -100;