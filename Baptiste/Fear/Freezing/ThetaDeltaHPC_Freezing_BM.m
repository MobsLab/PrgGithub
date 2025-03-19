
Cols = {[1, 0.8, 0.8],[1, 0.5, 0.5],[0.5 0.5 1],[0.8 0.8 1]};
X = [1,2,3,4];
Legends = {'Active shock','Freezing shock','Freezing safe','Active safe'};

Mouse=[666 667 668 669 688 739 777 779 849 893];
[OutPutVar , OutPutData]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','hpc_low');

figure
for i=1:8
    subplot(2,4,i)
    
    Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,i,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
    shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,i,:))),Conf_Inter,'-b',1); hold on;
    ylim([-1 3]); xlim([0 15])
    title(NameEpoch{i})
    [c,d]=max(nanmean(squeeze(OutPutData.hpc_low.norm(:,i,52:end))));
    vline(Spectro{3}(d+51),'--r')
    
end

% HPC Low Spectrum during the 2 freezing types
figure
Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,5,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,5,:))),Conf_Inter,'-r',1); hold on;
Conf_Inter=nanstd(squeeze(OutPutData.hpc_low.norm(:,6,:)))/sqrt(size(squeeze(OutPutData.hpc_low.norm),1));
shadedErrorBar(Spectro{3},nanmean(squeeze(OutPutData.hpc_low.norm(:,6,:))),Conf_Inter,'-b',1); hold on;
ylim([-1 3]); xlim([0 12])
makepretty
ylabel('Power (A.U.)')
xlabel('Frequency (Hz)')
f=get(gca,'Children');
legend([f(5),f(1)],'Shock side freezing','Safe side freezing')
title('HPC Low Spectrum')

%%
cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste')
load('Sess.mat','Sess')

Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    %Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    TestPostSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPost')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
    FearSess.(Mouse_names{mouse}) =  [CondSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse})];
    TestPreSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'TestPre')))));
end

for mouse = 1:length(Mouse) 
    
    HPC_LFP_TSD.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'lfp','channumber',18);
    Acc_TSD.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero');
    Fz_Epoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','freezeepoch');
    Zone_Epoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'epoch','epochname','zoneepoch');
    
    Shock_Epoch.(Mouse_names{mouse})=Zone_Epoch.(Mouse_names{mouse}){1};
    Safe_Epoch.(Mouse_names{mouse})=or(Zone_Epoch.(Mouse_names{mouse}){2},Zone_Epoch.(Mouse_names{mouse}){5});
    
    Shock_Fz_Epoch.(Mouse_names{mouse})=and(Fz_Epoch.(Mouse_names{mouse}),Shock_Epoch.(Mouse_names{mouse}));
    Safe_Fz_Epoch.(Mouse_names{mouse})=and(Fz_Epoch.(Mouse_names{mouse}),Safe_Epoch.(Mouse_names{mouse}));
    
    
    [ThetaRatioTSD.(Mouse_names{mouse}) , smooth_Theta.(Mouse_names{mouse})]=FindThetaEpoch_BM( HPC_LFP_TSD.(Mouse_names{mouse}) );
    
    HPC_LFP_TSD_Fz.(Mouse_names{mouse})=Restrict(HPC_LFP_TSD.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    
    smooth_Theta_Fz.(Mouse_names{mouse})=Restrict(smooth_Theta.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    smooth_Theta_Fz_Shock.(Mouse_names{mouse})=Restrict(smooth_Theta.(Mouse_names{mouse}) , Shock_Fz_Epoch.(Mouse_names{mouse}));
    smooth_Theta_Fz_Safe.(Mouse_names{mouse})=Restrict(smooth_Theta.(Mouse_names{mouse}) , Safe_Fz_Epoch.(Mouse_names{mouse}));
    
    Acc_TSD_Fz.(Mouse_names{mouse})=Restrict(Acc_TSD.(Mouse_names{mouse}) , Fz_Epoch.(Mouse_names{mouse}));
    Acc_TSD_Fz_Shock.(Mouse_names{mouse})=Restrict(Acc_TSD.(Mouse_names{mouse}) , Shock_Fz_Epoch.(Mouse_names{mouse}));
    Acc_TSD_Fz_Safe.(Mouse_names{mouse})=Restrict(Acc_TSD.(Mouse_names{mouse}) , Safe_Fz_Epoch.(Mouse_names{mouse}));
    
end

rat_theta=[]; rat_theta_Fz=[]; rat_theta_Fz_Shock=[]; rat_theta_Fz_Safe=[];
for mouse = 1:length(Mouse)
    rat_theta = [rat_theta ; log(Data(smooth_Theta.(Mouse_names{mouse})))];
    rat_theta_Fz = [rat_theta_Fz ; log(Data(smooth_Theta_Fz.(Mouse_names{mouse})))];
    rat_theta_Fz_Shock =[rat_theta_Fz_Shock ; log(Data(smooth_Theta_Fz_Shock.(Mouse_names{mouse})))];
    rat_theta_Fz_Safe = [rat_theta_Fz_Safe ; log(Data(smooth_Theta_Fz_Safe.(Mouse_names{mouse})))];
    
    All_Log_Ratio(1,mouse)=nanmean(log(Data(smooth_Theta.(Mouse_names{mouse}))));
    All_Log_Ratio(2,mouse)=nanmean(log(Data(smooth_Theta_Fz.(Mouse_names{mouse}))));
    All_Log_Ratio(3,mouse)=nanmean(log(Data(smooth_Theta_Fz_Shock.(Mouse_names{mouse}))));
    All_Log_Ratio(4,mouse)=nanmean(log(Data(smooth_Theta_Fz_Safe.(Mouse_names{mouse}))));
end

[Y,X] = hist(rat_theta,100); Y = Y/sum(Y);
[Y_Fz,X_Fz] = hist(rat_theta_Fz,100); Y_Fz = Y_Fz/sum(Y_Fz);
[Y_Fz_Shock,X_Fz_Shock] = hist(rat_theta_Fz_Shock,100); Y_Fz_Shock = Y_Fz_Shock/sum(Y_Fz_Shock);
[Y_Fz_Safe,X_Fz_Safe] = hist(rat_theta_Fz_Safe,100); Y_Fz_Safe = Y_Fz_Safe/sum(Y_Fz_Safe);


figure; plot(X,Y), hold on
plot(X_Fz,Y_Fz), 
plot(X_Fz_Shock,Y_Fz_Shock), 
plot(X_Fz_Safe,Y_Fz_Safe), 

bar([length(rat_theta) length(rat_theta_Fz) length(rat_theta_Fz_Shock) length(rat_theta_Fz_Safe) ]); xlim([0 4.5])

PlotErrorBarN_KJ(All_Log_Ratio')
xticks([1:4]); xticklabels({'Active','Freezing','Freezing shock','Freezing safe'})
makepretty; xtickangle(45); ylabel('Theta/Delta ratio')





% Example for a mouse
figure
subplot(311)
plot(Range(HPC_LFP_TSD),runmean(Data(HPC_LFP_TSD),10))
hold on
plot(Range(HPC_LFP_TSD_Fz),runmean(Data(HPC_LFP_TSD_Fz),10))
subplot(312)
plot(Range(smooth_Theta),Data(smooth_Theta))
hold on
plot(Range(smooth_Theta_Fz),Data(smooth_Theta_Fz))
plot(Range(smooth_Theta_Fz_Shock),Data(smooth_Theta_Fz_Shock))
plot(Range(smooth_Theta_Fz_Safe),Data(smooth_Theta_Fz_Safe))
subplot(313)
plot(Range(Acc_TSD),Data(Acc_TSD))
hold on
plot(Range(Acc_TSD_Fz),Data(Acc_TSD_Fz))
plot(Range(Acc_TSD_Fz_Shock),Data(Acc_TSD_Fz_Shock))
plot(Range(Acc_TSD_Fz_Safe),Data(Acc_TSD_Fz_Safe))

rat_theta=log(Data(smooth_Theta));
[Y,X] = hist(rat_theta,100); Y = Y/sum(Y);
figure; plot(X,Y), hold on
 
rat_theta_Fz=log(Data(smooth_Theta_Fz));
[Y,X] = hist(rat_theta_Fz,100);Y = Y/sum(Y);
figure; plot(X,Y), hold on

rat_theta_Fz_Shock=log(Data(smooth_Theta_Fz_Shock));
[Y,X] = hist(rat_theta_Fz_Shock,100); Y = Y/sum(Y);
figure; plot(X,Y), hold on

rat_theta_Fz_Safe=log(Data(smooth_Theta_Fz_Safe));
[Y,X] = hist(rat_theta_Fz_Safe,100); Y = Y/sum(Y);
figure; plot(X,Y), hold on










