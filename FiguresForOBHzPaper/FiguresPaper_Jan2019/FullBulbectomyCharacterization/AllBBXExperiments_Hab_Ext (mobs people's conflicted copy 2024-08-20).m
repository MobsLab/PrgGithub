clear all
close all
Dir_All.All{1} = PathForExperimentFEAR('FearCBNov15','fear');
Dir_All.Ext{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','EXT-24h-envC');
Dir_All.Hab{1} = RestrictPathForExperiment(Dir_All.All{1},'Session','HAB-grille');

Dir_All.All{2} = PathForExperimentFEAR('ManipFeb15Bulbectomie','fear');
Dir_All.Ext{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','EXT-24h-envC');
Dir_All.Hab{2} = RestrictPathForExperiment(Dir_All.All{2},'Session','HAB-envC');

% these mice extinguished in the plethysmograph so we're using 48hrs
Dir_All.All{3} = PathForExperimentFEAR('ManipDec14Bulbectomie','fear');
Dir_All.Ext{3} = RestrictPathForExperiment(Dir_All.All{3},'Session','EXT-48h-envB')
Dir_All.Hab{3} = RestrictPathForExperiment(Dir_All.All{3},'Session','HAB-envA')

TimePostCS = 60; % freezign will be calculated during the CS and then for this amount of time after
Cols = {[0.4 0.4 0.4],[1 0.4 0.4],[0.8 0.6 0.6]};

SessionTypes = {'Hab','Ext'};
for exp = [4]
    
    for ss = 2
        clear FzPerc CSEpoch
        if exp ==5
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){1},Dir_All.(SessionTypes{ss}){2});
            Dir = MergePathForExperiment(Dir,Dir_All.(SessionTypes{ss}){3});
        elseif exp ==4
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){3},Dir_All.(SessionTypes{ss}){2});
        else
            Dir = Dir_All.(SessionTypes{ss}){exp};
        end
        
        if ss==1
            % Times for habituation
            CSMOINS=[226 391 559 709];
            CSPLUS=[151 316 486 634];
            CSEpoch{1}=intervalSet(0,120*1e4);
            CSEpoch{2}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+TimePostCS*1e4);
            CSEpoch{3}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+TimePostCS*1e4);
            
        else
            % Times for conditionning
            CSMOINS=[122 192 257 347];
            CSPLUS=[408 478 628 689 789 862 927 1007 1117 1178 1256 1320];
            CSEpoch{1}=intervalSet(0,120*1e4);
            CSEpoch{2}=intervalSet(CSMOINS*1e4,CSMOINS*1e4+TimePostCS*1e4);
            CSEpoch{3}=intervalSet(CSPLUS(1:4)*1e4,CSPLUS(1:4)*1e4+TimePostCS*1e4);
            CSEpoch{4}=intervalSet(CSPLUS(5:8)*1e4,CSPLUS(5:8)*1e4+TimePostCS*1e4);
            CSEpoch{5}=intervalSet(CSPLUS(9:12)*1e4,CSPLUS(9:12)*1e4+TimePostCS*1e4);
        end
        
        % Get the percent of time freezing
        for mm=1:length(Dir.path)
            mm
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
            for ep=1:length(CSEpoch)
                FzPerc(mm,ep)=100*length(Range(Restrict(Movtsd,and(FreezeEpoch,CSEpoch{ep}))))./length(Range(Restrict(Movtsd,CSEpoch{ep})));
            end
            
        end
        
        % Get the identity of the mice
        a=strfind(Dir.group,'OBX');
        CTRL=cellfun('isempty',a);
        
        
        
        %         % Make plot for controls
        %         IdMiceFz=(FzPerc(CTRL==1,:));
        %         for k= 1 :length(CSEpoch)
        %             a=iosr.statistics.boxPlot(k*2-0.8,IdMiceFz(:,k),'boxColor',[0.8 0.8 0.8],'lineColor',[0.8 0.8 0.8],'medianColor','k','boxWidth',0.5,'showOutliers',false);
        %             a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        %             a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        %             a.handles.medianLines.LineWidth = 5;
        %             hold on
        %         end
        %
        %         % Make plot for BBX
        %         IdMiceFz=(FzPerc(CTRL==0,:));
        %         for k= 1 :length(CSEpoch)
        %             a=iosr.statistics.boxPlot(k*2-0.2,IdMiceFz(:,k),'boxColor',[0.95 0.95 0.95],'lineColor',[0.95 0.95 0.95],'medianColor','k','boxWidth',0.5,'showOutliers',false);
        %             a.handles.upperWhiskers.Visible='off';a.handles.upperWhiskerTips.Visible='off';
        %             a.handles.lowerWhiskers.Visible='off';a.handles.lowerWhiskerTips.Visible='off';
        %             a.handles.medianLines.LineWidth = 5;
        %             hold on
        %         end
        %
        %         % put the individual points
        %         handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors','k','xValues',[1:2:length(CSEpoch)*2-1]+0.2,'spreadWidth',0.8), hold on;
        %         set(handlesplot{1},'MarkerSize',30)
        %         handlesplot=plotSpread(FzPerc(CTRL==1,:),'distributionColors',[0.6,0.6,0.6]*0.4,'xValues',[1:2:length(CSEpoch)*2-1]+0.2,'spreadWidth',0.8), hold on;
        %         set(handlesplot{1},'MarkerSize',20)
        %         handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors','k','xValues',[2:2:length(CSEpoch)*2]-0.2,'spreadWidth',0.8), hold on;
        %         set(handlesplot{1},'MarkerSize',30)
        %         handlesplot=plotSpread(FzPerc(CTRL==0,:),'distributionColors',[0.6,0.6,0.6],'xValues',[2:2:length(CSEpoch)*2]-0.2,'spreadWidth',0.8), hold on;
        %         set(handlesplot{1},'MarkerSize',20)
        %         xlim([0 length(CSEpoch)*2+1])
        %         set(gca,'FontSize',18,'XTick',[],'linewidth',1.5,'YTick',[0:20:100])
        %         ylabel('% time freezing')
        %         ylim([-5 90])
        %
        % do some stats
        
        
        % labels
        if ss == 1
            Vals = {(FzPerc(CTRL==1,2)),(FzPerc(CTRL==0,2)),(FzPerc(CTRL==1,3)),(FzPerc(CTRL==0,3))};
            Legends = {'Sham','OBX','Sham','OBX','Sham','OBX'};
            X = [1 2 4 5];
            
            if exp == 2 |exp == 3|exp == 4
                Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4]};
            else
                Cols = {[0.8 0.8 0.8],[0.8 0.6 0.6],[0.8 0.8 0.8],[0.8 0.6 0.6]};
            end
            figure
            MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
            ylabel('% time freezing')
            
            
            
        else
            
            Vals = {(FzPerc(CTRL==1,2)),(FzPerc(CTRL==0,2)),(FzPerc(CTRL==1,3)),(FzPerc(CTRL==0,3)),...
                (FzPerc(CTRL==1,4)),(FzPerc(CTRL==0,4)),(FzPerc(CTRL==1,5)),(FzPerc(CTRL==0,5))};
            Legends = {'Sham','OBX','Sham','OBX','Sham','OBX'};
            X = [1 2 4 5 7 8 10 11];
            
            if exp == 2 |exp == 3|exp == 4
                Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4],[0.8 0.8 0.8],[1 0.4 0.4]};
            else
                Cols = {[0.8 0.8 0.8],[0.8 0.6 0.6],[0.8 0.8 0.8],[0.8 0.6 0.6],[0.8 0.8 0.8],[0.8 0.6 0.6],[0.8 0.8 0.8],[0.8 0.6 0.6]};
            end
            figure
            MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
            ylabel('% time freezing')
            
            Vals = {(FzPerc(CTRL==1,1)),(FzPerc(CTRL==0,1))};
            Legends = {'Sham','OBX'};
            X = [1 2 ];
            
            if exp == 2 |exp == 3|exp == 4
                Cols = {[0.8 0.8 0.8],[1 0.4 0.4]};
            else
                Cols = {[0.8 0.8 0.8],[0.8 0.6 0.6]};
            end
            figure
            MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
            ylabel('% time freezing')
            
        end
        for k= 1 :length(CSEpoch)
            [p1(k),h(k),ci(k)]=ranksum(FzPerc(CTRL==1,k),FzPerc(CTRL==0,k))
            %             text(k*2-0.5,85,num2str(p1,2))
        end
        
    end
    
end

%% Calculation of effect sizes
Ctrl_freezing = FzPerc(CTRL==1,:);
BBX_freezing = FzPerc(CTRL==0,:);
for sessnum = 1:5
    s_cohen_num = (length(Ctrl_freezing(:,sessnum))-1)*var(Ctrl_freezing(:,sessnum))+(length(BBX_freezing(:,sessnum))-1)*var(BBX_freezing(:,sessnum));
    s_cohen_denom = length(Ctrl_freezing(:,sessnum)) + length(BBX_freezing(:,sessnum))-2;
    s_cohen = sqrt(s_cohen_num./s_cohen_denom);
    Size_Effect = (nanmean(Ctrl_freezing(:,sessnum))-nanmean(BBX_freezing(:,sessnum)))./s_cohen
end



%% Freezing durations
for exp = [4]
    
    for ss = 1:2
        clear FzPerc CSEpoch
        if exp ==5
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){1},Dir_All.(SessionTypes{ss}){2});
            Dir = MergePathForExperiment(Dir,Dir_All.(SessionTypes{ss}){3});
        elseif exp ==4
            Dir = MergePathForExperiment(Dir_All.(SessionTypes{ss}){3},Dir_All.(SessionTypes{ss}){2});
        else
            Dir = Dir_All.(SessionTypes{ss}){exp};
        end
        
        for mm=1:length(Dir.path)
            cd(Dir.path{mm})
            clear Movtsd FreezeEpoch
            try, load('behavResources.mat');catch,load('Behavior.mat'); end
            FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
            FreezeEpoch = dropShortIntervals(FreezeEpoch,2*1e4);
            TotEpoch = intervalSet(0,max(Range(Movtsd)));
            Fz.(SessionTypes{ss}){mm} = Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s');
            NoFz.(SessionTypes{ss}){mm} = Stop(TotEpoch-FreezeEpoch,'s')-Start(TotEpoch-FreezeEpoch,'s');
        end
    end
    
    % Get the identity of the mice
    a=strfind(Dir.group,'OBX');
    CTRL=cellfun('isempty',a);
    
    FzX = [0:1:60];
    FzY = [0:1:150];
    
    % Ctrl
    clear AllCtrlFz AllCtrlNoFz  AllBBXFz AllBBXNoFz MeanCtrlFz MeanCtrlNoFz MeanBBXNoFz MeanBBXFz
    IdMiceFz=find(CTRL==1);
    for k = 1:length(IdMiceFz)
        [Y,X] = hist(Fz.Ext{IdMiceFz(k)},FzX);
        AllCtrlFz(k,:) = cumsum(Y/sum(Y));
        MeanCtrlFz(k,:) = nanmean(Fz.Ext{IdMiceFz(k)});
        
        [Y,X] = hist(NoFz.Ext{IdMiceFz(k)},FzY);
        AllCtrlNoFz(k,:) = cumsum(Y/sum(Y));
        MeanCtrlNoFz(k,:) = nanmean(NoFz.Ext{IdMiceFz(k)});
        
    end
    
    IdMiceFz=find(CTRL==0);
    for k = 1:length(IdMiceFz)
        [Y,X] = hist(Fz.Ext{IdMiceFz(k)},FzX);
        AllBBXFz(k,:) = cumsum(Y/sum(Y));
        MeanBBXFz(k,:) = nanmean(Fz.Ext{IdMiceFz(k)});
        
        [Y,X] = hist(NoFz.Ext{IdMiceFz(k)},FzY);
        AllBBXNoFz(k,:) = cumsum(Y/sum(Y));
        MeanBBXNoFz(k,:) = nanmean(NoFz.Ext{IdMiceFz(k)});
        
    end
    
    Cols = {[0.8 0.8 0.8],[1 0.4 0.4]};
    figure
    subplot(121)
    plot(FzX,AllCtrlFz,'color',Cols{1},'linewidth',1.5)
    hold on
    %  errorbar(FzX,nanmean(AllCtrlFz),stdError(AllCtrlFz),'color','k','linewidth',3)
    plot(FzX,AllBBXFz,'color',Cols{2},'linewidth',1.5)
    xlim([min(FzX) max(FzX)])
    % errorbar(FzX,nanmean(AllBBXFz),stdError(AllBBXFz),'color','r','linewidth',3)
    set(gca,'FontSize',20,'Linewidth',2)
    xlabel('Episode dur(s)')
    box off
    ylim([0 1.05])
    subplot(122)
    plot(FzY,AllCtrlNoFz,'color',Cols{1},'linewidth',1.5)
    hold on
    % errorbar(FzY,nanmean(AllCtrlNoFz),stdError(AllCtrlNoFz),'color','k','linewidth',3)
    plot(FzY,AllBBXNoFz,'color',Cols{2},'linewidth',1.5)
    % errorbar(FzY,nanmean(AllBBXNoFz),stdError(AllBBXNoFz),'color','r','linewidth',3)
    xlabel('Episode dur(s)')
    xlim([min(FzY) max(FzY)])
    box off
    set(gca,'FontSize',20,'Linewidth',2)
    ylim([0 1.05])
    
    Vals = {MeanCtrlFz,MeanBBXFz};
    Legends = {'Sham','OBX'};
    X = [1 2 ];
    
    if exp == 2 |exp == 3|exp == 4
        Cols = {[0.8 0.8 0.8],[1 0.4 0.4]};
    else
        Cols = {[0.8 0.8 0.8],[0.8 0.6 0.6]};
    end
    figure
    MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
    ylabel('Bout duration (s)')
    
    Vals = {MeanCtrlNoFz,MeanBBXNoFz};
    Legends = {'Sham','OBX'};
    X = [1 2 ];
    
    if exp == 2 |exp == 3|exp == 4
        Cols = {[0.8 0.8 0.8],[1 0.4 0.4]};
    else
        Cols = {[0.8 0.8 0.8],[0.8 0.6 0.6]};
    end
    figure
    MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
    ylabel('Bout duration (s)')
    
    
    [p,h,ci]=ranksum(MeanCtrlFz,MeanBBXFz);
    [p,h,ci]=ranksum(MeanCtrlNoFz,MeanBBXNoFz);
    
end
