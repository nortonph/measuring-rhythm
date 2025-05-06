function results = plotAllSingle(pattern,ioi)
% results = plotAllSingle(pattern,ioi)
%
% calls all plot functions consecutively for a single pattern in seperate
% figures and prints the Kolmogorov-Smirnov D and nPVI.
%
% pattern:  1-dimensional array of timestamps of events
% ioi:      1-dimensional array of IOIs in chronological order.
%
% returns the output of all functions in a single structure. The 
% structure consists of:
%  ksD:         Kolmogorov-Smirnov D
%  nPVI:        normalized pairwise variability index
%  correlation: autocorrelation function
%  sigConv:     convoluted signal used for the autocorrelation
%  freqFFT:     the frequencies for the fourier transformation
%  power:       the power of each of these frequencies
%  timeSeries:  the time series of the pattern
%  freqGAT:     the frequencies for the GAT method
%  frmsd:       the frequency-normalized root-mean-square deviation at
%               each of these frequencies

% set temporal resolution for time series in Hertz (samples per second)
temporalResolution = 1000;

% plot the pattern
figure;
plotPattern(pattern);

% plot a histogram of inter-onset intervals (IOIs)
figure;
plotHistogram(ioi);

% plot the autocorrelation function
figure;
[correlation,sigConv] = plotCorr(pattern,0,temporalResolution);

% plot the power spectrum of the fast fourier transformation (fft)
figure;
[freqFFT,power,timeSeries] = plotFFT(pattern,temporalResolution);

% plot the results of the pulse generate-and-test method (GAT)
figure;
[freqGAT,frmsd] = plotGAT(pattern);

% plot a phase portrait
figure;
plotPhasePortrait(ioi);

% plot a recurrence plot
figure;
plotRecurrence(ioi);

% calculate kolmogorov-smirnov D and print it to the command window
ksD = getKolmogorovSmirnovD(ioi);
disp(['Kolmogorov-Smirnov D = ' num2str(ksD)]);

% calculate the nPVI and print it to the command window
nPVI = getNPVI(ioi);
disp(['normalized pairwise variability index (nPVI) = ' num2str(nPVI)]);

% gather output of all functions in a structure and return it
results = struct('ksD', ksD,                 'nPVI', nPVI, ...
                 'correlation', correlation, 'sigConv', sigConv, ...
                 'freqFFT', freqFFT,         'power', power, ...
                 'timeSeries', timeSeries,   'freqGAT', freqGAT, ...
                 'frmsd', frmsd);