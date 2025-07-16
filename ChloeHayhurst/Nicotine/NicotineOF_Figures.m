%% Figures exploring Nicotine OF in more depth

Cols2= [0.3 0.3 0.3];
Cols1= [0.7 0.7 0.7];


Data_to_use = HeartRate_Norm.NicotineOF.Pre; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h1=shadedErrorBar(linspace(0,15,100) , nanmean(Data_to_use) , Conf_Inter,'b',1);
h1.mainLine.Color=Cols1; h1.patch.FaceColor=Cols1; h1.edge(1).Color=Cols1; h1.edge(2).Color=Cols1;
hold on;
makepretty
Data_to_use = HeartRate_Norm.NicotineOF.Post; Data_to_use(Data_to_use==0)=NaN;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
h2=shadedErrorBar(linspace(0,15,100) , nanmean(Data_to_use) , Conf_Inter,'b',1);
h2.mainLine.Color=Cols2; h2.patch.FaceColor=Cols2; h2.edge(1).Color=Cols2; h2.edge(2).Color=Cols2;
makepretty

legend([h1.mainLine h2.mainLine],'Saline','Nicotine')

figure('Color',[1 1 1]), hold on

for mouse = 1:length(Mouse_names_Nic)
    subplot(3,8,mouse), hold on
    plot(linspace(0,15,100),HeartRate_Norm.NicotineOF.Pre(mouse,:),'k')
    plot(linspace(0,15,100),HeartRate_Norm.NicotineOF.Post(mouse,:),'r')
    ylim([10 14])
    xlim([0 10])
    title(Mouse_names_Nic{mouse})
    subplot(3,8,mouse+8), hold on
    plot(linspace(0,15,100),HeartRateVar_Norm.NicotineOF.Pre(mouse,:),'k')
    plot(linspace(0,15,100),HeartRateVar_Norm.NicotineOF.Post(mouse,:),'r')
    ylim([0 0.2])
    xlim([0 10])
    
    subplot(3,8,mouse+16)
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [DistanceToCenter_mean.NicotineOF.Pre(mouse) ; DistanceToCenter_mean.NicotineOF.Post(mouse)];
    b = bar(x,vals);
    ylim([0 0.5])
    
end



figure('Color',[1 1 1]), hold on

for mouse = 1:length(Mouse_names_Nic)
    subplot(3,8,mouse), hold on
    plot(linspace(0,15,100),HeartRate_Norm.NicotineOF.Pre(mouse,:),'k')
    plot(linspace(0,15,100),HeartRate_Norm.NicotineOF.Post(mouse,:),'r')
    ylim([10 14])
    xlim([0 10])
    title(Mouse_names_Nic{mouse})
    subplot(3,8,mouse+8), hold on
    plot(linspace(0,15,100),HeartRateVar_Norm.NicotineOF.Pre(mouse,:),'k')
    plot(linspace(0,15,100),HeartRateVar_Norm.NicotineOF.Post(mouse,:),'r')
    ylim([0 0.2])
    xlim([0 10])
    
    subplot(3,8,mouse+16)
    x = categorical({'OFPre','OFPost'});
    x = reordercats(x,{'OFPre','OFPost'});
    vals = [FreezeTimeAcc.NicotineOF.Pre(mouse) ; FreezeTimeAcc.NicotineOF.Post(mouse)];
    b = bar(x,vals);
    ylim([0 200])
    
end

%%

figure('color',[1 1 1])

Cols={[0.7 0.7 0.7],[0.3 0.3 0.3]};
X=[1:2];
Legends={'Saline','Nicotine'};

MakeSpreadAndBoxPlot3_SB({HRNormPrePost_mean.SalineOF HRNormPrePost_mean.NicotineOF},Cols,X,Legends,'showpoints',1,'paired',0,'optiontest','ttest')
makepretty_CH
ylabel('Mean Heart Rate Pre-Post')

figure
PlotCorrelations_BM(HRNormPrePost_mean.SalineOF , DistanceToCenter_mean.SalineOF.Post)

figure
PlotCorrelations_BM(HRNormPrePost_mean.NicotineOF , FreezeTimeAcc.NicotineOF.Post)


