% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[253,395,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Parameters for triggered specrto
for mm=1:length(Dir.path)
    cd(Dir.path{mm})
    load('behavResources.mat','FreezeEpoch')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;
    load('LFPData/InfoLFP.mat')
    OBChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'Bulb')) & ~cellfun(@isempty,strfind(InfoLFP.hemisphere,'Right')));
    for h=1:length(OBChannels)
        load(['LFPData/LFP',num2str(InfoLFP.channel(OBChannels(h))),'.mat'])
        plot(Data(Restrict(LFP,FreezeEpoch))+h*4000), hold on

        LFPOB{h}=LFP;
    end
    AllCombi=combnk([1:h],2);
    for k=1:size(AllCombi,1)
        temp=Data(Restrict(LFPOB{AllCombi(k,1)},FreezeEpoch))-Data(Restrict(LFPOB{AllCombi(k,2)},FreezeEpoch));
        stdCombi(k)=std(temp);
    end
    
    [val,ind]=max(stdCombi);
    temp=Data(Restrict(LFPOB{AllCombi(ind,1)},FreezeEpoch))-Data(Restrict(LFPOB{AllCombi(ind,2)},FreezeEpoch));
    plot(temp-4000,'linewidth',3), hold on
    keyboard
    LFP=tsd(Range(LFPOB{1}),Data((LFPOB{AllCombi(ind,1)}))-Data((LFPOB{AllCombi(ind,2)})));
    Chans=AllCombi(ind,:);
    
    save('LFPData/LocalOBActivity.mat','LFP','Chans')
    clear LFP Chans LFPOB OBChannels stdCombi AllCombi val ind FreezeEpoch
    clf
    
end

