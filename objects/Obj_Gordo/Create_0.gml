
fila_sons = [];
som_tocando = -1;
som_recurso_tocando = -1;
ultimo_som = -1;
som_voz = -1;
som_tempo_restante = 0;
proximo_som = -1;
alarm[0] = -1;

falando = false;
falando_anterior = false;

colocar_som_na_fila = function(_som) {
    if (is_undefined(_som) || _som == -1) return;
    if (!is_array(fila_sons)) fila_sons = [];
    array_push(fila_sons, _som);
};

sortear_som = function() {
    if (!is_array(sons) || array_length(sons) <= 0) return -1;

    var total = array_length(sons);
    var escolhido = irandom(total - 1);

    if (total > 1 && escolhido == ultimo_som) {
        escolhido = (escolhido + irandom_range(1, total - 1)) mod total;
    }

    ultimo_som = escolhido;
    return sons[escolhido];
};

randomise();

digitando_tempo = false;
texto_tempo = "";
streaming = 300;
tempo_troca = 10 * 60;
contador = room_speed * tempo_troca;
contador_streaming = 0;
segundo_sorteado = irandom_range(60, streaming);
tocou_streaming = false;

if (!variable_global_exists("lista_skins")) {
    global.lista_skins = ["Padrao", "Robo"];
    global.skins_idle = [Spr_GDidle, Spr_GDdroid];
    global.skins_falando = [Spr_GDf_falando, Spr_GDdroid_falando];
}

if (!variable_global_exists("skin")) global.skin = 0;
if (!variable_global_exists("sons")) global.sons = [Sd_test1, Sd_test2];

if (!variable_global_exists("skins_externas_inicializadas")) {
    global.skins_externas_inicializadas = false;
}

if (!global.skins_externas_inicializadas) {
    var pasta_skins = environment_get_variable("LOCALAPPDATA") + "/BotTron_GD/Skins";

    if (!directory_exists(pasta_skins)) directory_create(pasta_skins);

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
            } else {
                if (novo_idle != -1) sprite_delete(novo_idle);
                if (novo_falando != -1) sprite_delete(novo_falando);
            }
        }
    }

    global.skins_externas_inicializadas = true;
}

// Carrega a última skin salva
if (file_exists("botConfig.ini")) {
    ini_open("botConfig.ini");
    global.skin = ini_read_real("Gordo", "skin", global.skin);
    ini_close();
}

global.skin = clamp(global.skin, 0, array_length(global.lista_skins) - 1);

spr_idle = global.skins_idle[global.skin];
spr_falando = global.skins_falando[global.skin];
sprite_index = spr_idle;
skin_aplicada = global.skin;
if (file_exists("botConfig.ini")) {
    ini_open("botConfig.ini");
    x = ini_read_real("botConfig", "x", x);
    y = ini_read_real("botConfig", "y", y);
    image_xscale = ini_read_real("botConfig", "escala_x", 4);
    image_yscale = ini_read_real("botConfig", "escala_y", 4);
    ini_close();
} else {
    image_xscale = 4;
    image_yscale = 4;
}
sons = global.sons;

wave = 0;
boing_fala = 0;
boing_x = 1;
boing_y = 1;
escala_boing = 0;
image_alpha = 1;
explosao = false;
explosao_frame = 0;
depth = -100;
tempo_aparicao = 0;
arrastando = false;
arrasto_offset_x = 0;
arrasto_offset_y = 0;
gordo_visivel = false;

if (!variable_global_exists("gui_visivel")) global.gui_visivel = true;
if (!variable_global_exists("contador")) global.contador = false;
if (!variable_global_exists("interface_oculta")) global.interface_oculta = false;

mensagem_salva = "";
alpha_mensagem = 0;
tempo_mensagem = 0;
