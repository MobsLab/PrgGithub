
%% Hab
cd('/media/nas7/Modelling_Behaviour/Free_Explo_Project/FromElisa')

load('model_results_Saline_hab_pre_post.mat')

Mouse_names = {'M688', 'M777', 'M849', 'M1144', 'M1146', 'M1147', 'M1170', 'M1171', 'M9184', 'M9205',...
    'M1391', 'M1392', 'M1394', 'M1224', 'M1225', 'M1226', 'M739', 'M779', 'M893', 'M1189', 'M1393'}; 

Var_Names = {'beta', 'thigmotaxis', 'direct_persist', 'immobility', 'p1', 'p2','p3', 'gamma', 'k', 'bp', 'Wm', 'Wnm'};
% Var_Names = {'beta', 'p1', 'p2','p3', 'gamma', 'k', 'bp', 'Wm', 'Wnm'};
% Var_Names = {'beta', 'p1','p2','p3','k', 'Wm', 'Wnm'};
ind_var = 1:12;
% ind_var = [1 5:7 9 11 12];

% [saline_pre,mu,sigma] = zscore(saline(13:24,:)');
[saline_pre,mu,sigma] = zscore(model_results_Sal_Pre2(ind_var,:)');

[M , v, v2] = Correlations_Matrices_Data_BM(saline_pre , Mouse_names , Var_Names);


% projection
mu1 = saline_pre(v2(1),:); 
mu2 = saline_pre(v2(end),:); 

W = mu2-mu1;
W_norm = W/norm(W);

mu1_proj = dot(mu1,W_norm);
mu2_proj = dot(mu2,W_norm);
B = (mu1_proj + mu2_proj)/2;

for mouse=1:length(Mouse_names)
    proj_mice_pre(mouse) = dot(saline_pre(mouse,:) , W_norm);
end
proj_mice_pre2=2*(proj_mice_pre-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1; % normalisation [-1 1]


%% II. Profiles identification
% 2 groups
Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1]};
Legends2={'all mice','1st group','2nd group'};
X2=1:3;

% ind_grp1 = [6 18 15 9 4 5 11 21];
% ind_grp2 = [16 2 3 7 8 12 14 1 19 10 13 20  17];
ind_grp1 = proj_mice_pre2<median(proj_mice_pre2);
ind_grp2 = proj_mice_pre2>median(proj_mice_pre2);
ind_grp1 = proj_mice_pre2<.1;
ind_grp2 = proj_mice_pre2>.1;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2(ind_grp1)...
    proj_mice_pre2(ind_grp2)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% Same as in Hab
model_results_hab_saline = saline(ind_var,:);
saline_hab = (model_results_hab_saline'-mu)./sigma;
for mouse=1:length(Mouse_names)
    proj_saline_hab(mouse) = dot(saline_hab(mouse,:) , W_norm);
end
proj_saline_hab2=2*(proj_saline_hab-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


figure
PlotCorrelations_BM(proj_saline_hab2,proj_mice_pre2,'method','pearson')
axis square
xlabel('model score, pre'), ylabel('model score, hab')
xlim([-1.2 1.2]), ylim([-1.2 1.2])
line([-1.2 1.2],[-1.2 1.2],'Color','r','LineStyle','--')
xticks([-1.2:.2:1.2]), yticks([-1.2:.2:1.2])
grid on
f=legend; f.String=f.String{1};


% Correlation with behaviours
for mouse=1:length(Mouse_names)
    Speed_All.TestPre(mouse) = nanmean(Data(Speed.TestPre.(Mouse_names{mouse})));
end


figure
subplot(131)
A=Tigmo_score_all.Active_Unblocked.TestPre{1};
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('thigmo score, pre')

subplot(132)
A=Speed_All.TestPre  ;
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('speed, pre')

subplot(133)
A=ImmobilityTime.TestPre;
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('immobility, pre')


%% III. confirming that it's related to stress/anxiety
% after aversive conditioning
Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5]};
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost'};
X2=1:4;

saline_post = (saline(ind_var+24,:)'-mu)./sigma;
for mouse=1:length(Mouse_names)
    proj_mice_post(mouse) = dot(saline_post(mouse,:) , W_norm);
end
proj_mice_post2=2*(proj_mice_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2(ind_grp1)...
    proj_mice_pre2(ind_grp2) proj_mice_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% after SD
load('model_results_SD_hab_pre.mat')
model_results_SD2 = model_results_SD(ind_var,:);
SD_hab = (model_results_SD2'-mu)./sigma;
for mouse=1:7
    proj_sd_hab(mouse) = dot(SD_hab(mouse,:) , W_norm);
end
proj_sd_hab2=2*(proj_sd_hab-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 .7 .5]};
X2=1:4;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','After SD'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2(ind_grp1)...
    proj_mice_pre2(ind_grp2) proj_sd_hab2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% after DZP
load('model_results_DZP_hab_pre.mat', 'model_results_DZP')
model_results__pre_DZP2 = model_results_DZP(12+ind_var,:);
DZP_hab = (model_results__pre_DZP2'-mu)./sigma;
for mouse=1:4
    proj_dzp_pre(mouse) = dot(DZP_hab(mouse,:) , W_norm);
end
proj_dzp_pre2=2*(proj_dzp_pre-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[0.95 0.52 0.3]};
X2=1:4;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','After DZP'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2(ind_grp1)...
    proj_mice_pre2(ind_grp2) proj_dzp_pre2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% with EPM values
model_results_EPM_hab = model_results_EPM(1:12,:);
EPM_hab = (model_results_EPM_hab'-mu)./sigma;
for mouse=1:7
    proj_epm_hab(mouse) = dot(EPM_hab(mouse,:) , W_norm);
end
proj_epm_hab2=2*(proj_epm_hab-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[0.95 0.52 0.3]};
X2=1:4;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','EPM mice, hab'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_epm_hab2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


Dir=PathForExperimentsEmbReact('EPM');
FolderList = Dir.path(end-6:end);

for mouse=1:7
    cd(FolderList{mouse}{1})
    
        clear Behav
    load('behavResources_SB.mat', 'Behav')
    Epoch = intervalSet(0,300e4);
    for i=1:3
        Behav.ZoneEpoch{1} = and(Behav.ZoneEpoch{1} , Epoch);
    end
    OpenArm_Prop(mouse) = sum(DurationEpoch(Behav.ZoneEpoch{1}))/(sum(DurationEpoch(Behav.ZoneEpoch{1})) + ...
        sum(DurationEpoch(Behav.ZoneEpoch{2})) + sum(DurationEpoch(Behav.ZoneEpoch{3})));
    OpenArm_Entries(mouse) = length(Start(Behav.ZoneEpoch{1}));
    
end


figure
subplot(121)
PlotCorrelations_BM(proj_epm_hab2,OpenArm_Prop,'method','pearson')
subplot(122)
PlotCorrelations_BM(proj_epm_hab2,OpenArm_Entries,'method','pearson')




%% Correlations
% with freezing and stims
figure
subplot(131)
A=ExtraStimNumber.Cond{1};
A(A>12)=NaN;
ind = A<12;
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('eyelid shocks, Cond'), ylim([0 10]), xlim([-1.2 1.2])

subplot(132)
A=Proportionnal_Time_Freezing_ofZone.Safe.Cond{1};
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('freezing safe prop, Cond'), ylim([0 .35]), xlim([-1.2 1.2])

subplot(133)
A=Respi_Shock.Cond{1};
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('Respi freq, Fz shock, Cond'), ylim([3 6]), xlim([-1.2 1.2])


% with shock zone entries
figure
subplot(131)
A=ShockEntriesZone.TestPre{1};
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('shock zone entries, TestPre'), ylim([0 30]), xlim([-1.2 1.2])

subplot(132)
A=ShockEntriesZone.Cond{1};
A(~ind)=NaN; A(A>30)=NaN;
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('shock zone entries, Cond'), ylim([0 30]), xlim([-1.2 1.2])

subplot(133)
A=ShockEntriesZone.TestPost{1};
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('shock zone entries, TestPost'), ylim([0 16]), xlim([-1.2 1.2])

% 
figure
subplot(121)
A=ShockEntriesZone.TestPre{1};
B=ShockEntriesZone.Cond{1};
B(B>30)=NaN;
PlotCorrelations_BM(A,B,'method','spearman')
axis square
xlabel('shock zone entries, TestPre'), ylabel('shock zone entries, Cond'), ylim([0 32]), xlim([0 30])

subplot(122)
A=ShockEntriesZone.Cond{1};
B=ShockEntriesZone.TestPost{1};
PlotCorrelations_BM(A,B,'method','spearman')
axis square
xlabel('shock zone entries, Cond'), ylabel('shock zone entries, TestPost'), ylim([0 15]), xlim([0 32])


%% Others
% DZP in TestPost
load('model_results_DZP_post.mat')
model_results_DZP_post2 = model_results_DZP_post(1:12,:);
DZP_post = (model_results_DZP_post2'-mu)./sigma;
for mouse=1:7
    proj_dzp_post(mouse) = dot(DZP_post(mouse,:) , W_norm);
end
proj_dzp_post2=2*(proj_dzp_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5],[0.95 0.32 0.2]};
X2=1:5;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost','DZP mice, TestPost'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_mice_post2 proj_dzp_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% FLX pre and post
load('model_results_FLX_pre_post.mat')
model_results_FLX2 = model_results_FLX(1:12,:);
FLX_pre = (model_results_FLX2'-mu)./sigma;
for mouse=1:7
    proj_flx_pre(mouse) = dot(FLX_pre(mouse,:) , W_norm);
end
proj_flx_pre2=2*(proj_flx_pre-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;

model_results_FLX3 = model_results_FLX(13:24,:);
FLX_post = (model_results_FLX3'-mu)./sigma;
for mouse=1:7
    proj_flx_post(mouse) = dot(FLX_post(mouse,:) , W_norm);
end
proj_flx_post2=2*(proj_flx_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5],[0.95 0.32 0.2],[0.7 0.7 0.5]};
X2=1:6;
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','all mice, TestPost','FLX mice, TestPre','FLX mice, TestPost'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_mice_post2 proj_flx_pre2 proj_flx_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% Experimenter
Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[1 0 0],[0 0 1],[0 1 0]};
Legends2={'all mice','1st group','2nd group','SB','CS','BM'};
X2=1:6;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21]) proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19])...
    proj_mice_pre2([1:3 17 18]) proj_mice_pre2([19 19]) proj_mice_pre2([4:16 20 21])},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')
hline(0,'--r')


% Correlation with RA
figure
A=RA_number.Saline;
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('RA, Cond'), ylim([0 30]), xlim([-1.2 1.2])


% Correlation with respi diff
Diff.Cond = Respi_Shock.Cond{1}-Respi_Safe.Cond{1};
Diff.Ext = Respi_Shock.Ext{1}-Respi_Safe.Ext{1};

figure
subplot(121)
A=Diff.Cond;
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('Respi diff, Cond'), ylim([-.5 3.5]), xlim([-1.2 1.2])
subplot(122)
A=Diff.Ext;
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('Respi diff, Ext'), ylim([-.5 3.5]), xlim([-1.2 1.2])


% Correlation with speed in Cond
for mouse=1:length(Mouse_names)
    Speed_All.Cond(mouse) = nanmean(Data(Speed.Cond.(Mouse_names{mouse})));
end
Speed_All.Cond(17)=NaN;


figure
A=Speed_All.Cond;
A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('mean speed, Cond'), ylim([1 5]), xlim([-1.2 1.2])


% Correlation with thigmotaxis score
figure
A=saline(44,:);
% A(~ind)=NaN; 
PlotCorrelations_BM(proj_mice_pre2,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('thigmo, TestPre'), %ylim([1 5]), xlim([-1.2 1.2])



% Intravariability
model_results_hab_688 = model_results_sameHabM688;
M688_hab = (model_results_hab_688'-mu)./sigma;
for it=1:13
    proj_M688_hab(it) = dot(M688_hab(it,:) , W_norm);
end
proj_M688_hab2=2*(proj_M688_hab-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1],[.5 1 .5]};
Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','M688 Hab'};
X2=1:4;

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_M688_hab2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')




model_results_hab_739 = model_results_samePostM739;
M739_post = (model_results_hab_739'-mu)./sigma;
for it=1:20
    proj_M739_post(it) = dot(M739_post(it,:) , W_norm);
end
proj_M739_post2=2*(proj_M739_post-min(proj_mice_pre))/(max(proj_mice_pre)-min(proj_mice_pre))-1;


Legends2={'all mice, TestPre','1st group, TestPre','2nd group, TestPre','M739 Post'};

figure
MakeSpreadAndBoxPlot3_SB({proj_mice_pre2 proj_mice_pre2([6 18 15 9 4 5 11 21])...
    proj_mice_pre2([17 10 20 16 2 13 3 7 8 12 14 1 19]) proj_M739_post2},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')


% Params model for 2 groups
for param=1:12
    Param{param}{1} = saline_pre(ind_grp1,param);
    Param{param}{2} = saline_pre(ind_grp2,param);
end

Cols2={[1 .5 .5],[.5 .5 1]};
Legends2={'1st group, TestPre','2nd group, TestPre'};
NoLegends={'',''};
X2=1:2;

figure
for param=1:12
    subplot(2,6,param)
    if param<7
        MakeSpreadAndBoxPlot3_SB(Param{param},Cols2,X2,NoLegends,'showpoints',1,'paired',0);
    else
        MakeSpreadAndBoxPlot3_SB(Param{param},Cols2,X2,Legends2,'showpoints',1,'paired',0);
    end
    title(Var_Names(param))
end

figure
for param=1:12
    subplot(2,6,param)
    PlotCorrelations_BM(proj_mice_pre2 , saline_pre(:,param)')
    axis square
    if param>6; xlabel('model score (a.u.)'); end
    if or(param==1 , param==7); ylabel('model score (a.u.)'); end
    title(Var_Names(param))
end

figure
for param=1:12
    subplot(2,6,param)
    [R0,P0]=PlotCorrelations_BM(proj_mice_pre2 , saline_pre(:,param)')
    [R1,P1]=PlotCorrelations_BM(proj_mice_pre2(ind_grp1) , saline_pre(ind_grp1,param)','Color','r')
    [R2,P2]=PlotCorrelations_BM(proj_mice_pre2(ind_grp2) , saline_pre(ind_grp2,param)','Color','b')
    f=get(gca,'Children'); legend([f(3),f(2),f(1)],['R = ' num2str(R0) '     P = ' num2str(P0)] ,...
        ['R = ' num2str(R1) '     P = ' num2str(P1)],['R = ' num2str(R2) '     P = ' num2str(P2)]);
    axis square
    if param>6; xlabel('model score (a.u.)'); end
    if or(param==1 , param==7); ylabel('model score (a.u.)'); end
    title(Var_Names(param))
end





