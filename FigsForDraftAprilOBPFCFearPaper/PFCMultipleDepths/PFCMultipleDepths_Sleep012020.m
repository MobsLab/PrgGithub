DataLocationPFCMultipleDepths
    windowsize=1600; %in ms

binsize  = 5; %for mETAverage  
nbBins = windowsize / binsize; %for mETAverage

%% Spectra and coherence

for m=1:mm
 
    cd(SleepSession{m})
    disp(SleepSession{m})
    
    if not(exist('IdFigureData.mat')>0)
    SleepScoringOBGamma
    
        %% Sleep event
        disp('getting sleep signals')
        CreateSleepSignals('recompute',0);
        
        %% Substages
        disp('getting sleep stages')
        [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures;
        save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
        [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
        save('SleepSubstages', 'Epoch', 'NameEpoch')
        
        %% Id figure 1
        disp('making ID fig1')
        MakeIDSleepData
        PlotIDSleepData
        saveas(1,'IDFig1.png')
        close all
        
        %% Id figure 2
        disp('making ID fig2')
        MakeIDSleepData2
        PlotIDSleepData2
        saveas(1,'IDFig2.png')
        close all
    end
    
    clear MeanSig_down  MeanSig_delta
    % Trigger PFC channels on delta waves
    delta_waves = GetDeltaWaves;
    for cc=1:size(AllChans{m},2)
        load(['LFPData/LFP',num2str(AllChans{m}(cc)),'.mat'])
        
        [sig,~,tps] = mETAverage(Start(delta_waves), Range(LFP), Data(LFP), binsize, nbBins);
        MeanSig_delta(cc,:) = sig;
    end
    
     % Trigger PFC channels on down
    down_states = GetDownStates;
    if not(isempty(down_states))
    for cc=1:size(AllChans{m},2)
        load(['LFPData/LFP',num2str(AllChans{m}(cc)),'.mat'])
        
        [sig,~,tps] = mETAverage(Start(down_states), Range(LFP), Data(LFP), binsize, nbBins);
        MeanSig_down(cc,:) = sig;
    end
    else
        MeanSig_down =  [];
    end
    
    save('MeanSignals_Down_Delta_ForOBVolCond.mat','MeanSig_delta','MeanSig_down','tps')
    
end




