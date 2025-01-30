

function Transition_Wake_Sleep_Ferret_BM

smootime = 3;
path{1} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20221221_long';
path{2} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20230302_saline/';
path{3} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20230309_3/';
path{4} = '/media/nas7/React_Passive_AG/OBG/Labneh/freely-moving/20230621/';
path{5} = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240122/';
path{6} = '/media/nas7/React_Passive_AG/OBG/Brynza/freely-moving/20240123_long/';

n=1; m=1;
for p = 1:length(path)
    cd(path{p})
    load('SleepScoring_Accelero.mat', 'Wake', 'Sleep','Epoch', 'TotalNoiseEpoch')
    load('SleepScoring_OBGamma.mat','SmoothGamma')
    load('ChannelsToAnalyse/EMG.mat', 'channel')
    load(['LFPData/LFP' num2str(channel) '.mat'])
    load('behavResources.mat', 'MovAcctsd')
    
    LFP = Restrict(LFP , Epoch);
    FilLFP = FilterLFP(LFP,[50 300],1024);
    EMG_tsd = tsd(Range(FilLFP),runmean(Data((FilLFP)).^2,ceil(smootime/median(diff(Range(FilLFP,'s'))))));
    Acc_tsd = tsd(Range(MovAcctsd),runmean_BM(Data(MovAcctsd),ceil(smootime/median(diff(Range(MovAcctsd,'s'))))));

    Wake = or(Wake,TotalNoiseEpoch);
    Wake = dropShortIntervals(Wake,30e4);
    Sleep = dropShortIntervals(Sleep,30e4);
    [~,bef_cell]=transEpoch(Sleep,Wake);
    
    clear Trans_Wake_Sleep Trans_Sleep_Wake 
    Trans_Wake_Sleep = Start(bef_cell{1,2}); % beginning of all sleep that is preceded by Wake
    Trans_Sleep_Wake = Start(bef_cell{2,1}); % beginning of all Wake  that is preceded by sleep
    
    for i=1:length(Trans_Wake_Sleep)
        SmallEp = intervalSet(Trans_Wake_Sleep(i)-20e4 , Trans_Wake_Sleep(i)+20e4);
        EMG_Data_WakeSleep(n,1:length(Data(Restrict(EMG_tsd , SmallEp)))) = Data(Restrict(EMG_tsd , SmallEp));
        Gamma_Data_WakeSleep(n,1:length(Data(Restrict(SmoothGamma , SmallEp)))) = Data(Restrict(SmoothGamma , SmallEp));
        Acc_Data_WakeSleep(n,1:length(Data(Restrict(Acc_tsd , SmallEp)))) = Data(Restrict(Acc_tsd , SmallEp));
        n=n+1;
    end
    for i=1:length(Trans_Sleep_Wake)
        SmallEp = intervalSet(Trans_Sleep_Wake(i)-20e4 , Trans_Sleep_Wake(i)+20e4);
        EMG_Data_SleepWake(m,1:length(Data(Restrict(EMG_tsd , SmallEp)))) = Data(Restrict(EMG_tsd , SmallEp));
        Gamma_Data_SleepWake(m,1:length(Data(Restrict(SmoothGamma , SmallEp)))) = Data(Restrict(SmoothGamma , SmallEp));
        Acc_Data_SleepWake(m,1:length(Data(Restrict(Acc_tsd , SmallEp)))) = Data(Restrict(Acc_tsd , SmallEp));
        m=m+1;
    end
    
    disp(p)
end


EMG_Data_WakeSleep([1 3 5 6],:) = NaN;
Gamma_Data_WakeSleep([1 4:6 8 11:14],:) = NaN;
Acc_Data_WakeSleep([1 4:6 8 11:14],:) = NaN;



figure
subplot(121)
Data_to_use = zscore(EMG_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,5e2) , runmean(Conf_Inter,5e2),'-k',1); hold on;
color= [.3 .5 .7]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Gamma_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,5e2) , runmean(Conf_Inter,5e2),'-k',1); hold on;
color= [.7 .5 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Acc_Data_WakeSleep')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(Acc_Data_WakeSleep)) , runmean(Mean_All_Sp,2e1) , runmean(Conf_Inter,2e1),'-k',1); hold on;
color= [.5 .7 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
vline(0,'--r'), xlabel('time (s)'), ylabel('Norm. power'), ylim([-1.5 2.5])
f=get(gca,'Children'); l=legend([f([12 8 4])],'EMG','OB','Acc'); 
makepretty
text(-7,2.5,'Wake','FontSize',15), text(3,2.5,'Sleep','FontSize',15)

subplot(122)
Data_to_use = zscore(EMG_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,5e2) , runmean(Conf_Inter,5e2),'-k',1); hold on;
color= [.3 .5 .7]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Gamma_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(EMG_Data_WakeSleep)) , runmean(Mean_All_Sp,5e2) , runmean(Conf_Inter,5e2),'-k',1); hold on;
color= [.7 .5 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
Data_to_use = zscore(Acc_Data_SleepWake')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1)); Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-10,10,length(Acc_Data_SleepWake)) , runmean(Mean_All_Sp,2e1) , runmean(Conf_Inter,2e1),'-k',1); hold on;
color= [.5 .7 .3]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
makepretty
text(-7,2,'Sleep','FontSize',15), text(3,2.5,'Wake','FontSize',15)
vline(0,'--r'), xlabel('time (s)'), ylabel('Norm. power'), ylim([-1.5 2.5])




