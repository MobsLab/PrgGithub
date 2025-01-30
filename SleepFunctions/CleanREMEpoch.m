function [REMEpochC, WakeC, idbad]=CleanREMEpoch(SleepStages,REMEpoch,Wake)

% [REMEpochC,WakeC,idbad]=CleanREMEpoch(SleepStages)
% 
% disp('******************************')
% disp(['Number of REM epochs: 
% disp('******************************')
% disp(['Number of Bad REM epochs
% disp('******************************')
% disp(['Total duration of Bad REM epochs
% disp('******************************')
% disp(['Mean duration of Bad REM epochs
% disp('******************************')
% disp(['Number of merged REM epochs
% disp('******************************')
%

try
    REMEpoch;
    Wake;
catch
    try
    load StateEpochSBKB REMEpoch Wake
catch
    try
    load StateEpochSB Wake SWSEpoch REMEpoch
catch
    load SleepScoring_OBGamma Wake SWSEpoch REMEpoch
end
    end
end


% length(Start(REMEpoch))

for i=1:length(Start(REMEpoch))
    testEpoch1=subset(REMEpoch,i);
    testEpoch2=intervalSet(Start(testEpoch1)-1E4,Start(testEpoch1)-2);
    SleepStageTemp1=Data(Restrict(SleepStages,testEpoch1));
    SleepStageTemp2=Data(Restrict(SleepStages,testEpoch2));
    try
        if SleepStageTemp2(end-1)==3
            idbad(i)=1;
        else
            idbad(i)=0;
        end 
    catch
        idbad(i)=1;
    end
end

REMEpochC=subset(REMEpoch,find(idbad==0));
WakeC=or(Wake,subset(REMEpoch,find(idbad==1)));
% 
% bef=length(Start(REMEpochC))
% REMEpochC=mergeCloseIntervals(REMEpochC,5E4);
% aft=length(Start(REMEpochC))
try
    Dur(1)=sum(End(subset(REMEpoch,find(idbad==1)),'s')-Start(subset(REMEpoch,find(idbad==1)),'s'));
    Dur(2)=nanmean(End(subset(REMEpoch,find(idbad==1)),'s')-Start(subset(REMEpoch,find(idbad==1)),'s'));
end

disp('******************************')
disp(['Number of REM epochs: ',num2str(length(Start(REMEpoch)))])
disp('******************************')
disp(['Number of Bad REM epochs: ',num2str(length(find(idbad==1)))])
disp('******************************')
disp(['Total duration of Bad REM epochs: ',num2str(floor(Dur(1))),' sec'])
disp('******************************')
try
disp(['Mean duration of Bad REM epochs: ',num2str(floor(Dur(2))),' sec'])
disp('******************************')
end
try
disp(['Number of merged REM epochs: ',num2str(bef-aft)])
disp('******************************')
end