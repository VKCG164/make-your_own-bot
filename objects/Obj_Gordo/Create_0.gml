
randomise();

digitando_tempo = false;
texto_tempo = "";
streaming = 300;

spr_idle = Spr_GDidle;
spr_falando = Spr_GDf_falando;

if (!variable_global_exists("lista_skins")) {
    global.lista_skins = ["Padrao", "Robo"];
    global.skins_idle = [Spr_GDidle, Spr_GDdroid];
    global.skins_falando = [Spr_GDf_falando, Spr_GDdroid_falando];
}

if (!variable_global_exists("skin")) {
    global.skin = 0;
}

// --- CARREGAR SKINS EXTERNAS ---
var pasta_skins = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/Skins";

if (!directory_exists(pasta_skins)) {
    directory_create(pasta_skins);
}

// Primeiro, guardar todas as pastas
var pastas = [];
var item = file_find_first(pasta_skins + "/*", fa_directory);

while (item != "") {
    if (item != "." && item != "..") {
        if (directory_exists(pasta_skins + "/" + item)) {
            array_push(pastas, item);
        }
    }

    item = file_find_next();
}

file_find_close();

// Depois, analisar cada pasta separadamente
for (var p = 0; p < array_length(pastas); p++) {
    var nome_pasta = pastas[p];
    var caminho_skin = pasta_skins + "/" + nome_pasta;
    var arquivos = [];

    var arquivo = file_find_first(caminho_skin + "/*", fa_none);

    while (arquivo != "") {
        array_push(arquivos, arquivo);
        arquivo = file_find_next();
    }

    file_find_close();

    // Procurar todas as imagens idle
    for (var a = 0; a < array_length(arquivos); a++) {
        var nome = arquivos[a];
        var nome_lower = string_lower(filename_name(nome));
        var extensao = string_lower(filename_ext(nome));

        if (extensao != ".png" && extensao != ".jpg" && extensao != ".jpeg") {
            continue;
        }

        var nome_base = string_delete(
            nome_lower,
            string_length(nome_lower) - string_length(extensao) + 1,
            string_length(extensao)
        );

        if (string_length(nome_base) <= 9) {
            continue;
        }

        if (string_copy(nome_base, 1, 4) != "spr_") {
            continue;
        }

        if (string_copy(nome_base, string_length(nome_base) - 4, 5) != "_idle") {
            continue;
        }

        var base = string_delete(
            nome_base,
            string_length(nome_base) - 4,
            5
        );

        var arquivo_falando = "";

        // Encontrar a imagem falando com o mesmo nome-base
        for (var b = 0; b < array_length(arquivos); b++) {
            var outro = arquivos[b];
            var outro_lower = string_lower(filename_name(outro));
            var outra_ext = string_lower(filename_ext(outro));

            if (outra_ext != ".png" && outra_ext != ".jpg" && outra_ext != ".jpeg") {
                continue;
            }

            var outra_base = string_delete(
                outro_lower,
                string_length(outro_lower) - string_length(outra_ext) + 1,
                string_length(outra_ext)
            );

            if (string_length(outra_base) > 12
            && string_copy(outra_base, 1, 4) == "spr_"
            && string_copy(outra_base, string_length(outra_base) - 7, 8) == "_falando") {

                outra_base = string_delete(
                    outra_base,
                    string_length(outra_base) - 7,
                    8
                );

                if (outra_base == base) {
                    arquivo_falando = outro;
                    break;
                }
            }
        }

        if (arquivo_falando != "") {
            var novo_idle = sprite_add(
                caminho_skin + "/" + nome,
                1,
                false,
                false,
                0,
                0
            );

            var novo_falando = sprite_add(
                caminho_skin + "/" + arquivo_falando,
                1,
                false,
                false,
                0,
                0
            );

            if (novo_idle != -1 && novo_falando != -1) {
                sprite_set_offset(
                    novo_idle,
                    sprite_get_width(novo_idle) div 2,
                    sprite_get_height(novo_idle) div 2
                );

                sprite_set_offset(
                    novo_falando,
                    sprite_get_width(novo_falando) div 2,
                    sprite_get_height(novo_falando) div 2
                );

                array_push(
                    global.lista_skins,
                    nome_pasta + " - " + string_delete(base, 1, 4)
                );

                array_push(global.skins_idle, novo_idle);
                array_push(global.skins_falando, novo_falando);

                show_debug_message(
                    "Skin carregada: " + nome_pasta + " - " + base
                );
            } else {
                if (novo_idle != -1) {
                    sprite_delete(novo_idle);
                }

                if (novo_falando != -1) {
                    sprite_delete(novo_falando);
                }
            }
        }
    }
}

// --- APLICAR SKIN SELECIONADA ---
global.skin = clamp(global.skin, 0, array_length(global.lista_skins) - 1);

spr_idle = global.skins_idle[global.skin];
spr_falando = global.skins_falando[global.skin];

sprite_index = spr_idle;
skin_aplicada = global.skin;

// --- CONFIGURAÇÕES DE POSIÇÃO E ESCALA ---
if (file_exists("gordo.ini")) {
    ini_open("gordo.ini");
    x = ini_read_real("Gordo", "x", x);
    y = ini_read_real("Gordo", "y", y);
    image_xscale = ini_read_real("Gordo", "escala_x", 4);
    image_yscale = ini_read_real("Gordo", "escala_y", 4);
    ini_close();
} else {
    image_xscale = 4;
    image_yscale = 4;
}

// --- SONS ---
sons = [Sd_test1, Sd_test2];

audio_pasta = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/audio";

if (!directory_exists(audio_pasta)) {
    directory_create(audio_pasta);
}

audio_total_encontrado = 0;
audio_wav_encontrado = 0;
audio_mp3_encontrado = 0;

var arquivo_audio = file_find_first(audio_pasta + "/*", fa_none);

while (arquivo_audio != "") {
    var extensao_audio = string_lower(filename_ext(arquivo_audio));
    var nome_audio = filename_name(arquivo_audio);
    var nome_lower = string_lower(nome_audio);

    if (string_copy(nome_lower, 1, 3) == "sd_") {
        if (extensao_audio == ".wav" || extensao_audio == ".mp3") {
            audio_total_encontrado++;

            if (extensao_audio == ".wav") {
                var caminho_audio = audio_pasta + "/" + arquivo_audio;

                var nome_som = string_delete(
                    nome_audio,
                    string_length(nome_audio) - 3,
                    4
                );

                var som_carregado = audioExtWavAddFile(
                    caminho_audio,
                    false,
                    false,
                    false,
                    nome_som
                );

                if (som_carregado != undefined) {
                    var id_som = som_carregado.getSoundID();

                    if (id_som != -1) {
                        array_push(sons, id_som);
                        audio_wav_encontrado++;

                        show_debug_message("WAV carregado: " + nome_audio);
                    } else {
                        show_debug_message("Falha ao obter ID: " + nome_audio);
                    }
                } else {
                    show_debug_message("Falha ao registrar: " + nome_audio);
                }
            } else {
                audio_mp3_encontrado++;

                show_debug_message("MP3 encontrado, não carregado: " + nome_audio);
            }
        }
    }

    arquivo_audio = file_find_next();
}

file_find_close();

show_debug_message("Total de arquivos: " + string(audio_total_encontrado));
show_debug_message("WAV carregados: " + string(audio_wav_encontrado));
show_debug_message("MP3 encontrados: " + string(audio_mp3_encontrado));

// --- STREAMING ---
contador_streaming = 0;
segundo_sorteado = irandom_range(60, streaming);
tocou_streaming = false;
tempo_troca = 10 * 60;
contador = room_speed * tempo_troca;

ultimo_som = irandom(array_length(sons) - 1);
audio_play_sound(sons[ultimo_som], 0, false);

// --- ANIMAÇÃO ---
wave = 0;
falando = false;
falando_anterior = false;
boing_fala = 0;

boing_x = 1;
boing_y = 1;
escala_boing = 0;

image_alpha = 1;
proximo_som = 0;
explosao = false;
explosao_frame = 0;
depth = -100;

// --- ARRASTAR ---
arrastando = false;
arrasto_offset_x = 0;
arrasto_offset_y = 0;
