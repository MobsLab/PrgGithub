clear all
SessNames={'HabituationBlockedShock_PreDrug' 'HabituationBlockedSafe_PreDrug' 'TestPre_PreDrug',...
    'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug','UMazeCondExplo_PreDrug',...
    'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug','UMazeCondExplo_PostDrug',...
    'TestPost_PostDrug',...
    'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };


SALMice = [688,739,777,779];
FLXMice = [740,750,778,775];


for ss = 1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path)
        for dd=1:length(Dir.path{d})
            cd(Dir.path{d}{dd})
            disp(Dir.path{d}{dd})
            load('ExpeInfo.mat')
            load('behavResources_SB.mat')
            load('B_Low_Spectrum.mat')
            Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
            
            if exist([cd filesep 'HeartBeatInfo.mat'])>0
                load('HeartBeatInfo.mat')
            else
                EKG = [];
            end
            
            load('InstFreqAndPhase_B.mat')
            
            if exist([cd filesep 'Ripples.mat'])>0
                load('Ripples.mat')
                Ripts = ts(RipplesR(:,1)*10);
            else
                Ripts = [];
            end
            
            load('H_VHigh_Spectrum.mat')
            Sptsd_H = tsd(Spectro{2}*1e4,Spectro{1});
            
            
            if (double(strcmp(ExpeInfo.DrugInjected,'FLX'))+double(strcmp(ExpeInfo.DrugInjected,'FLX-Ineff'))*4)==0
                MouseNum = find(SALMice==ExpeInfo.nmouse);
                MouseType = 'Sal';
            else
                MouseNum = find(FLXMice==ExpeInfo.nmouse);
                MouseType = 'Flx';
            end
            
            
            if isfield(Behav,'EscapeLat')
                if isnan(Params.DoorRemoved)
                    Params.DoorRemoved = 300;
                end
                for zone = 1:5
                    Behav.ZoneEpoch{zone} = and(Behav.ZoneEpoch{zone},intervalSet(0,Params.DoorRemoved*1e4));
                end
            end
            
            if not(isempty(MouseNum))
                for zone = 1:5
                    ZoneEpochNoFz = Behav.ZoneEpoch{zone} - Behav.FreezeAccEpoch;
                    ZoneEpochFz = and(Behav.ZoneEpoch{zone},Behav.FreezeAccEpoch);
                    
                    % Time spent
                    TimeSpentTotZones.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(Behav.ZoneEpoch{zone},'s')-Start(Behav.ZoneEpoch{zone},'s'));
                    
                    % Time spent freezing
                    TimeSpentFzZones.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = sum(Stop(and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{zone}),'s')-Start(and(Behav.FreezeAccEpoch,Behav.ZoneEpoch{zone}),'s'));
                    
                    % Speed in zone outside freezing
                    SpeedZonesNoFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(Behav.Vtsd,ZoneEpochNoFz)));
                    
                    if not(isempty(EKG))
                        % HR -mean- in zone outside freezing
                        HBRateNoFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(EKG.HBRate,ZoneEpochNoFz)));
                        
                        % HR -mean- in zone inside freezing
                        HBRateFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(EKG.HBRate,ZoneEpochFz)));
                        
                        % HR -std- in zone outside freezing
                        HBStdNoFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanstd(Data(Restrict(EKG.HBRate,ZoneEpochNoFz)));
                        
                        % HR -std- in zone inside freezing
                        HBStdFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanstd(Data(Restrict(EKG.HBRate,ZoneEpochFz)));
                    else
                        % HR -mean- in zone outside freezing
                        HBRateNoFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = NaN;
                        
                        % HR -mean- in zone inside freezing
                        HBRateFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = NaN;
                        
                        % HR -std- in zone outside freezing
                        HBStdNoFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = NaN;
                        
                        % HR -std- in zone inside freezing
                        HBStdFz.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = NaN;
                    end
                    
                    % OB freq in zone outside freezing
                    OBFreqNoFzPT.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(LocalFreq.PT,ZoneEpochNoFz)));
                    OBFreqNoFzWV.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(LocalFreq.WV,ZoneEpochNoFz)));
                    
                    % OB freq in zone inside freezing
                    OBFreqFzPT.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(LocalFreq.PT,ZoneEpochFz)));
                    OBFreqFzWV.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = nanmean(Data(Restrict(LocalFreq.WV,ZoneEpochFz)));
                    
                    % OB spectrum
                    
                    OBSpec.(SessNames{ss}).(MouseType)(MouseNum,zone,dd,:) = nanmean(Data(Restrict(Sptsd_B,ZoneEpochFz)));
                    
                    % HPC spectrum
                    HPCSpec.(SessNames{ss}).(MouseType)(MouseNum,zone,dd,:) = nanmean(Data(Restrict(Sptsd_H,ZoneEpochFz)));
                    
                    % Ripples in zone inside freezing
                    if not(isempty(Ripts))
                        NumRipples.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = length(Range(Restrict(Ripts,ZoneEpochFz)));
                        
                    else
                        NumRipples.(SessNames{ss}).(MouseType)(MouseNum,zone,dd) = NaN;
                    end
                end
            end
            
        end
    end
end




fig=figure;

SessNames_All{1} ={ 'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug'};
SessNames_All{2} ={ 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
SessNames_All{3} ={ 'UMazeCondBlockedShock_PreDrug' 'UMazeCondBlockedSafe_PreDrug'};
Cols{1} = [[1 0.6 0.6];[1 0.6 0.6]*0.5] ;
Cols{2} = [[0.6 0.6 1];[0.6 0.6 1]*0.5] ;

for sess = 1:3
    clf
    SessNames = SessNames_All{sess};
    for k = 1:2
        TotTime = [nanmean(nanmean(squeeze(TimeSpentTotZones.(SessNames{k}).Sal(:,k,1:2)),3)')',...
            nanmean(nanmean(squeeze(TimeSpentTotZones.(SessNames{k}).Flx(:,k,1:2)),3)')'];
        
        subplot(5,2,1+k-1)
        TotTimeFz = [nanmean(nanmean(squeeze(TimeSpentFzZones.(SessNames{k}).Sal(:,k,1:2)),3)')',...
            nanmean(nanmean(squeeze(TimeSpentFzZones.(SessNames{k}).Flx(:,k,1:2)),3)')'];
        TotTimeFz_Norm = TotTimeFz./TotTime;
        bar(1,nanmean(nanmean(TotTimeFz_Norm(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([TotTimeFz_Norm(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([TotTimeFz_Norm(:,1)']');([TotTimeFz_Norm(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 0.8])
        ylabel('% time freezing')
        
        subplot(5,2,3+k-1)
        A = [nanmean(nanmean(squeeze(NumRipples.(SessNames{k}).Sal(:,k,1:2)),3)')',...
            nanmean(nanmean(squeeze(NumRipples.(SessNames{k}).Flx(:,k,1:2)),3)')'];
        A = A./TotTimeFz;
        bar(1,nanmean(nanmean(A(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([A(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([A(:,1)']');([A(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 0.8])
        ylabel('Ripples per sec')
        
        subplot(5,2,5+k-1)
        A = [nanmean(nanmean(squeeze(HBRateFz.(SessNames{k}).Sal(:,k,1:2)),3)')',...
            nanmean(nanmean(squeeze(HBRateFz.(SessNames{k}).Flx(:,k,1:2)),3)')'];
        bar(1,nanmean(nanmean(A(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([A(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([A(:,1)']');([A(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 15])
        ylabel('HB rate')
        
        subplot(5,2,7+k-1)
        A = [nanmean(nanmean(squeeze(HBStdFz.(SessNames{k}).Sal(:,k,1:2)),3)')',...
            nanmean(nanmean(squeeze(HBStdFz.(SessNames{k}).Flx(:,k,1:2)),3)')'];
        bar(1,nanmean(nanmean(A(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([A(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([A(:,1)']');([A(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 2])
        ylabel('HB rate std')
        
        subplot(5,2,9+k-1)
        SpecSal = squeeze((nanmean(OBSpec.(SessNames{k}).Sal(:,k,1:2,:),3)));
        SpecFlx = squeeze((nanmean(OBSpec.(SessNames{k}).Flx(:,k,1:2,:),3)));
        g = shadedErrorBar(fLow,nanmean(SpecSal),stdError(SpecSal)); hold on
        set(g.patch,'FaceColor',Cols{k}(1,:))
        g = shadedErrorBar(fLow,nanmean(SpecFlx),stdError(SpecFlx));
        set(g.patch,'FaceColor',Cols{k}(2,:))
        line([2 2],ylim,'color','k')
        line([5 5],ylim,'color','k')
        ylabel('Power - OB')
        xlabel('Frequency (Hz)')
    end
        pause

    cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FluoxetineAnalysis/AnalysisSpet2018/
    saveas(fig.Number,[SessNames{k},'FreezingOverview.png'])
    
    clf
end


%% do same with all post drug freezing


% figure
% AllSalFz = 0;
% AllFlxFz = 0;
% figure
% for ss = 1:length(SessNames)
% AllSalFz = AllSalFz+nansum(nansum(nansum(TimeSpentFzZones.(SessNames{ss}).Sal)));
% AllFlxFz = AllFlxFz+nansum(nansum(nansum(TimeSpentFzZones.(SessNames{ss}).Flx)));
% errorbar(ss,nansum(nansum(nansum(TimeSpentFzZones.(SessNames{ss}).Sal))),'b*')
% hold on
% plot(ss,nansum(nansum(nansum(TimeSpentFzZones.(SessNames{ss}).Flx))),'r*')
% end
% line([6.5 6.5],ylim)
% 


SessNames={'UMazeCondBlockedShock_PostDrug' 'UMazeCondBlockedSafe_PostDrug' 'UMazeCondExplo_PostDrug'...
    'TestPost_PostDrug','ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };
SessNum = [2,2,2,4,2,2];
TimeSpentFzZones_Sal = zeros(4,5);
TimeSpentFzZones_Flx = zeros(4,5);

TimeSpentTotZones_Sal = zeros(4,5);
TimeSpentTotZones_Flx = zeros(4,5);

TotRipNumber_Sal = zeros(4,5);
TotRipNumber_Flx = zeros(4,5);


for sess = 1:length(SessNames)
    clf
    
    TimeSpentFzZones_Sal = TimeSpentFzZones_Sal + nansum(TimeSpentFzZones.(SessNames{sess}).Sal(:,:,1:SessNum(sess)),3);
    TimeSpentFzZones_Flx = TimeSpentFzZones_Flx + nansum(TimeSpentFzZones.(SessNames{sess}).Flx(:,:,1:SessNum(sess)),3);
    
    TimeSpentTotZones_Sal = TimeSpentTotZones_Sal + nansum(TimeSpentTotZones.(SessNames{sess}).Sal(:,:,1:SessNum(sess)),3);
    TimeSpentTotZones_Flx = TimeSpentTotZones_Flx + nansum(TimeSpentTotZones.(SessNames{sess}).Flx(:,:,1:SessNum(sess)),3);
    
    TotRipNumber_Sal = TotRipNumber_Sal + nansum(NumRipples.(SessNames{sess}).Sal(:,:,1:SessNum(sess)),3);
    TotRipNumber_Flx = TotRipNumber_Flx + nansum(NumRipples.(SessNames{sess}).Flx(:,:,1:SessNum(sess)),3);

    
end
figure
subplot(321)
PlotErrorSpreadN_KJ(TimeSpentTotZones_Sal(:,[1,4,3,5,2]),'newfig',0), ylim([0 3000])
subplot(322)
PlotErrorSpreadN_KJ(TimeSpentTotZones_Flx(:,[1,4,3,5,2]),'newfig',0), ylim([0 3000])

subplot(323)
PlotErrorSpreadN_KJ(TimeSpentFzZones_Sal(:,[1,4,3,5,2]),'newfig',0), ylim([0 700])
subplot(324)
PlotErrorSpreadN_KJ(TimeSpentFzZones_Flx(:,[1,4,3,5,2]),'newfig',0), ylim([0 700])

subplot(325)
PlotErrorSpreadN_KJ(TimeSpentFzZones_Sal(:,[1,4,3,5,2])./TimeSpentTotZones_Sal(:,[1,4,3,5,2]),'newfig',0), ylim([0 0.5])
subplot(326)
PlotErrorSpreadN_KJ(TimeSpentFzZones_Flx(:,[1,4,3,5,2])./TimeSpentTotZones_Flx(:,[1,4,3,5,2]),'newfig',0), ylim([0 0.5])

figure
subplot(325)
PlotErrorSpreadN_KJ(TotRipNumber_Sal(:,[1,4,3,5,2])./TimeSpentFzZones_Sal(:,[1,4,3,5,2]),'newfig',0), 
subplot(326)
PlotErrorSpreadN_KJ(TotRipNumber_Flx(:,[1,4,3,5,2])./TimeSpentFzZones_Flx(:,[1,4,3,5,2]),'newfig',0), 

