#if defined _utils_included
    #endinput
#endif
#define _utils_included

// Redefines

native SendClientMessageStr(playerid, color, ConstAmxString:string) = SendClientMessage;
native STREAMER_TAG_3D_TEXT_LABEL:CreateDynamic3DTextLabelStr(ConstAmxString:string, color, Float:x, Float:y, Float:z, Float:drawdistance, attachedplayer = INVALID_PLAYER_ID, attachedvehicle = INVALID_VEHICLE_ID, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD, STREAMER_TAG_AREA:areaid = STREAMER_TAG_AREA:-1, priority = 0) = CreateDynamic3DTextLabel;