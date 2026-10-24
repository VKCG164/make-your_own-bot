
pausado = false;

opcoes = [
    "CONTINUE",
    "COR DE FUNDO",
    "MUSICA",
    "DISPARAR",
    "CONTADOR",
    "ESCONDER GUI",
    "SALVAR POSICAO",
    "EXIT"
];

indice = 0;
pos = 0;

ultimo_clique_scroll = -1000;

larg_ini = 320;
alt_ini = 58;

larg = larg_ini;
alt = alt_ini;

larg_fim = 420;
alt_fim = 76;

texto_escala_ini = 1.05;
texto_escala = texto_escala_ini;
texto_escala_fim = 1.35;

texto_pulso = 0;
texto_clique = 0;
texto_clique_indice = -1;

animacao_menu = 0;
velocidade_menu = 0.15;

if (!variable_global_exists("interface_oculta")) {
    global.interface_oculta = false;
}

if (!variable_global_exists("contador")) {
    global.contador = true;
}

if (!variable_global_exists("fundo")) {
    global.fundo = 0;
}

if (!variable_global_exists("musica")) {
    global.musica = true;
}

draw_set_font(Fonte_jogo2);
