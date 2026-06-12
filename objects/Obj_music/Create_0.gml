if (!variable_global_exists("musica"))
    global.musica = true;

som_id = audio_play_sound(So_musiquinha, 1, true);
audio_pause_sound(som_id);