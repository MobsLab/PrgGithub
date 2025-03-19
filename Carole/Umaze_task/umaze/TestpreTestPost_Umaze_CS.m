clear all
MouseGroup = {'Sal','Mdz','Flx','FlxChr'};

Mice.Sal = [688,739,777,779,849,893];
Mice.Flx = [740,750,778,775,794];
Mice.Mdz = [829,851,856,857,858,859];
Mice.FlxChr = [876,877];

SessNames={'TestPre_PreDrug' 'TestPost_PostDrug' };
cols = summer(10);
cols2 = spring(10);
ReloadData = 1;
XLinPos = [0:0.05:1];


%%

for ss = 1 : length(SessNames)
    
    Dir=PathForExperimentsEmbReact(SessNames{ss});
    
    for mg = 1:length(MouseGroup)
        Files.(MouseGroup{mg}) = cell(1,length(Mice.(MouseGroup{mg})));
    end
    
    
    for d = 1:length(Dir.path)
        
        for mg = 1:length(MouseGroup)
            
            if sum(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))
                
                for p = 1:length(Dir.path{d})
                    Files.(MouseGroup{mg}){find(ismember(Mice.(MouseGroup{mg}),Dir.ExpeInfo{d}{1}.nmouse))}{end+1} = Dir.path{d}{p};
                end
            end
        end
    end
    
    
    % Initialize
    for testsession = 1:4
        for mg = 1:length(MouseGroup)
            
            OccupMap.(SessNames{ss}).(MouseGroup{mg}){testsession} = zeros(101,101);
            
            FreezeTime.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            LinPos.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            ZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            ZoneTimeTestTot.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            SpeedDistrib.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            ZoneNumTest.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
            FirstZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){testsession} = [];
            
        end
    end
    
    
    for mg = 1:length(MouseGroup)
        
        for mm = 1:length(Files.(MouseGroup{mg}))
            for dd = 1:length(Files.(MouseGroup{mg}){mm})
                
                cd(Files.(MouseGroup{mg}){mm}{dd})
                load('behavResources_SB.mat','Behav')
                load('ExpeInfo.mat')
                TotalEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
                
                
                % occupation map
                [OccupMap_temp,xx,yy] = hist2d(Data(Behav.AlignedXtsd),Data(Behav.AlignedYtsd),[0:0.01:1],[0:0.01:1]);
                OccupMap_temp = OccupMap_temp/sum(OccupMap_temp(:));
                OccupMap.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    OccupMap.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} + OccupMap_temp;
                
                % speed
                [YSp,XSp] = hist(log(Data(Restrict(Behav.Vtsd,TotalEpoch-Behav.FreezeAccEpoch))),[-15:0.1:1]);
                YSp = YSp/sum(YSp);
                SpeedDistrib.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [SpeedDistrib.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};YSp];
                
                
                % time in different zones
                for k=1:5
                    % mean episode duration
                    ZoneTime(k)=nanmean(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                    % total duration 
                    ZoneTimeTot(k)=nansum(Stop(Behav.ZoneEpochAligned{k},'s')-Start(Behav.ZoneEpochAligned{k},'s'));
                    
                    % number of visits
                    RealVisit = dropShortIntervals(Behav.ZoneEpochAligned{k},1*1e4);
                    ZoneEntr(k)=length(Stop(RealVisit,'s')-Start(RealVisit,'s'));
                    
                    % time to first entrance
                    if not(isempty(Start(RealVisit)))
                        FirstZoneTime(k) =min(Start(RealVisit,'s'));
                    else
                        FirstZoneTime(k) =200;
                    end
                end
                
                ZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [ZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneTime];
                ZoneTimeTestTot.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [ZoneTimeTestTot.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneTimeTot];
                ZoneNumTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [ZoneNumTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneEntr];
                
                FirstZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [FirstZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};FirstZoneTime];
                
                % freezing time in different zones
                for k=1:5
                    ZoneTime(k)=sum(Stop(and(Behav.FreezeAccEpoch,Behav.ZoneEpochAligned{k}),'s')-Start(and(Behav.ZoneEpochAligned{k},Behav.FreezeAccEpoch),'s'));
                end
                FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
                    [FreezeTime.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};ZoneTime];
                
                
%                 % Linear Position
%                 [YPos,XPos] = hist(Data(Behav.LinearDist),XLinPos);
%                 YPos = YPos/sum(YPos);
%                 LinPos.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber} = ...
%                     [LinPos.(SessNames{ss}).(MouseGroup{mg}){ExpeInfo.SessionNumber};YPos];
%                 
            end
        end
    end
    
end



%% Occupation map

for ss = 1:2
    figure
    for mg = 1:length(MouseGroup)
        MeanOcc.(MouseGroup{mg}){ss} = zeros(101,101);
    end
    
    for dd = 1:4
        for mg = 1:length(MouseGroup)
            subplot(length(MouseGroup),4,dd+(mg-1)*4)
            imagesc(xx,yy,log(OccupMap.(SessNames{ss}).(MouseGroup{mg}){dd}')),axis xy
            MeanOcc.(MouseGroup{mg}){ss} = MeanOcc.(MouseGroup{mg}){ss} + OccupMap.(SessNames{ss}).(MouseGroup{mg}){dd}./sum(sum(OccupMap.(SessNames{ss}).(MouseGroup{mg}){dd}));
            if mg==1
                title([strtok(SessNames{ss},'_') ' ' num2str(dd)])
            end
            set(gca,'XTick',[],'YTick',[])
            if dd==1
                ylabel(MouseGroup{mg})
            end
        end
    end
end
%%
figure
for mg = 1:length(MouseGroup)
    
    subplot(length(MouseGroup),2,1+(mg-1)*2)
    imagesc(log(MeanOcc.(MouseGroup{mg}){1})'), axis xy
    ylabel(MouseGroup{mg})
    set(gca,'XTick',[],'YTick',[])
    if mg==1
    title('Pre')
    end
    
    subplot(length(MouseGroup),2,2+(mg-1)*2)
    imagesc(log(MeanOcc.(MouseGroup{mg}){2})'), axis xy
    set(gca,'XTick',[],'YTick',[])
    if mg==1
    title('Post')
    end
end


%% Time spent
clear MeanEntryTime FirstEntryTime MeanStayTime NumberEntries TotFreezeTime TotTime
for ss = 1:2
    for mg = 1:length(MouseGroup)
        AllSp.(SessNames{ss}).(MouseGroup{mg}) = zeros(length(Files.(MouseGroup{mg})),161);
        
        for dd = 1:4
            MeanEntryTime.(SessNames{ss}).(MouseGroup{mg})(dd,:) = (FirstZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){dd}(:,1));
            
            MeanStayTime.(SessNames{ss}).(MouseGroup{mg})(dd,:) = (ZoneTimeTest.(SessNames{ss}).(MouseGroup{mg}){dd}(:,1));
            
            NumberEntries.(SessNames{ss}).(MouseGroup{mg})(dd,:) = (ZoneNumTest.(SessNames{ss}).(MouseGroup{mg}){dd}(:,1));
            
            TotFreezeTime.(SessNames{ss}).(MouseGroup{mg})(dd,:) = nansum(FreezeTime.(SessNames{ss}).(MouseGroup{mg}){dd}');
            
            for k = 1:5
                TotTime.(SessNames{ss}).(MouseGroup{mg})(k,dd,:) = (ZoneTimeTestTot.(SessNames{ss}).(MouseGroup{mg}){dd}(:,k));
            end
            
            AllSp.(SessNames{ss}).(MouseGroup{mg}) = AllSp.(SessNames{ss}).(MouseGroup{mg})+SpeedDistrib.(SessNames{ss}).(MouseGroup{mg}){dd};
        end
    end
end

%% Time spent zone per zone
figure
Cols = fliplr(gray(length(MouseGroup)+2)')';
for ss = 1:2
    
    for mg =1:length(MouseGroup)
        subplot(2,6,(1+(ss-1)*6:3+(ss-1)*6))
        bar(-1,mg,'Facecolor',Cols(mg,:));hold on
    end
    for mg =1:length(MouseGroup)
        subplot(2,6,(1+(ss-1)*6:3+(ss-1)*6))
        
        SalTotTime.(MouseGroup{mg}) = squeeze(nanmean(TotTime.(SessNames{ss}).(MouseGroup{mg}),2))/180;
        SalTotTime.(MouseGroup{mg}) = SalTotTime.(MouseGroup{mg})([1,4,3,5,2],:);
        
        
        for  k=1:5
        

            bar((k-1)*(length(MouseGroup)+1)+mg,nanmean(SalTotTime.(MouseGroup{mg})(k,:)),'Facecolor',Cols(mg,:)),hold on
            plot((k-1)*(length(MouseGroup)+1)+mg,SalTotTime.(MouseGroup{mg})(k,:),'.k','MarkerSize',10)
            
        end
    end
    %set(gca,'XTick',[1:2]*(length(MouseGroup)+1)-2,'XTickLabel',{'Shock','Safe'},'LineWidth',2)
    set(gca,'XTick',[1:5]*(length(MouseGroup)+1)-2,'XTickLabel',{'Shock','ShockCentre','Centre','SafeCentre','Safe'},'LineWidth',2)
    ylabel('% time per zone')
    ylim([0 1])
    xlim([-0.2 5*(length(MouseGroup)+1)+0.2])
    legend(MouseGroup,'Location','NorthWest')
    box off
    title(strtok(SessNames{ss},'_'))
    
    % Mean EntryTime
    subplot(2,6,4+(ss-1)*6)
    for mg =1:length(MouseGroup)
        
        SalEntryTime.(MouseGroup{mg}) = squeeze(nanmean(MeanEntryTime.(SessNames{ss}).(MouseGroup{mg}),1));
        
        bar(mg,nanmean(SalEntryTime.(MouseGroup{mg})),'Facecolor',Cols(mg,:)),hold on
        plot(mg,SalEntryTime.(MouseGroup{mg}),'.k','MarkerSize',10)
        
    end
    
    set(gca,'XTick',[1:length(MouseGroup)],'XTickLabel',MouseGroup,'LineWidth',2)
    ylabel('Mean entry time shock (s)')
    ylim([0 210])
    title(strtok(SessNames{ss},'_'))
    box off
    
    % Number of entries
    subplot(2,6,5+(ss-1)*6)
    for mg =1:length(MouseGroup)
        
        bar(mg,nanmean(NumberEntries.(SessNames{ss}).(MouseGroup{mg})(:)),'Facecolor',Cols(mg,:)),hold on
        plot(mg,nanmean(NumberEntries.(SessNames{ss}).(MouseGroup{mg})),'.k','MarkerSize',10)
    end
    
    set(gca,'XTick',[1:length(MouseGroup)],'XTickLabel',MouseGroup,'LineWidth',2)
    ylabel('Number of entries shock')
    title(strtok(SessNames{ss},'_'))
    ylim([-1 8])
    box off

    subplot(2,6,6+(ss-1)*6)
    for mg =1:length(MouseGroup)
        SalStayTime = squeeze(nanmean(MeanStayTime.(SessNames{ss}).(MouseGroup{mg}),1));
        
        bar(mg,nanmean(SalStayTime),'Facecolor',Cols(mg,:)),hold on
        plot(mg,SalStayTime,'.k','MarkerSize',10)
        

    end
    set(gca,'XTick',[1:length(MouseGroup)],'XTickLabel',MouseGroup,'LineWidth',2)
    ylabel('Mean stay time shock (s)')
        title(strtok(SessNames{ss},'_'))
ylim([0 26])
    box off
end

%% Shock vs Safe Ratio
figure
for ss = 1:2
    for mg =1:length(MouseGroup)
        SalTime = squeeze(nanmean(TotTime.(SessNames{ss}).(MouseGroup{mg})(1:2,:,:),2))';
        
        AvSal = (SalTime(:,1)-SalTime(:,2))./(SalTime(:,1)+SalTime(:,2));
        subplot(1,2,ss)
        bar(mg,nanmean(AvSal),'Facecolor',Cols(mg,:)),hold on
        plot(mg,AvSal,'.k','MarkerSize',10)
        
        title(strtok(SessNames{ss},'_'))
        ylabel('Shock-Safe')
        ylim([-1.1 1.1])
        set(gca,'XTick',[1:length(MouseGroup)],'XTickLabel',MouseGroup,'LineWidth',2)
        box off
    end
end



