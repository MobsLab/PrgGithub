clear all
SessionNames = {'Habituation' 'HabituationNight' 'Habituation_EyeShockTempProt'...
    'Habituation24HPre_EyeShock' 'Habituation_EyeShock' 'Habituation24HPre_PreDrug' 'Habituation_PreDrug'};
Colors = {'b','k','b','b','c','b','c'};
clf
Vals = [3:0.25:15];
MouseToAvoid=[688,778]; % mice with noisy data to exclude
for ss = 1:length(SessionNames)
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    for d=1:length(Dir.path)
        Hist_EKG_Explo{ss}(d,:) = nan(1,49);
        for dd=1
            cd(Dir.path{d}{dd})
            if exist([cd filesep 'HeartBeatInfo.mat'])>0
                disp(Dir.path{d}{dd})
                load('HeartBeatInfo.mat')
                [Y,X] = hist(Data(EKG.HBRate),Vals);
                Hist_EKG_Explo{ss}(d,:) = Y/sum(Y);
            end
        end
    end
end


SessionNames = {'SleepPre_PreDrug'};

for ss = 1:length(SessionNames)
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    for d=1:length(Dir.path)
        for dd=1
            cd(Dir.path{d}{dd})
            Hist_EKG_NREM{ss}(d,:) = nan(1,49);
            Hist_EKG_Wake{ss}(d,:) = nan(1,49);
            Hist_EKG_REM{ss}(d,:) = nan(1,49);
            if exist([cd filesep 'HeartBeatInfo.mat'])>0
                disp(Dir.path{d}{dd})
                load('HeartBeatInfo.mat')
                load('StateEpochSB.mat','SWSEpoch','REMEpoch','Wake')
                [Y,X] = hist(Data(Restrict(EKG.HBRate,SWSEpoch)),Vals);
                Hist_EKG_NREM{ss}(d,:) = Y/sum(Y);
                %                 plot(Vals,runmean(Y/sum(Y),2),'color','b','linewidth',2), hold on
                [Y,X] = hist(Data(Restrict(EKG.HBRate,REMEpoch)),Vals);
                Hist_EKG_REM{ss}(d,:) = Y/sum(Y);
                %                 plot(Vals,runmean(Y/sum(Y),2),'color','r','linewidth',2), hold on
                [Y,X] = hist(Data(Restrict(EKG.HBRate,Wake)),Vals);
                Hist_EKG_Wake{ss}(d,:) = Y/sum(Y);
                %                 plot(Vals,runmean(Y/sum(Y),2),'color','k','linewidth',2), hold on
            end
        end
    end
end

SessionNames = {'SoundTest'};

for ss = 1:length(SessionNames)
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    for d=1:length(Dir.path)
        for dd=1
            cd(Dir.path{d}{dd})
%             Hist_EKG_NREM{ss}(d,:) = nan(1,49);
%             Hist_EKG_Wake{ss}(d,:) = nan(1,49);
%             Hist_EKG_REM{ss}(d,:) = nan(1,49);
            if exist([cd filesep 'HeartBeatInfo.mat'])>0
                disp(Dir.path{d}{dd})
                load('HeartBeatInfo.mat')
                load('behavResources_SB.mat')
                CSPlusEpoch = intervalSet(TTLInfo.CSPlusTimes,TTLInfo.CSPlusTimes+10*1e4)-Behav.FreezeAccEpoch;
                [Y,X] = hist(Data(Restrict(EKG.HBRate,CSPlusEpoch)),Vals);
                Hist_EKG_CSPlus{ss}(d,:) = Y/sum(Y);
                [Y,X] = hist(Data(Restrict(EKG.HBRate,Behav.FreezeAccEpoch)),Vals);
                Hist_EKG_Freeze{ss}(d,:) = Y/sum(Y);
                [Y,X] = hist(Data(Restrict(EKG.HBRate,intervalSet(0,200*1e4))),Vals);
                Hist_EKG_SoundExplo{ss}(d,:) = Y/sum(Y);

            end
        end
    end
end

SessionNames = {'EPM'};

for ss = 1:length(SessionNames)
    Dir=PathForExperimentsEmbReact(SessionNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    for d=1:length(Dir.path)
        for dd=1
            cd(Dir.path{d}{dd})
            Hist_EKG_EPM{ss}(d,:) = nan(1,49);
            if exist([cd filesep 'HeartBeatInfo.mat'])>0
                disp(Dir.path{d}{dd})
                load('HeartBeatInfo.mat')
                Hist_EKG_EPM{ss}(d,:) = Y/sum(Y);

            end
        end
    end
end


figure
clf
subplot(311)
plot(Vals,nanmean(Hist_EKG_SoundExplo{1}),'linewidth',3,'color',[0 0.5 0.5])
hold on
plot(Vals,nanmean(Hist_EKG_CSPlus{1}),'linewidth',3,'color',[1 0 0])
plot(Vals,nanmean(Hist_EKG_Freeze{1}),'linewidth',3,'color',[0.8 0.5 0.5])
ylim([0 0.2])
line([9.1 9.1],ylim,'color','k','linewidth',2)
text(9.2,0.18,'PreCS-Tovote,2005')
line([12.5 12.5],ylim,'color','k','linewidth',2)
text(12.6,0.18,'PostCS-Tovote,2005')
legend('PreSound','CSPlus','Freeze')
line([10 10],ylim,'color','k','linewidth',2)
text(10.1,0.15,'PreCS-Stiedl,1997')
line([13.3 13.3],ylim,'color','k','linewidth',2)
text(13.4,0.15,'PostCS-Stiedl,1997')


subplot(312)
plot(Vals,nanmean(Hist_EKG_Explo{6}),'linewidth',3,'color',[0 0 1])
hold on
plot(Vals,nanmean(Hist_EKG_Explo{7}),'linewidth',3,'color',[0.6 0.6 0.8])
legend('Explo1','Explo2')

subplot(313)
plot(Vals,nanmean(Hist_EKG_Wake{1}),'linewidth',3,'color','k')
hold on
plot(Vals,nanmean(Hist_EKG_REM{1}),'linewidth',3,'color','r')
plot(Vals,nanmean(Hist_EKG_NREM{1}),'linewidth',3,'color','b')
ylim([0 0.17])
line([10 10],ylim,'color','r','linewidth',2)
text(10.1,0.15,'REM/NREM-Campen,2002')
legend('Wake-Home','REM-Home','NREM-Home')
xlim([4 16])

