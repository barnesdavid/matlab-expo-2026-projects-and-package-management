# Air Speed Virtual Sensor

This R2026b based MATLAB Project example demonstrates how to declare, resolve, and
use a File Exchange package dependency. It combines a local NASA aircraft
sensor dataset with the `chart_examples` package declared in `matlab.toml`.

The example is intentionally self-contained: its only external package
dependency is obtained from File Exchange. It also includes a plaintext App
Designer app, a plaintext live script, and a toolbox package definition that
can be built from the same project.

## Overview

An engineering team is reviewing flight telemetry before using true airspeed as a
virtual sensor target. The app walks through a small, realistic workflow:

1. Load and preview the local flight data.
2. Plot the raw sensor trend.
3. Clean ground records and oil sensor dropouts.
4. Explore flight trends and sensor relationships with specialized charts from
   File Exchange.
5. Fit a lightweight virtual sensor model for true airspeed.

## Open and Run

Open the `final-demo` project folder in MATLAB R2026b. MATLAB resolves the
`chart_examples` dependency declared in `matlab.toml` when the project opens.
Use the **Open flight sensor app** project shortcut, or run:

```matlab
FlightSensorApp
```

The app is stored as plaintext App Designer source:

- `apps/FlightSensorApp.m`
- `apps/FlightSensorApp.xml`

To review the File Exchange chart components outside the app, open
`examples/ExploreVirtualSensorWithChartExamples.m`.

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

## Build the Package

The project defines one toolbox package:

- Package name: `AirSpeedVirtualSensor`
- Version: `1.0.0`
- Output: `release/AirSpeedVirtualSensor_1_0_0.mltbx`
- Included content: app, app XML, local dataset, source functions, and live
  script example

Build it from the project root:

```matlab
buildtool package
```

The generated toolbox is excluded from source control. The File Exchange
dependency is managed by the source project through `matlab.toml`; users who
only install the toolbox can use the app's Explore tab to install
`chart_examples`.

## Relevant Products

- MATLAB R2026b
- Statistics and Machine Learning Toolbox
- File Exchange package: `chart_examples`
