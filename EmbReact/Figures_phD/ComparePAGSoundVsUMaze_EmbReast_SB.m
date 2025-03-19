clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MouseToAvoid=[117,431,795]; % mice with noisy data to exclude

% Everything Together
SessionType{1} =  {'SoundTest'};
Name{1} = 'SoundTest';
% PAG Only
SessionType{2} =  {'UMazeCond'};
Name{2} = 'PagDay';

SaveLocation = '/media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice';

SOI = 1;
clear MouseByMouse
for ss=1:length(SessionType{SOI})
    Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessionType{SOI}{ss})
    for d=1:length(Dir.path)
        MouseByMouse.IsSessionSound{Dir.ExpeInfo{d}{1}.nmouse} = nan(length(SessionType{SOI}{ss}),length(Dir.path{d}));
    end
end

disp(SessionType{SOI}{ss})
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
            clear TTLInfo SleepyEpoch Behav
            
            load('behavResources_SB.mat')
            load('ExpeInfo.mat')
            MouseNumSound(ss,d,dd) = ExpeInfo.nmouse;
            
            % Get epochs
            load('StateEpochSB.mat','SleepyEpoch')
            load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
            TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
            RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
            TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            if isfield(Behav,'FreezeAccEpoch')
                if not(isempty(Behav.FreezeAccEpoch))
                    Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                end
            end
            CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
            CleanNoFreezeEpoch  = (TotalEpoch-Behav.FreezeEpoch)-RemovEpoch;
            
            MouseByMouse.DurSound{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(CleanFreezeEpoch,'s')-Start(CleanFreezeEpoch,'s'));
            MouseByMouse.IsSessionSound{ExpeInfo.nmouse}(ss,dd) = 1;
            
            % OB frequency
            clear LocalFreq
            load('InstFreqAndPhase_B.mat','LocalFreq')
            % smooth the estimates
            WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.Vtsd));
            LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
            LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
            
            MouseByMouse.FreqSound{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,CleanFreezeEpoch)))+nanmean(Data(Restrict(LocalFreq.WV,CleanFreezeEpoch))))/2;
            
            % Ob spec
            clear Spectro
            load('B_Low_Spectrum.mat')
            Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
            MouseByMouse.OBSound{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,CleanFreezeEpoch)));
            fLow = Spectro{3};
            
            % Ripple density
            if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                clear RipplesEpochR
                load('Ripples.mat')
                MouseByMouse.RippleSound{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,CleanFreezeEpoch)));
            else
                MouseByMouse.RippleSound{ExpeInfo.nmouse}(ss,dd) = NaN;
            end
            
            % Heart rate and heart rate variability in and out of freezing
            if exist('HeartBeatInfo.mat')>0
                clear EKG
                load('HeartBeatInfo.mat')
                HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                MouseByMouse.HRSound{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,CleanFreezeEpoch)));
                MouseByMouse.HRVarSound{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,CleanFreezeEpoch)));
                
            else
                MouseByMouse.HRSound{ExpeInfo.nmouse}(ss,dd) = NaN;
                MouseByMouse.HRVarSound{ExpeInfo.nmouse}(ss,dd) = NaN;
                
            end
        end
    end
end


SOI = 2;
for ss=1:length(SessionType{SOI})
    Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessionType{SOI}{ss})
    for d=1:length(Dir.path)
        MouseByMouse.IsSession{Dir.ExpeInfo{d}{1}.nmouse} = nan(length(SessionType{SOI}{ss}),length(Dir.path{d}));
    end
end

for ss=1:length(SessionType{SOI})
    Dir=PathForExperimentsEmbReact(SessionType{SOI}{ss});
    Dir=RemoveElementsFromDir(Dir,'nmouse',MouseToAvoid);
    disp(SessionType{SOI}{ss})
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
                clear TTLInfo
                load('behavResources_SB.mat')
                load('ExpeInfo.mat')
                MouseNum(ss,d,dd) = ExpeInfo.nmouse;
                
                % Get epochs
                load('StateEpochSB.mat','SleepyEpoch')
                load('StateEpochSB.mat','TotalNoiseEpoch','SleepyEpoch')
                TTLInfo.StimEpoch=intervalSet(Start(TTLInfo.StimEpoch)-0.5*1e4,Stop(TTLInfo.StimEpoch)+2.5*1e4);
                RemovEpoch=or(or(TTLInfo.StimEpoch,TotalNoiseEpoch),SleepyEpoch);
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                if isfield(Behav,'FreezeAccEpoch')
                    if not(isempty(Behav.FreezeAccEpoch))
                        Behav.FreezeEpoch = Behav.FreezeAccEpoch;
                    end
                end
                CleanFreezeEpoch  = Behav.FreezeEpoch-RemovEpoch;
                CleanNoFreezeEpoch  = (TotalEpoch-Behav.FreezeEpoch)-RemovEpoch;
                SafeZone = and(Behav.FreezeEpoch,or(Behav.ZoneEpoch{2},Behav.ZoneEpoch{5}))-RemovEpoch;
                ShockZone = and(Behav.FreezeEpoch,Behav.ZoneEpoch{1})-RemovEpoch;
                
                MouseByMouse.DurSafe{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(SafeZone,'s')-Start(SafeZone,'s'));
                MouseByMouse.DurShock{ExpeInfo.nmouse}(ss,dd) = nansum(Stop(ShockZone,'s')-Start(ShockZone,'s'));
                MouseByMouse.IsSession{ExpeInfo.nmouse}(ss,dd) = 1;
                
                MouseByMouse.SpeedSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,SafeZone)));
                MouseByMouse.SpeedShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,ShockZone)));
                MouseByMouse.SpeedNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeEpoch)));
                
                
                try
                    MouseByMouse.MovSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,SafeZone)));
                    MouseByMouse.MovShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,ShockZone)));
                    MouseByMouse.MovNoFz{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(Behav.MovAcctsd,TotalEpoch-Behav.FreezeEpoch)));
                    if nanmean(Data(Restrict(Behav.MovAcctsd,ShockZone)))>9e6
                        keyboard
                    end
                catch
                    MouseByMouse.MovSafe{ExpeInfo.nmouse}(ss,dd)  = NaN;
                    MouseByMouse.MovShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.MovNoFz{ExpeInfo.nmouse}(ss,dd) = NaN;
                end
                
                % OB frequency
                clear LocalFreq
                load('InstFreqAndPhase_B.mat','LocalFreq')
                % smooth the estimates
                WVBinsize = length(Range(LocalFreq.WV))./length(Range(Behav.LinearDist));
                LocalFreq.WV = tsd(Range(LocalFreq.WV),movmedian(Data(LocalFreq.WV),ceil(WVBinsize)*2));
                LocalFreq.PT = tsd(Range(LocalFreq.PT),movmedian(Data(LocalFreq.PT),4));
                
                MouseByMouse.FreqShock{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,ShockZone)))+nanmean(Data(Restrict(LocalFreq.WV,ShockZone))))/2;
                MouseByMouse.FreqSafe{ExpeInfo.nmouse}(ss,dd,:) = (nanmean(Data(Restrict(LocalFreq.PT,SafeZone)))+nanmean(Data(Restrict(LocalFreq.WV,SafeZone))))/2;
                
                % Ob spec
                clear Spectro
                load('B_Low_Spectrum.mat')
                Sptsd=tsd(Spectro{2}*1e4,Spectro{1});
                MouseByMouse.OBShock{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,ShockZone)));
                MouseByMouse.OBSafe{ExpeInfo.nmouse}(ss,dd,:) = nanmean(Data(Restrict(Sptsd,SafeZone)));
                fLow = Spectro{3};
                
                % Ripple density
                if exist('ChannelsToAnalyse/dHPC_rip.mat')>0
                    clear RipplesEpochR
                    load('Ripples.mat')
                    MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,ShockZone)));
                    MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = length(Start(and(RipplesEpochR,SafeZone)));
                else
                    MouseByMouse.RippleShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.RippleSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                end
                
                % Heart rate and heart rate variability in and out of freezing
                if exist('HeartBeatInfo.mat')>0
                    clear EKG
                    load('HeartBeatInfo.mat')
                    HRVar = tsd(Range(EKG.HBRate),movstd(Data(EKG.HBRate),5));
                    MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,ShockZone)));
                    MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(EKG.HBRate,SafeZone)));
                    MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,ShockZone)));
                    MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = nanmean(Data(Restrict(HRVar,SafeZone)));
                    
                else
                    MouseByMouse.HRShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRVarShock{ExpeInfo.nmouse}(ss,dd) = NaN;
                    MouseByMouse.HRVarSafe{ExpeInfo.nmouse}(ss,dd) = NaN;
                    
                end
            end
        end
    end
end

AllMice = unique(MouseNumSound);
for m = 1:length(AllMice)
%     % Ripple shock
%     RipShockTemp = squeeze(MouseByMouse.RippleShock{AllMice(m)});
%     RipShockTemp = RipShockTemp(:);
%     RipShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
%     RipShockTempTime = RipShockTempTime(:);
%     RipShockTemp(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
%     RipShockTempTime(isnan(RipShockTempTime)|(RipShockTempTime==0)) = [];
%     RipFreq = RipShockTemp./RipShockTempTime;
%     % weighted mean according to time spent;
%     RipShock(m) = RipFreq'*RipShockTempTime/sum(RipShockTempTime);
%     
%     % Ripple safe
%     RipSafeTemp = squeeze(MouseByMouse.RippleSafe{AllMice(m)});
%     RipSafeTemp = RipSafeTemp(:);
%     RipSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
%     RipSafeTempTime = RipSafeTempTime(:);
%     RipSafeTemp(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
%     RipSafeTempTime(isnan(RipSafeTempTime)|(RipSafeTempTime==0)) = [];
%     RipFreq = RipSafeTemp./RipSafeTempTime;
%     % weighted mean according to time spentsum
%     RipSafe(m) = RipFreq'*RipSafeTempTime/norm(RipSafeTempTime);
%     
%     % Ripple Sound
%     RipSound(m) = MouseByMouse.RippleSound{AllMice(m)}./MouseByMouse.DurSound{AllMice(m)};
%     
%     % FreqOB shock
%     FreqOBShockTemp = squeeze(MouseByMouse.FreqShock{AllMice(m)});
%     FreqOBShockTemp = FreqOBShockTemp(:);
%     FreqOBShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
%     FreqOBShockTempTime = FreqOBShockTempTime(:);
%     FreqOBShockTemp(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
%     FreqOBShockTempTime(isnan(FreqOBShockTempTime)|(FreqOBShockTempTime==0)) = [];
%     FreqOBShock(m) = FreqOBShockTemp'*FreqOBShockTempTime/sum(FreqOBShockTempTime);
%     
%     % FreqOB safe
%     FreqOBSafeTemp = squeeze(MouseByMouse.FreqSafe{AllMice(m)});
%     FreqOBSafeTemp = FreqOBSafeTemp(:);
%     FreqOBSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
%     FreqOBSafeTempTime = FreqOBSafeTempTime(:);
%     FreqOBSafeTemp(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
%     FreqOBSafeTempTime(isnan(FreqOBSafeTempTime)|(FreqOBSafeTempTime==0)) = [];
%     FreqOBSafe(m) = FreqOBSafeTemp'*FreqOBSafeTempTime/sum(FreqOBSafeTempTime);
%     
%     % FreqOBSound
%     FreqOBSound(m) = MouseByMouse.FreqSound{AllMice(m)};
% 
%     
%      % Spec
%         OBSPecShockTemp = MouseByMouse.OBShock{AllMice(m)};
%         OBSPecShockTemp = reshape(OBSPecShockTemp,[size(OBSPecShockTemp,1)*size(OBSPecShockTemp,2),261]);
%         OBSPecShockTempTime = squeeze(MouseByMouse.DurShock{AllMice(m)});
%         OBSPecShockTempTime = OBSPecShockTempTime(:);
%         OBSPecShockTemp(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0),:) = [];
%         OBSPecShockTempTime(isnan(OBSPecShockTempTime)|(OBSPecShockTempTime==0)) = [];
%         Sptemp = OBSPecShockTemp'*OBSPecShockTempTime/sum(OBSPecShockTempTime);
%         OBSPecShock(m,:) = Sptemp./nansum(Sptemp(14:end));
%         TimeShock(m) = nansum(OBSPecShockTempTime);
%         
%         % safe
%         OBSPecSafeTemp = MouseByMouse.OBSafe{AllMice(m)};
%         OBSPecSafeTemp = reshape(OBSPecSafeTemp,[size(OBSPecSafeTemp,1)*size(OBSPecSafeTemp,2),261]);
%         OBSPecSafeTempTime = squeeze(MouseByMouse.DurSafe{AllMice(m)});
%         OBSPecSafeTempTime = OBSPecSafeTempTime(:);
%         OBSPecSafeTemp(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0),:) = [];
%         OBSPecSafeTempTime(isnan(OBSPecSafeTempTime)|(OBSPecSafeTempTime==0)) = [];
%         Sptemp=(OBSPecSafeTemp'*OBSPecSafeTempTime/sum(OBSPecSafeTempTime));
%         OBSPecSafe(m,:) = Sptemp./nansum(Sptemp(14:end));
%         TimeSafe(m) = nansum(OBSPecSafeTempTime);
%         
        % spec sound
        Sptemp = squeeze(MouseByMouse.OBSound{AllMice(m)});
        OBSpecSound(m,:) = Sptemp;%./nansum(Sptemp(14:end));

end

% Compare ripple numbers
figure
A = {RipSound,RipShock,RipSafe};
Cols = {[0.6 0.6 0.6],[1 0.6 0.6],[0.6 0.6 1]};
Legends = {'Shock','Safe'};
MakeSpreadAndBoxPlot_SB(A,Cols,1:3)
line([A{1}'*0+1,A{1}'*0+2,A{1}'*0+3]',[A{1}',A{2}',A{3}']','color','k')

% Compare OB freq

figure
A = {FreqOBSound,FreqOBShock,FreqOBSafe};
Cols = {[0.6 0.6 0.6],[1 0.6 0.6],[0.6 0.6 1]};
Legends = {'Shock','Safe'};
MakeSpreadAndBoxPlot_SB(A,Cols,1:3)
line([A{1}'*0+1,A{1}'*0+2,A{1}'*0+3]',[A{1}',A{2}',A{3}']','color','k')

