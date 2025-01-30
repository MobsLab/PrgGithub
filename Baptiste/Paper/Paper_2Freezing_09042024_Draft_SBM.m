
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                                     PAPER SBM                                                        %
%                                                THERE IS 2 FREEZING !!                                                %

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 1 : Task presentation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% a) Cartoon protocol / trajectories / stats proportion

% protocol cartoon 
edit Display_Maze_BM.m


% trajectories

% After Trajectories_Function_Maze_BM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Trajectories2.mat')

% or Example_Trajectories_Paper_FreezingMaze_BM

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
plot(PositionStimExplo.M688.Cond(a,1) , PositionStimExplo.M688.Cond(a,2),'.r','MarkerSize',40);
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


% Stats proportion
% After AllSalineAnalysis_Maze_Paper_SBM
% or
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/ZoneAnalysis.mat')

Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};


figure
subplot(121)
A = PropTime_Shock.TestPre;
B = PropTime_Safe.TestPre;
ind=or(A>.7,B>.7); % remove mice that spent more than 70% of time in shock zone. 3/51 : 436   469   471.
A(ind) = NaN;
B(ind) = NaN;
MakeSpreadAndBoxPlot_BM({A B},Cols,X,Legends,0,1);
ylim([0 1.2]), ylabel('proportion of time')
[h,p] = ttest(A , B)

plot([1 2],[1.1 1.1],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.15,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2


subplot(122)
A = PropTime_Shock.TestPost; A(isnan(A))=0;
B = PropTime_Safe.TestPost;
MakeSpreadAndBoxPlot_BM({A B},Cols,X,Legends,0,1);
ylim([0 1.2])
[h,p] = ttest(A , B)

plot([1 2],[1.1 1.1],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.12,'***','HorizontalAlignment','Center','BackGroundColor','none','Tag','sigstar_stars','FontSize',20);
makepretty_BM2



%% b) Cartoon recording + neurons + LFP
% or Example_Paper_FreezingMaze_BM.m

cd('/media/nas5/ProjetERC2/Mouse-905/20190404/PAGExp/_Concatenated/')

load('LFPData/LFP4.mat'), LFP_4=LFP;
load('LFPData/LFP10.mat'), LFP_10=LFP;
load('LFPData/LFP6.mat'), LFP_6=LFP;
load('LFPData/LFP3.mat'), LFP_3=LFP;

load('SpikeData.mat')

LFP_4_fil = FilterLFP(LFP_4,[10 200]);

window=[13795 13797];

LFP_4_Dat = Data(Restrict(LFP_4_fil , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_10_Dat = Data(Restrict(LFP_10 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_6_Dat = Data(Restrict(LFP_6 , intervalSet(window(1)*1e4 , window(2)*1e4)));
LFP_3_Dat = Data(Restrict(LFP_3 , intervalSet(window(1)*1e4 , window(2)*1e4)));

figure
subplot(211)
plot(LFP_4_Dat*4+3e4, 'k')
hold on
plot(LFP_10_Dat+2e4 , 'k')
plot(LFP_6_Dat+1e4 , 'k')
plot(LFP_3_Dat*2 , 'k')
xlim([0 length(LFP_4_Dat)]), axis off


subplot(212)
RasterPlot_SB(S,'FigureHandle',2)
xlim([window(1)*1e3 window(2)*1e3])
xlabel('time (s)'), ylabel('HPC neuron no.')
xticks([window(1)*1e3:1e3:window(2)*1e3]), xticklabels({'0','1','2','3'}) 
makepretty_BM2




LFP_10_fil = FilterLFP(LFP_10,[1 15]);
load('InstFreqAndPhase_B.mat')
Phase_on_LFP = Restrict(LocalPhase.PT , LFP_10); 
Data_Phase_on_LFP = Data(Restrict(Phase_on_LFP , intervalSet(window(1)*1e4,window(2)*1e4)));
Data_LFP = Data(Restrict(LFP_10_fil , intervalSet(window(1)*1e4,window(2)*1e4)));
for f=1:37
    A(f) = round(median(find(Data_Phase_on_LFP((f-1)*100+1:100*f)<.01)))+(f-1)*100;
end

figure
plot(Data_LFP , 'k' , 'LineWidth' , 2), xlim([0 length(Data_LFP)])
hold on
plot(A(~isnan(A)) , Data_LFP(A(~isnan(A))) , '.r' , 'MarkerSize' , 20)
axis off





%% c) Freezing in the Maze
load('/media/nas7/ProjetEmbReact/DataEmbReact/Trajectories_PAG.mat','OccupMap_squeeze')
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/FreezingDuration.mat','FreezingShock_prop','FreezingSafe_prop')

A = OccupMap_squeeze.Freeze.Fear{1}./OccupMap_squeeze.All.Fear{1};

for i=1:10
    for ii=1:10
        
        D(i,ii) = nanmean(nanmean(A((i-1)*10+1:i*10,(ii-1)*10+1:ii*10)));
        
    end
end
D(1:8,5:6)=NaN;


Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};


figure
subplot(221)
imagesc(D)
axis xy, axis off, hold on, axis square, c=caxis; %caxis([0 1e-3])
sizeMap=10; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap magma

a=area([4.6 6.4],[8.4 8.4]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

freezeColors

A(isnan(A))=0;
subplot(222)
imagesc(SmoothDec(A,2))
axis xy, axis off, hold on, axis square, caxis([0 1.8]), c=caxis; %caxis([0 1e-3])
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)
colormap jet

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

subplot(313)
a=barh([1],[-nanmean(FreezingShock_prop.Fear{1})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_prop.Fear{1}),1,nanstd(FreezingShock_prop.Fear{1})/sqrt(length(FreezingShock_prop.Fear{1})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; a.LineWidth=2;
handlesplot=plotSpread({-FreezingShock_prop.Fear{1}},'distributionColors','k','xValues',1,'spreadWidth',0.8,'xyOri','flipped'); 
set(handlesplot{1},'MarkerSize',5)

a=barh([1],[nanmean(FreezingSafe_prop.Fear{1})],'stacked'); 
errorbar(nanmean(FreezingSafe_prop.Fear{1}),1,0,nanstd(FreezingSafe_prop.Fear{1})/sqrt(length(FreezingSafe_prop.Fear{1})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; a.LineWidth=2;
handlesplot=plotSpread({FreezingSafe_prop.Fear{1}},'distributionColors','k','xValues',1,'spreadWidth',0.8,'xyOri','flipped'); 
set(handlesplot{1},'MarkerSize',5)

xlabel('freezing proportion'), yticklabels({''}), 
makepretty
xlim([-.8 .8])


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
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.accelero.mean(:,5)/1e7 OutPutData.Fear.accelero.mean(:,6)/1e7},Cols,X,Legends,1,0);
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
MakeSpreadAndBoxPlot_BM({Freq_Max1 Freq_Max2},Cols,X,Legends,1,0);
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
MakeSpreadAndBoxPlot_BM(OutPutData.Fear.heartrate.mean(:,5:6),Cols,X,Legends,1,0);
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
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([0 15]); ylim([0 1])
makepretty
v1=vline(nanmean(4.73)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(3.053)); set(v2,'LineStyle','--','Color',[.5 .5 1])
xticks([0:2:14])

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
MakeSpreadAndBoxPlot_BM({Freq_Max1 Freq_Max2},Cols,X,Legends,0,1);
ylabel('Breathing (Hz)')
ylim([0 8])
lim=7.5;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(152)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.heartrate.mean(:,5) OutPutData.Fear.heartrate.mean(:,6)},Cols,X,Legends,0,1);
ylabel('Heart rate (Hz)'), ylim([8.5 13.5])
lim=13;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(153)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.heartratevar.mean(:,5) OutPutData.Fear.heartratevar.mean(:,6)},Cols,X,Legends,0,1);
ylabel('Heart rate variability (a.u.)'), ylim([0 .45])
lim=.39;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(154)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.accelero.mean(:,5)/1e7 OutPutData.Fear.accelero.mean(:,6)/1e7},Cols,X,Legends,0,1);
ylabel('Motion (a.u.)'), ylim([0 3])
lim=2.7;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(155)
MakeSpreadAndBoxPlot_BM({log10(OutPutData.Fear.emg_pect.mean(:,5)) log10(OutPutData.Fear.emg_pect.mean(:,6))},Cols,X,Legends,0,1);
ylabel('EMG power (log scale)'), ylim([3.6 5.2])
lim=5;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

saveFigure_BM(2,'Paper_SBM_Fig2_6','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')

%% Brain
% ripples
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/MeanBodyValues_Fz.mat')

figure
MakeSpreadAndBoxPlot_BM({Ripples_Shock.Fear Ripples_Safe.Fear},Cols,X,Legends,0,1);
ylabel('ripples occurence (#/s)'), ylim([0 1.1])
lim=1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
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


% box plot
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat')


figure
subplot(141)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.ob_gamma_freq.mean(:,5) OutPutData.Fear.ob_gamma_freq.mean(:,6)},Cols,X,Legends,0,1);
ylabel('OB gamma frequency (Hz)')
ylim([58 76])
lim=74;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

subplot(142)
MakeSpreadAndBoxPlot_BM({OutPutData.Fear.ob_gamma_power.mean(:,5) OutPutData.Fear.ob_gamma_power.mean(:,6)},Cols,X,Legends,0,1);
ylabel('OB gamma power (a.u.)')
ylim([.9 1.45])
lim=1.4;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
makepretty_BM2

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


% mean spectrums
load('/media/nas7/ProjetEmbReact/DataEmbReact/MeanSpectrum.mat')

figure
subplot(121)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.hpc_low.mean(:,5,:)), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.hpc_low.mean(:,6,:)) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);

f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([2 12]); ylim([0 .9])
makepretty


subplot(122)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,5,:)), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Fear.ob_high.mean(:,6,:)) , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);

xlabel('Frequency (Hz)'); ylabel('Power (a.u.)'); xlim([40 100]); 
makepretty
v1=vline(nanmean(68.58)); set(v1,'LineStyle','--','Color',[1 .5 .5]); v2=vline(nanmean(63.58)); set(v2,'LineStyle','--','Color',[.5 .5 1])



%% Spider map
% edit GetSpiderMapData_BM.m 
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat')

load('/media/nas7/ProjetEmbReact/DataEmbReact/Spider_Map_PCA.mat','P')
P2 = squeeze(nanmedian(P));
P2=P2(:,[1 2 4 3 5:8]);

s = spider_plot_class(P2);
s.AxesLabels =  {'Breathing','Heart rate','OB gamma frequency','Heart rate variability','OB gamma power','Ripples occurence','HPC theta frequency','HPC theta power'};
s.LegendLabels = {'Freezing shock', 'Freezing safe'};
s.AxesInterval = 2;
s.FillOption = { 'on', 'on'};
s.Color = [1 .5 .5; .5 .5 1];
s.LegendHandle.Location = 'northeastoutside';
s.AxesLabelsEdge = 'none';xesLimits(:,5:6) = [4.2 7 ; 5.4 7.8];


saveFigure_BM(7,'Paper_SBM_Fig2_7','/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')



%% d) PCA analysis
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/PCA_Analysis.mat')
% or
% edit PCA_Freezing_CondPost_Dimensions_BM.m


% PC weights & eigen values
Col_to_use = {[0 0 0],[.3 .3 .3],[.6 .6 .6],[.8 .8 .8]};
[a,b] = sort(eigen_vector(:,1),'descend');
l = [5 3 2 1];

figure
for i=[4 3 2 1]
    plot(eigen_vector(b,i),'Color',Col_to_use{i},'LineWidth',l(i))
    hold on
    plot(eigen_vector(b,i),'.','MarkerSize',50,'Color',Col_to_use{i})
end
xticklabels({'Heart rate','Breathing','OB gamma frequency','HPC theta power','HPC theta frequency','OB gamma power','Ripples occurence','Heart rate variability'})
xtickangle(45)
box off
makepretty_BM2
axis square
h=hline(0,'--k'); set(h,'LineWidth',2);
ylabel('PC weight (a.u.)'), ylim([-.7 .7])
vline([1:8],'--k')
f=get(gca,'Children'); legend([f([1 3 5 7])],'PC1','PC2','PC3','PC4');

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



% 3D figure
figure
Bar_shock = [nanmedian(PC_values_shock{1}) nanmedian(PC_values_shock{2}) nanmedian(PC_values_shock{4})];
Bar_safe = [nanmedian(PC_values_safe{1}) nanmedian(PC_values_safe{2}) nanmedian(PC_values_safe{4})];
Bar_act = [nanmedian(PC_values_active{1}) nanmedian(PC_values_active{2}) nanmedian(PC_values_active{4})];
Bar_sleep = [nanmedian(PC_values_sleep{1}) nanmedian(PC_values_sleep{2}) nanmedian(PC_values_sleep{4})];
Bar_quiet = [nanmedian(PC_values_quiet{1}) nanmedian(PC_values_quiet{2}) nanmedian(PC_values_quiet{4})];

plot3(Bar_shock(1),Bar_shock(2),Bar_shock(3),'.','MarkerSize',100,'Color',[1 .5 .5]), hold on
plot3(Bar_safe(1),Bar_safe(2),Bar_safe(3),'.','MarkerSize',100,'Color',[.5 .5 1])
plot3(Bar_act(1),Bar_act(2),Bar_act(3),'.','MarkerSize',100,'Color',[.8 .3 .1])
plot3(Bar_sleep(1),Bar_sleep(2),Bar_sleep(3),'.','MarkerSize',100,'Color',[.8 .5 0])
plot3(Bar_quiet(1),Bar_quiet(2),Bar_quiet(3),'.','MarkerSize',100,'Color',[.5 .8 .5])

grid on
xlabel('PC1 value (a.u.)'), ylabel('PC2 value (a.u.)'), zlabel('PC4 value (a.u.)')



% SVM
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Sal_MouseByMouse_CondPost.mat')

svm_type = 1; % linear
parToUse = 1; % all variables

SVMChoice_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMScores_Sf_Ctrl{svm_type}(SVMScores_Sf_Ctrl{svm_type}==0) = NaN;
SVMChoice_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;
SVMScores_Sk_Ctrl{svm_type}(SVMScores_Sk_Ctrl{svm_type}==0) = NaN;

figure
MakeSpreadAndBoxPlot_BM({nanmean(SVMScores_Sk_Ctrl{svm_type}),nanmean(SVMScores_Sf_Ctrl{svm_type})},...
    {[1 0.5 0.5],[0.5 0.5 1]},[1,2],{'Shock','Safe'},0,1);
makepretty_BM2
ylabel('SVM score (a.u.)')
hline(0,'--k')

[~,p]=ttest(nanmean(SVMScores_Sk_Ctrl{svm_type}),nanmean(SVMScores_Sf_Ctrl{svm_type}))

ylim([-5 5])
lim=5;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'***','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




figure
PlotErrorBarN_KJ({nanmean(1-SVMChoice_Sk_Ctrl{svm_type}),nanmean(SVMChoice_Sf_Ctrl{svm_type})},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
makepretty_BM2
ylabel('Cross validated SVM accuracy')
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
Cols2 = {[1 1 1],[.7 .7 .7]};
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
MakeSpreadAndBoxPlot_BM({StimNumber.Cond{1}-12 StimNumber.Cond{2}-12},Cols2,X2,Legends2,1,0);
ylabel('aversive stimulation (#)')
makepretty_BM2

[p,~,~] = signrank(StimNumber.Cond{1}-12, StimNumber.Cond{2}-12)

ylim([0 15])
lim=14;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


figure
MakeSpreadAndBoxPlot_BM({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2} Zone2_Occupancy.TestPost{1} Zone2_Occupancy.TestPost{2}},Cols,X,Legends,1,0);
a=area([1.5 2.5],[1 1]); a.FaceColor=[.3 .3 .3]; a.EdgeColor=[1 1 1]; a.FaceAlpha=.3;
a=area([3.5 4.5],[1 1]); a.FaceColor=[.3 .3 .3]; a.EdgeColor=[1 1 1]; a.FaceAlpha=.3;
ylabel('proportion of time'), ylim([0 1])
makepretty_BM2

ylim([0 1])
lim=.35;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,.4,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.85;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,.9,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


%% c) Safe freezing is shock
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/RipInhib_Data.mat')

OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot_BM({OB_Max_Freq.RipControl.Cond.Shock OB_Max_Freq.RipInhib.Cond.Shock...
OB_Max_Freq.RipControl.Cond.Safe OB_Max_Freq.RipInhib.Cond.Safe},Cols,X,Legends,1,0);
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


figure;
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot_BM(A,Cols,X,Legends,1,0)
ylabel('SVM score')
makepretty_BM2
hline(0,'--k')
yl = max(abs(ylim));
ylim([-yl yl])

[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});

lim=3.1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,3.4,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=1.5;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,1.8,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


subplot(122)
A = {nanmean(1-SVMChoice_Sk_Ctrl),nanmean(1-SVMChoice_Sk),nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf)};
PlotErrorBarN_KJ(A,'barcolors',Cols,'newfig',0,'showpoints',0,'x_data',[1:4],'ShowSigstar','none')
set(gca,'XTick',1:4,'XtickLabel',Legends)
xtickangle(45)
ylabel('accuracy')
makepretty_BM2
ylim([0 1.1])
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});

lim=1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.1,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=1;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,1.1,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 5 : Saline & fluo chronic
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[1 1 1],[.7 .7 .7]};
X2 = 1:2;
Legends2 = {'Saline','Chronic flx'};


Cols = {[1 .5 .5],[.7 .3 .3],[.5 .5 1],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};


%% b) Learning is the same
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

figure
MakeSpreadAndBoxPlot_BM({StimNumber.Cond{1}-16 StimNumber.Cond{2}-16},Cols2,X2,Legends2,1,0);
ylabel('aversive stimulations (#)')
makepretty_BM2

[p,~,~] = signrank(StimNumber.Cond{1}-16, StimNumber.Cond{2}-16)

ylim([0 40])
lim=36;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,lim*1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


figure
MakeSpreadAndBoxPlot_BM({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2} Zone2_Occupancy.TestPost{1} Zone2_Occupancy.TestPost{2}},Cols,X,Legends,1,0);
ylabel('proportion of time'), ylim([0 1])
makepretty_BM2

lim=1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=1;
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,1.05,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


%% c) Shock freezing is safe
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Fluo_Data.mat')

OB_MaxFreq_Maze_BM

figure
MakeSpreadAndBoxPlot_BM({OB_Max_Freq.SalineSB.Ext.Shock OB_Max_Freq.ChronicFlx.Ext.Shock...
OB_Max_Freq.SalineSB.Ext.Safe OB_Max_Freq.ChronicFlx.Ext.Safe},Cols,X,Legends,1,0);
ylim([1 5.5]), ylabel('Breathing (Hz)')
makepretty_BM2

[p(1),h,stats] = ranksum(A{1},A{2});


lim=5.1;
plot([1 3],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(2,5.2,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=5.4;
plot([1 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(2.5,5.5,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


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
xlim([-4 4]), ylim([-3 3])
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
xlim([-4 4]), ylim([-3 3])
plot(Bar_shock(1),Bar_shock(2),'.','Color',[1 .5 .5],'MarkerSize',60)
plot(Bar_safe(1),Bar_safe(2),'.','Color',[.5 .5 1],'MarkerSize',60)
vline(0,'--r'), hline(0,'--r')
makepretty_BM2
xlim([-4 4]), ylim([-3 3])




% SVM scores
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_Flx_Chr.mat')

SVMChoice_Sf(SVMScores_Sf==0) = NaN;
SVMScores_Sf(SVMScores_Sf==0) = NaN;
SVMChoice_Sk(SVMScores_Sk==0) = NaN;
SVMScores_Sk(SVMScores_Sk==0) = NaN;

SVMChoice_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMScores_Sf_Ctrl(SVMScores_Sf_Ctrl==0) = NaN;
SVMChoice_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;
SVMScores_Sk_Ctrl(SVMScores_Sk_Ctrl==0) = NaN;



figure;
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot_BM(A,Cols,X,Legends,1,0)
ylabel('SVM score')
makepretty_BM2
hline(0,'--k')
yl = max(abs(ylim));
ylim([-yl yl])

[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});

lim=6.4;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,6.6,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,6.8,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);


subplot(122)
A = {nanmean(1-SVMChoice_Sk_Ctrl),nanmean(1-SVMChoice_Sk),nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf)};
PlotErrorBarN_KJ(A,'barcolors',Cols,'newfig',0,'showpoints',0,'x_data',[1:4],'ShowSigstar','none')
set(gca,'XTick',1:4,'XtickLabel',Legends)
xtickangle(45)
ylabel('accuracy')
makepretty_BM2
ylim([0 1.1])
[p(1),h,stats] = ranksum(A{1},A{2});
[p(2),h,stats] = ranksum(A{3},A{4});

lim=1.1;
plot([1 2],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1.5,1.15,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
plot([3 4],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(3.5,1.15,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);






%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Figure 6 : Reactivations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% a) Reactivation shock side during freezing
% edit RipplesReactivation_UMaze_DataAnalysis_BM.m , RipplesReactiavtion_UMaze_Wake_Figures_BM.m
% or
% load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Reactivations_HPC.mat')


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


figure;
s=subplot(121);
X = [1 2 3.5 4.5];
MakeSpreadAndBoxPlot_BM({AllComp_Shock_rip./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_rip./nanmedian(AllComp_Safe_ctrl)...
 AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl)  AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1],[1 .8 .8],[.8 .8 1]},X,{'Shock','Safe','Shock','Safe'},0,0)
ylabel('Reactivation strength'), %ylim([-50 350])
makepretty

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




s=subplot(122);
MakeSpreadAndBoxPlot_BM({AllComp_Shock_ctrl./nanmedian(AllComp_Shock_ctrl) AllComp_Safe_ctrl./nanmedian(AllComp_Safe_ctrl)},{[1 .5 .5],[.5 .5 1]},[1 2],{'Shock','Safe'},0,1)
makepretty
symlog(s,'y'), grid off, ylim([-1.5 3])













