function [pattern,iois] = generatePattern(n,nRep,type,stdev,seed)
% [pattern,iois] = generatePattern(n,ioiDur,nRep,type,stdev)
%
% generates random, isochronous, or one of three types of non-isochronous 
% rhythmic patterns.
%
% n:        number of events (must be divisible by nRep wtihout remainder)
% nRep:     number of repetitions of the rhythmic pattern
% type:     either 'random', 'isochronous', 'rhythmic', 'stress' or 'mora'
% stdev:    standard deviation for gaussean noise
% seed:     seed for the random number generator. supplying an integer
%           number greater than one allows to reproduce a specific pattern
%           (e.g. setting the seed to 2 will always produce the same
%           pattern if all other arguments are the same)
%
% returns a 1-dimensional array of timestamps of events (pattern) and a
% 1-dimensional array of the corresponding inter-onset intervals (ioi)

% mean IOI duration of the random and isochronous patterns and timestamp of
% the first event in each pattern. 
ioiDur          = 2;
startOfPattern  = ioiDur;

% seed the random number generator
if (seed)
    rand('twister',seed);
    randn('state', seed);
end

switch type
    case 'random'
        % construct a pattern of uniformly distributed random iois
        pattern = sort ((n * ioiDur) .* rand(1,n));
        iois    = [pattern(2:end) n*ioiDur] - pattern(1:end);
        pattern = pattern - pattern(1) + startOfPattern;
    case 'isochronous'
        % construct isochronous pattern
        iois    = ones(1,n) .* ioiDur;
        % create pattern with timepoints of events, starting at ioiDur
        ioiSums = cumsum(iois);
        pattern = [startOfPattern ioiSums(1:end-1)+startOfPattern];
        % introduce gaussean noise
        pattern(2:end)  = pattern(2:end) + stdev * randn(1,n-1);
        % get iois from noisy pattern
        iois(1:end-1)   = pattern(2:end) - pattern(1:end-1);
        iois(end)       = iois(end) + stdev * randn(1,1);
    case 'rhythmic'
        % construct non-isochronous, but rhythmic pattern, made up of iois
        % 1, 2 and 3. There will be floor(n/3) 1s and 3s and the rest 2s.
        % pattern will be repeated nRep times.
        if (mod(n,nRep))
            disp(['Error: number of events (' n ') must be divisible' ...
                  'by number of repetitions of the rhythmic pattern (' ...
                  nRep ') without remainder.']);
            return;
        end
        % number of iois in each repetition of the pattern
        nIOI    = n / nRep;
        n_3     = floor(nIOI/3);
        % create IOIs for one repetition of the pattern
        ioisPat = [ones(1,n_3), ones(1,n_3+mod(nIOI,3)).*2, ones(1,n_3).*3];
        % shuffle the values in the pattern
        ioisPat = ioisPat(randperm(length(ioisPat)));
        % repeat the pattern
        iois    = repmat(ioisPat,1,nRep);
        ioiSums = cumsum(iois);
        pattern = [startOfPattern ioiSums(1:end-1)+startOfPattern];
        % introduce gaussean noise
        pattern(2:end)  = pattern(2:end) + stdev * randn(1,n-1);
        % get iois from noisy pattern
        iois(1:end-1)   = pattern(2:end) - pattern(1:end-1);
        iois(end)       = iois(end) + stdev * randn(1,1);
    case 'stress'
        % construct pattern based on stress-timed languages. consists of
        % nRep clusters of IOIs that have the same total duration, but
        % different sets of within-cluster IOIs.
        if (mod(n,nRep))
            disp(['Error: number of events (' n ') must be divisible' ...
                  'by number of repetitions of the rhythmic pattern (' ...
                  nRep ') without remainder.']);
            return;
        end
        % generate list of ioi types (0.25,0.5,0.75,1,...)
        ioiTypes    = unique((1:15)/4); 
        nTypes      = length(ioiTypes);
        % number of iois in each cluster
        nIOI    = n / nRep;
        % loop over patterns
        iois    = [];
        c = 0;
        while (c < nRep)
            % create nIOI-1 semi-random iois
            ioisPat = [];
            for i = 1:nIOI-1
                ioisPat     = [ioisPat ioiTypes(randi(nTypes,1))];
            end
            % add a final ioi so that cluster duration = nIOI * ioiDur
            finalIOI    = nIOI*2 - sum(ioisPat);
            % if there is not enough room for a final ioi, repeat (q'n'd..)
            if (finalIOI >= 0.25)
                ioisPat     = [ioisPat finalIOI];
                iois        = [iois ioisPat];
                c           = c + 1;
            end
        end
        ioiSums = cumsum(iois);
        pattern = [startOfPattern ioiSums(1:end-1)+startOfPattern];
        % introduce gaussean noise
        pattern(2:end)  = pattern(2:end) + stdev * randn(1,n-1);
        % get iois from noisy pattern
        iois(1:end-1)   = pattern(2:end) - pattern(1:end-1);
        iois(end)       = iois(end) + stdev * randn(1,1);
    case 'mora'
        % construct pattern based on mora-timed languages. consists of
        % clusters that contain either one or two iois and have the same
        % total duration (3s).
        ioiTypes    = [0.25 0.5 0.75 1 1.25 1.5 1.75];
        nTypes      = length(ioiTypes);
        % loop over iois and create clusters of one or two iois
        iois        = [];
        i = 0;
        while (i < n)
            if (randi(2) == 1 || i == n-1)
                iois    = [iois 3];
                i       = i + 1;
            else
                ioiOne  = ioiTypes(randi(nTypes,1));
                ioiTwo  = 3 - ioiOne;
                iois    = [iois ioiOne ioiTwo];
                i       = i + 2;
            end
        end
        ioiSums = cumsum(iois);
        pattern = [startOfPattern ioiSums(1:end-1)+startOfPattern];
        % introduce gaussean noise
        pattern(2:end)  = pattern(2:end) + stdev * randn(1,n-1);
        % get iois from noisy pattern
        iois(1:end-1)   = pattern(2:end) - pattern(1:end-1);
        iois(end)       = iois(end) + stdev * randn(1,1);
end
