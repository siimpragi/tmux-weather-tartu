# Tmux Tartu Weather

Tmux plugin that displays data from the [weather station at University of Tartu Institute of Physics](https://meteo.physic.ut.ee/?lang=en) in the status bar.

The plugin introduces a new format: `#{meteodata}`

## Usage

Add `#{meteodata}` to your existing `status-left` or `status-right` option:

```
set -g status-right '#{meteodata} | %H:%M'
```

Current weather data will be displayed like this:

```
+21°C 1.5m/s | 16:20
```

## Additional Options

By default only the temperature and wind speed are printed. You can override this with the `@meteodata-params` option.

`@meteodata-params` can contain a comma separated list of [parameters](https://meteo.physic.ut.ee/xml/params.php). These are: 

| **Parameter** | **Name**         | **Unit** |
| ------------- | ---------------- | -------- |
| `temp`        | temperature      | °C       |
| `humid`       | humidity         | %        |
| `baro`        | air pressure     | hPa      |
| `wind_dir`    | wind direction   | °        |
| `wind_len`    | wind speed       | m/s      |
| `lux`         | illuminance      | lx       |
| `sole`        | irradiation flux | W/m²     |
| `gamma`       | radiation        | μSv/h    |
| `precip`      | precipitation    | mm/s     |

## Installation

### With [TPM](https://github.com/tmux-plugins/tpm)

Add this plugin to your list of TPM plugins in `.tmux.conf`:

```
set -g @plugin 'siimpragi/tmux-weather-tartu'
```

Press `prefix` + <kbd>I</kbd> to fetch the plugin.

### Manually

Clone this repo:

```
$ git clone https://github.com/siimpragi/tmux-weather-tartu ~/some/path
```

In the bottom of your `.tmux.conf` add:

```
run-shell ~/some/path/weather.tmux
```

Reload tmux with:

```
$ tmux source-file ~/.tmux.conf
```

## TODO

- [ ] Combine `wind_len` and `wind_dir`. Wind direction to be represented by Unicode arrow characters (U+2190–U+2193,U+2196–U+2199).
- [ ] Account for low `status-interval` option. Wouldn't want to bombard the server. The weather station data is only updated every 10 seconds anyways.

