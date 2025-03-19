clear all
SpeedThresh=3; % cm/s


% SessNames={'EPM','Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction',...
%     'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest','HabituationNight' 'SleepPreNight',...
%     'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight'};
SessNames={'UMazeCondNight'};
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
        disp(d)
        
        AllVals.Safe.WV{d}=[];         AllVals.Safe.PT{d}=[];  AllVals.Safe.Spec{d}=[];
        AllVals.Shock.WV{d}=[];         AllVals.Shock.PT{d}=[];  AllVals.Shock.Spec{d}=[];
        AllVals.Run.WV{d}=[];         AllVals.Run.PT{d}=[];   AllVals.Run.Spec{d}=[];
        
        for dd=1:length(Dir.path{d})
            
            cd(Dir.path{d}{dd})
            clear SleepyEpoch
            load('InstFreqAndPhase_B.mat','LocalFreq')
            load('behavResources_SB.mat')
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});

            

            %% UMaze
            %% On the safe side
            LitEp=and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
            AllVals.Safe.WV{d}=[AllVals.Safe.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.Safe.PT{d}=[AllVals.Safe.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            AllVals.Safe.Spec{d}=[AllVals.Safe.Spec{d};mean(Data(Restrict(Sptsd,LitEp)))];
            
            %% On the shock side
            LitEp=and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
            AllVals.Shock.WV{d}=[AllVals.Shock.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.Shock.PT{d}=[AllVals.Shock.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            AllVals.Shock.Spec{d}=[AllVals.Shock.Spec{d};mean(Data(Restrict(Sptsd,LitEp)))];

            %% running Epoch
            dt=median(diff(Range(Behav.Vtsd,'s')));
            tps=Range(Behav.Xtsd);
            RunSpeed=tsd(tps(1:end-1),runmean((abs(diff(Data(Behav.Xtsd)))+abs(diff(Data(Behav.Ytsd))))./diff(Range(Behav.Xtsd,'s')),3));
            RunningEpoch=thresholdIntervals(RunSpeed,SpeedThresh,'Direction','Above');
            RunningEpoch=mergeCloseIntervals(RunningEpoch,1*1e4);
            RunningEpoch=dropShortIntervals(RunningEpoch,2*1e4);
            
            LitEp=RunningEpoch-RemovEpoch;
            AllVals.Run.WV{d}=[AllVals.Run.WV{d};(Data(Restrict(LocalFreq.WV,LitEp)))];
            AllVals.Run.PT{d}=[AllVals.Run.PT{d};(Data(Restrict(LocalFreq.PT,LitEp)))];
            AllVals.Run.Spec{d}=[AllVals.Run.Spec{d};mean(Data(Restrict(Sptsd,LitEp)))];

        end
    end
end

for mm=1:6
    RunDat(mm,:)=nanmean(AllVals.Run.Spec{mm});
    SafeDat(mm,:)= nanmean(AllVals.Safe.Spec{mm});
    ShockDat(mm,:)=nanmean(AllVals.Shock.Spec{mm});
end

figure
shadedErrorBar(Spectro{3},nanmean(RunDat),stdError(RunDat),'k'), hold on
shadedErrorBar(Spectro{3},nanmean(SafeDat),stdError(SafeDat),'b')
shadedErrorBar(Spectro{3},nanmean(ShockDat),stdError(ShockDat),'r')
box off
line([3 3],ylim,'color','k')
line([6 6],ylim,'color','k')
xlim([0 15])