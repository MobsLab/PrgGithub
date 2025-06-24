clear all

%% Sleep
Eyelid = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/All_Eyelid_Sleep.mat','Prop');
Respi = load('/media/nas7/ProjetEmbReact/DataEmbReact/ThesisData/Physio_BehavGroup.mat', 'DATA_SAL');
HR = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Eyelid.mat');
Thigmo = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Eyelid.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat')
% 668 bad recording of sleep post
HR.HR_Wake_First5min{1}(7)=NaN;
Eyelid.Prop.REM_s_l_e_e_p{2}(7)=NaN;
Eyelid.Prop.Wake{2}(7)=NaN;


figure
PlotCorrelations_BM(Respi_safe , PCVal)


%
figure
subplot(421)
PlotCorrelations_BM(Respi_safe , Eyelid.Prop.Wake{2})
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('Wake prop, Sleep Post'), xlim([1.5 5.5]), ylim([0 .85])

subplot(423)
PlotCorrelations_BM(Respi_safe , Eyelid.Prop.REM_s_l_e_e_p{2})
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('REM prop, Sleep Post'), xlim([1.5 5.5]), ylim([0 .15])

subplot(425)
PlotCorrelations_BM(Respi_safe , HR.HR_Wake_First5min{1} , 'method' , 'pearson')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('HR homecage, Sleep Post'), xlim([1.5 5.5]), ylim([-3 2])

subplot(427)
PlotCorrelations_BM(Respi_safe , Thigmo.Thigmo_score{1} , 'method' , 'spearman')
axis square
xlabel('Breathing, safe side (Hz)'), ylabel('thigmo score, Sleep Post'), xlim([1.5 5.5]), ylim([0 .15])


% Rip
Rip = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/RipInhib_Sleep.mat','Prop');
Cols = {[.65, .75, 0],[.63, .08, .18]};
X = [1:2];
Legends = {'RipControl','RipInhib'};

subplot(443)
MakeSpreadAndBoxPlot3_SB(Rip.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .85]), ylabel('Wake prop, Sleep Post')

subplot(447)
MakeSpreadAndBoxPlot3_SB(Rip.Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .2]), ylabel('REM prop, Sleep Post')

Rip2 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_Rip.mat');

subplot(4,4,11)
MakeSpreadAndBoxPlot3_SB(Rip2.HR_Wake_First5min,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([-.6 1.8]), ylabel('HR norm, Wake, Sleep Post')

Rip3 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_Rip.mat');

subplot(4,4,15)
MakeSpreadAndBoxPlot3_SB(Rip3.Thigmo_score,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .4]), ylabel('thigmo score, Sleep Post')


% DZP
DZP = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/DZP_Sleep.mat','Prop');
Cols = {[.3, .745, .93],[.85, .325, .098]};
X = [1:2];
Legends = {'Saline','DZP'};

subplot(444)
MakeSpreadAndBoxPlot3_SB(DZP.Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .85])

subplot(448)
MakeSpreadAndBoxPlot3_SB(DZP.Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 .2])

DZP2 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/HR_Homecage_DZP.mat');

subplot(4,4,12)
MakeSpreadAndBoxPlot3_SB(DZP2.HR_Wake_First5min,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([-.6 1.8])

DZP3 = load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Thigmo_DZP.mat');

subplot(4,4,16)
MakeSpreadAndBoxPlot3_SB(DZP3.Thigmo_score,Cols,X,Legends,'showpoints',1,'paired',0)
ylim([0 .4])



%% Correlations, homeostasis
figure
subplot(141)
A = log10(Length_shock_side)'; A(A==-Inf)=NaN;
B = log10(Length_safe_side)'; B(B==-Inf)=NaN;
PlotCorrelations_BM(A , B , 'conf_bound',1)
makepretty
xlabel('Fz shock duration (log scale)'), ylabel('Fz safe duration (log scale)')
axis square

subplot(142)
A = log10(Length_safe_side)'; B = Respi_safe;
PlotCorrelations_BM(A , B , 'conf_bound',1)
makepretty
xlabel('Fz safe duration (log scale)'), ylabel('Breathing, fz safe side (Hz)')
axis square

subplot(143)
A = log10(Length_shock)'; B = log10(Length_safe)';
PlotCorrelations_BM(A , B , 'conf_bound',1)
makepretty
xlabel('Duration fz breathing >4.5Hz (log scale)'), ylabel('Fz breathing <4.5Hz (log scale)')
axis square

subplot(144)
A = Respi_shock; B = Respi_safe;
PlotCorrelations_BM(A , B , 'conf_bound',1)
makepretty
xlabel('Breathing, fz shock side (Hz)'), ylabel('Breathing, fz safe side (Hz)')
axis square



figure
PlotCorrelations_BM(log10(Length_fz{1}*60) , PCVal)
xlabel('Duration immobility (log)'), ylabel('stress score')
axis square, makepretty


%% not with SWR occurence safe side
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat', 'OutPutData')

figure
subplot(141)
PlotCorrelations_BM(OutPutData.Cond.ripples_density.mean(:,6) , Eyelid.Prop.Wake{2})
axis square
xlabel('SWR occurence, fz safe side (#/s)'), ylabel('Wake prop, Sleep Post'), xlim([0 1.2]), ylim([0 .85])

subplot(142)
PlotCorrelations_BM(OutPutData.Cond.ripples_density.mean(:,6) , Eyelid.Prop.REM_s_l_e_e_p{2})
axis square
xlabel('SWR occurence, fz safe side (#/s)'), ylabel('REM prop, Sleep Post'), xlim([0 1.2]), ylim([0 .15])

subplot(143)
PlotCorrelations_BM(OutPutData.Cond.ripples_density.mean(:,6) , HR.HR_Wake_First5min{1} , 'method' , 'pearson')
axis square
xlabel('SWR occurence, fz safe side (#/s)'), ylabel('HR homecage, Sleep Post'), xlim([0 1.2]), ylim([-3 2])

subplot(144)
PlotCorrelations_BM(OutPutData.Cond.ripples_density.mean(:,6) , Thigmo.Thigmo_score{1} , 'method' , 'spearman')
axis square
xlabel('SWR occurence, fz safe side (#/s)'), ylabel('thigmo score, Sleep Post'), xlim([0 1.2]), ylim([0 .15])

figure
PlotCorrelations_BM(OutPutData.Cond.ripples_density.mean(:,6) , PCVal)
axis square
xlabel('SWR occurence, fz safe side (#/s)'), ylabel('stress score'), xlim([0 1.2]), ylim([-.6 .8])

%% Homeostasis with low vs high breathig states
figure
subplot(131)
X = log10(Length_shock{1})'; X(X==-Inf)=NaN;
Y = log10(Length_safe{1})';
[R,P] = PlotCorrelations_BM(X , Y);
legend(['R = ' num2str(R) '     P = ' num2str(P)])
makepretty
xlabel('Duration Fz >4.5Hz (log scale)'), ylabel('Duration Fz <4.5Hz (log scale)')
axis square

tbl = table(X,Y);
mdl = fitlm(tbl,'Y ~ X');
t = table2array(mdl.Coefficients);
a = t(2,1); b = t(1,1);

X_proj = (X + a * (Y - b)) / (a^2 + 1); 
Y_proj = a * X_proj + b; % Compute distances 
d_perpendicular = (a * X - Y + b) ./ sqrt(a^2 + 1); % Perpendicular (Euclidean) distance 
d_y = (Y - (a * X + b)); % Vertical distance
d_x = X-X_proj; % horizontal dist 


subplot(132)
PlotCorrelations_BM(d_perpendicular , Respi_safe , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Breathing, safe side (Hz)')
axis square
xlim([-1.2 .8]), ylim([1.5 5])

load('PC_values.mat', 'PCVal')
subplot(133)
PlotCorrelations_BM(d_perpendicular , PCVal , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Stress score')
axis square
xlim([-1.2 .8]), ylim([-.7 1])



%% Homeostasis with safe vs shock side
figure
subplot(131)
A = log10(Length_shock_side)'; A(A==-Inf)=NaN;
B = log10(Length_safe_side)';
[R,P] = PlotCorrelations_BM(A , B , 'conf_bound',1);
makepretty
xlabel('Duration shock arm freezing (log scale)'), ylabel('Duration safe arm freezing (log scale)')
axis square

tbl = table(A,B);
mdl = fitlm(tbl,'B ~ A');
for mouse=1:29
    residual(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
    if residual(mouse)>0
        line([A(mouse) A(mouse)],[B(mouse) B(mouse)-residual(mouse)],'LineStyle','--','Color','g')
    else
        line([A(mouse) A(mouse)],[B(mouse) B(mouse)-residual(mouse)],'LineStyle','--','Color','r')
    end
end
f=get(gca,'Children'); legend([f(32)],['R = ' num2str(R) '     P = ' num2str(P)]);


subplot(132)
PlotCorrelations_BM(residual , Respi_safe , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Breathing, safe side (Hz)')
axis square
xlim([-1.2 .8]), ylim([1.5 5])

load('PC_values.mat', 'PCVal')
subplot(133)
PlotCorrelations_BM(residual , PCVal , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Stress score')
axis square
xlim([-1.2 .8]), ylim([-.7 1])


figure
subplot(141)
PlotCorrelations_BM(residual , Eyelid.Prop.Wake{2})
axis square
xlabel('SWR occurence, safe side (#/s)'), ylabel('Wake prop, Sleep Post'), %xlim([1.5 5.5]), ylim([0 .85])

subplot(142)
PlotCorrelations_BM(residual , Eyelid.Prop.REM_s_l_e_e_p{2})
axis square
xlabel('SWR occurence, safe side (#/s)'), ylabel('Wake prop, Sleep Post'), %xlim([1.5 5.5]), ylim([0 .85])

subplot(143)
PlotCorrelations_BM(residual , HR.HR_Wake_First5min{1} , 'method' , 'pearson')
axis square
xlabel('SWR occurence, safe side (#/s)'), ylabel('HR homecage, Sleep Post'), %xlim([1.5 5.5]), ylim([-3 2])

subplot(144)
PlotCorrelations_BM(residual , Thigmo.Thigmo_score{1} , 'method' , 'spearman')
axis square
xlabel('SWR occurence, safe side (#/s)'), ylabel('thigmo score, Sleep Post'), %xlim([1.5 5.5]), ylim([0 .15])



%%
figure
subplot(121)
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat')
A = log10(Length_shock)'; A(A==-Inf)=NaN;
B = log10(Length_safe)';
[R,P] = PlotCorrelations_BM(A , B , 'conf_bound',1);
makepretty
xlabel('Duration Fz >4.5Hz (log scale)'), ylabel('Duration Fz <4.5Hz (log scale)')
axis square

clear residual
for mouse=1:29
    residual(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
end

subplot(122)
PlotCorrelations_BM(residual , Respi_safe , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Breathing, safe side (Hz)')
axis square
xlim([-1.2 .8]), ylim([1.5 5])



load('/media/nas7/ProjetEmbReact/DataEmbReact/Temp.mat')

subplot(121)
A = log10(Length_shock(2,:))'; A(A==-Inf)=NaN;
B = log10(Length_safe(2,:))';
PlotCorrelations_BM(A , B , 'color',[.85, .325, .098]);

clear residual_DZP
try
    for mouse=1:29
        residual_DZP(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
    end
end

subplot(122)
PlotCorrelations_BM(residual , Respi_safe(2,:) , 'conf_bound',0,'color',[.85, .325, .098])


load('/media/nas7/ProjetEmbReact/DataEmbReact/Temp2.mat')

A = log10(Length_shock(2,:))'; A(A==-Inf)=NaN;
B = log10(Length_safe(2,:))';
subplot(121)
PlotCorrelations_BM(A , B , 'color',[.63, .08, .18] , 'conf_bound',0);
f=get(gca,'Children'); legend([f(2),f(1)],'Diazepam','RipInhib');

clear residual_Rip
try
    for mouse=1:29
        residual_Rip(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
    end
end

subplot(122)
PlotCorrelations_BM(residual , OB_Max_Freq.RipInhib.Cond.Safe , 'conf_bound',0,'color',[.63, .08, .18])





Cols = {[.85, .325, .098],[.63, .08, .18]};
X = [1:2];
Legends = {'DZP','RipInhib'};

figure
MakeSpreadAndBoxPlot3_SB({residual_DZP residual_Rip},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-1.2 1.2]), ylabel('dist to fit')
makepretty_BM2



figure
subplot(141)
PlotCorrelations_BM(residual , Eyelid.Prop.Wake{2})
PlotCorrelations_BM(residual_DZP , DZP.Prop.Wake{2} , 'color' , [.85, .325, .098],'conf_bound',0)
PlotCorrelations_BM(residual_Rip , Rip.Prop.Wake{2} , 'color' , [.63, .08, .18],'conf_bound',0)
axis square
xlabel('dist to fit'), ylabel('Wake prop, Sleep Post')

subplot(142)
PlotCorrelations_BM(residual , Eyelid.Prop.REM_s_l_e_e_p{2})
PlotCorrelations_BM(residual_DZP , DZP.Prop.REM_s_l_e_e_p{2} , 'color' , [.85, .325, .098],'conf_bound',0)
PlotCorrelations_BM(residual_Rip , Rip.Prop.REM_s_l_e_e_p{2} , 'color' , [.63, .08, .18],'conf_bound',0)
axis square
xlabel('dist to fit'), ylabel('REM prop, Sleep Post')

subplot(143)
PlotCorrelations_BM(residual , HR.HR_Wake_First5min{1})
PlotCorrelations_BM(residual_Rip , Rip2.HR_Wake_First5min{2} , 'color' , [.63, .08, .18],'conf_bound',0)
PlotCorrelations_BM(residual_DZP , DZP2.HR_Wake_First5min{2}  , 'color' , [.85, .325, .098],'conf_bound',0)
axis square
xlabel('dist to fit'), ylabel('HR homecage, Sleep Post')

subplot(144)
PlotCorrelations_BM(residual , Thigmo.Thigmo_score{1} , 'method' , 'spearman')
PlotCorrelations_BM(residual_DZP , DZP3.Thigmo_score{2} , 'method' , 'spearman' , 'color' , [.63, .08, .18],'conf_bound',0)
PlotCorrelations_BM(residual_Rip , Rip3.Thigmo_score{2} , 'method' , 'spearman'  , 'color' , [.85, .325, .098],'conf_bound',0)
axis square
xlabel('dist to fit'), ylabel('thigmo score, Sleep Post')



subplot(245)
PlotCorrelations_BM(residual_DZP , DZP.Prop.Wake{2})
axis square
xlabel('dist to fit'), ylabel('Wake prop, Sleep Post')

subplot(246)
PlotCorrelations_BM(residual_DZP , DZP.Prop.REM_s_l_e_e_p{2})
axis square
xlabel('dist to fit'), ylabel('REM prop, Sleep Post')

subplot(247)
PlotCorrelations_BM(residual_DZP , DZP2.HR_Wake_First5min{2} , 'method' , 'pearson')
axis square
xlabel('dist to fit'), ylabel('HR homecage, Sleep Post')

subplot(248)
axis square
xlabel('dist to fit'), ylabel('thigmo score, Sleep Post')



%%
figure
subplot(121)
load('/media/nas7/ProjetEmbReact/DataEmbReact/SleepData/Fear_related_measures.mat')
A = log10(Length_shock)'; A(A==-Inf)=NaN;
B = log10(Length_safe)';
[R,P] = PlotCorrelations_BM(A , B , 'conf_bound',1);
makepretty
xlabel('Duration Fz >4.5Hz (log scale)'), ylabel('Duration Fz <4.5Hz (log scale)')
axis square

clear residual
for mouse=1:29
    residual(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
    if residual(mouse)>0
%         line([A(mouse) A(mouse)],[B(mouse) B(mouse)-residual(mouse)],'LineStyle','--','Color','g')
    else
%         line([A(mouse) A(mouse)],[B(mouse) B(mouse)-residual(mouse)],'LineStyle','--','Color','r')
    end
end

subplot(122)
PlotCorrelations_BM(residual , Respi_safe , 'conf_bound',1)
makepretty
xlabel('distance to fit'), ylabel('Breathing, safe side (Hz)')
axis square
xlim([-1.2 .8]), ylim([1.5 5])




load('/media/nas7/ProjetEmbReact/DataEmbReact/Temp3.mat')

subplot(121)
A = log10(Length_shock(1,:))'; A(A==-Inf)=NaN;
B = log10(Length_safe(1,:))';
PlotCorrelations_BM(A , B , 'color',[0 0 1] , 'conf_bound',0);
f=get(gca,'Children'); legend([f(1)],'PAG');

clear residual_PAG
try
    for mouse=1:29
        residual_PAG(mouse) = B(mouse)-(A(mouse)*.6839+.9349);
    end
end

subplot(122)
PlotCorrelations_BM(residual_PAG , Respi_safe(1,:) , 'conf_bound',0,'color',[0 0 1])



figure
MakeSpreadAndBoxPlot4_SB({residual_PAG},{[.3 .3 .3]},[1],{'PAG'},'showpoints',1,'paired',0);
hline(0,'--r')
ylim([-.8 .8]), ylabel('dist to fit')
makepretty_BM2

[h,p]=ttest(residual_PAG , zeros(1,20))
lim=.75;
plot([.5 1.5],[lim lim],'-k','LineWidth',1.5,'Tag','sigstar_bar');
text(1,lim*1.05,'*','HorizontalAlignment','Center','BackGroundColor','none','FontSize',15);



%%
L = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat');
L2 = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat');
L.OutPutData.RipSham.Cond.respi_freq_bm.tsd  = L2.OutPutData.Cond.respi_freq_bm.tsd;
L.OutPutData.RipInhib.Cond.respi_freq_bm.tsd  = L.OutPutData.Cond.respi_freq_bm.tsd;

Session_type={'Cond'}; sess=1;
Group=[7 8];
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
  
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock(n,mouse) = sum(D>4.5)/length(D);
        Prop_safe(n,mouse) = sum(D<4.5)/length(D);
        Length_shock(n,mouse) = sum(D>4.5)*.2;
        Length_safe(n,mouse) = sum(D<4.5)*.2;
        
        clear D_shock, D_shock = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock(n,mouse) = sum(D_shock>4.5)/length(D);
        Prop_safeShock(n,mouse) = sum(D_shock<4.5)/length(D);
        clear D_safe, D_safe = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe(n,mouse) = sum(D_safe>4.5)/length(D);
        Prop_safeSafe(n,mouse) = sum(D_safe<4.5)/length(D);
        Respi_safe(n,mouse) = nanmean(D_safe);
        
    end
    n=n+1;
end
Prop_shock(Prop_shock==0)=NaN;
Prop_safe(Prop_safe==0)=NaN;
Length_shock(Length_shock==0)=NaN;
Length_safe(Length_safe==0)=NaN;
Prop_shockShock(Prop_shockShock==0)=NaN;
Prop_safeShock(Prop_safeShock==0)=NaN;
Prop_shockSafe(Prop_shockSafe==0)=NaN;
Prop_safeSafe(Prop_safeSafe==0)=NaN;
Respi_safe(Respi_safe==0)=NaN;



L = load('DATA_DZP_Physio_Cond.mat');
Session_type={'Cond'}; sess=1;
Group=[13 15];
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock(n,mouse) = sum(D>4.5)/length(D);
        Prop_safe(n,mouse) = sum(D<4.5)/length(D);
        Length_shock(n,mouse) = sum(D>4.5)*.2;
        Length_safe(n,mouse) = sum(D<4.5)*.2;
        
        clear D_shock, D_shock = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock(n,mouse) = sum(D_shock>4.5)/length(D);
        Prop_safeShock(n,mouse) = sum(D_shock<4.5)/length(D);
        clear D_safe, D_safe = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe(n,mouse) = sum(D_safe>4.5)/length(D);
        Prop_safeSafe(n,mouse) = sum(D_safe<4.5)/length(D);
        Respi_safe(n,mouse) = nanmean(D_safe);
        
    end
    n=n+1;
end
Prop_shock(Prop_shock==0)=NaN;
Prop_safe(Prop_safe==0)=NaN;
Length_shock(Length_shock==0)=NaN;
Length_safe(Length_safe==0)=NaN;
Prop_shockShock(Prop_shockShock==0)=NaN;
Prop_safeShock(Prop_safeShock==0)=NaN;
Prop_shockSafe(Prop_shockSafe==0)=NaN;
Prop_safeSafe(Prop_safeSafe==0)=NaN;
Respi_safe(Respi_safe==0)=NaN;





L = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_PAG_Cond_2sFullBins.mat');
Session_type={'Cond'}; sess=1;
Group=[9];
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};

L.OutPutData.PAG.Cond.respi_freq_bm.tsd  = L.OutPutData.Cond.respi_freq_bm.tsd;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse = 1:length(Mouse)
        
        clear D, D = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,3});
        Prop_shock(n,mouse) = sum(D>4.5)/length(D);
        Prop_safe(n,mouse) = sum(D<4.5)/length(D);
        Length_shock(n,mouse) = sum(D>4.5)*.2;
        Length_safe(n,mouse) = sum(D<4.5)*.2;
        
        clear D_shock, D_shock = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,5});
        Prop_shockShock(n,mouse) = sum(D_shock>4.5)/length(D);
        Prop_safeShock(n,mouse) = sum(D_shock<4.5)/length(D);
        clear D_safe, D_safe = Data(L.OutPutData.(Drug_Group{group}).(Session_type{sess}).respi_freq_bm.tsd{mouse,6});
        Prop_shockSafe(n,mouse) = sum(D_safe>4.5)/length(D);
        Prop_safeSafe(n,mouse) = sum(D_safe<4.5)/length(D);
        Respi_safe(n,mouse) = nanmean(D_safe);
        
    end
    n=n+1;
end
Prop_shock(Prop_shock==0)=NaN;
Prop_safe(Prop_safe==0)=NaN;
Length_shock(Length_shock==0)=NaN;
Length_safe(Length_safe==0)=NaN;
Prop_shockShock(Prop_shockShock==0)=NaN;
Prop_safeShock(Prop_safeShock==0)=NaN;
Prop_shockSafe(Prop_shockSafe==0)=NaN;
Prop_safeSafe(Prop_safeSafe==0)=NaN;
Respi_safe(Respi_safe==0)=NaN;




