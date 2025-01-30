%AnalyseNREMsubstages_MiceVsHumansML.m
%
% list of related scripts in NREMstages_scripts.m



%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<< GENERAL INPUTS MICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
FolderToSave='/media/DataMOBsRAID/ProjetAstro/AnalyseNREMsubstages/DatabaseHuman';
res='/media/DataMOBsRAIDN/ProjetAstro/AnalyseTempEvolutionSlow/AnalyseNREMsubstages';
analyname='AnalySubstages';
NameEpochs={'WAKE','REM','N1','N2','N3','totSLEEP','NREM','totRec'};
%FolderFigure='/home/mobsyoda/Dropbox/NREMsubstages-Manuscrit/NewFigs';
FolderFigure='/home/mobschapeau/Dropbox/NREMsubstages-Manuscrit/NewFigs';
%FolderFigure='/media/DataMOBsRAIDN/ProjetNREM/Figures/AnalyNREMsubstages_HumansVSMice';
savFig=0;
%doNew=1; % BASALlongSleep
doNew=2; % BASALlongSleep + old mice
%doNew=0; %old mice

colori=[0.5 0.5 0.5;0 0 0; 0.7 0.2 1 ; 1 0.2 0.8 ;1 0 0; 0 0 1;0.5 0.5 0.8;0 1 0];
%colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.6 0 0.6 ;1 0.8 1;1 0 1 ; 0 0 0];
%colori=[0.5 0.2 0.1;0.1 0.7 0 ;0.5 0.5 0.5 ;0 0 0;1 0 1 ];
if doNew==1
    analyname=[analyname,'New'];
    Dir=PathForExperimentsMLnew('BASALlongSleep');
    
elseif doNew==2
    analyname=[analyname,'All'];
    Dir1=PathForExperimentsMLnew('BASALlongSleep');
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
else
    Dir1=PathForExperimentsDeltaSleepNew('BASAL');
    Dir1=RestrictPathForExperiment(Dir1,'nMice',[243 244 251 252]);
    Dir2=PathForExperimentsML('BASAL');
    Dir2=RestrictPathForExperiment(Dir2,'Group','WT');
    Dir=MergePathForExperiment(Dir1,Dir2);
end


%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%% <<<<<<<<<<<<<<<<<<<<<<<<<<<<< COMPUTE MICE <<<<<<<<<<<<<<<<<<<<<<<<<<<<<
%<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
valSlSt=[4,3,2,1.5,1];
bstep=10; %(min) default =10
TrioL=[]; DuoL=[]; h_deb=nan(length(Dir.path),1);
DURmice=nan(length(Dir.path),length(NameEpochs));
totDURmice=nan(length(Dir.path),length(NameEpochs));
Evolmice=nan(length(NameEpochs),length(Dir.path),10*60/bstep);
MiceEpochs={};
    binsize=500; %50ms


for man=1:length(Dir.path)
    disp(' ');disp(Dir.path{man})
    cd(Dir.path{man})
    
    % -----------------------
    clear WAKE REM N1 N2 N3 NREM totSLEEP SleepStages Sleep
    disp('Loading Substages...')
    [WAKE,REM,N1,N2,N3,NamesStages,SleepStages,noise,WAKEnoise]=RunSubstages(0);close
    NREM=or(or(N1,N2),N3); NREM=mergeCloseIntervals(NREM,100);
    
    % -----------------------
    Epoch_ML{1} = N1;
    Epoch_ML{2} = N2;
    Epoch_ML{3} = N3;
    Epoch_ML{4} = NREM;
    Epoch_ML{5} = REM;
    Epoch_ML{6} = WAKE;

    
    %% Sleep stages
    Record_period = or(or(Epoch_ML{6},Epoch_ML{4}),Epoch_ML{5}); %SWS+WAKE+REM
    indtime = min(Start(Record_period)):binsize:max(Stop(Record_period));
    timeTsd = ts(indtime);
    rg = Range(timeTsd);
    
    for ep=1:length(Epoch_ML)
        idx = find(ismember(rg, Range(Restrict(timeTsd,Epoch_ML{ep})))==1);
        time_in_substages(ep) = length(idx) * sample_size;
        meanDuration_substages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
    end
    percentvalues_NREM = zeros(1,3);
    for ep=1:3
        percentvalues_NREM(ep) = time_in_substages(ep)/sum(time_in_substages(1:3));
    end
    percentvalues_NREM = round(percentvalues_NREM*100,2)
    
    %% recalc
    [dSWS,dREM,dWAKE,dOsciEpoch,noise,SIEpoch,Immob]=FindSleepStageML('PFCx_deltadeep');
    Epoch=Immob-noise;

    [tDelta, ~] = GetDeltaML('PFCx',Epoch,dSWS,1); %new method
    Dpfc=ts(tDelta);
    BurstDeltaEpoch_ML=FindDeltaBurst2(Restrict(Dpfc,Epoch),0.7,0);

    
    %% Substages
    load('DeltaWaves.mat', 'deltas_PFCx')
    deltas_PFCx = dropShortIntervals(deltas_PFCx, min_delta_duration);
    tdeltas = ts(Start(deltas_PFCx));

    BurstDeltaEpoch_KJ=FindDeltaBurst2(Restrict(tdeltas,Epoch),0.7,0);

%     disp('getting sleep stages')
%     [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
%     save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
    
    
    load('FeaturesScoring.mat')
    [Epoch_KJ, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
    
        %% Sleep stages
    Record_period = or(or(Epoch_KJ{6},Epoch_KJ{4}),Epoch_KJ{5}); %SWS+WAKE+REM
    indtime = min(Start(Record_period)):binsize:max(Stop(Record_period));
    timeTsd = ts(indtime);
    rg = Range(timeTsd);
    
    for ep=1:length(Epoch_KJ)
        idx = find(ismember(rg, Range(Restrict(timeTsd,Epoch_KJ{ep})))==1);
        time_in_substages(ep) = length(idx) * sample_size;
        meanDuration_substages(ep) = mean(diff([0;find(diff(idx)~=1);length(idx)])) * sample_size;
    end
    percentvalues_NREM = zeros(1,3);
    for ep=1:3
        percentvalues_NREM(ep) = time_in_substages(ep)/sum(time_in_substages(1:3));
    end
    percentvalues_NREM = round(percentvalues_NREM*100,2)

    
    

    
end
        