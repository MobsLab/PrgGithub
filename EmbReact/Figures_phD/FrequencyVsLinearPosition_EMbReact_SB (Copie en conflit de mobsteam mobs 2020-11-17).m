clear all
SessNames={'UMazeCond', 'UMazeCondNight',...
    'UMazeCond_EyeShock','UMazeCondBlockedShock_EyeShock','UMazeCondBlockedSafe_EyeShock',...
    'UMazeCondExplo_PreDrug','UMazeCondBlockedSafe_PreDrug','UMazeCondBlockedShock_PreDrug',...
    'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};

MouseToAvoid=[117,431]; % mice with noisy data to exclude

for ss=1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessNames{ss})
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            go=0;
            if isfield(Dir.ExpeInfo{d}{dd},'DrugInjected')
                if strcmp(Dir.ExpeInfo{d}{dd}.DrugInjected,'SAL')
                    go=1;
                end
            else
                go=1;
            end
            
            if go ==1
                cd(Dir.path{d}{dd})
                disp(Dir.path{d}{dd})
                
                load('behavResources_SB.mat')
                load('ExpeInfo.mat')
                MouseNum(ss,d,dd) = ExpeInfo.nmouse;
                
                % Get epochs
                load('StateEpochSB.mat','SleepyEpoch')
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+1.5*1e4);
                RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                if isfield(Behav,'FreezeAccEpoch')
                    if not(isempty(Behav.FreezeAccEpoch))
                        Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                    end
                end
                CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
                CleanNoFreezeEpoch  = (TotalEpoch-Behav.FreezeEpoch)-RemovEpoch;
                SafeZone = and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}));
                ShockZone = and(Behav.FreezeEpoch,Behav.ZoneEpoch{1});
                MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(SafeZone,'s')-Start(SafeZone,'s'));
                MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ShockZone,'s')-Start(ShockZone,'s'));
                MouseByMouse.IsSession{ExpeInfo.nmouse}(ss,dd) = 1;
                
                
                % Linear position
                Result.LinDistTempFz = Restrict(Behav.LinearDist,CleanFreezeEpoch);
                Result.LinDistTempNoFz = Restrict(Behav.LinearDist,CleanNoFreezeEpoch);
                
                % OB frequency
                clear Sptsd LocalFreq
                load('InstFreqAndPhase_B.mat','LocalFreq')
                % smooth the estimates
                WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                
                Result.LocalFreqPTFz = (Restrict(LocalFreq.PT,Result.LinDistTempFz,'align','closest'));
                Result.LocalFreqWVFz = (Restrict(LocalFreq.WV,Result.LinDistTempFz,'align','closest'));
                Result.LocalFreqPTNoFz = (Restrict(LocalFreq.PT,Result.LinDistTempNoFz,'align','closest'));
                Result.LocalFreqWVNoFz = (Restrict(LocalFreq.WV,Result.LinDistTempNoFz,'align','closest'));
                MouseByMouse.FreqShock{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,ShockZone)))+nanmean(Data(Restrict(LocalFreq.WV,ShockZone))))/2;
                MouseByMouse.FreqSafe{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,SafeZone)))+nanmean(Data(Restrict(LocalFreq.WV,SafeZone))))/2;
                
                
                % Ob spec
                clear Spectro
                load('B_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                Result.OBSpecFz = (Restrict(Sptsd,Result.LinDistTempFz,'align','closest'));
                MouseByMouse.OBShock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                MouseByMouse.OBSafe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                
                % HPC
                clear Sptsd LocalFreq
                load('InstFreqAndPhase_H.mat','LocalFreq')
                % smooth the estimates
                WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                
                Result.LocalFreqHPTFz = (Restrict(LocalFreq.PT,Result.LinDistTempFz,'align','closest'));
                Result.LocalFreqHWVFz = (Restrict(LocalFreq.WV,Result.LinDistTempFz,'align','closest'));
                Result.LocalFreqHPTNoFz = (Restrict(LocalFreq.PT,Result.LinDistTempNoFz,'align','closest'));
                Result.LocalFreqHWVNoFz = (Restrict(LocalFreq.WV,Result.LinDistTempNoFz,'align','closest'));
                MouseByMouse.FreqShockH{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,ShockZone)))+nanmean(Data(Restrict(LocalFreq.WV,ShockZone))))/2;
                MouseByMouse.FreqSafeH{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,SafeZone)))+nanmean(Data(Restrict(LocalFreq.WV,SafeZone))))/2;
                
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_rip');
                elseif exist('ChannelsToAnalyse/dHPC_deep.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_deep');
                elseif exist('ChannelsToAnalyse/dHPC_sup.mat')>0
                    [Sp,t,f]=LoadSpectrumML('dHPC_sup');
                end
                Sptsd=tsd(t*1e4,Sp);
                MouseByMouse.HPCShock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                MouseByMouse.HPCSafe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                
                
                PowerThetaTemp = nanmean(Sp(:,find(f<5.5,1,'last'):find(f<7.5,1,'last'))')';
                PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
                tpsToRem = Range(Restrict(Behav.Vtsd,RemovEpoch));
                c = ismember(Range(Behav.Vtsd),tpsToRem);
                PowerThetaTemp(find(c)) = NaN;
                PowerThetaSlow = tsd(Range(Behav.Vtsd),PowerThetaTemp);
                Result.ThetaPowerSlow = (Restrict(PowerThetaSlow,Result.LinDistTempFz,'align','closest'));
                
                PowerThetaTemp = nanmean(Sp(:,find(f<7.5,1,'last'):find(f<10,1,'last'))')';
                PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
                PowerThetaTemp(find(c)) = NaN;
                PowerThetaFast = tsd(Range(Behav.Vtsd),PowerThetaTemp);
                Result.ThetaPowerFast = (Restrict(PowerThetaFast,Result.LinDistTempFz,'align','closest'));
                

                PowerThetaTemp = nanmean(Sp(:,find(f<1.5,1,'last'):end)')';
                PowerThetaTemp = interp1(Range(Sptsd),PowerThetaTemp,Range(Behav.Vtsd));
                PowerThetaTemp(find(c)) = NaN;
                PowerThetaAll = tsd(Range(Behav.Vtsd),PowerThetaTemp);
                Result.ThetaPowerAll = (Restrict(PowerThetaAll,Result.LinDistTempFz,'align','closest'));
                MouseByMouse.HPCThetaPowerShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(PowerThetaSlow,ShockZone)))./nanmean(Data(Restrict(PowerThetaAll,ShockZone)));
                MouseByMouse.HPCThetaPowerSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(PowerThetaSlow,SafeZone)))./nanmean(Data(Restrict(PowerThetaAll,SafeZone)));

                
                for k = 1:4
                    LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/4,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/4,'Direction','Below'));
                    LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                    FinalResults.HPCPower{ss}{d}{dd}(k,1) = nanmean(Data(Restrict(PowerThetaSlow,LittleEpoch)));
                    FinalResults.HPCPower{ss}{d}{dd}(k,2) = nanmean(Data(Restrict(PowerThetaFast,LittleEpoch)));
                    FinalResults.HPCPower{ss}{d}{dd}(k,3) = nanmean(Data(Restrict(PowerThetaAll,LittleEpoch)));
                end
                for k = 1:10
                    LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/10,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/10,'Direction','Below'));
                    LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                    FinalResults.HPCPower10{ss}{d}{dd}(k,1) = nanmean(Data(Restrict(PowerThetaSlow,LittleEpoch)));
                    FinalResults.HPCPower10{ss}{d}{dd}(k,2) = nanmean(Data(Restrict(PowerThetaFast,LittleEpoch)));
                    FinalResults.HPCPower10{ss}{d}{dd}(k,3) = nanmean(Data(Restrict(PowerThetaAll,LittleEpoch)));
                end

                
                
                % Ripple density
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    clear RipplesEpochR
                    load('Ripples.mat')
                    [Y,X] = hist(Start(RipplesEpochR)/1e4,Range(Behav.LinearDist,'s'));
                    Y = Y./diff([0;X]');
                    Rippletsd = tsd(Range(Behav.LinearDist),Y');
                    Result.RippleFz = (Restrict(Rippletsd,Result.LinDistTempFz,'align','closest'));
                    for k = 1:4
                        LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/4,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/4,'Direction','Below'));
                        LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                        FinalResults.RipCount{ss}{d}{dd}(k,1) = nansum(Stop(LittleEpoch,'s')-Start(LittleEpoch,'s'));
                        FinalResults.RipCount{ss}{d}{dd}(k,2) = length(Start(and(RipplesEpochR,LittleEpoch)));
                    end
                    for k = 1:10
                        LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/10,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/10,'Direction','Below'));
                        LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                        FinalResults.RipCount10{ss}{d}{dd}(k,1) = nansum(Stop(LittleEpoch,'s')-Start(LittleEpoch,'s'));
                        FinalResults.RipCount10{ss}{d}{dd}(k,2) = length(Start(and(RipplesEpochR,LittleEpoch)));
                    end
                    MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,ShockZone)));
                    MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,SafeZone)));
                else
                    Result.RippleFz = tsd(Range(Result.LinDistTempFz),nan(length(Range(Result.LinDistTempFz)),1));
                    RipShock(ss,d,dd) = NaN;
                    RipSafe(ss,d,dd) =NaN;
                    FinalResults.RipCount{ss}{d}{dd}(1:4,1:2)=nan(4,2);
                    FinalResults.RipCount10{ss}{d}{dd}(1:10,1:2)=nan(10,2);
                    MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                end
                
                % Heart rate and heart rate variability in and out of freezing
                if exist('HeartBeatInfo.mat')>0
                    clear EKG
                    load('HeartBeatInfo.mat')
                    % HR
                    HR_temp = Restrict(EKG.HBRate,CleanFreezeEpoch);
                    Result.HRtsdFz = (Restrict(HR_temp,Result.LinDistTempFz,'align','closest'));
                    HR_temp = Restrict(EKG.HBRate,CleanNoFreezeEpoch);
                    Result.HRtsdNoFz = (Restrict(HR_temp,Result.LinDistTempNoFz,'align','closest'));
                    % HRvar
                    HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                    HRVar_temp = Restrict(HRVar,CleanFreezeEpoch);
                    Result.HRVartsdFz = (Restrict(HRVar_temp,Result.LinDistTempFz,'align','closest'));
                    HRVar_temp = Restrict(HRVar,CleanNoFreezeEpoch);
                    Result.HRVartsdNoFz = (Restrict(HRVar_temp,Result.LinDistTempNoFz,'align','closest'));
                    for k = 1:4
                        LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/4,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/4,'Direction','Below'));
                        LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                        FinalResults.HR{ss}{d}{dd}(k,1) = nansum(Stop(LittleEpoch,'s')-Start(LittleEpoch,'s'));
                        FinalResults.HR{ss}{d}{dd}(k,2) = nanmean(Data(Restrict(EKG.HBRate,LittleEpoch)));
                        FinalResults.HR{ss}{d}{dd}(k,3) = nanmean(Data(Restrict(HRVar,LittleEpoch)));
                    end
                    for k = 1:10
                        LittleEpoch = and(thresholdIntervals(Behav.LinearDist,(k-1)/10,'Direction','Above'),thresholdIntervals(Behav.LinearDist,k/10,'Direction','Below'));
                        LittleEpoch = and(Behav.FreezeEpoch,LittleEpoch);
                        FinalResults.HR10{ss}{d}{dd}(k,1) = nansum(Stop(LittleEpoch,'s')-Start(LittleEpoch,'s'));
                        FinalResults.HR10{ss}{d}{dd}(k,2) = nanmean(Data(Restrict(EKG.HBRate,LittleEpoch)));
                        FinalResults.HR10{ss}{d}{dd}(k,3) = nanmean(Data(Restrict(HRVar,LittleEpoch)));
                    end
                    MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,ShockZone)));
                    MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,SafeZone)));
                    MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,ShockZone)));
                    MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,SafeZone)));
                    
                else
                    Result.HRtsdFz = tsd(Range(Result.LinDistTempFz),nan(length(Range(Result.LinDistTempFz)),1));
                    Result.HRtsdNoFz = tsd(Range(Result.LinDistTempFz),nan(length(Range(Result.LinDistTempFz)),1));
                    Result.HRVartsdFz = tsd(Range(Result.LinDistTempFz),nan(length(Range(Result.LinDistTempFz)),1));
                    Result.HRVartsdNoFz = tsd(Range(Result.LinDistTempFz),nan(length(Range(Result.LinDistTempFz)),1));
                    FinalResults.HR{ss}{d}{dd}(1:4,1) = NaN;
                    FinalResults.HR{ss}{d}{dd}(1:4,2) = NaN;
                    FinalResults.HR{ss}{d}{dd}(1:4,3) = NaN;
                    FinalResults.HR10{ss}{d}{dd}(1:10,1) = NaN;
                    FinalResults.HR10{ss}{d}{dd}(1:10,2) = NaN;
                    FinalResults.HR10{ss}{d}{dd}(1:10,3) = NaN;
                    MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                    
                end
                
                % Speed out of freezing
                Result.Speed = (Restrict(Behav.Vtsd,Result.LinDistTempNoFz,'align','closest'));
                
                % Store variables
                Fld = fieldnames(Result);
                for name = 1:length(Fld)
                    FinalResults.(Fld{name}){ss}{d}{dd} = Data(Result.(Fld{name}));
                end
                clear Result
                
            end
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
save('AllSessionTypesWiHPC.mat','FinalResults','SessNames','MouseNum','MouseByMouse')
%
% clear all
% load('AllSessionTypes.mat')
AllDataTime=[];AllDataRipNum=[];

for ss=1:length(SessNames)
    for d=1:length(FinalResults.RipCount10{ss})
        Temp1=[];
        Temp2=[];
        
        for dd=1:length(FinalResults.RipCount10{ss}{d})
            Temp1 = [Temp1,FinalResults.RipCount10{ss}{d}{dd}(:,1)];
            Temp2 = [Temp2,FinalResults.RipCount10{ss}{d}{dd}(:,2)];
            
        end
        if not(isempty(Temp1))
            AllDataTime = [AllDataTime,nanmean(Temp1')'];
            AllDataRipNum = [AllDataRipNum,nanmean(Temp2')'];
        end
    end
end

AllData1=[];AllDataHR=[];AllDataHRVar=[];

for ss=1:length(SessNames)
    for d=1:length(FinalResults.HR10{ss})
        Temp1=[];
        Temp2=[];
        Temp3=[];
        
        for dd=1:length(FinalResults.HR10{ss}{d})
            Temp1 = [Temp1,FinalResults.HPCPower10{ss}{d}{dd}(:,1)];
            Temp2 = [Temp2,FinalResults.HR10{ss}{d}{dd}(:,2)];
            Temp3 = [Temp3,FinalResults.HR10{ss}{d}{dd}(:,3)];
        end
        if not(isempty(Temp1))
            A  = nanmean(Temp1')';
            A(A==0) = NaN;
            AllData1 = [AllData1,A];
            A  = nanmean(Temp2')';
            A(A==0) = NaN;
            AllDataHR = [AllDataHR,A];
            A  = nanmean(Temp3')';
            A(A==0) = NaN;
            AllDataHRVar = [AllDataHRVar,A];
            
        end
    end
end

AllDataHighTheta=[];AllDataLowTheta=[];AllDataAllTheta=[];

for ss=1:length(SessNames)
    for d=1:length(FinalResults.HPCPower10{ss})
        Temp1=[];
        Temp2=[];
        Temp3=[];
        
        for dd=1:length(FinalResults.HR10{ss}{d})
            Temp1 = [Temp1,FinalResults.HPCPower10{ss}{d}{dd}(:,1)];
            Temp2 = [Temp2,FinalResults.HPCPower10{ss}{d}{dd}(:,2)];
            Temp3 = [Temp3,FinalResults.HPCPower10{ss}{d}{dd}(:,3)];
        end
        if not(isempty(Temp1))
            A  = nanmean(Temp1')';
            A(A==0) = NaN;
            AllDataLowTheta = [AllDataLowTheta,A];
            A  = nanmean(Temp2')';
            A(A==0) = NaN;
            AllDataHighTheta = [AllDataHighTheta,A];
            A  = nanmean(Temp3')';
            A(A==0) = NaN;
            AllDataAllTheta = [AllDataAllTheta,A];
            
        end
    end
end
clear B A
A = ((AllDataLowTheta./AllDataAllTheta));
for k = 1 : 10
    B(k,1:size(A,2)) = k;
end
A = A(:);
B = B(:);
allnan = find(or(isnan(A),isnan(B)));
A(allnan) = [];
B(allnan) = [];




Lintemp=[];
FreqTempPT=[];
FreqTempWV=[];
RipTemp=[];
HRTemp = [];
HRVarTemp = [];
LintempNoFz = [];
HRTempNoFz = [];
HRVarTempNoFz = [];
Speed = [];
SpecTemp = [];
ThetaPowerFast = [];
ThetaPowerSlow = [];

% SessNames={'UMazeCond', 'UMazeCondNight','UMazeCond_EyeShock','UMazeCondExplo_PreDrug',...
%     'UMazeCondBlockedSafe_PreDrug','UMazeCondBlockedShock_PreDrug',...
%     'UMazeCondExplo_PostDrug' 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};

for ss=1:length(SessNames)
    ss
    for d=1:length(FinalResults.LinDistTempFz{ss})
        SpecTemptemp = [];
        for dd=1:length(FinalResults.LinDistTempFz{ss}{d})
            
            Lintemp = [Lintemp;FinalResults.LinDistTempFz{ss}{d}{dd}];
            FreqTempPT = [FreqTempPT;FinalResults.LocalFreqPTFz{ss}{d}{dd}];
            FreqTempWV = [FreqTempWV;FinalResults.LocalFreqWVFz{ss}{d}{dd}];
            SpecTemptemp = [SpecTemptemp;FinalResults.OBSpecFz{ss}{d}{dd}];
            RipTemp = [RipTemp;FinalResults.RippleFz{ss}{d}{dd}];
            HRTemp = [HRTemp;FinalResults.HRtsdFz{ss}{d}{dd}];
            HRVarTemp = [HRVarTemp;FinalResults.HRVartsdFz{ss}{d}{dd}];
            
            ThetaPowerFast = [ThetaPowerFast;FinalResults.ThetaPowerFast{ss}{d}{dd}];
            ThetaPowerSlow = [ThetaPowerSlow;FinalResults.ThetaPowerSlow{ss}{d}{dd}./FinalResults.ThetaPowerFast{ss}{d}{dd}];
            
            
            LintempNoFz = [LintempNoFz;FinalResults.LinDistTempNoFz{ss}{d}{dd}];
            HRTempNoFz = [HRTempNoFz;FinalResults.HRtsdNoFz{ss}{d}{dd}];
            HRVarTempNoFz = [HRVarTempNoFz;FinalResults.HRVartsdNoFz{ss}{d}{dd}];
            Speed = [Speed;FinalResults.Speed{ss}{d}{dd}];
            
            
            
        end
        SpecTemptemp=SpecTemptemp./nanmean(nanmean(SpecTemptemp));
        SpecTemp=[SpecTemp;SpecTemptemp];
    end
    
end


NumLims=20;
Fr=[0:0.25:20];
clear MeanFreqPT MeanSpec Occup MaxValPT MaxValWV MaxValSpec MeanFreqWV XAx
for k=1:NumLims
    Bins=find(Lintemp>(k-1)*1/NumLims & Lintemp<=(k)*1/NumLims);
    Occup(k)=length(Bins);
    RipDens(k,:)=nanmean(RipTemp(Bins));
    HR_Lin(k,:)=nanmedian(HRTemp(Bins));
    HRVar_Lin(k,:)=nanstd(HRVarTemp(Bins));
    ThetaPowerFast_Lin(k,:)=nanmean(ThetaPowerFast(Bins));
    ThetaPowerSlow_Lin(k,:)=nanmean(ThetaPowerSlow(Bins));

    [Y,X] = hist(nanmean([FreqTempPT(Bins),FreqTempWV(Bins)]')',Fr);
    Y = Y/nansum(Y);
    MeanFreqPTWV(k,:)= Y;

    XAx(k)=((k-1)*1/NumLims+k*1/NumLims)/2;
end
Bin = 1/NumLims;

%% All variables
figure
clf
ha = tight_subplot(5,1,[.03 .1],[.07 .01],[.15 .05]);
axes(ha(1))
[val,ind] = max(SmoothDec(zscore(MeanFreqPTWV'),[1,2]));
imagesc(0:0.1:1,Fr,SmoothDec(zscore(MeanFreqPTWV(1:20,:)'),[1,2])); axis xy, ylim([0 10]), hold on
plot([Bin:Bin:1]-Bin/2,Fr(ind),'.-k')
ylabel('Frequency (Hz)')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
box off
% [R,P] = corrcoef(Bin:Bin:1,Fr(ind));
% text(0.7,9.5,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,8,['P=',num2str(P(1,2))])

NewX = [1:4,7,10];
axes(ha(2))
RipNum = AllDataRipNum;
Time = AllDataTime;
RipNum(Time==0) = NaN;
Time(Time==0) = NaN;
RipNum = RipNum([1:4,7,10],:);
Time = Time([1:4,7,10],:);
A = RipNum'./Time';
B = RipNum'./Time';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(RipNum'./Time'),stdError(RipNum'./Time'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Rippes /sec')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([0 0.5])
% [R,P]=corrcoef(A(:),B(:));HeightForCols(2) = 0.7;
% text(0.7,0.15,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,0.1,['P=',num2str(P(1,2))])

axes(ha(3))
A = AllDataHR([1:4,7,10],:)';
B = AllDataHR([1:4,7,10],:)';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(AllDataHR([1:4,7,10],:)'),stdError(AllDataHR([1:4,7,10],:)'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Heart Rate (Hz)')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([10 12.5])
% [R,P]=corrcoef(A(:),B(:));HeightForCols(2) = 0.7;
% HeightForCols(3) = 12.2;
% text(0.7,11.7,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,11.4,['P=',num2str(P(1,2))])

axes(ha(4))
A = AllDataHRVar([1:4,7,10],:)';
B = AllDataHRVar([1:4,7,10],:)';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(AllDataHRVar([1:4,7,10],:)'),stdError(AllDataHRVar([1:4,7,10],:)'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Heart Rate variability')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([0.1 0.32])
% [R,P]=corrcoef(A(:),B(:));
% text(0.7,0.34,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,0.3,['P=',num2str(P(1,2))])

axes(ha(5))
bar(XAx,Occup./sum(Occup),'FaceColor','k')
box off
xlabel('Dist to shock norm.')
ylabel('% time spent')
set(gca,'LineWidth',2,'FontSize',10)


cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Habituation
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];
load('behavResources_SB.mat')
axes(ha(1))

hold on
for z=1:5
    hold on
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[9 9],'color','w','linewidth',8)
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[9 9],'color',cols(z,:),'linewidth',5)
end

% all vraiables except OB
    figure
clf
ha = tight_subplot(5,1,[.03 .1],[.07 .01],[.15 .05]);

NewX = [1:4,7,10];
axes(ha(1))
RipNum = AllDataRipNum;
Time = AllDataTime;
RipNum(Time==0) = NaN;
Time(Time==0) = NaN;
RipNum = RipNum([1:4,7,10],:);
Time = Time([1:4,7,10],:);
A = RipNum'./Time';
B = RipNum'./Time';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(RipNum'./Time'),stdError(RipNum'./Time'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Rippes /sec')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([0 0.5])
% [R,P]=corrcoef(A(:),B(:));HeightForCols(2) = 0.7;
% text(0.7,0.15,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,0.1,['P=',num2str(P(1,2))])

axes(ha(2))
A = AllDataHR([1:4,7,10],:)';
B = AllDataHR([1:4,7,10],:)';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(AllDataHR([1:4,7,10],:)'),stdError(AllDataHR([1:4,7,10],:)'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Heart Rate (Hz)')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([10 12.5])
% [R,P]=corrcoef(A(:),B(:));HeightForCols(2) = 0.7;
% HeightForCols(3) = 12.2;
% text(0.7,11.7,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,11.4,['P=',num2str(P(1,2))])

axes(ha(3))
A = AllDataHRVar([1:4,7,10],:)';
B = AllDataHRVar([1:4,7,10],:)';
for k = 1:6
    A(:,k) = NewX(k);
end
A(isnan(B))=[];
B(isnan(B))=[];
% plot(A/10-0.05,B,'.','color',[0.6 0.6 0.6])
% hold on
errorbar([1:4,7,10]/10-0.05,nanmean(AllDataHRVar([1:4,7,10],:)'),stdError(AllDataHRVar([1:4,7,10],:)'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Heart Rate variability')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([0.1 0.32])
% [R,P]=corrcoef(A(:),B(:));
% text(0.7,0.34,['R=',num2str(R(1,2),'%.2f')])
% text(0.7,0.3,['P=',num2str(P(1,2))])

axes(ha(4))
A = ((AllDataLowTheta./AllDataAllTheta));
errorbar([1:10]/10-0.05,nanmean(A'),stdError(A'),'linewidth',3,'color','k')
xlim([0 1])
box off
ylabel('Slow theta power')
set(gca,'LineWidth',2,'FontSize',10,'XTickLabel',{})
ylim([1 3])

axes(ha(5))
bar(XAx,Occup./sum(Occup),'FaceColor','k')
box off
xlabel('Dist to shock norm.')
ylabel('% time spent')
set(gca,'LineWidth',2,'FontSize',10)

cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Habituation
load('B_Low_Spectrum.mat')
fLow = Spectro{3};
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];
load('behavResources_SB.mat')
axes(ha(1))

hold on
for z=1:5
    hold on
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[0.45 0.45],'color','w','linewidth',8)
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[0.45 0.45],'color',cols(z,:),'linewidth',5)
end

    
%% Mouse averaged results
AllMice = unique(MouseNum);
AllMice(1) = [];
clear RipShock RipSafe HRShock HRSafe
for m=1:length(AllMice)
    
    % Ripple shock
    RipShockTemp = squeeze(MouseByMouse.RippleShock{AllMice(m)});
    RipShockTemp = RipShockTemp(:);
    RipShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    RipShockTempTime = RipShockTempTime(:);
    RipShockTemp(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
    RipShockTempTime(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
    RipFreq = RipShockTemp./RipShockTempTime;
    % weighted mean according to time spent;
    RipShock(m) = RipFreq'*RipShockTempTime/sum(RipShockTempTime);
    
    % Ripple safe
    RipSafeTemp = squeeze(MouseByMouse.RippleSafe{AllMice(m)});
    RipSafeTemp = RipSafeTemp(:);
    RipSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    RipSafeTempTime = RipSafeTempTime(:);
    RipSafeTemp(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
    RipSafeTempTime(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
    RipFreq = RipSafeTemp./RipSafeTempTime;
    % weighted mean according to time spentsum
    RipSafe(m) = RipFreq'*RipSafeTempTime/norm(RipSafeTempTime);
    
    % HR shock
    HRShockTemp = squeeze(MouseByMouse.HRShock{AllMice(m)});
    HRShockTemp = HRShockTemp(:);
    HRShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    HRShockTempTime = HRShockTempTime(:);
    HRShockTemp(isnan(HRShockTempTime)|(HRShockTempTime==0)) = [];
    HRShockTempTime(isnan(HRShockTempTime)|(HRShockTempTime==0)) = [];
    HRShock(m) = HRShockTemp'*HRShockTempTime/sum(HRShockTempTime);
    
    % HR Safe
    HRSafeTemp = squeeze(MouseByMouse.HRSafe{AllMice(m)});
    HRSafeTemp = HRSafeTemp(:);
    HRSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    HRSafeTempTime = HRSafeTempTime(:);
    HRSafeTemp(isnan(HRSafeTempTime)|(HRSafeTempTime==0)) = [];
    HRSafeTempTime(isnan(HRSafeTempTime)|(HRSafeTempTime==0)) = [];
    HRSafe(m) = HRSafeTemp'*HRSafeTempTime/sum(HRSafeTempTime);
    
    % HRVar shock
    HRVarShockTemp = squeeze(MouseByMouse.HRVarShock{AllMice(m)});
    HRVarShockTemp = HRVarShockTemp(:);
    HRVarShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    HRVarShockTempTime = HRVarShockTempTime(:);
    HRVarShockTemp(isnan(HRVarShockTempTime)|(HRVarShockTempTime==0)) = [];
    HRVarShockTempTime(isnan(HRVarShockTempTime)|(HRVarShockTempTime==0)) = [];
    HRVarShock(m) = HRVarShockTemp'*HRVarShockTempTime/sum(HRVarShockTempTime);
    
    % HRVar Safe
    HRVarSafeTemp = squeeze(MouseByMouse.HRVarSafe{AllMice(m)});
    HRVarSafeTemp = HRVarSafeTemp(:);
    HRVarSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    HRVarSafeTempTime = HRVarSafeTempTime(:);
    HRVarSafeTemp(isnan(HRVarSafeTempTime)|(HRVarSafeTempTime==0)) = [];
    HRVarSafeTempTime(isnan(HRVarSafeTempTime)|(HRVarSafeTempTime==0)) = [];
    HRVarSafe(m) = HRVarSafeTemp'*HRVarSafeTempTime/sum(HRVarSafeTempTime);
    
    % Spec
    OBSPecShockTemp = MouseByMouse.OBShock{AllMice(m)};
    OBSPecShockTemp = reshape(OBSPecShockTemp,[size(OBSPecShockTemp,1)*size(OBSPecShockTemp,2),261]);
    OBSPecShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    OBSPecShockTempTime = OBSPecShockTempTime(:);
    OBSPecShockTemp(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0),:) = [];
    OBSPecShockTempTime(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0)) = [];
    OBSPecShock(m,:) = OBSPecShockTemp'*OBSPecShockTempTime/sum(OBSPecShockTempTime);
    TimeShock(m) = nansum(OBSPecShockTempTime);
    
    % safe
    OBSPecSafeTemp = MouseByMouse.OBSafe{AllMice(m)};
    OBSPecSafeTemp = reshape(OBSPecSafeTemp,[size(OBSPecSafeTemp,1)*size(OBSPecSafeTemp,2),261]);
    OBSPecSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    OBSPecSafeTempTime = OBSPecSafeTempTime(:);
    OBSPecSafeTemp(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0),:) = [];
    OBSPecSafeTempTime(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0)) = [];
    OBSPecSafe(m,:) = (OBSPecSafeTemp'*OBSPecSafeTempTime/sum(OBSPecSafeTempTime));
    TimeSafe(m) = nansum(OBSPecSafeTempTime);
    
    % FreqOB shock
    FreqOBShockTemp = squeeze(MouseByMouse.FreqShock{AllMice(m)});
    FreqOBShockTemp = FreqOBShockTemp(:);
    FreqOBShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    FreqOBShockTempTime = FreqOBShockTempTime(:);
    FreqOBShockTemp(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
    FreqOBShockTempTime(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
    FreqOBShock(m) = FreqOBShockTemp'*FreqOBShockTempTime/sum(FreqOBShockTempTime);
    
    % FreqOB safe
    FreqOBSafeTemp = squeeze(MouseByMouse.FreqSafe{AllMice(m)});
    FreqOBSafeTemp = FreqOBSafeTemp(:);
    FreqOBSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    FreqOBSafeTempTime = FreqOBSafeTempTime(:);
    FreqOBSafeTemp(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    FreqOBSafeTempTime(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    FreqOBSafe(m) = FreqOBSafeTemp'*FreqOBSafeTempTime/sum(FreqOBSafeTempTime);
    
    % Theta power shock
    FreqOBSafeTemp = squeeze(MouseByMouse.HPCThetaPowerShock{AllMice(m)});
    FreqOBSafeTemp = FreqOBSafeTemp(:);
    FreqOBSafeTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
    FreqOBSafeTempTime = FreqOBSafeTempTime(:);
    FreqOBSafeTemp(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    FreqOBSafeTempTime(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    HPCThetaShock(m) = FreqOBSafeTemp'*FreqOBSafeTempTime/sum(FreqOBSafeTempTime);

    FreqOBSafeTemp = squeeze(MouseByMouse.HPCThetaPowerSafe{AllMice(m)});
    FreqOBSafeTemp = FreqOBSafeTemp(:);
    FreqOBSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
    FreqOBSafeTempTime = FreqOBSafeTempTime(:);
    FreqOBSafeTemp(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    FreqOBSafeTempTime(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
    HPCThetaSafe(m) = FreqOBSafeTemp'*FreqOBSafeTempTime/sum(FreqOBSafeTempTime);

    
end
figure
Legends = {'Shock','Safe'};
Cols = {UMazeColors('shock'),UMazeColors('safe')};

addpath(genpath('/home/gruffalo/Downloads/MatlabToolbox-master'))
figure
clf
ha = tight_subplot(5,1,[.03 .1],[.07 .01],[.15 .05]);
axes(ha(1))
A = {FreqOBShock,FreqOBSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(FreqOBShock,FreqOBSafe);
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('OB Frequency (Hz)')

axes(ha(2))
A = {RipShock,RipSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(RipShock,RipSafe);
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Ripples /sec')

axes(ha(3))
A = {HRShock,HRSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,stats] = signrank(HRShock,HRSafe);
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Heart rate (Hz)')

axes(ha(4))
A = {HRVarShock,HRVarSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(HRVarShock,HRVarSafe);
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Heart rate var')

axes(ha(5))
A = {1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe))};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,stats] = signrank(1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe)));
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1,2],'XTickLabel',{'Shock','Safe'})
ylabel('% freezing time')

% all variables except OB
figure
A = {FreqOBShock,FreqOBSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(FreqOBShock,FreqOBSafe);
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('OB Frequency (Hz)')

figure
ha = tight_subplot(5,1,[.03 .1],[.07 .01],[.15 .05]);

axes(ha(1))
A = {RipShock,RipSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(RipShock,RipSafe);
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Ripples /sec')

axes(ha(2))
A = {HRShock,HRSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,stats] = signrank(HRShock,HRSafe);
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Heart rate (Hz)')

axes(ha(3))
A = {HRVarShock,HRVarSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,~] = signrank(HRVarShock,HRVarSafe);
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('Heart rate var')

axes(ha(4))
A = {HPCThetaShock,HPCThetaSafe};

MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,stats] = signrank(HPCThetaShock,HPCThetaSafe);
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('SlowThetaPoer')

axes(ha(5))
A = {1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe))};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
[p,h,stats] = signrank(1-(TimeSafe./(TimeShock+TimeSafe)),(TimeSafe./(TimeShock+TimeSafe)));
sigstar({{1,2}},p)
xlim([0.5 2.5])
set(gca,'LineWidth',2,'FontSize',10,'XTick',[1,2],'XTickLabel',{'Shock','Safe'})
ylabel('% freezing time')


    % Zoom in on OB
figure
subplot(1,3,1:2)
imagesc(0:0.1:1,Fr,SmoothDec(zscore(MeanFreqPTWV(1:20,:)'),[1,2])); axis xy, ylim([0 10]), hold on
ylim([1 10])
cd /media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161201/ProjectEmbReact_M490_20161201_Habituation
cols=redblue(7);
cols=cols([7,1,3,5,2],:);
cols(3,:)=[0.9,0.7,1];
load('behavResources_SB.mat')

hold on
for z=1:5
    hold on
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[9 9],'color','w','linewidth',8)
    line([min(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z}))) max(Data(Restrict(Behav.LinearDist,Behav.ZoneEpoch{z})))],[9 9],'color',cols(z,:),'linewidth',5)
end
xlim([0 1])
box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('Dist to shock norm.')
ylabel('Frequency (Hz)')

subplot(1,3,3)
g = shadedErrorBar(fLow,nanmean(OBSPecShock),stdError(OBSPecShock));
set(g.patch,'FaceColor',Cols{1},'FaceAlpha',0.5)
set(g.mainLine,'Color',Cols{1},'linewidth',2), hold on
g = shadedErrorBar(fLow,nanmean(OBSPecSafe),stdError(OBSPecSafe));
set(g.patch,'FaceColor',Cols{2},'FaceAlpha',0.3)
set(g.mainLine,'Color',Cols{2},'linewidth',2)
xlim([1 15])
view([90 -90])
xlim([1 10])
box off
set(gca,'LineWidth',2,'FontSize',15)
xlabel('Frequency(Hz)')
ylabel('Power (AU)')

figure
A = {FreqOBShock,FreqOBSafe};
MakeSpreadAndBoxPlot_SB(A,Cols,1:2)
xlim([0.5 2.5])
[p,h,stats] = signrank(FreqOBShock,FreqOBSafe);
sigstar({{1,2}},p)
set(gca,'LineWidth',2,'FontSize',10,'XTick',[])
ylabel('OB Frequency (Hz)')
    



%% HR
AllDataTime=[];AllDataRipNum=[];

for ss=1:length(SessNames)
    for d=1:length(FinalResults.RipCount10{ss})
        Temp1=[];
        Temp2=[];
        
        for dd=1:length(FinalResults.RipCount10{ss}{d})
            Temp1 = [Temp1,nanmean(FinalResults.HRtsdNoFz{ss}{d}{dd}(:,1))];
            
        end
        if not(isempty(Temp1))
            AllDataRipNum = [AllDataRipNum,nanmean(Temp1')'];
        end
    end
end

 