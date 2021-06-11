#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source "$CURRENT_DIR/shared.sh"

print_meteodata() {
  local meteoparams=$(get_tmux_option @meteodata-params "temp,wind_len")
  local meteodata=$(curl https://meteo.physic.ut.ee/xml/data.php)
  local formatted_data=$(echo "$meteodata" | awk -v params=$meteoparams -f $CURRENT_DIR/meteodata.awk)
  echo $formatted_data
}

main() {
  print_meteodata
}

main
