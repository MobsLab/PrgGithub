cd /media/DataMOBsRAIDN/ProjetAversion/BackUp_Manuscript_042018/FiguresLaserHzFear/ForPaperFigure
load('SpectraAndCoherenceData.mat')
AllFreq=[1,2,4,7,10,13,15,20];

FreqLenght=size(Spec2PrePi{1},2);
AllCoh=[];
MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
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



AllCoh = [];
hold on
for freq=1:length(AllFreq)-1
    FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
    AllCoh=[AllCoh;(max(DurSpec{freq}(:,FreqLims)')-max(BefSpec(:,FreqLims)'))];

end

figure
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
A = {AllCoh(3,:),AllCoh(4,:),AllCoh(5,:),AllCoh(6,:)};
MakeSpreadAndBoxPlot_SB(A,{cols(3,:),cols(4,:),cols(5,:),cols(6,:)},[1,2,3,4],{'4Hz','7Hz','10Hz','13Hz'},0,0)

% PlotErrorBarN_KJ(AllCoh(3:6,:)','showpoints',0,'barcolors',{cols(3,:),cols(4,:),cols(5,:),cols(6,:)})
makepretty
ylabel('Post - Pre power')
% set(gca,'XTick',[1:3],'XTickLabel',{'4Hz','7Hz','10Hz','13Hz'})
xlim([0.3 4.7])



%% PFC
cd /media/DataMOBsRAIDN/ProjetAversion/BackUp_Manuscript_042018/FiguresLaserHzFear/ForPaperFigure
load('SpectraAndCoherenceData.mat')

FreqLenght=size(Spec2PrePi{1},2);
AllCoh=[];
MiceTogether={{1,2,3,4},{5,6},{7,8,9,10},{11,12,13,14}};
clear DurSpec
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



AllFreq=[1,2,4,7,10,13,15,20];
AllCoh = [];
hold on
for freq=1:length(AllFreq)-1
    FreqLims=find(Coherence{3}<AllFreq(freq)+1 & Coherence{3}>AllFreq(freq)-1);
    AllCoh=[AllCoh;(max(DurSpec{freq}(:,FreqLims)')-max(BefSpec(:,FreqLims)'))];

end

figure
cols=lines(8);
cols=cols([1,6,5,3,2],:);cols=[[0 0 0.5];cols;[0.8 0 0;0.5 0 0]];
A = {AllCoh(3,:),AllCoh(4,:),AllCoh(5,:),AllCoh(6,:)};
MakeSpreadAndBoxPlot_SB(A,{cols(3,:),cols(4,:),cols(5,:),cols(6,:)},[1,2,3,4],{'4Hz','7Hz','10Hz','13Hz'},0,0)
makepretty
ylabel('Post - Pre power')
xlim([0.3 4.7])
