function plotRecurrence(ioi)
% plotRecurrence(ioi)
%
% creates a recurrence plot of inter-onset intervals (IOIs). Visualization
% of the 2-dimensional distance matrix, color-coded with two colors 
% (black and white). Both axes of the plot represent all iois in chrono- 
% logical order. For every set of two IOIs whose absolute difference is 
% below a particular threshold, the corresponding field in the plot is 
% colored black.
%
% ioi:    1-dimensional array of IOIs in chronological order.

% set the threshold according to the expected variability among elements
threshold = 0.3;

% set the colormap to black (0,0,0) and white (1,1,1)
colormap([1,1,1;0,0,0]);

% calculate the distance matrix
distanceMatrix = abs( bsxfun(@minus, ioi, transpose(ioi)) );

% convert to a binary distance matrix that is 1 where the difference
% between the IOIs is smaller than the threshold and 0 otherwise
binaryDistanceMatrix = distanceMatrix < threshold;

% plot an image of the binary distance matrix
imagesc(binaryDistanceMatrix);

% set the colormap to black (0,0,0) and white (1,1,1), so that values of 0
% in the matrix are colored white in the plot and values of 1 black
colormap([1,1,1;0,0,0]);

% set the direction of the y-axis to normal, so that the origin is in the 
% lower left hand corner
set(gca,'YDir','normal');

% add a title and axis labels
title('Recurrence plot', 'FontWeight', 'bold', 'FontSize', 12);       
xlabel('IOI');
ylabel('IOI');

% remove axis tick marks and scale axes to equal length
set(gca,'TickLength',[0,0]);
axis square;