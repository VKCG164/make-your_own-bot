randomise()
sons=[a1,a2,a3,a4,a5,a6,a7]

tempo_troca = 1 * 60;

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