if (variable_global_exists("skin")) {
    ini_open("botConfig.ini");
    ini_write_real("botConfig", "skin", global.skin);
    ini_close();
}
ini_open("botConfig.ini");
ini_write_real("botConfig", "skin", global.skin);
ini_close();