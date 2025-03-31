
%% Piezo data Analysis

clear all, close all

Mouse = [1615 1616 1617 1618 1619 1620];
% Mouse = [1615 1616 1617 1619 1620];

GoodSess = [1 2 4 6:9 11:19];
soundtype = {'dB50','dB60','dB70','dB80','Orage','RU','Tono12','Sin20','TonoWN','Sin80','Tono5','RD'};
% soundtype = {'dB50','dB60','dB70','dB80'};

cc=1;
for c=GoodSess
    Dir{cc}=['/media/greta/DataMOBS198/Sounds/',num2str(c),'/'];
    Dir{cc}=['/media/greta/DataMOBS198/Sounds/',num2str(c),'/'];
    
    cd(Dir{cc})
%     keyboard
    cc=cc+1;
end
% 
for sound = 1 : length(soundtype)
    SoundTTL.(soundtype{sound}) = ConcatenateDataAudiodream_CH(Dir, 1615, 1, 'soundts', 'soundtype', soundtype{sound});
end

AllSounds=ts(sort([Range(SoundTTL.Orage); Range(SoundTTL.RU); Range( SoundTTL.Tono12); Range(SoundTTL.Sin20); Range(SoundTTL.TonoWN); Range(SoundTTL.Sin80); Range(SoundTTL.Tono5); Range(SoundTTL.RD)]));

for mouse = 1:length(Mouse)
    Mouse_name = Mouse(mouse);
    Mouse_names{mouse}=['M' num2str(Mouse_name)];
    disp(Mouse_names{mouse})
    Piezo_tsd.(Mouse_names{mouse}) = ConcatenateDataAudiodream_CH(Dir, Mouse_name, mouse, 'data');
    SleepEpoch.(Mouse_names{mouse}) = ConcatenateDataAudiodream_CH(Dir, Mouse_name, mouse, 'sleepepoch');
    TotEpoch.(Mouse_names{mouse}) = intervalSet(0,max(Range(Piezo_tsd.(Mouse_names{mouse}))));
    WakeEpoch.(Mouse_names{mouse})= TotEpoch.(Mouse_names{mouse})-SleepEpoch.(Mouse_names{mouse});
    SleepProp(mouse) = sum(DurationEpoch(SleepEpoch.(Mouse_names{mouse})))/sum(DurationEpoch(TotEpoch.(Mouse_names{mouse})));
    
    for sound = 1 : length(soundtype)
        
        temp=Range(SoundTTL.(soundtype{sound}));
        temp(isnan(temp))=[];
        SoundTTL.(soundtype{sound})=ts(temp);
        [m,s,t]=mETAverage(Range(Restrict(SoundTTL.(soundtype{sound}),SleepEpoch.(Mouse_names{mouse}))),Range(Piezo_tsd.(Mouse_names{mouse})),Data(Piezo_tsd.(Mouse_names{mouse})),10,1000);
        [M,T] = PlotRipRaw(Piezo_tsd.(Mouse_names{mouse}),  Range(Restrict(SoundTTL.(soundtype{sound}),SleepEpoch.(Mouse_names{mouse})),'s'),5000);
        m2.(soundtype{sound}){mouse} = median(T);
        m3.(soundtype{sound}){mouse} = mean(T);
        SoundNum.(soundtype{sound})(mouse)= length(SoundTTL.(soundtype{sound}));
        SoundNumSleep.(soundtype{sound})(mouse)= length(Restrict(SoundTTL.(soundtype{sound}),SleepEpoch.(Mouse_names{mouse})));
        s2.(soundtype{sound}){mouse} = s;
        mAll.(soundtype{sound})(mouse,:) = m2.(soundtype{sound}){:,mouse}';
        mAll2.(soundtype{sound})(mouse,:) = m3.(soundtype{sound}){:,mouse}';
        
        sAll.(soundtype{sound})(mouse,:) = s2.(soundtype{sound}){:,mouse}';
        meanBef.(soundtype{sound})(mouse) = nanmean(mAll.(soundtype{sound})(mouse,401:500));
        meanAft.(soundtype{sound})(mouse) = nanmean(mAll.(soundtype{sound})(mouse,501:600));
        meanBef2.(soundtype{sound})(mouse) = nanmean(mAll2.(soundtype{sound})(mouse,401:500));
        meanAft2.(soundtype{sound})(mouse) = nanmean(mAll2.(soundtype{sound})(mouse,501:600));
        
        Diff.(soundtype{sound})(mouse) = meanAft.(soundtype{sound})(mouse)-meanBef.(soundtype{sound})(mouse);
        Diff2.(soundtype{sound})(mouse) = meanAft2.(soundtype{sound})(mouse)-meanBef2.(soundtype{sound})(mouse);
        
        
        [m_awake, s_awake, t_awake] = mETAverage(Range(Restrict(SoundTTL.(soundtype{sound}), WakeEpoch.(Mouse_names{mouse}))), ...
            Range(Piezo_tsd.(Mouse_names{mouse})), Data(Piezo_tsd.(Mouse_names{mouse})), 10, 1000);
        [M_awake, T_awake] = PlotRipRaw(Piezo_tsd.(Mouse_names{mouse}), ...
            Range(Restrict(SoundTTL.(soundtype{sound}), WakeEpoch.(Mouse_names{mouse})), 's'), 5000);
        m2_awake.(soundtype{sound}){mouse} = median(T_awake);
        
        SoundNumAwake.(soundtype{sound})(mouse) = length(Restrict(SoundTTL.(soundtype{sound}), WakeEpoch.(Mouse_names{mouse})));
        
        s2_awake.(soundtype{sound}){mouse} = s_awake;
        mAllAwake.(soundtype{sound})(mouse, :) = m2_awake.(soundtype{sound}){:, mouse}';
        sAllAwake.(soundtype{sound})(mouse, :) = s2_awake.(soundtype{sound}){:, mouse}';
        meanBefAwake.(soundtype{sound})(mouse) = nanmean(mAllAwake.(soundtype{sound})(mouse, 401:500));
        meanAftAwake.(soundtype{sound})(mouse) = nanmean(mAllAwake.(soundtype{sound})(mouse, 501:600));
        DiffAwake.(soundtype{sound})(mouse) = meanAftAwake.(soundtype{sound})(mouse)-meanBefAwake.(soundtype{sound})(mouse);
        close all
        
    end
    
    start_intervals = Start(SleepEpoch.(Mouse_names{mouse}));
    stop_intervals = Stop(SleepEpoch.(Mouse_names{mouse}));
    sleep_durations = DurationEpoch(SleepEpoch.(Mouse_names{mouse}));
    total_sleep_duration = sum(sleep_durations);
    random_durations = sort(rand(1000, 1) * total_sleep_duration);
    random_timestamps = [];
    cumulative_duration = 0;
    for i = 1:length(sleep_durations)
        interval_start = start_intervals(i);
        interval_end = stop_intervals(i);
        interval_duration = sleep_durations(i);
        points_in_this_segment = random_durations(random_durations <= (cumulative_duration + interval_duration)) ...
            - cumulative_duration;
        random_durations = random_durations(random_durations > (cumulative_duration + interval_duration));
        random_timestamps = [random_timestamps; interval_start + points_in_this_segment];
        cumulative_duration = cumulative_duration + interval_duration;
    end
    
    RandomSleepTS.(Mouse_names{mouse}) = ts(random_timestamps);
%     [m,s,t]=mETAverage(Range(RandomSleepTS.(Mouse_names{mouse})),Range(Piezo_tsd.(Mouse_names{mouse})),Data(Piezo_tsd.(Mouse_names{mouse})),10,1000);
    [M,T] = PlotRipRaw(Piezo_tsd.(Mouse_names{mouse}),  Range(RandomSleepTS.(Mouse_names{mouse}),'s'),5000);
    m2Rand{mouse} = median(T);
    m3Rand{mouse} = mean(T);
    s2Rand{mouse} = s;
    mAllRand(mouse,:) = m2Rand{:,mouse}';
    mAllRand2(mouse,:) = m3Rand{:,mouse}';
    
    sAllRand(mouse,:) = s2Rand{:,mouse}';
    meanBef_Rand(mouse) = nanmean(mAllRand(mouse,401:500));
    meanAft_Rand(mouse) = nanmean(mAllRand(mouse,501:600));
    DiffRand(mouse) = meanAft_Rand(mouse)-meanBef_Rand(mouse);
    
    meanBef_Rand2(mouse) = nanmean(mAllRand2(mouse,401:500));
    meanAft_Rand2(mouse) = nanmean(mAllRand2(mouse,501:600));
    DiffRand2(mouse) = meanAft_Rand2(mouse)-meanBef_Rand2(mouse);
  
end


% 
% for mouse = 1:length(Mouse)
%     Mouse_name = Mouse(mouse);
%     Mouse_names{mouse}=['M' num2str(Mouse_name)];
%     disp(Mouse_names{mouse})
%     Piezo_tsd2.(Mouse_names{mouse}) = ConcatenateDataAudiodream_CH(Dir, Mouse_name, mouse, 'data2');
%     tsd_Sleep2.(Mouse_names{mouse}) = Restrict(Piezo_tsd2.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}));
%     for sound = 1 : length(soundtype)
%         [m,s,t]=mETAverage(Range(SoundTTL.(soundtype{sound})),Range(tsd_Sleep2.(Mouse_names{mouse})),Data(tsd_Sleep2.(Mouse_names{mouse})),1,1000);
%         m3.(soundtype{sound}){mouse} = m;
%         s3.(soundtype{sound}){mouse} = s;
%         mAll2.(soundtype{sound})(mouse,:) = m3.(soundtype{sound}){:,mouse}';
%         sAll2.(soundtype{sound})(mouse,:) = s3.(soundtype{sound}){:,mouse}';
%     end
% end


soundtype2 = {'Orage','RU','RD','Tono5','Tono12','Sin20','TonoWN','Sin80'};
dB = {'dB50','dB60','dB70','dB80'};

figure('Color',[1 1 1])
for i = 1:length(soundtype2)
    subplot(5,2,i)
    Data_to_use = mAll.(soundtype2{i});
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
    s1.edge(1).Color = 'none';
    s1.edge(2).Color = 'none';
    title(soundtype2{i});
    makepretty
    ylim([0.05 0.15])
    xlim([-3000 3000])
    vline(0,'r--')
end
subplot(5,4,18:19)
Data_to_use = mAllRand;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
s1.edge(1).Color = 'none';
s1.edge(2).Color = 'none';
title('Random');
makepretty
ylim([0.05 0.15])
xlim([-3000 3000])
vline(0,'r--')
mtitle('Mean value of piezo Sleep');


figure('Color',[1 1 1])
for i = 1:length(soundtype2)
    subplot(4,2,i)
    Data_to_use = mAllAwake.(soundtype2{i});
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
     s1.edge(1).Color = 'none'
   s1.edge(2).Color = 'none'
    title(soundtype2{i})
    makepretty
    ylim([0.1 0.7])
    xlim([-3000 3000])
    vline(0,'r--')
end
mtitle('Mean value of piezo Wake');

%%
figure('Color',[1 1 1])
for i = 1:length(dB)
    subplot(3,2,i)
    Data_to_use = mAll.(dB{i});
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
     s1.edge(1).Color = 'none';
   s1.edge(2).Color = 'none';
    title(dB{i});
    makepretty
    ylim([0.03 0.13])
    xlim([-3000 3000])
    vline(0,'r--');
end
    subplot(3,4,10:11)
Data_to_use = mAllRand;
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
s1.edge(1).Color = 'none';
s1.edge(2).Color = 'none';
title('Random');
makepretty
ylim([0.03 0.13])
xlim([-3000 3000])
vline(0,'r--')
mtitle('Mean value of piezo Sleep');



figure('Color',[1 1 1])
for i = 1:length(dB)
    subplot(2,2,i)
    Data_to_use = mAllAwake.(dB{i});
    Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    Mean_All_Sp = nanmean(Data_to_use);
    s1 = shadedErrorBar(t , Mean_All_Sp , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
     s1.edge(1).Color = 'none';
   s1.edge(2).Color = 'none';
    title(dB{i})
    makepretty
    ylim([0.2 0.6])
    xlim([-3000 3000])
    vline(0,'r--')
end
mtitle('Mean value of piezo Wake');

%%
Cols = {[0 0 0],[1 0 0],[0 1 0],[0 0 1],[1 1 0],[0 1 1],[1 0 1],[0.5 0 0.5],[0.7 0.7 0.7]};

figure
subplot(1,3,1:2), hold on
for i = 1:length(soundtype2)
    Data_to_use = runmean(nanmean(mAll.(soundtype2{i})),20);
    a.(soundtype2{i}) = plot(t,Data_to_use); clear Data_to_use
    a.(soundtype2{i}).Color = Cols{i};
    makepretty
end
Data_to_use = runmean(nanmean(mAllRand),20);
a.Rand = plot(t,Data_to_use); clear Data_to_use
a.Rand.Color = Cols{9};
makepretty

ylim([0.05 0.115])
vline(0,'k--');

legend([a.Orage a.RU a.RD a.Tono5 a.Tono12 a.Sin20 a.TonoWN a.Sin80 a.Rand],'Orage','RU','RD','Tono5','Tono12','Sin20','TonoWN','Sin80','Random');
subplot(133)
X=[1:8];
Legends = {'Orage','RU','RD','TonoWN','Tono12','Sin20','Sin80','Tono5'};
MakeSpreadAndBoxPlot3_SB({SoundNumSleep.Orage SoundNumSleep.RU SoundNumSleep.RD SoundNumSleep.TonoWN SoundNumSleep.Tono12 SoundNumSleep.Sin20 SoundNumSleep.Sin80 SoundNumSleep.Tono5},Cols,X,Legends,'showpoints',1,'paired',1);
ylim([0 90])
title('Number of sounds during sleep')
makepretty_CH

%%

Cols2 = {[0 0 0],[1 0 0],[0 1 0],[0 0 1],[0.7 0.7 0.7]};

figure
subplot(1,3,1:2), hold on
for i = 1:length(dB)
    Data_to_use = runmean(nanmean(mAll.(dB{i})),20);
    a.(dB{i}) = plot(t,Data_to_use); clear Data_to_use
    a.(dB{i}).Color = Cols2{i};
    makepretty
end
 Data_to_use = runmean(nanmean(mAllRand),20);
    a.Rand = plot(t,Data_to_use); clear Data_to_use
    a.Rand.Color = Cols2{5};
    makepretty
xlim([-3000 3000])
ylim([0.05 0.115])
vline(0,'k--');

legend([a.dB50 a.dB60 a.dB70 a.dB80 a.Rand],'50dB','60dB','70dB','80dB','Random');
subplot(133)
X=[1:4];
Legends = {'50 dB','60 dB','70 dB','80 dB'};
MakeSpreadAndBoxPlot3_SB({SoundNumSleep.dB50 SoundNumSleep.dB60 SoundNumSleep.dB70 SoundNumSleep.dB80},Cols2,X,Legends,'showpoints',1,'paired',1);
ylim([0 90])
title('Number of sounds during sleep')
makepretty_CH

%%
% 
% figure, hold on
% subplot(1,3,1:2), hold on
% for i = 1:length(dB)
%     Data_to_use = mAll.(dB{i});
%     Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
%     Mean_All_Sp = nanmean(Data_to_use);
%     s1.(dB{i}) = shadedErrorBar(t , runmean(Mean_All_Sp,20) , Conf_Inter, 'k',1); hold on, clear Data_to_use Conf_Inter Mean_All_Sp;
%    s1.(dB{i}).edge(1).Color = 'none';
%    s1.(dB{i}).edge(2).Color = 'none';
%    s1.(dB{i}).mainLine.Color = Cols2{i};
%    s1.(dB{i}).patch.FaceColor = Cols2{i};
%    s1.(dB{i}).mainLine.LineWidth = 5;
%    
% %    xlim([-3000 3000])
% %     Data_to_use = runmean(nanmean(mAll.(dB{i})),50);
% %     plot(t,Data_to_use),clear Data_to_use
%     makepretty
% end
% ylim([0.05 0.115])
% vline(0,'k--')
% legend([s1.dB50.mainLine s1.dB60.mainLine s1.dB70.mainLine s1.dB80.mainLine],'50dB','60dB','70dB','80dB');
% subplot(133)
% % Col={[0 0 0],[0 0 0],[0 0 0],[0 0 0],[0 0 0],[0 0 0],[0 0 0],[0 0 0]};
% X=[1:4];
% Legends = {'50 dB','60 dB','70 dB','80 dB'};
% MakeSpreadAndBoxPlot3_SB({SoundNumSleep.dB50 SoundNumSleep.dB60 SoundNumSleep.dB70 SoundNumSleep.dB80},Cols2,X,Legends,'showpoints',1,'paired',1);
% ylim([0 90])
% title('Number of sounds during sleep')
% makepretty_CH


%%

figure('Color',[1 1 1])

Cols={[0.5 0.5 0.5],[0 0 0]};
X=[1:2];
Legends={'Pre','Post'};
sons = {'Orage','RU','RD','TonoWN','Tono12','Sin20','Sin80','Tono5'};
for son = 1:length(sons)
    subplot(2,5,son)
    [p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBef.(sons{son}) meanAft.(sons{son})},Cols,X,Legends,'showpoints',1,'paired',1);
    title((sons{son}))
    ylim([0 0.2])
    makepretty_CH
end
subplot(2,5,9)
[p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBef_Rand meanAft_Rand},Cols,X,Legends,'showpoints',1,'paired',1);
title('Random')
ylim([0 0.2])
makepretty_CH
mtitle('Mean value of piezo Sleep (+/- 1s)')



figure('Color',[1 1 1])

Cols={[0.5 0.5 0.5],[0 0 0]};
X=[1:2];
Legends={'Pre','Post'};
sons = {'Orage','RU','RD','TonoWN','Tono12','Sin20','Sin80','Tono5'};
for son = 1:length(sons)
    subplot(2,4,son)
    [p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBefAwake.(sons{son}) meanAftAwake.(sons{son}) },Cols,X,Legends,'showpoints',1,'paired',1);
    title((sons{son}))
    ylim([0.2 0.8])
    makepretty_CH
end
mtitle('Mean value of piezo Wake (+/- 1s)')



figure('Color',[1 1 1])

Cols={[0.5 0.5 0.5],[0 0 0]};
X=[1:2];
Legends={'Pre','Post'};
sons = {'dB50','dB60','dB70','dB80'};
for son = 1:length(sons)
    subplot(3,2,son)
    [p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBef.(sons{son}) meanAft.(sons{son})},Cols,X,Legends,'showpoints',1,'paired',1);
    title((sons{son}))
    ylim([0 0.2])
    makepretty_CH
end
subplot(3,4,10:11)
[p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBef_Rand meanAft_Rand},Cols,X,Legends,'showpoints',1,'paired',1);
title('Random')
ylim([0 0.2])
makepretty_CH
mtitle('Mean value of piezo Sleep (+/- 1s)')


figure('Color',[1 1 1])

Cols={[0.5 0.5 0.5],[0 0 0]};
X=[1:2];
Legends={'Pre','Post'};
sons = {'dB50','dB60','dB70','dB80'};
for son = 1:length(sons)
    subplot(2,2,son)
    [p{son},~]= MakeSpreadAndBoxPlot3_SB({meanBefAwake.(sons{son}) meanAftAwake.(sons{son})},Cols,X,Legends,'showpoints',1,'paired',1);
    title((sons{son}))
    ylim([0.2 0.6])
    makepretty_CH
end
mtitle('Mean value of piezo Wake (+/- 1s)')

%%


for mouse=1:6
    [M,T] = PlotRipRaw(Piezo_tsd.(Mouse_names{mouse}),  Range(Restrict(SoundTTL.dB80,SleepEpoch.(Mouse_names{mouse})),'s'),5000);close
    
    Ts=zscore(T')';
    [BE,ids]=sort(mean(Ts(:,500:550),2)-mean(Ts(:,400:495),2));
    [BE,id]=sort(mean(T(:,500:550),2)-mean(T(:,400:495),2));
    figure,
    subplot(2,2,1), imagesc(M(:,1),1:size(T,1),T(ids,:)), axis xy, colormap hot, line([0 0],ylim,'color','w'), title(num2str(mouse))
    subplot(2,2,2), imagesc(M(:,1),1:size(T,1),T(id,:)), axis xy, colormap hot, line([0 0],ylim,'color','w'), title('dB 80')
    subplot(2,2,3), imagesc(M(:,1),1:size(T,1),Ts(ids,:)), axis xy, colormap hot, line([0 0],ylim,'color','w')
    subplot(2,2,4), imagesc(M(:,1),1:size(T,1),Ts(id,:)), axis xy, colormap hot, line([0 0],ylim,'color','w')
    Tall{mouse}=T(ids,:);
    Tsall{mouse}=Ts(ids,:);
    pause(0.5)
end





