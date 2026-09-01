function [cleanData, summary] = cleanFlightData(rawData)
%CLEANFLIGHTDATA Remove ground samples and fill oil sensor dropouts.
arguments
    rawData table
end

groundRows = rawData.TrueAirSpeed < 35 | rawData.Altitude < 100;
flightData = rawData(~groundRows, :);

pressureDropout = flightData.OilPressure < 40 | flightData.OilPressure > 110;
temperatureDropout = flightData.OilTemperature < -50 | flightData.OilTemperature > 220;

cleanData = filloutliers(flightData, "linear", "movmedian", 100, ...
    DataVariables=["OilPressure", "OilTemperature"]);

summary = struct;
summary.RawRows = height(rawData);
summary.FlightRows = height(flightData);
summary.GroundRowsRemoved = nnz(groundRows);
summary.PressureSamplesCleaned = nnz(pressureDropout);
summary.TemperatureSamplesCleaned = nnz(temperatureDropout);
summary.TotalSamplesCleaned = nnz(pressureDropout | temperatureDropout);
end
