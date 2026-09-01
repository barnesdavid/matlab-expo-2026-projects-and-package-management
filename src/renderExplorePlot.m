function ax = renderExplorePlot(ax, flightData, plotType, xVariable, yVariable)
%RENDEREXPLOREPLOT Render the data exploration chart used by the app.
arguments
    ax (1,1) matlab.ui.control.UIAxes
    flightData table
    plotType (1,1) string
    xVariable (1,1) string
    yVariable (1,1) string
end

figureHandle = ancestor(ax, "figure");
delete(findall(figureHandle, "Type", "ColorBar"));
cla(ax, "reset");
ax.Box = "on";
grid(ax, "on");

rows = sampleFlightRows(height(flightData), 2600);

switch plotType
    case "Trend"
        y = flightData.(yVariable)(rows);
        time = flightData.Time(rows);
        validRows = isfinite(y) & ~isnat(time);
        time = time(validRows);
        y = y(validRows);
        elapsedMinutes = minutes(time - time(1));

        plot(ax, elapsedMinutes, y, Color=[0.70 0.70 0.70], LineWidth=1.0);
        hold(ax, "on");
        scatter(ax, elapsedMinutes, y, 18, y, "filled", ...
            MarkerFaceAlpha=0.82, MarkerEdgeAlpha=0.10);
        hold(ax, "off");
        colormap(ax, turbo(256));
        cb = colorbar(ax);
        cb.Label.String = variableLabel(yVariable) + variableUnits(yVariable);
        title(ax, variableLabel(yVariable) + " across the flight");
        xlabel(ax, "Elapsed time (min)");
        ylabel(ax, variableLabel(yVariable) + variableUnits(yVariable));

    case "Prediction check"
        predicted = flightData.(xVariable)(rows);
        measured = flightData.(yVariable)(rows);
        time = flightData.Time(rows);
        validRows = isfinite(predicted) & isfinite(measured) & ~isnat(time);
        predicted = predicted(validRows);
        measured = measured(validRows);
        time = time(validRows);
        elapsedMinutes = minutes(time - time(1));

        plot(ax, elapsedMinutes, measured, LineWidth=1.7, Color=[0.05 0.33 0.56]);
        hold(ax, "on");
        plot(ax, elapsedMinutes, predicted, LineWidth=1.7, Color=[0.78 0.35 0.08]);
        hold(ax, "off");
        title(ax, "Virtual sensor prediction check");
        xlabel(ax, "Elapsed time (min)");
        ylabel(ax, "True airspeed (knots)");
        legend(ax, ["Measured", "Predicted"], Location="southoutside", Orientation="horizontal");

    otherwise
        x = flightData.(xVariable)(rows);
        y = flightData.(yVariable)(rows);
        validRows = isfinite(x) & isfinite(y);
        x = x(validRows);
        y = y(validRows);

        scatter(ax, x, y, 30, ...
            MarkerEdgeColor=[0.00 0.45 0.74], ...
            MarkerFaceColor="none", ...
            MarkerEdgeAlpha=0.82);
        hold(ax, "on");
        coefficients = polyfit(x, y, 1);
        fitX = linspace(min(x), max(x), 100);
        fitY = polyval(coefficients, fitX);
        plot(ax, fitX, fitY, LineWidth=2.4, Color=[0.85 0.33 0.10]);
        hold(ax, "off");
        title(ax, variableLabel(xVariable) + " vs. true airspeed");
        xlabel(ax, variableLabel(xVariable) + variableUnits(xVariable));
        ylabel(ax, "True airspeed (knots)");
end
end

function label = variableLabel(variableName)
labels = dictionary( ...
    ["FuelQuantity", "OilPressure", "OilTemperature", "Altitude", ...
    "ExhaustTemperature", "FuelFlow", "FanSpeed", "WindDirection", ...
    "WindSpeed", "TrueAirSpeed", "PredictedTrueAirSpeed"], ...
    ["Fuel quantity", "Oil pressure", "Oil temperature", "Altitude", ...
    "Exhaust temperature", "Fuel flow", "Fan speed", "Wind direction", ...
    "Wind speed", "True airspeed", "Predicted true airspeed"]);

if isKey(labels, variableName)
    label = labels(variableName);
else
    label = variableName;
end
end

function units = variableUnits(variableName)
unitsByVariable = dictionary( ...
    ["OilPressure", "OilTemperature", "Altitude", "ExhaustTemperature", ...
    "FuelFlow", "FanSpeed", "WindDirection", "WindSpeed", ...
    "TrueAirSpeed", "PredictedTrueAirSpeed"], ...
    [" (psi)", " (deg F)", " (ft)", " (deg F)", ...
    " (gal/hr)", " (rpm)", " (deg)", " (knots)", ...
    " (knots)", " (knots)"]);

if isKey(unitsByVariable, variableName)
    units = unitsByVariable(variableName);
else
    units = "";
end
end
