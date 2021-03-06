#!/usr/bin/env bash

set -o errexit  # Exit on most errors (see the manual)
set -o errtrace # Make sure any error trap is inherited
set -o nounset  # Disallow expansion of unset variables
set -o pipefail # Use last non-zero exit code in a pipeline
#set -o xtrace          # Trace the execution of the script (debug)

function start_secion_spacer() {
    echo '=============================='
    echo "======== ${1}"
    echo '=============================='
}

function end_secion_spacer() {
    echo '=============================='
    echo
}

DUMP1090_SERVER=${DUMP1090_SERVER:=dump1090}
DUMP1090_PORT=${DUMP1090_PORT:=30005}

start_secion_spacer "Running with"
echo " - DUMP1090_SERVER=${DUMP1090_SERVER}"
echo " - DUMP1090_PORT=${DUMP1090_PORT}"
echo " - DUMP1090_LAT =${DUMP1090_LAT}"
echo " - DUMP1090_LON=${DUMP1090_LON}"
echo " - PLANEFINDER_SHARECODE=${PLANEFINDER_SHARECODE}"
end_secion_spacer

start_secion_spacer "Building default config"
cat <<-EOF >/etc/pfclient-config.json
{
  "connection_type": "1",
  "data_format": "1",
  "tcp_address": "DUMP1090_SERVER",
  "tcp_port": "DUMP1090_PORT",

  "data_upload_interval": "10",
  "aircraft_timeout": "30",
  "select_timeout": "10",

  "sharecode": "PLANEFINDER_SHARECODE",
  "latitude": "DUMP1090_LAT",
  "longitude": "DUMP1090_LON"
}
EOF
end_secion_spacer

start_secion_spacer "Waiting for ${DUMP1090_SERVER} to start up"
sleep 5s
end_secion_spacer

start_secion_spacer "Ping test to ${DUMP1090_SERVER}"
ping -c 3 "${DUMP1090_SERVER}"
end_secion_spacer

start_secion_spacer 'pfclient-config.json template'
cat /etc/pfclient-config.json
end_secion_spacer

start_secion_spacer 'customising config'
sed -i "s/DUMP1090_SERVER/${DUMP1090_SERVER}/" /etc/pfclient-config.json
sed -i "s/DUMP1090_PORT/${DUMP1090_PORT}/" /etc/pfclient-config.json
sed -i "s/DUMP1090_LAT/${DUMP1090_LAT}/" /etc/pfclient-config.json
sed -i "s/DUMP1090_LON/${DUMP1090_LON}/" /etc/pfclient-config.json
sed -i "s/PLANEFINDER_SHARECODE/${PLANEFINDER_SHARECODE}/" /etc/pfclient-config.json
end_secion_spacer

start_secion_spacer "pfclient-config.json customised"
cat /etc/pfclient-config.json
end_secion_spacer

start_secion_spacer 'pfclient version'
pfclient --version
end_secion_spacer

start_secion_spacer 'Starting pfclient'
exec /usr/local/bin/pfclient --config_path=/etc/pfclient-config.json --log_path=/var/log
