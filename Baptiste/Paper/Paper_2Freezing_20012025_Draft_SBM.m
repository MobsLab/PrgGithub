
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                                     PAPER SBM                                                        %
%                                                THERE IS 2 FREEZING !!                                                %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : Task presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) Cartoon protocol / trajectories / stats explo

% protocol cartoon 
edit Display_Maze_BM.m


% trajectories & Freeze Occup map
edit Example_Trajectories_Paper_FreezingMaze_BM.m


% Pre Post and Fz stats
edit Explo_Features_PrePost_UMaze.m


%% b) Cartoon recording + neurons + LFP
edit Example_2FzTypes_Paper_BM.m


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : Two types of freezing defined by coordinated cardio-respiratory states parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mouse example

Example_Panel_Paper_FreezingMaze_BM

%% Body
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat')
% or after 
% edit Freezing_FarFromStims_Maze_BM.m

figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
close
Freq_Max1(7)=NaN; Freq_Max2(7)=1.373;
Freq_Max1(8)=2.747; Freq_Max2(8)=NaN;


figure
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));
Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0 , 'power_norm_value' , max([MaxPowerValues1' MaxPowerValues2']'));

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])
axis square

saveFigure_BM(1,'Paper_SBM_Fig2_3','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat')
% or after 
% edit Freezing_FarFromStims_Maze_BM.m

% Box plots
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
[~ , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
[~ , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
close
Freq_Max1(7)=NaN; Freq_Max2(7)=1.373;
Freq_Max2(8)=NaN;


figure
subplot(151)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2

subplot(152)
MakeSpreadAndBoxPlot3_SB({OutPutData.Fear.heartrate.mean(:,5) OutPutData.Fear.heartrate.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Heart rate (Hz)'), ylim([8.5 13.5])
makepretty_BM2

subplot(153)
MakeSpreadAndBoxPlot3_SB({OutPutData.Fear.heartratevar.mean(:,5) OutPutData.Fear.heartratevar.mean(:,6)},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Heart rate variability (a.u.)'), ylim([0 .45])
makepretty_BM2

subplot(154)
MakeSpreadAndBoxPlot3_SB({OutPutData.Fear.accelero.mean(:,5)/1e7 OutPutData.Fear.accelero.mean(:,6)/1e7},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Motion (a.u.)'), ylim([0 3])
makepretty_BM2

subplot(155)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.Fear.emg_pect.mean(:,5)) log10(OutPutData.Fear.emg_pect.mean(:,6))},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('EMG power (log scale)'), ylim([3.6 5.2])
lim=5;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

saveFigure_BM(2,'Paper_SBM_Fig2_6','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')

%% Brain
% box plot
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')


figure
subplot(143)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.hpc_theta_freq.mean(:,5) OutPutData.Fear.hpc_theta_freq.mean(:,6)},Cols,X,Legends,0,1);
ylabel('HPC theta frequency (Hz)')
ylim([5.3 7.7])
lim=7.5;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(144)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.hpc_theta_power.mean(:,5) OutPutData.Fear.hpc_theta_power.mean(:,6)},Cols,X,Legends,0,1);
ylabel('HPC theta power (a.u.)')
ylim([.8 3.3])
lim=3.1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2




%% Spider map
% edit GetSpiderMapData_BM.m 
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat')

load('/media/nas7/ProjetEmbReact/DataEmbReact/Spider_Map_PCA.mat','P')
P2 = squeeze(nanmedian(P));
P2=P2(:,[1 2 4 7 3 6 5 8]);

clear s
clf
s = spider_plot_class(P2);
% s.AxesLabels =  {'Breathing','Heart rate','OB gamma frequency','OB gamma power','Heart rate variability','Ripples occurence','HPC theta frequency','HPC theta power'};
s.AxesLabels =  {'','','','','','','',''};
s.LegendLabels = {'Freezing shock', 'Freezing safe'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on'};
s.Color = [1 .5 .5; .5 .5 1];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
s.AxesLimits(:,[4 7]) = [6.4 1.1;12 3];
s.MarkerSize=[1e2 1e2];
s.AxesTickLabels={''}

saveFigure_BM(7,'Paper_SBM_Fig2_7','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


%% d) PCA analysis
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat')
% or
% edit PCA_Freezing_CondPost_Dimensions_BM.m


% PC weights & eigen values
[a,b] = sort(eigen_vector(:,1),'descend');

figure
for i=1:4
    subplot(4,1,i)
    plot(eigen_vector(b,i),'Color','k','LineWidth',5)
    hold on
    plot(eigen_vector(b,i),'.','MarkerSize',50,'Color','k')
    
    if i==4, xticklabels({'Heart rate','Breathing','OB gamma frequency','HPC theta power','HPC theta frequency','OB gamma power','Ripples occurence','Heart rate variability'}), 
    else xticklabels({''}), end
    xtickangle(45)
    box off
    makepretty_BM2
    h=hline(0,'--k'); set(h,'LineWidth',2);
    ylabel(['PC ' num2str(i) ' weight (a.u.)']), ylim([-.7 .7])
    vline([1:8],'--k')
end

% 2D projections
Cols = {[1 .5 .5],[.5 .5 1],[.5 .8 .5],[.7 .7 .4],[.8 .5 0]};
PC_values_quiet{3}([2 4 8]) = NaN;

figure
for z=[1 3]
    subplot(2,2,(z-1)+1)
    
    plot(PC_values_shock{z} , PC_values_shock{z+1},'.','MarkerSize',10,'Color',[1 .5 .5])
    hold on
    plot(PC_values_safe{z} , PC_values_safe{z+1},'.','MarkerSize',10,'Color',[.5 .5 1])
    ind1 = and(~isnan(PC_values_shock{z}) , ~isnan(PC_values_shock{z+1}));
    ind2 = and(~isnan(PC_values_safe{z}) , ~isnan(PC_values_safe{z+1}));
    Bar_shock = [nanmedian(PC_values_shock{z}) nanmedian(PC_values_shock{z+1})];
    Bar_safe = [nanmedian(PC_values_safe{z}) nanmedian(PC_values_safe{z+1})];
    for mouse=1:length(PC_values_shock{z})
        line([Bar_shock(1) PC_values_shock{z}(mouse)],[Bar_shock(2) PC_values_shock{z+1}(mouse)],'LineStyle','--','Color',[1 .5 .5])
        line([Bar_safe(1) PC_values_safe{z}(mouse)],[Bar_safe(2) PC_values_safe{z+1}(mouse)],'LineStyle','--','Color',[.5 .5 1])
        
        DIST_intra{z}(mouse) = sqrt((Bar_shock(1)-PC_values_shock{z}(mouse))^2+(Bar_shock(2)-PC_values_shock{z+1}(mouse))^2);
        DIST_intra{z+1}(mouse) = sqrt((Bar_safe(1)-PC_values_safe{z}(mouse))^2+(Bar_safe(2)-PC_values_safe{z+1}(mouse))^2);
        
        DIST_inter{z}(mouse) = sqrt((Bar_safe(1)-PC_values_shock{z}(mouse))^2+(Bar_safe(2)-PC_values_shock{z+1}(mouse))^2);
        DIST_inter{z+1}(mouse) = sqrt((Bar_shock(1)-PC_values_safe{z}(mouse))^2+(Bar_shock(2)-PC_values_safe{z+1}(mouse))^2);
    end
    plot(Bar_shock(1),Bar_shock(2),'.','MarkerSize',50,'Color',[1 .5 .5])
    plot(Bar_safe(1),Bar_safe(2),'.','MarkerSize',50,'Color',[.5 .5 1])
    axis square
    xlabel(['PC' num2str(z) ' value (' num2str(round(eigen_val(z),1)) '%)']), ylabel(['PC' num2str(z+1) ' value (' num2str(round(eigen_val(z+1),1)) '%)'])
    grid on
    if z==1; f=get(gca,'Children'); legend([f([106 105])],'Freezing shock','Freezing safe'); end
    
    
    subplot(2,2,(z-1)+2)
    for states=1:5
        if states==1
            PC_values = PC_values_shock;
        elseif states==2
            PC_values = PC_values_safe;
        elseif states==3
            PC_values = PC_values_active;
        elseif states==4
            PC_values = PC_values_quiet;
        elseif states==5
            PC_values = PC_values_sleep;
        end
        
        ind{states} = and(~isnan(PC_values{z}) , ~isnan(PC_values{z+1}));
        Bar_st = [nanmedian(PC_values{z}) nanmedian(PC_values{z+1})];
        Q1_st(1) = quantile(PC_values{z},.25); Q1_st(2) = quantile(PC_values{z},.75);
        Q2_st(1) = quantile(PC_values{z+1},.25); Q2_st(2) = quantile(PC_values{z+1},.75);
        
        plot(Bar_st(1),Bar_st(2),'.','MarkerSize',50,'Color',Cols{states}), hold on
        line(Q1_st,[Bar_st(2) Bar_st(2)],'Color',Cols{states},'LineWidth',3)
        line([Bar_st(1) Bar_st(1)],Q2_st,'Color',Cols{states},'LineWidth',3)
        grid on
        axis square
        xlabel(['PC' num2str(z) ' value']), ylabel(['PC' num2str(z+1) ' value'])
        
    end
    if z==1; f=get(gca,'Children'); legend([f([13 10 7 4 1])],'Freezing shock','Freezing safe','Active wake','Quiet wake','Sleep'); end
end



% SVM
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Sal_MouseByMouse_CondPost.mat')

svm_type = 1; % linear
parToUse = 1; % all variables

SVMChoice_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMScores_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMChoice_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
SVMScores_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;

figure
MakeSpreadAndBoxPlot3_SB({SVMScores_Sk_Ctrl{svm_type}(1,:),SVMScores_Sf_Ctrl{svm_type}(1,:)},...
    {[1 0.5 0.5],[0.5 0.5 1]},[1,2],{'Shock','Safe'},'showpoints',0,'paired',1);
makepretty_BM2
ylabel('SVM score (a.u.)')
hline(0,'--k')



figure
[pval,eb,stats_out,b]=PlotErrorBarN_BM({nanmean(1-SVMChoice_Sk_Ctrl{svm_type}),nanmean(SVMChoice_Sf_Ctrl{svm_type})},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
makepretty
b(1).LineWidth=2; b(2).LineWidth=2;
ylabel('Accuracy')
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'})
hline(.5,'--k')
ylim([0 1])
xtickangle(45)


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3 : Breathing and ripples 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) Ripples occurence = f(respi)
% edit Ripples_Density_OB_Frequency_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')

Session_type={'Fear','Cond','Ext'};
Mouse=Drugs_Groups_UMaze_BM(11);

figure
for sess=1:length(Session_type)
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            MAP.(Session_type{sess})(mouse,:,:) = hist2d([Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) 1 1 7 7] , [Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) 0 3 0 3],100,100);
            MAP.(Session_type{sess})(mouse,:,:) = MAP.(Session_type{sess})(mouse,:,:)./nansum(nansum(MAP.(Session_type{sess})(mouse,:,:)));
            
            [R.(Session_type{sess})(mouse),P.(Session_type{sess})(mouse),a.(Session_type{sess})(mouse),b.(Session_type{sess})(mouse)]=PlotCorrelations_BM(Respi_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}) , Ripples_density_in_FzEp.(Session_type{sess}).(Mouse_names{mouse}));
        end
    end
    R.(Session_type{sess})(R.(Session_type{sess})==0)=NaN;
    P.(Session_type{sess})(P.(Session_type{sess})==0)=NaN;
end
R.Cond(4)=NaN;
close

Cols2={[.5 .5 .5]};
X2=[1];
Legends2={'R values'};

figure
subplot(1,4,1:2)
B=squeeze(nanmean(MAP.Cond)); B(isnan(B))=0; C=nansum(B); C(C==0)=1; B=B./C; B(B>.5)=0; 
imagesc(linspace(1,7,100) , linspace(0,3,100) , SmoothDec(B,2)), axis xy, colormap parula
xlabel('Breathing frequency (Hz)'), ylabel('Ripples occurence (#/s)')
caxis([0 .02])
u=colorbar; u.Ticks=[0 .02]; u.TickLabels={'0','1'}; u.Label.String = 'density (a.u.)'; u.Label.FontSize=12;
makepretty_BM2
axis square
colormap jet

subplot(143)
MakeSpreadAndBoxPlot_BM({P.Cond},Cols2,X2,{'p values'},1,0);
set(gca,'YScale','log')
makepretty_BM2
hline(.05,'--r')
ylim([1e-9 1])

subplot(144)
MakeSpreadAndBoxPlot_BM({R.Cond(P.Cond<.05)},Cols2,X2,Legends2,1,0);
[h,p] = ttest(R.Cond(P.Cond<.05) , zeros(1,length(R.Cond(P.Cond<.05))))
hline(0,'--r')
makepretty_BM2
ylim([-.65 .1])
lim=.05;
plot([.5 1.5],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



%% b) Ripples on breathing phase
% edit Ripples_Phase_on_Breathing_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')
% load('/media/nas7/ProjetEmbReact/DataEmbReact/Ripples_On_Breathing_Phase.mat', 'OutPutData' , 'Mean_LFP_respi_shock' , 'Mean_LFP_respi_safe' , 'HistData')

Session_type={'Cond'}; sess=1;
sess=1;
Bins = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.BinnedPhase;
Freq = OutPutData.(Session_type{sess}).hpc_vhigh_on_respi_phase_pref.Frequency;
for i=1:size(PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}),1)
    Phase_Pref(i,:) = interp1(linspace(0,1,size(PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess}),2)) , PhasePref_Averaged.Safe.(Drug_Group{group}).(Session_type{sess})(i,:) , linspace(0,1,200));
end

figure
subplot(121)
imagesc(linspace(0,720,60) , Freq , (Freq'.*SmoothDec([Phase_Pref Phase_Pref],5)));
axis xy, ylim([140 250]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
caxis([50 1.2e2])
makepretty_BM2
hold on
xlabel('Phase (rad'), ylabel('Frequency (Hz)')

colormap jet

Data_to_use = Mean_LFP_respi_safe(ind,:);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
Conf_Inter=(Conf_Inter/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20
Mean_All_Sp = ((Mean_All_Sp-min(Mean_All_Sp))/(max(Mean_All_Sp)-min(Mean_All_Sp)))*20+220;
shadedErrorBar(linspace(0,720,60) , [Mean_All_Sp Mean_All_Sp] , [Conf_Inter Conf_Inter],'-w',1); hold on;


subplot(122)
Data_to_use = HistData.Safe.Cond;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,720,60) , runmean([Mean_All_Sp Mean_All_Sp],5) , runmean([Conf_Inter Conf_Inter],5) ,'-k',1); hold on;
xlim([0 720]), xticks([0 180 360 540 720]), xticklabels({'0','π','2π','3π','4π'})
box off
xlabel('Phase (rad'), ylabel('number of events (#/cycle)')
makepretty_BM, makepretty_BM2
ylim([0 .18])


%% c) OB spectrograms around ripples
% edit OB_Spectrogram_AroundRipples_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Respi_Breathing.mat')

Side={'All','Shock','Safe'};


figure
subplot(221)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(pow2(OB_Low_Around_Rip_All_pretty.(Side{2})),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([.2 1.3]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
title('Shock')

subplot(222)
imagesc(linspace(-window_time,window_time,50) , Range_to_use , SmoothDec(pow2(OB_Low_Around_Rip_All_pretty.(Side{3})),1)'), axis xy
ylim([1 10]), xlabel('time (s)'), ylabel('Frequency (Hz)'), caxis([.2 1.3]),
h=vline(0,'--r'); set(h,'LineWidth',2)
makepretty_BM
u=colorbar; u.Ticks=[.2 1.3]; u.TickLabels={'0','1'}; u.Label.String = 'Power norm. (a.u.)'; u.Label.FontSize=12;
title('Safe')

colormap jet
subplot(223)
Data_to_use = OB_MeanPowerEvol_Around_Rip_All_pretty.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[1 .3 .3]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

OB_MeanPowerEvol_Around_Rand_All_pretty.Shock([17 23 43],:)=NaN;
Data_to_use = OB_MeanPowerEvol_Around_Rand_All_pretty.Shock;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
xlabel('time (s)'), ylabel('Power norm. (log scale)'), %ylim([1 1.7])
h=vline(0,'--r'); set(h,'LineWidth',2)
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');

subplot(224)
Data_to_use = OB_MeanPowerEvol_Around_Rip_All_pretty.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-r',1); hold on;
color=[.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 1]; h.FaceAlpha=.5; h.edge(1).Color=color; h.edge(2).Color=color;

Data_to_use = OB_MeanPowerEvol_Around_Rand_All_pretty.Safe;
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(-window_time,window_time,100), runmean(Mean_All_Sp,3) , runmean(Conf_Inter,3) ,'-k',1); hold on;

makepretty, makepretty_BM2
xlabel('time (s)'),% ylim([-.1 .1])
h=vline(0,'--r'); set(h,'LineWidth',2)
f=get(gca,'Children'); legend([f([5 1])],'ripples times','rand times');



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 4 : Ripples control & inhib
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[.6 .6 .6],[.3 .3 .3]};
X2 = 1:2;
Legends2 = {'Rip control','Rip inhib'};


Cols = {[1 .5 .5],[1 .8 .8],[.5 .5 1],[.8 .8 1]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

%% a) Protocol
% edit Ripples_Inhibition_Analysis_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

Ripples_Inhibition_Example_BM

%% b) Learning is the same
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

figure
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-12 StimNumber.Cond{2}-12},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('aversive stimulation (#)')
makepretty_BM2

[p,~,~] = signrank(StimNumber.Cond{1}-12, StimNumber.Cond{2}-12)

ylim([0 30])
ylim([0 15])
lim=14;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


figure
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},{[.6 .6 .6],[.3 .3 .3]},[1 2],{'Rip Control','Rip inhib'},'showpoints',1,'paired',0);
ylabel('proportion of time'), ylim([0 .35])
makepretty_BM2

ylim([0 1])
lim=.35;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,.4,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.85;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,.9,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


% Occup map
load('/media/nas7/ProjetEmbReact/DataEmbReact/OccupMap_Rip_TestPost.mat')

figure
subplot(121)
imagesc(runmean(runmean(squeeze(nanmean(A{1}))',3)',3)), caxis([0 5e-4]), axis xy, axis square, axis off, hold on
% imagesc(squeeze(nanmean(A{1}))), caxis([0 5e-4]), axis xy, axis square, axis off, colormap hot, hold on
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

subplot(122)
imagesc(runmean(runmean(squeeze(nanmean(A{2}))',3)',3)), caxis([0 5e-4]), axis xy, axis square, axis off, hold on
% imagesc(squeeze(nanmean(A{2}))), caxis([0 5e-4]), axis xy, axis square, axis off, colormap hot, hold on
a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;



%% c) Safe freezing is shock
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot3_SB({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([3 6.5]), ylabel('Breathing (Hz)')
makepretty_BM2

lim=6;
plot([2 3],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(2.5,6.1,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=6.1;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,6.2,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=6.3;
plot([1 3],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(2,6.4,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

figure
subplot(121)
plot(PC_values_shock_sal{1} , PC_values_shock_sal{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe_sal{1} , PC_values_safe_sal{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock_sal{1}) nanmedian(PC_values_shock_sal{2})];
Bar_safe = [nanmedian(PC_values_safe_sal{1}) nanmedian(PC_values_safe_sal{2})];
for mouse=1:length(PC_values_shock_sal{1})
    line([Bar_shock(1) PC_values_shock_sal{1}(mouse)],[Bar_shock(2) PC_values_shock_sal{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe_sal{1}(mouse)],[Bar_safe(2) PC_values_safe_sal{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{1}(mouse) = sqrt((Bar_shock(1)-PC_values_shock_sal{1}(mouse))^2+(Bar_shock(2)-PC_values_shock_sal{2}(mouse))^2);
    DIST_intra{3}(mouse) = sqrt((Bar_safe(1)-PC_values_safe_sal{1}(mouse))^2+(Bar_safe(2)-PC_values_safe_sal{2}(mouse))^2);
    
    DIST_inter{1}(mouse) = sqrt((Bar_safe(1)-PC_values_shock_sal{1}(mouse))^2+(Bar_safe(2)-PC_values_shock_sal{2}(mouse))^2);
    DIST_inter{3}(mouse) = sqrt((Bar_shock(1)-PC_values_safe_sal{1}(mouse))^2+(Bar_shock(2)-PC_values_safe_sal{2}(mouse))^2);
end
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
xlim([-4 4]), ylim([-3 2.5])
vline(0,'--r'), hline(0,'--r')
makepretty_BM2

subplot(122)
plot(PC_values_shock_drug{1} , PC_values_shock_drug{2},'.','Color',[1 .5 .5],'MarkerSize',30)
hold on
plot(PC_values_safe_drug{1} , PC_values_safe_drug{2},'.','Color',[.5 .5 1],'MarkerSize',30)
axis square
xlabel('PC1 value'), ylabel('PC2 value')
grid on
Bar_shock = [nanmedian(PC_values_shock_drug{1}) nanmedian(PC_values_shock_drug{2})];
Bar_safe = [nanmedian(PC_values_safe_drug{1}) nanmedian(PC_values_safe_drug{2})];
for mouse=1:length(PC_values_shock_drug{1})
    line([Bar_shock(1) PC_values_shock_drug{1}(mouse)],[Bar_shock(2) PC_values_shock_drug{2}(mouse)],'LineStyle','--','Color',[1 .5 .5])
    line([Bar_safe(1) PC_values_safe_drug{1}(mouse)],[Bar_safe(2) PC_values_safe_drug{2}(mouse)],'LineStyle','--','Color',[.5 .5 1])
    
    DIST_intra{2}(mouse) = sqrt((Bar_shock(1)-PC_values_shock_drug{1}(mouse))^2+(Bar_shock(2)-PC_values_shock_drug{2}(mouse))^2);
    DIST_intra{4}(mouse) = sqrt((Bar_safe(1)-PC_values_safe_drug{1}(mouse))^2+(Bar_safe(2)-PC_values_safe_drug{2}(mouse))^2);
    
    DIST_inter{2}(mouse) = sqrt((Bar_safe(1)-PC_values_shock_drug{1}(mouse))^2+(Bar_safe(2)-PC_values_shock_drug{2}(mouse))^2);
    DIST_inter{4}(mouse) = sqrt((Bar_shock(1)-PC_values_safe_drug{1}(mouse))^2+(Bar_shock(2)-PC_values_safe_drug{2}(mouse))^2);
end
xlim([-4 4]), ylim([-3 2.5])
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
vline(0,'--r'), hline(0,'--r')
makepretty_BM2


% SVM scores
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Ripples.mat')

SVMChoice_Sf(SVMScores_Sf==0) = NaN;
SVMScores_Sf(SVMScores_Sf==0) = NaN;
SVMChoice_Sk(SVMScores_Sk==0) = NaN;
SVMScores_Sk(SVMScores_Sk==0) = NaN;

SVMChoice_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMScores_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMChoice_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;
SVMScores_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;


figure
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('SVM score')
makepretty_BM2
hline(0,'--k')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 5 : Saline & fluo chronic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit FluoChronic_SumUp_Paper_BM.m

%% Fz shock is like the others

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCondSound.mat', 'Freq_Max_Shock_FearSound','Freq_Max1','Freq_Max2')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FearCtxt.mat', 'Freq_Max_Shock_FearCtxt')

Freq_Max1(46)=4.959;
Freq_Max2(30)=NaN;

Cols = {[1 .5 .5],[.5 .5 1],[.8 .1 .2],[1 .4 .1]};
X = 1:4;
Legends = {'Shock','Safe','Sound','Context'};

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max1(26:end) Freq_Max2(26:end) Freq_Max_Shock_FearSound Freq_Max_Shock_FearCtxt},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 8]), ylabel('Breathing (Hz)')
makepretty_BM2

%% OB power & Fz length

load('/media/nas7/ProjetEmbReact/DataEmbReact/Freezing_Length_OB_Power_BM.mat','R_shock','FzLength_Shock','Session_type','Mouse')

sess=2; 
for mouse=1:length(Mouse)
    l(mouse) = length(FzLength_Shock.(Session_type{sess}){mouse});
end


figure
sess=2; R_shock.(Session_type{sess})(or(R_shock.(Session_type{sess})==1 , R_shock.(Session_type{sess})==0))=NaN;
MakeSpreadAndBoxPlot4_SB({R_shock.(Session_type{sess})(l>10)},{[1 .5 .5]},1,{'Shock'},'showpoints',1,'paired',0);
h=hline(0,'--k'); set(h,'LineWidth',2); ylim([-1 1])
[h,p]=ttest(R_shock.(Session_type{sess})(l>10),zeros(1,length(R_shock.(Session_type{sess})(l>10))))
makepretty_BM2
plot([.7 1.3],[.8 .8],'-k','LineWidth',1.5);
text(1,.9,'***','HorizontalAlignment','Center','FontSize',20);
ylabel('R values')




%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 6 : Reactivations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) ripples
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat', 'Ripples_Shock', 'Ripples_Safe')

figure
MakeSpreadAndBoxPlot3_SB({Ripples_Shock.Fear Ripples_Safe.Fear},Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('ripples occurence (#/s)'), ylim([0 1.1])
makepretty_BM2


load('/media/nas7/ProjetEmbReact/DataEmbReact/Ripples_Mean_Waveform.mat')

figure
subplot(121)
Data_to_use = squeeze(OutPutData.Fear.ripples_meanwaveform(:,5,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001*30) , runmean(resample(Mean_All_Sp,30,1),30) , runmean(resample(Conf_Inter,30,1),30) ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([-50 50])
makepretty_BM
axis off

subplot(122)
Data_to_use = squeeze(OutPutData.Fear.ripples_meanwaveform(:,6,:));
Conf_Inter = nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-400,400,1001*30) , resample(Mean_All_Sp,30,1) , resample(Conf_Inter,30,1) ,'-b',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=color; h.edge(1).Color=color; h.edge(2).Color=color;
xlim([-50 50])
makepretty_BM
axis off


%% b) Place cells
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PlaceCells_Replay_FreezingSafe_BM.mat')
% or 
% edit PLaceCells_Replay_FreezingSafe_BM.m

Cols = {[0 0 1],[.85, .325, .1],[.3 .3 .3],[1 0 0],[.5 .2 .55],[.2 .8 .2]};
Legends = {'Hab1','Hab2','Hab','Cond','PreRipples','Ripples'};
X_plo=[1:6];
Cols2 = {[1 .5 .5],[.5 .5 .5],[.5 .5 1]};
Legends2 = {'Shock','Mid','Safe'};
X2_plo=[1:3];


figure
subplot(241), sess=4;
imagesc( linspace(0,1,100) , [1:size(LinFiring_AllPlaceCells{sess},1)] ,runmean(LinFiring_AllPlaceCells{sess}(OrderToUse,:)',2)')
% imagesc( linspace(0,1,100) , [1:size(LinFiring_AllPlaceCells{sess},1)] , LinFiring_AllPlaceCells{sess}(OrderToUse,:))
caxis([0 .05])
xlabel('linear UMaze distance'), ylabel('HPC neurons no')
hline(max(ShockCells),'--w'), hline(min(SafeCells),'--w')
makepretty_BM

subplot(242)
imagesc(linspace(-250,250,size(MeanFR_AroundRip_all,2)) , [1:size(MeanFR_AroundRip_all,1)] , MeanFR_AroundRip_all(OrderToUse,150:250))
xlabel('time around ripple (ms)'), yticklabels({''}), caxis([0 1]), xticks([-250 0 250])
makepretty_BM
hline(max(ShockCells),'--w'), hline(min(SafeCells),'--w')
colormap viridis

subplot(246)
% Mid
Data_to_use = MeanFR_AroundRip_all(OrderToUse(MidCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.25,.25,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
% SHock
Data_to_use = MeanFR_AroundRip_all(OrderToUse(ShockCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.25,.25,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [1 .5 .5]; h.mainLine.Color=color; h.patch.FaceColor=[.7 .3 .3]; h.edge(1).Color=color; h.edge(2).Color=color;
% Safe
Data_to_use = MeanFR_AroundRip_all(OrderToUse(SafeCells),150:250);
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp = nanmean(Data_to_use);
h=shadedErrorBar(linspace(-.25,.25,size(Data_to_use,2)) , runmean(Mean_All_Sp,5) , runmean(Conf_Inter,5) ,'-r',1); hold on;
color= [.5 .5 1]; h.mainLine.Color=color; h.patch.FaceColor=[.3 .3 .7]; h.edge(1).Color=color; h.edge(2).Color=color;
ylim([-.05 .5]), xlim([-.25 .25]), ylabel('FR (zscore)'), xlabel('time around ripple (s)')
f=get(gca,'Children'); legend([f([9 5 1])],'Shock','Safe','Mid');
makepretty_BM
set(f([9 5 1]),'Linewidth',3)
v=vline(0,'--k'); set(v,'LineWidth',1);


subplot(243)
makepretty_BM
MakeSpreadAndBoxPlot3_SB({RippleAmp(ShockCells),RippleAmp(MidCells),RippleAmp(SafeCells)},Cols2,X2_plo,Legends2,'showpoints',1,'paired',0)
ylabel('FR around ripples (zscore)')


subplot(244)
clear col
col(:,1) = linspace(1,.5,size(MeanFR_AroundRip_all,1));
col(:,2) = ones(1,size(MeanFR_AroundRip_all,1))*0.5;
col(:,3) = linspace(.5,1,size(MeanFR_AroundRip_all,1));

for i=[ShockCells, SafeCells]
    plot(RippleAmp(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [col(i,:)]), hold on
end
for i=MidCells
    plot(RippleAmp(i) ,PeakToUse(OrderToUse(i)) , '.' , 'MarkerSize' , 30 , 'Color' , [.5 .5 .5]), hold on
end
set(gca,'YDir','Reverse')

figure, [R,P,a,b,LINE]=PlotCorrelations_BM(RippleAmp,PeakToUse(OrderToUse), 'method' , 'pearson'); close
% Average position by time block
clear M
RippleBins = [min(RippleAmp):range(RippleAmp)/10:max(RippleAmp)];
for i=1:length(RippleBins)-1
    PosByRippleAmp(i) = mean(PeakToUse(find(and(RippleAmp>RippleBins(i),RippleAmp<=RippleBins(i+1)))));
end
plot(RippleBins(1:end-1),PosByRippleAmp,'color','k','linewidth',3)

xlabel('FR in ripples (a.u.)'), ylabel('linearized distance')
f=get(gca,'Children'); legend([f(1)],['R = ' num2str(round(R,2)) '     P = ' num2str(round(P,2))]);
xlim([-.1 .6])


%% c) Reactivation shock side during freezing
% edit RipplesReactivation_UMaze_DataAnalysis_BM.m , RipplesReactiavtion_UMaze_Wake_Figures_BM.m
% or
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Reactivations_HPC.mat')

MiceNumber = [905,906,911,994,1161,1162,1168,1186,1230,1239];
% Map 2D
Maze_2D_Ripples=[]; n=1;
for mm = 1:length(MiceNumber)
    for i=1:size(MnReact2D_Mov{mm}{9},1)
        clear A; A=real(MnReact2D_Mov{mm}{9});
        Maze_2D_Ripples(n,:,:) = squeeze(A(i,:,:));
        n=n+1;
    end
end

Maze_2D_Ctrl=[]; n=1;
for mm = 1:length(MiceNumber)
    for i=1:size(MnReact2D_Mov{mm}{10},1)
        clear A; A=real(MnReact2D_Mov{mm}{10});
        Maze_2D_Ctrl(n,:,:) = squeeze(A(i,:,:));
        n=n+1;
    end
end

for i=1:10
    for ii=1:10
   
        try, [P(i,ii),~,~] = ranksum(Maze_2D_Ripples(:,i,ii) , Maze_2D_Ctrl(:,i,ii)); end
        
    end
end
P(or(P==0 , P==1))=NaN;


figure
A = squeeze(nanmean(Maze_2D_Ripples))'; A(1:8,5:6)=NaN; %A(8,5)=0;
B = squeeze(nanmean(Maze_2D_Ctrl))';  B(1:8,5:6)=NaN; %B(8,5)=0;

imagesc(smooth2a(A-B,1,1))
axis xy, axis off, axis square, hold on
colormap hot

sizeMap=10; Maze_Frame_BM

a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];



% Mean values shock/safe
AllComp_Shock_rip = [];
AllComp_Safe_rip = [];
AllComp_Shock_ctrl = [];
AllComp_Safe_ctrl = [];
for mm = 1:length(MnReactPos_Mov_Shock)
    AllComp_Shock_rip = [AllComp_Shock_rip;MnReactPos_Mov_Shock{mm}{9}'];
    AllComp_Safe_rip = [AllComp_Safe_rip;MnReactPos_Mov_Safe{mm}{9}'];
    AllComp_Shock_ctrl = [AllComp_Shock_ctrl;MnReactPos_Mov_Shock{mm}{10}'];
    AllComp_Safe_ctrl = [AllComp_Safe_ctrl;MnReactPos_Mov_Safe{mm}{10}'];
end


figure
s=subplot(121);
X = [1 2 3.5 4.5];
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl)...
 AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl)  AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]},X,{'Shock','Safe','Shock','Safe'},'showpoints',0,'paired',0)
ylabel('Reactivation strength'), %ylim([-50 350])
makepretty_BM2

k=1;
line([ones(1,length(AllComp_Shock_rip))*X(k)+.3 ; ones(1,length(AllComp_Shock_rip))*X(k+1)-.3],[AllComp_Shock_rip'./nanmedian(AllComp_Shock_ctrl)  ; AllComp_Safe_rip'./nanmedian(AllComp_Safe_ctrl)], 'color',[.7 .7 .7])
k=3;
line([ones(1,length(AllComp_Shock_ctrl))*X(k)+.3 ; ones(1,length(AllComp_Shock_ctrl))*X(k+1)-.3],[AllComp_Shock_ctrl'./nanmedian(AllComp_Shock_ctrl)  ; AllComp_Safe_ctrl'./nanmedian(AllComp_Safe_ctrl)], 'color',[.7 .7 .7])
symlog(s,'y'), grid off, ylim([-1.5 3])

[p,~,~]=signrank(AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) , AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl))

lim=2.7;
plot([1 2],[lim lim],'-k','LineWidth',1.5);
text(1.5,2.8,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

[p,~,~]=signrank(AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl) , AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl))

lim=2.7;
plot([3.5 4.5],[lim lim],'-k','LineWidth',1.5);
text(4,2.8,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);

[p,~,~]=ranksum(AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) , AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl))

lim=2.9;
plot([1 3.5],[lim lim],'-k','LineWidth',1.5);
text(2.25,3,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



subplot(122);
X = [1 2 3.5 4.5];
MakeSpreadAndBoxPlot3_SB({AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl)...
 AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl)  AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]},X,{'Shock','Safe','Shock','Safe'},'showpoints',0,'paired',0)
ylabel('Reactivation strength'), %ylim([-50 350])
makepretty_BM2



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure : Sleep effects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Saline effects
% freq fz cond
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepEffectsUMaze.mat')

figure
MakeSpreadAndBoxPlot3_SB(Prop.REM,{[ .2 .2 .2],[.8 .5 .2]},X,Legends,'showpoints',0,'paired',1);
ylabel('REM proportion')
makepretty_BM2


figure
PlotCorrelations_BM(Fz_Shock_dur   ,  Prop.Wake{2})
xlabel('Freezing shock duration (min)'), ylabel('Wake proportion')
axis square


figure
PlotCorrelations_BM(Freq_Max_Safe   ,  Prop.REM{2})
xlabel('Freezing safe frequency (Hz)'), ylabel('REM proportion')
axis square


figure
PlotCorrelations_BM( Prop_shock(1,1:11) , Prop.Wake{2}{1} ,'color' , [.3, .745, .93])
PlotCorrelations_BM(Prop_shock(2,1:12) , Prop.Wake{2}{2} , 'color' , [.85, .325, .098])
A = [Prop_shock(1,1:11) Prop_shock(2,1:12)]; A(A>.6)=NaN;
B = [Prop.Wake{2}{1} Prop.Wake{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('Shock proportion, freezing'), ylabel('Wake proportion, Sleep Post')
ylim([0 .6]), xlim([0 .5])


figure
PlotCorrelations_BM( Prop_shock(1,1:11) , Prop.REM{2}{1} ,'color' , [.3, .745, .93])
PlotCorrelations_BM(Prop_shock(2,1:12) , Prop.REM{2}{2} , 'color' , [.85, .325, .098])
A = [Prop_shock(1,1:11) Prop_shock(2,1:12)]; A(A>.7)=NaN;
B = [Prop.REM{2}{1} Prop.REM{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('Shock proportion, freezing'), ylabel('REM proportion, Sleep Post')
ylim([.02 .13]), xlim([0 .7])

figure
PlotCorrelations_BM(OutPutData.Saline.Cond.ripples.mean(:,3)' , Prop.REM{2}{1} , 'color' , [.3, .745, .93])
PlotCorrelations_BM(OutPutData.Diazepam.Cond.ripples.mean(:,3)' , Prop.REM{2}{2} ,'color' , [.85, .325, .098])
A = [OutPutData.Saline.Cond.ripples.mean(:,3)' OutPutData.Diazepam.Cond.ripples.mean(:,3)']; %A(A>.7)=NaN;
B = [Prop.REM{2}{1} Prop.REM{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('SWR occurence, freezing'), ylabel('REM proportion, Sleep Post')
ylim([.02 .13]), xlim([0 1.2])


figure
PlotCorrelations_BM(OutPutData.Saline.Cond.ripples.mean(:,3)' , Prop.Wake{2}{1} , 'color' , [.3, .745, .93])
PlotCorrelations_BM(OutPutData.Diazepam.Cond.ripples.mean(:,3)' , Prop.Wake{2}{2} ,'color' , [.85, .325, .098])
A = [OutPutData.Saline.Cond.ripples.mean(:,3)' OutPutData.Diazepam.Cond.ripples.mean(:,3)']; %A(A>.7)=NaN;
B = [Prop.Wake{2}{1} Prop.Wake{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('SWR occurence, freezing'), ylabel('Wake proportion, Sleep Post')
ylim([.02 .13]), xlim([0 1.2])



%% Rip inhib / rip control
edit rippleInhibSleepEffect_Umaze_SBVF.m

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Sleep.mat')

figure
subplot(121)
A = {MnWk.sleep_post(1,:),MnWk.sleep_post(2,:)};
MakeSpreadAndBoxPlot3_SB(A,[Cols],[1,2],[Drug_Group],'showpoints',1,'paired',0)
ylabel('Wake proportion')
makepretty_BM2


subplot(122)
A = {REM_1hr.sleep_post(1,:),REM_1hr.sleep_post(2,:)};
MakeSpreadAndBoxPlot3_SB(A,[Cols],[1,2],[Drug_Group],'showpoints',1,'paired',0)
ylabel('REM proportion')
makepretty_BM2





figure
TempProfile{1}.REMOverSleep(1,:) = 0;
TempProfile{2}.REMOverSleep(1,:) = 0;
errorbar(timebins,nanmean(TempProfile{1}.REMOverSleep'),stdError(TempProfile{1}.REMOverSleep'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(TempProfile{2}.REMOverSleep'),stdError(TempProfile{2}.REMOverSleep'),'color',Cols{2})
makepretty
xlabel('time(min)')
ylabel('REM/Sleep')
xlim([0 90])
ylim([0 0.2])
for ii = 1:10
    [p(ii),h] = ranksum(TempProfile{1}.REMOverSleep(ii,:),TempProfile{2}.REMOverSleep(ii,:));
    if p(ii)<0.05
        text(timebins(ii),0.18,'*','FontSize',18)
    end
end
legend(Drug_Group)



figure
errorbar(timebins,nanmean(TempProfile{1}.Wake'),stdError(TempProfile{1}.Wake'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(TempProfile{2}.Wake'),stdError(TempProfile{2}.Wake'),'color',Cols{2})
makepretty
xlabel('time(min)')
ylabel('REM/Sleep')
xlim([0 90])
for ii = 1:10
    [p(ii),h] = ranksum(TempProfile{1}.Wake(ii,:),TempProfile{2}.Wake(ii,:));
    if p(ii)<0.05
        text(timebins(ii),0.18,'*','FontSize',18)
    end
end
legend(Drug_Group)




