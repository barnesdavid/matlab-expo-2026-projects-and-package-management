function flightData = loadFlightData(workbookFile)
%LOADFLIGHTDATA Import the local NASA aircraft sensor workbook.
arguments
    workbookFile (1,1) string
end

opts = spreadsheetImportOptions("NumVariables", 13);
opts.Sheet = 1;
opts.DataRange = "A2:M47313";
opts.VariableNames = ["Time", "FuelQuantity", "OilPressure", "OilTemperature", ...
    "LatitudePosition", "LongitudePosition", "Altitude", "ExhaustTemperature", ...
    "FuelFlow", "FanSpeed", "TrueAirSpeed", "WindDirection", "WindSpeed"];
opts.VariableTypes = ["datetime", "double", "double", "double", "double", ...
    "double", "double", "double", "double", "double", "double", "double", "double"];
opts = setvaropts(opts, "Time", "InputFormat", "");

flightData = readtable(workbookFile, opts, "UseExcel", false);
end
