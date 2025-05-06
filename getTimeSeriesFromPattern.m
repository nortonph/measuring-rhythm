function timeSeries = getTimeSeriesFromPattern(pattern, resolution)
% timeSeries = getTimeSeriesFromPattern(pattern, resolution)
%
% constructs a time series (i.e. continuous signal of equally spaced points
% in time that is 1 at the events and 0 otherwise) from a pattern.
%
% pattern:      1-dimensional array of timestamps of events
% resolution:   signal resolution in Hz (e.g. 1000)
% returns the time series

% get the duration of the pattern
durPattern = max(pattern);

% create an empty array for the time series that consists only of zeros
timeSeries = zeros(ceil(durPattern * resolution), 1);

% loop through all events in the pattern
for e = 1:length(pattern)
    % get the appropriate time point by multiplying the timestamp of the 
    % current event by the signal resolution and round down
    timePoint = floor(pattern(e) * resolution);
    
    % set the time series at the time point to 1
    timeSeries(timePoint) = 1;
end

