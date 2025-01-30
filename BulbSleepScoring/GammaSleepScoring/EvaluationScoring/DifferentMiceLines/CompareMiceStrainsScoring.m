cd /media/DataMOBsRAIDN/ProjetSlSc/FiguresReview/NewMiceStrains/%close all,
clear all
MouseLine{1} = load('OverlapStateByState_C57Bl6.mat');
MouseLine{2} = load('OverlapStateByState_GADCre.mat');
MouseLine{3} = load('OverlapStateByState_C3H.mat');
MouseLine{4} = load('OverlapStateByState_DBA.mat');
MouseName = {'C57','GAD','C3H','DBA'};
MouseLine{1}.Spec.Wake.Lin([2,3,5],:)=NaN;
MouseLine{1}.Spec.NREM.Lin([2,3,5],:)=NaN;
figure


% One fig per strain
cols = lines(4);
figure
clf
for k = 1:length(MouseLine)
    subplot(1,4,k)
    data_temp = (MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color',cols(k,:),'linewidth',4)
    hold on
    g=shadedErrorBar(MouseLine{1}.fH,runmean(nanmean(data_temp),4),runmean(stdError(data_temp),4));
    set(g.patch,'FaceColor',cols(k,:),'FaceAlpha',0.7)
    hold on
    box off
    set(gca,'FontSize',15)
    xlim([20 100])
    xlabel('Frequency')
    ylabel('Wake Power - Sleep Power')
end

for k = 1:length(MouseLine)
    figure
    data_temp = zscore(MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    data_ref = zscore(MouseLine{1}.Spec.Wake.Lin'-MouseLine{1}.Spec.NREM.Lin')';
    g=shadedErrorBar(MouseLine{1}.fH,runmean(nanmean(data_temp),4),runmean(stdError(data_temp),4));
    set(g.patch,'FaceColor',cols(k,:),'FaceAlpha',0.7)
    hold on
    g=shadedErrorBar(MouseLine{1}.fH,runmean(nanmean(data_ref),4),runmean(stdError(data_ref),4));
    set(g.patch,'FaceColor',cols(1,:),'FaceAlpha',0.7)
    box off
    set(gca,'FontSize',15)
    xlim([20 100])
    xlabel('Frequency')
    ylabel('Wake Power - Sleep Power (zscore)')

end

figure
% straight
subplot(121)
cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = (MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color',cols(k,:),'linewidth',4)
    hold on
end
box off
cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = (MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    g=shadedErrorBar(MouseLine{1}.fH,runmean(nanmean(data_temp),4),runmean(stdError(data_temp),4));
    set(g.patch,'FaceColor',cols(k,:),'FaceAlpha',0.3)
    hold on
end
box off

cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = (MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color',cols(k,:),'linewidth',4)
    hold on
end
box off
line([50 50],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
line([70 70],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
legend({'C57','GAD','C3H','DBA'},'Location','northwest')
xlabel('Frequency (Hz)'), ylabel('Wake - Sleep Power')
set(gca,'FontSize',15,'Linewidth',2)

% zscore
subplot(122)
cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = zscore(MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color',cols(k,:),'linewidth',4)
    hold on
end
box off

cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = zscore(MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    g=shadedErrorBar(MouseLine{1}.fH,runmean(nanmean(data_temp),4),runmean(stdError(data_temp),4));
    set(g.patch,'FaceColor',cols(k,:),'FaceAlpha',0.3)
    hold on
end
box off

cols = lines(4)
for k = 1:length(MouseLine)
    data_temp = zscore(MouseLine{k}.Spec.Wake.Lin'-MouseLine{k}.Spec.NREM.Lin')';
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color',cols(k,:),'linewidth',4)
    hold on
end
box off
line([50 50],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
line([70 70],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
xlabel('Frequency (Hz)'), ylabel('Wake - Sleep Power (zscore)')
set(gca,'FontSize',15,'Linewidth',2)



figure
% straight
for k = 1:length(MouseLine)
    subplot(1,4,k)
    data_temp = (MouseLine{k}.Spec.Wake.Lin);
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color','k','linewidth',4)
    hold on
    data_temp = (MouseLine{k}.Spec.NREM.Lin);
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color','b','linewidth',4)
    data_temp = (MouseLine{k}.Spec.REM.Lin);
    plot(MouseLine{1}.fH,runmean(nanmean(data_temp),4),'color','r','linewidth',4)
    title(MouseName{k})
    box off
    line([50 50],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
    line([70 70],ylim,'color',[0.3 0.3 0.3],'linewidth',2)
    xlabel('Frequency (Hz)'), ylabel('Power')
    set(gca,'FontSize',15,'Linewidth',2)
    xlim([20 100])
end


%% Evaluate scoring
figure
clf
for k = 1:length(MouseLine)
    subplot(1,4,k)
    StateComp = MouseLine{k}.StateComp;
    
    SWSprop=[(StateComp{2}./StateComp{1}),(StateComp{4}./StateComp{1}),...
        (StateComp{3}./StateComp{1})];
    REMprop=[(StateComp{8}./StateComp{5}),(StateComp{6}./StateComp{5}),...
        ((StateComp{7}./StateComp{5}))];
    Wakeprop=[(StateComp{11}./StateComp{9}),(StateComp{12}./StateComp{9}),...
        (StateComp{10}./StateComp{9})];
    g=bar([1:3],[SWSprop;REMprop;Wakeprop],'Stack'); hold on
    set(gca,'XTick',[1:3],'XTickLabel',{'SWS','REM','Wake'})
    set(g(1),'FaceColor',[0.4 0.5 1])
    set(g(2),'FaceColor',[1 0.2 0.2])
    set(g(3),'FaceColor',[0.6 0.6 0.6])
    xlim([0.5 3.5])
    ylim([0 1.1])
    box off
    text(0.65,0.5,[num2str(round(mean(StateComp{2}./StateComp{1})*1000)/10), '%'],'FontSize',15)
    text(1.65,0.5,[num2str(round(mean(StateComp{6}./StateComp{5})*1000)/10), '%'],'FontSize',15)
    text(2.65,0.5,[num2str(round(mean(StateComp{10}./StateComp{9})*1000)/10), '%'],'FontSize',15)
    title(MouseName{k})
    set(gca,'FontSize',15,'Linewidth',2)
    ylabel('Proportion')
end

figure
clf
for k = 1:length(MouseLine)
    subplot(1,4,k)
    Dur_disagree_S_W = MouseLine{k}.Dur_disagree_S_W;
    Dur_disagree_W_S= MouseLine{k}.Dur_disagree_W_S;
    
    AllData = [];
    for h = 1 :length(Dur_disagree_S_W)
        AllData = [AllData;Dur_disagree_S_W{h}];
    end
    for h = 1 :length(Dur_disagree_W_S)
        AllData = [AllData;Dur_disagree_W_S{h}];
    end
    histogram(AllData,[0:0.5:200],'Normalization','Probability')
    text(40,0.05,[num2str(round((sum(AllData<5)./length(AllData))*1000)/10) '%'])
    xlim([0 60]), ylim([0 0.1])
    title(MouseName{k})
    box off
    xlabel('Duration'), ylabel('Probability')
    set(gca,'FontSize',15,'Linewidth',2)
    
end


