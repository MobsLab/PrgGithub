

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
l{1} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Cond_2sFullBins.mat');
l{2} = load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_RipInhib_Ctrl_Cond_2sFullBins.mat');

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
        
        D = Data(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,5}); D(isnan(D)) = [];
        if length(D)>30
            [tau_shock{group}(mouse), p_value_shock{group}(mouse), trend_shock{group}(mouse)] = mann_kendall_test(D,0.05);
            [R_shock{group}(mouse) , P_shock{group}(mouse)] = corr([1:length(D)]' , D);
        else
            trend_shock{group}(mouse) = NaN;
        end
        
        D = Data(l{group}.OutPutData.Cond.respi_freq_bm.tsd{mouse,6}); D(isnan(D)) = [];
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


for group=1:length(Group)
    [h,p_shock(group)] = ttest(trend_shock{group}(~isnan(trend_shock{group})) , zeros(1,sum(~isnan(trend_shock{group}))));
    [h,p_safe(group)] = ttest(trend_shock{group}(~isnan(trend_safe{group})) , zeros(1,sum(~isnan(trend_safe{group}))));
    [h,p_shock2(group)] = ttest(R_shock{group}(~isnan(R_shock{group})) , zeros(1,sum(~isnan(R_shock{group}))));
    [h,p_safe2(group)] = ttest(R_safe{group}(~isnan(R_safe{group})) , zeros(1,sum(~isnan(R_safe{group}))));
end

%% figure
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
MakeSpreadAndBoxPlot3_SB(trend_safe,Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('kendall tau'), hline(0,'--k')
makepretty_BM2


sigstar({[.7 1.3]},p(1))
sigstar({[1.7 2.3]},p(2))








