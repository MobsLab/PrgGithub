% Calculate spectra,coherence and Granger
clear all, close all
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[242,248,244,243,253,254,258,259,299,394,395,402,403,450,451];

[params,movingwin,suffix]=SpectrumParametersML('low');
order=16;
paramsGranger.trialave=0;
paramsGrangerparamsGranger.err=[1 0.0500];
paramsGranger.pad=2;
paramsGranger.fpass=[0.1 80];
paramsGranger.tapers=[3 5];
paramsGranger.Fs=250;
paramsGranger.err=[1 0.05];
movingwinGranger=[3 0.2];

Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',[CtrlEphys,OBXEphys]);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');

for mm=25:length(Dir.path)
        clear XMLFile
        Dir.path{mm}
        cd(Dir.path{mm})
        
        CurrDirCont=dir;
        for t=1:length(CurrDirCont)
            if not(isempty(strfind(CurrDirCont(t).name,'_SpikeRef.xml'))) | not(isempty(strfind(CurrDirCont(t).name,'SubRefSpk.xml')))
                XMLFile=CurrDirCont(t).name;
            end
        end
        SetCurrentSession(XMLFile)
        
        global DATA
        tetrodeChannels=DATA.spikeGroups.groups;
        
        s=GetSpikes('output','full');
        a=1;
        clear S W
        for i=1:10
            for j=1:200
                try
                    if length(find(s(:,2)==i&s(:,3)==j))>1
                        S{a}=tsd(s(find(s(:,2)==i&s(:,3)==j),1)*1E4,s(find(s(:,2)==i&s(:,3)==j),1)*1E4);
                        TT{a}=[i,j];
                        cellnames{a}=['TT',num2str(i),'c',num2str(j)];
                        
                        tempW = GetSpikeWaveforms([i j]);
                        disp(['Cluster : ',cellnames{a},' > done'])
                        for elec=1:size(tempW,2)
                            W{a}(elec,:)=mean(squeeze(tempW(:,elec,:)));
                        end
                        a=a+1;
                    end
                end
            end
            disp(['Tetrodes #',num2str(i),' > done'])
        end
        
        try
            S=tsdArray(S);
        end
        
        clear tempW
        save SpikeData -v7.3 S s TT cellnames tetrodeChannels
        save Waveforms -v7.3 W cellnames
        disp('Done')
        
        
        if  exist([cd filesep 'SpikeData.mat'])>0
            load([cd filesep 'SpikeData.mat'])
            
            
            %% get the n° of the neurons of PFCx
            numtt=[]; % nb tetrodes ou montrodes du PFCx
            load LFPData/InfoLFP.mat
            chans=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
            
            for cc=1:length(chans)
                for tt=1:length(tetrodeChannels) % tetrodeChannels= tetrodes ou montrodes (toutes)
                    if ~isempty(find(tetrodeChannels{tt}==chans(cc)))
                        numtt=[numtt,tt];
                    end
                end
            end
            
            numNeurons=[]; % neurones du PFCx
            for i=1:length(S);
                if ismember(TT{i}(1),numtt)
                    numNeurons=[numNeurons,i];
                end
            end
            
            numMUA=[];
            for k=1:length(numNeurons)
                j=numNeurons(k);
                if TT{j}(2)==1
                    numMUA=[numMUA, k];
                end
            end
            numNeurons(numMUA)=[];
            GetWFInfoV2(cd)
            [WfId,W]=IdentifyWaveforms([cd],'/home/vador/',1,numNeurons);
            saveas(1,'SpikeClassif.png')
            save SpikeClassification WfId W
            close all
            
        end
 
end