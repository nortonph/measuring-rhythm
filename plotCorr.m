function [correlation, sigConvOne, sigConvTwo] = plotCorr(patternOne, patternTwo, resolution)
% [correlation, sigConvOne, sigConvTwo] = plotCorr(pattern, resolution)
%
% performs autocorrelation or crosscorrelation on one or two patterns. if
% the second argument (patternTwo) is zero (or empty), autocorrelation is
% performed on patternOne. if the second argument contains a pattern, 
% patternOne is cross-correlated with patternTwo. patterns are transformed
% to a time series and then convoluted with a normal distribution 
% to deal with variability in the timing of events.
%
% patternOne: 1-dimensional array of timestamps of events
% patternTwo: either a second pattern or 0 for autocorrelation of patternOne
% resolution: signal resolution in Hz (e.g. 1000)
%
% returns the auto-/crosscorrelation function and the convoluted time 
% series of the pattern(s)

% standard deviation & width of normal probability density function (npdf)
% set these according to the expected variability and IOIs of your pattern
stdev   = 0.03;
width   = 0.2;

% transform first (possibly only) pattern to time series
signalOne = getTimeSeriesFromPattern(patternOne, resolution);

% construct a normal probability density function (npdf) for convolution 
% with the signal (time series) and normalize to 1
npdf    = normpdf(-width/2:1/resolution:width/2, 0, stdev);
npdf    = npdf / max(npdf);

% convolute the signal with the npdf
sigConvOne = conv(signalOne, npdf);
sigConvOne = sigConvOne(round(resolution * width/2):end);

% check whether a second pattern was passed
if (length(patternTwo) > 1)
    % transform second pattern to time series
    signalTwo   = getTimeSeriesFromPattern(patternTwo, resolution);

    % convolute the second signal with the npdf
    sigConvTwo  = conv(signalTwo, npdf);
    sigConvTwo  = sigConvTwo(round(resolution * width/2):end);
    
    % in order to normalize the crosscorrelation, both signal must
    % have equal length. test if signals are of equal length. 
    if (length(sigConvTwo) > length(sigConvOne))
        % if signal 2 is longer, add a number of zeros to signal 1 equal to
        % the difference in length between the two signals
        difference = length(sigConvTwo) - length(sigConvOne);
        sigConvOne = [sigConvOne;zeros(difference,1)];
    elseif (length(sigConvOne) > length(sigConvTwo))
        % if signal 1 is longer, add a number of zeros to signal 2 equal to
        % the difference in length between the two signals
        difference = length(sigConvOne) - length(sigConvTwo);
        sigConvTwo = [sigConvTwo;zeros(difference,1)];
    end

    % cross-correlate the two convoluted signals
    correlation = xcorr(sigConvOne, sigConvTwo, 'coeff');
    correlation = correlation(round(length(correlation)/2):end);
else
    % autocorrelate the convoluted first signal
    correlation = xcorr(sigConvOne, 'coeff');
    correlation = correlation(round(length(correlation)/2):end);
end

% calculate x-values for plot (i.e. time lags of correlation function)
xStep   = 1 / resolution;
maxLag  = max([patternOne,patternTwo]) / 2;

% plot auto-/crosscorrelation function and adjust axis limits
plot(xStep:xStep:maxLag, correlation(1:floor(maxLag*resolution)), 'k');
xlim([-maxLag/50,maxLag]);
ylim([0,1]);

% add an x-axis label
xlabel('lag [s]');

% check whether one or two patterns were passed and add appropriate title
if (length(patternTwo) > 1)
    title('Cross-correlation', 'FontWeight', 'bold', 'FontSize', 12); 
else
    title('Autocorrelation', 'FontWeight', 'bold', 'FontSize', 12); 
end