function [freq, power, timeSeries] = plotFFT(pattern, resolution)
% [freq, power, timeSeries] = plotFFT(pattern, resolution)
%
% calculates fast fourier transform (fft) from a pattern and plots the
% results
%
% pattern:      1-dimensional array of timestamps of events
% resolution:   signal resolution in Hz (e.g. 1000)
%
% returns frequency, power and time series

% maximum frequency to be plotted in Hz (adjust according to your needs)
maxFreq = 5;

% transform pattern to time series
timeSeries = getTimeSeriesFromPattern(pattern, resolution);

% perform fft (taken from:
% http://de.mathworks.com/help/matlab/math/fast-fourier-transform-fft.html)
m       = length(timeSeries);       % Window length
n       = pow2(nextpow2(m));        % Transform length
y       = fft(timeSeries,n);        % DFT of signal
freq    = (0:n-1)*(resolution/n);   % Frequency range
power   = y.*conj(y)/n;             % Power of the DFT

% cut to first half
freq    = freq(1:floor(n/2));
power   = power(1:floor(n/2));

% plot power as a function of frequency and adjust x-axis limits
plot(freq, power, 'k');
xlim([-maxFreq/50,maxFreq]);

% add a title and axis labels
title('FFT', 'FontWeight', 'bold', 'FontSize', 12); 
xlabel('frequency [Hz]');
ylabel('power');

% remove ticks on the y-axis and tick marks on both
set(gca,'YTick',[],'TickLength',[0 0]);
