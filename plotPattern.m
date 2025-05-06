function plotPattern(pattern)
% plotPattern(pattern)
%
% plots the events of a pattern as vertical lines on a timeline
%
% pattern:   1-dimensional array of timestamps of events

% loop through all events in the pattern
for e = 1:length(pattern)
    % draw a vertical line at x = timestamp of event
    line([pattern(e) pattern(e)], [0,1], 'Color', [0,0,0], ...
         'LineWidth',1);
end

% set the x-axis limits from a bit before 0 to a bit beyond the last event
tLastEvent = max(pattern);
xlim([-tLastEvent/50,tLastEvent+0.1*tLastEvent]);
ylim([0,1]);

% remove y-axis ticks and tick marks
set(gca,'YTick',[],'TickLength',[0,0],'XColor',[0,0,0],'YColor',[0,0,0]);
box off;

% add a title and x-axis label
title('Pattern','FontWeight','bold','FontSize',12);
xlabel('time [s]');