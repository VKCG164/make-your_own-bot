global.musica = true;
global.fundo = 0;

if (!variable_global_exists("contador")) global.contador = false;
if (!variable_global_exists("skin")) global.skin = 0;

if (!variable_global_exists("lista_skins")) {
    global.lista_skins = ["Padrao", "Robo"];
    global.skins_idle = [Spr_GDidle, Spr_GDdroid];
    global.skins_falando = [Spr_GDf_falando, Spr_GDdroid_falando];
}

if (!variable_global_exists("sons")) {
    global.sons = [Sd_test1, Sd_test2];
}

if (!is_array(global.sons)) {
    global.sons = [Sd_test1, Sd_test2];
}

var pasta_skins = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/Skins";

if (!directory_exists(pasta_skins)) {
    directory_create(pasta_skins);
}

if (!variable_global_exists("skins_externas_inicializadas")) {
    global.skins_externas_inicializadas = false;
}

if (!global.skins_externas_inicializadas) {
    var pastas = [];
    var item = file_find_first(pasta_skins + "/*", fa_directory);

    while (item != "") {
        if (item != "." && item != ".." && directory_exists(pasta_skins + "/" + item)) {
            array_push(pastas, item);
        }

        item = file_find_next();
    }

    file_find_close();

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

        for (var a = 0; a < array_length(arquivos); a++) {
            var nome = arquivos[a];
            var nome_lower = string_lower(filename_name(nome));
            var extensao = string_lower(filename_ext(nome));

            if (extensao != ".png" && extensao != ".jpg" && extensao != ".jpeg") continue;

            var nome_base = string_delete(nome_lower, string_length(nome_lower) - string_length(extensao) + 1, string_length(extensao));

            if (string_length(nome_base) <= 9 || string_copy(nome_base, 1, 4) != "spr_") continue;
            if (string_copy(nome_base, string_length(nome_base) - 4, 5) != "_idle") continue;

            var base = string_delete(nome_base, string_length(nome_base) - 4, 5);
            var arquivo_falando = "";

            for (var b = 0; b < array_length(arquivos); b++) {
                var outro = arquivos[b];
                var outro_lower = string_lower(filename_name(outro));
                var outra_ext = string_lower(filename_ext(outro));

                if (outra_ext != ".png" && outra_ext != ".jpg" && outra_ext != ".jpeg") continue;

                var outra_base = string_delete(outro_lower, string_length(outro_lower) - string_length(outra_ext) + 1, string_length(outra_ext));

                if (string_length(outra_base) > 12 && string_copy(outra_base, 1, 4) == "spr_" && string_copy(outra_base, string_length(outra_base) - 7, 8) == "_falando") {
                    outra_base = string_delete(outra_base, string_length(outra_base) - 7, 8);

                    if (outra_base == base) {
                        arquivo_falando = outro;
                        break;
                    }
                }
            }

            if (arquivo_falando == "") continue;

            var novo_idle = sprite_add(caminho_skin + "/" + nome, 1, false, false, 0, 0);
            var novo_falando = sprite_add(caminho_skin + "/" + arquivo_falando, 1, false, false, 0, 0);

            if (novo_idle != -1 && novo_falando != -1) {
                sprite_set_offset(novo_idle, sprite_get_width(novo_idle) div 2, sprite_get_height(novo_idle) div 2);
                sprite_set_offset(novo_falando, sprite_get_width(novo_falando) div 2, sprite_get_height(novo_falando) div 2);

                array_push(global.lista_skins, nome_pasta + " - " + string_delete(base, 1, 4));
                array_push(global.skins_idle, novo_idle);
                array_push(global.skins_falando, novo_falando);

                show_debug_message("Skin carregada: " + nome_pasta + " - " + base);
            } else {
                if (novo_idle != -1) sprite_delete(novo_idle);
                if (novo_falando != -1) sprite_delete(novo_falando);
            }
        }
    }

    global.skins_externas_inicializadas = true;
}

global.skin = clamp(global.skin, 0, array_length(global.lista_skins) - 1);

var pasta_audio = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/audio";

if (!directory_exists(pasta_audio)) {
    directory_create(pasta_audio);
}

if (!variable_global_exists("audios_externos_inicializados")) {
    global.audios_externos_inicializados = false;
}

if (!global.audios_externos_inicializados) {
    var arquivo_audio = file_find_first(pasta_audio + "/*", fa_none);

    while (arquivo_audio != "") {
        var extensao_audio = string_lower(filename_ext(arquivo_audio));
        var nome_audio = filename_name(arquivo_audio);
        var nome_lower = string_lower(nome_audio);

        if (string_copy(nome_lower, 1, 3) == "sd_" && extensao_audio == ".wav") {
            var caminho_audio = pasta_audio + "/" + arquivo_audio;
            var nome_som = string_delete(nome_audio, string_length(nome_audio) - 3, 4);

            var som_carregado = audioExtWavAddFile(
                caminho_audio,
                false,
                false,
                false,
                nome_som
            );

            if (!is_undefined(som_carregado) && som_carregado != -1) {
                var id_som = som_carregado.getSoundID();

                if (id_som != -1) {
                    array_push(global.sons, id_som);
                    show_debug_message("Áudio carregado: " + nome_audio);
                }
            }
        }

        arquivo_audio = file_find_next();
    }

    file_find_close();

    global.audios_externos_inicializados = true;
}

global.skin = clamp(global.skin, 0, array_length(global.lista_skins) - 1);

show_debug_message("Total de sons disponíveis: " + string(array_length(global.sons)));