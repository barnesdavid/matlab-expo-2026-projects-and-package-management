# MATLAB Expo Workshop Plan

## Purpose

Transform the Air Speed Virtual Sensor App into a 90-minute, beginner-friendly MATLAB Expo workshop for MATLAB R2026b. The workshop teaches how MATLAB Projects manage paths, tests, build metadata, and MATLAB Package Manager dependencies.

The source repository is:

<https://insidelabs-git.mathworks.com/AE-Content/demos/air-speed-virtual-sensor-app>

Do not push changes to that source repository. A public GitHub destination will be supplied later.

The structural reference is:

<https://github.com/mathworks/Generating-Tests-for-Your-MATLAB-Code-Workshop>

## Audience and Prerequisites

- Audience: MATLAB users new to projects and package management.
- Duration: 90 minutes.
- Required release: MATLAB R2026b.
- Required product: Statistics and Machine Learning Toolbox.
- Optional environment: MATLAB Online or desktop MATLAB.
- External package: File Exchange `chart_examples`.

## Workshop Story

An engineering team uses local flight telemetry to build and inspect a virtual sensor for true airspeed. The app works without external packages for data loading, cleanup, plotting, and fitting. Its specialized Explore charts require the File Exchange `chart_examples` package.

This creates a useful progression:

1. The student sees a working app with one clearly unavailable capability.
2. The student installs the package manually and sees the capability become available.
3. The student declares the package in the project so setup becomes reproducible.
4. The student runs app tests and packages the project as a toolbox.

## Student Workflow

1. Clone the public workshop repository or use the README "Open in MATLAB Online" link.
2. Double-click `matlab.toml` to open the MATLAB Project.
3. Explain that project paths are configured automatically.
4. Run `FlightSensorApp`.
5. Use the core workflow and select **Explore Data**.
6. Observe that the optional charts are unavailable and that the app presents `mpminstall chart_examples`.
7. Close the app and close the project.
8. Run `mpminstall chart_examples`.
9. Run `mpmlist("chart_examples")` to inspect the manual installation.
10. Reopen the project and run the app again.
11. Confirm that the Explore charts now work.
12. In `matlab.toml`, uncomment the `chart_examples` entry under `[dependencies]`, or add the dependency through Project Settings.
13. Close the project and run `mpmlist("chart_examples")`.
14. Run `mpmuninstall("chart_examples", Prompt=false)` to remove the manually installed package.
15. Confirm the package is absent with `mpmlist("chart_examples")`.
16. Reopen `matlab.toml`.
17. Confirm MATLAB restores the declared dependency and verify it with `mpmlist("chart_examples")`.
18. Run the app once more and confirm the Explore charts are available.
19. Run `runtests("tests")`.
20. Inspect the app screenshot written to `results/FlightSensorApp.png`.
21. Run `buildtool package`.
22. Confirm `release/AirSpeedVirtualSensor_1_0_0.mltbx` exists.

## Initial Draft Artifacts

The initial draft adds or changes the following files:

| File | Role |
| --- | --- |
| `WorkshopGuide.m` | Plain-text live script containing the complete student workflow. |
| `README.md` | Workshop overview, prerequisites, clone guidance, and MATLAB Online badge template. |
| `matlab.toml` | Starter project configuration with the package dependency intentionally commented out. |
| `tests/testFlightSensorApp.m` | App workflow test that uses `exportapp` to save an app screenshot. |
| `.gitignore` | Excludes generated `release/` and `results/` directories. |

The public GitHub owner/repository is not known yet. The README uses an `OWNER/REPOSITORY` placeholder in the MATLAB Online URL. Replace it when the public repository is provided.

## Technical Decisions

### Project Start State

The starter `matlab.toml` must contain this disabled declaration:

```toml
[dependencies]
# chart_examples = {version = "*", id = "d47c73c1-4864-4beb-93d4-9642d80fcb1b"}
```

This is essential. The original source clone had the dependency active, which would install the package as soon as the project opened and would bypass the first teaching moment.

### Manual Package Installation

The File Exchange page for Chart Examples provides:

```matlab
mpminstall chart_examples
```

The package identifier is:

```text
d47c73c1-4864-4beb-93d4-9642d80fcb1b
```

The current File Exchange release observed during drafting was `2.2.6`. The workshop uses the package name rather than pinning a version so students receive the current compatible release.

### Screenshot Capture

R2026b documents `exportapp(fig, filename)` for capturing an App Designer or `uifigure` app as PNG, JPEG, TIFF, or PDF. The app workflow test writes:

```text
results/FlightSensorApp.png
```

The image is generated, is not source-controlled, and gives students a visible artifact from the test run.

### Toolbox Build

The existing `buildfile.m` defines `check`, `test`, and `package` build tasks. The `[[package]]` section in `matlab.toml` produces:

```text
release/AirSpeedVirtualSensor_1_0_0.mltbx
```

## Validation Plan

Validate in MATLAB R2026b after restarting Codex so the repaired MATLAB MCP configuration is active.

1. Open the starter project with `openProject(projectRoot, Prompt=false)` and verify `chart_examples` is absent.
2. Launch the app and verify the button text includes `Package Missing: Chart Examples`.
3. Verify `exportapp` creates a PNG for the app.
4. Install `chart_examples` with `mpminstall`.
5. Verify the Explore tab supports both `LineGradientChart` and `ScatterFitChart`.
6. Run `runtests("tests")` and confirm the screenshot exists.
7. In a temporary validation copy, uncomment the dependency, uninstall the package, and reopen the project to verify automatic dependency restoration.
8. Restore the committed starter state with the dependency commented out.
9. Run `buildtool package` and confirm the `.mltbx` file is created.
10. Run Code Analyzer on `WorkshopGuide.m` and the modified app workflow test.

## Current Status

Completed:

- Cloned the source application and the reference workshop locally.
- Identified the package and its File Exchange installation command.
- Created the initial `WorkshopGuide.m`.
- Reworked the README around the workshop.
- Added project shortcuts for the guide and app.
- Commented out the starter dependency declaration.
- Added generated-artifact ignores.
- Added an app-test screenshot capture using `exportapp`.
- Corrected Codex and MATLAB toolkit configuration from `R2026b_Prerelease` to the released R2026b installation.

Needs validation after restart:

- MATLAB MCP tool calls should load from the corrected R2026b path in a new Codex session.
- Full manual-install and project-managed-install student flows.
- App tests and generated screenshot.
- Build tool package output.
- Live Editor rendering of `WorkshopGuide.m`.

## Known Environment Note

The MATLAB MCP configuration was repaired in:

```text
C:\Users\dbarnes\.codex\config.toml
C:\Users\dbarnes\.matlab\agentic-toolkits\config.json
```

Both now target:

```text
C:\Program Files\MATLAB\R2026b
```

Restart Codex before resuming so its MATLAB MCP process reloads the updated configuration.

## Follow-Up Review Topics

- Replace the MATLAB Online URL placeholder with the final public GitHub repository.
- Dry-run the guide with new users and adjust pacing, wording, and screenshots.
- Decide whether the README should use a badge, a direct link, or both after the final public URL is known.
- Complete licensing, attribution, and repository-cleanup work before public release.
- Decide whether the workshop should include facilitator notes or a separate presentation.
