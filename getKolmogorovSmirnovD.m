function [d] = getKolmogorovSmirnovD(ioi)
% [d] = getKolmogorovSmirnovD(ioi)
%
% calculates the kolmogorov-smirnov D from a list of inter-onset intervals
%
% ioi:    1-dimensional array of IOIs in chronological order.

% determine if this is run on Matlab or Octave
if (exist ('OCTAVE_VERSION', 'builtin'))
    isOctave = 1;
else
    isOctave = 0;
end

if (isOctave)
    % calculate komogorov-smirnov D
    [~,d] = kolmogorov_smirnov_test(ioi,'norm',mean(ioi),std(ioi));
else
    % create a normal cumulative distribution function (CDF) based on ioi
    ioiCDF = normcdf(ioi,mean(ioi),std(ioi));
    % calculate komogorov-smirnov D
    [~,~,d,~] = kstest(ioi,[ioi',ioiCDF']);
end