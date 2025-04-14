

Cols2 = {[.3, .745, .93],[.85, .325, .098]};
X2 = 1:2;
Legends2 = {'Saline','Diazepam'};


Cols = {[1 .5 .5],[.7 .3 .3],[.5 .5 1],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

edit GenerateSleep_Data_Diazepam_BM.m

edit GeneratePCA_Data_Diazepam_BM.m

edit GenerateSVM_Data_Diazepam_BM.m


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% Generate data part
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù

edit SumUp_Diazepam_RipInhib_Maze_BM.m

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Behav.mat')

Thigmo_score.TestPre{2}([6 9 12]) = NaN;
Thigmo_score.Cond{2}([6 9 12]) = NaN;


% Occup map and trajectories
Group=[13 15];
GetEmbReactMiceFolderList_BM
Session_type={'CondPre','CondPost'};

Trajectories_Function_Maze_BM


% OB Low
clear all
Session_type={'CondPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'ripples','respi_freq_bm');
    end
end


% OB Low
clear all
Session_type={'CondPost'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),'ob_low');
    end
end


figure
[~,~,Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,5,:)));
[~,~,Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.Fear.ob_low.mean(:,6,:)));
close


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù
%% FIGURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ùù


%% a) Learning is the same
% edit SumUp_Diazepam_RipInhib_Maze_BM.m
% or 
% load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Behav.mat')

% stims number
figure
subplot(171)
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-12 StimNumber.Cond{2}-12},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('shocks (#)')


% TestPost occupancy
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPre{1} ShockZone_Occupancy.TestPre{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)'), ylim([0 .6])

subplot(122)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)'), ylim([0 .35])


%Freezing
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(FreezingShock_Dur.Cond,Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('Fz duration, shock zone (s)')%, ylim([0 .4])
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(FreezingSafe_Dur.Cond,Cols3,X3,Legends3,'showpoints',1,'paired',0);
ylabel('Fz duration, safe zone (s)')%, ylim([0 .4])
makepretty_BM2



% thigmotaxis
subplot(174)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.TestPre,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('thigmotaxis (a.u.))'), ylim([.4 1])

subplot(175)
MakeSpreadAndBoxPlot3_SB(Thigmo_score.Cond,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('thigmotaxis (a.u.))'), ylim([.4 1])


% mean speed
subplot(176)
MakeSpreadAndBoxPlot3_SB(MeanSpeed.TestPre,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('speed (cm/s))'), %ylim([.4 1])

subplot(177)
MakeSpreadAndBoxPlot3_SB(MeanSpeed.Cond,Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('speed (cm/s))'), %ylim([.4 1])




% Occup map
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        
        NewSpeed=tsd(Range(Speed.(Session_type{sess}).(Mouse_names{mouse})),runmean(Data(Speed.(Session_type{sess}).(Mouse_names{mouse})),10));
        Moving=thresholdIntervals(NewSpeed,1,'Direction','Above');
        Moving=mergeCloseIntervals(Moving,0.3*1e4);
        Moving=dropShortIntervals(Moving,0.3*1e4);
        Pos_Moving.(Session_type{sess}) = Restrict(Position_Active_Unblocked.(Session_type{sess}).(Mouse_names{mouse}) , Moving);
        D = Data(Pos_Moving.(Session_type{sess}));
        OccupMap_MovCond{n}(mouse,:,:) = hist2d([D(:,1) ;0; 0; 1; 1] , [D(:,2);0;1;0;1] , 100 , 100);
    end
    n=n+1;
end


figure
subplot(121)
imagesc(SmoothDec(squeeze(nanmean(OccupMap_MovCond{1})),2)')
axis xy, axis off, hold on, axis square, caxis([0 2]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


subplot(122)
imagesc(SmoothDec(squeeze(nanmean(OccupMap_MovCond{2})),2)')
axis xy, axis off, hold on, axis square, caxis([0 2]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

colormap gray



figure
subplot(121)
imagesc(SmoothDec(OccupMap_squeeze.Freeze_Unblocked.Cond{1},2))
axis xy, axis off, hold on, axis square, caxis([0 8e-4]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;


subplot(122)
imagesc(SmoothDec(OccupMap_squeeze.Freeze_Unblocked.Cond{2},2))
axis xy, axis off, hold on, axis square, caxis([0 8e-4]), c=caxis;
sizeMap=100; Maze_Frame_BM
u=colorbar; u.Ticks=[c(1) c(2)]; u.TickLabels={'0','1'}; u.FontSize=15; u.Label.String = 'occupancy (a.u.)'; u.Label.FontSize=12; set(u.Label,'Rotation',270)

a=area([40 62],[74 74]); 
a.FaceColor=[1 1 1];
a.LineWidth=1e-6;

colormap hot




% correlations
figure
subplot(221)
X = [77 10 8];
bar(X,'FaceColor',[0 0 0]), xticklabels({'λ1','λ2','λ3','λ4','λ5'})
box off
ylabel('% var explained')

subplot(222)
X = [64 34];
bar(X,'FaceColor',[0 0 0]), xticklabels({'λ1','λ2','λ3','λ4','λ5'})
box off
ylabel('% var explained')


subplot(223)
A = [ShockZoneEntries_Density.Cond{1}(ind) ; ShockZone_Occupancy.Cond{1}(ind) ; StimDensity.Cond{1}(ind) ; ...
    Thigmo_score.Cond{1}(ind) ; -MeanSpeed.Cond{1}(ind) ; log10(FreezingShock_Dur.Cond{1}(ind)) ; log10(Freezing_Dur.Cond{1}(ind)) ;...
    log10(FreezingSafe_Dur.Cond{1}(ind));  ...
    ];
ind = ~sum(isnan(A));
[D_sal,p1] = corr(zscore(A(:,ind)'),'type','pearson');
imagesc(D_sal), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:8]), yticks([1:8])
xticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
yticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
xtickangle(45)
axis square, axis xy


subplot(224)
A = [ShockZoneEntries_Density.Cond{2} ; ShockZone_Occupancy.Cond{2} ; StimDensity.Cond{2}; ...
    Thigmo_score.Cond{2}; -MeanSpeed.Cond{2} ; log10(FreezingShock_Dur.Cond{2}) ; log10(Freezing_Dur.Cond{2}) ;...
    log10(FreezingSafe_Dur.Cond{2});  ...
    ];
A(A==-Inf)=0;
ind = ~sum(isnan(A));
[D_dzp,p1] = corr(zscore(A(:,ind)'),'type','pearson');
imagesc(D_dzp), hold on
[rows3,cols3] = find(p1<.05);
plot(rows3,cols3,'*k')
caxis([-1 1])
colormap redblue
xticks([1:8]), yticks([1:8])
xticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
yticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
xtickangle(45)
axis square, axis xy


subplot(336)
imagesc(D_dzp-D_sal), axis square, colormap redblue, axis xy, caxis([-1.2 1.2])
xticks([1:8]), yticks([1:8])
xticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
yticklabels({'SZ entries','SZ occupancy','Shocks','Thigmotaxis','- Speed','Fz shock','Fz total','Fz safe'})
xtickangle(45)


subplot(337)
[~, ~, frvecs1, trnsfrmd1, ~, ~] = pca(D_sal); 
imagesc(frvecs1(:,1)*frvecs1(:,1)'), axis square, axis xy, colormap redblue

subplot(338)
[~, ~, frvecs1, trnsfrmd1, ~, ~] = pca(D_dzp); 
imagesc(frvecs1(:,1)*frvecs1(:,1)'), axis square, axis xy, colormap redblue




figure
% A = ShockZone_Occupancy.TestPost{1}; A (A>.15)=NaN;
PlotCorrelations_BM(MeanSpeed.Cond{2}([1:5 7:12]) , log10(FreezingShock_Dur.Cond{2}([1:5 7:12])), 'color' , [.85, .325, .098]), hold on
% PlotCorrelations_BM(MeanSpeed.Cond{1}(ind) , log10(FreezingShock_Dur.Cond{1}(ind)), 'color' , [.3, .745, .93])
axis square, xlabel('Mean speed, Cond (cm/s)'), ylabel('Fz shock duration, Cond (log scale)')


figure
A = ShockZone_Occupancy.TestPost{1}; A (A>.15)=NaN;
PlotCorrelations_BM(Freq_Max_Safe_SAL , A , 'color' , [.3, .745, .93])
PlotCorrelations_BM(Freq_Max_Safe_DZP , ShockZone_Occupancy.TestPost{2} , 'color' , [.85, .325, .098])
axis square, xlabel('Breathing safe Fz, Cond (Hz)'), ylabel('SZ occupancy, Test Post (prop)')
xlim([2.5 5.5]), ylim([-.05 .6])

figure
A = log10(FreezingSafe_Dur.Cond{1}); %A(A>.15)=NaN;
PlotCorrelations_BM(Freq_Max_Safe_SAL , A , 'color' , [.3, .745, .93])
PlotCorrelations_BM(Freq_Max_Safe_DZP , ShockZone_Occupancy.TestPost{2} , 'color' , [.85, .325, .098])



%% b) more safe fz
figure
a=barh([2 1],[-nanmean(FreezingShock_Dur.Cond{1}/60); -nanmean(FreezingShock_Dur.Cond{2}/60)],'stacked'); hold on
errorbar(-nanmean(FreezingShock_Dur.Cond{1}/60),2,nanstd(FreezingShock_Dur.Cond{1}/60)/sqrt(length(FreezingShock_Dur.Cond{1}/60)),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_Dur.Cond{2}/60),1,nanstd(FreezingShock_Dur.Cond{2}/60)/sqrt(length(FreezingShock_Dur.Cond{2}/60)),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_Dur.Cond{1}/60); nanmean(FreezingSafe_Dur.Cond{2}/60)],'stacked'); 
errorbar(nanmean(FreezingSafe_Dur.Cond{1}/60),2,0,nanstd(FreezingSafe_Dur.Cond{1}/60)/sqrt(length(FreezingSafe_Dur.Cond{1}/60)),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_Dur.Cond{2}/60),1,0,nanstd(FreezingSafe_Dur.Cond{2}/60)/sqrt(length(FreezingSafe_Dur.Cond{2}/60)),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing duration (min)')
yticklabels({'Diazepam','Saline'}), 
makepretty_BM2
xlim([-8 8])

[p(1),h,stats] = ranksum(FreezingShock_Dur.Cond{1}/60 , FreezingShock_Dur.Cond{2}/60);
[p(2),h,stats] = ranksum(FreezingSafe_Dur.Cond{1}/60 , FreezingSafe_Dur.Cond{2}/60);
p

lim=-4;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-4.5,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=7;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(7.5,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);




%% Pysio
edit GeneratePCA_Data_Diazepam_BM.m

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Physio.mat')

for group=Group
    figure, [~ , ~ , Freq_Max_Shock.(Drug_Group{group})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,5,:))); close
    figure, [~ , ~ , Freq_Max_Safe.(Drug_Group{group})] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.(Drug_Group{group}).(Session_type{sess}).ob_low.mean(:,6,:))); close
end

figure
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.Diazepam.CondPost.ob_low.mean(:,5,:)), 'color' , [.7 .3 .3], 'smoothing' , 3 , 'dashed_line' , 0);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData2.Diazepam.CondPost.ob_low.mean(:,6,:)), 'color' , [.3 .3 .7], 'smoothing' , 3 , 'dashed_line' , 0);
f=get(gca,'Children'); l=legend([f(5),f(1)],'Shock','Safe'); l.Box='off';
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10]); ylim([0 1])
makepretty
v1=vline(nanmean(Freq_Max_Shock_SAL)); set(v1,'LineStyle','--','Color',[1 .5 .5],'LineWidth',2); 
v2=vline(nanmean(Freq_Max_Safe_SAL)); set(v2,'LineStyle','--','Color',[.5 .5 1],'LineWidth',2)
xticks([0:2:10])
axis square


figure
subplot(121)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,5,:)), 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0, 'threshold' , 39);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,5,:)), 'color' , [.7 .3 .3], 'smoothing' , 3 , 'dashed_line' , 0, 'threshold' , 39);
f=get(gca,'Children'); l=legend([f(5),f(1)],'Saline','Diazepam'); l.Box='off';
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10]); ylim([0 1.5])
vline([1.5 5 8],'--k')
makepretty
xticks([0:2:10])
axis square

subplot(122)
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,6,:)), 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0, 'threshold' , 39);
Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,6,:)), 'color' , [.3 .3 .7], 'smoothing' , 3 , 'dashed_line' , 0, 'threshold' , 39);
f=get(gca,'Children'); l=legend([f(5),f(1)],'Saline','Diazepam'); l.Box='off';
xlabel('Frequency (Hz)'), ylabel('Power (a.u.)'), xlim([0 10]); ylim([0 1.5])
vline([1.5 5 8],'--k')
makepretty
xticks([0:2:10])
axis square


A = nanmean(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,5,65:104))')./nanmean(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,5,19:65))');
B = nanmean(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,5,65:104))')./nanmean(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,5,19:65))');
C = nanmean(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,6,65:104))')./nanmean(squeeze(OutPutData.Saline.CondPost.hpc_low.mean(:,6,19:65))');
D = nanmean(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,6,65:104))')./nanmean(squeeze(OutPutData.Diazepam.CondPost.hpc_low.mean(:,6,19:65))');


Cols = {[1 .5 .5],[.7 .3 .3],[.5 .5 1],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Shock','Safe','Safe'};
NoLegends = {'','','',''};

figure
MakeSpreadAndBoxPlot3_SB({A B C D},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)'), ylim([0 .35])







figure, n=2;
for i=1:8
    subplot(1,7,n)
    
    if n==1
         MakeSpreadAndBoxPlot3_SB({Freq_Max_Shock.(Drug_Group{Group(1)}) Freq_Max_Shock.(Drug_Group{Group(2)})...
        Freq_Max_Safe.(Drug_Group{Group(1)}) Freq_Max_Safe.(Drug_Group{Group(2)})},Cols,X,Legends,'showpoints',1,'paired',0);
    else
   MakeSpreadAndBoxPlot3_SB({OutPutData.Saline.CondPost.(Params{i}).mean(:,5) OutPutData.Diazepam.CondPost.(Params{i}).mean(:,5)...
    OutPutData.Saline.CondPost.(Params{i}).mean(:,6) OutPutData.Diazepam.CondPost.(Params{i}).mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
    end
    if n==1
        ylabel('Breathing (Hz)')
    elseif n==2
        ylabel('Heart rate (Hz)')
    elseif n==3
        ylabel('Heart rate variability (a.u.)')
    elseif n==4
        ylabel('OB Gamma frequency (Hz)')
    elseif n==5
        ylabel('OB Gamma power (a.u.)')
    elseif n==6
        ylabel('SWR occurence (#/s)')
    elseif n==8
        ylabel('HPC Theta/Delta')
    end
    makepretty_BM2
    
    n=n+1;
end


figure, Group=[13 15]; sess=1; l=linspace(0,15,100);
for param=1:4
    
    subplot(2,2,param)
    
    Data_to_use = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    col=Cols{Group(1)}; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    hold on;
    Data_to_use = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{sess}); Data_to_use(Data_to_use==0)=NaN;
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(linspace(0,15,100) , movmean(nanmean(Data_to_use),5,'omitnan') , movmean(Conf_Inter,5,'omitnan'),'b',1);
    h.mainLine.Color=Cols{Group(2)}; h.patch.FaceColor=Cols{Group(2)}; h.edge(1).Color=Cols{Group(2)}; h.edge(2).Color=Cols{Group(2)};
    
        for i=1:length(H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{1}))
            A = H.(Drug_Group{Group(1)}).(Param{param}).(Session_type{1})(:,i); A(A==0)=NaN;
            B = H.(Drug_Group{Group(2)}).(Param{param}).(Session_type{1})(:,i); B(B==0)=NaN;
        p{param}(i) = ttest2(A(~isnan(A)) , B(~isnan(B)));
    end
    p{param}(isnan(p{param}))=0;
    y=ylim;
    try, plot(l(logical(p{param})) , y(2) , '*k'), end
    
    makepretty
    if param==1; ylabel('Breathing (Hz)')
    elseif param==2;  ylabel('Heart rate (a.u.)')
    elseif param==3;  ylabel('Heart rate variability (a.u.)')
    elseif param==4;  ylabel('Motion (log scale)')
    end
    xlabel('Speed (cm/s)')
    if param==1; f=get(gca,'Children'); legend([f(5),f(1)],Drug_Group{Group(1)},Drug_Group{Group(2)}); end
end




%% PCA
figure
Make_PCA_Plot_BM(PC_values_shock_SAL{1} , PC_values_shock_SAL{2} , 'color' , [1 .5 .5]), hold on
Make_PCA_Plot_BM(PC_values_safe_SAL{1} , PC_values_safe_SAL{2} , 'color' , [.5 .5 1])
Make_PCA_Plot_BM(PC_values_shock_DZP{1} , PC_values_shock_DZP{2} , 'color' , [.7 .3 .3]), hold on
Make_PCA_Plot_BM(PC_values_safe_DZP{1} , PC_values_safe_DZP{2} , 'color' , [.3 .3 .7])
xlabel('PC1 value'), ylabel('PC2 value')
f=get(gca,'Children'); legend([f([42 29 15 1])],'Shock Saline','Safe Saline','Shock Diazepam','Safe Diazepam');
xlim([-4 3.5]), ylim([-2.5 2.5])
grid on




%% SVM scores
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SVM_DZP.mat')

figure
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('SVM score')
makepretty_BM2
line(xlim,[0 0],'color','k','LineStyle','--')

subplot(122)
A = {nanmean(1-SVMChoice_Sk_Ctrl),nanmean(1-SVMChoice_Sk),nanmean(SVMChoice_Sf_Ctrl),nanmean(SVMChoice_Sf)};
PlotErrorBarN_KJ(A,'barcolors',Cols,'newfig',0,'showpoints',0,'x_data',[1:4])
set(gca,'XTick',1:4,'XtickLabel',Legends)
xtickangle(45)
ylabel('accuracy')
line(xlim,[.5 .5],'color','k','LineStyle','--')
makepretty_BM2


Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
L = load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Physio_Cond.mat');
Session_type={'Cond'}; sess=1;
Group=[13 15];

FreqLim=4.5;
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock(n,mouse) = sum(D>FreqLim)/length(D);
        Prop_safe(n,mouse) = sum(D<FreqLim)/length(D);
        Length_shock(n,mouse) = sum(D>FreqLim)*.2;
        Length_safe(n,mouse) = sum(D<FreqLim)*.2;
        
        clear D_shock, D_shock = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock(n,mouse) = sum(D_shock>FreqLim)/length(D);
        Prop_safeShock(n,mouse) = sum(D_shock<FreqLim)/length(D);
        clear D_safe, D_safe = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe(n,mouse) = sum(D_safe>FreqLim)/length(D);
        Prop_safeSafe(n,mouse) = sum(D_safe<FreqLim)/length(D);
        
    end
    n=n+1;
end
Prop_shock(Prop_shock==0)=NaN;
Prop_safe(Prop_safe==0)=NaN;
Length_shock(Length_shock==0)=NaN;
Prop_shockShock(Prop_shockShock==0)=NaN;
Prop_safeShock(Prop_safeShock==0)=NaN;
Prop_shockSafe(Prop_shockSafe==0)=NaN;
Prop_safeSafe(Prop_safeSafe==0)=NaN;




figure
a=barh([2 1],[-nanmean(Prop_shock(1,:)); -nanmean(Prop_shock(2,:))],'stacked'); hold on
errorbar(-nanmean(Prop_shock(1,:)),2,nanstd(Prop_shock(1,:))/sqrt(length(Prop_shock(1,:))),0,'.','horizontal','Color','k');
errorbar(-nanmean(Prop_shock(2,:)),1,nanstd(Prop_shock(2,:))/sqrt(length(Prop_shock(2,:))),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(Prop_safe(1,:)); nanmean(Prop_safe(2,:))],'stacked'); 
errorbar(nanmean(Prop_safe(1,:)),2,0,nanstd(Prop_safe(1,:))/sqrt(length(Prop_safe(1,:))),'.','horizontal','Color','k');
errorbar(nanmean(Prop_safe(2,:)),1,0,nanstd(Prop_safe(2,:))/sqrt(length(Prop_safe(2,:))),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing mode (prop)')
yticklabels({'Diazepam','Saline'}), 
makepretty_BM2
xlim([-1 1])

[p(1),h,stats] = ranksum(Prop_shock(1,:) , Prop_shock(2,:));
[p(2),h,stats] = ranksum(Prop_safe(1,:) , Prop_safe(2,:));
p

lim=-.5;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.6,1.5,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.85;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.9,1.5,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);





a=barh([2 1],[-nanmean(Prop_shock(1,:)); -nanmean(Prop_shock(2,:))],'stacked'); hold on
b=barh([2 1],[-nanmean(Prop_shockSafe(1,:)); -nanmean(Prop_shockSafe(2,:))],'stacked'); hold on
errorbar(-nanmean(Prop_shock(1,:)),2,nanstd(Prop_shock(1,:))/sqrt(length(Prop_shock(1,:))),0,'.','horizontal','Color','k');
errorbar(-nanmean(Prop_shock(2,:)),1,nanstd(Prop_shock(2,:))/sqrt(length(Prop_shock(2,:))),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 
b.FaceColor=[.7 .3 .3]; 

a=barh([2 1],[nanmean(Prop_safe(1,:)); nanmean(Prop_safe(2,:))],'stacked'); 
b=barh([2 1],[nanmean(Prop_safeShock(1,:)); nanmean(Prop_safeShock(2,:))],'stacked'); 
errorbar(nanmean(Prop_safe(1,:)),2,0,nanstd(Prop_safe(1,:))/sqrt(length(Prop_safe(1,:))),'.','horizontal','Color','k');
errorbar(nanmean(Prop_safe(2,:)),1,0,nanstd(Prop_safe(2,:))/sqrt(length(Prop_safe(2,:))),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
b.FaceColor=[.3 .3 .7]; 
xlabel('freezing mode (prop)')
yticklabels({'Diazepam','Saline'}), 
makepretty_BM2
xlim([-1 1])

f=get(gca,'Children'); legend([f(8),f(7),f(4),f(3)],'High breathing, shock','Low breathing, shock','Low breathing, safe','High breathing, safe');





%% Sleep
edit GenerateSleep_Data_Diazepam_BM.m

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_DZP_Sleep.mat')
Prop.Wake{1}{1}(1:2)=NaN; Prop.Wake{2}{1}(1:2)=NaN;
EpNumb.Wake{1}{1}(1:2)=NaN; EpNumb.Wake{2}{1}(1:2)=NaN;
Prop.REM{1}{1}(1:2)=NaN; Prop.REM{2}{1}(1:2)=NaN;
EpNumb.REM{1}{1}(1:2)=NaN; EpNumb.REM{2}{1}(1:2)=NaN;

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Prop.Wake{1},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Wake prop')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(Prop.Wake{2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Wake prop')
makepretty_BM2


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(EpNumb.Wake{1},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Wake ep number (#)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(EpNumb.Wake{2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Wake ep number (#)')
makepretty_BM2




figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Prop.REM{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(Prop.REM{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')
makepretty_BM2


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(EpNumb.REM{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(EpNumb.REM{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')
makepretty_BM2


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(RipplesDensity{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('ripples occurence (#/s)')
makepretty_BM2

subplot(122)
MakeSpreadAndBoxPlot3_SB(RipplesDensity{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('ripples occurence (#/s)')
makepretty_BM2





figure
PlotCorrelations_BM(1-Prop_shock(1,1:11) , Prop.REM{2}{1} ,'color' , [.3, .745, .93])
PlotCorrelations_BM(1-Prop_shock(2,1:12) , Prop.REM{2}{2} , 'color' , [.85, .325, .098])
A = [1-Prop_shock(1,1:11) 1-Prop_shock(2,1:12)]; A(A<.3)=NaN;
B = [Prop.REM{2}{1} Prop.REM{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('Beathing<4.5Hz, Cond'), ylabel('REM proportion, Sleep Post')
ylim([.02 .13]), xlim([.5 1])


figure
PlotCorrelations_BM(L.OutPutData.Saline.Cond.ripples.mean(:,3) , Prop.REM{2}{1} ,'color' , [.3, .745, .93])
PlotCorrelations_BM(L.OutPutData.Diazepam.Cond.ripples.mean(:,3) , Prop.REM{2}{2} , 'color' , [.85, .325, .098])
A = [L.OutPutData.Saline.Cond.ripples.mean(:,3) L.OutPutData.Diazepam.Cond.ripples.mean(:,3)]; 
B = [Prop.REM{2}{1} Prop.REM{2}{2}];
PlotCorrelations_BM(A , B)
axis square
xlabel('Beathing<4.5Hz, Cond'), ylabel('REM proportion, Sleep Post')
ylim([.02 .13]), xlim([.5 1])




%% trash ?
Group=[13 15];
Session_type = {'Cond'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'respi_freq_bm');
    end
end

x = linspace(0,1,100);
param=1;

Params={'respi_freq_bm'};
for group=Group
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(OutPutData.(Drug_Group{group}).Cond.(Params{param}).tsd{mouse,5});
            DATA_shock.(Drug_Group{group}).(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        try
            clear D, D = Data(OutPutData.(Drug_Group{group}).Cond.(Params{param}).tsd{mouse,6});
            DATA_safe.(Drug_Group{group}).(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
    end
    DATA_shock.(Drug_Group{group}).(Params{param})(DATA_shock.(Drug_Group{group}).(Params{param})==0) = NaN;
    DATA_safe.(Drug_Group{group}).(Params{param})(DATA_safe.(Drug_Group{group}).(Params{param})==0) = NaN;
end


figure, n=1;
for group=Group
    subplot(1,2,n)
    
    Data_to_use = DATA_shock.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a1 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a1 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    end
    
    Data_to_use = DATA_safe.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),10) , runmean(Conf_Inter,10) ,'-k',1); hold on;
    col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    if or(or(param==1 , param==2) ,  or(param==8 , param==4))
        a2 = runmean(nanmean(Data_to_use),10)+runmean(Conf_Inter,10);
    elseif or(param==6 , param==3)
        a2 = runmean(nanmean(Data_to_use),10)-runmean(Conf_Inter,10);
    end
    
    if or(or(or(param==1 , param==2) ,  or(param==8 , param==4)) , or(param==6 , param==3))
        patch([x fliplr(x)], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)
    end
    makepretty
    xlabel('time (a.u.)')
    
    n=n+1;
end



figure, n=1;
for group=Group
    subplot(1,2,n)
    
    Data_to_use = DATA_shock.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),2) , runmean(Conf_Inter,2) ,'-k',1); hold on;
    col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;

    
    Data_to_use = DATA_safe.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , runmean(nanmean(Data_to_use),2) , runmean(Conf_Inter,2) ,'-k',1); hold on;
    col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    
    makepretty
    xlabel('time (a.u.)')
    
    n=n+1;
end







figure, n=1;
for group=Group
    subplot(1,2,n)
    
    Data_to_use = DATA_shock.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
    col = [1 .5 .5]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    a1 = nanmean(Data_to_use)-Conf_Inter;
    
    Data_to_use = DATA_safe.(Drug_Group{group}).(Params{param});
    Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
    h=shadedErrorBar(x , nanmean(Data_to_use) , Conf_Inter ,'-k',1); hold on;
    col = [.5 .5 1]; h.mainLine.Color=col; h.patch.FaceColor=col; h.edge(1).Color=col; h.edge(2).Color=col;
    a2 = nanmean(Data_to_use)+Conf_Inter;
    
    patch([x fliplr(x)], [a1 fliplr(a2)], 'k' , 'FaceAlpha' , .5)
    makepretty
    xlabel('time (a.u.)')
    
    n=n+1;
end










