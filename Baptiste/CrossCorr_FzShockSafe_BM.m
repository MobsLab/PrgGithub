

%% PAG
Mouse=Drugs_Groups_UMaze_BM(9);
Session_type={'Cond'}; sess=1;

[OutPutData , Epoch1 , NameEpoch] = MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'respi_freq_bm');

for mouse=1:length(Mouse)
    High_Respi_Fz{mouse} = thresholdIntervals(OutPutData.respi_freq_bm.tsd{mouse,3} , 4 , 'Direction','Above');
    Low_Respi_Fz{mouse} = thresholdIntervals(OutPutData.respi_freq_bm.tsd{mouse,3} , 4 , 'Direction','Below');
end

for mouse=1:length(Mouse)
    TotDur = max(Range(OutPutData.respi_freq_bm.tsd{mouse,1}));
    try
        for bin=1:round(TotDur/60e4)
            SmallEp = intervalSet((bin-1)*60e4 , bin*60e4);
            
            Shocks{sess}(mouse,bin) = length(Start(and(Epoch1{mouse,2} , SmallEp)));

            FreezeShock_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(Epoch1{mouse,5} , SmallEp)))/sum(DurationEpoch(SmallEp));
%             FreezeSafe_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(Epoch1{mouse,3}-Epoch1{mouse,5} , SmallEp)))/sum(DurationEpoch(SmallEp));
            FreezeSafe_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(Epoch1{mouse,6} , SmallEp)))/sum(DurationEpoch(SmallEp));
            
            PropHigh_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(High_Respi_Fz{mouse} , SmallEp)))/sum(DurationEpoch(SmallEp));
            PropLow_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(Low_Respi_Fz{mouse} , SmallEp)))/sum(DurationEpoch(SmallEp));
        end
    end
    disp(mouse)
end

clear r1 r2 r3 r4 lags1 lags2 lags3 lags4
figure, n=1;
for mouse=1:length(Mouse)
    [r1(mouse,:) , lags1] = xcorr(FreezeShock_Prop_Minbin{1}(mouse,1:38) , FreezeSafe_Prop_Minbin{1}(mouse,1:38));
    [r2(mouse,:) , lags2] = xcorr(PropHigh_Prop_Minbin{1}(mouse,1:38) , PropLow_Prop_Minbin{1}(mouse,1:38));
    Skew_Data_Side(mouse) = skewness(r1(mouse,:));
    Skew_Data_Type(mouse) = skewness(r2(mouse,:));
    
    for i=1:10
        rand_num = ceil(rand()*20);
        while rand_num==mouse
            rand_num = ceil(rand()*20);
        end
        [r1_ctrl(n,:) , lags1] = xcorr(FreezeShock_Prop_Minbin{1}(rand_num,1:38) , FreezeSafe_Prop_Minbin{1}(mouse,1:38));
        [r2_ctrl(n,:) , lags2] = xcorr(PropHigh_Prop_Minbin{1}(rand_num,1:38) , PropLow_Prop_Minbin{1}(mouse,1:38));
        Skew_Data_SideCtrl(n) = skewness(r1_ctrl(n,:));
        Skew_Data_TypeCtrl(n) = skewness(r2_ctrl(n,:));
        
        n=n+1;
    end
    disp(mouse)
end
close
r1(sum(r1'==0)==length(r1),:) = NaN;
r2(sum(r2'==0)==length(r2),:) = NaN;
r1_ctrl(sum(r1_ctrl'==0)==length(r1_ctrl),:) = NaN;
r2_ctrl(sum(r2_ctrl'==0)==length(r2_ctrl),:) = NaN;



figure
plot(r')
plot(r2')

plot(Data_to_use')

figure
subplot(131)
Data_to_use = r1_ctrl;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(lags1 , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
Data_to_use = r1;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(lags1 , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
xlabel('lag (min)'), ylabel('R values')
vline(0,'--r'), ylim([0 1])
title('Cross-corr shock/safe side')
box off
makepretty
f=get(gca,'Children'); legend([f(8),f(4)],'Shuffle','Data');

subplot(132)
Data_to_use = r2_ctrl;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(lags2 , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
Data_to_use = r2;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(lags2 , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
xlabel('lag (min)'), ylabel('R values')
vline(0,'--r')
title('Cross-corr Breathing>4Hz/Breathing<4Hz')
makepretty

Cols = {[.5 .5 .5],[1 0 0]};
X = [1:2];
Legends = {'Shuffle','Data'};


subplot(165)
MakeSpreadAndBoxPlot3_SB({Skew_Data_SideCtrl Skew_Data_Side},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('skewness index, side')

subplot(166)
MakeSpreadAndBoxPlot3_SB({Skew_Data_Type Skew_Data_TypeCtrl},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('skewness index, mode')




% example using mouse 514
figure, i=15;
subplot(211)
plot(FreezeShock_Prop_Minbin{1}(i,:),'r' , 'LineWidth',2)
hold on
plot(FreezeSafe_Prop_Minbin{1}(i,:),'-b' , 'LineWidth',2)
ylabel('proportion')
yyaxis right
a=bar(Shocks{sess}(i,:)); a.FaceColor=[.2 .2 .2]; a.FaceAlpha=.3;
ax = gca; ax.YColor = [.5 .5 .5];
ylabel('shocks (#)'), xlim([0 42])
makepretty
legend('shock side','safe side')

subplot(212)
plot(PropHigh_Prop_Minbin{1}(i,:),'r' , 'LineWidth',2)
hold on
plot(PropLow_Prop_Minbin{1}(i,:),'-b' , 'LineWidth',2)
ylabel('proportion')
yyaxis right
a=bar(Shocks{sess}(i,:)); a.FaceColor=[.2 .2 .2]; a.FaceAlpha=.3;
ax = gca; ax.YColor = [.5 .5 .5];
ylabel('shocks (#)'), xlim([0 42])
makepretty
legend('Fz>4Hz','Fz<4Hz')





%% eyelid
load('/media/nas7/ProjetEmbReact/DataEmbReact/Control_TemporalBiased.mat')

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=3:4
        Sessions_List_ForLoop_BM
        if sess~=2
            try
                for bin=1:round(TotDur.(Session_type{sess}).(Mouse_names{mouse})/60e4)
                    SmallEp = intervalSet((bin-1)*60e4 , bin*60e4);
                    FreezeAll_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                    FreezeShock_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                    FreezeSafe_Prop_Minbin{sess}(mouse,bin) = sum(DurationEpoch(and(FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) , SmallEp)))/sum(DurationEpoch(SmallEp));
                end
            end
        end
    end
    disp(mouse)
end
            
clear R P r
figure
for mouse=1:51
    [r(mouse,:) , lags] = xcorr(FreezeShock_Prop_Minbin{3}(mouse,:) , FreezeSafe_Prop_Minbin{3}(mouse,:));
%         for i=1:20
%             try
%                 A = FreezeShock_Prop_Minbin{3}(mouse,:);
%                 B = FreezeSafe_Prop_Minbin{3}(mouse,:);
%                 [R{i}(mouse),P{i}(mouse)]=PlotCorrelations_BM(A(1:end-i+1),B(i:end));
%                 [R2{i}(mouse),P2{i}(mouse)]=PlotCorrelations_BM(A(i:end),B(1:end-i+1));
%             end
%         end
    disp(mouse)
end
close
r(sum(r'==0)==length(r),:) = NaN;



figure
plot(r')

figure
Data_to_use = r;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(lags , Mean_All_Sp,Conf_Inter,'-k',1); hold on;
xlabel('lag (min)'), ylabel('R values'), ylim([-.05 .75])
line([-5 -5],[-.05 .5934],'LineStyle','--','Color','r')
line([-100 -5],[.5934 .5934],'LineStyle','--','Color','r')


for i=1:20
    R_corr{i} = R{i}; %R_corr{i}(P{i}>.05)=NaN;
    R_corr2{i} = R2{i}; %R_corr2{i}(P2{i}>.05)=NaN;
    Cols{i}=[.15+i/30 .15+i/30 .15+i/30];
    Legends{i}=num2str(i);
    N(i)=sum(P{i}<.05);
    N2(i)=sum(P2{i}<.05);
end
X=[1:20];

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(R_corr,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-1 1]), xlabel('shift in min'), hline(0,'--r'), ylabel('R values')

subplot(132)
MakeSpreadAndBoxPlot3_SB(P,Cols,X,Legends,'showpoints',1,'paired',0);
set(gca , 'Yscale','log')
ylim([1e-6 2])
hline(.05,'--r'), xlabel('shift in min'), ylabel('p values')

subplot(133)
bar(N/51)
xticks([1:20]), xticklabels(Legends), xtickangle(45)
xlabel('shift in min'), ylabel('significative correlations (prop)')



figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(R_corr2,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-1 1]), xlabel('shift in min'), ylabel('R values'), hline(0,'--r')

subplot(132)
MakeSpreadAndBoxPlot3_SB(P2,Cols,X,Legends,'showpoints',1,'paired',0);
set(gca , 'Yscale','log')
ylim([1e-6 2])
hline(.05,'--r'), xlabel('shift in min'), ylabel('p values')

subplot(133)
bar(N2/51)
xticks([1:20]), xticklabels(Legends), xtickangle(45)
xlabel('shift in min'), ylabel('significative correlations (prop)')




Data_to_use = R;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:10] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;

subplot(122)
Data_to_use = P;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:10] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;




figure
subplot(121)
Data_to_use = R_corr;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar([1:10] , Mean_All_Sp , Conf_Inter,'-k',1); hold on;






figure
subplot(211)
bar([FreezeShock_Prop_Minbin{3}(30,:) FreezeShock_Prop_Minbin{4}(30,:)])
subplot(212)
bar([FreezeSafe_Prop_Minbin{3}(30,:) FreezeSafe_Prop_Minbin{4}(30,:)])




figure
subplot(211)
bar(FreezeShock_Prop_All(30,20:60))
subplot(212)
bar(FreezeSafe_Prop_All(30,20:60))





figure
plot(r')








