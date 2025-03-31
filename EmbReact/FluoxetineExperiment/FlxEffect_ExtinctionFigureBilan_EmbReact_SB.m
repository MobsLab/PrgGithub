clear all
SessNames = {'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug' };


SALMice = [688,739,777,779];
FLXMice = [740,750,778,775];

load('B_Low_Spectrum.mat')
fLow = Spectro{3};

for ss = 1:length(SessNames)
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    for d=1:length(Dir.path)
        for dd=1:2
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
            
            
            
            TotEpoch = intervalSet(0,Params.DoorRemoved*1e4);
            
            if not(isempty(MouseNum))
                ZoneEpochNoFz = TotEpoch - Behav.FreezeAccEpoch;
                ZoneEpochFz = and(TotEpoch,Behav.FreezeAccEpoch);
                
                % Time spent freezing
                TimeSpentFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = sum(Stop(ZoneEpochFz,'s')-Start(ZoneEpochFz,'s'));
                
                % Speed in zone outside freezing
                SpeedNoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = nanmean(Data(Restrict(Behav.Vtsd,ZoneEpochNoFz)));
                
                if not(isempty(EKG))
                    % HR -mean- in zone outside freezing
                    HBRateNoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = nanmean(Data(Restrict(EKG.HBRate,ZoneEpochNoFz)));
                    
                    % HR -mean- in zone inside freezing
                    HBRateFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = nanmean(Data(Restrict(EKG.HBRate,ZoneEpochFz)));
                    
                    % HR -std- in zone outside freezing
                    HBStdNoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = nanstd(Data(Restrict(EKG.HBRate,ZoneEpochNoFz)));
                    
                    % HR -std- in zone inside freezing
                    HBStdFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = nanstd(Data(Restrict(EKG.HBRate,ZoneEpochFz)));
                else
                    % HR -mean- in zone outside freezing
                    HBRateNoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = NaN;
                    
                    % HR -mean- in zone inside freezing
                    HBRateFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = NaN;
                    
                    % HR -std- in zone outside freezing
                    HBStdNoFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = NaN;
                    
                    % HR -std- in zone inside freezing
                    HBStdFz.(SessNames{ss}).(MouseType)(MouseNum,dd) = NaN;
                end
                
                
                
                % OB spectrum
                OBSpec.(SessNames{ss}).(MouseType)(MouseNum,dd,:) = nanmean(Data(Restrict(Sptsd_B,ZoneEpochFz)));
                OBSpecAll.(SessNames{ss}).(MouseType){MouseNum,dd} = (Data(Restrict(Sptsd_B,ZoneEpochFz)));
                
                % Lin position
                [Y,X] = hist(Data(Behav.LinearDist),[0:0.01:1]);
                LinPos.(SessNames{ss}).(MouseType)(MouseNum,dd,:) = Y;
                [Y,X] = hist(Data(Restrict(Behav.LinearDist,ZoneEpochFz)),[0:0.01:1]);
                LinPosFz.(SessNames{ss}).(MouseType)(MouseNum,dd,:) = Y;

                
                % HPC spectrum
                HPCSpec.(SessNames{ss}).(MouseType)(MouseNum,dd,:) = nanmean(Data(Restrict(Sptsd_H,ZoneEpochFz)));
                
                % Ripples in zone inside freezing
                if not(isempty(Ripts))
                    NumRipples.(SessNames{ss}).(MouseType)(MouseNum,dd) = length(Range(Restrict(Ripts,ZoneEpochFz)));
                    
                else
                    NumRipples.(SessNames{ss}).(MouseType)(MouseNum,dd) = NaN;
                end
            end
        end
        
    end
end



fig=figure;

SessNames_All{1} ={ 'ExtinctionBlockedShock_PostDrug' 'ExtinctionBlockedSafe_PostDrug'};
Cols{1} = [[1 0.6 0.6];[1 0.6 0.6]*0.5] ;
Cols{2} = [[0.6 0.6 1];[0.6 0.6 1]*0.5] ;

for sess = 1
    clf
    SessNames = SessNames_All{sess};
    for k = 1:2
        
        
        subplot(4,2,1+k-1)
        TotTimeFz = [nanmean((TimeSpentFz.(SessNames{k}).Sal),2),...
            nanmean((TimeSpentFz.(SessNames{k}).Flx),2)];
        TotTimeFz_Norm = TotTimeFz./300;
        bar(1,nanmean(nanmean(TotTimeFz_Norm(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([TotTimeFz_Norm(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([TotTimeFz_Norm(:,1)']');([TotTimeFz_Norm(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 0.8])
        ylabel('% time freezing')
        
        
        subplot(4,2,3+k-1)
        A = [nanmean((NumRipples.(SessNames{k}).Sal),2),...
            nanmean((NumRipples.(SessNames{k}).Flx),2)];
        
        A = A./TotTimeFz;
        bar(1,nanmean(nanmean(A(:,1)')),'FaceColor',Cols{k}(1,:)), hold on
        bar(2,nanmean(nanmean([A(:,2)]')),'FaceColor',Cols{k}(2,:))
        handles = plotSpread({([A(:,1)']');([A(:,2)']')},'distributionColors',[ 0 0 0;0 0 0]);
        set(handles{1},'MarkerSize',10)
        set(gca,'XTick',[1,2],'XTickLabel',{'Sal','Flx'}), ylim([0 0.8])
        ylabel('Ripples per sec')
        
        subplot(4,2,5+k-1)
        plot(nanmean(squeeze(nanmean(LinPosFz.(SessNames{k}).Sal,2))),'color',Cols{k}(1,:),'linewidth',2)
        hold on
        plot(nanmean(squeeze(nanmean(LinPosFz.(SessNames{k}).Flx,2))),'color',Cols{k}(2,:),'linewidth',2)
        if k==1
            line([20 20],ylim)
        else
            line([80 80],ylim)
        end
        
        subplot(4,2,7+k-1)
        SpecSal = squeeze(nanmean(OBSpec.(SessNames{k}).Sal,2));
        SpecFlx = squeeze(nanmean(OBSpec.(SessNames{k}).Flx,2));
        g = shadedErrorBar(fLow,nanmean(SpecSal),stdError(SpecSal)); hold on
        set(g.patch,'FaceColor',Cols{k}(1,:))
        g = shadedErrorBar(fLow,nanmean(SpecFlx),stdError(SpecFlx));
        set(g.patch,'FaceColor',Cols{k}(2,:))
        line([2 2],ylim,'color','k')
        line([5 5],ylim,'color','k')
        ylabel('Power - OB')
        xlabel('Frequency (Hz)')
    end
end


ConcatSpec.Sal.Shock = [];
ConcatSpec.Sal.Safe = [];
ConcatSpec.Flx.Safe = [];
ConcatSpec.Flx.Shock = [];


for mouse = 1:4
    ConcatSpec.Sal.Safe{mouse} = [OBSpecAll.ExtinctionBlockedSafe_PostDrug.Sal{mouse,1};OBSpecAll.ExtinctionBlockedSafe_PostDrug.Sal{mouse,2}];
    ConcatSpec.Flx.Safe{mouse} = [OBSpecAll.ExtinctionBlockedSafe_PostDrug.Flx{mouse,1};OBSpecAll.ExtinctionBlockedSafe_PostDrug.Flx{mouse,2}];
    
    ConcatSpec.Sal.Shock{mouse} = [OBSpecAll.ExtinctionBlockedShock_PostDrug.Sal{mouse,1};OBSpecAll.ExtinctionBlockedShock_PostDrug.Sal{mouse,2}];
    ConcatSpec.Flx.Shock{mouse} = [OBSpecAll.ExtinctionBlockedShock_PostDrug.Flx{mouse,1};OBSpecAll.ExtinctionBlockedShock_PostDrug.Flx{mouse,2}];
end

figure
for mouse = 1:4
subplot(2,4,mouse)
imagesc(0:size(ConcatSpec.Sal.Safe{mouse},1),fLow,log(ConcatSpec.Sal.Safe{mouse}')), axis xy
line(xlim,[3 3])
if mouse ==1
    ylabel('Safe')
end
clim([4 15])

subplot(2,4,mouse+4)
imagesc(0:size(ConcatSpec.Sal.Shock{mouse},1),fLow,log(ConcatSpec.Sal.Shock{mouse}')), axis xy
line(xlim,[3 3])
if mouse ==1
    ylabel('Shock')
end
clim([4 15])

end

figure
for mouse = 1:4
subplot(2,4,mouse)
imagesc(0:size(ConcatSpec.Flx.Safe{mouse},1),fLow,log(ConcatSpec.Flx.Safe{mouse}')), axis xy
line(xlim,[3 3])
if mouse ==1
    ylabel('Safe')
end
clim([4 15])
subplot(2,4,mouse+4)
imagesc(0:size(ConcatSpec.Flx.Shock{mouse},1),fLow,log(ConcatSpec.Flx.Shock{mouse}')), axis xy
line(xlim,[3 3])
if mouse ==1
    ylabel('Shock')
end
clim([4 15])
end

