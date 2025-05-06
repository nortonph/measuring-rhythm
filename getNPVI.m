function [nPVI] = getNPVI(ioi)
% [nPVI] = getNPVI(ioi)
%
% calculates the normalized pairwise variability index (nPVI) as described
% in Grabe & Low (2002)* from a list of iois.
%
% ioi:  1-dimensional array of inter onset intervals (or any durations)
%
% returns the nPVI
%
% * Grabe, E., & Low, E. L. (2002). Durational variability in speech and 
% the rhythm class hypothesis. Papers in laboratory phonology, 7(515-546).

nPVI = 100 / (length(ioi)-1) * ...
       sum(abs(diff(ioi) ./ ((ioi(2:end) + ioi(1:end-1)) / 2)));
end