%NREMstages_scripts.m

%% 0. Directories
edit NREMstages_path.m
edit PathForExperimentsML.m
edit PathForExperimentsMLnew.m % dont spikes

%% 1. General codes
edit NREMstages_pool.m
edit GetEvolutionAcrossZT.m
edit AnalyseNREM_CheckDelta.m
edit FiguresArticleNREM.m % occurence rhythms ...
edit FigureTheseML.m
edit RunFuctions_ML.m
edit RunSubstages.m

% specific codes for scoring NREM sleep stages
edit AnalyseNREMsubstagesML.m %doNew
edit AnalyseNREMsubstagesNewML.m % irrelevant
% including
edit FindNREMepochsML.m
edit FindSleepStageML.m
edit FindOsciEpochs.m

%% 2. SD and OR experiments
edit AnalyseNREMsubstages_ORspikes
edit AnalyseNREMsubstages_OR
edit AnalyseNREMsubstages_DisplayORandSD;
edit AnalyseNREMsubstages_SD24h
edit AnalyseNREMsubstages_SD6h
edit AnalyseNREMsubstages_SD
edit AnalyseNREMsubstagesBM
edit AnalyseNREMsubstages_SWA;

%% 3. Spikes and Rythms
edit AnalyseNREMsubstages_SpikesML %doNew avec timeZT 9 et 8h
edit AnalyseNREMsubstages_SpikesTrioEvol
edit AnalyseNREMsubstages_Spikescheck
edit AnalyseNREMsubstages_SpikesAndRhythms
edit AnalyseNREMsubstages_SpikesInterPyrML
edit AnalyseNREMsubstages_BilanInterPyrML
edit AnalyseNREMsubstages_Rhythms
edit AnalyseNREMsubstages_RipplesPFCneuron
edit AnalyseNREMsubstages_RipplesPFCneuron_check % oct 2018
edit AnalyseNREMsubstages_RythmsEvol

%% 4. Specific questions
edit AnalyseNREMsubstages_N2andREM;
edit NREMstages_N2CorREM;
edit NREMstages_N2CrossCorREM;
edit AnalyseNREMsubstages_N1evalML
edit AnalyseNREMsubstages_N1evalEMGonlyML.m
edit AnalyseNREMsubstages_N1versusImmob.m
edit AnalyseNREMsubstages_N1versusImmob2.m 
edit AnalyseNREMsubstages_N1versusImmob3.m
edit AnalyseNREMsubstages_N1versusImmob_Spikes.m
edit AnalyseNREMsubstages_N1versusImmob_Spikes2.m
edit AnalyseNREMsubstages_OBX
edit AnalyseNREMsubstages_MultiParamMatrix
edit NREMCodeORX % souris orexin

%% 5. Evolution slowOscillations across ZT
edit AnalyseNREMsubstages_OBslowOscML
edit AnalyseNREMsubstages_EvolSlowML
edit AnalyseNREMsubstages_SpectrumML

%% 6. codes for Transition analysis
edit AnalyseNREMsubstages_transitionML
edit AnalyseNREMsubstages_transitionprobML
edit AnalyseNREMsubstages_EvolRescaleML
edit AnalyseNREMsubstages_MiceVsHumansML %doNew
edit AnalyseNREMsubstages_TrioTransRescaleML
edit AnalyseNREMsubstages_SleepCycle.m %doNew
edit AnalyseNREMsubstages_TrioTransitionML.m

%% 7. dKO connexins
edit AnalyseNREMsubstagesdKOML;

%% 8. Other
edit NREMstages_CaracteristicsExpe.m
edit AnalyseNREMsubstages_mergeDropML
edit CodePourMarieCrossCorrDeltaSpindlesRipples.m
edit CaracteristicsSubstagesML.m
edit ExploreSleepScorSubstages.m
edit RunFuctions_ML.m


%% resume step NREM substage Scoring

%[WAKE,REM,N1,N2,N3]=RunSubstages;
   op=FindNREMepochsML;
   [EP,~]=DefineSubStagesNew(op,noise,0,1);
   N1=EP{1}; N2=EP{2}; N3=EP{3}; REM=EP{4}; WAKE=EP{5}; SWS=EP{6}; swaOB=EP{8};

%[EP,~]=DefineSubStagesNew(op,noise,0,1);
t_mergeEp=3; % in second
t_dropEp=1;
REM=and(opNew{4},sleep); %t_mergeEp %t_dropEp
SWS=opNew{6}-REM;%t_mergeEp %t_dropEp
WAKE=mergeCloseIntervals(opNew{5},t_mergeEp*1E4);
WAKE=(WAKE-REM)-SWS;%t_dropEp
N3=and(opNew{3},SWS); 
N23=and(or(opNew{1},opNew{2}),SWS);N23=or(N23,N3);%t_mergeEp %t_dropEp
N1=SWS-N23; %t_mergeEp %t_dropEp
N2=N23-N3; %t_mergeEp %t_dropEp
lostEpoch=TOTepoch-WAKEnoise-REM-N1-N2-N3-SI; % replace lost epoch, continuous hypothesis

% op=FindNREMepochsML;
[dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deltadeep');
BurstDeltaEpoch=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,0);
op{1}=sOsciEpoch; %S34 sup
op{2}=dOsciEpoch; %S34 deep
op{3}=BurstDeltaEpoch; %N3
op{4}=dREM;
op{5}=dWAKE;
op{6}=dSWS;
op{7}=SIEpoch;% short immobility
op{8}=EpochSlowPF; %PFCx
op{9}=EpochSlowOB; %OB

% [dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deltadeep');
mergeSleep=3; % movement smaller than 3s included in sleep 
% immob smaller than 3s included in wake 
win=5; dropSleep=15;%s
load StateEpoch.mat ThetaRatioTSD ThetaThresh ImmobEpoch ManualScoring Mmov
ThetaEpoch=thresholdIntervals(ThetaRatioTSD,ThetaThresh,'Direction','Above'); % merge win, drop win
Immob=thresholdIntervals(Mmov,MovThresh,'Direction','Below');% merge win, drop win
SIEpoch=Immob-dropShortIntervals(Immob,dropSleep*1E4);
REM=and(Immob,ThetaEpoch); % merge win
SWS=Immob-REM;% merge win
WAKE=WholeEpoch-Immob;
[OsciEpoch,~,SWAEpoch,BurstEpoch,spindles,sdTH,ISI_th]=FindOsciEpochs(LFP,Immob);% modif Julie 25.01.2018

%[OsciEpoch,WholeEpoch,SWAEpoch,BurstEpoch,spindles,sdTH,ISI_th]=FindOsciEpochs(LFP,SWS,sdTH,ISI_th)
[tpeaks]=FindExtremPeaksML(LFP,sdTH,dropShortIntervals(SWS,1.5E4));%SB output = tsd with time of all peaks and all troughs after filtering in all freq bands
[h,BurstEpoch]=ObsExtremPeaksML(tpeaks,ISI_th); %SB BurstEpoch is all the epochs with at least 3 peaks in freq between 2-20Hz that are closer than 1s
[spindles,SWA]=FindSpindlesML(LFP,[2 20],SWS,'off');
SWAEpoch=intervalSet(SWA(:,1)*1E4,SWA(:,2)*1E4);
OsciEpoch=or(SWAEpoch,BurstEpoch);
