randomise()
digitando_tempo = false;
texto_tempo = "";
streaming=300
spr_idle = Spr_GDidle;
spr_falando = Spr_GDf_falando;
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

sons=[a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,a21,a22,a23,a24,a25,a26,a27,a28,a29]

contador_streaming = 0;


segundo_sorteado = irandom_range(60,streaming); 

tocou_streaming = false;
tempo_troca = 10 * 60;


contador = room_speed * tempo_troca;


ultimo_som = -1;

ultimo_som = irandom(array_length(sons) - 1);
audio_play_sound(sons[ultimo_som], 0, false);
wave = 0;
falando = false;
image_alpha = 1;
proximo_som = 0;
explosao = false;
explosao_frame = 0;
depth = -100;
arrastando = false;
