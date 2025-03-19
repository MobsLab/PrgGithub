function [MATEP,nameEp]=DefineSubStagesNew(opNew,noise,RemoveSI,BurstIs3,newBurstThresh)

% [MATEP,nameEpochs]=DefineSubStagesNew(opNew,RemoveSI,BurstIs3)
%
% input:
% opNew = epochs from FindNREMepochsML.m
% noise
% RemoveSI (optional) = 1 to include only long periods of immobility (default =0)
% BurstIs3 = consider Burst of delta only when 3 delta in a row (see FindNREMepochsML/FindDeltaBurst2)
% newBurstThresh = 1 for 1s interBurst threshold, (0 for default =0.7s)

nameEp={'N1','N2','N3','REM','WAKE','SI','SWS','swaPF','swaOB','TOTSleep','WAKEnoise'};

% disp(' '); disp('...Defining epochs and Merge/drop intervals')

%% INPUTS
if ~exist('RemoveSI','var')
    RemoveSI=0;
end
if ~exist('BurstIs3','var')
    BurstIs3=1;
end
if ~exist('newBurstThresh','var')
    newBurstThresh=0;
end

t_mergeEp=3; % in second
t_dropEp=1;

if 0; %for info
    opNew{1}=StagesSup.OsciEpoch; %S34
    opNew{2}=StagesDeep.OsciEpoch; %S34;
    opNew{3}=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,0); %N3 new threshold by fitin ISI delta
    opNew{4}=StagesDeep.REM;
    opNew{5}=StagesDeep.WAKE;
    opNew{6}=StagesDeep.SWS;
    opNew{7}=SIEpoch; %short immobility
    opNew{8}=EpochSlowPF; %PFCx
    opNew{9}=EpochSlowOB; %OB
    opNew{10}=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,1);
    opNew{11}=FindDeltaBurst2(Restrict(Dpfc,Epoch),1,0);
    opNew{12}=FindDeltaBurst2(Restrict(Dpfc,Epoch),1,1);
end

try
    if length(op)==8 % add short immobility in analysis
        opNew{9}=opNew{8};
        opNew{8}=opNew{7};
        sleep=or(opNew{4},opNew{6});
        sleep=CleanUpEpoch(sleep);
        sleep=mergeCloseIntervals(sleep,1);
        opNew{7}=sleep-dropShortIntervals(sleep,15*1E4);%short immobility
        opNew{7}=CleanUpEpoch(opNew{7});
        opNew{7}=mergeCloseIntervals(opNew{7},1);
    end
end

%% COMPUTE
MATEP={};
warning off
try

    % ----------- sleep and SI ------------
    sleep=or(opNew{4},opNew{6});
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
    REM=and(opNew{4},sleep);
    REM=mergeCloseIntervals(REM,t_mergeEp*1E4);
    REM=dropShortIntervals(REM,t_dropEp*1E4);
    REM=CleanUpEpoch(REM);
    
    % ----------- SWS ------------
    SWS=opNew{6}-REM;
    SWS=and(SWS,sleep); 
    SWS=mergeCloseIntervals(SWS,t_mergeEp*1E4);
    SWS=dropShortIntervals(SWS,t_dropEp*1E4);
    SWS=CleanUpEpoch(SWS);
    
    % ----------- WAKE -----------
    WAKE=mergeCloseIntervals(opNew{5},t_mergeEp*1E4);
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
    if BurstIs3
        disp('following option is ON : Burst is defined as at least 3 delta')
        N3=and(opNew{3},SWS); 
        if newBurstThresh, N3=and(opNew{11},SWS);end
    else
        disp('following option is OFF : Burst is defined as at least 3 delta')
        N3=and(opNew{10},SWS);
        if newBurstThresh, N3=and(opNew{12},SWS);end
    end
    N3=mergeCloseIntervals(N3,t_mergeEp*1E4);
    N3=dropShortIntervals(N3,t_dropEp*1E4);
    N3=CleanUpEpoch(N3);
    
    %
    N23=and(or(opNew{1},opNew{2}),SWS); 
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
    % check overlapping epochs N1 N2 N3
    %nameEp={'N1','N2','N3','REM','WAKE','SI','SWS','swaPF','swaOB','TOTSleep','WAKEnoise'};
    di=1;
    for n=1:6
        for m=1:6
            if m>n
                eval(['a=and(',nameEp{n},',',nameEp{m},');'])
                if sum(Stop(a,'s')-Start(a,'s'))>0
                    if di, disp('Attention ! overlapping epochs !'); di=0;end
                    disp([nameEp{n},' n ',nameEp{m},sprintf(' = %1.1fs',sum(Stop(a,'s')-Start(a,'s')))])
                end
            end
        end
    end
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % replace lost epoch, continuous hypothesis
    WS=WAKE; SIS=SI; WnoiseS=WAKEnoise;
    
    % ------------ nameEp -----------
    nam1={'N1','N2','N3','REM','WAKE','SI','WAKEnoise'};
    minsta=min([Start(WAKE);Start(REM);Start(N1);Start(N2);Start(N3);Start(SI);Start(WAKEnoise)]);
    sto=[];
    for n=1:length(nam1) 
        eval(['temp=Stop(',nam1{n},');'])
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
            eval([nam1{n(s)},'=or(',nam1{n(s)},',subset(lostEpoch,',num2str(s),'));'])
        end
    end
    disp(['lostEpoch found for :', sprintf(' %s',nam1{unique(n)})])
   
    for n=1:length(nam1)
        eval([nam1{n},'=CleanUpEpoch(',nam1{n},');'])
        eval([nam1{n},'=mergeCloseIntervals(',nam1{n},',1);'])
    end
    
    
    % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    PFswa=mergeCloseIntervals(opNew{8},t_mergeEp*1E4);
    PFswa=dropShortIntervals(PFswa,t_dropEp*1E4);
    OBswa=mergeCloseIntervals(opNew{9},t_mergeEp*1E4);
    OBswa=dropShortIntervals(OBswa,t_dropEp*1E4);
    %
    TOTSleep=or(or(N1,N2),or(N3,REM));
    TOTSleep=CleanUpEpoch(TOTSleep);
    MATEP={N1,N2,N3,REM,WAKE,SI,SWS,PFswa,OBswa,TOTSleep,WAKEnoise};
    
catch
    disp('Problem in DefineSubStages.m');
end
warning on

