%% This codes looks at what neurons are doing
clear all, close all

MiceNumber=[490,507,512,508,509,510,514]; 
SessNames={'EPM'};
NumBt=200;
EPMRegNames={'Open','Closed','Centre','OpenSide1','OpenSide2','ClosedSide1','ClosedSide2';'OpenRun','ClosedRun','CentreRun','OpenSide1Run','OpenSide2Run','ClosedSide1Run','ClosedSide2Run'};
UMazeRegNames={'Shock','NoShock','Centre','CentreShock','CentreNoShock'};
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
                %% EPM
                if strcmp(SessNames{ss},'EPM')
                    cd(Dir.path{d}{1})
                    clear EpochsOfInt
                    disp(['Mouse' num2str(MiceNumber(mm)),' EPM'])
                    load('SpikeData.mat')
                    load('behavResources.mat')
                    load('LFPData/LFP0.mat')
                    
                    % Get RunPeriod
                    [RunningEpoch,RunSpeed]=GetRunPer(Behav.Xtsd,Behav.Ytsd,SpeedThresh,0);

                    % Get Open1/Open2 and Closed1/Closed2
                    T1=Range(Behav.Xtsd);Xtemp=Data(Behav.Xtsd);
                    for z=1:2
                        RegionInfo=bwconncomp(Params.Zone{z});
                        for zz=1:2
                            tempZone=zeros(RegionInfo.ImageSize);
                            tempZone(RegionInfo.PixelIdxList{zz})=1;
                            ZoneInd=find(diag(tempZone(floor(Data(Behav.Ytsd)/Params.pixratio),floor(Data(Behav.Xtsd)/Params.pixratio))));
                            Xtemp2=Xtemp*0;
                            Xtemp2(ZoneInd)=1;
                            ZoneEpochTemp{(z-1)*2+zz}=CleanUpEpoch(thresholdIntervals(tsd(T1,Xtemp2),0.5,'Direction','Above'));
                        end
                    end
                    
                    for i=1:3,EpochsOfInt{1,i}=Behav.ZoneEpoch{i};end
                    for i=1:3,EpochsOfInt{2,i}=and(Behav.ZoneEpoch{i},RunningEpoch);end
                    for i=1:4,EpochsOfInt{1,i+3}=ZoneEpochTemp{i};end
                    for i=1:4,EpochsOfInt{2,i+3}=and(ZoneEpochTemp{i},RunningEpoch);end

                    
                    for sp=1:length(S)
                        if length(S{sp})>MinNumSpikes
                            
                            for z=1:2
                                for zz=1:7
                                    EPM.ZoneFr{mm}.(EPMRegNames{z,zz})(sp)=FiringRateEpoch(S{sp},EpochsOfInt{z,zz});
                                end
                            end
                            [EPM.PlaceField{mm}{sp}.map,EPM.PlaceField{mm}{sp}.stats]=PlaceField_SB(S{sp},Behav.Xtsd,Behav.Ytsd,'limitmaze',[0 100 0 100],'size',100,'smoothing',2);
                            
                            [EPM.PlaceFieldRun{mm}{sp}.map,EPM.PlaceFieldRun{mm}{sp}.stats]=PlaceField_SB(Restrict(S{sp},RunningEpoch),Restrict(Behav.Xtsd,RunningEpoch),Restrict(Behav.Ytsd,RunningEpoch),'limitmaze',[0 100 0 100],'size',100,'smoothing',2);
                            
                            A=0.25*(abs(EPM.ZoneFr{mm}.OpenSide1(sp)-EPM.ZoneFr{mm}.ClosedSide1(sp))+abs(EPM.ZoneFr{mm}.OpenSide2(sp)-EPM.ZoneFr{mm}.ClosedSide1(sp))+...
                                abs(EPM.ZoneFr{mm}.OpenSide1(sp)-EPM.ZoneFr{mm}.ClosedSide2(sp))+abs(EPM.ZoneFr{mm}.OpenSide2(sp)-EPM.ZoneFr{mm}.ClosedSide2(sp)));
                            B=0.5*(abs(EPM.ZoneFr{mm}.OpenSide1(sp)-EPM.ZoneFr{mm}.OpenSide2(sp))+abs(EPM.ZoneFr{mm}.ClosedSide1(sp)-EPM.ZoneFr{mm}.ClosedSide2(sp)));
                            EPM.Score{mm}(sp)=(A-B)/(A+B);
                            EPM.ModInd{mm}(sp)=(EPM.ZoneFr{mm}.Open(sp)-EPM.ZoneFr{mm}.Closed(sp))./(EPM.ZoneFr{mm}.Open(sp)+EPM.ZoneFr{mm}.Closed(sp));
                            
                            A=0.25*(abs(EPM.ZoneFr{mm}.OpenSide1Run(sp)-EPM.ZoneFr{mm}.ClosedSide1Run(sp))+abs(EPM.ZoneFr{mm}.OpenSide2Run(sp)-EPM.ZoneFr{mm}.ClosedSide1Run(sp))+...
                                abs(EPM.ZoneFr{mm}.OpenSide1Run(sp)-EPM.ZoneFr{mm}.ClosedSide2Run(sp))+abs(EPM.ZoneFr{mm}.OpenSide2Run(sp)-EPM.ZoneFr{mm}.ClosedSide2Run(sp)));
                            B=0.5*(abs(EPM.ZoneFr{mm}.OpenSide1Run(sp)-EPM.ZoneFr{mm}.OpenSide2Run(sp))+abs(EPM.ZoneFr{mm}.ClosedSide1Run(sp)-EPM.ZoneFr{mm}.ClosedSide2Run(sp)));
                            EPM.ScoreRun{mm}(sp)=(A-B)/(A+B);
                            EPM.ModIndRun{mm}(sp)=(EPM.ZoneFr{mm}.OpenRun(sp)-EPM.ZoneFr{mm}.ClosedRun(sp))./(EPM.ZoneFr{mm}.OpenRun(sp)+EPM.ZoneFr{mm}.ClosedRun(sp));
                            
                            for k=1:NumBt
                                ISI=diff(Range(S{sp}));
                                ISI=ISI(randperm(length(ISI)));
                                tppossstart=max(Range(LFP))-sum(ISI);
                                NewSp=cumsum([tppossstart*rand;ISI]);
                                NewSp=tsd(NewSp,NewSp);
                                
                                for z=1:2
                                    for zz=1:7
                                        EPM.ZoneFrRand{mm}.(EPMRegNames{z,zz})(sp,k)=FiringRateEpoch(NewSp,EpochsOfInt{z,zz});
                                    end
                                end
                                
                                A=0.25*(abs(EPM.ZoneFrRand{mm}.OpenSide1(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide1(sp,k))+abs(EPM.ZoneFrRand{mm}.OpenSide2(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide1(sp,k))+...
                                    abs(EPM.ZoneFrRand{mm}.OpenSide1(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2(sp,k))+abs(EPM.ZoneFrRand{mm}.OpenSide2(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2(sp,k)));
                                B=0.5*(abs(EPM.ZoneFrRand{mm}.OpenSide1(sp,k)-EPM.ZoneFrRand{mm}.OpenSide2(sp,k))+abs(EPM.ZoneFrRand{mm}.ClosedSide1(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2(sp,k)));
                                EPM.ScoreRand{mm}(sp,k)=(A-B)/(A+B);
                                EPM.ModIndRand{mm}(sp,k)=(EPM.ZoneFrRand{mm}.Open(sp,k)-EPM.ZoneFrRand{mm}.Closed(sp,k))./(EPM.ZoneFrRand{mm}.Open(sp,k)+EPM.ZoneFrRand{mm}.Closed(sp,k));
                                
                                A=0.25*(abs(EPM.ZoneFrRand{mm}.OpenSide1Run(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide1Run(sp,k))+abs(EPM.ZoneFrRand{mm}.OpenSide2Run(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide1Run(sp,k))+...
                                    abs(EPM.ZoneFrRand{mm}.OpenSide1Run(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2Run(sp,k))+abs(EPM.ZoneFrRand{mm}.OpenSide2Run(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2Run(sp,k)));
                                B=0.5*(abs(EPM.ZoneFrRand{mm}.OpenSide1Run(sp,k)-EPM.ZoneFrRand{mm}.OpenSide2Run(sp,k))+abs(EPM.ZoneFrRand{mm}.ClosedSide1Run(sp,k)-EPM.ZoneFrRand{mm}.ClosedSide2Run(sp,k)));
                                EPM.ScoreRandRun{mm}(sp,k)=(A-B)/(A+B);
                                EPM.ModIndRandRun{mm}(sp,k)=(EPM.ZoneFrRand{mm}.OpenRun(sp,k)-EPM.ZoneFrRand{mm}.ClosedRun(sp,k))./(EPM.ZoneFrRand{mm}.OpenRun(sp,k)+EPM.ZoneFrRand{mm}.ClosedRun(sp,k));
                                                                
                            end
                            
                            if EPM.ModInd{mm}(sp)<prctile(EPM.ModIndRand{mm}(sp,:),Alpha2Side(1)), EPM.ModIndSig{mm}(sp)=-1;
                            elseif EPM.ModInd{mm}(sp)>prctile(EPM.ModIndRand{mm}(sp,:),Alpha2Side(2)),EPM.ModIndSig{mm}(sp)=1;
                            else,EPM.ModIndSig{mm}(sp)=0;end
                            
                            if EPM.ModIndRun{mm}(sp)<prctile(EPM.ModIndRandRun{mm}(sp,:),Alpha2Side(1)), EPM.ModIndSigRun{mm}(sp)=-1;
                            elseif EPM.ModIndRun{mm}(sp)>prctile(EPM.ModIndRandRun{mm}(sp,:),Alpha2Side(2)),EPM.ModIndSigRun{mm}(sp)=1;
                            else,EPM.ModIndSigRun{mm}(sp)=0;end
                            
                            if EPM.Score{mm}(sp)>prctile(EPM.ScoreRand{mm}(sp,:),Alpha1Side(2)), EPM.ScoreSig{mm}(sp)=1;
                            else,EPM.ScoreSig{mm}(sp)=0;end
                            
                            if EPM.ScoreRun{mm}(sp)>prctile(EPM.ScoreRandRun{mm}(sp,:),Alpha1Side(2)), EPM.ScoreSigRun{mm}(sp)=1;
                            else,EPM.ScoreSigRun{mm}(sp)=0;end
                            
                        else %Neurons with too few spikes  
                            for z=1:2
                                for zz=1:7
                                    EPM.ZoneFr{mm}.(EPMRegNames{z,zz})(sp)=NaN;
                                    EPM.ZoneFrRand{mm}.(EPMRegNames{z,zz})(sp,1)=NaN;
                                end
                            end
                            EPM.PlaceField{mm}{sp}.map=NaN;EPM.PlaceFieldRun{mm}{sp}.map=NaN;
                            EPM.PlaceField{mm}{sp}.stats=NaN;EPM.PlaceFieldRun{mm}{sp}.stats=NaN;
                            EPM.Score{mm}(sp)=NaN;EPM.ScoreRun{mm}(sp)=NaN;
                            EPM.ModInd{mm}(sp)=NaN;EPM.ModIndRun{mm}(sp)=NaN;
                            EPM.ScoreRand{mm}(sp,1:NumBt)=nan(1,NumBt);EPM.ScoreRandRun{mm}(sp,1:NumBt)=nan(1,NumBt);
                            EPM.ModIndRand{mm}(sp,1:NumBt)=nan(1,NumBt);EPM.ModIndRandRun{mm}(sp,1:NumBt)=nan(1,NumBt);
                            EPM.ModIndSig{mm}(sp)=NaN;EPM.ModIndSigRun{mm}(sp)=NaN;
                            EPM.ScoreSig{mm}(sp)=NaN;EPM.ScoreSigRun{mm}(sp)=NaN;
                        end
                    end
                    
                    spuse=find(not(isnan(EPM.Score{mm})),1,'first');
                    map=EPM.PlaceField{mm}{spuse}.map;
                    XR=Data(Restrict(Behav.Xtsd,RunningEpoch));
                    YR=Data(Restrict(Behav.Ytsd,RunningEpoch));
                    SpR=[0;Data(Restrict(RunSpeed,RunningEpoch))];
                    X=Data(Behav.Xtsd);
                    Y=Data(Behav.Ytsd);
                    Sp=[0;Data(RunSpeed)];
                    AllSpeed=[];AllSpeedR=[];

                    for xx=1:length(map.XAx)-1
                        for yy=1:length(map.YAx)-1
                            id=find(X>map.XAx(xx) & X<map.XAx(xx+1) & Y>map.YAx(yy) & Y<map.YAx(yy+1));
                            idR=find(XR>map.XAx(xx) & XR<map.XAx(xx+1) & YR>map.YAx(yy) & YR<map.YAx(yy+1));
                            if isempty(id) 
                                AllSpeed(xx,yy)=0;
                            else
                                AllSpeed(xx,yy)=nanmean(Sp(id));
                            end 
                            if isempty(idR) 
                                AllSpeedR(xx,yy)=0;
                            else
                                AllSpeedR(xx,yy)=nanmean(SpR(idR));
                            end
                        end
                    end
                    EPM.AllSpeedR{mm}=AllSpeedR;
                    EPM.AllSpeed{mm}=AllSpeed;

                end
                
            end
        end
    end
end
cd('/media/sophie/My Passport/ProjectEmbReac/Figures/March2017')
save('EPMData.mat','EPM')
    