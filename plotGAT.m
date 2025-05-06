function [freq,frmsd] = plotGAT(pattern)
% [freq,frmsd] = plotGAT(pattern,ioi)
%
% applies the pulse generate-and-test method as described in Norton &
% Scharff (2016)* to an event pattern.
%
% pattern:  1-dimensional array of timestamps of events
%
% returns two arrays of equal length, one containing the frequency values
% between minFreq and maxFreq in stepFreq steps, the other the
% frequency-normalized root-mean-squared deviation of all events in the
% pattern to the nearest event in the pulse of the corresponding frequency.
%
% * Norton, P., & Scharff, C. (2016). 'Bird Song Metronomics': Isochronous 
% Organization of Zebra Finch Song Rhythm. Frontiers in Neuroscience,10,309

% set minimum and maximum frequency to be calculated (in Hz)
minFreq = 0.2;
maxFreq = 5;

% resolution parameters. lower values increase precision at the cost of
% higher computation time. stepOffset in seconds, stepFreq in Hz.
stepOffset  = 0.001;
stepFreq    = 0.01;

% calculate the root-mean squared deviation (rmsd) for each pulse frequency
% this calls a function written in C (pulse_gat.c, compiled as
% pulse_gat.mexw32, pulse_gat.mexw64 or pulse_gat.mex)
[freq,rmsd] = pulse_gat(pattern,stepFreq,stepOffset,minFreq,maxFreq);

% get the frmsd (i.e. normalize the rmsd by frequency)
frmsd = freq .* rmsd;

% plot frmsd as a function of frequency and adjust axis limits
plot(freq, frmsd, 'k');
xlim([-maxFreq/50,maxFreq]);
%ylim([0,0.3]);

% reverse y-axis
set(gca,'YDir','reverse');

% add a title and axis labels
title('Pulse GAT', 'FontWeight', 'bold', 'FontSize', 12); 
xlabel('frequency [Hz]');
ylabel('frmsd');