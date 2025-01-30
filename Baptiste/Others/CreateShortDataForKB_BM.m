



%% Data for Karim : for mice with PFC neurons
%MiceToUse = [490,507,508,509,510,512,514];
MiceToUse = [688,739,777,779,849,893,1096];
MiceToUse = [875,876,877,1001,1002,1095];


for mm = 5:length(MiceToUse)
   
    FileNames_Bef=GetAllMouseTaskSessions(MiceToUse(mm));
   % FileNames = FileNames(1:18);
    FileNames = FileNames_Bef;
    SaveLocation = ['/media/nas6/ProjetEmbReact/DataUmazeSpikes_KB/M',num2str(MiceToUse(mm)),'/'];
    mkdir(SaveLocation)
   
    %% Behaviour
    % Freezing
    try
    FreezeEpoch = ConcatenateDataFromFolders_SB(FileNames,'epoch','epochname','freezeepoch');
    catch
        LittleCorrection_CreateShortDataKB
    end
    % ZoneEpoch
    ZoneEpoch = ConcatenateDataFromFolders_SB(FileNames,'epoch', 'epochname','zoneepoch');
   
    % Linearized position
    LinPos = ConcatenateDataFromFolders_SB(FileNames,'linearposition');
   
    % X,Y position
    Pos = ConcatenateDataFromFolders_SB(FileNames,'alignedposition');
   
    % speed
    Vtsd = ConcatenateDataFromFolders_SB(FileNames,'speed');
   
    % SessionName
    SessionNames = ConcatenateDataFromFolders_SB(FileNames,'epoch', 'epochname','sessiontype');
   
    % StimTimes
    StimEpoch = ConcatenateDataFromFolders_SB(FileNames,'epoch', 'epochname','stimepoch');
   
    % accelero
    MovAcctsd = ConcatenateDataFromFolders_SB(FileNames,'accelero');
   
    save([SaveLocation,'behavresources.mat'],'MovAcctsd','StimEpoch','SessionNames','Vtsd','Pos',...
        'LinPos','ZoneEpoch','FreezeEpoch','-v7.3')
   
    %% Ephys
    % EKG
    HB_Times = ConcatenateDataFromFolders_SB(FileNames,'heartbeat');
    HB_LFP = ConcatenateDataFromFolders_SB(FileNames,'heartbeat');
    save([SaveLocation,'EKG.mat'],'HB_LFP','HB_Times','-v7.3')
   
    % All channels to analyse as LFP
    cd(FileNames{1})
    ChToAnalyse = dir('ChannelsToAnalyse');
    mkdir([SaveLocation 'LFPData'])
    mkdir([SaveLocation 'ChannelsToAnalyse'])
   
    for ch = 1:length(ChToAnalyse)
        if not(isempty(strfind(ChToAnalyse(ch).name,'.mat')))
            load(['ChannelsToAnalyse/' ChToAnalyse(ch).name])
            if not(isempty(channel)) & length(channel)==1 & not(isnan(channel))
                LFP = ConcatenateDataFromFolders_SB(FileNames,'lfp','channumber',channel);
                save([SaveLocation,'LFPData/LFP',num2str(channel),'.mat'],'LFP','-v7.3')
                save([SaveLocation,'ChannelsToAnalyse/' ChToAnalyse(ch).name],'channel')
            end
        end
    end
   
    try
    % Spikes
    Spikes = ConcatenateDataFromFolders_SB(FileNames,'spikes');
    save([SaveLocation,'Spikes.mat'],'Spikes','-v7.3')
    end
   
    % Oscillations
    Ripples = ConcatenateDataFromFolders_SB(FileNames,'ripples');
    Spindles = ConcatenateDataFromFolders_SB(FileNames,'spindles');
    Deltas = ConcatenateDataFromFolders_SB(FileNames,'deltawaves');
    save([SaveLocation,'Ripples.mat'],'Ripples','-v7.3')
    save([SaveLocation,'Spindle.mat'],'Spindles','-v7.3')
    save([SaveLocation,'Delta.mat'],'Deltas','-v7.3')
   
    %% Sleep
    % sleep states
    SleepOut = ConcatenateDataFromFolders_SB(FileNames,'epoch', 'epochname','sleepstates');
    Wake = SleepOut{1};
    NREMEpoch = SleepOut{2};
    REMEpoch = SleepOut{3};
   
    % Marie scoring
    SleepOut = ConcatenateDataFromFolders_SB(FileNames,'epoch', 'epochname','NREMsubstages');
    N1Epoch = SleepOut{1};
    N2Epoch = SleepOut{2};
    N3Epoch = SleepOut{3};
   
    save([SaveLocation,'SleepScoring.mat'],'Wake','NREMEpoch','REMEpoch','N1Epoch','N2Epoch','N3Epoch','-v7.3')
   
    %% Spectra
    SpecPref = {'H_Low','B_Low','PFCx_Low','H_VHigh','B_High'};
    for spec = 1:length(SpecPref)
       
        try
            Sptsd = ConcatenateDataFromFolders_SB(FileNames,'spectrum', 'prefix',SpecPref{spec});
        load([FileNames{1},SpecPref{spec},'_Spectrum.mat'])
        f = Spectro{3};
        save([SaveLocation,SpecPref{spec}, '_spectrum.mat'],'f','Sptsd','-v7.3')
        end
    end
   
end












