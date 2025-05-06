function [pattern,ioi] = readPatternFromXls(filename)
% [pattern,ioi] = readPatternFromXls(filename)
%
% reads a pattern (list of timestamps of events) from an Excel table file
% (*.xls) and returns the pattern and as its inter-onset intervals (IOIs)
% 
% filename:   filename of .xls table. Must be located in current directory
%
% returns a 1-dimensional array of timestamps of events (pattern) and a
% 1-dimensional array of the corresponding inter-onset intervals (ioi)

% read pattern from file
pattern = xlsread(filename);

% get the size of the pattern & make sure it has 1 row and multiple columns
sizePattern = size(pattern);
if (sizePattern(1) > 1 && sizePattern(2) == 1)
    % if the pattern has one column and multiple rows, transpose it
    pattern = transpose(pattern);
elseif (sizePattern(1) == 1 && sizePattern(2) > 1)
    % if the has one row and many columns, we're fine -> do nothing
elseif (sizePattern(1) > 1 && sizePattern(2) > 1)
    % if the pattern has many rows and many columns, display error and exit
    error('the table must have either a single row or a single column');
elseif (sizePattern(1) == 1 && sizePattern(2) == 1)
    % if the pattern has only a single value, display error and exit
    error('the table must contain more than one number');
else
    % something else went wrong. display error and exit
    error('something went wrong');
end

% calculate IOIs
ioi = pattern(2:end) - pattern(1:end-1);