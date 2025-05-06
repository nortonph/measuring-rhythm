function [phaseRad] = plotRose(pattern, isochronousPattern)
% [phaseRad] = plotRose(pattern, isochronousPattern)
%
% creates a rose plot (circular histogram) of phases of a pattern relative
% to a pre-determined strictly isochronous pattern
%
% pattern:      any 1-dimensional array of timestamps of events
% patternIso:   1-dimensional array of timestamps of isochronous (!) events
%
% returns phase of events in radians

% NOTE: Matlab version R2016b introduced a new and improved rose plot 
% function called polarhistogram(), which is not available in GNU Octave &
% earlier versions of Matlab. If you're using Matlab R2016b or newer, I
% recommend reading the help on polarhistogram() (type "doc polarhistogram"
% in the command window) and use that function. Due to the limited
% functionality of the functions rose() and polar() used here, this code is
% quite messy and unintuitive.

% get the phase of each event in the pattern, relative to the isochronous 
% pattern (in radians)
phaseRad    = getPhaseFromPatterns(pattern,isochronousPattern);

% create an array of 20 bin centers for the plot and convert to radians
binsDeg     = -171:18:171;
binsRad     = binsDeg * pi / 180;

% get polar coordinates for the histogram plot
[tout,rout] = rose(phaseRad,binsRad);

% plot fake data to set radial limits
rMax        = ceil(max(rout)/10)*10;
hFake       = polar(tout,rMax*ones(size(tout)));
hold on;

% plot actual data and hide fake data
polar(tout,rout,'k');
set(hFake, 'Visible', 'Off');

% plot mean vector (this requires the package CircStats)
if (exist('circ_r','file') && exist('circ_mean','file'))
    zm = circ_r(phaseRad') * rMax * exp(1i * circ_mean(phaseRad'));
    plot([0 real(zm)], [0, imag(zm)], 'k', 'LineWidth', 2);
else
    disp('CircStat not found in search path. Mean vector not plotted.');
end

% rotate the plot so that 0° is on the top of the plot
set(gca,'View',[-90 90],'YDir','reverse');

% replace axis labels 0 to 360° with -180 to +180°
hLabels = findall(gca,'type','text');
labOld  = {'30','60','90','120','150','180','210','240','270','300','330','360'};
labNew  = {'    30','    60','    90','     120','     150','±180', ...
           '-150     ','-120     ','-90    ','-60    ','-30    ','0'};
for l = 1:length(labOld)
    idx = ismember(get(hLabels,'string'),labOld{l});
    set(hLabels(idx),'string',labNew{l});
end

% reduce font size of axis labels
hT = findall(gca,'Type','text');
for t = 1:length(hT),
    set(hT(t),'FontSize',7)
end
hold off;

% add a title
title(sprintf('Rose plot\n'),'FontWeight','bold','FontSize',12);