

clear all

%% path & load data
% eyelid
Group=22;
Drug_Group={'Saline'};
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/SVM_tsd.mat')

% rip inhib
Group=[7 8];
Drug_Group={'RipControl','RipInhib'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Respi_corrected_RipControl.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Respi_corrected_RipInhib.mat');

% DZP
Group=[13 15];
Drug_Group={'Saline','Diazepam'};
GetEmbReactMiceFolderList_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_SalineShort_Cond_2sFullBin.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_DZPShort_Cond_2sFullBin.mat');

% PAG
Group=[9];
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_PAG_Cond_2sFullBins.mat');



%% get data
for group=1:length(Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        
        try
            D = Data(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,5}); D(isnan(D)) = [];
        catch
            D = Data(l{group}.OutPutData.Cond.respi_freq_bm_clean.tsd{mouse,5}); D(isnan(D)) = [];
        end
        if length(D)>30
            [tau_shock{group}(mouse), p_value_shock{group}(mouse), trend_shock{group}(mouse)] = mann_kendall_test(D,0.05);
            [R_shock{group}(mouse) , P_shock{group}(mouse)] = corr([1:length(D)]' , D);
        else
            trend_shock{group}(mouse) = NaN;
        end
        
        try
            D = Data(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,6}); D(isnan(D)) = [];
        catch
            D = Data(l{group}.OutPutData.Cond.respi_freq_bm_clean.tsd{mouse,6}); D(isnan(D)) = [];
        end
        if length(D)>30
            [tau_safe{group}(mouse), p_value_safe{group}(mouse), trend_safe{group}(mouse)] = mann_kendall_test(D,0.05);
            [R_safe{group}(mouse) , P_safe{group}(mouse)] = corr([1:length(D)]' , D);
        else
            trend_safe{group}(mouse) = NaN;
        end
    end
    tau_shock{group}(tau_shock{group}==0) = NaN;
    tau_safe{group}(tau_safe{group}==0) = NaN;
    R_shock{group}(R_shock{group}==0) = NaN;
    P_shock{group}(P_shock{group}==0) = NaN;
    R_safe{group}(R_safe{group}==0) = NaN;
    P_safe{group}(P_safe{group}==0) = NaN;
end

% if DZP, R_safe{1}(7) = -0.61;
    
for group=1:length(Group)
    p_shock(group) = signrank(trend_shock{group}(~isnan(trend_shock{group})) , zeros(1,sum(~isnan(trend_shock{group}))));
    p_safe(group) = signrank(trend_safe{group}(~isnan(trend_safe{group})) , zeros(1,sum(~isnan(trend_safe{group}))));
    p_shock2(group) = signrank(R_shock{group}(~isnan(R_shock{group})) , zeros(1,sum(~isnan(R_shock{group}))));
    p_safe2(group) = signrank(R_safe{group}(~isnan(R_safe{group})) , zeros(1,sum(~isnan(R_safe{group}))));
end

%% figures
Cols = {[1 .5 .5],[.5 .5 1]};
X = [1:2];
Legends = {'Shock','Safe'};


figure
MakeSpreadAndBoxPlot3_SB({trend_shock{1}+(-.2+rand(1,29)*.4) trend_safe{group}+(-.2+rand(1,29)*.4)},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('trend'), hline(0,'--k')
makepretty_BM2

sigstar({[.7 1.3]},p(1))
sigstar({[1.7 2.3]},p(2))


figure
subplot(121)
MakeSpreadAndBoxPlot4_SB(R_shock(group),Cols(1),X(1),Legends(1),'showpoints',1,'paired',0);
ylabel('temporal evolution index'), hline(0,'--k'), ylim([-.75 .75])
makepretty_BM2
sigstar({[.7 1.3]},p_shock2(1))

subplot(122)
MakeSpreadAndBoxPlot4_SB(R_safe(group),Cols(2),X(2),Legends(2),'showpoints',1,'paired',0);
hline(0,'--k'), ylim([-.75 .75])
makepretty_BM2
sigstar({[1.7 2.3]},p_safe2(1))


Cols = {[.3 .3 .3],[.6 .6 .6]};
X = [1:2];
Legends = {'Saline','DZP'};


figure
MakeSpreadAndBoxPlot3_SB(R_safe,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('kendall tau'), hline(0,'--k')
makepretty_BM2


sigstar({[.7 1.3]},p_safe(1))
sigstar({[1.7 2.3]},p_safe(2))







%% 0-15 / 85-100%
clear all

Group=22;
Drug_Group={'Saline'};
GetAllSalineSessions_BM
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_Eyelid_Cond_2sFullBins.mat');
load('/media/nas7/ProjetEmbReact/DataEmbReact/NewData/SVM_tsd.mat')

Params={'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_delta'};
group = 1;

for param=1:8
    for mouse = 1:length(Mouse)
        try
            clear D, D = Data(l{group}.OutPutData.Cond.(Params{param}).tsd{mouse,5});
            DATA_shock.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
        try
            clear D, D = Data(l{group}.OutPutData.Cond.(Params{param}).tsd{mouse,6});
            DATA_safe.(Params{param})(mouse,:) = interp1(linspace(0,1,length(D)) , D , linspace(0,1,100));
        end
    end
    DATA_shock.(Params{param})(DATA_shock.(Params{param})==0) = NaN;
    DATA_safe.(Params{param})(DATA_safe.(Params{param})==0) = NaN;
end
param=1; bin=15;
Respi_shock_beg = nanmean(DATA_shock.(Params{param})(:,1:bin)');
Respi_safe_beg = nanmean(DATA_safe.(Params{param})(:,1:bin)');
Respi_shock_end = nanmean(DATA_shock.(Params{param})(:,100-bin:end)');
Respi_safe_end = nanmean(DATA_safe.(Params{param})(:,100-bin:end)');



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({Respi_shock_beg Respi_shock_end},{[.6 .5 .5],[1 .5 .5]},[1 2],{['0-' num2str(bin) '%'],[ num2str(bin) '-100%']},'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2

subplot(122)
[b, tf, lthresh, uthresh, center] = filloutliers(Respi_safe_beg,'linear');
MakeSpreadAndBoxPlot3_SB({b Respi_safe_end},{[.5 .5 .6],[.5 .5 1]},[1 2],{['0-' num2str(bin) '%'],[ num2str(100-bin) '-100%']},'showpoints',0,'paired',1);
ylabel('Breathing (Hz)')
makepretty_BM2







