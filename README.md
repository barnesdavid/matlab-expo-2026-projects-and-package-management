# Flight Sensor Package Demo

This is the clean MATLAB Expo demo for MATLAB Projects, File Exchange package
dependencies, and toolbox packaging in R2026b. It uses a local copy of a NASA
aircraft sensor dataset and the File Exchange `chart_examples` dependency
declared in `matlab.toml`.

## Demo Story

An engineering team is reviewing flight telemetry before using true airspeed as a
virtual sensor target. The app walks through a small, realistic workflow:

1. Load and preview the local flight data.
2. Plot the raw sensor trend.
3. Clean ground records and oil sensor dropouts.
4. Explore flight trends and sensor relationships with specialized charts from
   File Exchange.
5. Fit a lightweight virtual sensor model for true airspeed.

## Run

Open the project folder in MATLAB R2026b. The project resolves the
`chart_examples` dependency declared in `matlab.toml`. Then run:

```matlab
FlightSensorApp
```

The app is an App Designer plaintext app:

- `apps/FlightSensorApp.m`
- `apps/FlightSensorApp.xml`

## Explore Options

The Explore tab opens with a flight trend and exposes three views:

1. `Trend` uses `LineGradientChart` to show one selected signal over time. The
   colorbar is the selected signal value.
2. `Relationship` uses `ScatterFitChart` to compare a selected predictor with
   measured true airspeed and overlay a linear fit for quick screening.
3. `Prediction check` uses a clean app-native axes view to compare predicted
   and measured true airspeed after fitting the virtual sensor.

If `chart_examples` is not installed, the app keeps the data-cleaning and model
workflow available and shows the installation command in the Explore tab.

## Build the Toolbox

The project defines one intentional toolbox package:

- Package name: `FlightSensorPackageDemo`
- Version: `1.0.0`
- Output: `release/FlightSensorPackageDemo_1_0_0.mltbx`
- Included content: app, app XML, local dataset, source functions, and live
  script example

Build it from the project root:

```matlab
buildtool package
```

The generated toolbox contains the demo itself. The File Exchange dependency is
managed by the source project through `matlab.toml`; users who only install the
toolbox can use the app's Explore tab to install `chart_examples`.
