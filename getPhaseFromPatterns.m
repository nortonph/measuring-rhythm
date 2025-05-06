function [phaseRad] = getPhaseFromPatterns(pattern, patternIso)
% [phaseRad] = getPhaseFromPatterns(pattern, patternIso, ioiIso)
%
% calculates the phase of each event in pattern, relative to a second,
% isochronous pattern and returns it in radians.
%
% pattern:      any 1-dimensional array of timestamps of events
% patternIso:   1-dimensional array of timestamps of isochronous (!) events
%
% returns phase of events in radians

% get the inter-onset interval (ioi) of the isochronous pattern
ioiIso = mean(patternIso(2:end)-patternIso(1:end-1));

% for each event find nearest isochronous event and get phase (deviation)
for e = 1:length(pattern)
    [~,nearest]     = min(abs(patternIso - pattern(e)));
    phase(e)        = patternIso(nearest) - pattern(e);
end

% convert phase to degrees and radians
phaseDeg = phase / ioiIso * 360;
phaseRad = phaseDeg * pi / 180;