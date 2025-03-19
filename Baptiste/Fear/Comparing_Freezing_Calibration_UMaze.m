%% Comparison freezing prop UMaze and calib

SessNames={'Calibration_Eyeshock'};

Dir=PathForExperimentsEmbReact(SessNames{1});

for d=1:length(Dir.path)-3
    Mouse_names{d}= ['M' num2str(Dir.ExpeInfo{1, d}{1, 1}.nmouse)];
    Mouse(d)=Dir.ExpeInfo{1, d}{1, 1}.nmouse;
end

for mouse =1:length(Mouse)

    length_to_use = length(Dir.path{1, mouse});
    CalibSess.(Mouse_names{mouse}){1} = Dir.path{1, mouse}{1, length_to_use}  ;

end
CalibSess.M779{1} = '/media/nas4/ProjetEmbReact/Mouse779/20180730/ProjectEmbReact_M779_20180730_Calibration_3V_200ms';
CalibSess.M688{1} = '/media/nas4/ProjetEmbReact/Mouse688/20180207/ProjectEmbReact_M688_20180207_Calibration_2,5V_2000ms';
CalibSess.M1170{1} = '/media/nas6/ProjetEmbReact/Mouse1170/20210204/ProjectEmbReact_M1170_20210204_Calibration_3V_200ms';
CalibSess.M566{1} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse566/20170727/ProjectEmbReact_M566_20170727_Calibration_3V_2000ms';
CalibSess.M666{1} = '/media/nas4/ProjetEmbReact/Mouse666/20171226/ProjectEmbReact_M666_20171226_Calibration_2,5V_2000ms';


cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
for mouse =1:length(Mouse)
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Ext')))));
end


for mouse =1:length(Mouse)

    Freeze_Epoch.Calib.(Mouse_names{mouse})=ConcatenateDataFromFolders_BM(CalibSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch_noSleepy');
    Freeze_Epoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');
    Freeze_Epoch.Ext.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(ExtSess.(Mouse_names{mouse}),'Epoch','epochname','freezeepoch');

    Freeze_Prop.Calib.(Mouse_names{mouse}) = sum(Stop(Freeze_Epoch.Calib.(Mouse_names{mouse}))-Start(Freeze_Epoch.Calib.(Mouse_names{mouse})))/(max(Range(ConcatenateDataFromFolders_SB(CalibSess.(Mouse_names{mouse}),'accelero'))));
    Freeze_Prop.Cond.(Mouse_names{mouse}) = sum(Stop(Freeze_Epoch.Cond.(Mouse_names{mouse}))-Start(Freeze_Epoch.Cond.(Mouse_names{mouse})))/(max(Range(ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'accelero'))));
    Freeze_Prop.Ext.(Mouse_names{mouse}) = sum(Stop(Freeze_Epoch.Ext.(Mouse_names{mouse}))-Start(Freeze_Epoch.Ext.(Mouse_names{mouse})))/(max(Range(ConcatenateDataFromFolders_SB(ExtSess.(Mouse_names{mouse}),'accelero'))));

    ZoneEpoch.Cond.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(CondSess.(Mouse_names{mouse}),'Epoch','epochname','zoneepoch');
    ShockFreezing.Cond.(Mouse_names{mouse})=and(Freeze_Epoch.Cond.(Mouse_names{mouse}) , ZoneEpoch.Cond.(Mouse_names{mouse}){1});
    ShockFreezing_Prop.Cond.(Mouse_names{mouse})=sum(Stop(ShockFreezing.Cond.(Mouse_names{mouse}))-Start(ShockFreezing.Cond.(Mouse_names{mouse})))/sum(Stop(Freeze_Epoch.Cond.(Mouse_names{mouse}))-Start(Freeze_Epoch.Cond.(Mouse_names{mouse})));
    ShockFreezing_Quantity.Cond.(Mouse_names{mouse})=sum(Stop(ShockFreezing.Cond.(Mouse_names{mouse}))-Start(ShockFreezing.Cond.(Mouse_names{mouse})));
    
    AllFreeze_Prop.Calib(mouse) = Freeze_Prop.Calib.(Mouse_names{mouse});
    AllFreeze_Prop.Cond(mouse) = Freeze_Prop.Cond.(Mouse_names{mouse});
    AllFreeze_Prop.Ext(mouse) = Freeze_Prop.Ext.(Mouse_names{mouse});
    %AllFreeze_Prop.Fear(mouse-12) = Freeze_Prop.Fear.(Mouse_names{mouse});
    
    AllFreeze_Shock_Prop.Cond(mouse) = ShockFreezing_Prop.Cond.(Mouse_names{mouse});
    AllFreeze_Shock_Quantity.Cond(mouse) = ShockFreezing_Quantity.Cond.(Mouse_names{mouse});

    disp(Mouse(mouse))
end
AllFreeze_Prop.Calib(AllFreeze_Prop.Calib==0)=0,01;

figure
plot(AllFreeze_Prop.Cond(1:26),AllFreeze_Prop.Ext(1:26),'.r','MarkerSize',30); hold on
plot(AllFreeze_Prop.Cond(27:end),AllFreeze_Prop.Ext(27:end),'.b','MarkerSize',30)
%xlim([0 3e7]); ylim([0 3e7]); axis square
makepretty
xlabel('Freeze proportion in Cond'); ylabel('Freeze proportion in Ext')
[R1,P1]=corrcoef_BM(AllFreeze_Prop.Cond(1:26),AllFreeze_Prop.Ext(1:26));
[R2,P2]=corrcoef_BM(AllFreeze_Prop.Cond(27:end),AllFreeze_Prop.Ext(27:end));
legend(['R = ' num2str(R1(2,1)) '     P = ' num2str(P1(2,1))],['R = ' num2str(R2(2,1)) '     P = ' num2str(P2(2,1))])

a=suptitle('%Freezing in Ext = f(%Freezing in Cond)'); a.FontSize=20;

figure
plot(AllFreeze_Prop.Cond(1:26),AllFreeze_Prop.Calib(1:26),'.r','MarkerSize',30); hold on
plot(AllFreeze_Prop.Cond(27:end),AllFreeze_Prop.Calib(27:end),'.b','MarkerSize',30)
%xlim([0 3e7]); ylim([0 3e7]); axis square
makepretty
xlabel('Freeze proportion in Cond'); ylabel('Freeze proportion in Calib')
[R1,P1]=corrcoef_BM(AllFreeze_Prop.Cond(1:26),AllFreeze_Prop.Calib(1:26));
[R2,P2]=corrcoef_BM(AllFreeze_Prop.Cond(27:end),AllFreeze_Prop.Calib(27:end));
legend(['R = ' num2str(R1(2,1)) '     P = ' num2str(P1(2,1))],['R = ' num2str(R2(2,1)) '     P = ' num2str(P2(2,1))])

a=suptitle('%Freezing in Calib = f(%Freezing in Cond)'); a.FontSize=20;


figure
plot(AllFreeze_Shock_Prop.Cond(1:26) , AllFreeze_Prop.Calib(1:26),'.r','MarkerSize',30); hold on
plot(AllFreeze_Shock_Prop.Cond(27:end) , AllFreeze_Prop.Calib(27:end),'.b','MarkerSize',30)
%xlim([0 3e7]); ylim([0 3e7]); axis square
makepretty
xlabel('Freeze proportion in Cond'); ylabel('Freeze proportion in Calib')
[R1,P1]=corrcoef_BM(AllFreeze_Shock_Prop.Cond(1:26) , AllFreeze_Prop.Calib(1:26));
[R2,P2]=corrcoef_BM(AllFreeze_Shock_Prop.Cond(27:end) , AllFreeze_Prop.Calib(27:end));
legend(['R = ' num2str(R1(2,1)) '     P = ' num2str(P1(2,1))],['R = ' num2str(R2(2,1)) '     P = ' num2str(P2(2,1))])

a=suptitle('%Freezing in Calib = f(shock freezing proportion in Cond)'); a.FontSize=20;


figure
plot(AllFreeze_Shock_Quantity.Cond(1:26) , AllFreeze_Prop.Calib(1:26),'.r','MarkerSize',30); hold on
plot(AllFreeze_Shock_Quantity.Cond(27:end) , AllFreeze_Prop.Calib(27:end),'.b','MarkerSize',30)
%xlim([0 3e7]); ylim([0 3e7]); axis square
makepretty
xlabel('Freeze proportion in Cond'); ylabel('Freeze proportion in Calib')
[R1,P1]=corrcoef_BM(AllFreeze_Shock_Quantity.Cond(1:26) , AllFreeze_Prop.Calib(1:26));
[R2,P2]=corrcoef_BM(AllFreeze_Shock_Quantity.Cond(27:end) , AllFreeze_Prop.Calib(27:end));
legend(['R = ' num2str(R1(2,1)) '     P = ' num2str(P1(2,1))],['R = ' num2str(R2(2,1)) '     P = ' num2str(P2(2,1))])

a=suptitle('%Freezing in Calib = f(shock freezing time in Cond)'); a.FontSize=20;










figure
bar([AllFreeze_Prop.Calib ; AllFreeze_Prop.Cond; AllFreeze_Prop.Ext]')
xticks([1:44]); xticklabels(Mouse_names(13:end)); xtickangle(45)


for mouse =1:length(Mouse)
    
    cd(CalibSess.(Mouse_names{mouse}){1})
    
    th_immob=0.005;
    thtps_immob=2;
    smoofact=10;
    smoofact_Acc = 30;
    th_immob_Acc = 1.7e7;
    
    if ~exist('behavResources_SB.mat')
        try load('behavResources.mat', 'MovAcctsd')
            a=MovAcctsd;
        catch
            load('behavResources.mat', 'Movtsd')
            MovAcctsd = Movtsd;
        end
        
        NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
        FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
        FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
        FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
        
        Behav.FreezeAccEpoch = FreezeAccEpoch;
        save('behavResources_SB.mat','Behav')
        clear MovAcctsd
    end
end