% DreemIDfunc_Sleepstage
% 27.03.2018 KJ
%
%%INPUT
% 
% 
%%OUTPUT
% 
%
% SEE
%   DreemIDStimImpact
%
%


function [SleepStages, Epochs, time_stages, percentvalues_NREM, meanDuration_sleepstages] = DreemIDfunc_Sleepstage(varargin)


% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'hypnogram'
            StageEpochs = varargin{i+1};
        case 'filename'
            filename = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end



%check inputs
if ~exist('StageEpochs','var') && ~exist('filename','var')
    error('An input is required.')
elseif ~exist('StageEpochs','var')
    [~, ~, ~, StageEpochs, ~] = GetRecordDreem(filename);
end


%% load
N1=StageEpochs{1}; 
N2=StageEpochs{2}; 
N3=StageEpochs{3}; 
REM=StageEpochs{4}; 
WAKE=StageEpochs{5}; 


%% Sleep Stages
Rec=or(or(or(N1,or(N2,N3)),REM),WAKE);
Epochs={N1,N2,N3,REM,WAKE};
num_substage=[2 1.5 1 3 4]; %ordinate in graph
indtime=min(Start(Rec)):1E4:max(Stop(Rec));
timeTsd=tsd(indtime,zeros(length(indtime),1));
SleepStages=zeros(1,length(Range(timeTsd)))+4.5;
rg=Range(timeTsd);
sample_size = median(diff(rg))/10; %in ms

time_stages = zeros(1,5);
meanDuration_sleepstages = zeros(1,5);
for ep=1:length(Epochs)
    idx=find(ismember(rg,Range(Restrict(timeTsd,Epochs{ep})))==1);
    SleepStages(idx)=num_substage(ep);
    time_stages(ep) = length(idx) * sample_size;
    meanDuration_sleepstages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
end

SleepStages=tsd(rg,SleepStages');

percentvalues_NREM = zeros(1,3);
for ep=1:3
    percentvalues_NREM(ep) = time_stages(ep)/sum(time_stages(1:3));
end
percentvalues_NREM = round(percentvalues_NREM*100,2);





end












