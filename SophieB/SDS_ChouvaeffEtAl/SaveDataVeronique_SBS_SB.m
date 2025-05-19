clear all
DataLocation = '/media/nas8/ProjetPFCVLPO/'
SessionName = {'Sleep_PreSDS','Sleep_PostSDS'};
pasTheta=100;
params.Fs=200;
params.trialave=0;
params.err=[1 0.0500];
params.pad=2;
params.fpass=[0 40];
movingwin=[3 0.2];
params.tapers=[3 5];

for ss = 1:length(SessionName)
    if ss==1
        cd /home/pinky/Dropbox/Mobs_member/Thierry/DataSommeilSDS_Veronique/WT_PréDS/
    else
        cd /home/pinky/Dropbox/Mobs_member/Thierry/DataSommeilSDS_Veronique/WT_DSJ1/
    end
    [hdr, recorddata] = edfread('Traces.edf');
    date = [hdr.startdate(end-1:end),hdr.startdate(end-4:end-3),'20',hdr.startdate(1:2)];
    
    % Get time and zeitgeber time
    tpsEMG = [1:length(recorddata)/2]/100;
    tpsEEG = [1:length(recorddata)]/200;
    starttime_sec = eval(hdr.starttime(1:2))*3600 + eval(hdr.starttime(4:5))*60;
    ZT = mod(starttime_sec + tpsEEG,3600*24);
    NewtsdZT = tsd(tpsEEG*1e4,ZT');
    
    for mousenum = 1:4
        DirectoryToUse = [DataLocation,'M', num2str(mousenum),filesep,date,filesep,SessionName{ss}];
        mkdir(DirectoryToUse)
        cd(DirectoryToUse)
        
        save('behavResources.mat','NewtsdZT')
        % Save LFP
        mkdir('ChannelsToAnalyse')
        mkdir('LFPData')
        % LFP - EMG
        ChanName = ['EMG',num2str(mousenum+1)];
        ChanToUse = find(~cellfun(@isempty,strfind(hdr.label,ChanName)));
        channel = 1;
        save('ChannelsToAnalyse/EMG.mat','channel')
        LFP = tsd(tpsEMG*1e4,recorddata(ChanToUse,1:end/2)');
        save('LFPData/LFP1.mat','LFP')
        % LFP - EOG
        ChanName = ['EOG',num2str(mousenum+1)];
        ChanToUse = find(~cellfun(@isempty,strfind(hdr.label,ChanName)));
        channel = 2;
        save('ChannelsToAnalyse/EOG.mat','channel')
        LFP = tsd(tpsEMG*1e4,recorddata(ChanToUse,1:end/2)');
        save('LFPData/LFP2.mat','LFP')
        % LFP - EEG
        ChanName = ['EEG',num2str(mousenum+1)];
        ChanToUse = find(~cellfun(@isempty,strfind(hdr.label,ChanName)));
        channel = 3;
        save('ChannelsToAnalyse/EEG.mat','channel')
        LFP = tsd(tpsEEG*1e4,recorddata(ChanToUse,1:end)');
        save('LFPData/LFP3.mat','LFP')
        
        
        [Spectro{1},Spectro{2},Spectro{3}]=mtspecgramc(Data(LFP),movingwin,params);
        save('H_Low_Spectrum.mat','Spectro')
        
    end
end