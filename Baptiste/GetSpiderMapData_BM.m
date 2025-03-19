

% use Matlab2021b

addpath(genpath('/home/ratatouille/Documents/MATLAB/'))
addpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/'))

rmpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/mvgc_v1.0/'));
rmpath(genpath('/home/ratatouille/Dropbox/Kteam/PrgMatlab/MuTE_onlineVersion'))


load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat')

Var = {'respi_freq_bm','heartrate','heartratevar','ob_gamma_freq','ob_gamma_power','ripples_density','hpc_theta_freq','hpc_theta_power'};



%% Generate data
Session_type = {'Cond','Ext','Fear'};
load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Cond_2sFullBins.mat', 'OutPutData')
for sess=1%:length(Session_type)
    clear Freq_Max1 Freq_Max2
    figure
    [~ , ~ , Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , [1 .5 .5] , 'dashed_line' , 1);
    [~ , ~ , Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'dashed_line' , 1);
    close
    DATA_TO_PLOT.(Session_type{sess})(1,1,:) = (Freq_Max1);
    DATA_TO_PLOT.(Session_type{sess})(1,2,:) = (Freq_Max2);
    for var=2:length(Var)
        DATA_TO_PLOT.(Session_type{sess})(var,1,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,5);
        DATA_TO_PLOT.(Session_type{sess})(var,2,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,6);
    end
    DATA_TO_PLOT.(Session_type{sess})(DATA_TO_PLOT.(Session_type{sess})==0)=NaN;
end

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Ext_2sFullBins.mat', 'OutPutData')
for sess=2%:length(Session_type)
    clear Freq_Max1 Freq_Max2
    figure
    [~ , ~ , Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , [1 .5 .5] , 'dashed_line' , 1);
    [~ , ~ , Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'dashed_line' , 1);
    close
    DATA_TO_PLOT.(Session_type{sess})(1,1,:) = (Freq_Max1);
    DATA_TO_PLOT.(Session_type{sess})(1,2,:) = (Freq_Max2);
    for var=2:length(Var)
        DATA_TO_PLOT.(Session_type{sess})(var,1,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,5);
        DATA_TO_PLOT.(Session_type{sess})(var,2,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,6);
    end
    DATA_TO_PLOT.(Session_type{sess})(DATA_TO_PLOT.(Session_type{sess})==0)=NaN;
end

load('/media/nas7/ProjetEmbReact/DataEmbReact/Data_Physio_Freezing_Saline_all_Fear_2sFullBins.mat', 'OutPutData')
for sess=3%:length(Session_type)
    clear Freq_Max1 Freq_Max2
    figure
    [~ , ~ , Freq_Max1] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,5,:)), 'color' , [1 .5 .5] , 'dashed_line' , 1);
    [~ , ~ , Freq_Max2] = Plot_MeanSpectrumForMice_BM(squeeze(OutPutData.(Session_type{sess}).ob_low.mean(:,6,:)) , 'color' , [.5 .5 1] , 'dashed_line' , 1);
    close
    DATA_TO_PLOT.(Session_type{sess})(1,1,:) = (Freq_Max1);
    DATA_TO_PLOT.(Session_type{sess})(1,2,:) = (Freq_Max2);
    for var=2:length(Var)
        DATA_TO_PLOT.(Session_type{sess})(var,1,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,5);
        DATA_TO_PLOT.(Session_type{sess})(var,2,:) = OutPutData.(Session_type{sess}).(Var{var}).mean(:,6);
    end
    DATA_TO_PLOT.(Session_type{sess})(DATA_TO_PLOT.(Session_type{sess})==0)=NaN;
end


save('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat','DATA_TO_PLOT')



% blocked/unblocked
load('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/OB_Spec.mat','OB_MeanSpecFz_Shock_Blocked','OB_MeanSpecFz_Safe_Blocked',...
   'OB_MeanSpecFz_Shock_Unblocked','OB_MeanSpecFz_Safe_Unblocked')


clear Freq_Max1 Freq_Max2
figure
[~,~, Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Blocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~, Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Blocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
DATA_TO_PLOT_Blocked.Fear(1,1,:) = Freq_Max1;
DATA_TO_PLOT_Blocked.Fear(1,2,:) = Freq_Max2;

clear Freq_Max1 Freq_Max2
figure
[~,~, Freq_Max1] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Shock_Unblocked.Fear, 'color' , [1 .5 .5], 'smoothing' , 3 , 'dashed_line' , 0);
[~,~, Freq_Max2] = Plot_MeanSpectrumForMice_BM(OB_MeanSpecFz_Safe_Unblocked.Fear , 'color' , [.5 .5 1], 'smoothing' , 3 , 'dashed_line' , 0);
close
DATA_TO_PLOT_Unblocked.Fear(1,1,:) = Freq_Max1;
DATA_TO_PLOT_Unblocked.Fear(1,2,:) = Freq_Max2;

GetAllSalineSessions_BM
for mouse=1:length(Mouse)
   BlockedEpoch.Fear.(Mouse_names{mouse}) = ConcatenateDataFromFolders_SB(FearSess.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
    UnblockedEpoch.Fear.(Mouse_names{mouse}) = intervalSet(0,max(Range(OutPutData.Fear.respi_freq_bm.tsd{mouse,1})))-BlockedEpoch.Fear.(Mouse_names{mouse});
    for var=2:length(Var)
        % blocked
        try
            DATA_TO_PLOT_Blocked.Fear(var,1,mouse) = nanmean(Data(Restrict(OutPutData.Fear.(Var{var}).tsd{mouse,5} , BlockedEpoch.Fear.(Mouse_names{mouse}))));
        catch
            DATA_TO_PLOT_Blocked.Fear(var,1,mouse) = NaN;
        end
        try
            DATA_TO_PLOT_Blocked.Fear(var,2,mouse) = nanmean(Data(Restrict(OutPutData.Fear.(Var{var}).tsd{mouse,6} , BlockedEpoch.Fear.(Mouse_names{mouse}))));
        catch
            DATA_TO_PLOT_Blocked.Fear(var,2,mouse) = NaN;
        end
        % unblocked
        try
            DATA_TO_PLOT_Unblocked.Fear(var,1,mouse) = nanmean(Data(Restrict(OutPutData.Fear.(Var{var}).tsd{mouse,5} , UnblockedEpoch.Fear.(Mouse_names{mouse}))));
        catch
            DATA_TO_PLOT_Unblocked.Fear(var,1,mouse) = NaN;
        end
        try
            DATA_TO_PLOT_Unblocked.Fear(var,2,mouse) = nanmean(Data(Restrict(OutPutData.Fear.(Var{var}).tsd{mouse,6} , UnblockedEpoch.Fear.(Mouse_names{mouse}))));
        catch
            DATA_TO_PLOT_Unblocked.Fear(var,2,mouse) = NaN;
        end
    end
    disp(Mouse_names{mouse})
end
DATA_TO_PLOT_Blocked.Fear(DATA_TO_PLOT_Blocked.Fear==0)=NaN;
DATA_TO_PLOT_Unblocked.Fear(DATA_TO_PLOT_Unblocked.Fear==0)=NaN;


save('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/SpiderMap.mat','DATA_TO_PLOT_Blocked','DATA_TO_PLOT_Unblocked','-append')


%%
for i=1:6
    clear P P2 s
    if i==1
        P=[nanmedian(DATA_TO_PLOT.Cond(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Cond(:,2,:),3)'];
    elseif i==2
        P=[nanmedian(DATA_TO_PLOT.Ext(:,1,:),3)' ; nanmedian(DATA_TO_PLOT.Ext(:,2,:),3)'];
    elseif i==3
        P=[nanmedian(DATA_TO_PLOT.Fear(:,1,1:25),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,1:25),3)'];
    elseif i==4
        P=[nanmedian(DATA_TO_PLOT.Fear(:,1,26:end),3)' ; nanmedian(DATA_TO_PLOT.Fear(:,2,26:end),3)'];
    elseif i==5
        P=[nanmedian(DATA_TO_PLOT_Blocked.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT_Blocked.Fear(:,2,:),3)'];
    elseif i==6
        P=[nanmedian(DATA_TO_PLOT_Unblocked.Fear(:,1,:),3)' ; nanmedian(DATA_TO_PLOT_Unblocked.Fear(:,2,:),3)'];
    end
    P2=P(:,[1 2 4 7 3 6 5 8]);

    try
        figure
        s = spider_plot_class(P2);
        s.AxesLabels =  {'','','','','','','',''};
        s.LegendLabels = {'Freezing shock', 'Freezing safe'};
        s.AxesInterval = 2;
        s.FillOption = { 'on', 'on'};
        s.Color = [1 .5 .5; .5 .5 1];
        s.LegendHandle.Location = 'northeastoutside';
        s.AxesLabelsEdge = 'none';
        s.AxesLimits(:,:) = [2.21 9.5 63.5 6.2 .1 .1 1.09 1.56 ; 5.12 11.84 68.6 12 .24 .308 3 2.09];
        s.MarkerSize=[1e2 1e2];
        s.AxesTickLabels={''};
    end
end



%%
% P_all=[];
% for i=1:6
%     P_all=[P_all ; P{i}];
% end
% nanmin(P_all)
% nanmax(P_all)

for f=7:12
    saveFigure_BM(f,['SpiderMap_' num2str(f)],'/home/ratatouille/Desktop/Figures_Baptiste/Paper_Figures/')
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
          %%% SVM %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear SVM_score Acc
[SVM_score.Cond{1},Acc.Cond{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Cond(:,1,:)));
[SVM_score.Cond{2},Acc.Cond{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Cond(:,2,:)));
[SVM_score.Ext{1},Acc.Ext{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Ext(:,1,:)));
[SVM_score.Ext{2},Acc.Ext{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Ext(:,2,:)));

[SVM_score.FearPAG{1},Acc.FearPAG{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Fear(:,1,1:25)));
[SVM_score.FearPAG{2},Acc.FearPAG{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Fear(:,2,1:25)));
[SVM_score.FearEyelid{1},Acc.FearEyelid{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Fear(:,1,26:end)));
[SVM_score.FearEyelid{2},Acc.FearEyelid{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT.Fear(:,2,26:end)));

[SVM_score.Blocked{1},Acc.Blocked{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT_Blocked.Fear(:,1,:)));
[SVM_score.Blocked{2},Acc.Blocked{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT_Blocked.Fear(:,2,:)));
[SVM_score.Unblocked{1},Acc.Unblocked{1}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT_Unblocked.Fear(:,1,:)));
[SVM_score.Unblocked{2},Acc.Unblocked{2}] = Get_SVM_Score_BM(squeeze(DATA_TO_PLOT_Unblocked.Fear(:,2,:)));


Cols={[1 .5 .5],[.5 .5 1]};
X=[1:2];
Legends={'Shock','Safe'};

figure
subplot(261)
A=SVM_score.Cond;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('SVM score'), ylim([-3.5 10])
title('Cond')

subplot(262)
A=SVM_score.Ext;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-3.5 10])
title('Recall')

subplot(263)
A=SVM_score.FearPAG;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-3.5 10])
title('PAG')

subplot(264)
A=SVM_score.FearEyelid;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-3.5 10])
title('Eyelid')

subplot(265)
A=SVM_score.Blocked;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-3.5 10])
title('Blocked')

subplot(266)
A=SVM_score.Unblocked;
MakeSpreadAndBoxPlot3_SB({[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([-3.5 10])
title('Unblocked')



subplot(267)
A=Acc.Cond; A{1}(isnan(SVM_score.Cond{1}))=NaN; A{2}(isnan(SVM_score.Cond{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45)
ylabel('Accuracy'), ylim([0 1.1])

subplot(268)
A=Acc.Ext; A{1}(isnan(SVM_score.Ext{1}))=NaN; A{2}(isnan(SVM_score.Ext{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45), ylim([0 1.1])

subplot(269)
A=Acc.FearPAG; A{1}(isnan(SVM_score.FearPAG{1}))=NaN; A{2}(isnan(SVM_score.FearPAG{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45), ylim([0 1.1])

subplot(2,6,10)
A=Acc.FearEyelid; A{1}(isnan(SVM_score.FearEyelid{1}))=NaN; A{2}(isnan(SVM_score.FearEyelid{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45), ylim([0 1.1])

subplot(2,6,11)
A=Acc.Blocked; A{1}(isnan(SVM_score.Blocked{1}))=NaN; A{2}(isnan(SVM_score.Blocked{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45), ylim([0 1.1])

subplot(2,6,12)
A=Acc.Unblocked; A{1}(isnan(SVM_score.Unblocked{1}))=NaN; A{2}(isnan(SVM_score.Unblocked{2}))=NaN;
PlotErrorBarN_KJ({1-[A{1}(1,:) A{1}(3,isnan(A{1}(1,:)))] [A{2}(1,:) A{2}(3,isnan(A{2}(1,:)))]},...
    'barcolors',{[1 0.5 0.5],[0.5 0.5 1]},'x_data',[1,2],'showPoints',0,'ShowSigstar','sig','newfig',0);
set(gca,'XTick',1:2,'XtickLabel',{'Shock','Safe'}), xtickangle(45), ylim([0 1.1])






