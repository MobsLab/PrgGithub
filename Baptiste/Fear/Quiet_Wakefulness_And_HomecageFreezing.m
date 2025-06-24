
% Is freezing in the homecage after conditionning is safe ?

clear all
GetAllSalineSessions_BM
Group=22;
Session_type = {'SleepPre','SleepPost'};
Mouse=Drugs_Groups_UMaze_BM(Group);

smoofact_Acc = 30;
th_immob_Acc = 1.7e7;
thtps_immob=2;

for sess=2%1:2
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];

        try
            clear Sleep MovAcctsd NewMovAcctsd FreezeAccEpoch B
            load([SleepSess.(Mouse_names{mouse}){sess} 'StateEpochSB.mat'], 'Sleep')
            load([SleepSess.(Mouse_names{mouse}){sess} 'behavResources.mat'], 'MovAcctsd')
            B = load([SleepSess.(Mouse_names{mouse}){sess} 'B_Low_Spectrum.mat']);
            B_Sptsd = tsd(B.Spectro{2}*1e4 , B.Spectro{1});
            
            Sleep = dropShortIntervals(Sleep,20e4);
            Sleep_St = Start(Sleep) ;
            Wake_Before_Sleep_Epoch = intervalSet(0 , Sleep_St(1));
            
            NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
            FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
            FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
            FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
            
            Fz_HC{sess}(mouse) = sum(DurationEpoch(and(Wake_Before_Sleep_Epoch , FreezeAccEpoch)))/60e4;
            Fz_HC_prop{sess}(mouse) = sum(DurationEpoch(and(Wake_Before_Sleep_Epoch , FreezeAccEpoch)))/sum(DurationEpoch(Wake_Before_Sleep_Epoch));
            Fz_HC_prop_all{sess}(mouse) = sum(DurationEpoch(and(Wake_Before_Sleep_Epoch , FreezeAccEpoch)))/max(Range(NewMovAcctsd));
        
            Sleep_HC{sess}(mouse) = sum(DurationEpoch(Sleep))/60e4;
            Sleep_prop{sess}(mouse) = sum(DurationEpoch(Sleep))/max(Range(NewMovAcctsd));
        
%             OB{sess,mouse} = Restrict(B_Sptsd , and(Wake_Before_Sleep_Epoch , FreezeAccEpoch));
%             OB_MeanSp_Fz_HC(sess,mouse,:) = nanmean(Data(OB{sess,mouse}));
%             Respi = ConcatenateDataFromFolders_SB({SleepSess.(Mouse_names{mouse}){sess}} , 'respi_freq_bm');
%             Respi_Fz_HC{sess,mouse} = Restrict(Respi , and(Wake_Before_Sleep_Epoch , FreezeAccEpoch));
%             
%             Ripples = ConcatenateDataFromFolders_SB({SleepSess.(Mouse_names{mouse}){sess}} , 'ripples');
%             RipplesDensity_Fz_HC(sess,mouse) = length(Restrict(Ripples , and(Wake_Before_Sleep_Epoch , FreezeAccEpoch)))./(sum(DurationEpoch(and(Wake_Before_Sleep_Epoch , FreezeAccEpoch)))/1e4);
        end
        disp(mouse)
    end
    Fz_HC{sess}(Fz_HC{sess}==0) = NaN;
    Fz_HC_prop{sess}(Fz_HC_prop{sess}==0) = NaN;
    Fz_HC_prop_all{sess}(Fz_HC_prop_all{sess}==0) = NaN;
    Sleep_HC{sess}(Sleep_HC{sess}==0) = NaN;
    Sleep_prop{sess}(Sleep_prop{sess}==0) = NaN;
    Fz_HC{sess}(Fz_HC{sess}>20) = NaN;
    Fz_HC_prop{sess}(Fz_HC_prop{sess}>.4) = NaN;
end
RipplesDensity_Fz_HC(RipplesDensity_Fz_HC==0) = NaN;

Cols = {[.1 .4 .7],[.7 .4 .1]};
X = [1 2];
Legends = {'Sleep Pre','Sleep Post'};


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Fz_HC,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('homecage immobility (min)')
subplot(122)
MakeSpreadAndBoxPlot3_SB(Fz_HC_prop,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('homecage immobility (prop)')


figure
Plot_MeanSpectrumForMice_BM(squeeze(OB_MeanSp_Fz_HC(1,:,:)) , 'color' , [.1 .4 .7] , 'threshold' , 13)
Plot_MeanSpectrumForMice_BM(squeeze(OB_MeanSp_Fz_HC(2,:,:)) , 'color' , [.7 .4 .1] , 'threshold' , 13)
xlim([0 10]), ylim([0 1])
box off
f=get(gca,'Children'); l=legend([f([8 4])],'Sleep Pre','Sleep Post');


figure
MakeSpreadAndBoxPlot3_SB({RipplesDensity_Fz_HC(1,:) RipplesDensity_Fz_HC(2,:)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SWR occurence, immobility (#/s)')


figure
i=1;
for mouse=1:30
    subplot(3,4,i)
    try, plot(Data(Respi_Fz_HC{1,mouse})), i=i+1; end
end

figure
i=1;
for mouse=1:30
    subplot(4,5,i)
    try, plot(Data(Respi_Fz_HC{2,mouse})), i=i+1; end
end





