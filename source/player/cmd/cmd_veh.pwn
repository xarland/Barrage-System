#if defined _cmd_veh_included
    #endinput
#endif
#define _cmd_veh_included

// Command

cmd:veh(playerid, params[])
{
    new vehicleid;
    new color1;
    new color2;

    if(sscanf(params, "iii", vehicleid, color1, color2)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Подсказка: {FFFFFF}используйте /veh [ид транспорта] [цвет 1] [цвет 2]");
    }

    if(!(400 <= vehicleid <= 611)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}ID транспорта должен быть от 400 до 611");
    } 

    if(!(0 <= color1 <= 255)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF} Цвета транспорта должны быть от 0 до 255");
    }

    if(!(0 <= color2 <= 255)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF} Цвета транспорта должны быть от 0 до 255");
    }

    new Float:x;
    new Float:y;
    new Float:z;
    new Float:a;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    new vid = CreateVehicle(vehicleid, x, y, z, a, color1, color2, 84600);
    PutPlayerInVehicle(playerid, vid, 0);
    SendClientMessage(playerid, COLOR_GRAY, "Вы создали транспорт. Для удаления введите /delveh");
    return 1;
}