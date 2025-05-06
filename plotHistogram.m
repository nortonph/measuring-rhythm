function plotHistogram(ioi)
% plotHistogram(ioi)
%
% plots a histogram of inter-onset intervals (IOIs)
%
% ioi:    1-dimensional array of IOIs in chronological order.

% NOTE: Matlab version R2014b introduced a new and improved histogram 
% function called histogram(), which is not available in GNU Octave and 
% earlier versions of Matlab. If you're using Matlab R2014b or newer, I
% recommend reading the help on histogram() (type "doc histogram" in the
% command window) and use that function instead of hist().

% get the maximum IOI and set bin width (adjust according to your needs)
maxIOI      = max(ioi(:));
binWidth    = 0.075;

% call hist() once to get the number of elements in each bin
numElements = hist(ioi,0:binWidth:maxIOI+binWidth);

% call hist() again (without an output variable) to plot the histogram
hist(ioi,0:binWidth:maxIOI+binWidth);

% get a handle to the bar objects from the plot & change the color
hBars   = findobj(gca, 'Type', 'patch');
set(hBars, 'FaceColor', [1,1,1], 'EdgeColor', 'k');

% adjust axis limits and remove tick marks
xlim([0,maxIOI+2*binWidth]);
ylim([0,max(numElements)+1]);
set(gca, 'TickLength', [0,0]);

% add a title and axis labels
title('IOI histogram', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('IOI [s]');
ylabel('n');