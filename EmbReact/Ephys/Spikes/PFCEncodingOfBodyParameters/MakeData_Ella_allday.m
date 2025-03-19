clear all,
MiceNumber_EKG = [507,508,509,510];
MiceNumber = [490,507,508,509,510,512,514];

epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond5
load('B_Low_Spectrum.mat')
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Data_ella/alldata/';
mkdir(SaveFolder)

LookAtneurons = 0; % whether or not to make plots
fig = figure;



for mm=1:length(MiceNumber)
    FolderList = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    clear VarToSave
    
    % Get concatenated variables
    
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
    cd(FolderList{1})
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    S_concat = S_concat(number);
    for sp = 1:length(S_concat)
        VarToSave.Spk_times{sp} = Range(S_concat{sp},'s');
    end
    
    % OB Spectrum
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
    VarToSave.OBSpec = Data(OBSpec_concat);
    VarToSave.timebins = Range(OBSpec_concat,'s');
    
    % LinearPosition
    LinPos_concat=ConcatenateDataFromFolders_SB(FolderList,'linearposition');
    y=interp1(Range(LinPos_concat),Data(LinPos_concat),Range(OBSpec_concat));
    LinPos_concat = tsd(Range(OBSpec_concat),y);
    VarToSave.LinPos = Data(LinPos_concat);
    
    % accelero
    accelero=ConcatenateDataFromFolders_SB(FolderList,'accelero');
    accelero = Restrict(accelero,ts(Range(OBSpec_concat)));
    VarToSave.Accelero = Data(accelero);
    
    % Heart rate
    if ismember(MiceNumber(mm),MiceNumber_EKG)
        heartrate=ConcatenateDataFromFolders_SB(FolderList,'heartrate');
        y=interp1(Range(heartrate),Data(heartrate),Range(OBSpec_concat));
        heartrate = tsd(Range(OBSpec_concat),y);
        VarToSave.Heartrate = Data(heartrate);
    else
        VarToSave.Heartrate = [];
    end
    
    % Heart times
    if ismember(MiceNumber(mm),MiceNumber_EKG)
        heart_times=ConcatenateDataFromFolders_SB(FolderList,'heart_times');
        VarToSave.HeartTimes = Data(heart_times);
    else
        VarToSave.HeartTimes = [];
    end
    
    % InstFreq, OB
    instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
    y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(OBSpec_concat));
    instfreq_concat_PT = tsd(Range(OBSpec_concat),y);
    instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
    instfreq_concat_WV=Restrict(instfreq_concat_WV,ts(Range(OBSpec_concat)));
    y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(OBSpec_concat));
    y(y>15)=NaN;
    y=naninterp(y);
    instfreq_concat_WV = tsd(Range(OBSpec_concat),y);
    instfreq_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
    VarToSave.BreathFreq = Data(instfreq_concat_Both);
    
    % InstPhase, OB
    instphase_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instphase','suffix_instphase','B','method','PT');
    y=interp1(Range(instphase_concat_PT),Data(instphase_concat_PT),Range(OBSpec_concat));
    instphase_concat_PT = tsd(Range(OBSpec_concat),y);
    instphase_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instphase','suffix_instphase','B','method','WV');
    instphase_concat_WV=Restrict(instphase_concat_WV,ts(Range(OBSpec_concat)));
    y=interp1(Range(instphase_concat_WV),Data(instphase_concat_WV),Range(OBSpec_concat));
    y=naninterp(y);
    y = mod(y+2*pi,2*pi)
    instphase_concat_WV = tsd(Range(OBSpec_concat),y);
    datWV = exp(i*Data(instphase_concat_WV));
    datPT = exp(i*Data(instphase_concat_PT));
    dat = nanmean([datWV,datPT],2);
    phase_consensus = atan2(imag(dat),real(dat));
    instphase_concat_Both = tsd(Range(OBSpec_concat),nanmean([Data(instphase_concat_WV),Data(instphase_concat_PT)]')');
    error = abs(mod(Data(instphase_concat_WV)-Data(instphase_concat_PT)-pi,2*pi)-pi);
    
    VarToSave.BreathPhase_Cons = Data(instphase_concat_Both);
    VarToSave.BreathPhase_PT = Data(instphase_concat_PT);
    VarToSave.Err = error;
    
    
    % Sleep
    Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
    VarToSave.WakeStartStop = [Start(Sleepstate{1},'s'),Stop(Sleepstate{1},'s')];
    VarToSave.NREMStartStop = [Start(Sleepstate{2},'s'),Stop(Sleepstate{2},'s')];
    VarToSave.REMStartStop = [Start(Sleepstate{3},'s'),Stop(Sleepstate{3},'s')];
    
    % FreezingEpoch
    FzEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
    VarToSave.FzStartStop = [Start(FzEp_concat,'s'),Stop(FzEp_concat,'s')];
    
    % NoiseEpoch
    NoiseEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
    VarToSave.NoiseStartStop = [Start(NoiseEp_concat,'s'),Stop(NoiseEp_concat,'s')];
    
    % sessionname
    SessType = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sessiontype');
    allsess = fieldnames(SessType);
    for ss = 1:length(allsess)
        VarToSave.([allsess{ss} '_epo']) = [];
        for ii= 1:length(SessType.(allsess{ss}))
            VarToSave.([allsess{ss} '_epo']) = [VarToSave.([allsess{ss} '_epo']);[Start(SessType.(allsess{ss}){ii},'s'),Stop(SessType.(allsess{ss}){ii},'s')]];
        end
        
    end
    
    
    AllVar = fieldnames(VarToSave);
    mkdir([SaveFolder 'Mouse' num2str(MiceNumber(mm))])
    for v = 1:length(AllVar)
        data = VarToSave.(AllVar{v});
        save([SaveFolder 'Mouse' num2str(MiceNumber(mm)) filesep AllVar{v} '.mat'],'data')
    end
    
end
