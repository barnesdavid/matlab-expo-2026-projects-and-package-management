# MATLAB Projects and Package Management

This 90-minute workshop uses an air speed virtual sensor app to introduce MATLAB Projects, the MATLAB Package Manager, project dependencies, app testing, and package management in MATLAB R2026b.

## Open in MATLAB Online

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=barnesdavid/matlab-expo-2026-projects-and-package-management&file=WorkshopGuide.m)

From MATLAB R2026b, clone this repository from:

```matlab
gitclone https://github.com/barnesdavid/matlab-expo-2026-projects-and-package-management
```

The workshop requires MATLAB R2026b and Statistics and Machine Learning Toolbox.

## Start the Workshop

1. In the MATLAB Files panel, double-click `matlab.toml` to open the project. MATLAB configures the project paths.
2. In the Project tab, select **Open workshop guide**.
3. Complete `WorkshopGuide.m` in order.

The guide begins with the app's core workflow and an optional File Exchange capability that is unavailable until Chart Examples is installed. You will install `chart_examples` manually with `mpminstall`, then add it as a project dependency so MATLAB restores it when the project opens.

## Workshop Contents

- `WorkshopGuide.m` - Plain-text live script containing the student workflow
- `matlab.toml` - MATLAB Project configuration
- `src/app/FlightSensorApp.m` - Plain-text App Designer app
- `src/data/FlightData.xlsx` - Flight sensor data used by the app
- `src/examples/ExploreVirtualSensorWithChartExamples.m` - Chart Examples exploration script
- `tests/testFlightSensorApp.m` - App workflow tests that save `results/FlightSensorApp.png`
- `buildfile.m` - Build Tool tasks for code checks, tests, and toolbox packaging

## Toolbox Packaging

The starter `matlab.toml` intentionally does not contain a `[[package]]` section. During the workshop, the **Build Package** task creates that package configuration after participants choose the package metadata and output settings. Only after that configuration exists can they run:

```matlab
buildtool package
```

The task creates the toolbox file in the output folder configured in the package task. Generated `release`, `results`, and `.buildtool` folders are excluded from source control.
