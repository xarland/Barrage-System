#if defined _cmd_delveh_included
    #endinput
#endif
#define _cmd_delveh_included

// Command

cmd:delveh(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    DestroyVehicle(vehicleid);
    return 1;
}