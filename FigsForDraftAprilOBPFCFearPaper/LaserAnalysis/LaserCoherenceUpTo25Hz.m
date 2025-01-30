% INPUTS
clear all
Dir.path={
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
    '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
    %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
    };

for k=1:length(Dir.path)
    ind_mouse=strfind(Dir.path{k},'Mouse');
    Dir.name{k}=Dir.path{k}(ind_mouse:ind_mouse+7);
end

Structures={'PFCx','PiCx','dHPC'};
Sides={'Left','Right'}

% for d=length(Dir.path)
%     cd(Dir.path{d})
%     clear AllLFP
%     load('ChannelsToAnalyse/Bulb_deep_left.mat')
%     AllChans.Bulb.Left=channel;
%     load('ChannelsToAnalyse/Bulb_deep_right.mat')
%     AllChans.Bulb.Right=channel;
%     load('ChannelsToAnalyse/PFCx_deep_left.mat')
%     AllChans.PFCx.Left=channel;
%     load('ChannelsToAnalyse/PFCx_deep_right.mat')
%     AllChans.PFCx.Right=channel;
%     try,load('ChannelsToAnalyse/dHPC_rip.mat')
%         AllChans.dHPC.Right=channel;
%     catch
%         load('ChannelsToAnalyse/dHPC_deep.mat')
%         AllChans.dHPC.Right=channel;
%     end
%     load('ChannelsToAnalyse/PiCx_left.mat')
%     AllChans.PiCx.Left=channel;
%     load('ChannelsToAnalyse/PiCx_right.mat')
%     AllChans.PiCx.Right=channel;
%
%     for sd=1:length(Sides)
%         OBChan=AllChans.Bulb.(Sides{sd});
%         OBName=['BulbBis',(Sides{sd})];
%         for s=1:length(Structures)
%             if isfield(AllChans,(Structures{s}))
%                 if isfield(AllChans.(Structures{s}),(Sides{sd}))
%                     [OBName,'-',Structures{s},Sides{sd}]
%                     LowCohgramSB([cd filesep],OBChan,OBName,AllChans.(Structures{s}).(Sides{sd}),[Structures{s},Sides{sd}], 0);
%                 end
%             end
%         end
%     end
% end

AllFreq=[1,2,4,7,10,13,15,20];
num=1;numpi=1;
for d=1:length(Dir.path)
    disp(Dir.path{d})
    cd(Dir.path{d})
    load('StimInfo.mat')
    load('StateEpoch.mat','SWSEpoch')
    
    load('BulbBisLeft_PFCxLeft_Low_Coherence.mat')
    Cohtsd=tsd(Coherence{2}*1e4,Coherence{1});
    Spec1tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch1{1});
    Spec2tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch2{1});
    CrossSpectsd=tsd(Coherence{2}*1e4,CrossSpectro{1});
    TFtemp=abs(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec1tsd)));
    TFtsd=tsd(Coherence{2}*1e4,TFtemp);
    IMtemp=imag(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec2tsd)));
    IMCohtsd=tsd(Coherence{2}*1e4,IMtemp);
    for freq=1:length(AllFreq)
        FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
        Stims=find(StimInfo.Freq==AllFreq(freq));
        
        StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
        MeanCoh{freq}(num,:)=nanmean(Data(Restrict(Cohtsd,StimEpoch)));
        MeanImCoh{freq}(num,:)=nanmean(Data(Restrict(IMCohtsd,StimEpoch)));
        TF{freq}(num,:)=nanmean(Data(Restrict(TFtsd,StimEpoch)));
        Spec1{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,StimEpoch)));
        Spec2{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,StimEpoch)));
        MeanCohPeak{freq}(num,:)=max(MeanCoh{freq}(num,FreqLims));
        Spec1Peak{freq}(num,:)=max(Spec1{freq}(num,FreqLims));
        Spec2Peak{freq}(num,:)=max(Spec2{freq}(num,FreqLims));
        TFPeak{freq}(num,:)=max(TF{freq}(num,FreqLims));
        
        PreStimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4-30*1e4,StimInfo.StartTime(Stims)*1e4),SWSEpoch);
        Spec1Pre{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,PreStimEpoch)));
        Spec2Pre{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,PreStimEpoch)));
    end
    num=num+1;
    
    
    load('BulbBisRight_PFCxRight_Low_Coherence.mat')
    Cohtsd=tsd(Coherence{2}*1e4,Coherence{1});
    Spec1tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch1{1});
    Spec2tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch2{1});
    CrossSpectsd=tsd(Coherence{2}*1e4,CrossSpectro{1});
    TFtemp=abs(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec1tsd)));
    TFtsd=tsd(Coherence{2}*1e4,TFtemp);
    IMtemp=imag(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec2tsd)));
    IMCohtsd=tsd(Coherence{2}*1e4,IMtemp);
    for freq=1:length(AllFreq)
        Stims=find(StimInfo.Freq==AllFreq(freq));
        StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
        MeanCoh{freq}(num,:)=nanmean(Data(Restrict(Cohtsd,StimEpoch)));
        MeanImCoh{freq}(num,:)=nanmean(Data(Restrict(IMCohtsd,StimEpoch)));
        TF{freq}(num,:)=nanmean(Data(Restrict(TFtsd,StimEpoch)));
        Spec1{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,StimEpoch)));
        Spec2{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,StimEpoch)));
        MeanCohPeak{freq}(num,:)=max(MeanCoh{freq}(num,FreqLims));
        Spec1Peak{freq}(num,:)=max(Spec1{freq}(num,FreqLims));
        Spec2Peak{freq}(num,:)=max(Spec2{freq}(num,FreqLims));
        TFPeak{freq}(num,:)=max(TF{freq}(num,FreqLims));
        PreStimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4-30*1e4,StimInfo.StartTime(Stims)*1e4),SWSEpoch);
        Spec1Pre{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,PreStimEpoch)));
        Spec2Pre{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,PreStimEpoch)));
        
    end
    num=num+1;
    
    load('BulbBisRight_PiCxRight_Low_Coherence.mat')
    Cohtsd=tsd(Coherence{2}*1e4,Coherence{1});
    Spec1tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch1{1});
    Spec2tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch2{1});
    CrossSpectsd=tsd(Coherence{2}*1e4,CrossSpectro{1});
    TFtemp=abs(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec1tsd)));
    TFtsd=tsd(Coherence{2}*1e4,TFtemp);
    IMtemp=imag(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec2tsd)));
    IMCohtsd=tsd(Coherence{2}*1e4,IMtemp);
    for freq=1:length(AllFreq)
        Stims=find(StimInfo.Freq==AllFreq(freq));
        StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
        MeanCohPi{freq}(num,:)=nanmean(Data(Restrict(Cohtsd,StimEpoch)));
        MeanImCohPi{freq}(num,:)=nanmean(Data(Restrict(IMCohtsd,StimEpoch)));
        TFPi{freq}(num,:)=nanmean(Data(Restrict(TFtsd,StimEpoch)));
        Spec1Pi{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,StimEpoch)));
        Spec2Pi{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,StimEpoch)));
        MeanCohPeakPi{freq}(num,:)=max(MeanCohPi{freq}(num,FreqLims));
        Spec1PeakPi{freq}(num,:)=max(Spec1Pi{freq}(num,FreqLims));
        Spec2PeakPi{freq}(num,:)=max(Spec2Pi{freq}(num,FreqLims));
        TFPeakPi{freq}(num,:)=max(TFPi{freq}(num,FreqLims));
        PreStimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4-30*1e4,StimInfo.StartTime(Stims)*1e4),SWSEpoch);
        Spec1PrePi{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,PreStimEpoch)));
        Spec2PrePi{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,PreStimEpoch)));
        
    end
    numpi=numpi+1;
    
    
    load('BulbBisLeft_PiCxLeft_Low_Coherence.mat')
    Cohtsd=tsd(Coherence{2}*1e4,Coherence{1});
    Spec1tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch1{1});
    Spec2tsd=tsd(Coherence{2}*1e4,SingleSpectro.ch2{1});
    CrossSpectsd=tsd(Coherence{2}*1e4,CrossSpectro{1});
    TFtemp=abs(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec1tsd)));
    TFtsd=tsd(Coherence{2}*1e4,TFtemp);
    IMtemp=imag(Data(CrossSpectsd)./sqrt(Data(Spec1tsd).*Data(Spec2tsd)));
    IMCohtsd=tsd(Coherence{2}*1e4,IMtemp);
    for freq=1:length(AllFreq)
        Stims=find(StimInfo.Freq==AllFreq(freq));
        StimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4,StimInfo.StopTime(Stims)*1e4),SWSEpoch);
        MeanCohPi{freq}(num,:)=nanmean(Data(Restrict(Cohtsd,StimEpoch)));
        MeanImCohPi{freq}(num,:)=nanmean(Data(Restrict(IMCohtsd,StimEpoch)));
        TFPi{freq}(num,:)=nanmean(Data(Restrict(TFtsd,StimEpoch)));
        Spec1Pi{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,StimEpoch)));
        Spec2Pi{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,StimEpoch)));
        MeanCohPeakPi{freq}(num,:)=max(MeanCohPi{freq}(num,FreqLims));
        Spec1PeakPi{freq}(num,:)=max(Spec1Pi{freq}(num,FreqLims));
        Spec2PeakPi{freq}(num,:)=max(Spec2Pi{freq}(num,FreqLims));
        TFPeakPi{freq}(num,:)=max(TFPi{freq}(num,FreqLims));
        PreStimEpoch=and(intervalSet(StimInfo.StartTime(Stims)*1e4-30*1e4,StimInfo.StartTime(Stims)*1e4),SWSEpoch);
        Spec1PrePi{freq}(num,:)=nanmean(Data(Restrict(Spec1tsd,PreStimEpoch)));
        Spec2PrePi{freq}(num,:)=nanmean(Data(Restrict(Spec2tsd,PreStimEpoch)));
    end
    numpi=numpi+1;
end

figure
FreqLenght=size(Spec2PrePi{1},2);
AllCoh=[];
subplot(231)
MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
for mm=1:length(MiceTogether)
    BefSpec(mm,:)=zeros(1,FreqLenght);
    for ff=1:length(AllFreq)
        BefSpec(mm,:)=BefSpec(mm,:)+nanmean(Spec1Pre{ff}(cell2mat(MiceTogether{mm}),:));
        DurSpec{ff}(mm,:)=nanmean(Spec1{ff}(cell2mat(MiceTogether{mm}),:));
    end
end
BefSpec=BefSpec./length(AllFreq);
for mm=1:length(MiceTogether)
    for ff=1:length(AllFreq)
        DurSpec{ff}(mm,:)=DurSpec{ff}(mm,:)./mean(BefSpec(mm,:));
    end
    BefSpec(mm,:)=BefSpec(mm,:)./mean(BefSpec(mm,:));
end
 shadedErrorBar(Coherence{3},nanmean(BefSpec),stdError(BefSpec))
 
hold on
for freq=1:length(AllFreq)
    FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
    allotherfreq=[1:size(Spec2{freq},2)];allotherfreq(FreqLims)=[];
%     AllCoh=[AllCoh;(max(DurSpec{freq}(:,FreqLims)')./mean(BefSpec(:,FreqLims)'))];
%     AllCoh=[AllCoh;max(log(DurSpec{freq}(:,FreqLims)'))./mean(log(BefSpec(:,FreqLims)'))];
    AllCoh=[AllCoh;(mean(DurSpec{freq}(:,FreqLims)')-mean(BefSpec(:,FreqLims)'))];

    temp=runmean((mean(DurSpec{freq})),3);
    PeakVal(freq)=mean(temp(find(Coherence{3}<AllFreq(freq),1,'last')));
    plot(Coherence{3},runmean((mean(DurSpec{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
plot(Coherence{3},mean(BefSpec),'linewidth',5,'color','k')
plot(AllFreq,PeakVal,'--','linewidth',0.5,'color',[0.4 0.4 0.4])
% plot(AllFreq,PeakVal,'o','MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6],'MarkerEdgeColor',[0.6 0.6 0.6])
xlim([0 23])
%  shadedErrorBar(Coherence{3},nanmean(BefSpec),std(BefSpec))
boundedline(Coherence{3},nanmean(BefSpec),[std(BefSpec);std(BefSpec)]','k')
title('Spec OB')
box off
subplot(234)
errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
xlim([0 23])
box off

% [p.OB.Comp2_4,Table.OB.Comp2_4,Stats.OB.Comp2_4] = friedman([AllCoh(2,:)' AllCoh(3,:)'],1);
% [p.OB.Comp7_4,Table.OB.Comp7_4,Stats.OB.Comp7_4] = friedman([AllCoh(4,:)' AllCoh(3,:)'],1);
% 
% [p.OB.Comp7_10,Table.OB.Comp7_10,Stats.OB.Comp7_10] = friedman([AllCoh(4,:)' AllCoh(5,:)'],1);
% [p.OB.Comp13_10,Table.OB.Comp13_10,Stats.OB.Comp13_10] = friedman([AllCoh(6,:)' AllCoh(5,:)'],1);

%% Piriform
AllCoh=[];
subplot(232)
MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
for mm=1:length(MiceTogether)
    BefSpec(mm,:)=zeros(1,FreqLenght);
    for ff=1:length(AllFreq)
        BefSpec(mm,:)=BefSpec(mm,:)+nanmean(Spec2PrePi{ff}(cell2mat(MiceTogether{mm}),:));
        DurSpec{ff}(mm,:)=nanmean(Spec2Pi{ff}(cell2mat(MiceTogether{mm}),:));
    end
end
BefSpec=BefSpec./length(AllFreq);
for mm=1:length(MiceTogether)
    for ff=1:length(AllFreq)
        DurSpec{ff}(mm,:)=DurSpec{ff}(mm,:)./mean(BefSpec(mm,:));
    end
    BefSpec(mm,:)=BefSpec(mm,:)./mean(BefSpec(mm,:));
end

hold on
for freq=1:length(AllFreq)
    FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
    allotherfreq=[1:size(Spec2{freq},2)];allotherfreq(FreqLims)=[];
    AllCoh=[AllCoh;(max(DurSpec{freq}(:,FreqLims)')./mean(BefSpec(:,FreqLims)'))];
    temp=runmean((mean(DurSpec{freq})),3);
    PeakVal(freq)=mean(temp(find(Coherence{3}<AllFreq(freq),1,'last')));
    plot(Coherence{3},runmean((mean(DurSpec{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
plot(AllFreq,PeakVal,'--','linewidth',0.5,'color',[0.4 0.4 0.4])
% plot(AllFreq,PeakVal,'o','MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6],'MarkerEdgeColor',[0.6 0.6 0.6])
xlim([0 23])
% shadedErrorBar(Coherence{3},nanmean(BefSpec),std(BefSpec))
boundedline(Coherence{3},nanmean(BefSpec),[std(BefSpec);std(BefSpec)]','k')
title('Spec Pi')
box off
subplot(235)
errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
xlim([0 23])
box off


AllCoh=[];
subplot(233)
clear DurSpec BefSpec
for mm=1:length(MiceTogether)
    BefSpec(mm,:)=zeros(1,FreqLenght);
    for ff=1:length(AllFreq)
        BefSpec(mm,:)=BefSpec(mm,:)+nanmean(Spec2Pre{ff}(cell2mat(MiceTogether{mm}),:));
        DurSpec{ff}(mm,:)=nanmean(Spec2{ff}(cell2mat(MiceTogether{mm}),:));
    end
end
BefSpec=BefSpec./length(AllFreq);
for mm=1:length(MiceTogether)
    for ff=1:length(AllFreq)
        DurSpec{ff}(mm,:)=DurSpec{ff}(mm,:)./mean(BefSpec(mm,:));
    end
    BefSpec(mm,:)=BefSpec(mm,:)./mean(BefSpec(mm,:));
end
xlim([0 23])

hold on
for freq=1:length(AllFreq)
    FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
    allotherfreq=[1:size(Spec2{freq},2)];allotherfreq(FreqLims)=[];
    AllCoh=[AllCoh;(max(DurSpec{freq}(:,FreqLims)')./mean(BefSpec(:,FreqLims)'))];
    temp=runmean((mean(DurSpec{freq})),3);
    PeakVal(freq)=mean(temp(find(Coherence{3}<AllFreq(freq),1,'last')));
    plot(Coherence{3},runmean((mean(DurSpec{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
plot(AllFreq,PeakVal,'--','linewidth',0.5,'color',[0.4 0.4 0.4])
% plot(AllFreq,PeakVal,'o','MarkerSize',10,'MarkerFaceColor',[0.6 0.6 0.6],'MarkerEdgeColor',[0.6 0.6 0.6])
% shadedErrorBar(Coherence{3},nanmean(BefSpec),std(BefSpec))
boundedline(Coherence{3},nanmean(BefSpec),[std(BefSpec);std(BefSpec)]','k')
title('Spec PFC')
box off
subplot(236)
errorbar(AllFreq,AllFreq.*nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
xlim([0 23])
box off


errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)

% [p.PFC.Comp2_4,Table.PFC.Comp2_4,Stats.PFC.Comp2_4] = friedman([AllCoh(2,:)' AllCoh(3,:)'],1);
% [p.PFC.Comp7_4,Table.PFC.Comp7_4,Stats.PFC.Comp7_4] = friedman([AllCoh(4,:)' AllCoh(3,:)'],1);
% 
% [p.PFC.Comp7_10,Table.PFC.Comp7_10,Stats.PFC.Comp7_10] = friedman([AllCoh(4,:)' AllCoh(5,:)'],1);
% [p.PFC.Comp13_10,Table.PFC.Comp13_10,Stats.PFC.Comp13_10] = friedman([AllCoh(6,:)' AllCoh(5,:)'],1);)




%%%%%%%%%%%%%%%
% clf
% AllCoh=[];
% subplot(241)
% for freq=1:length(AllFreq)
%     AllCoh=[AllCoh;(MeanCohPeak{freq})'];
%     plot(Coherence{3},(mean(MeanCoh{freq}))), hold on
% end
% title('coherence')
% subplot(245)
% errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
% 
% AllCoh=[];
% subplot(242)
% for freq=1:length(AllFreq)
%     AllCoh=[AllCoh;(TFPeak{freq})'];
%     plot(Coherence{3},(mean(TF{freq}))), hold on
% end
% title('Transfer function')
% subplot(246)
% errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
% 
% AllCoh=[];
% subplot(243)
% for freq=1:length(AllFreq)
%     FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
%     allotherfreq=[1:size(Spec2{freq},2)];allotherfreq(FreqLims)=[];
%     if freq>1
%     AllCoh=[AllCoh;(max(Spec2{freq}(:,FreqLims)')-mean(Spec2{1}(:,FreqLims)'))];
%     else
%             AllCoh=[AllCoh;(max(Spec2{freq}(:,FreqLims)')-mean(Spec2{end}(:,FreqLims)'))];
%     end
%     plot(Coherence{3},(mean(Spec2{freq}))), hold on
% end
% title('Spec PFC')
% subplot(247)
% errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
% AllCoh1=AllCoh;
% AllCoh=[];
% subplot(244)
% for freq=1:length(AllFreq)
%     FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
%     allotherfreq=[1:size(Spec1{freq},2)];allotherfreq(FreqLims)=[];
%     if freq>1
%     AllCoh=[AllCoh;(max(Spec1{freq}(:,FreqLims)')./mean(Spec1{1}(:,FreqLims)'))];
%     else
%             AllCoh=[AllCoh;(max(Spec1{freq}(:,FreqLims)')./mean(Spec1{end}(:,FreqLims)'))];
%     end
%     plot(Coherence{3},(mean(Spec1{freq}))), hold on
% end
% title('Spec OB')
% subplot(248)
% errorbar(AllFreq,nanmean(AllCoh'),stdError(AllCoh'),'k','linewidth',3)
% 
% 
% 
% 
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161116';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse458/20161117';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse459/20161123';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170126';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse465/20170127';
% %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170130';
% %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse466/20170131';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170202';
%     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse467/20170203';
% %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170207';
% %     '/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/Mouse468/20170208';
% 
% 
% 
% shadedErrorBar(Coherence{3},mean(BefSpec),stdError(BefSpec))
% hold on
% for mm=1:length(MiceTogether)
%     for ff=1:8
%         SpecPeak(mm,ff)=nanmean(Spec1Peak{ff}(cell2mat(MiceTogether{mm})));
%     end
% end
% errorbar(AllFreq,mean(SpecPeak),stdError(SpecPeak))



%% IMCOherence
figure
FreqLenght=size(Spec2PrePi{1},2);
AllCoh=[];
subplot(221)
hold on
for freq=1:length(AllFreq)
    plot(Coherence{3},runmean(mean(abs(MeanCoh{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
xlim([0 23])
title('Coh OB-PFC')

subplot(222)
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
hold on
for freq=1:length(AllFreq)
    plot(Coherence{3},runmean(mean(abs(MeanImCoh{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
xlim([0 23])
title('ImagCoh OB-PFC')
box off
subplot(223)
hold on
for freq=1:length(AllFreq)
    plot(Coherence{3},runmean(mean(abs(MeanCohPi{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
xlim([0 23])
title('Coh OB-PFC')
subplot(224)
MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
hold on
for freq=1:length(AllFreq)
    plot(Coherence{3},runmean(mean(abs(MeanImCohPi{freq})),3),'linewidth',3,'color',cols(freq,:)), hold on
end
xlim([0 23])
title('Coh OB-PiCx')
box off


