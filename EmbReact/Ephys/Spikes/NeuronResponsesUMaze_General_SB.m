%% This codes looks at what neurons are doing
clear all, close all

MiceNumber=[490,507,508,509,510,514]; % add 512 back in later
SessNames={'EPM','Habituation' 'SleepPreUMaze' 'TestPre' 'UMazeCond' 'SleepPostUMaze' 'TestPost' 'Extinction',...
    'SoundHab' 'SleepPreSound' 'SoundCond' 'SleepPostSound' 'SoundTest','HabituationNight' 'SleepPreNight',...
    'TestPreNight' 'UMazeCondNight' 'SleepPostNight' 'TestPostNight' 'ExtinctionNight'};
NumBt=200;
UMazeRegNames={'Shock','NoShock','Centre','CentreShock','CentreNoShock';'ShockRun','NoShockRun','CentreRun','CentreShockRun','CentreNoShockRun'};
SpeedThresh=5; % cm/s
Alpha2Side=[2.5,97.5];
Alpha1Side=[5,95];
MinNumSpikes=100;
SoundPSTHDur=40;

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReactMontreal(SessNames{ss});
    for mm=1:length(MiceNumber)
        for d=1:length(Dir.path)
            if Dir.ExpeInfo{d}{1}.nmouse==MiceNumber(mm)
                
                %% UmazeHab
                if strcmp(SessNames{ss},'Habituation') | strcmp(SessNames{ss},'HabituationNight')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' UmazeHab'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    
                    [map{mm}{sp},stats{mm}{sp},ZoneFr{mm}{sp},ZoneFrRand{mm}{sp}]=UMazeSpatialPatterns(S{sp},Behav.Xtsd,Behav.Ytsd,TotEpoch,SpeedThresh,Behav.ZoneEpoch,MinNumSpikes,NumBt)
                    
                    for z=1:5
                        Behav.ZoneEpoch{z}=and(Behav.ZoneEpoch{z},TotEpoch);
                    end
                    [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,SpeedThresh,0);
                    RunningEpoch=and(RunningEpoch,TotEpoch);
                    
                    for z=1:5
                        EpochsOfInt{z,1}=CleanUpEpoch(and(Behav.ZoneEpoch{z},TotEpoch));
                        EpochsOfInt{z,2}=CleanUpEpoch(and(Behav.ZoneEpoch{z},RunningEpoch));
                    end

                    for sp=1:length(S)
                        S{sp}=Restrict(S{sp},TotEpoch);
                        if  length(S{sp})>MinNumSpikes
                            try,[UmazeHab.PlaceField{mm}{sp}.map,UmazeHab.PlaceField{mm}{sp}.stats]=PlaceField_SB(S{sp},Behav.Xtsd,Behav.Ytsd,'figure',0,'limitmaze',[0 ceil(max(Data(Behav.Xtsd))*1.2) 0 ceil(max(Data(Behav.Ytsd))*1.2)],'size',100,'smoothing',2);
                            catch
                                UmazeHab.PlaceField{mm}{sp}.map=NaN;
                                UmazeHab.PlaceField{mm}{sp}.stats=NaN;
                            end
                            
                            try,[UmazeHab.PlaceFieldRun{mm}{sp}.map,UmazeHab.PlaceFieldRun{mm}{sp}.stats]=PlaceField_SB(Restrict(S{sp},RunningEpoch),Restrict(Behav.Xtsd,RunningEpoch),Restrict(Behav.Ytsd,RunningEpoch),'figure',0,'limitmaze',[0 ceil(max(Data(Behav.Xtsd))*1.2) 0 ceil(max(Data(Behav.Ytsd))*1.2)],'size',100,'smoothing',2);
                            catch
                                UmazeHab.PlaceField{mm}{sp}.map=NaN;
                                UmazeHab.PlaceField{mm}{sp}.stats=NaN;
                            end
                            
                            for z=1:2
                                for zz=1:5
                                    UmazeHab.ZoneFr{mm}.(UMazeRegNames{z,zz})(sp)=length(Restrict(S{sp},EpochsOfInt{z,zz}))/sum(Stop(EpochsOfInt{z,zz},'s')-Start(EpochsOfInt{z,zz},'s'));
                                end
                            end
                           
                            UmazeHab.ModInd{mm}(sp)=(UmazeHab.ZoneFr{mm}.Shock(sp)-UmazeHab.ZoneFr{mm}.NoShock(sp))./(UmazeHab.ZoneFr{mm}.Shock(sp)+UmazeHab.ZoneFr{mm}.NoShock(sp));
                            UmazeHab.ModIndRun{mm}(sp)=(UmazeHab.ZoneFr{mm}.ShockRun(sp)-UmazeHab.ZoneFr{mm}.NoShockRun(sp))./(UmazeHab.ZoneFr{mm}.ShockRun(sp)+UmazeHab.ZoneFr{mm}.NoShockRun(sp));
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                for z=1:2
                                    for zz=1:5
                                        UmazeHab.ZoneFrRand{mm}.(UMazeRegNames{z,zz})(sp,k)=length(Restrict(NewSp,EpochsOfInt{z,zz}))/sum(Stop(EpochsOfInt{z,zz},'s')-Start(EpochsOfInt{z,zz},'s'));
                                    end
                                end
                                UmazeHab.ModIndRand{mm}(sp,k)=(UmazeHab.ZoneFrRand{mm}.Shock(sp)-UmazeHab.ZoneFrRand{mm}.NoShock(sp))./(UmazeHab.ZoneFrRand{mm}.Shock(sp)+UmazeHab.ZoneFrRand{mm}.NoShock(sp));
                                UmazeHab.ModIndRunRand{mm}(sp,k)=(UmazeHab.ZoneFrRand{mm}.ShockRun(sp)-UmazeHab.ZoneFrRand{mm}.NoShockRun(sp))./(UmazeHab.ZoneFrRand{mm}.ShockRun(sp)+UmazeHab.ZoneFrRand{mm}.NoShockRun(sp));
                            end
                            
                            if UmazeHab.ModInd{mm}(sp)<prctile(UmazeHab.ModIndRand{mm}(sp,:),Alpha2Side(1)), UmazeHab.ModIndSig{mm}(sp)=-1;
                            elseif UmazeHab.ModInd{mm}(sp)>prctile(UmazeHab.ModIndRand{mm}(sp,:),Alpha2Side(2)),UmazeHab.ModIndSig{mm}(sp)=1;
                            else,UmazeHab.ModIndSig{mm}(sp)=0;end
                            
                            if UmazeHab.ModIndRun{mm}(sp)<prctile(UmazeHab.ModIndRunRand{mm}(sp,:),Alpha2Side(1)), UmazeHab.ModIndRunSig{mm}(sp)=-1;
                            elseif UmazeHab.ModIndRun{mm}(sp)>prctile(UmazeHab.ModIndRunRand{mm}(sp,:),Alpha2Side(2)),UmazeHab.ModIndRunSig{mm}(sp)=1;
                            else,UmazeHab.ModIndRunSig{mm}(sp)=0;end
                            
                            
                            
                            
                        else
                            
                            UmazeHab.PlaceField{mm}{sp}.map=NaN;
                            UmazeHab.PlaceField{mm}{sp}.stats=NaN;
                            for z=1:2
                                for zz=1:5
                                    UmazeHab.ZoneFrRand{mm}.(UMazeRegNames{z,zz})(sp,1:NumBt)=nan(1,NumBt);
                                    UmazeHab.ZoneFr{mm}.(UMazeRegNames{z,zz})(sp)=NaN;
                                end
                            end
                            UmazeHab.ModIndSig{mm}(sp)=NaN;
                            UmazeHab.ModIndRunSig{mm}(sp)=NaN;
                        end
                    end
                end
                
                %% UmazeExt
                if strcmp(SessNames{ss},'Extinction') | strcmp(SessNames{ss},'ExtinctionNight')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' UmazeExt'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    Behav.Xtsd=Restrict(Behav.Xtsd,TotEpoch);
                    Behav.Ytsd=Restrict(Behav.Ytsd,TotEpoch);
                    for z=1:5
                        Behav.ZoneEpoch{z}=and(Behav.ZoneEpoch{z},TotEpoch);
                    end
                    for sp=1:length(S)
                        S{sp}=Restrict(S{sp},TotEpoch);
                        if  length(S{sp}) >MinNumSpikes
                            try,[~,mapS,stats,~,~,~,~,PrField,CentGrav,ScField,~,~]=PlaceField(S{sp},Behav.Xtsd,Behav.Ytsd,'figure',0);
                                UmazeExt.PlaceField{mm}{sp}.mapS=mapS;
                                UmazeExt.PlaceField{mm}{sp}.stats=stats;
                                UmazeExt.PlaceField{mm}{sp}.PrField=PrField;
                                UmazeExt.PlaceField{mm}{sp}.CentGravmapS=CentGrav;
                                UmazeExt.PlaceField{mm}{sp}.ScField=ScField;
                            catch
                                UmazeExt.PlaceField{mm}{sp}.mapS=NaN;
                                UmazeExt.PlaceField{mm}{sp}.stats=NaN;
                                UmazeExt.PlaceField{mm}{sp}.PrField=NaN;
                                UmazeExt.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                UmazeExt.PlaceField{mm}{sp}.ScField=NaN;
                            end
                            for z=1:5
                                UmazeExt.ZoneFr{mm}.(UMazeRegNames{z})(sp)=length(Restrict(S{sp},Behav.ZoneEpoch{z}))/sum(Stop(Behav.ZoneEpoch{z},'s')-Start(Behav.ZoneEpoch{z},'s'));
                            end
                            UmazeExt.ModInd{mm}(sp)=(UmazeExt.ZoneFr{mm}.Shock(sp)-UmazeExt.ZoneFr{mm}.NoShock(sp))./(UmazeExt.ZoneFr{mm}.Shock(sp)+UmazeExt.ZoneFr{mm}.NoShock(sp));
                            
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                for z=1:5
                                    UmazeExt.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=length(Restrict(NewSp,Behav.ZoneEpoch{z}))/sum(Stop(Behav.ZoneEpoch{z},'s')-Start(Behav.ZoneEpoch{z},'s'));
                                end
                                UmazeExt.ModIndRand{mm}(sp,k)=(UmazeExt.ZoneFrRand{mm}.Shock(sp,k)-UmazeExt.ZoneFrRand{mm}.NoShock(sp,k))./(UmazeExt.ZoneFrRand{mm}.Shock(sp,k)+UmazeExt.ZoneFrRand{mm}.NoShock(sp,k));
                                
                            end
                            
                            if UmazeExt.ModInd{mm}(sp)<prctile(UmazeExt.ModIndRand{mm}(sp,:),Alpha2Side(1)), UmazeExt.ModIndSig{mm}(sp)=-1;
                            elseif UmazeExt.ModInd{mm}(sp)>prctile(UmazeExt.ModIndRand{mm}(sp,:),Alpha2Side(2)),UmazeExt.ModIndSig{mm}(sp)=1;
                            else,UmazeExt.ModIndSig{mm}(sp)=0;end
                        else
                            UmazeExt.PlaceField{mm}{sp}.mapS=NaN;
                            UmazeExt.PlaceField{mm}{sp}.stats=NaN;
                            UmazeExt.PlaceField{mm}{sp}.PrField=NaN;
                            UmazeExt.PlaceField{mm}{sp}.CentGravmapS=NaN;
                            UmazeExt.PlaceField{mm}{sp}.ScField=NaN;
                            for z=1:5
                                UmazeExt.ZoneFr{mm}.(UMazeRegNames{z})(sp)=NaN;
                            end
                            UmazeExt.ModInd{mm}(sp)=NaN;
                            
                            
                            for k=1
                                for z=1:5
                                    UmazeExt.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=NaN;
                                end
                                UmazeExt.ModIndRand{mm}(sp,k)=NaN;
                            end
                            
                            UmazeExt.ModIndSig{mm}(sp)=NaN;
                            
                        end
                    end
                end
                
                %% TestPre
                if strcmp(SessNames{ss},'TestPre') | strcmp(SessNames{ss},'TestPreNight')
                    for dd=1:4
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)));
                        TotEpoch=TotEpoch-SleepyEpoch;
                        for sp=1:length(S)
                            S{sp}=Restrict(S{sp},TotEpoch);
                        end
                        Behav.Xtsd=Restrict(Behav.Xtsd,TotEpoch);
                        Behav.Ytsd=Restrict(Behav.Ytsd,TotEpoch);
                        for z=1:5
                            Behav.ZoneEpoch{z}=and(Behav.ZoneEpoch{z},TotEpoch);
                        end
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        if ExpeInfo.SessionNumber==4
                            disp(['Mouse' num2str(MiceNumber(mm)),' UmazeTestPre'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];
                                Y=[Y;Data(AllBehav{k}.Ytsd)];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                            end
                            Xtsdtemp=tsd(XYTimes,X);
                            Ytsdtemp=tsd(XYTimes,Y);
                            for z=1:5,ZoneEpochtemp{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(S),Stemp{sp}=tsd(STimes{sp},STimes{sp}); end
                            
                            for sp=1:length(Stemp)
                                if  length(Stemp{sp}) >MinNumSpikes
                                    try,[~,mapS,stats,~,~,~,~,PrField,CentGrav,ScField,~,~]=PlaceField(Stemp{sp},Xtsdtemp,Ytsdtemp,'figure',0);
                                        UMazePreTest.PlaceField{mm}{sp}.mapS=mapS;
                                        UMazePreTest.PlaceField{mm}{sp}.stats=stats;
                                        UMazePreTest.PlaceField{mm}{sp}.PrField=PrField;
                                        UMazePreTest.PlaceField{mm}{sp}.CentGravmapS=CentGrav;
                                        UMazePreTest.PlaceField{mm}{sp}.ScField=ScField;
                                    catch
                                        UMazePreTest.PlaceField{mm}{sp}.mapS=NaN;
                                        UMazePreTest.PlaceField{mm}{sp}.stats=NaN;
                                        UMazePreTest.PlaceField{mm}{sp}.PrField=NaN;
                                        UMazePreTest.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                        UMazePreTest.PlaceField{mm}{sp}.ScField=NaN;
                                    end
                                    for z=1:5
                                        UMazePreTest.ZoneFr{mm}.(UMazeRegNames{z})(sp)=length(Restrict(Stemp{sp},ZoneEpochtemp{z}))/sum(Stop(ZoneEpochtemp{z},'s')-Start(ZoneEpochtemp{z},'s'));
                                    end
                                    UMazePreTest.ModInd{mm}(sp)=(UMazePreTest.ZoneFr{mm}.Shock(sp)-UMazePreTest.ZoneFr{mm}.NoShock(sp))./(UMazePreTest.ZoneFr{mm}.Shock(sp)+UMazePreTest.ZoneFr{mm}.NoShock(sp));
                                    
                                    
                                    for k=1:NumBt
                                        ISI=diff(Range(Stemp{sp}));
                                        ISI=ISI(randperm(length(ISI)));
                                        tppossstart=max(Range(LFP))-sum(ISI);
                                        NewSp=cumsum([tppossstart*rand;ISI]);
                                        NewSp=tsd(NewSp,NewSp);
                                        for z=1:5
                                            UMazePreTest.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=length(Restrict(NewSp,ZoneEpochtemp{z}))/sum(Stop(ZoneEpochtemp{z},'s')-Start(ZoneEpochtemp{z},'s'));
                                        end
                                        UMazePreTest.ModIndRand{mm}(sp,k)=(UMazePreTest.ZoneFrRand{mm}.Shock(sp,k)-UMazePreTest.ZoneFrRand{mm}.NoShock(sp,k))./(UMazePreTest.ZoneFrRand{mm}.Shock(sp,k)+UMazePreTest.ZoneFrRand{mm}.NoShock(sp,k));
                                        
                                    end
                                    
                                    if UMazePreTest.ModInd{mm}(sp)<prctile(UMazePreTest.ModIndRand{mm}(sp,:),Alpha2Side(1)), UMazePreTest.ModIndSig{mm}(sp)=-1;
                                    elseif UMazePreTest.ModInd{mm}(sp)>prctile(UMazePreTest.ModIndRand{mm}(sp,:),Alpha2Side(2)),UMazePreTest.ModIndSig{mm}(sp)=1;
                                    else,UMazePreTest.ModIndSig{mm}(sp)=0;end
                                    
                                else
                                    
                                    UMazePreTest.PlaceField{mm}{sp}.mapS=NaN;
                                    UMazePreTest.PlaceField{mm}{sp}.stats=NaN;
                                    UMazePreTest.PlaceField{mm}{sp}.PrField=NaN;
                                    UMazePreTest.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                    UMazePreTest.PlaceField{mm}{sp}.ScField=NaN;
                                    for z=1:5
                                        UMazePreTest.ZoneFr{mm}.(UMazeRegNames{z})(sp)=NaN;
                                    end
                                    UMazePreTest.ModInd{mm}(sp)=NaN;
                                    
                                    
                                    for k=1
                                        for z=1:5
                                            UMazePreTest.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=NaN;
                                        end
                                        UMazePreTest.ModIndRand{mm}(sp,k)=NaN;
                                    end
                                    
                                    UMazePreTest.ModIndSig{mm}(sp)=NaN;
                                    
                                end
                                
                            end
                            
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp Xtsdtemp Ytsdtemp ZoneEpochtemp Stemp
                            
                        end
                    end
                end
                
                %% TestPost
                if strcmp(SessNames{ss},'TestPost') | strcmp(SessNames{ss},'TestPostNight')
                    for dd=1:4
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)));
                        TotEpoch=TotEpoch-SleepyEpoch;
                        for sp=1:length(S)
                            S{sp}=Restrict(S{sp},TotEpoch);
                        end
                        Behav.Xtsd=Restrict(Behav.Xtsd,TotEpoch);
                        Behav.Ytsd=Restrict(Behav.Ytsd,TotEpoch);
                        for z=1:5
                            Behav.ZoneEpoch{z}=and(Behav.ZoneEpoch{z},TotEpoch);
                        end
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        if ExpeInfo.SessionNumber==4
                            disp(['Mouse' num2str(MiceNumber(mm)),' UMazeTestPost'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];
                                Y=[Y;Data(AllBehav{k}.Ytsd)];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                                
                            end
                            Xtsdtemp=tsd(XYTimes,X);
                            Ytsdtemp=tsd(XYTimes,Y);
                            for z=1:5,ZoneEpochtemp{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(S),Stemp{sp}=tsd(STimes{sp},STimes{sp}); end
                            
                            
                            for sp=1:length(Stemp)
                                if  length(Stemp{sp}) >MinNumSpikes
                                    try,[~,mapS,stats,~,~,~,~,PrField,CentGrav,ScField,~,~]=PlaceField(Stemp{sp},Xtsdtemp,Ytsdtemp,'figure',0);
                                        UMazePostTest.PlaceField{mm}{sp}.mapS=mapS;
                                        UMazePostTest.PlaceField{mm}{sp}.stats=stats;
                                        UMazePostTest.PlaceField{mm}{sp}.PrField=PrField;
                                        UMazePostTest.PlaceField{mm}{sp}.CentGravmapS=CentGrav;
                                        UMazePostTest.PlaceField{mm}{sp}.ScField=ScField;
                                    catch
                                        UMazePostTest.PlaceField{mm}{sp}.mapS=NaN;
                                        UMazePostTest.PlaceField{mm}{sp}.stats=NaN;
                                        UMazePostTest.PlaceField{mm}{sp}.PrField=NaN;
                                        UMazePostTest.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                        UMazePostTest.PlaceField{mm}{sp}.ScField=NaN;
                                    end
                                    for z=1:5
                                        UMazePostTest.ZoneFr{mm}.(UMazeRegNames{z})(sp)=length(Restrict(Stemp{sp},ZoneEpochtemp{z}))/sum(Stop(ZoneEpochtemp{z},'s')-Start(ZoneEpochtemp{z},'s'));
                                    end
                                    UMazePostTest.ModInd{mm}(sp)=(UMazePostTest.ZoneFr{mm}.Shock(sp)-UMazePostTest.ZoneFr{mm}.NoShock(sp))./(UMazePostTest.ZoneFr{mm}.Shock(sp)+UMazePostTest.ZoneFr{mm}.NoShock(sp));
                                    
                                    
                                    for k=1:NumBt
                                        ISI=diff(Range(Stemp{sp}));
                                        ISI=ISI(randperm(length(ISI)));
                                        tppossstart=max(Range(LFP))-sum(ISI);
                                        NewSp=cumsum([tppossstart*rand;ISI]);
                                        NewSp=tsd(NewSp,NewSp);
                                        for z=1:5
                                            UMazePostTest.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=length(Restrict(NewSp,ZoneEpochtemp{z}))/sum(Stop(ZoneEpochtemp{z},'s')-Start(ZoneEpochtemp{z},'s'));
                                        end
                                        UMazePostTest.ModIndRand{mm}(sp,k)=(UMazePostTest.ZoneFrRand{mm}.Shock(sp,k)-UMazePostTest.ZoneFrRand{mm}.NoShock(sp,k))./(UMazePostTest.ZoneFrRand{mm}.Shock(sp,k)+UMazePostTest.ZoneFrRand{mm}.NoShock(sp,k));
                                        
                                    end
                                    
                                    if UMazePostTest.ModInd{mm}(sp)<prctile(UMazePostTest.ModIndRand{mm}(sp,:),Alpha2Side(1)), UMazePostTest.ModIndSig{mm}(sp)=-1;
                                    elseif UMazePostTest.ModInd{mm}(sp)>prctile(UMazePostTest.ModIndRand{mm}(sp,:),Alpha2Side(2)),UMazePostTest.ModIndSig{mm}(sp)=1;
                                    else,UMazePostTest.ModIndSig{mm}(sp)=0;end
                                    
                                else
                                    
                                    UMazePostTest.PlaceField{mm}{sp}.mapS=NaN;
                                    UMazePostTest.PlaceField{mm}{sp}.stats=NaN;
                                    UMazePostTest.PlaceField{mm}{sp}.PrField=NaN;
                                    UMazePostTest.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                    UMazePostTest.PlaceField{mm}{sp}.ScField=NaN;
                                    for z=1:5
                                        UMazePostTest.ZoneFr{mm}.(UMazeRegNames{z})(sp)=NaN;
                                    end
                                    UMazePostTest.ModInd{mm}(sp)=NaN;
                                    
                                    
                                    for k=1
                                        for z=1:5
                                            UMazePostTest.ZoneFrRand{mm}.(UMazeRegNames{z})(sp,k)=NaN;
                                        end
                                        UMazePostTest.ModIndRand{mm}(sp,k)=NaN;
                                        
                                    end
                                    
                                    UMazePostTest.ModIndSig{mm}(sp)=NaN;
                                    
                                end
                            end
                            
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp Xtsdtemp Ytsdtemp ZoneEpochtemp Stemp
                        end
                    end
                end
                
                %% UMazeCond
                if strcmp(SessNames{ss},'UMazeCond') | strcmp(SessNames{ss},'UMazeCondNight')
                    for dd=1:5
                        cd(Dir.path{d}{dd})
                        load('SpikeData.mat')
                        load('behavResources.mat')
                        load('ExpeInfo.mat')
                        load('LFPData/LFP0.mat')
                        load('StateEpochSB.mat','SleepyEpoch')
                        load('LFPData/LFP0.mat')
                        TotEpoch=intervalSet(0,max(Range(LFP)));
                        TotEpoch=TotEpoch-SleepyEpoch;
                        for sp=1:length(S)
                            S{sp}=Restrict(S{sp},TotEpoch);
                        end
                        Behav.Xtsd=Restrict(Behav.Xtsd,TotEpoch);
                        Behav.Ytsd=Restrict(Behav.Ytsd,TotEpoch);
                        Behav.FreezeEpoch=and(Behav.FreezeEpoch,TotEpoch);
                        for z=1:5
                            Behav.ZoneEpoch{z}=and(Behav.ZoneEpoch{z},TotEpoch);
                        end
                        AllS{ExpeInfo.SessionNumber}=S;
                        AllBehav{ExpeInfo.SessionNumber}=Behav;
                        TEnd(ExpeInfo.SessionNumber+1)=max(Range(LFP));
                        AllZoneEpoch{ExpeInfo.SessionNumber}=Behav.ZoneEpoch;
                        AllZFreezeEpoch{ExpeInfo.SessionNumber}=Behav.FreezeEpoch;
                        
                        if ExpeInfo.SessionNumber==5
                            disp(['Mouse' num2str(MiceNumber(mm)),' UMazeCond'])
                            TEnd=[cumsum(TEnd)];
                            % Concatenate
                            X=[]; Y=[]; XYTimes=[];
                            for z=1:5,ZoneEpStrStp{z}=[];end
                            FreezeEpStpStr=[];
                            for sp=1:length(S),STimes{sp}=[];end
                            for k=1:4
                                for sp=1:length(S),STimes{sp}=[STimes{sp};Range(AllS{k}{sp})+TEnd(k)]; end
                                X=[X;Data(AllBehav{k}.Xtsd)];
                                Y=[Y;Data(AllBehav{k}.Ytsd)];
                                XYTimes=[XYTimes;Range(AllBehav{k}.Ytsd)+TEnd(k)];
                                for z=1:5,ZoneEpStrStp{z}=[ZoneEpStrStp{z};[Start(AllZoneEpoch{k}{z})+TEnd(k),Stop(AllZoneEpoch{k}{z})+TEnd(k)]];end
                                FreezeEpStpStr=[FreezeEpStpStr;[Start(AllZFreezeEpoch{z})+TEnd(k),Stop(AllZFreezeEpoch{z})+TEnd(k)]];
                            end
                            
                            Xtsdtemp=tsd(XYTimes,X);
                            Ytsdtemp=tsd(XYTimes,Y);
                            for z=1:5,ZoneEpochtemp{z}=intervalSet(ZoneEpStrStp{z}(:,1),ZoneEpStrStp{z}(:,2));end
                            for sp=1:length(S),Stemp{sp}=tsd(STimes{sp},STimes{sp}); end
                            FreezeEpochtemp=intervalSet(FreezeEpStpStr(:,1),FreezeEpStpStr(:,2));
                            TotEpoch=intervalSet(0,TEnd(end));
                            
                            for sp=1:length(Stemp)
                                if  length(Restrict(Stemp{sp},FreezeEpochtemp)) >MinNumSpikes & length(Restrict(Stemp{sp},TotEpoch-FreezeEpochtemp)) >MinNumSpikes
                                    try,[~,mapS,stats,~,~,~,~,PrField,CentGrav,ScField,~,~]=PlaceField(Restrict(Stemp{sp},TotEpoch-FreezeEpochtemp),Xtsdtemp,Ytsdtemp,'figure',0);
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.mapS=mapS;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.stats=stats;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.PrField=PrField;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.CentGravmapS=CentGrav;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.ScField=ScField;
                                    catch
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.mapS=NaN;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.stats=NaN;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.PrField=NaN;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.CentGravmapS=NaN;
                                        UMazeCond.PlaceFieldNoFz{mm}{sp}.ScField=NaN;
                                    end
                                    
                                    try,[~,mapS,stats,~,~,~,~,PrField,CentGrav,ScField,~,~]=PlaceField(Stemp{sp},Xtsdtemp,Ytsdtemp,'figure',0);
                                        UMazeCond.PlaceField{mm}{sp}.mapS=mapS;
                                        UMazeCond.PlaceField{mm}{sp}.stats=stats;
                                        UMazeCond.PlaceField{mm}{sp}.PrField=PrField;
                                        UMazeCond.PlaceField{mm}{sp}.CentGravmapS=CentGrav;
                                        UMazeCond.PlaceField{mm}{sp}.ScField=ScField;
                                    catch
                                        UMazeCond.PlaceField{mm}{sp}.mapS=NaN;
                                        UMazeCond.PlaceField{mm}{sp}.stats=NaN;
                                        UMazeCond.PlaceField{mm}{sp}.PrField=NaN;
                                        UMazeCond.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                        UMazeCond.PlaceField{mm}{sp}.ScField=NaN;
                                    end
                                    
                                    for z=1:5
                                        tempEp=and(ZoneEpochtemp{z},FreezeEpochtemp);tempEp=dropShortIntervals(tempEp,2*1e4);
                                        UMazeCond.ZoneFrFz{mm}.(UMazeRegNames{z})(sp)=length(Restrict(Stemp{sp},tempEp))/sum(Stop(tempEp,'s')-Start(tempEp,'s'));
                                        tempEp=and(ZoneEpochtemp{z},TotEpoch-FreezeEpochtemp);tempEp=dropShortIntervals(tempEp,2*1e4);
                                        UMazeCond.ZoneFrNoFz{mm}.(UMazeRegNames{z})(sp)=length(Restrict(Stemp{sp},tempEp))/sum(Stop(tempEp,'s')-Start(tempEp,'s'));
                                    end
                                    UMazeCond.ModIndFrFz{mm}(sp)=(UMazeCond.ZoneFrFz{mm}.Shock(sp)-UMazeCond.ZoneFrFz{mm}.NoShock(sp))./(UMazeCond.ZoneFrFz{mm}.Shock(sp)+UMazeCond.ZoneFrFz{mm}.NoShock(sp));
                                    UMazeCond.ModIndFrNoFz{mm}(sp)=(UMazeCond.ZoneFrNoFz{mm}.Shock(sp)-UMazeCond.ZoneFrNoFz{mm}.NoShock(sp))./(UMazeCond.ZoneFrNoFz{mm}.Shock(sp)+UMazeCond.ZoneFrNoFz{mm}.NoShock(sp));
                                    
                                    for k=1:NumBt
                                        ISI=diff(Range(Stemp{sp}));
                                        ISI=ISI(randperm(length(ISI)));
                                        tppossstart=max(Range(LFP))-sum(ISI);
                                        NewSp=cumsum([tppossstart*rand;ISI]);
                                        NewSp=tsd(NewSp,NewSp);
                                        for z=1:5
                                            tempEp=and(ZoneEpochtemp{z},FreezeEpochtemp);tempEp=dropShortIntervals(tempEp,2*1e4);
                                            UMazeCond.ZoneFrFzRand{mm}.(UMazeRegNames{z})(sp,k)=length(Restrict(NewSp,tempEp))/sum(Stop(tempEp,'s')-Start(tempEp,'s'));
                                            tempEp=and(ZoneEpochtemp{z},TotEpoch-FreezeEpochtemp);tempEp=dropShortIntervals(tempEp,2*1e4);
                                            UMazeCond.ZoneFrNoFzRand{mm}.(UMazeRegNames{z})(sp,k)=length(Restrict(NewSp,tempEp))/sum(Stop(tempEp,'s')-Start(tempEp,'s'));
                                        end
                                        UMazeCond.ModIndFrFzRand{mm}(sp,k)=(UMazeCond.ZoneFrFzRand{mm}.Shock(sp,k)-UMazeCond.ZoneFrFzRand{mm}.NoShock(sp,k))./(UMazeCond.ZoneFrFzRand{mm}.Shock(sp,k)+UMazeCond.ZoneFrFzRand{mm}.NoShock(sp,k));
                                        UMazeCond.ModIndFrNoFzRand{mm}(sp,k)=(UMazeCond.ZoneFrNoFzRand{mm}.Shock(sp,k)-UMazeCond.ZoneFrNoFzRand{mm}.NoShock(sp,k))./(UMazeCond.ZoneFrNoFzRand{mm}.Shock(sp,k)+UMazeCond.ZoneFrNoFzRand{mm}.NoShock(sp,k));
                                    end
                                    
                                else
                                    
                                    UMazeCond.PlaceFieldNoFz{mm}{sp}.mapS=NaN;
                                    UMazeCond.PlaceFieldNoFz{mm}{sp}.stats=NaN;
                                    UMazeCond.PlaceFieldNoFz{mm}{sp}.PrField=NaN;
                                    UMazeCond.PlaceFieldNoFz{mm}{sp}.CentGravmapS=NaN;
                                    UMazeCond.PlaceFieldNoFz{mm}{sp}.ScField=NaN;
                                    
                                    UMazeCond.PlaceField{mm}{sp}.mapS=NaN;
                                    UMazeCond.PlaceField{mm}{sp}.stats=NaN;
                                    UMazeCond.PlaceField{mm}{sp}.PrField=NaN;
                                    UMazeCond.PlaceField{mm}{sp}.CentGravmapS=NaN;
                                    UMazeCond.PlaceField{mm}{sp}.ScField=NaN;
                                    
                                    for z=1:5
                                        UMazeCond.ZoneFrFz{mm}.(UMazeRegNames{z})(sp)=NaN;
                                        UMazeCond.ZoneFrNoFz{mm}.(UMazeRegNames{z})(sp)=NaN;
                                    end
                                    UMazeCond.ModIndFrFz{mm}(sp)=NaN;
                                    UMazeCond.ModIndFrNoFz{mm}(sp)=NaN;
                                    
                                    for k=1
                                        
                                        for z=1:5
                                            UMazeCond.ZoneFrFzRand{mm}.(UMazeRegNames{z})(sp,k)=NaN;
                                            UMazeCond.ZoneFrNoFzRand{mm}.(UMazeRegNames{z})(sp,k)=NaN;
                                        end
                                        UMazeCond.ModIndFrFzRand{mm}(sp,k)=NaN;
                                        UMazeCond.ModIndFrNoFzRand{mm}(sp,k)=NaN;
                                    end
                                    
                                end
                            end
                            clear AllS AllBehav TEnd X Y XYTimes STimes ZoneEpStrStp Xtsdtemp Ytsdtemp ZoneEpochtemp Stemp FreezeEpochtemp FreezeEpStpStr
                        end
                    end
                end
                
                %% Sound hab
                if strcmp(SessNames{ss},'SoundHab')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' SoundHab'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('ExpeInfo.mat')
                    load('LFPData/LFP0.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    for sp=1:length(S)
                        S{sp}=Restrict(S{sp},TotEpoch);
                    end
                    Behav.FreezeEpoch=and(Behav.FreezeEpoch,TotEpoch);
                    
                    for sp=1:length(S)
                        if length(S{sp})>MinNumSpikes
                            [~,SoundHab.AvCSMoins{mm}{sp},SoundHab.IndivSweepsCSMoins{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            [~,SoundHab.AvCSPlus{mm}{sp},SoundHab.IndivSweepsCSPlus{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            
                            
                            SoundHab.FrFz{mm}{sp}=length(Restrict(S{sp},Behav.FreezeEpoch))/sum(Stop(Behav.FreezeEpoch,'s')-Start(Behav.FreezeEpoch,'s'));
                            SoundHab.FrNoFz{mm}{sp}=length(Restrict(S{sp},TotEpoch-Behav.FreezeEpoch))/sum(Stop(TotEpoch-Behav.FreezeEpoch,'s')-Start(TotEpoch-Behav.FreezeEpoch,'s'));
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundHab.AvCSMoinsRand{mm}{sp}(k,:)=Data(sq);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundHab.AvCSPlusRand{mm}{sp}(k,:)=Data(sq);
                            end
                            
                        else
                            SoundHab.AvCSMoins{mm}{sp}=NaN;SoundHab.IndivSweepsCSMoins{mm}{sp}=NaN;
                            SoundHab.AvCSPlus{mm}{sp}=NaN;SoundHab.IndivSweepsCSPlus{mm}{sp}=NaN;
                            SoundHab.FrFz{mm}{sp}=NaN;SoundHab.FrNoFz{mm}{sp}=NaN;
                            SoundHab.AvCSMoinsRand{mm}{sp}=NaN;
                            SoundHab.AvCSPlusRand{mm}{sp}(k,:)=NaN;
                        end
                    end
                end
                
                
                %% Sound cond
                if strcmp(SessNames{ss},'SoundCond')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' SoundCond'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('ExpeInfo.mat')
                    load('LFPData/LFP0.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    for sp=1:length(S)
                        S{sp}=Restrict(S{sp},TotEpoch);
                    end
                    Behav.FreezeEpoch=and(Behav.FreezeEpoch,TotEpoch);
                    TTLInfo.StimEpoch=intervalset(Start(TTLInfo.StimEpoch),Start(TTLInfo.StimEpoch)+1*1e4);
                    TotEpoch=TotEpoch-TTLInfo.StimEpoch;
                    Behav.FreezeEpoch=Behav.FreezeEpoch-TTLInfo.StimEpoch;
                    
                    for sp=1:length(S)
                        if length(S{sp})>MinNumSpikes
                            [~,SoundCond.AvCSMoins{mm}{sp},SoundCond.IndivSweepsCSMoins{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            [~,SoundCond.AvCSPlus{mm}{sp},SoundCond.IndivSweepsCSPlus{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            
                            
                            SoundCond.FrFz{mm}{sp}=length(Restrict(S{sp},Behav.FreezeEpoch))/sum(Stop(Behav.FreezeEpoch,'s')-Start(Behav.FreezeEpoch,'s'));
                            SoundCond.FrNoFz{mm}{sp}=length(Restrict(S{sp},TotEpoch-Behav.FreezeEpoch))/sum(Stop(TotEpoch-Behav.FreezeEpoch,'s')-Start(TotEpoch-Behav.FreezeEpoch,'s'));
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundCond.AvCSMoinsRand{mm}{sp}(k,:)=Data(sq);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundCond.AvCSPlusRand{mm}{sp}(k,:)=Data(sq);
                            end
                        else
                            SoundCond.AvCSMoins{mm}{sp}=NaN;SoundCond.IndivSweepsCSMoins{mm}{sp}=NaN;
                            SoundCond.AvCSPlus{mm}{sp}=NaN;SoundCond.IndivSweepsCSPlus{mm}{sp}=NaN;
                            SoundCond.FrFz{mm}{sp}=NaN;SoundCond.FrNoFz{mm}{sp}=NaN;
                            SoundCond.AvCSMoinsRand{mm}{sp}=NaN;
                            SoundCond.AvCSPlusRand{mm}{sp}(k,:)=NaN;
                            
                            
                        end
                        
                    end
                end
                
                
                %% Sound test
                if strcmp(SessNames{ss},'SoundTest')
                    cd(Dir.path{d}{1})
                    disp(['Mouse' num2str(MiceNumber(mm)),' SoundTest'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('ExpeInfo.mat')
                    load('LFPData/LFP0.mat')
                    load('StateEpochSB.mat','SleepyEpoch')
                    load('LFPData/LFP0.mat')
                    TotEpoch=intervalSet(0,max(Range(LFP)));
                    TotEpoch=TotEpoch-SleepyEpoch;
                    for sp=1:length(S)
                        S{sp}=Restrict(S{sp},TotEpoch);
                    end
                    Behav.FreezeEpoch=and(Behav.FreezeEpoch,TotEpoch);
                    
                    for sp=1:length(S)
                        if length(S{sp})>MinNumSpikes
                            [~,SoundTest.AvCSMoins{mm}{sp},UMazeHab.IndivSweepsCSMoins{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            [~,SoundTest.AvCSPlus{mm}{sp},UMazeHab.AvCSPlusRand{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            [~,SoundTest.AvCSPlusFirst{mm}{sp},UMazeHab.AvCSPlusFirst{mm}{sp}, ~, ~,~] = RasterPETH_SB(S{sp}, ts((TTLInfo.CSPlusTimes(1:4))),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                            
                            SoundTest.FrFz{mm}{sp}=length(Restrict(S{sp},Behav.FreezeEpoch))/sum(Stop(Behav.FreezeEpoch,'s')-Start(Behav.FreezeEpoch,'s'));
                            SoundTest.FrNoFz{mm}{sp}=length(Restrict(S{sp},TotEpoch-Behav.FreezeEpoch))/sum(Stop(TotEpoch-Behav.FreezeEpoch,'s')-Start(TotEpoch-Behav.FreezeEpoch,'s'));
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSMoinsTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundTest.AvCSMoinsRand{mm}{sp}(k,:)=Data(sq);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSPlusTimes)),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundTest.AvCSPlusRand{mm}{sp}(k,:)=Data(sq);
                                [fh,sq,sweeps, rasterAx, histAx,dArea] = RasterPETH_SB(NewSp, ts((TTLInfo.CSPlusTimes(1:4))),-SoundPSTHDur*1e4, SoundPSTHDur*1e4,0,'BinSize',1000);
                                SoundTest.AvCSPlusFirstRand{mm}{sp}(k,:)=Data(sq);
                            end
                        else
                            SoundTest.AvCSMoins{mm}{sp}=NaN;SoundTest.IndivSweepsCSMoins{mm}{sp}=NaN;
                            SoundTest.AvCSPlus{mm}{sp}=NaN;SoundTest.IndivSweepsCSPlus{mm}{sp}=NaN;
                            SoundTest.FrFz{mm}{sp}=NaN;SoundTest.FrNoFz{mm}{sp}=NaN;
                            SoundTest.AvCSMoinsRand{mm}{sp}=NaN;
                            SoundTest.AvCSPlusRand{mm}{sp}(k,:)=NaN;
                        end
                    end
                end
                
            end
        end
    end
end

for mm=3
    for sp=1:length(EPM.ModIndSig{mm})
        if abs(EPM.ModIndSig{mm}(sp))==1
            subplot(231)
            hist(EPM.ModIndRand{mm}(sp,:)), hold on
            line([1 1]*EPM.ModInd{mm}(sp),ylim)
            title(num2str(EPM.ModIndSig{mm}(sp)))
            subplot(232)
            hist(EPM.ScoreRand{mm}(sp,:)), hold on
            line([1 1]*EPM.Score{mm}(sp),ylim)
            title(num2str(EPM.ScoreSig{mm}(sp)))
            subplot(233)
            imagesc( EPM.PlaceField{mm}{sp}.mapS.rate)
               subplot(234)
            hist(EPM.ModIndRandRun{mm}(sp,:)), hold on
            line([1 1]*EPM.ModIndRun{mm}(sp),ylim)
            title(num2str(EPM.ModIndSigRun{mm}(sp)))
            subplot(235)
            hist(EPM.ScoreRandRun{mm}(sp,:)), hold on
            line([1 1]*EPM.ScoreRun{mm}(sp),ylim)
            title(num2str(EPM.ScoreSigRun{mm}(sp)))
            subplot(236)
            imagesc( EPM.PlaceFieldRun{mm}{sp}.mapS.rate)
            pause
            clf
        end
    end
end