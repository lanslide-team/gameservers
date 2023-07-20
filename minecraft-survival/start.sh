#!/bin/bash

# Start server advertiser

python3 advertise.py "$HOSTNAME" &

SERVER_IP=`ip route get 1 | sed 's/^.*src \([^ ]*\).*$/\1/;q'`
echo $SERVER_IP | python3 stats.py &

ENV_VAR_ARR="MAX_TICK_TIME HOSTNAME GAMEMODE GENERATOR_SETTINGS FORCE_GAMEMODE ALLOW_NETHER ENFORCE_WHITELIST ENABLE_QUERY PLAYER_IDLE_TIMEOUT DIFFICULTY SPAWN_MONSTERS OP_PERMISSION_LEVEL PVP SNOOPER_ENABLED LEVEL_TYPE HARDCORE ENABLE_COMMAND_BLOCK MAX_PLAYERS NETWORK_COMPRESSION_THRESHOLD RESOURCE_PACK_SHA1 MAX_WORLD_SIZE SERVER_PORT SERVER_IP SPAWN_NPCS ALLOW_FLIGHT LEVEL_NAME VIEW_DISTANCE RESOURCE_PACK SPAWN_ANIMALS WHITE_LIST GENERATE_STRUCTURES ONLINE_MODE MAX_BUILD_HEIGHT LEVEL_SEED PREVENT_PROXY_CONNECTIONS USE_NATIVE_TRANSPORT ENABLE_RCON RCON_PASSWORD MOTD SPAWN_PROTECTION XMS XMX"

SERVER_DIR="/spigot"
SERVER_CFG="$SERVER_DIR/server.properties"

MAX_TICK_TIME="${MAX_TICK_TIME:-60000}"
HOSTNAME="${HOSTNAME:-Build Server}"
GAMEMODE="${GAMEMODE:-creative}"
GENERATOR_SETTINGS="${GENERATOR_SETTINGS:-}"
FORCE_GAMEMODE="${FORCE_GAMEMODE:-false}"
ALLOW_NETHER="${ALLOW_NETHER:-true}"
ENFORCE_WHITELIST="${ENFORCE_WHITELIST:-false}"
ENABLE_QUERY="${ENABLE_QUERY:-true}"
PLAYER_IDLE_TIMEOUT="${PLAYER_IDLE_TIMEOUT:-0}"
DIFFICULTY="${DIFFICULTY:-1}"
SPAWN_MONSTERS="${SPAWN_MONSTERS:-false}"
OP_PERMISSION_LEVEL="${OP_PERMISSION_LEVEL:-4}"
PVP="${PVP:-true}"
SNOOPER_ENABLED="${SNOOPER_ENABLED:-true}"
LEVEL_TYPE="${LEVEL_TYPE:-DEFAULT}"
HARDCORE="${HARDCORE:-false}"
ENABLE_COMMAND_BLOCK="${ENABLE_COMMAND_BLOCK:-false}"
MAX_PLAYERS="${MAX_PLAYERS:-100}"
NETWORK_COMPRESSION_THRESHOLD="${NETWORK_COMPRESSION_THRESHOLD:-256}"
RESOURCE_PACK_SHA1="${RESOURCE_PACK_SHA1:-}"
MAX_WORLD_SIZE="${MAX_WORLD_SIZE:-29999984}"
SERVER_PORT="${SERVER_PORT:-25565}"
SPAWN_NPCS="${SPAWN_NPCS:-false}"
ALLOW_FLIGHT="${ALLOW_FLIGHT:-false}"
LEVEL_NAME="${LEVEL_NAME:-world}"
VIEW_DISTANCE="${VIEW_DISTANCE:-10}"
RESOURCE_PACK="${RESOURCE_PACK:-}"
SPAWN_ANIMALS="${SPAWN_ANIMALS:-true}"
WHITE_LIST="${WHITE_LIST:-}"
GENERATE_STRUCTURES="${GENERATE_STRUCTURES:-true}"
ONLINE_MODE="${ONLINE_MODE:-true}"
MAX_BUILD_HEIGHT="${MAX_BUILD_HEIGHT:-256}"
LEVEL_SEED="${LEVEL_SEED:-}"
PREVENT_PROXY_CONNECTIONS="${PREVENT_PROXY_CONNECTIONS:-false}"
USE_NATIVE_TRANSPORT="${USE_NATIVE_TRANSPORT:-true}"
ENABLE_RCON="${ENABLE_RCON:-true}"
RCON_PASSWORD="${RCON_PASSWORD:-DEFAULT_ADMIN_PASSWORD}"
MOTD="${MOTD:-Welcome to the Minecraft Server}"
SPAWN_PROTECTION="${SPAWN_PROTECTION:-4}"

XMS="${XMS:-6G}"
XMX="${XMS:-6G}"

for ENV_VAR in $ENV_VAR_ARR
do
    sed -i "s/\$$ENV_VAR/${!ENV_VAR}/" $SERVER_CFG
done


# Start server itself

if [ -z "$(ls -A /$SERVER_DIR/world)" ]; then
    echo "World folder is empty"
    mv $SERVER_DIR/deathrun/* "$SERVER_DIR/world" && rm -f $SERVER_DIR/deathrun
fi

exec java -Xms${XMS} -Xmx${XMX} -jar $SERVER_DIR/spigot-*.jar nogui
