%CurtoModelTest
% 01.04.2018 KJ
%
% test the curto model
%
% see 



clear

Dir=PathForExperimentsBasalSleepSpike;
p=7;
cd(Dir.path{p})

%params
binsize_mua = 0.8; %ms
hannwin_len = 16; %ms
tau = 100;

%% load


MUA = GetMuaNeurons_KJ('PFCx','binsize',binsize_mua); %0.8ms
[Vdata, Wdata, Vderiv] = GetCurtoData_KJ(MUA);

load('SleepSubstages.mat')
Substages = Epoch([1:5 7]);
N3 = Substages{3};
durN3 = End(N3) - Start(N3);
idx_n3 = find(durN3<5e4);

%% Fit and simulation

%fit
epoch = subset(N3,idx_n3(7));
[a1, a2, a3, I, b] = FitCurtoParams_KJ(Vdata, Wdata, Vderiv, 'epoch', epoch);


%simulation
nb_data = length(Data(Restrict(MUA,epoch)));
model_params.a1=a1; model_params.a2=a2; model_params.a3=a3; model_params.I=I; model_params.b=b;
% model_params.a1=-0.0271; model_params.a2=0.394; model_params.a3=-0.9; model_params.I=0.00017; model_params.b=-0.0374;
[v_sim, w_sim] = CurtoSimulation(model_params, 'toPlot',0, 'nb_data', nb_data, 'tau', tau, 'dt', binsize_mua);

%nullclines
nc = linspace(0,0.4,200);
nullclines1 = (a3*nc.^3 + a2*nc.^2 + a1*nc + I) / (-b);
nullclines2 = nc;


%data for plot
t_range = Range(Restrict(MUA,epoch),'s');
t_range = t_range - t_range(1);
v_data = Data(Restrict(Vdata,epoch));
w_data = Data(Restrict(Wdata,epoch));


%% plot simulation
figure; hold on

%MUA with time
subplot(2,2,1), hold on
plot(t_range, v_data, 'r'),  hold on
plot(t_range, v_sim, 'b'),  hold on
title('V'), xlabel('time (s)')

%W with time
subplot(2,2,2), hold on
plot(t_range, w_data, 'r'),  hold on
plot(t_range, w_sim, 'b'),  hold on
title('W'), xlabel('time (s)')

%phase diagram
subplot(2,2,3:4), hold on
plot(v_data, w_data, 'r'), hold on
plot(v_sim, w_sim, 'b'), hold on
plot(nc, nullclines1, 'k', 'linewidth', 2), hold on
plot(nc, nullclines2, 'k', 'linewidth', 2), hold on
xlim([0 0.4]), ylim([0 0.25]),
xlabel('v') , ylabel('w')






% %% PLOT
% figure, hold on
% tmp = Range(Restrict(MUA,epoch));
% tmp = (tmp-tmp(1))/10;
% 
% subplot(3,1,1), hold on
% plot(tmp, Data(Restrict(MUA,epoch))), hold on
% xlim([0 3e3]),
% subplot(3,1,2), hold on
% plot(tmp, Data(Restrict(Vdata,epoch))), hold on
% xlim([0 3e3]),
% subplot(3,1,3), hold on
% plot(tmp, Data(Restrict(Wdata,epoch))), hold on
% xlim([0 3e3]),
% 






