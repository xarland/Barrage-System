#if defined _player_sys_included
    #endinput
#endif
#define _player_sys_included

// Var

new Map:pMap[MAX_PLAYERS] = {INVALID_MAP, ...};
static pTimerId[MAX_PLAYERS] = {0, ...};

// Callback

public OnPlayerDataUpdate(playerid)
{
    if(map_has_str_key(pMap[playerid], #barrageid))
    {
        for(new i = 0, j = map_str_sizeof(pMap[playerid], #barrageid); i < j; ++i)
        {
            if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, i)) continue;

            new Float:x;
            new Float:y;
            new Float:z;

            GetDynamicObjectPos(map_str_get(pMap[playerid], #barrageid, i), x, y, z);
            if(!IsPlayerInRangeOfPoint(playerid, 30.0, x, y, z))
            {
                for(new k = 0, m = map_str_sizeof(pMap[playerid], #barrageid); k < m; ++k)
                {
                    if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, k)) continue;
                    DestroyDynamicObject(map_str_get(pMap[playerid], #barrageid, k));
                    DestroyDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrage_text_id, k));
                }

                if(map_has_str_key(pMap[playerid], #spikes))
                {
                    DestroyDynamicArea(map_str_get(pMap[playerid], #spikes));
                    map_str_remove_deep(pMap[playerid], #spikes);
                }

                map_str_remove_deep(pMap[playerid], #barrageid);
                map_str_remove_deep(pMap[playerid], #barrage_text_id);
                SendClientMessage(playerid, COLOR_GRAY, "Ограждения удалены");
                break;
            }
        }
    }
    return pTimerId[playerid] = SetTimerEx(#OnPlayerDataUpdate, 1000, 0, "i", playerid);
}

// External

Player_OnPlayerConnect(playerid) 
{
    if(map_valid(pMap[playerid])) {
        map_delete_deep(pMap[playerid]);
        pMap[playerid] = INVALID_MAP;
    }

    pMap[playerid] = map_new();
}

Player_OnPlayerDisconnect(playerid, reason) 
{
    #pragma unused reason
    map_delete_deep(pMap[playerid]);
    pMap[playerid] = INVALID_MAP;
    KillTimer(pTimerId[playerid]);
    pTimerId[playerid] = 0;
}

Player_OnPlayerRequestSpawn(playerid)
{
    pTimerId[playerid] = SetTimerEx(#OnPlayerDataUpdate, 1000, 0, "i", playerid);
}