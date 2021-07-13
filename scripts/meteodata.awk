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
      current_data = data[current_param]
      current_unit = units[current_param]

      if (current_data == "-") {
        printf("N/A")
        continue
      }

      (current_param == "temp") ? fmt_str = "%+.f%s" : fmt_str = "%.1f%s"
      printf(fmt_str, current_data, current_unit)
    } else {
      printf("?")
    }
  }
  printf("\n")
}
