clear all

Folder.Cond = PathForExperimentsERC('UMazePAG');
Folder.Known = PathForExperimentsERC('Known');
Folder.Novel = PathForExperimentsERC('Novel');

MouseGroup = fieldnames(Folder);
NumGroups = length(MouseGroup);
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {'k','r','m'};

clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(MouseGroup)
    disp(MouseGroup{group})
    for mouse=1:length(Folder.(MouseGroup{group}).path)
        cd(Folder.(MouseGroup{group}).path{mouse}{1})
        % Get sleep info
        clear Wake REMEpoch SWSEpoch Tot
        load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        Wake_All = Wake - TotalNoiseEpoch;
        REMEpoch_All = REMEpoch - TotalNoiseEpoch;
        SWSEpoch_All = SWSEpoch - TotalNoiseEpoch;
        Tot_All = or(Wake,or(SWSEpoch,REMEpoch));
        
        % Get pre and post periods
        clear ExpeInfo TTLInfo
        load('ExpeInfo.mat')
        load('behavResources.mat','TTLInfo','SessionEpoch')
        %             SleepPre_Num = find(~cellfun(@isempty,strfind(ExpeInfo.PreProcessingInfo.FolderSessionName,'PreSleep')));
        %             Epoch.sleep_pre = intervalSet(TTLInfo.StartSession(SleepPre_Num),TTLInfo.StopSession(SleepPre_Num));
        %             SleepPost_Num = find(~cellfun(@isempty,strfind(ExpeInfo.PreProcessingInfo.FolderSessionName,'PostSleep')));
        %             if SleepPost_Num>size(TTLInfo.StartSession,1)
        %                 Epoch.sleep_post = intervalSet(TTLInfo.StartSession(end),TTLInfo.StopSession(end));
        %             else
        %                 Epoch.sleep_post = intervalSet(TTLInfo.StartSession(SleepPost_Num),TTLInfo.StopSession(SleepPost_Num));
        %             end
        
        Epoch.sleep_pre  = SessionEpoch.PreSleep;
        Epoch.sleep_post= SessionEpoch.PostSleep;
        
        
        for sess=1:2
            
            %% Restrict to session
            Wake = and(Wake_All,Epoch.(Session_type{sess}));
            REMEpoch = and(REMEpoch_All,Epoch.(Session_type{sess}));
            SWSEpoch = and(SWSEpoch_All,Epoch.(Session_type{sess}));
            if isempty(min(Start(REMEpoch,'s')))
                REMEpoch = intervalSet(min(Start(Wake))-1e4,min(Start(Wake))-0.9e4);
            end
            if isempty(min(Start(SWSEpoch,'s')))
                SWSEpoch = intervalSet(min(Start(Wake))-0.8e4,min(Start(Wake))-0.7e4);
            end
            Tot = and(Tot_All,Epoch.(Session_type{sess}));
            
            %% Latency to sleep, dependant on how consolidated sleep is
            for merge_i=1:length(MergeForLatencyCalculation)
                LitEpo =dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4);
                if not(isempty(Start(LitEpo)))
                    LatencyToSleep.(Session_type{sess}).(MouseGroup{group})(mouse,merge_i) = min(Start(dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4),'s')) - min(Start(Epoch.(Session_type{sess})));
                else
                    LatencyToSleep.(Session_type{sess}).(MouseGroup{group})(mouse,merge_i) = NaN;
                end
            end
            
            LatencyToREM.(Session_type{sess}).(MouseGroup{group})(mouse) = min(Start(REMEpoch,'s')) - min(Start(Epoch.(Session_type{sess})));
            %% Variables averaged during the first hour
            LitEpoch = intervalSet(min(Start(Epoch.(Session_type{sess}))), min(Start(Epoch.(Session_type{sess}))) + 60*60*1e4);
            dat = Data(Restrict(tsdMovement,LitEpoch));
            subplot(NumGroups,2,(group-1)*2+sess)
            plot(dat(1:20:end)/1e7+(mouse-1)*20,'color',Cols{group})
            hold on
            
            [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
            
            [AllDur_Tot,Prop.(Session_type{sess}){group}.Tot(mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.Tot(mouse) = Prop.(Session_type{sess}){group}.Tot(mouse)/DurLitEpo;
            
            [AllDur_Wk,Prop.(Session_type{sess}){group}.Wake(mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.Wake(mouse) = Prop.(Session_type{sess}){group}.Wake(mouse)/DurLitEpo;
            
            [AllDur_SWS,Prop.(Session_type{sess}){group}.SWS(mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.SWS(mouse) = Prop.(Session_type{sess}){group}.SWS(mouse)/DurLitEpo;
            [AllDur_REM,Prop.(Session_type{sess}){group}.REM(mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.REM(mouse) = Prop.(Session_type{sess}){group}.REM(mouse)/DurLitEpo;
            
            % Mean episode dur in the state
            MeanDur.(Session_type{sess}){group}.Wake(mouse) = nanmean(AllDur_Wk);
            MeanDur.(Session_type{sess}){group}.SWS(mouse) = nanmean(AllDur_SWS);
            MeanDur.(Session_type{sess}){group}.REM(mouse) = nanmean(AllDur_REM);
            
            % Number of episodes in the state
            EpNum.(Session_type{sess}){group}.Wake(mouse) = length(AllDur_Wk);
            EpNum.(Session_type{sess}){group}.SWS(mouse) = length(AllDur_SWS);
            EpNum.(Session_type{sess}){group}.REM(mouse) = length(AllDur_REM);
            
            %% Variables in time
            for i = 1:11
                LitEpoch = intervalSet(min(Start(Epoch.(Session_type{sess}))) + (i-1)*60*10*1E4,min(Start(Epoch.(Session_type{sess}))) + i*60*10*1E4);
                if sum(DurationEpoch(and(Tot,LitEpoch)))/1E4 >590
                    [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
                    % Amount of time in the state
                    [AllDur_Tot,Prop_time.(Session_type{sess}){group}.Tot(i,mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
                    [AllDur_Wk,Prop_time.(Session_type{sess}){group}.Wake(i,mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
                    [AllDur_SWS,Prop_time.(Session_type{sess}){group}.SWS(i,mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
                    [AllDur_REM,Prop_time.(Session_type{sess}){group}.REM(i,mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
                    
                    % Mean episode dur in the state
                    MeanDur_time.(Session_type{sess}){group}.Wake(i,mouse) = nanmean(AllDur_Wk);
                    MeanDur_time.(Session_type{sess}){group}.SWS(i,mouse) = nanmean(AllDur_SWS);
                    MeanDur_time.(Session_type{sess}){group}.REM(i,mouse) = nanmean(AllDur_REM);
                    
                    % Number of episodes in the state
                    EpNum_time.(Session_type{sess}){group}.Wake(i,mouse) = length(AllDur_Wk);
                    EpNum_time.(Session_type{sess}){group}.SWS(i,mouse) = length(AllDur_SWS);
                    EpNum_time.(Session_type{sess}){group}.REM(i,mouse) = length(AllDur_REM);
                    
                else
                    Prop_time.(Session_type{sess}){group}.Tot(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    MeanDur_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    MeanDur_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    MeanDur_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    EpNum_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    EpNum_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    EpNum_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    
                end
            end
            
            
        end
        
    end
end



%% Figures
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/RippleEffect
load('SessionInfo_KnownNovel.mat'); sess=2;
Session_type={'sleep_pre','sleep_post'};

for ss = 1:3
    GoodMice{ss} = find(CondDur{ss}>4000 & CondDur{ss}<8000);% & SleepStart{ss}>13 & SleepStart{ss}<16) 
end

figure
% Plot in time
Cols = {[0.75, 0.75, 0],[0 0.75 0.75],[0.75 0 0.75]};
X = [1:2];
NoLegends = {'',''};
timebins = 5:10:(size(Prop_time.(Session_type{sess}){1}.Wake,1)*10);
LimitGoodMouse = 500; % at least 500s not in noise
clear TempProfile
clear REM_1hr MnWk
Smo = 1;
for sess=1:2
    for i = 1:3
        TempProfile{i}.Tot = Prop_time.(Session_type{sess}){i}.Tot;
        TempProfile{i}.Wake = smooth2a(Prop_time.(Session_type{sess}){i}.Wake./TempProfile{i}.Tot,Smo,0);
        TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REMOverSleep = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),Smo,0);
        %         PropTimeFul{sess}(i,:) = nanmean( TempProfile{i}.Tot');
        MnWk.(Session_type{sess}){i} = nanmean(TempProfile{i}.Wake(1:6,:),1);
        REM_1hr.(Session_type{sess}){i} = nanmean(TempProfile{i}.REMOverSleep(4:7,:),1);
        %         % Get rid of mice without full sessions
        %         TempProfile{i}.Tot(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.Wake(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.SWS(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.REM(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
    end
    
    
    
    subplot(4,2,1+(sess-1))
    for i = 1:3
        errorbar(timebins,nanmean(TempProfile{i}.Wake(:, GoodMice{i})'),stdError(TempProfile{i}.Wake(:, GoodMice{i})'),'color',Cols{i})
        hold on
    end
    makepretty
    xlabel('time(min)')
    ylabel('Wake/Total')
    xlim([0 90])
    ylim([0 1])
    
    subplot(4,2,3+(sess-1))
    for i = 1:3
        errorbar(timebins,nanmean(TempProfile{i}.SWS(:, GoodMice{i})'),stdError(TempProfile{i}.SWS(:, GoodMice{i})'),'color',Cols{i})
        hold on
    end
    makepretty
    xlabel('time(min)')
    ylabel('NREM/Total')
    xlim([0 90])
    ylim([0 1])
    
    subplot(4,2,5+(sess-1))
    for i = 1:3
        errorbar(timebins,nanmean(TempProfile{i}.REM(:, GoodMice{i})'),stdError(TempProfile{i}.REM(:, GoodMice{i})'),'color',Cols{i})
        hold on
    end
    makepretty
    xlabel('time(min)')
    ylabel('REM/Total')
    xlim([0 90])
    ylim([0 0.2])
    
    subplot(4,2,7+(sess-1))
    % First point is all wake, get rid of it
    for i = 1:3
        errorbar(timebins,nanmean(TempProfile{i}.REMOverSleep(:, GoodMice{i})'),stdError(TempProfile{i}.REMOverSleep(:, GoodMice{i})'),'color',Cols{i})
        hold on
    end
    makepretty
    xlabel('time(min)')
    ylabel('REM/Sleep')
    xlim([0 90])
    ylim([0 0.2])
end
legend(MouseGroup)

%% Repeated measures anova
%% REM fina =l figure
figure
% First point is all wake, get rid of it
B=TempProfile{1}.REMOverSleep(:, GoodMice{1})';
A=[TempProfile{2}.REMOverSleep(:, GoodMice{2})';TempProfile{3}.REMOverSleep(:, GoodMice{3})'];
A(isnan(A)) = 0;
B(isnan(B)) = 0;
errorbar(timebins,nanmean(A),stdError(A),'color',Cols{1})
hold on
errorbar(timebins,nanmean(B),stdError(B),'color',Cols{2})
makepretty
xlabel('time(min)')
ylabel('REM/Sleep')
xlim([0 90])
ylim([0 0.2])
for ii = 1:10
    try
    [p(ii),h] = ranksum(TempProfile{1}.REMOverSleep(ii,:),TempProfile{2}.REMOverSleep(ii,:));
    if p(ii)<0.05
        text(timebins(ii),0.18,'*','FontSize',18)
    end
    end
end
legend({'NoCond','Cond'})


%%
figure
subplot(221)
for i = 1:3
plot(MnWk.sleep_pre{i},MnWk.sleep_post{i},'.','color',Cols{i})
hold on
end
makepretty
axis square
ylim(xlim)
line([0 1],[0 1])
legend(MouseGroup)
xlabel('Wake prop - sleep Pre')
ylabel('Wake prop - sleep Post')

subplot(223)
A = [MnWk.sleep_pre,...
    MnWk.sleep_post];
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,3,5,6,7],[MouseGroup,MouseGroup],1,0)
xtickangle(45)
ylabel('Wake/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)

subplot(222)
for i = 1:3
plot(REM_1hr.sleep_pre{i},REM_1hr.sleep_post{i},'.','color',Cols{i})
hold on
end
makepretty
axis square
ylim(xlim)
line([0 1],[0 1])
xlabel('REM prop - sleep Pre')
ylabel('REM prop - sleep Post')

subplot(224)
A = {REM_1hr.sleep_pre{1}(GoodMice{1}),REM_1hr.sleep_pre{2}(GoodMice{2}),REM_1hr.sleep_pre{3}(GoodMice{3}),...
    REM_1hr.sleep_post{1}(GoodMice{1}),REM_1hr.sleep_post{2}(GoodMice{2}),REM_1hr.sleep_post{3}(GoodMice{3})};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,3,5,6,7],[MouseGroup,MouseGroup],1,0)
xtickangle(45)
ylabel('REM/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)
%
% figure
% plot(MnWk.sleep_pre(1,:),REM_1hr.sleep_post(1,:),'.','color',Cols{1})
% makepretty
% hold on
% plot(MnWk.sleep_pre(2,:),REM_1hr.sleep_post(2,:),'.','color',Cols{2})
% makepretty
% axis square
% ylim(xlim)
% xlabel('Wake prop - sleep Pre')
% ylabel('REM prop - sleep Post')
% ylim([0 0.2])
% [R,P] = corr([MnWk.sleep_pre(1,:)';MnWk.sleep_pre(2,:)'],[REM_1hr.sleep_post(1,:)';REM_1hr.sleep_post(2,:)']);
%
%
%
% %% Wihtout the outliers
% figure
% subplot(211)
% GoodCtrl = find(MnWk.sleep_pre(1,:)>0.4);
%
% A = {MnWk.sleep_pre(1,GoodCtrl),MnWk.sleep_pre(2,:),...
%     MnWk.sleep_post(1,GoodCtrl),MnWk.sleep_post(2,:)};
% MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[MouseGroup,MouseGroup],1,0)
% xtickangle(45)
% ylabel('Wake/Total')
% [p(1),h] = ranksum(A{1},A{2});
% [p(2),h] = ranksum(A{3},A{4});
% sigstar({[1,2],[4,5]},p)
% subplot(212)
%
% A = {REM_1hr.sleep_pre(1,GoodCtrl),REM_1hr.sleep_pre(2,:),...
%     REM_1hr.sleep_post(1,GoodCtrl),REM_1hr.sleep_post(2,:)};
% MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[MouseGroup,MouseGroup],1,0)
% xtickangle(45)
% ylabel('REM/Total')
% [p(1),h] = ranksum(A{1},A{2});
% [p(2),h] = ranksum(A{3},A{4});
% sigstar({[1,2],[4,5]},p)
%
%
% %%
% figure
% subplot(2,3,1)
% A = {MeanDur.sleep_post{1}.Wake,MeanDur.sleep_post{2}.Wake};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('Wake ep dur')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% subplot(2,3,2)
% A = {MeanDur.sleep_post{1}.SWS,MeanDur.sleep_post{2}.SWS};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('NREM ep dur')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% subplot(2,3,3)
% A = {MeanDur.sleep_post{1}.REM,MeanDur.sleep_post{2}.REM};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('REM ep dur')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% subplot(2,3,4)
% A = {EpNum.sleep_post{1}.Wake,EpNum.sleep_post{2}.Wake};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('Wake ep num')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% subplot(2,3,5)
% A = {EpNum.sleep_post{1}.SWS,EpNum.sleep_post{2}.SWS};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('NREM ep num')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% subplot(2,3,6)
% A = {EpNum.sleep_post{1}.REM,EpNum.sleep_post{2}.REM};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('REM ep num')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% %% Latencies - nthg sig
% figure
% Lat = 2;
% A = {LatencyToSleep.sleep_post.RipControl(:,Lat),LatencyToSleep.sleep_post.RipInhib(:,Lat)};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('Wake latency')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
%
% %% figure - sanity scheck wake
% figure
% A = {EpNum.sleep_post{1}.Wake.*MeanDur.sleep_post{1}.Wake ...
%     ,EpNum.sleep_post{2}.Wake.*MeanDur.sleep_post{2}.Wake};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('Wake dur recalculated')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
% %% figure - sanity REM
% figure
% A = {EpNum.sleep_post{1}.REM.*MeanDur.sleep_post{1}.REM ...
%     ,EpNum.sleep_post{2}.REM.*MeanDur.sleep_post{2}.REM};
% MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[MouseGroup],1,0)
% xtickangle(45)
% ylabel('REM dur recalculated')
% clear p
% [p(1),h] = ranksum(A{1},A{2});
% sigstar({[1,2]},p)
%
%
%% Look at the hypnograms
clear all
Folder.Cond = PathForExperimentsERC('UMazePAG');
Folder.Known = PathForExperimentsERC('Known');
Folder.Novel = PathForExperimentsERC('Novel');

MouseGroup = fieldnames(Folder);
NumGroups = length(MouseGroup);
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {'k','r','m'};

clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(MouseGroup)
    disp(MouseGroup{group})
    for mouse=1:length(Folder.(MouseGroup{group}).path)
        cd(Folder.(MouseGroup{group}).path{mouse}{1})
        % Get sleep info
        clear Wake REMEpoch SWSEpoch Tot
        load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        Wake_All = or(Wake,TotalNoiseEpoch);
        REMEpoch_All = REMEpoch - TotalNoiseEpoch;
        SWSEpoch_All = SWSEpoch - TotalNoiseEpoch;
        Tot_All = or(Wake,or(SWSEpoch,REMEpoch));
        
        % Get pre and post periods
        clear ExpeInfo TTLInfo
        load('ExpeInfo.mat')
        load('behavResources.mat','TTLInfo','SessionEpoch')
        
        Epoch.sleep_pre  = SessionEpoch.PreSleep;
        Epoch.sleep_post= SessionEpoch.PostSleep;
        
        for sess=1:2
            stsess = min(Start(Epoch.(Session_type{sess})));

            %% Restrict to session
            Wake = and(Wake_All,Epoch.(Session_type{sess}));
            REMEpoch = and(REMEpoch_All,Epoch.(Session_type{sess}));
            SWSEpoch = and(SWSEpoch_All,Epoch.(Session_type{sess}));
            if isempty(min(Start(REMEpoch,'s')))
                REMEpoch = intervalSet(min(Start(Wake))-1e4,min(Start(Wake))-0.9e4);
                FirstREM{sess}{group}(mouse) =  min(Start(Epoch.(Session_type{sess})));
            else
                FirstREM{sess}{group}(mouse) = min(Start(REMEpoch));
            end
            if isempty(min(Start(SWSEpoch,'s')))
                SWSEpoch = intervalSet(min(Start(Wake))-0.8e4,min(Start(Wake))-0.7e4);
                FirstSleep{sess}{group}(mouse) =  stsess;
                FirstSleep_Realigned{sess}{group}(mouse) = FirstSleep{sess}{group}(mouse) - stsess;

            else
                FirstSleep{sess}{group}(mouse) = min(Start(dropShortIntervals(SWSEpoch,100*1e4)));
                FirstSleep_Realigned{sess}{group}(mouse) = FirstSleep{sess}{group}(mouse) - stsess;

            end
            Tot = and(Tot_All,Epoch.(Session_type{sess}));
            
            PostSleep = intervalSet(FirstSleep{sess}{group}(mouse),FirstSleep{sess}{group}(mouse)+3600*1e4);
            WASO{sess}{group}(mouse) = sum(DurationEpoch(and(Wake,PostSleep),'s'))./sum(DurationEpoch((PostSleep),'s'));
            % WASO dropping wake
            for ii = 1:60
                WASO_dropwake{sess}{group}(mouse,ii) = sum(DurationEpoch(and(dropShortIntervals(Wake,ii*1e4),PostSleep),'s'))./sum(DurationEpoch((PostSleep),'s'));
            end
            
            for i = 1:6
                LitEpoch = intervalSet(FirstSleep{sess}{group}(mouse)+(i-1)*60*10*1E4,FirstSleep{sess}{group}(mouse)+i*60*10*1E4);
                if sum(DurationEpoch(and(Tot,LitEpoch)))/1E4 >500
                    [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
                    % Amount of time in the state
                    [AllDur_Tot,Prop_time.(Session_type{sess}){group}.Tot(i,mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
                    [AllDur_Wk,Prop_time.(Session_type{sess}){group}.Wake(i,mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
                    [AllDur_SWS,Prop_time.(Session_type{sess}){group}.SWS(i,mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
                    [AllDur_REM,Prop_time.(Session_type{sess}){group}.REM(i,mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
                else
                    disp('problem')
                end
            end
        end
    end
end

cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/RippleEffect
load('SessionInfo_KnownNovel.mat')
for ss = 1:3
    GoodMice{ss} = find(CondDur{ss}>4000 & CondDur{ss}<8000);% & SleepStart{ss}>13 & SleepStart{ss}<16) 
end


figure
for group=1:length(MouseGroup)
    disp(MouseGroup{group})
    for mouse=1:length(Folder.(MouseGroup{group}).path)
        cd(Folder.(MouseGroup{group}).path{mouse}{1})
        % Get sleep info
        clear Wake REMEpoch SWSEpoch Tot
        load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
        Wake_All = Wake - TotalNoiseEpoch;
        REMEpoch_All = REMEpoch - TotalNoiseEpoch;
        SWSEpoch_All = SWSEpoch - TotalNoiseEpoch;
        Tot_All = or(Wake,or(SWSEpoch,REMEpoch));
        
        % Get pre and post periods
        clear ExpeInfo TTLInfo
        load('ExpeInfo.mat')
        load('behavResources.mat','TTLInfo','SessionEpoch')
        
        Epoch.sleep_pre  = SessionEpoch.PreSleep;
        Epoch.sleep_post= SessionEpoch.PostSleep;
        
        for sess=1:2
            
            %% Restrict to session
            Wake = and(Wake_All,Epoch.(Session_type{sess}));
            REMEpoch = and(REMEpoch_All,Epoch.(Session_type{sess}));
            SWSEpoch = and(SWSEpoch_All,Epoch.(Session_type{sess}));
            stsess = min(Start(Epoch.(Session_type{sess})));
            Wake = intervalSet(Start(Wake) - stsess,Stop(Wake) - stsess);
            REMEpoch = intervalSet(Start(REMEpoch) - stsess,Stop(REMEpoch) - stsess);
            SWSEpoch = intervalSet(Start(SWSEpoch) - stsess,Stop(SWSEpoch) - stsess);
            [A,B] = sort( FirstSleep_Realigned{sess}{group});order = find(B==mouse);
            subplot(3,2,(group-1)*2+sess)
            SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[order*5 1]);
            title(MouseGroup{group})
            xlim([0 5000])
        end
    end
    for sess=1:2
        [A,B] = sort( FirstSleep_Realigned{sess}{group});order = find(B==mouse);
            subplot(3,2,(group-1)*2+sess)
        plot(A/1e4,8+[0:5:5*length(A)-5],'m')
    end
end

%% WASO
figure,MakeSpreadAndBoxPlot_SB(WASO{2},{},[1,2,3],{},1,0)
ylabel('WASO')
[p,h] = ranksum(WASO{2}{1},WASO{2}{2})
set(gca,'XTickLabel',MouseGroup)
sigstar({[1,2]},p)

%% Temporal evolution
figure
% Plot in time
X = [1:3];
NoLegends = {'',''};
timebins = 5:10:(size(Prop_time.(Session_type{sess}){1}.Wake,1)*10);
LimitGoodMouse = 500; % at least 500s not in noise
clear TempProfile
clear REM_1hr MnWk
Smo = 1;
for sess=1:2
    for i = 1:3
        TempProfile{i}.Tot = Prop_time.(Session_type{sess}){i}.Tot;
        TempProfile{i}.Wake = smooth2a(Prop_time.(Session_type{sess}){i}.Wake./TempProfile{i}.Tot,Smo,0);
        TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REMOverSleep = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),Smo,0);

    end


    subplot(4,2,1+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.Wake'),stdError(TempProfile{1}.Wake'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.Wake'),stdError(TempProfile{2}.Wake'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('Wake/Total')
    xlim([0 90])
    ylim([0 1])

    subplot(4,2,3+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.SWS'),stdError(TempProfile{1}.SWS'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.SWS'),stdError(TempProfile{2}.SWS'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('NREM/Total')
    xlim([0 90])
    ylim([0 1])

    subplot(4,2,5+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.REM'),stdError(TempProfile{1}.REM'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.REM'),stdError(TempProfile{2}.REM'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('REM/Total')
    xlim([0 90])
    ylim([0 0.2])

    subplot(4,2,7+(sess-1))
    % First point is all wake, get rid of it
    ylim([0 0.2])
    errorbar(timebins,nanmean(TempProfile{1}.REMOverSleep'),stdError(TempProfile{1}.REMOverSleep'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.REMOverSleep'),stdError(TempProfile{2}.REMOverSleep'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('REM/Sleep')
    xlim([0 90])
    ylim([0 0.2])
end
legend(MouseGroup)


% % REM post falling asleep
% figure
% A = {REM_1hr.sleep_pre(1,:),REM_1hr.sleep_pre(2,:),...
%     REM_1hr.sleep_post(1,:),REM_1hr.sleep_post(2,:)};
% MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[MouseGroup,MouseGroup],1,0)
% xtickangle(45)
% ylabel('REM/Total')
% [p(1),h] = ranksum(A{1},A{2});
% [p(2),h] = ranksum(A{3},A{4});
% sigstar({[1,2],[4,5]},p)
%
%
% errorbar(1:60,nanmean( WASO_dropwake{2}{1}),stdError( WASO_dropwake{2}{1}),'k')
% hold on
% errorbar(1:60,nanmean( WASO_dropwake{2}{2}),stdError( WASO_dropwake{2}{1}),'r')
%
%  legend(MouseGroup)
% xlabel('wake longer than XX s')
% ylabel('WASO')
%
% for ii = 1:60
%     [p(ii),h] = ranksum( WASO_dropwake{2}{1}(:,ii),WASO_dropwake{2}{2}(:,ii))
% end