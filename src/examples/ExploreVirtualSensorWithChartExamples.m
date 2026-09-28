%[text] # Flight Sensor Exploration with File Exchange Charts
%[text] This live script is the package-management companion to the flight sensor app. The app keeps the workflow simple and robust; this script shows what the project gains after the `chart_examples` File Exchange dependency is installed from `matlab.toml`.
%%
%[text] ## Demo Setup
%[text] The story is a lightweight virtual sensor review. An engineering team has aircraft telemetry, wants to estimate true airspeed from other measured signals, and needs a fast way to understand which signals are useful before fitting a model.
%[text] This project depends on `chart_examples`, installed from File Exchange with package ID `d47c73c1-4864-4beb-93d4-9642d80fcb1b`.
dependencyCheck = [exist("ScatterFitChart","class") == 8, exist("LineGradientChart","class") == 8];
assert(all(dependencyCheck), "Install project dependencies from matlab.toml before running this live script.")
which("ScatterFitChart")
which("LineGradientChart")
%%
%[text] ## Load and Clean the Flight Data
%[text] The workbook is a local copy of the NASA aircraft dataset used by the app. Cleaning removes ground records and repairs oil sensor dropouts so the plots focus on flight behavior.
rawData = loadFlightData("FlightData.xlsx");
[flightData, cleaningSummary] = cleanFlightData(rawData);
summaryTable = struct2table(cleaningSummary)
%%
%[text] ## Preview the Flight
%[text] This native MATLAB plot gives the audience immediate context: airspeed over the flight, colored by fuel flow. It is the baseline view before the File Exchange charts are added.
previewRows = sampleFlightRows(height(flightData), 2500);
elapsedMinutes = minutes(flightData.Time(previewRows) - flightData.Time(previewRows(1)));
scatter(elapsedMinutes, flightData.TrueAirSpeed(previewRows), 14, flightData.FuelFlow(previewRows), "filled", MarkerFaceAlpha=0.55)
grid on
box on
colormap(turbo)
previewColorbar = colorbar;
previewColorbar.Label.String = "Fuel flow (gal/hr)";
title("True airspeed across the flight")
xlabel("Elapsed time (min)")
ylabel("True airspeed (knots)")
%%
%[text] ## File Exchange Chart: Fan Speed Screen
%[text] `ScatterFitChart` is a UI component from `chart_examples`. Parent it to a specific `uifigure` so the chart has a real UI container instead of relying on the current figure state.
predictorName = "FanSpeed";
rows = sampleFlightRows(height(flightData), 2500);
x = flightData.(predictorName)(rows);
y = flightData.TrueAirSpeed(rows);
validRows = isfinite(x) & isfinite(y);
chartWindow = uifigure("Name", "Fan speed screen", "Visible", "on", "Position", [100 100 760 430]);
relationshipChart = ScatterFitChart("Parent", chartWindow, "XData", x(validRows), "YData", y(validRows), "SizeData", 30, "Marker", "o", "LineWidth", 2.4, "Controls", "off");
legend(relationshipChart, "off")
grid(relationshipChart, "on")
title(relationshipChart, "Fan speed vs. true airspeed")
xlabel(relationshipChart, "Fan speed (rpm)")
ylabel(relationshipChart, "True airspeed (knots)")
%%
%[text] ## File Exchange Chart: Flight Trend
%[text] `LineGradientChart` uses the same pattern. Give the chart an explicit UI parent so it renders predictably.
trendRows = sampleFlightRows(height(flightData), 3000);
trendSignal = flightData.TrueAirSpeed(trendRows);
chartWindow = uifigure("Name", "Flight trend", "Visible", "on", "Position", [120 120 820 460]);
trendChart = LineGradientChart("Parent", chartWindow, "XData", flightData.Time(trendRows), "YData", trendSignal, "LineWidth", 4.0);
colormap(trendChart, turbo(256))
trendColorbar = colorbar(trendChart);
trendColorbar.Label.String = "True airspeed (knots)";
title(trendChart, "True airspeed across the flight")
xlabel(trendChart, "Time")
ylabel(trendChart, "True airspeed (knots)")
%%
%[text] ## Fit the Virtual Sensor
%[text] The simple model uses multiple predictors, so it should be judged differently from the single-predictor screening chart. This section uses the project model helper and compares measured and predicted true airspeed on held-out rows.
model = fitVirtualSensor(flightData);
testRows = model.TestRows;
testRows = testRows(sampleFlightRows(numel(testRows), 1800));
elapsedMinutes = minutes(flightData.Time(testRows) - flightData.Time(testRows(1)));
plot(elapsedMinutes, flightData.TrueAirSpeed(testRows), LineWidth=1.6, Color=[0.05 0.33 0.56])
hold on
plot(elapsedMinutes, model.PredictedTrueAirSpeed(testRows), LineWidth=1.6, Color=[0.85 0.33 0.10])
hold off
grid on
box on
title("Virtual sensor: measured vs. predicted true airspeed")
xlabel("Elapsed time in test segment (min)")
ylabel("True airspeed (knots)")
legend(["Measured", "Predicted"], Location="southoutside", Orientation="horizontal")
%%
%[text] ## Takeaway
%[text] The app demonstrates the operational workflow. This live script demonstrates the package-management payoff: after the File Exchange dependency is installed, the project can use specialized chart classes for exploratory analysis without copying those chart implementations into the project.
%[text] Suggested workshop flow:
%[text] - Run the app first to show the clean baseline workflow.
%[text] - Install the `chart_examples` dependency declared in `matlab.toml`.
%[text] - Open this live script to show the enhanced exploratory analysis enabled by the dependency. \
%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"inline"}
%---
