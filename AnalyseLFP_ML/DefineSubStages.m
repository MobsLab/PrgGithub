function [MATEP,nameEpochs]=DefineSubStages(op,noise,RemoveSI)

% [MATEP,nameEpochs]=DefineSubStages(op)
%
% input:
% op = epochs from FindNREMepochsML.m
% noise
% RemoveSI (optional) = 1 to include only long periods of immobility (default =0)

nameEpochs={'N1','N2','N3','REM','WAKE','SWS','SI','swaPF','swaOB','TOTSleep','WAKEnoise'};
% disp(' '); disp('...Defining epochs and Merge/drop intervals')

%% INPUTS
if ~exist('RemoveSI','var')
    RemoveSI=0;
end


t_mergeEp=3; % in second
t_dropEp=1;

if 0; %for info
    op{1}=StagesSup.OsciEpoch; %S34
    op{2}=StagesDeep.OsciEpoch; %S34;
    op{3}=BurstDeltaEpoch; %N3
    op{4}=StagesDeep.REM;
    op{5}=StagesDeep.WAKE;
    op{6}=StagesDeep.SWS;
    op{7}=SIEpoch; %short immobility
    op{8}=EpochSlowPF; %PFCx
    op{9}=EpochSlowOB; %OB
end

try
    if length(op)==8 % add short immobility in analysis
        op{9}=op{8};
        op{8}=op{7};
        sleep=or(op{4},op{6});
        sleep=CleanUpEpoch(sleep);
        sleep=mergeCloseIntervals(sleep,1);
        op{7}=sleep-dropShortIntervals(sleep,15*1E4);%short immobility
        op{7}=CleanUpEpoch(op{7});
        op{7}=mergeCloseIntervals(op{7},1);
    end
end

%% COMPUTE
MATEP={};
warning off
try
    % op = SupOsci DeepOsci N3 REM WAKE SWS PFswa OBswa
    % arrange epochs
    
    % ----------- sleep and SI ------------
    sleep=or(op{4},op{6});
    sleep=mergeCloseIntervals(sleep,3E4);
    if RemoveSI
        SI=sleep-dropShortIntervals(sleep,15E4);
        SI=mergeCloseIntervals(SI,10);
        SI=CleanUpEpoch(SI);
        sleep=dropShortIntervals(sleep,15E4);% 15s
    else
        sleep=dropShortIntervals(sleep,2E4);
        SI=intervalSet([],[]);
    end
    sleep=CleanUpEpoch(sleep);
    
    % ----------- REM ------------
    REM=and(op{4},sleep);
    REM=mergeCloseIntervals(REM,t_mergeEp*1E4);
    REM=dropShortIntervals(REM,t_dropEp*1E4);
    REM=CleanUpEpoch(REM);
    
    % ----------- SWS ------------
    SWS=op{6}-REM;
    SWS=and(SWS,sleep); 
    SWS=mergeCloseIntervals(SWS,t_mergeEp*1E4);
    SWS=dropShortIntervals(SWS,t_dropEp*1E4);
    SWS=CleanUpEpoch(SWS);
    
    % ----------- WAKE -----------
    WAKE=mergeCloseIntervals(op{5},t_mergeEp*1E4);
    WAKE=(WAKE-REM)-SWS;
    WAKE=dropShortIntervals(WAKE,t_dropEp*1E4);
    WAKE=CleanUpEpoch(WAKE);
    %
    WAKEnoise=or(WAKE,noise);
    WAKEnoise=mergeCloseIntervals(WAKEnoise,1E4);
    WAKEnoise=(WAKEnoise-REM)-SWS;
    WAKEnoise=dropShortIntervals(WAKEnoise,t_dropEp*1E4);
    WAKEnoise=CleanUpEpoch(WAKEnoise);
    
    if 0
        figure('Color',[1 1 1])
        subplot(2,3,1),hist(Stop(sleep,'s')-Start(sleep,'s'),0:15:2000);title('Sleep distrib'); xlabel('Duration (s)')
        subplot(2,3,2),hist(Stop(REM,'s')-Start(REM,'s'),0:15:300);title('REM distrib'); xlabel('Duration (s)')
        subplot(2,3,3),hist(Stop(SWS,'s')-Start(SWS,'s'),0:15:1000);title('SWS distrib'); xlabel('Duration (s)')
        subplot(2,3,4),hist(Stop(WAKE,'s')-Start(WAKE,'s'),0:15:1000);title('WAKE distrib'); xlabel('Duration (s)')
        subplot(2,3,5),hist(Stop(SI,'s')-Start(SI,'s'),0:0.5:16);title('SI distrib'); xlabel('Duration (s)')
    end
    
    % ----------- N3 ------------
    N3=and(op{3},SWS); 
    N3=mergeCloseIntervals(N3,t_mergeEp*1E4);
    N3=dropShortIntervals(N3,t_dropEp*1E4);
    N3=CleanUpEpoch(N3);
    %
    N23=and(or(op{1},op{2}),SWS); 
    N23=or(N23,N3);
    N23=mergeCloseIntervals(N23,t_mergeEp*1E4);
    N23=dropShortIntervals(N23,t_dropEp*1E4);
    N23=CleanUpEpoch(N23);
    
    % ----------- N1 ------------
    N1=SWS-N23;
    N1=mergeCloseIntervals(N1,t_mergeEp*1E4);
    N1=N1-N23;
    N1=dropShortIntervals(N1,t_dropEp*1E4);
    N1=CleanUpEpoch(N1);
    
    % ----------- N2 ------------
    %N2=(SWS-N1)-N3;
    N2=N23-N3;
    N2=mergeCloseIntervals(N2,t_mergeEp*1E4);
    N2=N2-N3-N1;
    N2=dropShortIntervals(N2,t_dropEp*1E4);
    N2=CleanUpEpoch(N2);
     
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % check overlapping epochs
    di=1;
    for n=[1:5,7]
        for m=[1:5,7]
            if m>n
                eval(['a=and(',nameEpochs{n},',',nameEpochs{m},');'])
                if sum(Stop(a,'s')-Start(a,'s'))>0
                    if di, disp('Attention ! overlapping epochs !'); di=0;end
                    disp([nameEpochs{n},' n ',nameEpochs{m},sprintf(' = %1.1fs',sum(Stop(a,'s')-Start(a,'s')))])
                end
            end
        end
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % replace lost epoch, continuous hypothesis
    minsta=min([Start(WAKE);Start(REM);Start(N1);Start(N2);Start(N3);Start(SI);Start(WAKEnoise)]);
    sto=[];
    for n=[1:6,11], 
        eval(['temp=Stop(',nameEpochs{n},');'])
        sto=[sto;[temp,n*ones(size(temp))]];
    end
    TOTepoch=intervalSet(minsta,max(sto(:,1)));
    lostEpoch=TOTepoch-WAKEnoise-REM-N1-N2-N3-SI;
    lostEpoch=CleanUpEpoch(lostEpoch);
    lostEpoch=mergeCloseIntervals(lostEpoch,1);
    
    sta=Start(lostEpoch);n=0;
    disp(sprintf(' ! %d lost epoch',length(sta)))
    for s=1:length(sta)
        try
            m=max(sto(sto(:,1)<=sta(s),1));% stop time before begining of lostEpoch
            n(s)=max(sto(sto(:,1)==m,2));% put in wakeNoise if ambiguous
            eval([nameEpochs{n(s)},'=or(',nameEpochs{n(s)},',subset(lostEpoch,',num2str(s),'));'])
        end
    end
    disp(['lostEpoch found for :', sprintf(' %s',nameEpochs{unique(n)})])
   
    for n=[1:6,11]
        eval([nameEpochs{n},'=CleanUpEpoch(',nameEpochs{n},');'])
        eval([nameEpochs{n},'=mergeCloseIntervals(',nameEpochs{n},',1);'])
    end
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    PFswa=mergeCloseIntervals(op{8},t_mergeEp*1E4);
    PFswa=dropShortIntervals(PFswa,t_dropEp*1E4);
    OBswa=mergeCloseIntervals(op{9},t_mergeEp*1E4);
    OBswa=dropShortIntervals(OBswa,t_dropEp*1E4);
    %
    TOTSleep=or(or(N1,N2),or(N3,REM));
    TOTSleep=CleanUpEpoch(TOTSleep);
    %
    MATEP={N1,N2,N3,REM,WAKE,SWS,SI,PFswa,OBswa,TOTSleep,WAKEnoise};
catch
    disp('Problem in DefineSubStages.m');
    I=intervalSet([],[]);
    MATEP={I,I,I,I,I,I,I,I,I,I,I};
end
warning on

