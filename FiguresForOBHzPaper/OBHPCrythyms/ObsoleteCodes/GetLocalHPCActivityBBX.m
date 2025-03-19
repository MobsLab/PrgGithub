% Look at HPC phase after subtraction of local channels
%% Are theta and OB ocillations coupled?
%  Only look
%% Comodulation in three states : REM, SWS, Locomotion
clear all
CtrlEphysInvHPC=[249,250,297];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphysInvHPC);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h-envC');

% Parameters for triggered specrto
for mm=1:length(Dir.path)
    cd(Dir.path{mm})

    load('H_Low_Spectrum.mat')
    lowlim=find(Spectro{3}>7,1,'first');
    highlim=find(Spectro{3}>11,1,'first');
    ThetVal=mean(Spectro{1}(:,lowlim:highlim)')./(mean(Spectro{1}(:,1:lowlim)')+mean(Spectro{1}(:,highlim:end)'));
    ThetValtsd=tsd(Spectro{2}*1e4,ThetVal');
    ThetEp=thresholdIntervals(ThetValtsd,prctile(ThetVal,90));
    ThetEp=mergeCloseIntervals(ThetEp,3*1e4);
    
    load('LFPData/InfoLFP.mat')
    HPCChannels=find(~cellfun(@isempty,strfind(InfoLFP.structure,'dHPC')));

    for h=1:length(HPCChannels)
        load(['LFPData/LFP',num2str(InfoLFP.channel(HPCChannels(h))),'.mat'])
        LFPHPC{h}=LFP;
                 plot(Data(Restrict(LFP,ThetEp))+10000*h), hold on
    end
    AllCombi=combnk([1:h],2);
    for k=1:size(AllCombi,1)
        temp=Data(Restrict(LFPHPC{AllCombi(k,1)},ThetEp))-Data(Restrict(LFPHPC{AllCombi(k,2)},ThetEp));
                 plot(temp), hold on
        stdCombi(k)=std(temp);
    end
    
    [val,ind]=max(stdCombi);
    temp=Data(Restrict(LFPHPC{AllCombi(ind,1)},ThetEp))-Data(Restrict(LFPHPC{AllCombi(ind,2)},ThetEp));
         plot(temp,'linewidth',3), hold on
    LFP=tsd(Range(LFPHPC{1}),Data((LFPHPC{AllCombi(ind,1)}))-Data((LFPHPC{AllCombi(ind,2)})));
    Chans=AllCombi(ind,:);
    HPCChannels=InfoLFP.channel(HPCChannels(Chans));
    keyboard
    save('LFPData/LocalHPCActivity.mat','LFP','HPCChannels')
    clear LFP Chans LFPHPC HPCChannels stdCombi AllCombi ThetEp ThetVal val ind Spectro
    
    
end