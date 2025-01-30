
% load('DeltaWaves.mat');
% Deltas=alldeltas_PFCx;
% Delta_min=Deltaperminute(Deltas);
% Deltam=Delta_min;
% 
% 
% 
% load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
% ax1_Baseline1=linspace(0,length(Deltam)*60,length(Deltam));
% figure
% bar(ax1_Baseline1,Deltam), hold on
% ylabel('Number of Delta')
% yyaxis right
% SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0);
% set(gca,'ytick',[-1:4])
% set(gca,'yticklabel',{'Noise',' ','SWS',' ','REM','Wake'})
% ylim([-1.5 4.5])
% xlabel('Time (s)')
% title('Number of Deltas wave per minute 1106 NaCl')
% 
% [C1,B1]=CrossCorr(StimREM,Start(Deltas),1200,100);
% figure, plot(B1/1E3,C1,'r')

% Dir{1}=PathForExperiments_DREADD_MC('1Inj2mg_CtrlMice_Nacl');
% Dir{2}=PathForExperiments_DREADD_MC('1Inj2mg_CtrlMice_CNO');

Dir{1}=PathForExperiments_DREADD_MC('1Inj2mg_Nacl');
Dir{2}=PathForExperiments_DREADD_MC('1Inj2mg_CNO');


% Dir{1}=PathForExperiments_DREADD_MC('1Inj1mg_Nacl');
% Dir{2}=PathForExperiments_DREADD_MC('1Inj1mg_CNO');

% Dir{1}=PathForExperiments_DREADD_MC('DREADD_Nacl');
% Dir{2}=PathForExperiments_DREADD_MC('DREADD_CNO');

for i=1:length(Dir{1}.path)
    cd(Dir{1}.path{i}{1});
    
%     load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    load StateEpochSBAllOB REMEpoch SWSEpoch Wake

    REMEp{i}=REMEpoch;
    WakeEp{i}=Wake;
    SWSEp{i}=SWSEpoch;
    durtotal{i}=max([max(End(WakeEp{i})),max(End(SWSEp{i}))]);
    Epoch1{i}=intervalSet(0,durtotal{i}/2); %pour ne considérer que la deuxième moitié de la session (après injection)
    
    Epoch2{i}=intervalSet(durtotal{i}/2,durtotal{i}); %pour ne considérer que la deuxième moitié de la session (après injection)
    
    load DeltaWaves alldeltas_PFCx
    DeltasEp{i}=alldeltas_PFCx;
    load Ripples RipplesEpoch
    RipplesEp{i}=RipplesEpoch;
    
     DeltaPerMinBegin_sal{i}=Deltaperminute(and(DeltasEp{i},Epoch1{i}));
    RippPerMinBegin_sal{i}=RipplesPerMin(and(RipplesEp{i},Epoch1{i}));
    
    DeltaPerMinEnd_sal{i}=Deltaperminute(and(DeltasEp{i},Epoch2{i}));
    RippPerMinEnd_sal{i}=RipplesPerMin(and(RipplesEp{i},Epoch2{i}));
    
    avDeltBegin_Sal(i,:)=nanmean(DeltaPerMinBegin_sal{i});
    avRippBegin_Sal(i,:)=nanmean(RippPerMinBegin_sal{i});
    
     avDeltEnd_Sal(i,:)=nanmean(DeltaPerMinEnd_sal{i});
    avRippEnd_Sal(i,:)=nanmean(RippPerMinEnd_sal{i});
    
end



for j=1:length(Dir{2}.path)
    cd(Dir{2}.path{j}{1});
   
%     load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    load StateEpochSBAllOB REMEpoch SWSEpoch Wake

    REMEpCNO{j}=REMEpoch;
    WakeEpCNO{j}=Wake;
    SWSEpCNO{j}=SWSEpoch;
    durtotalCNO{j}=max([max(End(WakeEpCNO{j})),max(End(SWSEpCNO{j}))]);
    Epoch1CNO{j}=intervalSet(0,durtotalCNO{j}/2); %pour ne considérer que la deuxième moitié de la session (après injection)
    
    Epoch2CNO{j}=intervalSet(durtotalCNO{j}/2,durtotalCNO{j}); %pour ne considérer que la deuxième moitié de la session (après injection)
    
    load DeltaWaves alldeltas_PFCx
    DeltasEpCNO{j}=alldeltas_PFCx;
    load Ripples RipplesEpoch
    RipplesEpCNO{j}=RipplesEpoch;
    
    DeltaPerMinBegin_CNO{j}=Deltaperminute(and(DeltasEpCNO{j},Epoch1CNO{j}));
    RippPerMinBegin_CNO{j}=RipplesPerMin(and(RipplesEpCNO{j},Epoch1CNO{j}));
    
      DeltaPerMinEnd_CNO{j}=Deltaperminute(and(DeltasEpCNO{j},Epoch2CNO{j}));
    RippPerMinEnd_CNO{j}=RipplesPerMin(and(RipplesEpCNO{j},Epoch2CNO{j}));
    
    avDeltBegin_CNO(j,:)=nanmean(DeltaPerMinBegin_CNO{j});
    avRippBegin_CNO(j,:)=nanmean(RippPerMinBegin_CNO{j});
    
        avDeltEnd_CNO(j,:)=nanmean(DeltaPerMinEnd_CNO{j});
    avRippEnd_CNO(j,:)=nanmean(RippPerMinEnd_CNO{j});
end

%%
figure,PlotErrorBarN_KJ({avRippEnd_Sal avRippEnd_CNO},'newfig',0);
ylabel('density (ripples/min)')
xticks([1 2])
xticklabels({'sal','CNO'})

figure,PlotErrorBarN_KJ({avDeltEnd_Sal avDeltEnd_CNO},'newfig',0);
xticks([1 2])
xticklabels({'sal','CNO'})
ylabel('density (deltas/min)')








