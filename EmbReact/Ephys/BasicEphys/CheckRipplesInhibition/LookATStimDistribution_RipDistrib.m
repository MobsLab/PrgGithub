clear all
GetEmbReactMiceFolderList_BM

%% Ripples inhibition
clear Mouse
Mouse.Inhib=[1266 1268 1269 1305 1349 1350 1351 1352];
Mouse.Ctrl=[41266,41268,41269,41305,41349,41350,41351,41352];
Groups = {'Inhib','Ctrl'};
for gr = 1:length(Groups)
    for mm =1:length(Mouse.(Groups{gr}))
        for ss = 1:length(CondSess.(['M' num2str(Mouse.(Groups{gr})(mm))]))
            cd(CondSess.(['M' num2str(Mouse.(Groups{gr})(mm))]){ss})
            
            load('behavResources_SB.mat')
            if length(Start(TTLInfo.VHC_Stim_Epoch))>100
                load('ChannelsToAnalyse/dHPC_rip.mat')
                load(['LFPData/LFP' num2str(channel),'.mat'])
                clf
                plot(Range(LFP,'s'),Data(LFP))
                hold on
                hold on,plot(Start(TTLInfo.VHC_Stim_Epoch,'s'),1000,'*')
                title(CondSess.(['M' num2str(Mouse.(Groups{gr})(mm))]){ss})
                keyboard
                
            end
            StimNum{gr}(mm,ss) = length(Start(TTLInfo.VHC_Stim_Epoch));
            StimNumNoSk{gr}(mm,ss) = length(Start(TTLInfo.VHC_Stim_Epoch)) -length(Start(TTLInfo.StimEpoch));
            SfEpoch = or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{4});
            SkEpoch = or(Behav.ZoneEpoch{1},Behav.ZoneEpoch{3});
            
            StimNumFz{gr}(mm,ss) = length(Start(and(TTLInfo.VHC_Stim_Epoch,Behav.FreezeAccEpoch)));
            StimNumSk{gr}(mm,ss) = length(Start(and(TTLInfo.VHC_Stim_Epoch,SkEpoch)));
            StimNumSf{gr}(mm,ss) = length(Start(and(TTLInfo.VHC_Stim_Epoch,SfEpoch)));
            StimNumSfFz{gr}(mm,ss) = length(Start(and(TTLInfo.VHC_Stim_Epoch,and(SfEpoch,Behav.FreezeAccEpoch))));
            StimNumSkFz{gr}(mm,ss) = length(Start(and(TTLInfo.VHC_Stim_Epoch,and(SkEpoch,Behav.FreezeAccEpoch))));
            TotalFz{gr}(mm,ss) = nansum(Stop(Behav.FreezeAccEpoch,'s')-Start(Behav.FreezeAccEpoch,'s'));
            TotalSkFz{gr}(mm,ss) = nansum(Stop(and(SkEpoch,Behav.FreezeAccEpoch),'s')-Start(and(SkEpoch,Behav.FreezeAccEpoch),'s'));
            TotalSfFz{gr}(mm,ss) = nansum(Stop(and(SfEpoch,Behav.FreezeAccEpoch),'s')-Start(and(SfEpoch,Behav.FreezeAccEpoch),'s'));
            
        end
    end
end

figure
for gr = 1:2
    subplot(2,1,gr)
    nhist({nansum(StimNumSf{gr}')./nansum(StimNum{gr}'),nansum(StimNumFz{gr}')./nansum(StimNum{gr}'),nansum(StimNumSfFz{gr}')./nansum(StimNum{gr}'),...
        nansum(StimNumSkFz{gr}')./nansum(StimNum{gr}')},'samebins')
    xlim([0 1])
    legend('Safe','Fz','SfFz','SkFz')
    xlabel('Prop stims in each state')
    title(Groups{gr})
end


clear SkProp 
for gr = 1:2
    SkProp{gr} = 1-nansum(StimNumNoSk{gr}')./nansum(StimNum{gr}');
end
figure
figure,MakeSpreadAndBoxPlot_SB(SkProp,{[0.3 0.3 0.8],[0.8 0.3 0.5]},1:2,Groups,1)
ylabel('Prop vHPC stims linked to Shock')



clear SkFz SfFz 
for gr = 1:2
    SkFz{gr} = nansum(TotalSkFz{gr}');
    SfFz{gr} = nansum(TotalSfFz{gr}');
end
figure
subplot(121)
MakeSpreadAndBoxPlot_SB(SfFz,{[0.3 0.3 0.8],[0.8 0.3 0.5]},1:2,Groups,1)
ylabel('Total time freezing - shock')
ylim([0 1500])
subplot(122)
MakeSpreadAndBoxPlot_SB(SkFz,{[0.3 0.3 0.8],[0.8 0.3 0.5]},1:2,Groups,1)
ylabel('Total time freezing - safe')
ylim([0 1500])
