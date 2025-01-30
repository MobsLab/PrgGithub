%FindSleepStageML.m

function [SWS,REM,WAKE,OsciEpoch,MovEpoch]=FindSleepStageML(nameChannel)
% e.g.
% [SWS,REM,WAKE,OsciEpoch,SleepStages]=FindSleepStageML('PFCx_deep',1);
% used in FindNREMepochsML.m

% inputs:
% nameChannel = name in channeltoAnalyse fo spindles/oscillation analy
% plo = 1 to display stages at the end of the function
%
% outputs:
% SleepStages 0 1 2 3: W REM N1 N23 

%% INITIATION

if ~exist('plo','var')
    plo=0;
end

%% LOAD STATEEPOCH IN CURRENT DIRECTORY

disp('... loading StateEpochs')
if exist('StateEpoch.mat','file')
    load StateEpoch.mat SWSEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch REMEpoch
end
try
    SWS=SWSEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
catch
    if exist('StateEpochSB.mat','file')
        load StateEpochSB.mat SWSEpoch NoiseEpoch GndNoiseEpoch REMEpoch
    end
    try
        SWS=SWSEpoch-NoiseEpoch-GndNoiseEpoch;
        disp('note: Using SleepScoringSB')
        MovEpoch=intervalSet([],[]);
    catch
        disp('PROBLEM: no sleepscoring');
    end
end


% clean REM from noise
REM=REMEpoch-GndNoiseEpoch;
REM=REM-NoiseEpoch;
try
    REM=REM-WeirdNoiseEpoch;
end

%% FIND OSCILLATIONS EPOCHS 

% FindOsciEpochs.m
newname=nameChannel;
newname(strfind(nameChannel,'_'))=[];
try 
    eval(['load(''SleepStagesML',newname,'.mat'',''OsciEpoch'',''WholeEpoch'')'])
    OsciEpoch;
catch
    [OsciEpoch,WholeEpoch,SWAEpoch,BurstEpoch,spindles,sdTH,ISI_th]=FindOsciEpochs(nameChannel,SWS);
    eval(['save(''SleepStagesML',newname,'.mat'',''OsciEpoch'',''WholeEpoch'',',...
        '''SWAEpoch'',''BurstEpoch'',''spindles'',''sdTH'',''ISI_th'')']);
end

%% OUTPUT EPOCHS DEFINITION

SleepEpoch=or(SWS,REM);
try
    WAKE=WholeEpoch-SleepEpoch;
catch
    eval(['tp=load(''SleepStagesML',newname,'.mat'',''WAKE'',''SWS'',''REM'');'])
    WholeEpoch=and(and(tp.WAKE,tp.SWS),tp.REM);
    WholeEpoch=mergeCloseIntervals(WholeEpoch,1E4);
    WAKE=WholeEpoch-SleepEpoch;
end


WAKE=WAKE-GndNoiseEpoch;
WAKE=WAKE-NoiseEpoch;
try
    WAKE=WAKE-WeirdNoiseEpoch;
end