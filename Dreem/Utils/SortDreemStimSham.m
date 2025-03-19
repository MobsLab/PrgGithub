% SortDreemStimSham
% 06.04.2018 KJ
%
% function [stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations, varargin)
%
%%INPUT
%   stimulations            -tsd of stimulations time and intensities
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact GetRecordDreem
%
%


function [stim_tmp, sham_tmp, int_stim, stim_train, sham_train, StimEpoch, ShamEpoch] = SortDreemStimSham(stimulations, varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'interstim_thresh'
            interstim_thresh = varargin{i+1};
            if interstim_thresh<0
                error('Incorrect value for property ''interstim_thresh''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end


%check inputs
if ~exist('interstim_thresh','var')
    interstim_thresh = 1600;
end

interstim_thresh = interstim_thresh*10;


%% stim
stim_tmp = Range(stimulations);
int_stim = Data(stimulations);

sham_tmp = stim_tmp(Data(stimulations)==0); %sham
stim_tmp = stim_tmp(Data(stimulations)>0); %true tones, not sham
int_stim = int_stim(Data(stimulations)>0);


%% Find trains epoch
StimEpoch = intervalSet(stim_tmp,stim_tmp+1);
StimEpoch = mergeCloseIntervals(StimEpoch, interstim_thresh);

ShamEpoch = intervalSet(sham_tmp,sham_tmp+1);
ShamEpoch = mergeCloseIntervals(ShamEpoch, interstim_thresh);


%% trains timestamps

%stim
stim_train = [];
for i=1:length(Start(StimEpoch))
    stims = Range(Restrict(ts(stim_tmp), subset(StimEpoch,i)));
    stim_train(end+1,1:length(stims)) = stims;
end
stim_train(stim_train==0) = nan;

%sham
sham_train = [];
for i=1:length(Start(ShamEpoch))
    sham = Range(Restrict(ts(sham_tmp), subset(ShamEpoch,i)));
    sham_train(end+1,1:length(sham)) = sham;
end
sham_train(sham_train==0) = nan;


end












