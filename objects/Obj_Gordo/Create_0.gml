
randomise();

digitando_tempo = false;
texto_tempo = "";
streaming = 300;

spr_idle = Spr_GDidle;
spr_falando = Spr_GDf_falando;

global.lista_skins = ["Padrao", "Robo"];
global.skins_idle = [Spr_GDidle, Spr_GDdroid];
global.skins_falando = [Spr_GDf_falando, Spr_GDdroid_falando];

var pasta_skins = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/Skins";

if (!directory_exists(pasta_skins)) {
    directory_create(pasta_skins);
}

var item = file_find_first(pasta_skins + "/*", fa_directory);

while (item != "") {
    if (item != "." && item != "..") {
        var caminho_skin = pasta_skins + "/" + item;

        if (directory_exists(caminho_skin)) {
            var arquivo = file_find_first(caminho_skin + "/*", fa_none);

            var caminho_idle = "";
            var caminho_falando = "";
            var base_idle = "";
            var base_falando = "";

            while (arquivo != "") {
                var caminho_arquivo = caminho_skin + "/" + arquivo;
                var nome = filename_name(arquivo);
                var extensao = string_lower(filename_ext(arquivo));

                var nome_lower = string_lower(nome);
                var nome_sem_extensao = string_delete(
                    nome_lower,
                    string_length(nome_lower) - string_length(extensao) + 1,
                    string_length(extensao)
                );

                if (extensao == ".png" || extensao == ".jpg" || extensao == ".jpeg") {
                    if (string_length(nome_sem_extensao) > 9
                    && string_copy(nome_sem_extensao, 1, 4) == "spr_"
                    && string_copy(nome_sem_extensao, string_length(nome_sem_extensao) - 4, 5) == "_idle") {
                        caminho_idle = caminho_arquivo;
                        base_idle = string_delete(
                            nome_sem_extensao,
                            string_length(nome_sem_extensao) - 4,
                            5
                        );
                    }

                    if (string_length(nome_sem_extensao) > 12
                    && string_copy(nome_sem_extensao, 1, 4) == "spr_"
                    && string_copy(nome_sem_extensao, string_length(nome_sem_extensao) - 7, 8) == "_falando") {
                        caminho_falando = caminho_arquivo;
                        base_falando = string_delete(
                            nome_sem_extensao,
                            string_length(nome_sem_extensao) - 7,
                            8
                        );
                    }
                }

                arquivo = file_find_next();
            }

            file_find_close();

            if (caminho_idle != "" && caminho_falando != ""
            && base_idle == base_falando) {
                var novo_idle = sprite_add(caminho_idle, 1, false, false, 0, 0);
                var novo_falando = sprite_add(caminho_falando, 1, false, false, 0, 0);

                if (novo_idle != -1) {
                    sprite_set_offset(
                        novo_idle,
                        sprite_get_width(novo_idle) div 2,
                        sprite_get_height(novo_idle) div 2
                    );
                }

                if (novo_falando != -1) {
                    sprite_set_offset(
                        novo_falando,
                        sprite_get_width(novo_falando) div 2,
                        sprite_get_height(novo_falando) div 2
                    );
                }

                if (novo_idle != -1 && novo_falando != -1) {
                    array_push(global.lista_skins, item);
                    array_push(global.skins_idle, novo_idle);
                    array_push(global.skins_falando, novo_falando);

                    show_debug_message("Skin carregada: " + item);
                } else {
                    if (novo_idle != -1) {
                        sprite_delete(novo_idle);
                    }

                    if (novo_falando != -1) {
                        sprite_delete(novo_falando);
                    }

                    show_debug_message("Erro ao carregar a skin: " + item);
                }
            } else {
                show_debug_message("Skin ignorada: nomes incompatíveis ou arquivos ausentes em " + item);
                show_debug_message("Idle encontrado: " + caminho_idle);
                show_debug_message("Falando encontrado: " + caminho_falando);
            }
        }
    }

    item = file_find_next();
}

file_find_close();

global.skin = clamp(global.skin, 0, array_length(global.lista_skins) - 1);

spr_idle = global.skins_idle[global.skin];
spr_falando = global.skins_falando[global.skin];

sprite_index = spr_idle;
skin_aplicada = global.skin;

show_debug_message("Total de skins: " + string(array_length(global.lista_skins)));

for (var i = 0; i < array_length(global.lista_skins); i++) {
    show_debug_message("Skin encontrada: " + global.lista_skins[i]);
}

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

sons = [
    a1,a2,a3,a4,a5,a6,a7,a8,a9,a10,
    a11,a12,a13,a14,a15,a16,a17,a18,a19,a20,
    a21,a22,a23,a24,a25,a26,a27,a28,a29,a30
];

contador_streaming = 0;
segundo_sorteado = irandom_range(60, streaming);
tocou_streaming = false;
tempo_troca = 10 * 60;
contador = room_speed * tempo_troca;

ultimo_som = irandom(array_length(sons) - 1);
audio_play_sound(sons[ultimo_som], 0, false);

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

arrastando = false;
arrasto_offset_x = 0;
arrasto_offset_y = 0;
