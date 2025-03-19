clear all

Folder = FolderNames_UmazeSleepPrePost_RibInhib_SB;
Drug_Group={'RipControl','RipInhib',};
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {[0.6 0.6 0.6],[0.8 0.2 0.2]};
SpeedLims = logspace(log10(0.1),log10(10),10);
SpeedLims(1) = 0;

clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for sess=1:2
        for mouse=1:length(Folder.(Drug_Group{group}).(Session_type{sess}))
            ekgok = 0;
            breathok = 0;
            cd(Folder.(Drug_Group{group}).(Session_type{sess}){mouse})
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            Wake = Wake - TotalNoiseEpoch;
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            Tot = or(Wake,or(SWSEpoch,REMEpoch));
            
            
            if sess == 1
                TotEpoch = intervalSet(0,3600*2*1e4);
            else
                % Just first hour
                TotEpoch = intervalSet(0,3600*1e4);
            end
            
            %% Get speed
            load('behavResources_SB.mat')
            
            %% HR, HRVar and breathing during SWS, REM and different speeds
            clear EKG HRVar_ms HRate_ms
            if exist('HeartBeatInfo.mat')
                load('HeartBeatInfo.mat')
                ekgok = 1;
                HRate_ms = EKG.HBRate;
                rg = Range(EKG.HBRate);
                dt = movstd(Data(EKG.HBRate),5);
                HRVar_ms = tsd(rg,dt);
                
            end
            clear LocalFreq
            if exist('InstFreqAndPhase_B.mat')
                load('InstFreqAndPhase_B.mat', 'LocalFreq')
                breathok = 1;
            end
            
            if ekgok
                HR.SWS{sess}{group}(mouse) = nanmean(Data(Restrict(HRate_ms,and(SWSEpoch,TotEpoch))));
                HR.REM{sess}{group}(mouse) = nanmean(Data(Restrict(HRate_ms,and(REMEpoch,TotEpoch))));
                HR.Wake{sess}{group}(mouse) = nanmean(Data(Restrict(HRate_ms,and(Wake,TotEpoch))));
                
                HRVar.SWS{sess}{group}(mouse) = nanmean(Data(Restrict(HRVar_ms,and(SWSEpoch,TotEpoch))));
                HRVar.REM{sess}{group}(mouse) = nanmean(Data(Restrict(HRVar_ms,and(REMEpoch,TotEpoch))));
                HRVar.Wake{sess}{group}(mouse) = nanmean(Data(Restrict(HRVar_ms,and(Wake,TotEpoch))));
            end
            if breathok
                Resp_WV.SWS{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.WV,and(SWSEpoch,TotEpoch))));
                Resp_WV.REM{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.WV,and(REMEpoch,TotEpoch))));
                Resp_WV.Wake{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.WV,and(Wake,TotEpoch))));
                
                Resp_PT.SWS{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.PT,and(SWSEpoch,TotEpoch))));
                Resp_PT.REM{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.PT,and(REMEpoch,TotEpoch))));
                Resp_PT.Wake{sess}{group}(mouse) = nanmean(Data(Restrict(LocalFreq.PT,and(Wake,TotEpoch))));
            end
            
            for ii = 1:length(SpeedLims)-1
                MovEpoch = thresholdIntervals(Behav.Vtsd,SpeedLims(ii),'Direction','Above');
                MovEpoch = and(Wake,and(MovEpoch,thresholdIntervals(Behav.Vtsd,SpeedLims(ii+1),'Direction','Below')));
                if ekgok
                    HR.WakeBySpeed{sess}{group}(mouse,ii) =  nanmean(Data(Restrict(HRate_ms,and(MovEpoch,TotEpoch))));
                    HRVar.WakeBySpeed{sess}{group}(mouse,ii) =  nanmean(Data(Restrict(HRVar_ms,and(MovEpoch,TotEpoch))));
                end
                if breathok
                    Resp_WV.WakeBySpeed{sess}{group}(mouse,ii) =  nanmean(Data(Restrict(LocalFreq.WV,and(MovEpoch,TotEpoch))));
                    Resp_PT.WakeBySpeed{sess}{group}(mouse,ii) =  nanmean(Data(Restrict(LocalFreq.PT,and(MovEpoch,TotEpoch))));
                end
            end
            
            if ekgok==0
                HR.SWS{sess}{group}(mouse) = NaN;
                HR.REM{sess}{group}(mouse) = NaN;
                HR.Wake{sess}{group}(mouse) = NaN;
                
                HRVar.SWS{sess}{group}(mouse) = NaN;
                HRVar.REM{sess}{group}(mouse) = NaN;
                HRVar.Wake{sess}{group}(mouse) = NaN;
                for ii = 1:length(SpeedLims)-1
                    HR.WakeBySpeed{sess}{group}(mouse,ii) =  NaN;
                    HRVar.WakeBySpeed{sess}{group}(mouse,ii) =  NaN;
                end
            end
            
             
            if breathok==0
                Resp_WV.SWS{sess}{group}(mouse) = NaN;
                Resp_WV.REM{sess}{group}(mouse) = NaN;
                Resp_WV.Wake{sess}{group}(mouse) = NaN;
                
                Resp_PT.SWS{sess}{group}(mouse) = NaN;
                Resp_PT.REM{sess}{group}(mouse) = NaN;
                Resp_PT.Wake{sess}{group}(mouse) = NaN;
                for ii = 1:length(SpeedLims)-1
                    Resp_WV.WakeBySpeed{sess}{group}(mouse,ii) =  NaN;
                    Resp_PT.WakeBySpeed{sess}{group}(mouse,ii) =  NaN;
                end
            end
                        
        end
    end
end


%% Figures
figure
for sess = 1:2
subplot(2,4,(sess-1)*4+1)
MakeSpreadAndBoxPlot_SB(HR.SWS{sess},Cols,[1,2],Drug_Group,1,0)
ylabel('HR'),xtickangle(45)
[p,h] = ranksum(HR.SWS{sess}{1},HR.SWS{sess}{2});
sigstar({[1,2]},p)
title('SWS')
ylim([7 11.5])

subplot(2,4,(sess-1)*4+2)
MakeSpreadAndBoxPlot_SB(HR.REM{sess},Cols,[1,2],Drug_Group,1,0)
ylabel('HR'),xtickangle(45)
[p,h] = ranksum(HR.REM{sess}{1},HR.REM{sess}{2});
sigstar({[1,2]},p)
title('REM')
ylim([7 11.5])

subplot(2,4,(sess-1)*4+[3:4])
hold on
plot(SpeedLims(1:end-1),HR.WakeBySpeed{sess}{1},'k')
plot(SpeedLims(1:end-1),HR.WakeBySpeed{sess}{2},'r')

errorbar(SpeedLims(1:end-1),nanmean(HR.WakeBySpeed{sess}{1}),stdError(HR.WakeBySpeed{sess}{1}),'k','linewidth',3)
hold on
errorbar(SpeedLims(1:end-1),nanmean(HR.WakeBySpeed{sess}{2}),stdError(HR.WakeBySpeed{sess}{2}),'r','linewidth',3)
xlabel('Speed')
ylabel('HR'),makepretty
title('Wake by speed')
ylim([7 11.5])


end




figure
for sess = 1:2
subplot(2,4,(sess-1)*4+1)
MakeSpreadAndBoxPlot_SB(HRVar.SWS{sess},Cols,[1,2],Drug_Group,1,0)
ylabel('HRVar'),xtickangle(45)
[p,h] = ranksum(HRVar.SWS{sess}{1},HRVar.SWS{sess}{2});
sigstar({[1,2]},p)
title('SWS')
ylim([0.04 0.25])

subplot(2,4,(sess-1)*4+2)
MakeSpreadAndBoxPlot_SB(HRVar.REM{sess},Cols,[1,2],Drug_Group,1,0)
ylabel('HRVar'),xtickangle(45)
[p,h] = ranksum(HRVar.REM{sess}{1},HRVar.REM{sess}{2});
sigstar({[1,2]},p)
title('REM')
ylim([0.04 0.25])

subplot(2,4,(sess-1)*4+[3:4])
hold on
plot(SpeedLims(1:end-1),HRVar.WakeBySpeed{sess}{1},'k')
plot(SpeedLims(1:end-1),HRVar.WakeBySpeed{sess}{2},'r')

errorbar(SpeedLims(1:end-1),nanmean(HRVar.WakeBySpeed{sess}{1}),stdError(HRVar.WakeBySpeed{sess}{1}),'k','linewidth',3)
hold on
errorbar(SpeedLims(1:end-1),nanmean(HRVar.WakeBySpeed{sess}{2}),stdError(HRVar.WakeBySpeed{sess}{2}),'r','linewidth',3)
xlabel('Speed')
ylabel('HRVar'),makepretty
title('Wake by speed')
ylim([0.04 0.25])

end
% 
% 
% figure
% for sess = 1:2
% subplot(2,4,(sess-1)*4+1)
% MakeSpreadAndBoxPlot_SB(Resp_PT.SWS{sess},Cols,[1,2],Drug_Group,1,0)
% ylabel('Resp_PT'),xtickangle(45)
% [p,h] = ranksum(Resp_PT.SWS{sess}{1},Resp_PT.SWS{sess}{2});
% sigstar({[1,2]},p)
% title('SWS')
% 
% subplot(2,4,(sess-1)*4+2)
% MakeSpreadAndBoxPlot_SB(Resp_PT.REM{sess},Cols,[1,2],Drug_Group,1,0)
% ylabel('Resp_PT'),xtickangle(45)
% [p,h] = ranksum(Resp_PT.REM{sess}{1},Resp_PT.REM{sess}{2});
% sigstar({[1,2]},p)
% title('REM')
% 
% subplot(2,4,(sess-1)*4+[3:4])
% errorbar(SpeedLims(1:end-1),nanmean(Resp_PT.WakeBySpeed{sess}{1}),stdError(Resp_PT.WakeBySpeed{sess}{1}),'k')
% hold on
% errorbar(SpeedLims(1:end-1),nanmean(Resp_PT.WakeBySpeed{sess}{2}),stdError(Resp_PT.WakeBySpeed{sess}{2}),'r')
% xlabel('Speed')
% ylabel('Resp_PT'),makepretty
% title('Wake by speed')
% 
% 
% end