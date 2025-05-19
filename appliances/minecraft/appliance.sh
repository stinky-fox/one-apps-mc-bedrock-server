# List of contextualization parameters
ONE_SERVICE_PARAMS=(
    'SERVER_NAME'                   'configure'                     '' ''
    'GAMEMODE'                      'configure'                     '' ''
    'FORCE_GAMEMODE'                    'configure'                     '' ''
    'DIFFICULTY'                    'configure'                     '' ''
    'ALLOW_CHEATS'                      'configure'                     '' ''
    'MAX_PLAYERS'                   'configure'                     '' ''
    'ONLINE_MODE'                  'configure'                     '' ''
    'ALLOW_LIST'                  'configure'                     '' ''
    'SERVER_PORT'                  'configure'                     '' ''
    'SERVER_PORTV6'                  'configure'                     '' ''
    'ENABLE_LAN_VISIBILITY'                  'configure'                     '' ''
    'VIEW_DISTANCE'                  'configure'                     '' ''
    'TICK_DISTANCE'                  'configure'                     '' ''
    'PLAYER_IDLE_TIMEOUT'                  'configure'                     '' ''
    'MAX_THREADS'                  'configure'                     '' ''
    'LEVEL_NAME'                                       'configure'                     '' ''
    'LEVEL_SEED'                                       'configure'                     '' ''
    'DEFAULT_PLAYER_PERMISSION_LEVEL'                  'configure'                     '' ''
    'TEXTUREPACK_REQUIRED'                  'configure'                     '' ''
    'CONTENT_LOG_FILE_ENABLED'                  'configure'                     '' ''
    'COMPRESSION_THRESHOLD'                  'configure'                     '' ''
    'COMPRESSION_ALGORITHM'                  'configure'                     '' ''
    'SERVER_AUTHORITATIVE_MOVEMENT_STRICT'                  'configure'                     '' ''
    'SERVER_AUTHORITATIVE_DISMOUNT_STRICT'                  'configure'                     '' ''
    'SERVER_AUTHORITATIVE_ENTITY_INTERACTIONS_STRICT'                  'configure'                     '' ''
    'PLAYER_POSITION_ACCEPTANCE_THRESHOLD'                  'configure'                     '' ''
    'PLAYER_MOVEMENT_ACTION_DIRECTION_THRESHOLD'                  'configure'                     '' ''
    'SERVER_AUTHORITATIVE_BLOCK_BREAKING_PICK_RANGE_SCALAR'                  'configure'                     '' ''
    'CHAT_RESTRICTION'                  'configure'                     '' ''
    'DISABLE_PLAYER_INTERACTION'                  'configure'                     '' ''
    'CLIENT_SIDE_CHUNK_GENERATION_ENABLED'                  'configure'                     '' ''
    'BLOCK_NETWORK_IDS_ARE_HASHES'                  'configure'                     '' ''
    'DISABLE_PERSONA'                  'configure'                     '' ''
    'DISABLE_CUSTOM_SKINS'                  'configure'                     '' ''
    'SERVER_BUILD_RADIUS_RATIO'                  'configure'                     '' ''
    'ALLOW_OUTBOUND_SCRIPT_DEBUGGING'                  'configure'                     '' ''
    'ALLOW_INBOUND_SCRIPT_DEBUGGING'                  'configure'                     '' ''
    'SCRIPT_DEBUGGER_AUTO_ATTACH'                  'configure'                     '' ''
    )

### Default values

SERVER_NAME="${SERVER_NAME:-The World}"
GAMEMODE="${GAMEMODE:-creative}"
FORCE_GAMEMODE="${FORCE_GAMEMODE:-false}"
DIFFICULTY="${DIFFICULTY:-easy}"
ALLOW_CHEATS="${ALLOW_CHEATS:-false}"
MAX_PLAYERS="${MAX_PLAYERS:-10}"
ONLINE_MODE="${ONLINE_MODE:-false}"
ALLOW_LIST="${ALLOW_LIST:-false}"
SERVER_PORT="${SERVER_PORT:-19132}"
SERVER_PORTV6="${SERVER_PORTV6:-19133}"
ENABLE_LAN_VISIBILITY="${ENABLE_LAN_VISIBILITY:-true}"
VIEW_DISTANCE="${VIEW_DISTANCE:-32}"
TICK_DISTANCE="${TICK_DISTANCE:-4}"
PLAYER_IDLE_TIMEOUT="${PLAYER_IDLE_TIMEOUT:-30}"
MAX_THREADS="${MAX_THREADS:-0}"
LEVEL_NAME="${LEVEL_NAME:-The level}"
LEVEL_SEED="${LEVEL_SEED:-}"
DEFAULT_PLAYER_PERMISSION_LEVEL="${DEFAULT_PLAYER_PERMISSION_LEVEL:-member}"
TEXTUREPACK_REQUIRED="${TEXTUREPACK_REQUIRED:-false}"
CONTENT_LOG_FILE_ENABLED="${CONTENT_LOG_FILE_ENABLED:-false}"
COMPRESSION_THRESHOLD="${COMPRESSION_THRESHOLD:-1}"
COMPRESSION_ALGORITHM="${COMPRESSION_ALGORITHM:-zlib}"
SERVER_AUTHORITATIVE_MOVEMENT_STRICT="${SERVER_AUTHORITATIVE_MOVEMENT_STRICT:-false}"
SERVER_AUTHORITATIVE_DISMOUNT_STRICT="${SERVER_AUTHORITATIVE_DISMOUNT_STRICT:-false}"
SERVER_AUTHORITATIVE_ENTITY_INTERACTIONS_STRICT="${SERVER_AUTHORITATIVE_ENTITY_INTERACTIONS_STRICT:-false}"
PLAYER_POSITION_ACCEPTANCE_THRESHOLD="${PLAYER_POSITION_ACCEPTANCE_THRESHOLD:-0.5}"
PLAYER_MOVEMENT_ACTION_DIRECTION_THRESHOLD="${PLAYER_MOVEMENT_ACTION_DIRECTION_THRESHOLD:-0.85}"
SERVER_AUTHORITATIVE_BLOCK_BREAKING_PICK_RANGE_SCALAR="${SERVER_AUTHORITATIVE_BLOCK_BREAKING_PICK_RANGE_SCALAR:-1.5}"
CHAT_RESTRICTION="${CHAT_RESTRICTION:-None}"
DISABLE_PLAYER_INTERACTION="${DISABLE_PLAYER_INTERACTION:-false}"
CLIENT_SIDE_CHUNK_GENERATION_ENABLED="${CLIENT_SIDE_CHUNK_GENERATION_ENABLED:-true}"
BLOCK_NETWORK_IDS_ARE_HASHES="${BLOCK_NETWORK_IDS_ARE_HASHES:-true}"
DISABLE_PERSONA="${DISABLE_PERSONA:-false}"
DISABLE_CUSTOM_SKINS="${DISABLE_CUSTOM_SKINS:-false}"
SERVER_BUILD_RADIUS_RATIO="${SERVER_BUILD_RADIUS_RATIO:-Disabled}"
ALLOW_OUTBOUND_SCRIPT_DEBUGGING="${ALLOW_OUTBOUND_SCRIPT_DEBUGGING:-false}"
ALLOW_INBOUND_SCRIPT_DEBUGGING="${ALLOW_INBOUND_SCRIPT_DEBUGGING:-false}"
SCRIPT_DEBUGGER_AUTO_ATTACH="${SCRIPT_DEBUGGER_AUTO_ATTACH:-disabled}"

MINECRAFT_BEDROCK_URL="https://www.minecraft.net/bedrockdedicatedserver/bin-linux/bedrock-server-1.21.81.2.zip"

service_install()
{

    echo  "Updating Packages and installing tools"
    apt update -y
    apt install unzip curl -y

    echo  "Adding user and dirs"

    useradd -m -d /home/minecraft -s /bin/bash minecraft
    mkdir -p /home/minecraft/bedrock
    cd /home/minecraft/bedrock

    echo  "Downloading minecraft"
    curl -H "Accept-Encoding: identity" -H "Accept-Language: en" -s -L -A "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; BEDROCK-UPDATER)" $MINECRAFT_BEDROCK_URL -o bedrock.zip

    echo  "unzipping and changing ownership"
    unzip bedrock.zip
    chown -R minecraft:minecraft /home/minecraft/bedrock

    create_systemd_service
}

service_configure() 
{

    create_config_file

    systemctl enable --now bedrock

}

service_bootstrap() 
{
    
    echo  "BOOTSTRAP FINISHED"

    return 0

}




#### Custom Functions

create_config_file()
{

echo "Creating the server.properties file"

cat > /home/minecraft/bedrock/server.properties <<EOF
server-name=$SERVER_NAME
gamemode=$GAMEMODE
force-gamemode=$FORCE_GAMEMODE
difficulty=$DIFFICULTY
allow-cheats=$ALLOW_CHEATS
max-players=$MAX_PLAYERS
online-mode=$ONLINE_MODE
allow-list=$ALLOW_LIST
server-port=$SERVER_PORT
server-portv6=$SERVER_PORTV6
enable-lan-visibility=$ENABLE_LAN_VISIBILITY
view-distance=$VIEW_DISTANCE
tick-distance=$TICK_DISTANCE
player-idle-timeout=$PLAYER_IDLE_TIMEOUT
max-threads=$MAX_THREADS
level-name=$LEVEL_NAME
level-seed=$LEVEL_SEED
default-player-permission-level=$DEFAULT_PLAYER_PERMISSION_LEVEL
texturepack-required=$TEXTUREPACK_REQUIRED
content-log-file-enabled=$CONTENT_LOG_FILE_ENABLED
compression-threshold=$COMPRESSION_THRESHOLD
compression-algorithm=$COMPRESSION_ALGORITHM
server-authoritative-movement-strict=$SERVER_AUTHORITATIVE_MOVEMENT_STRICT
server-authoritative-dismount-strict=$SERVER_AUTHORITATIVE_DISMOUNT_STRICT
server-authoritative-entity-interactions-strict=$SERVER_AUTHORITATIVE_ENTITY_INTERACTIONS_STRICT
player-position-acceptance-threshold=$PLAYER_POSITION_ACCEPTANCE_THRESHOLD
player-movement-action-direction-threshold=$PLAYER_MOVEMENT_ACTION_DIRECTION_THRESHOLD
server-authoritative-block-breaking-pick-range-scalar=$SERVER_AUTHORITATIVE_BLOCK_BREAKING_PICK_RANGE_SCALAR
chat-restriction=$CHAT_RESTRICTION
disable-player-interaction=$DISABLE_PLAYER_INTERACTION
client-side-chunk-generation-enabled=$CLIENT_SIDE_CHUNK_GENERATION_ENABLED
block-network-ids-are-hashes=$BLOCK_NETWORK_IDS_ARE_HASHES
disable-persona=$DISABLE_PERSONA
disable-custom-skins=$DISABLE_CUSTOM_SKINS
server-build-radius-ratio=$SERVER_BUILD_RADIUS_RATIO
allow-outbound-script-debugging=$ALLOW_OUTBOUND_SCRIPT_DEBUGGING
allow-inbound-script-debugging=$ALLOW_INBOUND_SCRIPT_DEBUGGING
script-debugger-auto-attach=$SCRIPT_DEBUGGER_AUTO_ATTACH
EOF
}

create_systemd_service()
{
    
echo "Configure systemd service"

cat > /etc/systemd/system/bedrock.service <<EOF

[Unit]
Description=Minecraft Bedrock Server
After=network.target

[Service]
User=minecraft
Group=minecraft

Type=Simple

WorkingDirectory=/home/minecraft/bedrock
ExecStart=/bin/sh -c "LD_LIBRARY_PATH=. ./bedrock_server"
TimeoutStopSec=20
Restart=on-failure

[Install]
WantedBy=multi-user.target
EOF


}