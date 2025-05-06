function plotPhasePortrait(ioi)
% plotPhasePortrait(ioi)
%
% creates a phase portrait of inter-onset intervals (IOIs). Pairs of
% adjacent IOIs serve as x- and y-coordinates respectively and lines
% connect neighbouring pairs (e.g. x1=ioi1, y1=ioi2, x2=ioi2, y2=ioi3).
%
% ioi:    1-dimensional array of IOIs in chronological order.

% loop through the array of IOIs
for k = 1:length(ioi)-2
    % draw a line for each pair of adjacent IOIs
    line([ioi(k) ioi(k+1)], [ioi(k+1) ioi(k+2)], 'Color', [0,0,0])
end

% add a title and axis labels
title('Phase space plot', 'FontWeight', 'bold', 'FontSize', 12);
xlabel('IOI (n)');
ylabel('IOI (n+1)');

% adjust axis scale for both axes
axLim = max(ioi) + 0.2*max(ioi);
xlim([-axLim/25,axLim]);
ylim([-axLim/25,axLim]);
axis square;