
%% load data
load('Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')

%% generate data
GetEmbReactMiceFolderList_BM
Mouse = Drugs_Groups_UMaze_BM(11);
Session_type={'Fear'};

for sess=1:length(Session_type)
    Sessions_List_ForLoop_BM
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
        ZoneEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
        
        ShockEpoch.(Session_type{sess}).(Mouse_names{mouse}) = ZoneEpoch.Fear.(Mouse_names{mouse}){1};
        SafeEpoch.(Session_type{sess}).(Mouse_names{mouse}) = or(ZoneEpoch.Fear.(Mouse_names{mouse}){2},ZoneEpoch.Fear.(Mouse_names{mouse}){5});
        
        FreezingShock.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , ShockZone.(Session_type{sess}).(Mouse_names{mouse}));
        FreezingSafe.(Session_type{sess}).(Mouse_names{mouse}) = and(FreezeEpoch.(Session_type{sess}).(Mouse_names{mouse}) , SafeZone.(Session_type{sess}).(Mouse_names{mouse}));
        
        Respi.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'respi_freq_bm');
        
        disp(Mouse_names{mouse})
    end
end

% - EpProp_2_4 : column vector with proportion for each episode of time with OB frequency > Freq_Limit
% - PropOfEp_2_4 look at proportion of episodes with a mean frequency > Freq_Limit
% - TimeProp_thr look at proportion of time where OB frequency > Freq_Limit
% - TimeProp_norm took each episode, look at its proportion of 2-4 and then mean these values (shorter episodes will have the same impact as long ones)

load('B_Low_Spectrum.mat')
Type={'All','Shock','Safe'};
Drug_Group={'Saline','ChronicFlx','AcuteFlx','Midazolam','Diazepam','NewSal'};
thr=1; % threshold for noise
Freq_Limit=3.66;
for mouse = 1:length(Mouse)
    for type=1:length(Type)
        if type==1; FzEpoch=Freeze_Epoch.Fear.(Mouse_names{mouse}); end
        if type==2; FzEpoch=and(Freeze_Epoch.Fear.(Mouse_names{mouse}),ShockEpoch.Fear.(Mouse_names{mouse})); end
        if type==3; FzEpoch=and(Freeze_Epoch.Fear.(Mouse_names{mouse}),SafeEpoch.Fear.(Mouse_names{mouse})); end
        [All_Freq.(Mouse_names{mouse}).(Type{type}),EpLength.(Mouse_names{mouse}).(Type{type}),EpProp_2_4.(Mouse_names{mouse}).(Type{type}),TimeProp_2_4.(Mouse_names{mouse}).(Type{type})] = FreezingSpectrumEpisodesAnalysis_BM(FzEpoch , RespiFreq.Fear.(Mouse_names{mouse}) , Freq_Limit);
        PropOfEp_2_4.(Mouse_names{mouse}).(Type{type})=length(find(EpProp_2_4.(Mouse_names{mouse}).(Type{type})>0.5))/length(EpLength.(Mouse_names{mouse}).(Type{type})); %
        TimeProp_norm_2_4.(Mouse_names{mouse}).(Type{type})=nanmean(EpProp_2_4.(Mouse_names{mouse}).(Type{type}));
        
        disp(Mouse_names{mouse})
    end
end

% normalized and frequency evolution in an epsiode
for mouse = 1:length(Mouse)
    for type=1:length(Type)
        norm_value=100;
        for ep=1:size(All_Freq.(Mouse_names{mouse}).(Type{type}),1)
            if sum(isnan(All_Freq.(Mouse_names{mouse}).(Type{type})(ep,:)))==size(All_Freq.(Mouse_names{mouse}).(Type{type}),2);
                All_Freq_norm.(Mouse_names{mouse}).(Type{type})(ep,:)=NaN; % when 0 values in an espisode
            elseif sum(isnan(All_Freq.(Mouse_names{mouse}).(Type{type})(ep,:)))==size(All_Freq.(Mouse_names{mouse}).(Type{type}),2)-1;
                All_Freq_norm.(Mouse_names{mouse}).(Type{type})(ep,:)=All_Freq.(Mouse_names{mouse}).(Type{type})(ep,1); % when 1 value in an espisode
            else
                All_Freq_norm.(Mouse_names{mouse}).(Type{type})(ep,:)= interp1(linspace(0,1,sum(~isnan(All_Freq.(Mouse_names{mouse}).(Type{type})(ep,:)))),All_Freq.(Mouse_names{mouse}).(Type{type})(ep,1:sum(~isnan(All_Freq.(Mouse_names{mouse}).(Type{type})(ep,:)))),linspace(0,1,norm_value));
            end
        end
    end
end

% chosse your drug group
clear Mouse Mouse_names
for group=1:length(Drug_Group)
    if group==1 % saline mice
        Mouse_names={'M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095'};
    elseif group==3 % Acute Flx
        Mouse_names={'M740','M750','M775','M778','M794'};
    elseif group==4 % midazolam mice
        Mouse_names={'M829','M851','M857','M858','M859','M1005','M1006'};
%     elseif group==5 % classic mice
%         Mouse_names={'M561','M566','M567','M568','M569'};
    elseif group==5 % midazolam mice
        Mouse_names={'M11147','M11184','M11189','M11200','M11204','M11205','M11206','M11207'};
    elseif group==6 % new saline mice
        Mouse_names={'M1144','M1146','M1147','M1170','M1171','M1172','M1174','M1184','M1189','M1204','M1205'};
    end
    for mouse =1:length(Mouse_names)
        for type=1:length(Type)
            PropOfEp_2_4.(Drug_Group{group}).(Type{type})(mouse)=PropOfEp_2_4.(Mouse_names{mouse}).(Type{type});
            TimeProp_thr_2_4.(Drug_Group{group}).(Type{type})(mouse)=TimeProp_thr_2_4.(Mouse_names{mouse}).(Type{type});
            TimeProp_norm_2_4.(Drug_Group{group}).(Type{type})(mouse)=TimeProp_norm_2_4.(Mouse_names{mouse}).(Type{type});
            TimeProp_abs_2_4.(Drug_Group{group}).(Type{type})(mouse)=TimeProp_abs_2_4.(Mouse_names{mouse}).(Type{type});
        end
    end
end

for group=1:length(Drug_Group)
    Data_For_Plot.(Drug_Group{group}).Shock = (1-TimeProp_abs_2_4.(Drug_Group{group}).Shock)'*100;
    Data_For_Plot.(Drug_Group{group}).Safe = (1-TimeProp_abs_2_4.(Drug_Group{group}).Safe)'*100;
    Data_For_Plot2.(Drug_Group{group}).Shock = (1-PropOfEp_2_4.(Drug_Group{group}).Shock)'*100;
    Data_For_Plot2.(Drug_Group{group}).Safe = (1-PropOfEp_2_4.(Drug_Group{group}).Safe)'*100;
end

figure
for group=1:6
    
    subplot(2,6,group)
    bar([100,100],'FaceColor',[0.5 0.5 1]); hold on
    PlotErrorBarN_KJ({Data_For_Plot.(Drug_Group{group}).Shock , Data_For_Plot.(Drug_Group{group}).Safe},'showpoints',1,'paired',1,'newfig',0,'barcolors',[1 0.5 0.5])
    makepretty
    ylim([0 120])
    title(Drug_Group{group})
        xticklabels({'',''});

    if group==1; ylabel('Time percentage'); legend('2-4 freezing','4-6 freezing'); end
    
    subplot(2,6,group+6)
    bar([100,100],'FaceColor',[0.5 0.5 1]); hold on
    PlotErrorBarN_KJ({Data_For_Plot2.(Drug_Group{group}).Shock , Data_For_Plot2.(Drug_Group{group}).Safe},'showpoints',1,'paired',1,'newfig',0,'barcolors',[1 0.5 0.5])
    makepretty
    ylim([0 120])
    xticklabels({'Shock side fz','Safe side fz'}); xtickangle(45)

    if group==1; ylabel('Number of episodes percentage'); end
    
end

a=suptitle('Freezing analysis, type of OB oscillations, UMaze drugs'); a.FontSize=20;

figure
subplot(221)
bar([100,100,100,100,100,100],'FaceColor',[0.5 0.5 1]); hold on
PlotErrorBarN_KJ({Data_For_Plot.Saline.Shock , Data_For_Plot.ChronicFlx.Shock , Data_For_Plot.AcuteFlx.Shock , Data_For_Plot.Midazolam.Shock , Data_For_Plot.Diazepam.Shock , Data_For_Plot.NewSal.Shock},'showpoints',1,'paired',0,'newfig',0,'barcolors',[1 0.5 0.5])
makepretty
ylim([0 130]); xticklabels({'','','','','',''});
title('Shock side'); ylabel('Time percentage')

subplot(222)
bar([100,100,100,100,100,100],'FaceColor',[0.5 0.5 1]); hold on
PlotErrorBarN_KJ({Data_For_Plot.Saline.Safe , Data_For_Plot.ChronicFlx.Safe , Data_For_Plot.AcuteFlx.Safe , Data_For_Plot.Midazolam.Safe , Data_For_Plot.Diazepam.Safe , Data_For_Plot.NewSal.Safe},'showpoints',1,'paired',0,'newfig',0,'barcolors',[1 0.5 0.5])
makepretty; xticklabels({'','','','','',''});
ylim([0 130])
title('Safe side'); 

subplot(223)
bar([100,100,100,100,100,100],'FaceColor',[0.5 0.5 1]); hold on
PlotErrorBarN_KJ({Data_For_Plot2.Saline.Shock , Data_For_Plot2.ChronicFlx.Shock , Data_For_Plot2.AcuteFlx.Shock , Data_For_Plot2.Midazolam.Shock , Data_For_Plot2.Diazepam.Shock , Data_For_Plot2.NewSal.Shock},'showpoints',1,'paired',0,'newfig',0,'barcolors',[1 0.5 0.5])
makepretty
ylim([0 130]); xticklabels(Drug_Group);  xtickangle(45)
ylabel('Number of episodes percentage')

subplot(224)
bar([100,100,100,100,100,100],'FaceColor',[0.5 0.5 1]); hold on
PlotErrorBarN_KJ({Data_For_Plot2.Saline.Safe , Data_For_Plot2.ChronicFlx.Safe , Data_For_Plot2.AcuteFlx.Safe , Data_For_Plot2.Midazolam.Safe , Data_For_Plot2.Diazepam.Safe , Data_For_Plot2.NewSal.Safe},'showpoints',1,'paired',0,'newfig',0,'barcolors',[1 0.5 0.5])
makepretty; xticklabels(Drug_Group); xtickangle(45)
ylim([0 130])

a=suptitle('Freezing analysis, type of OB oscillations, UMaze drugs'); a.FontSize=20;

%% AllFreq analysis :

% Matrix with all epsiodes and mean frequency by ep :
% Percentage of 2-4
figure
% subplot(221)
% imagesc(1-EpProp_2_4.(Mouse_names{mouse}).Shock)
% title('Shock side freezing ')
% subplot(222)
% imagesc(1-EpProp_2_4.(Mouse_names{mouse}).Safe)
% title('Safe side freezing ')
%map = [1 0.5 0.5 ; 0.95 0.5 0.55 ; 0.9 0.5 0.6 ; 0.85 0.5 0.65 ; 0.8 0.5
%0.7 ; 0.75 0.5 0.75 ; 0.7 0.5 0.8 ; 0.65 0.5 0.85 ; 0.6 0.5 0.9 ; 0.55 0.5
%0.95 ; 0.5 0.5 1];
a=colorbar; a.Ticks=[0 1]; a.TickLabels={'100% 2-4 freezing','100% 4-6 freezing'};
% absolute frequency
subplot(121)
imagesc(nanmean(All_Freq.(Mouse_names{mouse}).Shock')')
subplot(122)
imagesc(nanmean(All_Freq.(Mouse_names{mouse}).Safe')')
a=suptitle('Mouse 893, type of freezing proportion by episode'); a.FontSize=20;
a=colorbar; 
u=text(1.7,140,'Frequency (Hz)','FontSize',16); set(u,'Rotation',90);
colormap(gray)

% 2D plot as KB asked
figure
% subplot(221)
% plot((1-EpProp_2_4.(Mouse_names{mouse}).Shock)*100); hold on
% plot((1-EpProp_2_4.(Mouse_names{mouse}).Shock)*100,'.r','MarkerSize',10)
% title('Shock side freezing ')
% makepretty
% ylabel('2-4 percentage (%)')
% subplot(222)
% plot((1-EpProp_2_4.(Mouse_names{mouse}).Safe)*100); hold on
% plot((1-EpProp_2_4.(Mouse_names{mouse}).Safe)*100,'.r','MarkerSize',10)
% title('Safe side freezing ')
% makepretty
% % Absolute frequency
subplot(121)
plot(nanmean(All_Freq.(Mouse_names{mouse}).Shock')'); hold on
plot(nanmean(All_Freq.(Mouse_names{mouse}).Shock')','.r','MarkerSize',10);
makepretty
hline(2,'--r'); 
ylabel('Frequency (Hz)'); xlabel('freezing episodes #')
subplot(122)
plot(nanmean(All_Freq.(Mouse_names{mouse}).Safe')'); hold on
plot(nanmean(All_Freq.(Mouse_names{mouse}).Safe')','.r','MarkerSize',10);
makepretty
hline(2,'--r'); 
xlabel('freezing episodes #')
a=suptitle('Mouse 893, type of freezing proportion by episode'); a.FontSize=20;

%% scatter plot
% example with M893
figure
subplot(121)
imagesc(All_Freq_norm.M893.Shock)
title('Shock side freezing ')
ylabel('freezing episodes #')
xlabel('normalized time')
subplot(122)
imagesc(All_Freq_norm.M893.Safe)
xlabel('normalized time')
title('Safe side freezing ')
%map2 =flip(map);
a=colormap(gray); 
a=colorbar; 
u=text(110,140,'Frequency (Hz)','FontSize',24); set(u,'Rotation',90);
a=suptitle('Mouse 893, type of freezing proportion by episode'); a.FontSize=20;

%% link between length of an episode and frequency

figure
[R,P]=PlotCorrelations_BM(nanmean(All_Freq.M893.All') , EpLength.M893.All/1e4);
ylabel('freezing episode duration (s)'); xlabel('Mean frequency of epsiodes')

%% putting all mice together
% Evoution inside episodes in mean

for group=1:length(Drug_Group)
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893'};
        Mouse=[666 668 688 739 777 779 849 893 ];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130];
    end
    for mouse =1:length(Mouse)
        
        Freq_FzEp_Shock_All.(Drug_Group{group})(mouse,1:length(nanmean(All_Freq.(Mouse_names{mouse}).Shock)))=nanmean(All_Freq.(Mouse_names{mouse}).Shock);
        Freq_FzEp_Safe_All.(Drug_Group{group})(mouse,1:length(nanmean(All_Freq.(Mouse_names{mouse}).Safe)))=nanmean(All_Freq.(Mouse_names{mouse}).Safe);
        Freq_FzEp_Shock_All.(Drug_Group{group})(Freq_FzEp_Shock_All.(Drug_Group{group})==0)=NaN;
        Freq_FzEp_Safe_All.(Drug_Group{group})(Freq_FzEp_Safe_All.(Drug_Group{group})==0)=NaN;        
        
        Freq_FzEp_norm_Shock_All.(Drug_Group{group})(mouse,:)=nanmean(All_Freq_norm.(Mouse_names{mouse}).Shock);
        Freq_FzEp_norm_Safe_All.(Drug_Group{group})(mouse,:)=nanmean(All_Freq_norm.(Mouse_names{mouse}).Safe);
        
        FreqEvolution_AlongFzEp_Shock_All.(Drug_Group{group})(mouse,1:length(nanmean(All_Freq.(Mouse_names{mouse}).Shock')))= nanmean(All_Freq.(Mouse_names{mouse}).Shock');
        FreqEvolution_AlongFzEp_Safe_All.(Drug_Group{group})(mouse,1:length(nanmean(All_Freq.(Mouse_names{mouse}).Safe')))= nanmean(All_Freq.(Mouse_names{mouse}).Safe');
        FreqEvolution_AlongFzEp_Shock_All.(Drug_Group{group})(FreqEvolution_AlongFzEp_Shock_All.(Drug_Group{group})==0)=NaN;
        FreqEvolution_AlongFzEp_Safe_All.(Drug_Group{group})(FreqEvolution_AlongFzEp_Safe_All.(Drug_Group{group})==0)=NaN;
        
        FreqEvolution_AlongFzEp_norm_Shock_All.(Drug_Group{group})(mouse,:)= interp1(linspace(0,1,length(nanmean(All_Freq_norm.(Mouse_names{mouse}).Shock'))),nanmean(All_Freq_norm.(Mouse_names{mouse}).Shock'),linspace(0,1,norm_value));
        FreqEvolution_AlongFzEp_norm_Safe_All.(Drug_Group{group})(mouse,:)= interp1(linspace(0,1,length(nanmean(All_Freq_norm.(Mouse_names{mouse}).Safe'))),nanmean(All_Freq_norm.(Mouse_names{mouse}).Safe'),linspace(0,1,norm_value));
        
    end
end
  
Color_to_use={'-r','-r','-b','-b'};
figure
for cond=1:4
    
    subplot(2,2,cond)
    if cond==1
        clear DataPlot; DataPlot=Freq_FzEp_Shock_All.Saline;
    elseif cond==2
        clear DataPlot; DataPlot=Freq_FzEp_Shock_All.ChronicFlx;
    elseif cond==3
        clear DataPlot; DataPlot=Freq_FzEp_Safe_All.Saline;
    else
        clear DataPlot; DataPlot=Freq_FzEp_Safe_All.ChronicFlx;
    end
    
    Conf_Inter=nanstd(DataPlot)/sqrt(size(DataPlot,1));
    shadedErrorBar(Spectro{2}(1:length(nanmean(DataPlot)))-1.5,nanmean(DataPlot),Conf_Inter,Color_to_use{cond},1); hold on;
    makepretty; ylim([0.5 6]); xlim([0 20])
    hline(3,'--r')
    if cond==1 | cond==3
        ylabel('Frequency (Hz)')
    end
    if cond==1
        title('Saline')
    elseif cond==2
        title('Chronic Flx')
    end
    if cond==3 | cond==4
        xlabel('time (s)')
    end
end
a=suptitle('Mean evolution of OB frequency in a freezing episode, non normalized'); a.FontSize=20;

figure
for cond=1:4
    
    subplot(2,2,cond)
    if cond==1
        clear DataPlot; DataPlot=Freq_FzEp_norm_Shock_All.Saline;
    elseif cond==2
        clear DataPlot; DataPlot=Freq_FzEp_norm_Shock_All.ChronicFlx;
    elseif cond==3
        clear DataPlot; DataPlot=Freq_FzEp_norm_Safe_All.Saline;
    else
        clear DataPlot; DataPlot=Freq_FzEp_norm_Safe_All.ChronicFlx;
    end
    
    Conf_Inter=nanstd(DataPlot)/sqrt(size(DataPlot,1));
    shadedErrorBar([1:length(nanmean(DataPlot))],nanmean(DataPlot),Conf_Inter,Color_to_use{cond},1); hold on;
    makepretty; ylim([0.5 6]); xlim([0 100])
    hline(3,'--r')
   if cond==1 | cond==3
        ylabel('Frequency (Hz)')
    end
    if cond==1
        title('Saline')
    elseif cond==2
        title('Chronic Flx')
    end
    if cond==3 | cond==4
        xlabel('normalized time of an epsiode')
    end
end
a=suptitle('Mean evolution of OB frequency in a freezing episode, normalized'); a.FontSize=20;

% evolution along episodes of the frequency

figure
for cond=1:4
    
    subplot(2,2,cond)
    if cond==1
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_Shock_All.Saline;
    elseif cond==2
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_Shock_All.ChronicFlx;
    elseif cond==3
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_Safe_All.Saline;
    else
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_Safe_All.ChronicFlx;
    end
    
    Conf_Inter=nanstd(DataPlot)/sqrt(size(DataPlot,1));
    shadedErrorBar([1:length(nanmean(DataPlot))],nanmean(DataPlot),Conf_Inter,Color_to_use{cond},1); hold on;
    makepretty; ylim([0.5 6]); xlim([0 100])
    hline(3,'--r')
    if cond==1 | cond==3
        ylabel('Frequency (Hz)')
    end
    if cond==1
        title('Saline')
    elseif cond==2
        title('Chronic Flx')
    end
    if cond==3 | cond==4
        xlabel('freezing episodes #')
    end
end
a=suptitle('Mean evolution of OB frequency along freezing episode, non normalized'); a.FontSize=20;

figure
for cond=1:4
    
    subplot(2,2,cond)
    if cond==1
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_norm_Shock_All.Saline;
    elseif cond==2
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_norm_Shock_All.ChronicFlx;
    elseif cond==3
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_norm_Safe_All.Saline;
    else
        clear DataPlot; DataPlot=FreqEvolution_AlongFzEp_norm_Safe_All.ChronicFlx;
    end
    
    Conf_Inter=nanstd(DataPlot)/sqrt(size(DataPlot,1));
    shadedErrorBar([1:length(nanmean(DataPlot))],nanmean(DataPlot),Conf_Inter,Color_to_use{cond},1); hold on;
    makepretty; ylim([0.5 6]); xlim([0 100])
    hline(3,'--r')
    if cond==1 | cond==3
        ylabel('Frequency (Hz)')
    end
    if cond==1
        title('Saline')
    elseif cond==2
        title('Chronic Flx')
    end
    if cond==3 | cond==4
        xlabel('normalized freezing episodes #')
    end
end
a=suptitle('Mean evolution of OB frequency along freezing episode, normalized'); a.FontSize=20;











for i=1:size(FreqEvolution_AlongFzEp_Safe_All.Saline,1)
    subplot(2,4,i)
    
    plot(runmean(nanmean(All_Freq.(Mouse_names{i}).Safe'),5))
    
end



