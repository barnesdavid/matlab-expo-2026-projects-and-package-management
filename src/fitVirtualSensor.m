function model = fitVirtualSensor(flightData)
%FITVIRTUALSENSOR Fit a lightweight true-airspeed virtual sensor.
arguments
    flightData table
end

predictorNames = ["FuelQuantity", "OilPressure", "OilTemperature", "Altitude", ...
    "ExhaustTemperature", "FuelFlow", "FanSpeed", "WindDirection", "WindSpeed"];
X = flightData{:, predictorNames};
y = flightData.TrueAirSpeed;

validRows = all(isfinite(X), 2) & isfinite(y);
X = X(validRows, :);
y = y(validRows);

if numel(y) < 20
    error("flightDemo:NotEnoughData", "At least 20 valid flight rows are required to fit the virtual sensor.");
end

numRows = size(X, 1);
split = max(10, floor(0.70 * numRows));
trainRows = (1:numRows)' <= split;
testRows = ~trainRows;

mu = mean(X(trainRows, :), 1);
sigma = std(X(trainRows, :), 0, 1);
sigma(sigma == 0) = 1;
Xn = (X - mu) ./ sigma;

beta = [ones(nnz(trainRows), 1), Xn(trainRows, :)] \ y(trainRows);
predictedValid = [ones(numRows, 1), Xn] * beta;
rmse = sqrt(mean((predictedValid(testRows) - y(testRows)).^2));

predicted = nan(height(flightData), 1);
predicted(validRows) = predictedValid;

weights = abs(beta(2:end));
[~, order] = sort(weights, "descend");

model = struct;
model.PredictorNames = predictorNames;
model.Coefficients = beta;
model.PredictedTrueAirSpeed = predicted;
model.RMSE = rmse;
model.TestRows = find(validRows);
model.TestRows = model.TestRows(testRows);
model.TopPredictors = predictorNames(order(1:min(3, numel(order))));
end
