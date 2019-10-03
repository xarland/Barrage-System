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
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}���������: {FFFFFF}����������� /veh [�� ����������] [���� 1] [���� 2]");
    }

    if(!(400 <= vehicleid <= 611)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}������: {FFFFFF}ID ���������� ������ ���� �� 400 �� 611");
    } 

    if(!(0 <= color1 <= 255)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}������: {FFFFFF} ����� ���������� ������ ���� �� 0 �� 255");
    }

    if(!(0 <= color2 <= 255)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}������: {FFFFFF} ����� ���������� ������ ���� �� 0 �� 255");
    }

    new Float:x;
    new Float:y;
    new Float:z;
    new Float:a;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    new vid = CreateVehicle(vehicleid, x, y, z, a, color1, color2, 84600);
    PutPlayerInVehicle(playerid, vid, 0);
    SendClientMessage(playerid, COLOR_GRAY, "�� ������� ���������. ��� �������� ������� /delveh");
    return 1;
}