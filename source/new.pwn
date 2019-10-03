/*
    Project name:
        Bort system
    
    Project verion:
        0.1
    
    SA-MP Version:
        0.3.7-R2 and older

    Developers:
        https://github.com/xarland

    Website:
        -
*/

@___If_u_can_read_this_u_r_nerd();    // 10 different ways to crash DeAMX
@___If_u_can_read_this_u_r_nerd()    // and also a nice tag for exported functions table in the AMX file
{ // by Daniel_Cortez \\ pro-pawn.ru
    #emit    stack    0x7FFFFFFF    // wtf (1) (stack over... overf*ck!?)
    #emit    inc.s    cellmax    // wtf (2) (this one should probably make DeAMX allocate all available memory and lag forever)
    static const ___[][] = {"pro-pawn", ".ru"};    // pretty old anti-deamx trick
    #emit    retn
    #emit    load.s.pri    ___    // wtf (3) (opcode outside of function?)
    #emit    proc    // wtf (4) (if DeAMX hasn't crashed already, it would think it is a new function)
    #emit    proc    // wtf (5) (a function inside of another function!?)
    #emit    fill    cellmax    // wtf (6) (fill random memory block with 0xFFFFFFFF)
    #emit    proc
    #emit    stack    1    // wtf (7) (compiler usually allocates 4 bytes or 4*N for arrays of N elements)
    #emit    stor.alt    ___    // wtf (8) (...)
    #emit    strb.i    2    // wtf (9)
    #emit    switch    0
    #emit    retn    // wtf (10) (no "casetbl" opcodes before retn - invalid switch statement?)
L1:
    #emit    jump    L1    // avoid compiler crash from "#emit switch"
    #emit    zero    cellmin    // wtf (11) (nonexistent address)
}

#if defined _bort_system_included
    #endinput
#endif
#define _bort_system_included

// Dependencies

#include <a_samp>
#define PP_SYNTAX
#include <PawnPlus> // v1.1 (https://github.com/IllidanS4/PawnPlus)
#include <streamer> // v2.9.4 (https://github.com/samp-incognito/samp-streamer-plugin)
#include <sscanf2> // v2.8.3 (https://github.com/maddinat0r/sscanf)
#include <Pawn.CMD> // 3.2.0 (https://github.com/urShadow/Pawn.CMD)
#define MDIALOG_DISABLE_TAGS
#include <pp_mdialog> // v1.4.0 (https://github.com/Open-GTO/mdialog) modified version for PawnPlus

// Configuration

#include "config.inc"

// Utils

#include "utils.inc"

// Player

#include "player/player.pwn"
#include "player/player.inc"
#include "player/barrage.inc"
#include "player/barrage.pwn"
#include "player/cmd/cmd_veh.pwn"
#include "player/cmd/cmd_delveh.pwn"

// Callbacks

main() 
{
    print("Barrage system");
}

public OnGameModeInit() 
{
    AddPlayerClass(287, -81.2867,-136.5750,3.1172,65.0982, 0, 0, 0, 0, 0, 0);
    return 1;
}

public OnPlayerRequestSpawn(playerid)
{
    Player_OnPlayerRequestSpawn(playerid);
    return 1;
}

public OnPlayerConnect(playerid)
{
    Player_OnPlayerConnect(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    Barrage_OnPlayerDisconnect(playerid, reason);
    Player_OnPlayerDisconnect(playerid, reason);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    Barrage_OnPlayerDeath(playerid, killerid, reason);
    return 1;
}

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    Barrage_OnPlayerEnterDynArea(playerid, areaid);
    return 1;
}