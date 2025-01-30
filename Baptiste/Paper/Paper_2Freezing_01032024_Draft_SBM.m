

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                                     PAPER SBM                                                        %
%                                                THERE IS 2 FREEZING !!                                                %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : Task presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

edit Display_Maze_BM.m

%% 1) Behaviour Pre/Post

% After AllSalineAnalysis_Maze_Paper_SBM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ZoneAnalysis.mat')

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};


figure
subplot(321)
A = PropTime_Shock.TestPre;
B = PropTime_Safe.TestPre;
ind=or(A>.7,B>.7); % remove mice that spent more than 70% of time in shock zone. 3/51 : 436   469   471.
A(ind) = NaN;
B(ind) = NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)

subplot(322)
A = PropTime_Shock.TestPost;
B = PropTime_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)


subplot(323)
A = Entries_Shock.TestPre;
B = Entries_Safe.TestPre;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 30]), ylabel('entries number')
[h,p] = ttest(A , B)

subplot(324)
A = Entries_Shock.TestPost;
B = Entries_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 30]), ylabel('entries number')
[h,p] = ttest(A , B)


subplot(325)
A = Latency_Shock.TestPre;
B = Latency_Safe.TestPre;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 600]), ylabel('latency first entry (s)')
[h,p] = ttest(A , B)

subplot(326)
A = Latency_Shock.TestPost;
B = Latency_Safe.TestPost;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylim([0 600]), ylabel('latency first entry (s)')
[h,p] = ttest(A , B)



saveFigure_BM(1,'Paper_SBM_Fig1_1','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')
% here shock is 1 and safe 2 



%% 3) Freezing features
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Freeze_Shock_TotDur.Fear Freeze_Safe_TotDur.Fear},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('total freezing duration (s)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({Freeze_Shock_MedDur.Fear Freeze_Safe_MedDur.Fear},Cols,X,Legends,'showpoints',1,'paired',0,'showsigstar','none');
ylabel('freezing episode median (s)')


saveFigure_BM(1,'Paper_SBM_Fig1_4','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


%% 2) Trajectories
% After Trajectories_Function_Maze_BM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Trajectories.mat')


figure
subplot(131)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPre , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2

subplot(132)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
for i=1:4
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(0e4+(i-1)*1440e4,480e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    hold on
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(800e4+(i-1)*1440e4,960e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
    clear D; D = Data(Restrict(Position_tsd_Unblocked.M688.Cond   , intervalSet(1270e4+(i-1)*1440e4,1440e4+(i-1)*1440e4)));
    D(or(D<0,D>1))=NaN;
    plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
end
n=1; clear a
for i=1:length(PositionStimExplo.M688.Cond)
    if isempty(find(PositionStimBlocked.M688.Cond==PositionStimExplo.M688.Cond(i,:)))
        a(n)=i;
        n=n+1;
    end
end
plot(PositionStimExplo.M688.Cond(a,1) , PositionStimExplo.M688.Cond(a,2),'.r','MarkerSize',20);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2

subplot(133)
fill([0 0 .35 .35],[0 .75 .75 0],[1 .5 .5],'FaceAlpha',0.3)
hold on
clear D; D = Data(Restrict(Position_tsd.M688.TestPost , intervalSet(0e4,720e4)));
plot(D(:,1) , D(:,2),'Color',[.3 .3 .3]);
xlim([0 1]); ylim([0 1])
axis off
Maze_Frame_BM2


saveFigure_BM(1,'Paper_SBM_Fig1_3','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



%% c) Hierarchical organization of fear defense behaviours along the Maze

load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/BehaviourAlongMaze.mat') 
% or after BehaviourAlongUMaze_BM.m

smootime = .1;
bin_size = 20;

figure
x =linspace(0,1,bin_size);
for i=1:4
    if i==1
        DATA = EpochLinDist_Jumps_prop2.Cond;
        txt = 'Jumps (prop)';
        val = .035;
    elseif i==2
        DATA = EpochLinDist_RA_prop2.Cond;
        txt = 'RA (prop)';
        val = .1;
    elseif i==3
        DATA = EpochLinDist_Grooming_Unblocked_prop2.Cond  ;
        txt = 'Grooming (prop)';
        val = .3;
    else
        DATA = EpochLinDist_Fz_prop2.Cond;
        txt = 'Freezing (prop)';
        val = .2;
    end
    
    subplot(4,1,i)
    area([-.1 .29] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.3)
    hold on
    area([.29 .447] , [.8 .8] ,'FaceColor',[1 .5 .5],'FaceAlpha',.2)
    area([.447 .552] , [.8 .8] ,'FaceColor',[1 .5 1],'FaceAlpha',.2)
    area([.552 .71] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.2)
    area([.71 1.1] , [.8 .8] ,'FaceColor',[.5 .5 1],'FaceAlpha',.3)
    
    errhigh = nanstd(DATA)/sqrt(size(DATA,1));
    errlow  = zeros(1,bin_size);
    
    b=bar(x,nanmean(DATA));
    b.FaceColor=[.3 .3 .3];
    
    box off
    
    er = errorbar(x,nanmean(DATA),errlow,errhigh);
    er.Color = [0 0 0];
    er.LineStyle = 'none';
    ylabel(txt)
    xlim([-.05 1.05]), ylim([0 val])
    if i==4
        xlabel('linear distance (a.u.)')
    end
end


saveFigure_BM(5,'Paper_SBM_Fig1_2','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')
% proportion of time doing this behaviour in this bin zone






%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 2 : Two types of freezing defined by coordinated cardio-respiratory states parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mouse example
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ExampleMouse.mat')
% or after 
% edit Freezing_FarFromStims_Maze_BM.m

mouse=14; sess=1;
Freeze.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FolderList.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
FreezeShock = intervalSet([1686e4 1700e4],[1695e4 1707e4]);
FreezeSafe = intervalSet([1714e4],[1780e4]);

Acc.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
Smooth_Acc=tsd(Range(Acc.Cond.(Mouse_names{mouse})),runmean(Data(Acc.Cond.(Mouse_names{mouse})),ceil(1/median(diff(Range(Acc.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_Acc_Freeze = Restrict(Smooth_Acc,Freeze.Cond.(Mouse_names{mouse}));
Smooth_Acc_FreezeShock = Restrict(Smooth_Acc,FreezeShock);
Smooth_Acc_FreezeSafe = Restrict(Smooth_Acc,FreezeSafe);

HR.(Session_type{sess}).(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'heartrate');
Smooth_HR=tsd(Range(HR.Cond.(Mouse_names{mouse})),runmean(Data(HR.Cond.(Mouse_names{mouse})),ceil(3/median(diff(Range(HR.Cond.(Mouse_names{mouse}),'s'))))));
Smooth_HR_Freeze = Restrict(Smooth_HR,Freeze.Cond.(Mouse_names{mouse}));
Smooth_HR_FreezeShock = Restrict(Smooth_HR,FreezeShock);
Smooth_HR_FreezeSafe = Restrict(Smooth_HR,FreezeSafe);



figure
a=subplot(3,4,1:3); %a.Position=[.13 .71 .694 .2157];
plot(Range(Smooth_Acc,'s') , Data(Smooth_Acc)/1e7,'k','LineWidth',2)
hold on
plot(Range(Smooth_Acc_FreezeShock,'s') , Data(Smooth_Acc_FreezeShock)/1e7,'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_Acc_FreezeSafe,'s') , Data(Smooth_Acc_FreezeSafe)/1e7,'.','LineWidth',2,'Color',[.5 .5 1])
xticklabels({'','','','','','',''}), xlim([1660 1780]), ylim([0 15])
ylabel('Motion (a.u.)'), xticks([1660:20:1780])
f=get(gca,'Children'); l=legend([f(2),f(1)],'Freezing shock','Freezing safe'); l.Box='off';
box off

subplot(344)
MakeSpreadAndBoxPlot3_SB({OutPutData.Fear.accelero.mean(:,5)/1e7 OutPutData.Fear.accelero.mean(:,6)/1e7},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Motion (a.u.)')
ylim([0 3])


a=subplot(3,4,5:7); val=14.5;
imagesc(Range(OB_Low_Spec.Cond.(Mouse_names{mouse}))/1e4 , Spectro{3} , runmean(runmean(log10(Spectro{3}'.*Data(OB_Low_Spec.Cond.(Mouse_names{mouse}))'),10)',10)'), axis xy
line([1660 1708],[val val],'Color',[1 .5 .5],'Linewidth',10)
line([1708 1711],[val val],'Color',[.8 .5 .8],'Linewidth',10)
line([1711 1780],[val val],'Color',[.5 .5 1],'Linewidth',10)
line([[1686 1700 1714];[1695 1707 1780]],[13 13],'Color',[.5 .5 .5],'Linewidth',10)
ylim([.15 15]), xlim([1660 1780]), 
xticklabels({'','','','','','',''}), yticks([0:2:14]), text(1658,-.1,'0')
h=hline(4.5,'--r'); h.LineWidth=3;xticks([1660:20:1780])
caxis([5.1 6.9])
ylabel('OB frequency (Hz)')
box off
f=get(gca,'Children'); l=legend([f(7),f(6),f(5),f(4)],'Shock arm','Center','Safe arm','Freezing'); 
l.Box='off';
c=colorbar; c.Ticks=[]; c.Label.String='Power (log scale)';
colormap jet

subplot(348)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 7])


a=subplot(3,4,9:11); %a.Position=[.13 .11 .694 .2157];
plot(Range(Smooth_HR,'s') , Data(Smooth_HR),'k','LineWidth',2)
hold on
plot(Range(Smooth_HR_FreezeShock,'s') , Data(Smooth_HR_FreezeShock),'.','LineWidth',2,'Color',[1 .5 .5])
plot(Range(Smooth_HR_FreezeSafe,'s') , Data(Smooth_HR_FreezeSafe),'.','LineWidth',2,'Color',[.5 .5 1])
xlim([1660 1780]), ylim([8 14])
xlabel('time (s)'), ylabel('Heart rate (Hz)')
xticklabels({'0','20','40','60','80','100','120'})
box off

subplot(3,4,12)
MakeSpreadAndBoxPlot3_SB(OutPutData.Fear.heartrate.mean(:,5:6),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Heart rate (Hz)')


saveFigure_BM(6,'Paper_SBM_Fig2_1','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



% LFP
figure
clear TSD; TSD = OB_LFP_Fz_Shock.Cond{15};
subplot(211)
plot(interp1(linspace(0,1,length(TSD)) , Range(TSD,'s'), linspace(0,1,length(TSD)*10)) , resample(Data(TSD),10,1),'Color',[1 .5 .5],'LineWidth',1.5)
hold on
plot([Range(InstFreq_OB.Cond{15},'s') Range(InstFreq_OB.Cond{15},'s')],[-1e4 1e4],'--','Color',[.5 .5 .5]);
xlim([2411 2414]), ylim([-7e3 7e3])
axis off

clear TSD; TSD = OB_LFP_Fz_Safe.Cond{15};
subplot(212)
plot(interp1(linspace(0,1,length(TSD)) , Range(TSD,'s'), linspace(0,1,length(TSD)*10)) , resample(Data(TSD),10,1),'Color',[.5 .5 1],'LineWidth',1.5)
hold on
plot([Range(InstFreq_OB.Cond{15},'s') Range(InstFreq_OB.Cond{15},'s')],[-1e4 1e4],'--','Color',[.5 .5 .5]);
xlim([1425 1428]), ylim([-7e3 7e3])
axis off


saveFigure_BM(5,'Paper_SBM_Fig2_2','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



%% Mean OB spectrum frequencies
% load('/media/nas7/ProjetEmbReact/DataEmbReact/OB_Spec.mat')
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
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty_BM
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])

saveFigure_BM(1,'Paper_SBM_Fig2_3','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


% Box plots
Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
[h , MaxPowerValues1 , Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Shock.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 1);
[h , MaxPowerValues2 , Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_NoClean_Safe.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 1);
close
Freq_Max1(7)=NaN; Freq_Max2(7)=1.373;
Freq_Max2(8)=NaN;


figure
subplot(1,3,1:2)
MakeSpreadAndBoxPlot3_SB({Freq_Max1 Freq_Max2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([0 8])

Cols2={[.3 .3 .3]};
X2=[1];
Legends2={'Respi diff'};

subplot(133)
MakeSpreadAndBoxPlot4_SB({Freq_Max1-Freq_Max2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)')
ylim([-.5 4])
hline(0,'--r')


saveFigure_BM(2,'Paper_SBM_Fig2_4','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



% edit Paper_2Freezing_Supp_SBM.m for more



%% Other physio params
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat')
% or after 
% MeanBodyParameters_Freezing_Maze_BM.m

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
subplot(131)
MakeSpreadAndBoxPlot3_SB(OutPutData.Fear.heartrate.mean(:,5:6),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('heart rate (Hz)')

subplot(132)
MakeSpreadAndBoxPlot3_SB(OutPutData.Fear.heartratevar.mean(:,5:6),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('heart rate variability (a.u.)')

subplot(133)
MakeSpreadAndBoxPlot3_SB(OutPutData.Fear.tailtemperature.mean(30:36,5:6),Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('tail temperature (°C)')
ranksum(OutPutData.Fear.tailtemperature.mean(30:36,5),OutPutData.Fear.tailtemperature.mean(30:36,6))

saveFigure_BM(1,'Paper_SBM_Fig2_5','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


% accelero
Cols = {[.5 .5 .5],[1 0.5 0.5],[0.5 0.5 1]};
X = [1:3];
Legends = {'Active','Shock','Safe'};

figure, sess=1;
subplot(121)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.TestPre.accelero.mean(:,4)) log10(OutPutData.Fear.accelero.mean(:,5)) log10(OutPutData.Fear.accelero.mean(:,6))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('movement quantity (log scale)')
ranksum(OutPutData.Fear.accelero.mean(:,5),OutPutData.Fear.accelero.mean(:,6))

subplot(122)
MakeSpreadAndBoxPlot3_SB({log10(OutPutData.TestPre.emg_pect.mean(:,4)) log10(OutPutData.Fear.emg_pect.mean(:,5)) log10(OutPutData.Fear.emg_pect.mean(:,6))},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('EMG power (log scale)')
ranksum(log10(OutPutData.Fear.emg_pect.mean(:,5)),log10(OutPutData.Fear.emg_pect.mean(:,6)))


saveFigure_BM(2,'Paper_SBM_Fig2_6','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


%% Spider map
% edit GetSpiderMapData_BM.m 
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat')

P=[nanmedian(DATA_TO_PLOT.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,:),3)'];
P(:,5:6) =log10(P(:,5:6));

figure
s = spider_plot_class(P);
s.AxesLabels =  {'Breathing','HR','HR var','Tail T°','EMG','Motion'};
s.LegendLabels = {'Freezing shock', 'Freezing safe'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on'};
s.Color = [1 .5 .5; .5 .5 1];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';
s.AxesLimits(:,5:6) = [4.2 7 ; 5.4 7.8];


saveFigure_BM(7,'Paper_SBM_Fig2_7','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')


%% Decoding accuracy
% edit ROC_curves_BodyParametersFreezingUMaze_BM.m








%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 3 : Two types of freezing defined by coordinated brain states parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Mean spectrum















