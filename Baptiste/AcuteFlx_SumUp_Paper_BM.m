
%%
edit SumUp_Diazepam_RipInhib_Maze_BM.m
% for behav

edit SumUp_Diazepam_RipInhib_Maze_BM.m
% for physio

edit SumUp_Diazepam_RipInhib_Maze_BM.m
% for sleep

load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/DATA_AcuteFlx_All.mat')


MeanSpeed.Cond{1}(2)=NaN;

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù
%                            FIGURES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ù

Cols2 = {[.3, .745, .93],[.85 .35 .45]};
X2 = 1:2;
Legends2 = {'Saline','Acute Flx'};



figure
subplot(171)
MakeSpreadAndBoxPlot3_SB({StimNumber.Cond{1}-16 StimNumber.Cond{2}-16},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('shocks (#)')


% TestPost occupancy
subplot(172)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPost{1} ShockZone_Occupancy.TestPost{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)'), ylim([0 .35])

subplot(173)
MakeSpreadAndBoxPlot3_SB({ShockZone_Occupancy.TestPre{1} ShockZone_Occupancy.TestPre{2}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('SZ occupancy (prop)'), ylim([0 .6])


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




figure
subplot(121)
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


subplot(122)
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





figure
a=barh([2 1],[-nanmean(FreezingShock_prop.Cond{1}); -nanmean(FreezingShock_prop.Cond{2})],'stacked'); hold on
errorbar(-nanmean(FreezingShock_prop.Cond{1}),2,nanstd(FreezingShock_prop.Cond{1})/sqrt(length(FreezingShock_prop.Cond{1})),0,'.','horizontal','Color','k');
errorbar(-nanmean(FreezingShock_prop.Cond{2}),1,nanstd(FreezingShock_prop.Cond{2})/sqrt(length(FreezingShock_prop.Cond{2})),0,'.','horizontal','Color','k');
a.FaceColor=[1 .5 .5]; 

a=barh([2 1],[nanmean(FreezingSafe_prop.Cond{1}); nanmean(FreezingSafe_prop.Cond{2})],'stacked'); 
errorbar(nanmean(FreezingSafe_prop.Cond{1}),2,0,nanstd(FreezingSafe_prop.Cond{1})/sqrt(length(FreezingSafe_prop.Cond{1})),'.','horizontal','Color','k');
errorbar(nanmean(FreezingSafe_prop.Cond{2}),1,0,nanstd(FreezingSafe_prop.Cond{2})/sqrt(length(FreezingSafe_prop.Cond{2})),'.','horizontal','Color','k');
a.FaceColor=[.5 .5 1]; 
xlabel('freezing proportion')
yticklabels({'Acute Flx','Saline'}), 
makepretty_BM2
xlim([-.2 .2])

[p(1),h,stats] = ranksum(FreezingShock_prop.Cond{1} , FreezingShock_prop.Cond{2});
[p(2),h,stats] = ranksum(FreezingSafe_prop.Cond{1} , FreezingSafe_prop.Cond{2});
p

lim=-.17;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.19,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.17;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(.19,1.5,'ns','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



%% Physio
Cols = {[1 .5 .5],[.5 .5 1],[.7 .3 .3],[.3 .3 .7]};
X = 1:4;
Legends = {'Shock','Safe','Shock','Safe'};

figure
MakeSpreadAndBoxPlot3_SB({Freq_Max_Shock.(Drug_Group{Group(1)}) Freq_Max_Safe.(Drug_Group{Group(1)})...
    Freq_Max_Shock.(Drug_Group{Group(2)}) Freq_Max_Safe.(Drug_Group{Group(2)})},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Breathing (Hz)')


figure
Make_PCA_Plot_BM(PC_values_shock.(Drug_Group{Group(1)}){1} , PC_values_shock.(Drug_Group{Group(1)}){2} , 'color' , [1 .5 .5]), hold on
Make_PCA_Plot_BM(PC_values_safe.(Drug_Group{Group(1)}){1} , PC_values_safe.(Drug_Group{Group(1)}){2} , 'color' , [.5 .5 1])
Make_PCA_Plot_BM(PC_values_shock.(Drug_Group{Group(2)}){1} , PC_values_shock.(Drug_Group{Group(2)}){2} , 'color' , [.7 .3 .3]), hold on
Make_PCA_Plot_BM(PC_values_safe.(Drug_Group{Group(2)}){1} , PC_values_safe.(Drug_Group{Group(2)}){2} , 'color' , [.3 .3 .7])
xlabel('PC1 values'), ylabel('PC2 values')


figure
MakeSpreadAndBoxPlot3_SB({PC_values_shock.(Drug_Group{Group(1)}){1} PC_values_safe.(Drug_Group{Group(1)}){1}...
    PC_values_shock.(Drug_Group{Group(2)}){1} PC_values_safe.(Drug_Group{Group(2)}){1}},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Breathing (Hz)')



figure
subplot(121)
A = {nanmean(SVMScores_Sk_Ctrl),nanmean(SVMScores_Sk),nanmean(SVMScores_Sf_Ctrl),nanmean(SVMScores_Sf)};
MakeSpreadAndBoxPlot3_SB(A,Cols,[1,1.7,3,3.7],Xlab,'showpoints',1,'paired',0)
ylabel('SVM score')




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
yticklabels({'Chronic Flx','Saline'}), 
makepretty_BM2
xlim([-1 1])

[p(1),h,stats] = ranksum(Prop_shock(1,:) , Prop_shock(2,:));
[p(2),h,stats] = ranksum(Prop_safe(1,:) , Prop_safe(2,:));
p

lim=-.3;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(-.35,1.5,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);
lim=.95;
plot([lim lim],[1 2],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1,1.5,'**','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);





figure, n=1;
for i=1:8
    subplot(1,8,n)
    
    if n==1
        MakeSpreadAndBoxPlot3_SB({Freq_Max_Shock.(Drug_Group{Group(1)}) Freq_Max_Safe.(Drug_Group{Group(1)})...
            Freq_Max_Shock.(Drug_Group{Group(2)}) Freq_Max_Safe.(Drug_Group{Group(2)})},Cols,X,Legends,'showpoints',1,'paired',0);
    else
        MakeSpreadAndBoxPlot3_SB({OutPutData.(Drug_Group{Group(1)}).Cond.(Params{i}).mean(:,5) OutPutData.(Drug_Group{Group(1)}).Cond.(Params{i}).mean(:,6)...
            OutPutData.(Drug_Group{Group(2)}).Cond.(Params{i}).mean(:,5) OutPutData.(Drug_Group{Group(2)}).Cond.(Params{i}).mean(:,6)},Cols,X,Legends,'showpoints',1,'paired',0);
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
    elseif n==7
        ylabel('HPC Theta frequency (Hz)')
    elseif n==8
        ylabel('HPC Theta/Delta')
    end
    
    n=n+1;
end






%% sleep
Cols = {[.3, .745, .93],[.85 .35 .45]};
X = 1:2;
Legends = {'Saline','Acute Flx'};



figure
subplot(221)
MakeSpreadAndBoxPlot3_SB(Prop.Wake{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake prop')
subplot(222)
MakeSpreadAndBoxPlot3_SB(Prop.Wake{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake prop')
subplot(223)
MakeSpreadAndBoxPlot3_SB(Prop.REM{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')
subplot(224)
MakeSpreadAndBoxPlot3_SB(Prop.REM{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')





