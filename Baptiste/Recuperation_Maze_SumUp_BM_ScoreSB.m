close all,clear all



%% paper figures
% homeostasis
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat','Length_shock','Length_safe')
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/PC_values.mat', 'PCVal')

figure
A = log10(Length_shock{1})'; B = log10(Length_safe{1})';
PlotCorrelations_BM(A , B , 'conf_bound',1)
makepretty
xlabel('Duration fz breathing >4.5Hz (log scale)'), ylabel('Fz breathing <4.5Hz (log scale)')
axis square


X = log10(Length_shock{1})'; X(X==-Inf)=NaN;
Y = log10(Length_safe{1})';

tbl = table(X,Y);
mdl = fitlm(tbl,'Y ~ X');
t = table2array(mdl.Coefficients);
a = t(2,1); b = t(1,1);

X_proj = (X + a * (Y - b)) / (a^2 + 1); 
Y_proj = a * X_proj + b; % Compute distances 
d_perpendicular = (a * X - Y + b) ./ sqrt(a^2 + 1); % Perpendicular (Euclidean) distance 
d_y = (Y - (a * X + b)); % Vertical distance
d_x = X-X_proj; % horizontal dist 


figure
PlotCorrelations_BM(d_perpendicular , PCVal , 'conf_bound',1 , 'method' , 'spearman')
makepretty
xlabel('distance to fit'), ylabel('Breathing, safe side (Hz)')
axis square
xlim([-1.2 .8]), ylim([1.5 5])




%% Sleep
Eyelid = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/All_Eyelid_Sleep.mat','Prop');
Respi = load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat', 'DATA_SAL');
HR = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Eyelid.mat');
Thigmo = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Eyelid.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat', 'Respi_safe')

% 668 bad recording of sleep post
HR.HR_Wake_First5min{1}(7)=NaN;
Eyelid.Prop.REM_s_l_e_e_p{2}(7)=NaN;
Eyelid.Prop.Wake{2}(7)=NaN;


%% Plot the correlations of al lthe elements of the stress score with breathing on the safe side
figure(1)
subplot(521)
PlotCorrelations_BM(Respi_safe , Eyelid.Prop.Wake{2})
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('Wake prop, Sleep Post'), xlim([1.5 5.5]), ylim([0 .85])

subplot(523)
PlotCorrelations_BM(Respi_safe , Eyelid.Prop.REM_s_l_e_e_p{2})
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('REM prop, Sleep Post'), xlim([1.5 5.5]), ylim([0 .15])

subplot(525)
PlotCorrelations_BM(Respi_safe , HR.HR_Wake_First5min{1} , 'method' , 'pearson')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('HR homecage, Sleep Post'), xlim([1.5 5.5]), ylim([-3 2])

subplot(527)
PlotCorrelations_BM(Respi_safe , Thigmo.Thigmo_score{1} , 'method' , 'spearman')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('thigmo score, Sleep Post'), xlim([1.5 5.5]), ylim([0 .15])

AllDat = [Eyelid.Prop.Wake{2};Eyelid.Prop.REM_s_l_e_e_p{2};HR.HR_Wake_First5min{1};Thigmo.Thigmo_score{1}];
AllDat = AllDat(:,sum(isnan(AllDat))==0);
StdTouse = nanstd(AllDat')';
MnTouse = nanmean(AllDat')';
AllDat = (AllDat - repmat(MnTouse,1,size(AllDat,2)))./repmat(StdTouse,1,size(AllDat,2));
[EigVect,EigVals]=PerformPCA(AllDat);
AllDat_all = [Eyelid.Prop.Wake{2};Eyelid.Prop.REM_s_l_e_e_p{2};HR.HR_Wake_First5min{1};Thigmo.Thigmo_score{1}];
AllDat_all = nanzscore(AllDat_all')';
for mm = 1:size(AllDat_all,2)
    PCVal(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
end
subplot(5,2,9)
PlotCorrelations_BM(Respi_safe ,PCVal , 'method' , 'spearman')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('Stress score'), xlim([1.5 5.5]),

%% Plot the correlations of  the stress score with breathing on the safe side

figure(2)
subplot(1,2,1)
 PlotCorrelations_BM(Respi_safe ,PCVal , 'method' , 'spearman')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('Stress score'), xlim([1.5 5.5]), 

%% Plot the impact of rip inhib on al lthese markers

figure(1)
% Rip
Rip = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/RipInhib_Sleep.mat','Prop');
Cols = {[.65, .75, 0],[.63, .08, .18]};
X = [1:2];
Legends = {'RipControl','RipInhib'};

subplot(543)
MakeSpreadAndBoxPlot3_SB(Rip.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .85]), ylabel('Wake prop, Sleep Post')

subplot(547)
MakeSpreadAndBoxPlot3_SB(Rip.Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .2]), ylabel('REM prop, Sleep Post')

Rip2 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Rip.mat');

subplot(5,4,11)
MakeSpreadAndBoxPlot3_SB(Rip2.HR_Wake_First5min,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([-.6 1.8]), ylabel('HR norm, Wake, Sleep Post')

Rip3 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Rip.mat');

subplot(5,4,15)
MakeSpreadAndBoxPlot3_SB(Rip3.Thigmo_score,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .4]), ylabel('thigmo score, Sleep Post')

AllDat_all = [Rip.Prop.Wake{1};Rip.Prop.REM_s_l_e_e_p{1};Rip2.HR_Wake_First5min{1};Rip3.Thigmo_score{1}];
StdTouse = nanstd([AllDat_all]')';
MnTouse = nanmean([AllDat_all]')';
AllDat_all = (AllDat_all - repmat(MnTouse,1,size(AllDat_all,2)))./repmat(StdTouse,1,size(AllDat_all,2));
for mm = 1:size(AllDat_all,2)
    PCVal_Rip{1}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
end
AllDat_all = [Rip.Prop.Wake{2};Rip.Prop.REM_s_l_e_e_p{2};[NaN,NaN,Rip2.HR_Wake_First5min{2}];Rip3.Thigmo_score{2}]; % Check this!!
AllDat_all = (AllDat_all - repmat(MnTouse,1,size(AllDat_all,2)))./repmat(StdTouse,1,size(AllDat_all,2));
for mm = 1:size(AllDat_all,2)
    PCVal_Rip{2}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
end

subplot(5,4,19)
MakeSpreadAndBoxPlot3_SB(PCVal_Rip,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('stress score')
ylim([-1 3])

%% Plot the impact of rip inhib on stress score

figure(2)
subplot(1,4,3)
MakeSpreadAndBoxPlot3_SB(PCVal_Rip,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('stress score')
ylim([-1 3])

%% Plot the impact of DZP on al lthese markers
figure(1)
% DZP
DZP = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/DZP_Sleep.mat','Prop');
Cols = {[.3, .745, .93],[.85, .325, .098]};
X = [1:2];
Legends = {'Saline','DZP'};

subplot(544)
MakeSpreadAndBoxPlot3_SB(DZP.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .85])

subplot(548)
MakeSpreadAndBoxPlot3_SB(DZP.Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .2])

DZP2 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_DZP.mat');

subplot(5,4,12)
MakeSpreadAndBoxPlot3_SB(DZP2.HR_Wake_First5min,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([-.6 1.8])

DZP3 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_DZP.mat');

subplot(5,4,16)
MakeSpreadAndBoxPlot3_SB(DZP3.Thigmo_score,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .4])

AllDat_all = [DZP.Prop.Wake{1};DZP.Prop.REM_s_l_e_e_p{1};DZP2.HR_Wake_First5min{1};DZP3.Thigmo_score{1}];
StdTouse = nanstd([AllDat_all'])';
MnTouse = nanmean([AllDat_all'])';
AllDat_all = (AllDat_all - repmat(MnTouse,1,size(AllDat_all,2)))./repmat(StdTouse,1,size(AllDat_all,2));
for mm = 1:size(AllDat_all,2)
    PCVal_Dzp{1}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
end
AllDat_all = [DZP.Prop.Wake{2};DZP.Prop.REM_s_l_e_e_p{2};DZP2.HR_Wake_First5min{2};DZP3.Thigmo_score{2}];
AllDat_all = (AllDat_all - repmat(MnTouse,1,size(AllDat_all,2)))./repmat(StdTouse,1,size(AllDat_all,2));
for mm = 1:size(AllDat_all,2)
    PCVal_Dzp{2}(mm) = nanmean(EigVect(:,1)'.*AllDat_all(:,mm)');
end

subplot(5,4,20)
MakeSpreadAndBoxPlot3_SB(PCVal_Dzp,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('stress score')
ylim([-1 3])

%% Plot the impact of dzp on stress score
figure(2)
subplot(1,4,4)
MakeSpreadAndBoxPlot3_SB(PCVal_Dzp,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('stress score')
ylim([-1 3])





%% supp
clear all

Eyelid = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/All_Eyelid_Sleep.mat','Prop');
Respi = load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat', 'DATA_SAL');
HR = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Eyelid.mat');
Thigmo = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Eyelid.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat', 'Respi_safe', 'Respi_shock')
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/PC_values.mat', 'PCVal')
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_end_task.mat')

% 668 bad recording of sleep post
HR.HR_Wake_First5min{1}(7)=NaN;
Eyelid.Prop.REM_s_l_e_e_p{2}(7)=NaN;
Eyelid.Prop.Wake{2}(7)=NaN;




A = Eyelid.Prop.Wake{2}; B = Respi_safe;
[R1,P1]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = Eyelid.Prop.REM_s_l_e_e_p{2}; B = Respi_safe;
[R2,P2]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = Thigmo.Thigmo_score{1}; B = Respi_safe;
[R3,P3]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = HR.HR_Wake_First5min{1}; B = Respi_safe;
[R4,P4]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = HR_end_task; B = Respi_safe;
[R5,P5]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','pearson')



A = Eyelid.Prop.Wake{2}; B = Respi_shock;
[R6,P6]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = Eyelid.Prop.REM_s_l_e_e_p{2}; B = Respi_shock;
[R7,P7]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = Thigmo.Thigmo_score{1}; B = Respi_shock;
[R8,P8]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = HR.HR_Wake_First5min{1}; B = Respi_shock;
[R9,P9]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')
A = HR_end_task; B = Respi_shock;
[R10,P10]=PlotCorrelations_BM(A , B , 'conf_bound',1 , 'method','spearman')




figure
imagesc([R1 R2 R3 R4 R5 ; R6 R7 R8 R9 R10]') 
colormap redblue










