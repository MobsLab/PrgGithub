experiment= 'Fear-electrophy';
Dir=PathForExperimentFEAR(experiment);
%Dir = RestrictPathForExperiment(Dir,'nMice',[253 254]);
%nameSession=unique(Dir.Session);

% nameGroups=unique(Dir.group);
% nameGroups=[nameGroups(~strcmp(nameGroups,'CTRL')),nameGroups(strcmp(nameGroups,'CTRL'))];
nameGroups={'OBX', 'CTRL'};

Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','CTRL'});
[B,IX] = sort(Dir.group);
Dir.path=Dir.path(IX);
Dir.name=Dir.name(IX);
Dir.manipe=Dir.manipe(IX);
Dir.group=B;
Dir.Session=Dir.Session(IX);

channelstoAnalyse={'dHPC_rip','PFCx_deep','Bulb_deep'}
cols=jet(9);
startvals=[1:0.5:20];
envals=[1:0.5:20]+2;
%clear RocVal
 clear Spectr2 Spectr
for m=2:length(Dir.group)
    m
    try
        cd(Dir.path{m})
        load('behavResources.mat')
        load('StateEpoch.mat')
            
            if exist('SpectrumDataL')>0
                for ch=1:length(channelstoAnalyse)
                if exist(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'])>0
                    load(['ChannelsToAnalyse/' channelstoAnalyse{ch} '.mat'],'channel');
                    if not(isempty(channel))
                        load(['SpectrumDataL/Spectrum',num2str(channel),'.mat'])
                        Sptsd=tsd(t*1e4,Sp);
                        Spectr{m,ch}=(mean(Data(Restrict(Sptsd,FreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch))));
                        TotEpoch=intervalSet(0,max(Range(Sptsd)))-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
                        NoFreezeEpoch=TotEpoch-FreezeEpoch;
                        Spectr2{m,ch}=(mean(Data(Restrict(Sptsd,NoFreezeEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch))));                %Spectr=10*log10(Spectr);
                    end
                end
            end
            end
    end
end

save('/home/vador/Bureau/SpectraFreezing17092015.mat','Spectr','Spectr2','f')


