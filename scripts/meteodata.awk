BEGIN {
  # a way to parse XML with awk...
  FS="[<|>]"

  # CSV from `@meteodata-params`
  split(params, selected_params, ",")

  # unit definitions from https://meteo.physic.ut.ee/xml/params.php
  units["temp"]     = "°C"
  units["humid"]    = "%"
  units["baro"]     = "hPa"
  units["wind_dir"] = "°"
  units["wind_len"] = "m/s"
  units["lux"]      = "lx"
  units["sole"]     = "W/m²"
  units["gamma"]    = "μSv/h"
  units["precip"]   = "mm/s"

  # to map `wind_dir` to one of 8 Unicode chars
  sectors[0] = "↓"
  sectors[1] = "↙"
  sectors[2] = "←"
  sectors[3] = "↖"
  sectors[4] = "↑"
  sectors[5] = "↗"
  sectors[6] = "→"
  sectors[7] = "↘"
  sectors[8] = "↓"
}

{
  # awk regular expression engine unfortunately doesn't capture its groups
  # we're looking for `data` tags with an `id` attribute
  if (NF != 5 || match($2, /data id/) == 0) {
    next
  }

  # value of the `id` attribute will get us the parameter
  current_param = $2
  gsub("data id=\"|\"", "", current_param)

  # current value of that parameter
  current_data = $3

  data[current_param] = current_data
}

END {
  # let's print those bad boys
  for (i=1; i<=length(selected_params); i++) {
    printf(" ")

    current_param = selected_params[i]
    if (current_param in data) {

      if (data[current_param] == "-") {
        printf("N/A")
        continue
      } else {
        (current_param == "temp") ? format = "%+.f%s" : format = "%.1f%s"
        printf(format, data[current_param], units[current_param])
      }

    } else if (current_param == "wind") {

      printf(wind_dir_to_symbol(data["wind_dir"]))
      printf("%.1f", data["wind_len"])
      printf(units["wind_len"])

    } else {

      printf("?")

    }
  }

  printf("\n")
}

function wind_dir_to_symbol(wind_dir) {
  sector_index = int((wind_dir % 360) / 45)
  return sectors[sector_index]
}
