
%% OB mean spectrum shock safe side

figure
Conf_Inter=nanstd(squeeze(OutPutData.ob_low.norm(:,5,:)))/sqrt(size(squeeze(OutPutData.ob_low.norm(:,5,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(OutPutData.ob_low.norm(:,5,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--r'); a.LineWidth=2;
Conf_Inter=nanstd(squeeze(OutPutData.ob_low.norm(4:10,6,:)))/sqrt(size(squeeze(OutPutData.ob_low.norm(4:10,6,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(OutPutData.ob_low.norm(4:10,6,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-b',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--b'); a.LineWidth=2;
makepretty
xlabel('Frequency (Hz)')
xlim([0 10]); ylim([-0.5 1.6])
f=get(gca,'Children'); legend([f(5),f(1)],'Shock side freezing','Safe side freezing');
ylabel('Power (A.U)')

figure
subplot(121); 
Conf_Inter=nanstd(OB_Shock_Fz_All.(Session_type{sess}).Saline)/sqrt(size(OB_Shock_Fz_All.(Session_type{sess}).Saline,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Shock_Fz_All.(Session_type{sess}).Saline);
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-r',1); hold on;
makepretty
xlim([0 10]); ylim([-0.5 1.6])
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
title('Shock side freezing')

subplot(122)
Conf_Inter=nanstd(OB_Safe_Fz_All.(Session_type{sess}).Saline)/sqrt(size(OB_Safe_Fz_All.(Session_type{sess}).Saline,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Safe_Fz_All.(Session_type{sess}).Saline);
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-b',1); hold on;
makepretty
xlabel('Frequency (Hz)')
xlim([0 10]); ylim([-0.5 1.6])
title('Safe side freezing')


figure
subplot(121)
Conf_Inter=nanstd(OB_Shock_Fz_All.(Session_type{sess}).Saline)/sqrt(size(OB_Shock_Fz_All.(Session_type{sess}).Saline,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Shock_Fz_All.(Session_type{sess}).Saline);
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'-r'); a.LineWidth=2;
Conf_Inter=nanstd(OB_Shock_Fz_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Shock_Fz_All.(Session_type{sess}).ChronicFlx,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Shock_Fz_All.(Session_type{sess}).ChronicFlx);
h=shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'--r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--r'); a.LineWidth=2;
makepretty
xlabel('Frequency (Hz)'); ylabel('Power (A.U)')
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Chronic Flx');
title('Shock side freezing')
xlim([0 10]); ylim([-0.5 1.6])

subplot(122)
Conf_Inter=nanstd(OB_Safe_Fz_All.(Session_type{sess}).Saline)/sqrt(size(OB_Safe_Fz_All.(Session_type{sess}).Saline,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Safe_Fz_All.(Session_type{sess}).Saline);
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-b',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'-b'); a.LineWidth=2;
Conf_Inter=nanstd(OB_Safe_Fz_All.(Session_type{sess}).ChronicFlx)/sqrt(size(OB_Safe_Fz_All.(Session_type{sess}).ChronicFlx,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(OB_Safe_Fz_All.(Session_type{sess}).ChronicFlx);
h=shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end) ) , Conf_Inter,'--b',1); hold on;
h.mainLine.Color=[0 0 0.5]; h.patch.FaceColor=[0.8 0.8 1];
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--b'); a.LineWidth=2;
f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Chronic Flx');
makepretty
xlabel('Frequency (Hz)')
xlim([0 10]); ylim([-0.5 1.6])
title('Safe side freezing')

a=suptitle('OB Low spectrum, normalized, Fz, fear sessions'); a.FontSize=20;



%% After stim
cd('/home/mobsmorty/Dropbox/Kteam/PrgMatlab/Baptiste/Temperature')
load('Sess.mat')

Mouse=[666 667 668 669 688 739 777 779 849 893];

[OutPutVar , OutPutData]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','accelero','heartrate','heartratevar','respi','tailtemperature','masktemperature');
OutPutData.tailtemperature(: , 2:8) = OutPutData.tailtemperature(: , 2:8) - OutPutData.tailtemperature(:,1);
OutPutData.masktemperature(: , 2:8) = OutPutData.masktemperature(: , 2:8) - OutPutData.masktemperature(:,1);

Physio_Param={'accelero','heartrate','heartratevar','respi','masktemperature','tailtemperature'};
Cols = {[0, 0.5, 0],[1 0 0]};
X = [1,2];
Legends = {'Active','After Stim'};

figure
for param=1:length(Physio_Param)
    
    subplot(1,length(Physio_Param),param)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Physio_Param{param})(:,[4 2]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
    if param==1; ylabel('Movement quantity'); title('Movement')
    elseif param==2; ylabel('Frequency (Hz)'); title('Heart rate')
    elseif param==3; ylabel('Variability'); title('Heart rate variability')
    elseif param==4; ylabel('Frequency (Hz)'); title('Respiratory rate')
    elseif param==5; ylabel('NormalizedTemperature (°C)'); title('Body Temperature')
    elseif param==6; ylabel('NormalizedTemperature (°C)'); title('Tail temperature')
    end
    
end

a=suptitle('Behaviour & physiological parameters mean values, n=10'); a.FontSize=20;


figure
subplot(1,6,1)
Conf_Inter=nanstd(all_mice_onset.Stim.Acc)/sqrt(size(all_mice_onset.Stim.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Acc),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylim([0 1.5e8]);
ylabel('Movement quantity')
makepretty
a=title( 'Accelerometer'); a.Position=[60 12e7 0];
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
a=text(55,12e7,'Eyelidshock','FontSize',15,'Color','r')

subplot(1,6,2)
Conf_Inter=nanstd(all_mice_onset.Stim.HR)/sqrt(size(all_mice_onset.Stim.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
ylim([12.6 13.4])

subplot(1,6,3)
Conf_Inter=nanstd(all_mice_onset.Stim.HRVar)/sqrt(size(all_mice_onset.Stim.HRVar,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.HRVar),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Variability')
title( 'Heart Rate variability');
makepretty
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
ylim([0 0.2])

subplot(1,6,4)
Conf_Inter=nanstd(all_mice_onset.Stim.Respi)/sqrt(size(all_mice_onset.Stim.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
ylim([6 8.5])

subplot(1,6,5)
Conf_Inter=nanstd(all_mice_onset.Stim.MTemp)/sqrt(size(all_mice_onset.Stim.MTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.MTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Normalized Temperature (°C)')
makepretty
title( 'Total Body Temperature');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
ylim([-0.7 0.1])

subplot(1,6,6)
Conf_Inter=nanstd(all_mice_onset.Stim.TTemp)/sqrt(size(all_mice_onset.Stim.TTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.Stim.TTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Normalized Temperature (°C)')
makepretty
title( 'Tail Temperature');
xticklabels({'-10s','0s','10s'})
line([50 50], [-5 2e8],'color','r','LineWidth',5);
ylim([-2 -0.5])

a=suptitle('Physiological parameters evolution after eyelidshock, n=10'); a.FontSize=20;

saveFigure(1,'Physiological_Params_Eyelidshocks','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')


Spectro_Param={'ob_low','ob_high'};
% Spectrum analysis
Mouse=[666 667 668 669 688 739 777 779 849 893];
[OutPutVar , OutPutData]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','ob_low','ob_high');

figure
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_high.power(:,[4 2]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Power (A.U.)'); 


%% Freezing
Physio_Param={'accelero','heartrate','heartratevar','respi','masktemperature','tailtemperature'};
Cols = {[0, 0.5, 0],[0.494, 0.184, 0.556]};
X = [1,2];
Legends = {'Active','Freezing'};

figure
for param=1:length(Physio_Param)
    
    subplot(1,length(Physio_Param),param)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Physio_Param{param})(:,[4 3]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
    if param==1; ylabel('Movement quantity'); title('Movement')
    elseif param==2; ylabel('Frequency (Hz)'); title('Heart rate')
    elseif param==3; ylabel('Variability'); title('Heart rate variability')
    elseif param==4; ylabel('Frequency (Hz)'); title('Respiratory rate')
    elseif param==5; ylabel('NormalizedTemperature (°C)'); title('Body Temperature')
    elseif param==6; ylabel('NormalizedTemperature (°C)'); title('Tail temperature')
    end
    
end

a=suptitle('Physiological parameters and behaviour evolution during fear session, n=10'); a.FontSize=30
a=suptitle('Behaviour & physiological parameters mean values, n=10'); a.FontSize=20;

saveFigure(1,'Physiological_Analysis_Fear_MeanValues','/home/mobsmorty/Desktop/Baptiste/FiguresForSophie/')

% evolution
figure
subplot(161)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Acc)/sqrt(size(all_mice_onset.FreezingOnset.Acc,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Acc),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylim([0 4e7]);
ylabel('Movement quantity')
makepretty
title( 'Accelerometer');
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
a=text(50,3e7,'Freezing onset','FontSize',15,'Color','r')

subplot(162)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HR)/sqrt(size(all_mice_onset.FreezingOnset.HR,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HR),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
title( 'Heart Rate');
makepretty
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 

subplot(163)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.HRVar)/sqrt(size(all_mice_onset.FreezingOnset.HRVar,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.HRVar),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Variability')
title( 'Heart Rate variability');
makepretty
xticklabels({'-10s','0s','10s'})
a=vline(50,'--r'); a.LineWidth=4; 
ylim([0.1 0.3 ]);

subplot(164)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.Respi)/sqrt(size(all_mice_onset.FreezingOnset.Respi,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.Respi),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('Frequency (Hz)')
makepretty
title( 'Respiratory Rate');
a=vline(50,'--r'); a.LineWidth=4; 
xticks([0 50 100])
xticklabels({'-10s','0s','10s'})

subplot(165)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.MTemp)/sqrt(size(all_mice_onset.FreezingOnset.MTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.MTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Total Body Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})

subplot(166)
Conf_Inter=nanstd(all_mice_onset.FreezingOnset.TTemp)/sqrt(size(all_mice_onset.FreezingOnset.TTemp,1));
shadedErrorBar([1:100],nanmean(all_mice_onset.FreezingOnset.TTemp),Conf_Inter,{'Color','k','Linewidth',2},1); hold on
ylabel('NormalizedTemperature (°C)')
makepretty
title( 'Tail Temperature');
a=vline(50,'--r'); a.LineWidth=4; 
xticklabels({'-10s','0s','10s'})

a=suptitle('Physiological parameters evolution around freezing onset, n=10'); a.FontSize=20;

% Spectro
figure
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_high.power(:,[4 3]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Power (A.U.)'); 

%% 2 freezing types
[OutPutVar , OutPutData]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','accelero','heartrate','heartratevar','respi','tailtemperature','masktemperature');

Physio_Param={'accelero','heartrate','heartratevar','respi','masktemperature','tailtemperature'};
Cols = {[1, 0.8, 0.8],[1, 0.5, 0.5],[0.5 0.5 1],[0.8 0.8 1]};
X = [1,2,3,4];
Legends = {'Active shock','Freezing shock','Freezing safe','Active safe'};

figure
for param=1:length(Physio_Param)
    
    subplot(1,6,param)
    MakeSpreadAndBoxPlot2_SB(OutPutData.(Physio_Param{param})(:,[7 5 6 8]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
    if param==1; ylabel('Movement quantity'); title('Movement')
    elseif param==2; ylabel('Frequency (Hz)'); title('Heart rate')
    elseif param==3; ylabel('Variability'); title('Heart rate variability')
    elseif param==4; ylabel('Frequency (Hz)'); title('Respiratory rate')
    elseif param==5; ylabel('NormalizedTemperature (°C)'); title('Body Temperature')
    elseif param==6; ylabel('NormalizedTemperature (°C)'); title('Tail temperature')
    end
    
end

subplot(164)
K=[nanmean(A1(:,1:300)')'  nanmean(A1(:,301:600)')'  nanmean(A2(:,301:600)')'  nanmean(A2(:,1:300)')' ];
MakeSpreadAndBoxPlot2_SB(K ,Cols,X,Legends,'showpoints',0,'paired',1);
ylabel('Frequency (Hz)'); title('Respiratory rate')
xtickangle(45)


% Spectro
figure
MakeSpreadAndBoxPlot2_SB(OutPutData.ob_high.power(:,[7 5 6 8]),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Power (A.U.)'); 


%% Freezing proportion Saline & Chronic Flx

Mouse=[666 668 688 739 777 779 849 893 1096 875 876 877 1001 1002 1095 1130];
Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096','M875','M876','M877','M1001','M1002','M1095','M1130'}; % add 1096

[OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(Mouse,'cond','accelero','speed');


Drug_Group={'Saline','ChronicFlx'};
for mouse=1:length(Mouse)
    
    Fz_Prop.(Mouse_names{mouse})= sum(Stop(Epoch{mouse,3})-Start(Epoch{mouse,3})) / sum(Stop(Epoch{mouse,1})-Start(Epoch{mouse,1})) ;
    FzShock_Prop.(Mouse_names{mouse}) = sum(Stop(Epoch{mouse,5})-Start(Epoch{mouse,5})) / sum(Stop(Epoch{mouse,1})-Start(Epoch{mouse,1})) ;
    FzSafe_Prop.(Mouse_names{mouse}) = sum(Stop(Epoch{mouse,6})-Start(Epoch{mouse,6})) / sum(Stop(Epoch{mouse,1})-Start(Epoch{mouse,1})) ;
    
end


for group=1:length(Drug_Group)
    
    if group==1 % saline mice
        Mouse_names={'M666','M668','M688','M739','M777','M779','M849','M893','M1096'}; % add 1096
        Mouse=[666 668 688 739 777 779 849 893 1096 ];
    elseif group==2 % chronic flx mice
        Mouse_names={'M875','M876','M877','M1001','M1002','M1095','M1130'};
        Mouse=[875 876 877 1001 1002 1095 1130];
    end
    
    for mouse=1:length(Mouse_names)
        
        Fz_Prop.(Drug_Group{group})(mouse) = Fz_Prop.(Mouse_names{mouse})*100 ;
        FzShock_Prop.(Drug_Group{group})(mouse) = FzShock_Prop.(Mouse_names{mouse})*100;
        FzSafe_Prop.(Drug_Group{group})(mouse) = FzSafe_Prop.(Mouse_names{mouse})*100 ;
        
    end
end

Cols = {[0.5 0.5 1],[1, 0.5, 0.5],[0.8, 0.5, 0.5],[0.5 0.5 0.8]};
X = [1,2,3,4];
Legends = {'Saline safe','Saline shock','Chronic flx shock','Chronic flx safe'};

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB( {FzSafe_Prop.Saline FzShock_Prop.Saline FzShock_Prop.ChronicFlx FzSafe_Prop.ChronicFlx} , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('%'); title('Freezing percentage')
subplot(122)
MakeSpreadAndBoxPlot2_SB( {OutPutData.speed(1:9,6) OutPutData.speed(1:9,5)  OutPutData.speed(10:16,5) OutPutData.speed(10:16,6)} , Cols , X , Legends , 'showpoints',1,'paired',0); makepretty; xtickangle(45);
ylabel('%'); title('Freezing percentage')




%% Sleep
Cols = {[0 0 1],[1, 0, 0],[0 1 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]};
X = [1,2,3,4,5,6];
Legends = {'Wake','NREM','REM','N1','N2','N3'};
NoLegends = {'','','','','',''};

Cols2 = {[1, 0, 0],[0 1 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]};
X2 = [1,2,3,4,5];
Legends2 = {'NREM','REM','N1','N2','N3'};

Mouse=[739 740 750 775 849 829 851 856 857];
[OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','accelero','heartrate','heartratevar','respi','ob_low','ob_high','hpc_low','pfc_low');
Mouse=[750];
[OutPutData , Epoch , NameEpoch , OutPutTSD]=MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','masktemperature');

for mouse = 1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    BaselineSleepSess.(Mouse_names{mouse}) = GetBaselineSleepSessions_BM(Mouse(mouse));
    BaselineSleepSess.(Mouse_names{mouse}) = [{BaselineSleepSess.(Mouse_names{mouse}){1}}];
end
cd(BaselineSleepSess.(Mouse_names{mouse}){1})

Mouse=[739, 750, 849 , 829 , 1002 , 1001 , 1095];
[OutPutData3 , Epoch3 , NameEpoch3 , OutPutTSD3]=MeanValuesPhysiologicalParameters_BM(Mouse,'slbs','sleep_ripples','spindles','delta');

for states=1:6
    
    PowerRatioHPC(states,:)=sum(squeeze(abs(OutPutData2.hpc_low.raw(:,states,65:131)))')./sum(squeeze(abs(OutPutData2.hpc_low.raw(:,states,1:end)))');
    PowerRatioBulb(states,:)=sum(squeeze(abs(OutPutData.ob_low.raw(:,states,25:65)))')./sum(squeeze(abs(OutPutData.ob_low.raw(:,states,1:end)))');
    PowerRatioPFC(states,:)=sum(squeeze(abs(OutPutData2.pfc_low.raw(:,states,25:65)))')./sum(squeeze(abs(OutPutData2.pfc_low.raw(:,states,1:end)))');
    PowerRatioHighOB(states,:)=sum(squeeze(abs(OutPutData.ob_high.raw(:,states,9:25)))')./sum(squeeze(abs(OutPutData.ob_high.raw(:,states,1:end)))');
    
    [PowerMaxHPC(states,:) , FreqMaxHPC(states,:)]=max(squeeze(abs(OutPutData2.hpc_low.raw(:,states,65:131)))');
    [PowerMaxBulb(states,:) , FreqMaxBulb(states,:)]=max(squeeze(abs(OutPutData.ob_low.raw(:,states,25:65)))');
    [PowerMaxPFC(states,:) , FreqMaxPFC(states,:)]=max(squeeze(abs(OutPutData2.pfc_low.raw(:,states,25:65)))');
    [PowerMaxHighOB(states,:) , FreqMaxHighOB(states,:)]=max(squeeze(abs(OutPutData.ob_high.raw(:,states,9:25)))');
    
end

OutPutData.masktemperature(:,[2:7]) = OutPutData.masktemperature(:,[2:7]) - OutPutData.masktemperature(:,1);
OutPutData.masktemperature(7,5)=NaN;

% Physio
figure
subplot(241)
MakeSpreadAndBoxPlot2_SB(OutPutData.accelero(:,2:7),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Movement quantity (A.U.)'); title('Movement')
subplot(245)
MakeSpreadAndBoxPlot2_SB(OutPutData.accelero(:,3:7),Cols2,X2,Legends2,'showpoints',0,'paired',1); makepretty; xtickangle(45);
subplot(142)
MakeSpreadAndBoxPlot2_SB(OutPutData.heartrate(:,2:7),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Frequency (Hz)'); title('Heart rate')
% subplot(153)
% MakeSpreadAndBoxPlot2_SB(OutPutData.heartratevar,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
% ylabel('Variability'); title('Heart rate variability')
subplot(143)
MakeSpreadAndBoxPlot2_SB(OutPutData.respi(:,2:7),Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Frequency (Hz)');  title('Respiratory rate')
subplot(144)
MakeSpreadAndBoxPlot2_SB(OutPutData.masktemperature(:,2:7) ,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('Normalized temperature (°C)');  title('Temperature')

% Ration of interest power
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB(PowerRatioHPC',Cols,X,NoLegends,'showpoints',0,'paired',1); 
ylabel('Power (A.U.)'); title('Hippocampus, theta band')
subplot(222)
MakeSpreadAndBoxPlot2_SB(PowerRatioBulb',Cols,X,NoLegends,'showpoints',0,'paired',1); 
title('Bulb, delta band')
subplot(223)
MakeSpreadAndBoxPlot2_SB(PowerRatioPFC',Cols,X,Legends,'showpoints',0,'paired',1); xtickangle(45);
title('PFC, delta band'); ylabel('Power (A.U.)')
subplot(224)
MakeSpreadAndBoxPlot2_SB(PowerRatioHighOB',Cols,X,Legends,'showpoints',0,'paired',1); xtickangle(45);
title('High Bulb, gamma band')

a=suptitle('Ratio of mean spectrum power, baselinesleep, n=9'); a.FontSize=20;

% Max power
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB(PowerMaxHPC([1 3 4],:)',{[0 0 1],[0 1 0],[1, 0.8, 0.8]},[1,2,3],{'Wake','REM','N1'},'showpoints',0,'paired',1); 
ylabel('Power (A.U.)'); title('Hippocampus')
subplot(222)
MakeSpreadAndBoxPlot2_SB(PowerMaxBulb(2:end,:)',{[1, 0, 0],[0 1 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]},[1,2,3,4,5], {'NREM','REM','N1','N2','N3'},'showpoints',0,'paired',1); 
title('Bulb')
subplot(223)
MakeSpreadAndBoxPlot2_SB(PowerMaxPFC([2 4 5 6],:)',{[1, 0, 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]},[1,2,3,4],{'NREM','N1','N2','N3'},'showpoints',0,'paired',1); xtickangle(45);
title('PFC'); ylabel('Power (A.U.)')
subplot(224)
MakeSpreadAndBoxPlot2_SB(PowerMaxHighOB([1 3],:)',{[0 0 1],[0 1 0]},[1,2],{'Wake','REM'},'showpoints',0,'paired',1); xtickangle(45);
title('High Bulb')

a=suptitle('Mean spectrum maximums, baselinesleep, n=9'); a.FontSize=20;


% Frequency where mean spectrum is max
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB(Spectro{3}(OutPutData2.hpc_low.max_freq(:,[1 3 4])), {[0 0 1],[0 1 0],[1, 0.8, 0.8]},[1,2,3],{'Wake','REM','N1'},'showpoints',0,'paired',1); 
ylabel('Frequency (Hz)'); title('Hippocampus')
subplot(222)
MakeSpreadAndBoxPlot2_SB(Spectro{3}(OutPutData.ob_low.max_freq(:,2:end)),{[1, 0, 0],[0 1 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]},[1,2,3,4,5], {'NREM','REM','N1','N2','N3'},'showpoints',0,'paired',1); 
title('Bulb')
subplot(223)
MakeSpreadAndBoxPlot2_SB(Spectro{3}(OutPutData2.pfc_low.max_freq(:,[2 4 5 6])),{[1, 0, 0],[1, 0.8, 0.8],[1, 0.4, 0.4],[0.8, 0, 0]},[1,2,3,4],{'NREM','N1','N2','N3'},'showpoints',0,'paired',1); 
title('PFC'); ylabel('Frequency (Hz)') 
subplot(224); load('B_High_Spectrum.mat')
MakeSpreadAndBoxPlot2_SB(Spectro{3}(OutPutData.ob_high.max_freq(:,[1 3])),{[0 0 1],[0 1 0]},[1,2],{'Wake','REM'},'showpoints',0,'paired',1); 
title('High OB')

a=suptitle('Frequency of mean spectrum maximums, baselinesleep, n=9'); a.FontSize=20;


plot(Spectro{3},squeeze(nanmean(OutPutData2.hpc_low.raw(:,3,:))))
hold on
bar(Spectro{3}([65:131]) , squeeze(nanmean(OutPutData2.hpc_low.raw(:,3,65:131))))
bar(Spectro{3}([1:65 131:end]) , squeeze(nanmean(OutPutData2.hpc_low.raw(:,3,[1:65 131:end]))))
makepretty
a=plot(7.172,1.105e5,'or'); a.LineWidth=60;
ylabel('Power (A.U.)')
legend('Mean spectrum','A1','A2','Maximum')
xlim([0 15]); xlabel('Frequency (Hz)')


subplot(122); load('B_high_Spectrum.mat')
Conf_Inter=nanstd(squeeze(OutPutData.ob_high.norm(:,1,:)))/sqrt(size(squeeze(OutPutData.ob_high.norm(:,1,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(OutPutData.ob_high.norm(:,1,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-b',1); hold on;
Conf_Inter=nanstd(squeeze(OutPutData.ob_high.norm(:,2,:)))/sqrt(size(squeeze(OutPutData.ob_high.norm(:,2,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(OutPutData.ob_high.norm(:,2,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-r',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--r'); a.LineWidth=2;
Conf_Inter=nanstd(squeeze(OutPutData.ob_high.norm(:,3,:)))/sqrt(size(squeeze(OutPutData.ob_high.norm(:,3,:)),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(squeeze(OutPutData.ob_high.norm(:,3,:)));
shadedErrorBar(Spectro{3} , Mean_All_Sp/max(Mean_All_Sp(16:end)) , Conf_Inter,'-g',1); hold on;
[u,v]=max(Mean_All_Sp(16:end)); a=vline(Spectro{3}(v+15),'--g'); a.LineWidth=2;makepretty
xlabel('Frequency (Hz)')
xlim([20 100]); ylim([-0.5 1.6])
ylabel('Power (A.U)')

subplot(122)
plot(nanmean(squeeze(OutPutData.ob_high.norm(:,1,:)))); hold on
plot(nanmean(squeeze(OutPutData.ob_high.norm(:,2,:)))); hold on
plot(nanmean(squeeze(OutPutData.ob_high.norm(:,3,:)))); hold on

% NREM substages
figure
subplot(221)
MakeSpreadAndBoxPlot2_SB(OutPutData3.sleep_ripples,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('ripples/sec'); title('Ripples density'); ylim([-0.05 0.6])
subplot(222)
MakeSpreadAndBoxPlot2_SB(OutPutData3.spindles,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('spindles/sec'); title('Spindles density')
subplot(223)
MakeSpreadAndBoxPlot2_SB(OutPutData3.delta.proportion*100,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('%'); title('Delta percentage')
subplot(224)
MakeSpreadAndBoxPlot2_SB(OutPutData3.delta.density,Cols,X,Legends,'showpoints',0,'paired',1); makepretty; xtickangle(45);
ylabel('delta/sec'); title('Delta density')

a=suptitle('Sleep events, baselinesleep, n=7'); a.FontSize=20;





