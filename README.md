# MATLAB Projects and Package Management

This 90-minute workshop shows how MATLAB Projects and MATLAB Package Manager create a consistent development environment for people, continuous integration (CI) systems, and AI agents.

## About the Workshop

This hands-on workshop guides you through:

- Open a MATLAB Project to set up the development environment
- Run `FlightSensorApp`, which has a package dependency
- Install `Chart_Examples` from File Exchange using MATLAB Package Manager
- Declare `Chart_Examples` in `matlab.toml` so MATLAB installs it when the project opens
- Build an `.mltbx` file to share the app and its supporting files

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
- `utils/` - Workshop helpers for adding package dependencies and metadata and restoring the starter project configuration
- `buildfile.m` - Build Tool tasks for code checks, tests, and building a package

## Build a Package from the Project

The starter `matlab.toml` intentionally does not contain a `[[package]]` section. During the workshop, create the package configuration by clicking **Build Package** in the MATLAB Project Toolstrip or running `workshopAddPackageMetadataToProject`. Only after that configuration exists can you run:

```matlab
buildtool package
```

The task creates the `.mltbx` package file in the output folder configured in the package task. The `.mltbx` can then be published to a package repository so other users can install the package with MATLAB Package Manager.

Copyright 2026 The MathWorks, Inc.
