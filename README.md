# Flight Sensor Package Demo

This is the clean demo version for the MATLAB Expo package-management workflow.
It uses a local copy of the NASA aircraft sensor dataset and a File Exchange
dependency, `chart_examples`, declared in `matlab.toml`.

## Demo Story

An engineering team is reviewing flight telemetry before using true airspeed as a
virtual sensor target. The app walks through a small, realistic workflow:

1. Load and preview the local flight data.
2. Plot the raw sensor trend.
3. Clean ground records and oil sensor dropouts.
4. Explore sensor relationships with clean app-native plots.
5. Fit a lightweight virtual sensor model for true airspeed.

## Run

Open the project from this folder in MATLAB R2026b, install project
dependencies, and run:

```matlab
FlightSensorApp
```

The app is an App Designer plaintext app:

- `apps/FlightSensorApp.m`
- `apps/FlightSensorApp.xml`

## Explore Options

The Explore tab currently exposes three app views:

1. `Relationship` compares a selected predictor with measured true airspeed and
   overlays a simple linear fit for quick screening.
2. `Trend` shows one selected signal over time. The colorbar is the selected
   signal value.
3. `Prediction check` uses a clean app-native axes view to compare predicted
   and measured true airspeed after fitting the virtual sensor.

The project still declares `chart_examples` in `matlab.toml` for the
package-management workshop path. The embedded chart components were removed
from the app view because they did not size cleanly in this App Designer layout.

Package-backed chart ideas that could still fit as a workshop enhancement:

1. `ScatterDensityChart` for high-volume operating envelope coverage.
2. `ScatterBoxChart` for predictor/response coverage plus marginal distributions.
3. `LineGradientChart` for prediction error over time.
