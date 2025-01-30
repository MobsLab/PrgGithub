clear all, close all
SessNames={'EPM','Habituation' 'TestPre' 'UMazeCond' 'TestPost' 'Extinction',...
    'SoundHab' 'SoundCond' 'SoundTest','HabituationNight' ,...
    'TestPreNight' 'UMazeCondNight'  'TestPostNight' 'ExtinctionNight'};
a=1;
mousenumber=509;
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse==mousenumber
                cd(Dir.path{d}{dd})
                clear MovAcctsd
                load('behavResources.mat','MovAcctsd')
                try MovAcctsd;
                catch
                    MakeData_Accelero
                    load('behavResources.mat','MovAcctsd')
                end
                RemMovAcctsd{a}=MovAcctsd; 
                a=a+1;
            end
        end
    end
end

smoofact_Acc=30;
thtps_immob=2;
th_immob_Acc=1e7;
clf
for k=1:size(RemMovAcctsd,2)
    subplot(4,5,k)
    NewMovAcctsd=tsd(Range(RemMovAcctsd{k}),runmean(Data(RemMovAcctsd{k}),smoofact_Acc));
    plot(Range(NewMovAcctsd),Data(NewMovAcctsd)), hold on
    FreezeEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
    FreezeEpoch=mergeCloseIntervals(FreezeEpoch,0.5*1e4);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,thtps_immob*1e4);
    if not(isempty(Start(FreezeEpoch)))
        plot(Range(Restrict(NewMovAcctsd,FreezeEpoch)),Data(Restrict(NewMovAcctsd,FreezeEpoch)),'c')
    end
    line(xlim,[1 1]*th_immob_Acc,'color','r')
    ylim([0 1*1e8])
    pause(0.5)
end

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            if Dir.ExpeInfo{d}{dd}.nmouse==mousenumber
                cd(Dir.path{d}{dd})
                clear MovAcctsd FreezeAccEpoch
                load('behavResources.mat','MovAcctsd')
                NewMovAcctsd=tsd(Range(MovAcctsd),runmean(Data(MovAcctsd),smoofact_Acc));
                FreezeAccEpoch=thresholdIntervals(NewMovAcctsd,th_immob_Acc,'Direction','Below');
                FreezeAccEpoch=mergeCloseIntervals(FreezeAccEpoch,0.3*1e4);
                FreezeAccEpoch=dropShortIntervals(FreezeAccEpoch,thtps_immob*1e4);
                save('behavResources.mat','smoofact_Acc','th_immob_Acc','FreezeAccEpoch','-append')
            end
        end
    end
end

