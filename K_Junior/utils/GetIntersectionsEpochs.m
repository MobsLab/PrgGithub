%%GetIntersectionsEpochs
% 09.09.2019 KJ
%
% get intersection between two intervalSet
%
% function [EpochInter1, EpochInter2, Istat, index1, index2] = GetIntersectionsEpochs(Epoch1, Epoch2)
%
% INPUT:
% - Epoch1              intervalSet
% - Epoch1              intervalSet
%
%
% OUTPUT:
% - EpochInter1     = intervalSet
% - EpochInter2     = intervalSet
% - Istat           = stat 
% - index1          = indices of the Epoch1 to find EpochInter1
% - index2          = indices of the Epoch2 to find EpochInter2
% 
%   see 
%       
%


function [EpochInter1, EpochInter2, Istat, index1, index2] = GetIntersectionsEpochs(Epoch1, Epoch2)


%% CHECK INPUTS

if nargin < 2
  error('Incorrect number of parameters.');
end


%% intersection

interEpoch = and(Epoch1,Epoch2);
center_interEpoch = (Start(interEpoch) + End(interEpoch))/2;

%Epoch1
[~,intervals1,~] = InIntervals(center_interEpoch, [Start(Epoch1) End(Epoch1)]);
intervals1(intervals1==0)=[];
index1 = unique(intervals1);
EpochInter1 = subset(Epoch1, index1);

%Epoch2
[~,intervals2,~] = InIntervals(center_interEpoch, [Start(Epoch2) End(Epoch2)]);
intervals2(intervals2==0)=[];
index2 = unique(intervals2);
EpochInter2 = subset(Epoch2, index2);


%% stat
nb_epoch1 = length(Start(Epoch1));
nb_epoch2 = length(Start(Epoch2));
nb_inter  = length(index1);

Istat.nb_inter  = nb_inter;
Istat.nb_alone1 = nb_epoch1-nb_inter;
Istat.nb_alone2 = nb_epoch2-nb_inter;

Istat.precision = nb_inter / nb_epoch1;
Istat.recall    = nb_inter / nb_epoch2;
Istat.fscore    = 2*Istat.recall*Istat.precision / (Istat.recall+Istat.precision);


end


