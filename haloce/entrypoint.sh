#!/bin/bash

ENV_VAR_ARR="SV_NAME SV_RCON_PASSWORD SV_PASSWORD SV_PUBLIC SV_MOTD SV_MAXPLAYERS SV_FRIENDLY_FIRE SV_MAPCYCLE_TIMEOUT SV_TK_BAN SV_TK_COOLDOWN SV_TK_GRACE SV_BAN_PENALTY SV_MAPVOTE SV_MAPCYCLE_TIMEOUT SV_MAPCYCLE_ADD ANTIHALOFP SV_TIMELIMIT SCORELIMIT"
SERVER_CFG=init.txt
GAME_FOLDER=/haloce
INTERNAL_PORT="${INTERNAL_PORT:-2302}"

SV_NAME="${SV_NAME:-Halo CE Server}"
SV_RCON_PASSWORD="${SV_RCON_PASSWORD:-DEFAULT_ADMIN_PASSWORD}"
SV_PASSWORD="${SV_PASSWORD:-}"
SV_PUBLIC="${SV_PUBLIC:-0}"
SV_MOTD="${SV_MOTD:-motd.txt}"
SV_MAXPLAYERS="${SV_MAXPLAYERS:-16}"
SV_FRIENDLY_FIRE="${SV_FRIENDLY_FIRE:-1}"

SV_MAPCYCLE_TIMEOUT="${SV_MAPCYCLE_TIMEOUT:-8}"
SV_TK_BAN="${SV_TK_BAN:-20}"
SV_TK_COOLDOWN="${SV_TK_COOLDOWN:-10}"
SV_TK_GRACE="${SV_TK_GRACE:-10}"
SV_BAN_PENALTY="${SV_BAN_PENALTY:-0}"

SV_MAPVOTE="${SV_MAPVOTE:-1}"
SV_MAPCYCLE_TIMEOUT="${SV_MAPCYCLE_TIMEOUT:-15}"
SV_MAPCYCLE_ADD="${SV_MAPCYCLE_ADD:-bloodgulch \"Team slayer\"}"
ANTIHALOFP="${ANTIHALOFP:-1}"
SV_TIMELIMIT="${SV_TIMELIMIT:-0}"
SCORELIMIT="${SCORELIMIT:-25}"

echo "Starting dedicated server 1"
#for ENV_VAR in $ENV_VAR_ARR
for ENV_VAR in $ENV_VAR_ARR
do
    sed -i "s/\$$ENV_VAR/${!ENV_VAR}/" $GAME_FOLDER/$SERVER_CFG
done

echo "Current config file"
cat "$GAME_FOLDER/$SERVER_CFG"

echo "Starting dedicated server 2"
echo wineconsole --backend=curses haloceded.exe -path . -port $INTERNAL_PORT
wineconsole --backend=curses haloceded.exe -path . -port $INTERNAL_PORT

