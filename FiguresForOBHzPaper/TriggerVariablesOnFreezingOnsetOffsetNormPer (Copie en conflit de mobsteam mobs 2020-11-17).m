clear all,% close all
%% INITIATION
FreqRange=[3,6];
[params,movingwin,suffix]=SpectrumParametersML('low');
tps=[0.05:0.05:1];
timeatTransition=5;
timebefprop=0.3;
timebefxpos=timebefprop./(1+timebefprop*2);

%% DATA LOCALISATION
% Get data
CtrlEphys=[242,248,244,253,254,259,299,394,395,402,403,450,451];
% Excluded mice (too much noise)=258
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
Dir2 = PathForExperimentFEAR('Fear-electrophy-plethysmo');

Dir = MergePathForExperiment(Dir,Dir2)

KeepFirstSessionOnly=[2,3,4,6,7:length(Dir.path)-2];

n=1;

for m=1:length(KeepFirstSessionOnly)
    
    cd(Dir.path{KeepFirstSessionOnly(m)})
    load('behavResources.mat')
    
    clear AllVarToTrigger
    %% Go to file location
    clear Spec_H Spec_B FreqBand NewMat TotalNoiseEpoch NoFreezeEpoch FreezeEpoch FreezeAccEpoch FreqBand
    clear Movtsd MovAcctsd
    
    %% load freezing periods
    load('behavResources.mat')
    load('StateEpochSB.mat')
    if exist('FreezeAccEpoch')
        FreezeEpoch=FreezeAccEpoch;
    end
    TotEpoch=intervalSet(0,max(Range(Movtsd)));
    FreezeEpoch=and(FreezeEpoch,TotEpoch);
    FreezeEpoch=dropShortIntervals(FreezeEpoch,5*1e4);
%     FreezeEpoch=dropLongIntervals(FreezeEpoch,10*1e4);
    FreezeEpochBis=FreezeEpoch;
    
    % keep only well separated epochs
    for fr_ep=1:length(Start(FreezeEpoch))
        LitEp=subset(FreezeEpoch,fr_ep);
        NotLitEp=FreezeEpoch-LitEp;
        StopEp=intervalSet(Stop(LitEp)-timeatTransition*1e4,Stop(LitEp)+timeatTransition*1e4);
        if not(isempty(Data(Restrict(Movtsd,and(NotLitEp,StopEp)))))
            FreezeEpochBis=FreezeEpochBis-LitEp;
        end
    end
    FreezeEpoch=CleanUpEpoch(FreezeEpochBis);
    
    if length(Start(FreezeEpoch))>0
        
        %% movement
        AllVarToTrigger.Speed = Movtsd;
        if exist('MovAcctsd')
            AllVarToTrigger.Accelero = MovAcctsd;
        end
        
        %% Spectra
        % OB Spectra
        load(['B_Low_Spectrum.mat'])
        AllVarToTrigger.PowerOB =  tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')');
        
        % PFC Spectra
        if exist('PFCx_Low_Spectrum.mat')>0
            load(['PFCx_Low_Spectrum.mat'])
            AllVarToTrigger.PowerPFC =  tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')');
            
            % OB - PFC coherence
            load('ChannelsToAnalyse/Bulb_deep.mat'); chB = channel;
            load('ChannelsToAnalyse/PFCx_deep.mat'); chP = channel;
            try
                load(['CohgramcDataL/Cohgram_',num2str(chB),'_',num2str(chP),'.mat'])
            catch
                load(['CohgramcDataL/Cohgram_',num2str(chP),'_',num2str(chB),'.mat'])
            end
            
            AllVarToTrigger.CohOBPFC = tsd(t*1e4,nanmean(C(:,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'))')');
            
            
            
        else
            AllVarToTrigger.PowerPFC = [];
            AllVarToTrigger.CohOBPFC = [];
        end
        
        % HPC Spectra - only local
        if exist('LFPData/LocalHPCActivity.mat')>0
            load('HPCLoc_Low_Spectrum.mat')
            Sptsd_HLoc = tsd(Spectro{2}*1e4,Spectro{1});
            [val,ind] = max(Spectro{1}(:,50:end)'); ind = ind + 50;
            AllVarToTrigger.HPCFreq = tsd(Spectro{2}*1e4,medfilt1(Spectro{3}(ind)',10));
        else
            AllVarToTrigger.HPCFreq = [];
        end
        
        %% Respiration
        if exist('BreathingInfo.mat')>0
            % breathing frequency
            load('BreathingInfo.mat','TidalVolumtsd','Frequecytsd')
            AllVarToTrigger.TidalVolumeRespi = TidalVolumtsd;
            AllVarToTrigger.RespiFreq = Frequecytsd;
            AllVarToTrigger.RespiVar = tsd(Range(Frequecytsd),movvar(Data(Frequecytsd),5));
            
            
            % OB - Respi coherence
            load('ChannelsToAnalyse/Bulb_deep.mat'); chB = channel;
            load('ChannelsToAnalyse/Respi.mat'); chR = channel;
            try
                load(['CohgramcDataL/Cohgram_',num2str(chB),'_',num2str(chR),'.mat'])
            catch
                load(['CohgramcDataL/Cohgram_',num2str(chR),'_',num2str(chB),'.mat'])
            end
            AllVarToTrigger.CohRespiOB = tsd(t*1e4,nanmean(C(:,find(f<FreqRange(1),1,'last'):find(f<FreqRange(2),1,'last'))')');
            
            % Respi - Power
            load('Respi_Low_Spectrum.mat')
            AllVarToTrigger.PowerRespi =  tsd(Spectro{2}*1e4,nanmean(Spectro{1}(:,find(Spectro{3}<FreqRange(1),1,'last'):find(Spectro{3}<FreqRange(2),1,'last'))')');
            
        else
            AllVarToTrigger.TidalVolumeRespi = [];
            AllVarToTrigger.RespiFreq = [];
            AllVarToTrigger.Coh_B_R = [];
        end
        
        %% Spikes
        clear S ProjFR SumFR VectFr
        if exist('SpikeData.mat')>0
            load('SpikeData.mat')
            if iscell(S), S = tsdArray(S); end
            if not(sum(size(S))) ==0
                Q = MakeQfromS(S,0.5e4);
                AllVarToTrigger.SumFR = tsd(Range(Q),full(sum(Data(Q)')'));
                VectFr = nanmean(Data(Restrict(Q,FreezeEpoch))) - nanmean(Data(Restrict(Q,TotEpoch-FreezeEpoch)));
                ProjFR = tsd(Range(Q),full((Data(Q)*VectFr')));
                Biais = (nanmean(Data(Restrict(ProjFR,FreezeEpoch)))+nanmean(Data(Restrict(ProjFR,TotEpoch-FreezeEpoch))))/2;
                AllVarToTrigger.ProjFR = tsd(Range(ProjFR),Data(ProjFR) - Biais);
            else
                AllVarToTrigger.SumFR = [];
                AllVarToTrigger.ProjFR = [];
            end
        else
            AllVarToTrigger.SumFR = [];
            AllVarToTrigger.ProjFR = [];
        end
        VarNames = fieldnames(AllVarToTrigger);
        
        for ep=1:length(Start(FreezeEpoch))-1
            ActualEpoch=subset(FreezeEpoch,ep);
            Dur{m}(ep)=Stop(ActualEpoch,'s')-Start(ActualEpoch,'s');
            %% Look at Normalized periods
            % define epoch
            timebef = 4; % now use 5s always
            % timebef=Dur{m}(ep)*timebefprop; % period before and after is 30% acutal period
            LittleEpoch=intervalSet(Start(ActualEpoch),Stop(ActualEpoch));
            LittleEpochPre=intervalSet(Start(ActualEpoch)-timebef*1e4,Start(ActualEpoch));
            LittleEpochPost=intervalSet(Stop(ActualEpoch),Stop(ActualEpoch)+timebef*1e4);
            
            for var = 1:length(VarNames)
                if not(isempty(AllVarToTrigger.(VarNames{var})))
                    TempData=Data(Restrict(AllVarToTrigger.(VarNames{var}),LittleEpoch));
                    TempData = interp1([1/length(TempData):1/length(TempData):1],TempData,tps);
                    
                    TempDataPre=Data(Restrict(AllVarToTrigger.(VarNames{var}),LittleEpochPre));
                    TempDataPre = interp1([1/length(TempDataPre):1/length(TempDataPre):1],TempDataPre,[0.1:0.1:1]);
                    
                    TempDataPost=Data(Restrict(AllVarToTrigger.(VarNames{var}),LittleEpochPost));
                    TempDataPost = interp1([1/length(TempDataPost):1/length(TempDataPost):1],TempDataPost,[0.1:0.1:1]);
                    
                    Triggered.NormPer.(VarNames{var}){m}(ep,:) = [TempDataPre,TempData,TempDataPost];
                    
                else
                    Triggered.NormPer.(VarNames{var}){m} = [];
                end
            end
            
            
            %% Look at onset periods
            % define epoch
            LittleEpoch=intervalSet(Start(ActualEpoch)-(timeatTransition-1)*1e4,Start(ActualEpoch)+timeatTransition*1e4);
            
            for var = 1:length(VarNames)
                if not(isempty(AllVarToTrigger.(VarNames{var})))
                    TempData=Data(Restrict(AllVarToTrigger.(VarNames{var}),LittleEpoch));
                    Triggered.Onset.(VarNames{var}){m}(ep,:) = interp1([1/length(TempData):1/length(TempData):1],TempData,tps);
                else
                    Triggered.Onset.(VarNames{var}){m} = [];
                end
            end
            
            %% Look at offset periods
            % define epoch
            LittleEpoch=intervalSet(Stop(ActualEpoch)-timeatTransition*1e4,Stop(ActualEpoch)+(timeatTransition-1)*1e4);
            
            for var = 1:length(VarNames)
                if not(isempty(AllVarToTrigger.(VarNames{var})))
                    TempData=Data(Restrict(AllVarToTrigger.(VarNames{var}),LittleEpoch));
                    Triggered.Offset.(VarNames{var}){m}(ep,:) = interp1([1/length(TempData):1/length(TempData):1],TempData,tps);
                else
                    Triggered.Offset.(VarNames{var}){m} = [];
                end
            end
        end
    end
end


clear AllVals
for var = 1:length(VarNames)
    for m = 1 : length(Triggered.Offset.PowerOB)
        if not(isempty(Triggered.Offset.(VarNames{var}){m}))
            AllVals.Offset.(VarNames{var})(m,:) = nanmean(Triggered.Offset.(VarNames{var}){m});
        else
            AllVals.Offset.(VarNames{var})(m,:)  = nan(1,20);
        end
        
        if not(isempty(Triggered.Onset.(VarNames{var}){m}))
            AllVals.Onset.(VarNames{var})(m,:) = nanmean(Triggered.Onset.(VarNames{var}){m});
        else
            AllVals.Onset.(VarNames{var})(m,:)  = nan(1,20);
        end
        
        if not(isempty(Triggered.NormPer.(VarNames{var}){m}))
            AllVals.NormPer.(VarNames{var})(m,:) = nanmean(Triggered.NormPer.(VarNames{var}){m});
        else
            AllVals.NormPer.(VarNames{var})(m,:)  = nan(1,40);
        end
        
    end
end
% mouse with abherrant values
AllVals.Onset.PowerRespi(17,:) = nan(1,20);
AllVals.NormPer.PowerRespi(17,:) = nan(1,40);

VarNames2 = {'Accelero','Speed','RespiFreq','PowerRespi','TidalVolumeRespi','RespiVar','CohRespiOB','PowerOB','CohOBPFC','PowerPFC','ProjFR','HPCFreq'};
figure(11)

tpsrealigned=tps*10-5-0.2;
for var = 1:length(VarNames2)
    subplot(6,2,var)
    boundedline(tpsrealigned-10,naninterp(nanmean((AllVals.Onset.(VarNames2{var})))),naninterp(stdError((AllVals.Onset.(VarNames2{var})))),'r')
    hold on
    boundedline(tpsrealigned,naninterp(nanmean((AllVals.Offset.(VarNames2{var})))),naninterp(stdError((AllVals.Offset.(VarNames2{var})))),'r')
    line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
    line([-10 -10],ylim,'color','k','linestyle',':','linewidth',2)
    title(VarNames2{var})
    set(gca,'XTick',[])
    xlim([-15 5])
end

figure(12)

for var = 1:length(VarNames2)
    subplot(6,2,var)
    boundedline([-0.5:0.05:-0.05,tps,1.05:0.05:1.5],naninterp(nanmean((AllVals.NormPer.(VarNames2{var})))),naninterp(stdError((AllVals.NormPer.(VarNames2{var})))),'r')
    line([0 0],ylim,'color','k','linestyle',':','linewidth',2)
    line([1 1],ylim,'color','k','linestyle',':','linewidth',2)
    title(VarNames2{var})
    % set(gca,'XTick',[])
    xlim([-0.5 1.5])
end

% figure
% clear AllVals
% for var = 12
%     for m = 1 : length(Triggered.Offset.PowerOB)
%         if not(isempty(Triggered.Offset.(VarNames{var}){m}))
%             AllVals.Offset.(VarNames{var})(m,:) = nanmean(Triggered.Offset.(VarNames{var}){m}>0);
%         else
%             AllVals.Offset.(VarNames{var})(m,:)  = nan(1,20);
%         end
%         
%         if not(isempty(Triggered.Onset.(VarNames{var}){m}))
%             AllVals.Onset.(VarNames{var})(m,:) = nanmean(Triggered.Onset.(VarNames{var}){m}>0);
%         else
%             AllVals.Onset.(VarNames{var})(m,:)  = nan(1,20);
%         end
%         
%         if not(isempty(Triggered.NormPer.(VarNames{var}){m}))
%             AllVals.NormPer.(VarNames{var})(m,:) = nanmean(Triggered.NormPer.(VarNames{var}){m}>0);
%         else
%             AllVals.NormPer.(VarNames{var})(m,:)  = nan(1,40);
%         end
%         
%     end
% end
% 
% boundedline(tpsrealigned(2:end),naninterp(nanmean((AllVals.Offset.ProjFR(:,2:end)))),naninterp(stdError((AllVals.Offset.ProjFR(:,2:end))))), hold on
% boundedline(tpsrealigned(2:end)-10,naninterp(nanmean((AllVals.Onset.ProjFR(:,2:end)))),naninterp(stdError((AllVals.Onset.ProjFR(:,2:end)))))
% line(xlim,[0.5 0.5])
% 
