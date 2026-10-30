# MATLAB Projects and Package Management

This 90-minute workshop introduces MATLAB Projects and MATLAB Package Manager to set up a consistent development environment that works on my machine, your machine, and in Continuous Integration (CI) systems.

## About the Workshop

This hands-on workshop guides you through:

- Set up the development environment by opening the MATLAB Project
- Install the package dependency `Chart_Examples` from File Exchange
- Declare package dependencies in the `matlab.toml`
- Run tests to verify the code works as intended
- Build a package from the project using Build Tool

## Open in MATLAB Online

[![Open in MATLAB Online](https://www.mathworks.com/images/responsive/global/open-in-matlab-online.svg)](https://matlab.mathworks.com/open/github/v1?repo=barnesdavid/matlab-expo-2026-projects-and-package-management&file=WorkshopGuide.m)

From MATLAB R2026b, clone this repository from:

```matlab
gitclone https://github.com/barnesdavid/matlab-expo-2026-projects-and-package-management
```

The workshop requires MATLAB R2026b and Statistics and Machine Learning Toolbox.

## Workshop License

Use the [MATLAB Expo 2026 workshop license](https://www.mathworks.com/licensecenter/classroom/expo2026-4) to start MATLAB for this workshop.

## Getting Started

1. In the MATLAB Files panel, double-click `matlab.toml` to open the project. MATLAB configures the project paths.
2. In the Project tab, select **WorkshopGuide**.
3. Complete `WorkshopGuide.m` in order.

Step-by-step instructions are available in [WorkshopGuide.md](WorkshopGuide.md) or [WorkshopGuide.m](WorkshopGuide.m).

The guide begins with the app's core workflow and an optional File Exchange capability that is unavailable until `Chart_Examples` is installed. Use the app **Refresh** button after installing the package to recheck its availability without closing the app.

The starter `matlab.toml` includes a commented `Chart_Examples` dependency template. During the workshop, add the dependency by using the MATLAB Projects UI, uncommenting the template, or running `workshopAddPackageDependencyToProject`. MATLAB Projects installs declared package dependencies when the project opens.

## Workshop Contents

- `WorkshopGuide.m` - Plain-text live script containing the student workflow
- `matlab.toml` - MATLAB Project configuration
- `src/app/FlightSensorApp.m` - Plain-text App Designer app
- `src/data/FlightData.xlsx` - Flight sensor data used by the app
- `src/examples/ExploreVirtualSensorWithChartExamples.m` - Chart Examples exploration script
- `tests/` - Unit tests for the data-loading, cleaning, model-fitting, and sampling functions
- `utils/` - Workshop helpers for adding package dependencies and metadata, verifying the dependency, and restoring the starter project configuration
- `buildfile.m` - Build Tool tasks for code checks, tests, and building a package

## Build a Package from the Project

The starter `matlab.toml` intentionally does not contain a `[[package]]` section. During the workshop, create the package configuration with the **Build Package** task or `workshopAddPackageMetadataToProject`. Only after that configuration exists can you run:

```matlab
buildtool package
```

The task creates the `.mltbx` file in the output folder configured in the package task.

Copyright 2026 The MathWorks, Inc.
