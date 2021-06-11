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
  # we're looking for <data> tags with an `id` attribute
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
    if (data[selected_params[i]] == "-") {
       printf("N/A")
    } else if (selected_params[i] == "temp") {
      printf("%+.f%s", data[selected_params[i]], units[selected_params[i]])
    } else {
      printf("%.1f%s", data[selected_params[i]], units[selected_params[i]])
    }
    printf(" ")
  }
  printf("\n")
}
