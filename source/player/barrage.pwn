#if defined _barrage_included
    #endinput
#endif
#define _barrage_included

// Callback

public OnBarrageEditObject(CallbackHandler:id, listitem, playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(response == EDIT_RESPONSE_CANCEL && objectid == map_str_get(pMap[playerid], #barrageid, listitem))
    {
        DestroyDynamicObject(objectid);
        map_str_remove_deep(pMap[playerid], #barrageid);
        map_str_remove_deep(pMap[playerid], #barrage_text_id);
        pawn_unregister_callback(id);
        return Dialog_Show(playerid, Dialog:SelectBarrage);
    }

    if(response == EDIT_RESPONSE_FINAL && objectid == map_str_get(pMap[playerid], #barrageid, listitem))
    {
        SendClientMessage(
            playerid, COLOR_WHITE, 
            "{FFCC00}Подсказка: {FFFFFF}ограждение установлено! \
            (используйте /delbort, чтобы удалить его и /fixbort чтобы переместить)"
        );
        
        if(!IsValidDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrageid, listitem)))
        {
            new Text3D:textId = CreateDynamic3DTextLabelStr(@("[ID - ")+@@(playerid)+@("]"), COLOR_YELLOW, x, y, z+0.5, 1.0);
            map_str_set_cell(pMap[playerid], #barrage_text_id, listitem, _:textId);
        }
        else
        {
            DestroyDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrageid, listitem));
            new Text3D:textId = CreateDynamic3DTextLabelStr(@("[ID - ")+@@(playerid)+@("]"), COLOR_YELLOW, x, y, z+0.5, 1.0);
            map_str_set_cell(pMap[playerid], #barrage_text_id, listitem, _:textId);
        }

        map_str_set_cell(pMap[playerid], #barrageid, listitem, objectid);
        
        if(7 == listitem && !map_has_str_key(pMap[playerid], #spikes))
        {
            new sphereid = CreateDynamicSphere(x, y, z, 4.0);
            map_str_add(pMap[playerid], #spikes, sphereid);
        }
        else if(7 == listitem && map_has_str_key(pMap[playerid], #spikes))
        {
            DestroyDynamicArea(map_str_get(pMap[playerid], #spikes));
            new sphereid = CreateDynamicSphere(x, y, z, 4.0);
            map_str_add(pMap[playerid], #spikes, sphereid);
        }
        return pawn_unregister_callback(id);
    }

    return 1;
}

// External

Barrage_OnPlayerDisconnect(playerid, reason)
{
    #pragma unused reason
    if(map_has_str_key(pMap[playerid], #barrageid))
    {
        for(new i = 0, j = map_str_sizeof(pMap[playerid], #barrageid); i < j; ++i)
        {
            if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, i)) continue;
            DestroyDynamicObject(map_str_get(pMap[playerid], #barrageid, i));
            DestroyDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrage_text_id, i));
        }

        if(map_has_str_key(pMap[playerid], #spikes))
        {
            DestroyDynamicArea(map_str_get(pMap[playerid], #spikes));
            map_str_remove_deep(pMap[playerid], #spikes);
        }

        map_str_remove_deep(pMap[playerid], #barrageid);
        map_str_remove_deep(pMap[playerid], #barrage_text_id);

        SendClientMessage(playerid, COLOR_GRAY, "Ограждения удалены");
    }
}

Barrage_OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused killerid, reason
    if(map_has_str_key(pMap[playerid], #barrageid))
    {
        for(new i = 0, j = map_str_sizeof(pMap[playerid], #barrageid); i < j; ++i)
        {
            if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, i)) continue;
            DestroyDynamicObject(map_str_get(pMap[playerid], #barrageid, i));
            DestroyDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrage_text_id, i));
        }

        map_str_remove_deep(pMap[playerid], #barrageid);
        map_str_remove_deep(pMap[playerid], #barrage_text_id);

        SendClientMessage(playerid, COLOR_GRAY, "Ограждения удалены");
    }
}

Barrage_OnPlayerEnterDynArea(playerid, areaid)
{
    if(areaid == map_str_get(pMap[playerid], #spikes) && PLAYER_STATE_DRIVER == GetPlayerState(playerid))
    {
        new panels;
        new doors;
        new lights;
        new tires;
        GetVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, tires);
        UpdateVehicleDamageStatus(GetPlayerVehicleID(playerid), panels, doors, lights, 15);
    }
}

// Internal

static stock CreateBarrageObject(playerid, listitem)
{
    static barrageObjId[] = {1427, 3091, 1423, 1237, 997, 994, 3578, 2899};

    new Float:x;
    new Float:y;
    new Float:z;

    GetPlayerPos(playerid, x, y, z);
    new objectid = CreateDynamicObject(barrageObjId[listitem], x, y, z, 0.0, 0.0, 0.0);

    if(!map_has_str_key(pMap[playerid], #barrageid)) 
    {
        map_str_add_arr(
            pMap[playerid], #barrageid,
            {
                INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID, 
                INVALID_OBJECT_ID, INVALID_OBJECT_ID, INVALID_OBJECT_ID, 
                INVALID_OBJECT_ID, INVALID_OBJECT_ID
            }
        );

        map_str_add_arr(
            pMap[playerid], #barrage_text_id,
            {
                INVALID_3DTEXT_ID, INVALID_3DTEXT_ID, INVALID_3DTEXT_ID, 
                INVALID_3DTEXT_ID, INVALID_3DTEXT_ID, INVALID_3DTEXT_ID, 
                INVALID_3DTEXT_ID, INVALID_3DTEXT_ID
            }
        );
    }

    map_str_set_cell(pMap[playerid], #barrageid, listitem, objectid);
    pawn_register_callback(#OnPlayerEditDynamicObject, #OnBarrageEditObject, _, "ei", listitem);
    return EditDynamicObject(playerid, objectid);
}

static stock DestroyBarrage(playerid, listitem)
{
    if(!map_has_str_key(pMap[playerid], #barrageid)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}вы не создавали выбранное ограждение");
    }

    if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, listitem)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}вы не создавали выбранное ограждение");
    }

    DestroyDynamicObject(map_str_get(pMap[playerid], #barrageid, listitem));
    DestroyDynamic3DTextLabel(Text3D:map_str_get(pMap[playerid], #barrageid, listitem));

    new counter = 0;
    for(new i = 0, j = map_str_sizeof(pMap[playerid], #barrageid); i < j; ++i)
    {
        if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, i)) {
            counter++;
        }
    }

    if(counter == map_str_sizeof(pMap[playerid], #barrageid)) {
        map_str_remove_deep(pMap[playerid], #barrageid);
        map_str_remove_deep(pMap[playerid], #barrage_text_id);
    } else {
        map_str_set_cell(pMap[playerid], #barrageid, listitem, INVALID_OBJECT_ID);
        map_str_set_cell(pMap[playerid], #barrage_text_id, listitem, _:INVALID_3DTEXT_ID);
    }

    return Dialog_Show(playerid, Dialog:DestroyBarrage);
}

static stock FixBarrage(playerid, listitem)
{
    if(!map_has_str_key(pMap[playerid], #barrageid)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}вы не создавали выбранное ограждение");
    }

    if(INVALID_OBJECT_ID == map_str_get(pMap[playerid], #barrageid, listitem)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}вы не создавали выбранное ограждение");
    }

    new Float:x;
    new Float:y;
    new Float:z;
    new objectid = map_str_get(pMap[playerid], #barrageid, listitem);

    GetDynamicObjectPos(objectid, x, y, z);

    if(!IsPlayerInRangeOfPoint(playerid, 2.0, x, y, z)) {
        return SendClientMessage(playerid, COLOR_WHITE, "{FFCC00}Ошибка: {FFFFFF}вы находитесь далеко от заграждения");
    }

    pawn_register_callback(#OnPlayerEditDynamicObject, #OnBarrageEditObject, _, "ei", listitem);
    return EditDynamicObject(playerid, objectid);
}

// Command

cmd:bort(playerid, params[])
{
    Dialog_Show(playerid, Dialog:SelectBarrage);
    return 1;
}

cmd:delbort(playerid, params[])
{
    Dialog_Show(playerid, Dialog:DestroyBarrage);
    return 1;
}

cmd:fixbort(playerid, params[])
{
    Dialog_Show(playerid, Dialog:FixBarrage);
    return 1;
}

// Dialogues

DialogCreate:SelectBarrage(playerid)
{
    Dialog_Open(
        playerid, Dialog:SelectBarrage, DIALOG_STYLE_TABLIST,
        @("Выберите заграждение"),
        @("[1] Деревянный барьер №1\n\
        [2] Деревянный барьер №2\n\
        [3] Деревянный барьер №3\n\
        [4] Бочкообразный барьер\n\
        [5] Железный барьер №1\n\
        [6] Железный барьер №2\n\
        [7] Большое дорожное заграждение\n\
        [8] Шипы"),
        @("Выбрать"), @("Закрыть")
    );
}

DialogResponse:SelectBarrage(playerid, response, listitem, inputtext[])
{
    return (response) ? CreateBarrageObject(playerid, listitem) : Dialog_Close(playerid);
}

DialogCreate:DestroyBarrage(playerid)
{
    Dialog_Open(
        playerid, Dialog:DestroyBarrage, DIALOG_STYLE_TABLIST,
        @("Выберите заграждение"),
        @("[1] Деревянный барьер №1\n\
        [2] Деревянный барьер №2\n\
        [3] Деревянный барьер №3\n\
        [4] Бочкообразный барьер\n\
        [5] Железный барьер №1\n\
        [6] Железный барьер №2\n\
        [7] Большое дорожное заграждение\n\
        [8] Шипы"),
        @("Выбрать"), @("Закрыть")
    );
}

DialogResponse:DestroyBarrage(playerid, response, listitem, inputtext[])
{
    return (response) ? DestroyBarrage(playerid, listitem) : Dialog_Close(playerid);
}

DialogCreate:FixBarrage(playerid)
{
    Dialog_Open(
        playerid, Dialog:FixBarrage, DIALOG_STYLE_TABLIST,
        @("Выберите заграждение"),
        @("[1] Деревянный барьер №1\n\
        [2] Деревянный барьер №2\n\
        [3] Деревянный барьер №3\n\
        [4] Бочкообразный барьер\n\
        [5] Железный барьер №1\n\
        [6] Железный барьер №2\n\
        [7] Большое дорожное заграждение\n\
        [8] Шипы"),
        @("Выбрать"), @("Закрыть")
    );
}

DialogResponse:FixBarrage(playerid, response, listitem, inputtext[])
{
    return (response) ? FixBarrage(playerid, listitem) : Dialog_Close(playerid);
}