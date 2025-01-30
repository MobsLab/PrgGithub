clear all,close all

clear all
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');
order=40;
nboot=100;
winsize=50;


for mm=2:length(Dir.path) % mouse 1 has no reliable PFCx
    cd(Dir.path{mm})
    clear FreezeEpoch NoFreezeEpoch BreathNoiseEpoch TotalNoiseEpoch
    load('behavResources.mat')
    load('BreathingInfo.mat','BreathNoiseEpoch')
    load('StateEpochSB.mat','TotalNoiseEpoch')
    TotalNoiseEpoch=or(TotalNoiseEpoch,BreathNoiseEpoch);
    FreezeEpoch=FreezeEpoch-TotalNoiseEpoch;FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
    NoFreezeEpoch=NoFreezeEpoch-TotalNoiseEpoch;NoFreezeEpoch=dropShortIntervals(NoFreezeEpoch,5*1e4);
    Ep{1}=FreezeEpoch; Ep{2}=NoFreezeEpoch;
    load('ChannelsToAnalyse/Bulb_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.OB=FilLFP;
    load('ChannelsToAnalyse/PFCx_deep.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.P=FilLFP;
    load('ChannelsToAnalyse/Respi.mat')
    load(['LFPData/LFP',num2str(channel),'.mat'])
    FilLFP=FilterLFP((LFP),[1 80],1024);
    DataLFP.Respi=FilLFP;
    
    
    for ep=1
        %         for st=1:length(Start(Ep{ep}))
        %             LitEpToUse=subset(Ep{ep},st);
        %             EpDur{ep,st}=Stop(LitEpToUse,'s')-Start(LitEpToUse,'s');
        %% Parameters
        LitEpToUse=Ep{ep};
        X=[Data(Restrict(DataLFP.Respi,LitEpToUse)),Data(Restrict(DataLFP.OB,LitEpToUse)),Data(Restrict(DataLFP.P,LitEpToUse))]';
        X=X(:,1:10:end);%X=X(:,1:floor(length(X)/winsize)*winsize);
%         keyboard
        [ret.GW,ret.COH,ret.pp,waut,cons]=cca_pwcausal(X,1,length(X),order,125,[0:0.5:20], 0);
%         ret{ep}=cca_partialgc_doi_bstrap(X,1,length(X),order,nboot,winsize,0.05,1,2);
    end
    save('GrangerFreq.mat','ret')
    clear ret
end
% end
%
% figure
% for mm=2:6%:length(Dir.path) % mouse 1 has no reliable PFCx
%     subplot(2,3,mm)
%     imagesc(ret{mm,1}.gc)
% end