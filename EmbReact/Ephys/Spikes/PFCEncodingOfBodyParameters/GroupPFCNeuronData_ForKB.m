clear all,
MiceNumber_EKG = [507,508,509,510];
MiceNumber = [490,507,508,509,510,512,514];

epoch_names = {'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
SessionNames = {'UMazeCond'};
num_bootstraps = 100;
SaveFolder = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/SpikeAnalysis/PFCNeurons_UMazeSpatialFiring/';
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_UMazeCond/Cond5
load('B_Low_Spectrum.mat')
FolderList_all{1} = PathForExperimentsEmbReact(SessionNames{1});
SaveFolder='/media/DataMOBsRAIDN/ProjectEmbReact/Data_KB/';
mkdir(SaveFolder)

fig = figure;


for mm=4:length(MiceNumber)
    FolderList = GetAllMouseTaskSessions(MiceNumber(mm));
    
    
    clear VarToSave
    
    % Get concatenated variables
    
    % Spikes
    S_concat=ConcatenateDataFromFolders_SB(FolderList,'spikes');
    cd(FolderList{1})
    clear number
    load('SpikesToAnalyse/PFCx_Neurons.mat')
    S_concat = S_concat(number);
    VarToSave.S = S_concat;
    
    
    % OB Spectrum
    OBSpec_concat=ConcatenateDataFromFolders_SB(FolderList,'spectrum','prefix','B_Low');
    VarToSave.OBSpec = OBSpec_concat;
    
    % LinearPosition
    LinPos_concat=ConcatenateDataFromFolders_SB(FolderList,'linearposition');
    VarToSave.LinPos = LinPos_concat;
    
    % accelero
    accelero=ConcatenateDataFromFolders_SB(FolderList,'accelero');
    VarToSave.Accelero = accelero;
    
    % Aligned Position
    position = ConcatenateDataFromFolders_SB(FolderList,'alignedposition');
    VarToSave.AlignedPosition = position;
    
    % Heart rate
    if ismember(MiceNumber(mm),MiceNumber_EKG)
        heartrate=ConcatenateDataFromFolders_SB(FolderList,'heartrate');
        VarToSave.Heartrate = heartrate;
        heartratevar=ConcatenateDataFromFolders_SB(FolderList,'heartratevar');
        VarToSave.HeartrateVar = heartratevar;
    else
        VarToSave.Heartrate = [];
        VarToSave.HeartrateVar = [];
    end
    
    
    % InstFreq, OB
    instfreq_concat_PT=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','PT');
    instfreq_concat_WV=ConcatenateDataFromFolders_SB(FolderList,'instfreq','suffix_instfreq','B','method','WV');
    
    y=interp1(Range(instfreq_concat_PT),Data(instfreq_concat_PT),Range(instfreq_concat_WV));
    instfreq_concat_PT = tsd(Range(instfreq_concat_WV),y);
    y=interp1(Range(instfreq_concat_WV),Data(instfreq_concat_WV),Range(instfreq_concat_WV));
    y(y>15)=NaN;
    y=naninterp(y);
    instfreq_concat_WV = tsd(Range(instfreq_concat_WV),y);
    instfreq_concat_Both = tsd(Range(instfreq_concat_WV),nanmean([Data(instfreq_concat_WV),Data(instfreq_concat_PT)]')');
    VarToSave.BreathFreq = instfreq_concat_Both;
    
    % ripples
    Ripples = ConcatenateDataFromFolders_SB(FolderList,'ripples');
    VarToSave.Ripples = Ripples;
    
    % LFP OB
    cd(FolderList{1})
    clear channel
    if exist('ChannelsToAnalyse/Bulb_deep.mat')>0
        load('ChannelsToAnalyse/Bulb_deep.mat')
    elseif exist('ChannelsToAnalyse/Bulb_sup.mat')>0
        load('ChannelsToAnalyse/Bulb_sup.mat')
    end
    LFP = ConcatenateDataFromFolders_SB(FolderList,'LFP','channumber',channel);
    VarToSave.OBLFP = LFP;
    
    % LFP HPC
    cd(FolderList{1})
    clear channel
    if exist('ChannelsToAnalyse/dHPC_deep.mat')>0
        load('ChannelsToAnalyse/dHPC_deep.mat')
        LFP = ConcatenateDataFromFolders_SB(FolderList,'LFP','channumber',channel);
        VarToSave.HPC_deepLFP = LFP;
    else
        VarToSave.HPC_deepLFP = [];
    end
    clear channel
    if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
        load('ChannelsToAnalyse/dHPC_rip.mat')
        LFP = ConcatenateDataFromFolders_SB(FolderList,'LFP','channumber',channel);
        VarToSave.HPC_ripLFP = LFP;
    else
        VarToSave.HPC_ripLFP = [];
    end
    
    % Sleep epochs
    Sleepstate=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sleepstates');
    VarToSave.WakeEpoch = Sleepstate{1};
    VarToSave.NREMEpoch =  Sleepstate{2};
    VarToSave.REMEpoch = Sleepstate{3};
    
    % FreezingEpoch
    FzEp_concat=ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','freezeepoch');
    VarToSave.FzEpoch = FzEp_concat;
    
    % NoiseEpoch
    NoiseEp_concat = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','noiseepoch');
    VarToSave.NoiseEpoch = NoiseEp_concat;
    
    % sessionname
    SessType = ConcatenateDataFromFolders_SB(FolderList,'epoch','epochname','sessiontype');
    VarToSave.SessionEpoch = SessType;
    
    AllVar = fieldnames(VarToSave);
    mkdir([SaveFolder 'Mouse' num2str(MiceNumber(mm))])
    for v = 1:length(AllVar)
        eval([AllVar{v} '= VarToSave.(AllVar{v})']);
        save([SaveFolder 'Mouse' num2str(MiceNumber(mm)) filesep AllVar{v} '.mat'],AllVar{v})
    end
    
end
