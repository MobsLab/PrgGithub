
function [v1, v2 , eig1 , eig2] = Understand_Elisa_Data_BM(Data , Mouse_names , Var_Names)

try
    [~ , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(Data , Mouse_names , Var_Names);
catch
    [~ , v1, v2 , eig1 , eig2] = Correlations_Matrices_Data_BM(Data' , Mouse_names , Var_Names);
end

for mouse=1:length(Mouse_names)
    proj_mice(mouse) = dot(Data(mouse,v1) , eig1);
end
proj_norm = 2*(proj_mice-min(proj_mice))/(max(proj_mice)-min(proj_mice))-1; % normalisation [-1 1]


Cols2={[1 .5 1],[1 .5 .5],[.5 .5 1]};
Legends2={'all mice','1st group','2nd group'};
X2=1:3;

ind_grp1 = proj_norm<median(proj_norm);
ind_grp2 = proj_norm>median(proj_norm);

figure
MakeSpreadAndBoxPlot3_SB({proj_norm proj_norm(ind_grp1)...
    proj_norm(ind_grp2)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('model score (a.u.)')

load('/media/nas7/Modelling_Behaviour/Free_Explo_Project/FromBaptiste/Workspace_DrugsOverview_Sal.mat', 'ExtraStimNumber','Proportionnal_Time_Freezing_ofZone','Respi_Shock')

figure
subplot(131)
A=ExtraStimNumber.Cond{1};
A(A>12)=NaN;
ind = A<12;
PlotCorrelations_BM(proj_norm,A,'method','spearman')
axis square
xlabel('model score pre'), ylabel('eyelid shocks, Cond'), ylim([0 10]), xlim([-1.2 1.2])

subplot(132)
A=Proportionnal_Time_Freezing_ofZone.Safe.Cond{1};
A(~ind)=NaN; 
PlotCorrelations_BM(proj_norm,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('freezing safe prop, Cond'), ylim([0 .35]), xlim([-1.2 1.2])

subplot(133)
A=Respi_Shock.Cond{1};
A(~ind)=NaN; 
PlotCorrelations_BM(proj_norm,A,'method','pearson')
axis square
xlabel('model score pre'), ylabel('Respi freq, Fz shock, Cond'), ylim([3 6]), xlim([-1.2 1.2])










