function rows = sampleFlightRows(numRows, maxSamples)
%SAMPLEFLIGHTROWS Return stable row indices for responsive plotting.
arguments
    numRows (1,1) double {mustBeNonnegative, mustBeInteger}
    maxSamples (1,1) double {mustBePositive, mustBeInteger} = 1800
end

if numRows == 0
    rows = zeros(0, 1);
elseif numRows <= maxSamples
    rows = (1:numRows)';
else
    rows = unique(round(linspace(1, numRows, maxSamples)))';
end
end
