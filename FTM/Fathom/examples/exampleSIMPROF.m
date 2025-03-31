% Example of Similarity Profile Analysis (SIMPROF)
% 
% by David L. Jones, Aug-2013

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               EXE:                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% The file 'exe.mat' consists of abundance data for 140 species of nematodes
% from 19 sites within the Exe estuary in the UK from Warwick (1971) and has the
% following variables:
% 
% bio.dat  = average counts of 140 spp of nematodes from 19 sites
% bio.txt  = cell array of corresponding column (species) labels
% env.dat  = values of 6 environmental sediment variables from the same 19 sites
% env.txt  = cell array of corresponding column labels:
%    'MPD' : median particle  diameter
%    'Wt'  : depth of the water table
%    'H2S' : depth of hydrogen sulfide layer
%    'Ht'  : height up the shore
%    '%Org': percentage of organics
%    'Sal' : salinity
% env.site = cell array of site labels
% 
% Warwick, R. M. 1971. Nematode associations in the Exe estuary. J. Mar. Biol.
% Assoc. U.K. 51: 439-454.

% Use similarity profile analysis (SIMPROF) to test the null hypothesis that
% there is no multivariate structure in the abundance and distribution data
% represented by the Exe data set.

% Load data:
load exe.mat;

% Fourth-root transforme the abundance data:
bio.dat4 = f_normal(bio.dat,'4');

% Run SIMPROF on a using Bray-Curtis metric:
simprof = f_simprof(bio.dat4,'bc',1000,1,1);
% Calculating mean similarity profile from 999 permutations...
% Calculating significance levels from 999 permutations...
% 
% ==================================================
%       SIMPROF - Similarity Profile Analysis:
% --------------------------------------------------
% pi Stat = 16.9764  p =  0.00100 
% No. of permutations = 1000 
% ==================================================
% 
% -> the pi statistic is highly significant, so we reject the null hypothesis of
%    no significant multivariate structure in the data (at alpha = 0.05). Note
%    the observed similarity profile depicted in the corresponding plot departs
%    substantially from the mean profile generated through random permutation.
%    The observed profile has more small and large similarity values than that
%    expected by chance, suggesting there is true strcture in these data.

% Repeat, but only assess sites 1-4:
f_simprof(bio.dat4(1:4,:),'bc',1000,1,1);


S = sort(f_unwrap(f_dis2sim(f_dis(bio.dat4(1:4,:),'bc',1)),0),1,'descend')