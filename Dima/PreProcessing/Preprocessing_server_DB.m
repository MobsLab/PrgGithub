%Preprocessing_server_DB
% 11.04.2018 DB

function Preprocessing_server_DB(dirin, dHPC_rip, nonrip, check_noise, sleepsession, th_immob)

try
   dirin;
catch
   dirin={
        '/media/mobsrick/DataMOBS87/Mouse-797/11112018/_Concatenated/';
        '/media/mobsrick/DataMOBS87/Mouse-798/12112018/_Concatenated/'
       };
end

try
   dHPC_rip;
catch
   dHPC_rip = 21; % Number of channels with the best ripples
end

try
   nonrip;
catch
   nonrip = 17; % Number of channels with the no ripples at all (hip tho)
end

try
   check_noise;
catch
   check_noise = 1; % Do you see the noiseless epoch 1/0 
end

try
   sleepsession;
catch
   sleepsession = 1;
end

try
   sleepstimulated;
catch
   sleepstimulated = 0;
end


for i=1:length(dirin)
    Dir=dirin{i};
    
    cd(Dir);
    prefix = 'ERC-';  % Experiment prefix
    load('ExpeInfo.mat');
    load('makedataBulbeInputs.mat');
    load('behavResources.mat', 'TTLInfo');
    flnme = [prefix 'Mouse-' num2str(ExpeInfo.nmouse) '-' num2str(ExpeInfo.date) '-' ExpeInfo.phase];
%     dir_rip = '/media/mobsrick/DataMOBS87/Mouse-798/12112018/PreSleep/';

    %% Make data

    %Set Session
    SetCurrentSession([flnme '.xml']);
    
%     make LFP
    MakeData_LFP
    
%     Make accelerometer Movtsd
    MakeData_Accelero(Dir);
    
%     Digital inputs
    if dodigitalin == 1
        MakeData_Digin
    end
    
%     Get Stimulations if you have any
    if dodigitalin == 1
        GetStims_DB
    end
    
end
%     make Spike Data
    if spk == 1
       SetCurrentSession([flnme '_SpikeRef.xml']);
       MakeData_Spikes([flnme '_SpikeRef.xml'], 'mua', 1, 'allwaveforms', 1);
    end
    
   Check for noise and save it
    [Epoch,TotalNoiseEpoch,SubNoiseEpoch,Info]=FindNoiseEpoch_SleepScoring(dHPC_rip);
    if check_noise == 1
        load ([Dir '/LFPData/LFP' num2str(dHPC_rip) '.mat']);
        A = Restrict(LFP, Epoch);
        plot(Range(A, 's'), Data(A))
    end
    save('NoiseEpoch', 'Epoch', 'TotalNoiseEpoch','SubNoiseEpoch','Info');
    
    % Make Heart Beat data
    Options.TemplateThreshStd=3;
    Options.BeatThreshStd=0.5;
    load ([Dir '/ChannelsToAnalyse/EKG.mat'])
    EKG = load(['LFPData/LFP',num2str(channel),'.mat']);
    load('ExpeInfo.mat')
    load('behavResources.mat');
    StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-3E2, Start(TTLInfo.StimEpoch)+5E3);
    BadEpoch = or(TotalNoiseEpoch, StimEpoch);
    [Times,Template,HeartRate,GoodEpoch]=DetectHeartBeats_EmbReact_SB(EKG.LFP,BadEpoch,Options,1);
    EKG.HBTimes=ts(Times);
    EKG.HBShape=Template;
    EKG.DetectionOptions=Options;
    EKG.HBRate=HeartRate;
    EKG.GoodEpoch=GoodEpoch;
    save('HeartBeatInfo.mat','EKG')
    saveas(gcf,'EKGCheck.fig'),              
    saveFigure(gcf,'EKGCheck', Dir);
    
    % Detect ripples events
    if sleepsession == 1
        [ripples,stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 5],'rmvnoise',0, 'clean', 1);
    else
        load ([dir_rip 'Ripples.mat']);
        [ripples, stdev] = FindRipples_DB (dHPC_rip, nonrip, [2 5],'rmvnoise', 0, 'clean', 1, 'stdev', stdev);
    end
   
    %% Sleep scoring
    defaultvalues={'no', 'no', 'no'};
    Questions={'Sleep scoring? (OBgamma)', 'Sleep events?' 'Substages?'};
    ans = inputdlg(Questions, 'Inputs for makeData', 1, defaultvalues);
    
    doscoring = strcmp(ans{1},'yes');
    dosleepevents = strcmp(ans{2},'yes');
    dosubstages = strcmp(ans{3},'yes');
    
    if doscoring == 1
        if sleepstimulated
            StimEpoch = intervalSet(Start(TTLInfo.StimEpoch)-3E2, Start(TTLInfo.StimEpoch)+3E3);
            SleepScoring_Accelero_OBgamma('PlotFigure',1, 'smoothwindow', 1.2, 'StimEpoch', StimEpoch);
        else
            SleepScoring_Accelero_OBgamma('PlotFigure',1);
        end
    end
   
    %Sleep event
    delete DeltaWaves.mat
    if dosleepevents == 1
        CreateSleepSignals('recompute',0,'scoring','accelero');
    end
    
    % Substages
    if dosubstages == 1
       [featuresNREM, Namesfeatures, EpochSleep, NoiseEpoch, scoring] = FindNREMfeatures('scoring','ob');
       save('FeaturesScoring', 'featuresNREM', 'Namesfeatures', 'EpochSleep', 'NoiseEpoch', 'scoring')
       [Epoch, NameEpoch] = SubstagesScoring(featuresNREM, NoiseEpoch);
       save('SleepSubstages', 'Epoch', 'NameEpoch') 
    end
end
end