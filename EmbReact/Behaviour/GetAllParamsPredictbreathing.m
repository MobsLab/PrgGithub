%% Get together all the potentially predictible variables to guess breathing freauencym in 2second bins
clear all
Binsize=3; % s

SessNames={ 'UMazeCond' 'UMazeCondNight'};
for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
    MouseToAvoid=[117,431]; % mice with noisy data to exclude
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        TotTime=0;TotFz=0;TotStims=0;
        MouseName{ss,d}=num2str(Dir.ExpeInfo{d}{1}.nmouse);
        disp(MouseName{ss,d})
        for dd=1:length(Dir.path{d})
            
            cd(Dir.path{d}{dd})
            load('behavResources.mat')
            load('InstFreqAndPhase.mat','LocalFreq')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            if not(isempty(Behav.FreezeAccEpoch))
                Behav.FreezeEpoch=Behav.FreezeAccEpoch;
            end
            Behav.FreezeEpoch=Behav.FreezeEpoch-SleepyEpoch;
            
            SampleSz=median(diff(Range(Behav.Xtsd,'s')));
            BlockDur=ceil(Binsize/SampleSz);
            
            % Position related
            AllParams{dd}.LinDist=DownsInBlocks(Data(Behav.LinearDist),BlockDur);
            AllParams{dd}.XPos=DownsInBlocks(Data(Behav.Xtsd),BlockDur);
            AllParams{dd}.YPos=DownsInBlocks(Data(Behav.Ytsd),BlockDur);
            AllParams{dd}.Speed=DownsInBlocks(Data(Behav.Movtsd),BlockDur);
            AllParams{dd}.PrevSpeed=[NaN,NaN,NaN,[AllParams{dd}.Speed(1:end-3)+AllParams{dd}.Speed(2:end-2)+AllParams{dd}.Speed(3:end-1)]/3]; % average spped over last ^ second
            AllParams{dd}.XDistToPrevPos=[NaN,NaN,abs(AllParams{dd}.XPos(1:end-2)-AllParams{dd}.XPos(3:end))]; % distance to position 4sec ago
            AllParams{dd}.YDistToPrevPos=[NaN,NaN,abs(AllParams{dd}.YPos(1:end-2)-AllParams{dd}.YPos(3:end))]; % distance to position 4sec ago
            
            % Time related
            AllParams{dd}.TrialTime=DownsInBlocks(Range(Behav.Ytsd,'s'),BlockDur);
            AllParams{dd}.TotTime=DownsInBlocks(Range(Behav.Ytsd,'s'),BlockDur)+TotTime;
            TotTime=max(AllParams{dd}.TotTime);
            
            % Freezing related
            temptsd=tsd(AllParams{dd}.TrialTime*1e4,[1:length(AllParams{dd}.TrialTime)]');
            FreezeBins=Data(Restrict(temptsd,Behav.FreezeEpoch));
            AllParams{dd}.IsFreeze=zeros(1,length(AllParams{dd}.TrialTime));AllParams{dd}.IsFreeze(FreezeBins)=1;
            AllParams{dd}.CumFreezeTrial=cumsum(AllParams{dd}.IsFreeze)*Binsize;
            AllParams{dd}.CumFreezeTotal=cumsum(AllParams{dd}.IsFreeze)*Binsize+TotTime;
            TotFz=max(AllParams{dd}.CumFreezeTotal);
            FzStart=Start(Behav.FreezeEpoch,'s');
            FzStop=Stop(Behav.FreezeEpoch,'s');
            AllParams{dd}.TimeToFzStart=nan(1,length(AllParams{dd}.TrialTime));
            AllParams{dd}.TimeToPrevFz=nan(1,length(AllParams{dd}.TrialTime));
            AllParams{dd}.DurPrevEp=nan(1,length(AllParams{dd}.TrialTime));
            for k=1:length(FreezeBins)
                tempDat=AllParams{dd}.TrialTime(FreezeBins(k))-FzStart;
                tempDat(tempDat<0)=[];
                [val,ind]=min(tempDat);
                AllParams{dd}.TimeToFzStart(FreezeBins(k))=val;
                tempDat(ind)=[];
                if not(isempty(tempDat))
                    AllParams{dd}.TimeToPrevFz(FreezeBins(k))=AllParams{dd}.TrialTime(FreezeBins(k))-FzStop(length(tempDat));
                    AllParams{dd}.DurPrevEp(FreezeBins(k))=FzStop(length(tempDat))-FzStart(length(tempDat));
                end
            end
            
            % Stim related
            StimTimes=Start(TTLInfo.StimEpoch,'s');
            clear XSt YSt
            for s=1:length(StimTimes)
                XSt(s)=nanmean(Data(Restrict(Behav.Xtsd,intervalSet(StimTimes(s)*1e4-0.4*1e4,StimTimes(s)*1e4+0.1*1e4))));
                YSt(s)=nanmean(Data(Restrict(Behav.Ytsd,intervalSet(StimTimes(s)*1e4-0.5*1e4,StimTimes(s)*1e4+0.1*1e4))));
            end
            AllParams{dd}.TimeToStim=nan(1,length(AllParams{dd}.TrialTime));
            AllParams{dd}.XDistToStim=nan(1,length(AllParams{dd}.TrialTime));
            AllParams{dd}.YDistToStim=nan(1,length(AllParams{dd}.TrialTime));
            for k=1:length(AllParams{dd}.TrialTime)
                tempDat=AllParams{dd}.TrialTime(k)-StimTimes;
                tempDat(tempDat<0)=[];
                [val,ind]=min(tempDat);
                AllParams{dd}.CumNumStimsTrial(k)=length(val);
                if not(isempty(ind))
                    AllParams{dd}.TimeToStim(k)=val;
                    AllParams{dd}.XDistToStim(k)=abs(AllParams{dd}.XPos(k)-XSt(ind));
                    AllParams{dd}.YDistToStim(k)=abs(AllParams{dd}.YPos(k)-YSt(ind));
                end
            end
            AllParams{dd}.CumNumStimsTotal=AllParams{dd}.CumNumStimsTrial+TotStims;
            TotStims=TotStims+length(StimTimes);
            
            % Zone related
            AllParams{dd}.WhichZone=NaN(1,length(AllParams{dd}.TrialTime));
            for z=1:5
                temptsd=tsd(AllParams{dd}.TrialTime*1e4,[1:length(AllParams{dd}.TrialTime)]');
                ZoneBins=Data(Restrict(temptsd,Behav.ZoneEpoch{z}));
                AllParams{dd}.WhichZone(ZoneBins)=z;
            end
            ExitShockZoneTimes=Stop(Behav.ZoneEpoch{1},'s');
            NotShockZoneBins=find(AllParams{dd}.WhichZone~=1);
            AllParams{dd}.TimeLastShockZone=nan(1,length(AllParams{dd}.TrialTime));
            if not(isempty(NotShockZoneBins)) &  not(isempty(ExitShockZoneTimes))
                for k=1:length(NotShockZoneBins)
                    tempDat=AllParams{dd}.TrialTime(NotShockZoneBins(k))-ExitShockZoneTimes;
                    tempDat(tempDat<0)=[];
                    [val,ind]=min(tempDat);
                    if not(isempty(ind))
                        AllParams{dd}.TimeLastShockZone(k)=val;
                    end
                end
            end
            
            
            % Get Breathingfrequency
            tempDat=interp1(Range(LocalFreq.PT),Data(LocalFreq.PT),Range(Behav.Xtsd));
            AllParams{dd}.BreathFreq=DownsInBlocks(tempDat,BlockDur);
            
            %Get rid of noisy data
            TotEpoch=intervalSet(0,max(Range(Behav.Xtsd)));
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            temptsd=tsd(AllParams{dd}.TrialTime*1e4,[1:length(AllParams{dd}.TrialTime)]');
            noNoiseBins=Data(Restrict(temptsd,TotEpoch-RemovEpoch));
            AllParams{dd}=structfun(@(M) (M(noNoiseBins)),AllParams{dd},'UniformOutput',0);
        end
        
        cd(Dir.path{d}{dd}(1:findstr(Dir.path{d}{dd},[MouseName{ss,d} filesep])+3))
        save('TableToPredictBreathingFreq.mat','AllParams')
        
        cd('/media/sophie/My Passport1/ProjectEmbReac/Figures/ForIGBoost/')
        fld=fieldnames(AllParams{dd});
        for f=1:length(fld)-1
            InPutData.(fld{f})=[];
        end
        for dd=1:length(Dir.path{d})
            for f=1:length(fld)-1
                InPutData.(fld{f})=[InPutData.(fld{f}),AllParams{dd}.(fld{f})];
            end
        end
        AllFzInd=find(InPutData.IsFreeze);
        InPutData=reshape(struct2array(InPutData),size(InPutData.WhichZone,2),length(fld)-1);
        OutPutData=[];
        for dd=1:length(Dir.path{d})
            OutPutData=[OutPutData,AllParams{dd}.BreathFreq];
        end
        save(['Mouse' MouseName{ss,d} 'TableToPredictBreathingFreq.mat'],'OutPutData','InPutData')
        
        OutPutData=OutPutData(AllFzInd);
        InPutData=InPutData(AllFzInd,:);
        save(['Mouse' MouseName{ss,d} 'TableToPredictBreathingFreqOnlyFz.mat'],'OutPutData','InPutData')

        clear OutPutData InPutData AllFzInd AllParams
    end
end
