Dir{1}=PathForExperiments_Opto_MC('PFC_Control_20Hz');
Dir{2}=PathForExperiments_Opto_MC('PFC_Stim_20Hz');

number=1;
for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
    [SpREM,idxBetaREM,facREM,freqB,temps] = PlotBETAPowerOverTime_SingleMouse_MC2;
    SpectroREM{i}=SpREM;
    FacREM{i}=facREM;
    BetaIndxREM{i}=idxBetaREM;
    
    for ii=1:length(BetaIndxREM)
        AvBetaREM(ii,:)=nanmean(BetaIndxREM{ii}(:,:),1);
    end
    
    MouseId(number) = Dir{1}.nMice{i} ;
    number=number+1;
end



clear SpREM idxBetaREM freqB temps

numberOpto=1;
for j=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{j}{1});
    
    [SpREM,idxBetaREM,facREM,freqB,temps]=PlotBETAPowerOverTime_SingleMouse_MC2;
    SpectroREMopto{j}=SpREM;
    FacREMopto{j}=facREM;
    BetaIndxREMopto{j}=idxBetaREM;

      for jj=1:length(BetaIndxREMopto)
        AvBetaREMopto(jj,:)=nanmean(BetaIndxREMopto{jj}(:,:),1);
      end
    
    MouseId(numberOpto) = Dir{2}.nMice{j} ;
    numberOpto=numberOpto+1;
end
%%
dataFacREM=cat(3,FacREM{:});
avFacREM=nanmean(dataFacREM,3);

dataFacREMopto=cat(3,FacREMopto{:});
avFacREMopto=nanmean(dataFacREMopto,3);

dataSpREM=cat(3,SpectroREM{:});
dataSpREMopto=cat(3,SpectroREMopto{:}); 

avdataSpREM=nanmean(dataSpREM,3);
avdataSpREMopto=nanmean(dataSpREMopto,3);

%% imagesc(Spectro{2},Spectro{3},10*log10(Spectro{1}')), axis xy
figure('color',[1 1 1]),subplot(4,4,[1,2]),imagesc(temps,freqB, avdataSpREMopto),axis xy,colormap(jet)
% caxis([70 90])
line([0 0],ylim,'color','w','linestyle','-')
xlim([-30 +30])
 ylim([10 30])
ylabel('Frequency (Hz)')
colorbar
title('OB REM opto ')
subplot(4,4,[5,6]),imagesc(temps,freqB, avdataSpREM),axis xy,colormap(jet)
% caxis([70 90])
line([0 0],ylim,'color','w','linestyle','-')
xlim([-30 +30])
 ylim([10 30])
ylabel('Frequency (Hz)')
colorbar
title('OB REM control')

beforeidx=find(temps>-15&temps<-1);
duringidx=find(temps>1&temps<15);

subplot(4,4,[9,10,13,14]),shadedErrorBar(temps,AvBetaREM/avFacREM,{@mean,@stdError},'-k',1);
hold on,
shadedErrorBar(temps,AvBetaREMopto/avFacREMopto,{@mean,@stdError},'-b',1);
xlim([-30 +30])
% ylim([0.7 1.3])
line([0 0], ylim,'color','k','linestyle',':')
xlabel('Time (s)')
ylabel('beta power')

subplot(4,4,[3,7]),PlotErrorBarN_KJ({mean(AvBetaREMopto(:,beforeidx)/avFacREMopto,2), mean(AvBetaREMopto(:,duringidx)/avFacREMopto,2)},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'before','during'})
% ylim([0 2.5])
title('opto')
subplot(4,4,[4,8]),
PlotErrorBarN_KJ({mean(AvBetaREM(:,beforeidx)/avFacREM,2), mean(AvBetaREM(:,duringidx)/avFacREM,2)},'newfig',0,'paired',0,'ShowSigstar','sig');
xticks([1 2])
xticklabels({'before','during'})
% ylim([0 2.5])
title('ctrl')
