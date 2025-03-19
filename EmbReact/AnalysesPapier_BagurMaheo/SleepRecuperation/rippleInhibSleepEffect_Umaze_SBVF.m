clear all

Folder = FolderNames_UmazeSleepPrePost_RibInhib_SB;
Drug_Group={'RipControl','RipInhib',};
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {'k','r'};

clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for sess=1:2
        for mouse=1:length(Folder.(Drug_Group{group}).(Session_type{sess}))
            cd(Folder.(Drug_Group{group}).(Session_type{sess}){mouse})
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            Wake = Wake - TotalNoiseEpoch;
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            Tot = or(Wake,or(SWSEpoch,REMEpoch));
            
            
            %% Latency to sleep, dependant on how consolidated sleep is
            for merge_i=1:length(MergeForLatencyCalculation)
                LitEpo =dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4);
                if not(isempty(Start(LitEpo)))
                    LatencyToSleep.(Session_type{sess}).(Drug_Group{group})(mouse,merge_i) = min(Start(dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4),'s'));
                else
                    LatencyToSleep.(Session_type{sess}).(Drug_Group{group})(mouse,merge_i) = NaN;
                end
            end
            
            LatencyToREM.(Session_type{sess}).(Drug_Group{group})(mouse) = min(Start(REMEpoch,'s'));
            %% Variables averaged during the first hour
            LitEpoch = intervalSet(0,60*60*1e4);
            dat = Data(Restrict(tsdMovement,LitEpoch));
            subplot(2,2,(group-1)*2+sess)
            plot(dat(1:20:end)/1e7+(mouse-1)*20,'color',Cols{group})
            hold on
            
            [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
            %             SleepRipples = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).ripples.ts{mouse,4},LitEpoch);
            %             if length(SleepRipples) == 0
            %                 RipplesDensity.(Session_type{sess}).(Drug_Group{group})(mouse) = NaN;
            %             else
            %                 RipplesDensity.(Session_type{sess}).(Drug_Group{group})(mouse) = length(Range(SleepRipples))/sum(DurationEpoch(and(SWSEpoch,LitEpoch)));
            %             end
            
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
                LitEpoch = intervalSet((i-1)*60*10*1E4,i*60*10*1E4);
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

figure
% Plot in time
Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
NoLegends = {'',''};
timebins = 5:10:(size(Prop_time.(Session_type{sess}){1}.Wake,1)*10);
LimitGoodMouse = 500; % at least 500s not in noise
clear TempProfile
clear REM_1hr MnWk
Smo = 1;
for sess=1:2
    for i = 1:2
        TempProfile{i}.Tot = Prop_time.(Session_type{sess}){i}.Tot;
        TempProfile{i}.Wake = smooth2a(Prop_time.(Session_type{sess}){i}.Wake./TempProfile{i}.Tot,Smo,0);
        TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REMOverSleep = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),Smo,0);
        PropTimeFul{sess}(i,:) = nanmean( TempProfile{i}.Tot);
        MnWk.(Session_type{sess})(i,:) = nanmean(TempProfile{i}.Wake(1:6,:),1);
        REM_1hr.(Session_type{sess})(i,:) = nanmean(TempProfile{i}.REMOverSleep(2:5,:),1);
        %         % Get rid of mice without full sessions
        %         TempProfile{i}.Tot(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.Wake(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.SWS(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
        %         TempProfile{i}.REM(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
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
    TempProfile{1}.REMOverSleep(1,:) = NaN;
    TempProfile{2}.REMOverSleep(1,:) = NaN;
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
legend(Drug_Group)


%% REM fina =l figure
figure
% First point is all wake, get rid of it
TempProfile{1}.REMOverSleep(1,:) = 0;
TempProfile{2}.REMOverSleep(1,:) = 0;
errorbar(timebins,nanmean(TempProfile{1}.REMOverSleep'),stdError(TempProfile{1}.REMOverSleep'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(TempProfile{2}.REMOverSleep'),stdError(TempProfile{2}.REMOverSleep'),'color',Cols{2})
makepretty
xlabel('time(min)')
ylabel('REM/Sleep')
xlim([0 90])
ylim([0 0.2])
for ii = 1:10
    [p(ii),h] = ranksum(TempProfile{1}.REMOverSleep(ii,:),TempProfile{2}.REMOverSleep(ii,:));
    if p(ii)<0.05
        text(timebins(ii),0.18,'*','FontSize',18)
    end
end
legend(Drug_Group)



%%
figure
subplot(221)
plot(MnWk.sleep_pre(1,:),MnWk.sleep_post(1,:),'.','color',Cols{1})
makepretty
hold on
plot(MnWk.sleep_pre(2,:),MnWk.sleep_post(2,:),'.','color',Cols{2})
makepretty
axis square
ylim(xlim)
line([0 1],[0 1])
legend(Drug_Group)
xlabel('Wake prop - sleep Pre')
ylabel('Wake prop - sleep Post')

subplot(223)
A = {MnWk.sleep_pre(1,:),MnWk.sleep_pre(2,:),...
    MnWk.sleep_post(1,:),MnWk.sleep_post(2,:)};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[Drug_Group,Drug_Group],1,0)
xtickangle(45)
ylabel('Wake/Total')
clear p
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)

subplot(222)
plot(REM_1hr.sleep_pre(1,:),REM_1hr.sleep_post(1,:),'.','color',Cols{1})
makepretty
hold on
plot(REM_1hr.sleep_pre(2,:),REM_1hr.sleep_post(2,:),'.','color',Cols{2})
makepretty
axis square
ylim(xlim)
line([0 1],[0 1])
xlabel('REM prop - sleep Pre')
ylabel('REM prop - sleep Post')

subplot(224)
A = {REM_1hr.sleep_pre(1,:),REM_1hr.sleep_pre(2,:),...
    REM_1hr.sleep_post(1,:),REM_1hr.sleep_post(2,:)};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[Drug_Group,Drug_Group],1,0)
xtickangle(45)
ylabel('REM/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)

figure
plot(MnWk.sleep_pre(1,:),REM_1hr.sleep_post(1,:),'.','color',Cols{1})
makepretty
hold on
plot(MnWk.sleep_pre(2,:),REM_1hr.sleep_post(2,:),'.','color',Cols{2})
makepretty
axis square
ylim(xlim)
xlabel('Wake prop - sleep Pre')
ylabel('REM prop - sleep Post')
ylim([0 0.2])
[R,P] = corr([MnWk.sleep_pre(1,:)';MnWk.sleep_pre(2,:)'],[REM_1hr.sleep_post(1,:)';REM_1hr.sleep_post(2,:)']);



%% Wihtout the outliers
figure
subplot(211)
GoodCtrl = find(MnWk.sleep_pre(1,:)>0.4);

A = {MnWk.sleep_pre(1,GoodCtrl),MnWk.sleep_pre(2,:),...
    MnWk.sleep_post(1,GoodCtrl),MnWk.sleep_post(2,:)};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[Drug_Group,Drug_Group],1,0)
xtickangle(45)
ylabel('Wake/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)
subplot(212)

A = {REM_1hr.sleep_pre(1,GoodCtrl),REM_1hr.sleep_pre(2,:),...
    REM_1hr.sleep_post(1,GoodCtrl),REM_1hr.sleep_post(2,:)};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[Drug_Group,Drug_Group],1,0)
xtickangle(45)
ylabel('REM/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)


%%
figure
subplot(2,3,1)
A = {MeanDur.sleep_post{1}.Wake,MeanDur.sleep_post{2}.Wake};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('Wake ep dur')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

subplot(2,3,2)
A = {MeanDur.sleep_post{1}.SWS,MeanDur.sleep_post{2}.SWS};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('NREM ep dur')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

subplot(2,3,3)
A = {MeanDur.sleep_post{1}.REM,MeanDur.sleep_post{2}.REM};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('REM ep dur')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

subplot(2,3,4)
A = {EpNum.sleep_post{1}.Wake,EpNum.sleep_post{2}.Wake};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('Wake ep num')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

subplot(2,3,5)
A = {EpNum.sleep_post{1}.SWS,EpNum.sleep_post{2}.SWS};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('NREM ep num')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

subplot(2,3,6)
A = {EpNum.sleep_post{1}.REM,EpNum.sleep_post{2}.REM};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('REM ep num')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

%% Latencies - nthg sig
figure
Lat = 2;
A = {LatencyToSleep.sleep_post.RipControl(:,Lat),LatencyToSleep.sleep_post.RipInhib(:,Lat)};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('Wake latency')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)


%% figure - sanity scheck wake
figure
A = {EpNum.sleep_post{1}.Wake.*MeanDur.sleep_post{1}.Wake ...
    ,EpNum.sleep_post{2}.Wake.*MeanDur.sleep_post{2}.Wake};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('Wake dur recalculated')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)

%% figure - sanity REM
figure
A = {EpNum.sleep_post{1}.REM.*MeanDur.sleep_post{1}.REM ...
    ,EpNum.sleep_post{2}.REM.*MeanDur.sleep_post{2}.REM};
MakeSpreadAndBoxPlot_SB(A,[Cols],[1,2],[Drug_Group],1,0)
xtickangle(45)
ylabel('REM dur recalculated')
clear p
[p(1),h] = ranksum(A{1},A{2});
sigstar({[1,2]},p)








%% Look at the hypnograms
clear all

Folder = FolderNames_UmazeSleepPrePost_RibInhib_SB;
Drug_Group={'RipControl','RipInhib',};
Session_type={'sleep_pre','sleep_post'};
MergeForLatencyCalculation = [1,5,10,15,20:10:60];
Cols = {'k','r'};


clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for sess=1:2
        for mouse=1:length(Folder.(Drug_Group{group}).(Session_type{sess}))
            cd(Folder.(Drug_Group{group}).(Session_type{sess}){mouse})
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            Wake = or(Wake,TotalNoiseEpoch);
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            Tot = or(Wake,or(SWSEpoch,REMEpoch));
            
            FirstSleep{sess}{group}(mouse) = min(Start(dropShortIntervals(SWSEpoch,1*1e4)));
            FirstREM{sess}{group}(mouse) = min(Start(REMEpoch));
            PostSleep = intervalSet(FirstSleep{sess}{group}(mouse),FirstREM{sess}{group}(mouse)+3600*1e4);
            WASO{sess}{group}(mouse) = sum(DurationEpoch(and(Wake,PostSleep),'s'))./sum(DurationEpoch((PostSleep),'s'));
            % WASO dropping wake
            for ii = 1:60
                WASO_dropwake{sess}{group}(mouse,ii) = sum(DurationEpoch(and(dropShortIntervals(Wake,ii*1e4),PostSleep),'s'))./sum(DurationEpoch((PostSleep),'s'));
               
            end
            for i = 1:6
                LitEpoch = intervalSet(FirstSleep{sess}{group}(mouse)+(i-1)*60*10*1E4,FirstSleep{sess}{group}(mouse)+i*60*10*1E4);
                if sum(DurationEpoch(and(Tot,LitEpoch)))/1E4 >590
                    [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
                    % Amount of time in the state
                    [AllDur_Tot,Prop_time.(Session_type{sess}){group}.Tot(i,mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
                    [AllDur_Wk,Prop_time.(Session_type{sess}){group}.Wake(i,mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
                    [AllDur_SWS,Prop_time.(Session_type{sess}){group}.SWS(i,mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
                    [AllDur_REM,Prop_time.(Session_type{sess}){group}.REM(i,mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
                end
            end
        end
    end
end

figure
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for sess=1:2
        for mouse=1:length(Folder.(Drug_Group{group}).(Session_type{sess}))
            cd(Folder.(Drug_Group{group}).(Session_type{sess}){mouse})
            load('SleepScoring_Accelero.mat','Wake','SWSEpoch','REMEpoch','TotalNoiseEpoch','tsdMovement')
            Wake = or(Wake,TotalNoiseEpoch);
            REMEpoch = REMEpoch - TotalNoiseEpoch;
            SWSEpoch = SWSEpoch - TotalNoiseEpoch;
            
            [A,B] = sort( FirstSleep{2}{group});order = find(B==mouse);
            subplot(2,2,(sess-1)*2+group)
            SleepStages=PlotSleepStage(Wake,SWSEpoch,REMEpoch,0,[order*5 1]);
            title(Drug_Group{group})
            xlim([0 5000])
        end
        plot(A/1e4,8+[0:5:48],'k')
    end
end



%% WASO
figure,MakeSpreadAndBoxPlot_SB(WASO{2},{},[1,2],{},1,0)
ylabel('WASO')
[p,h] = ranksum(WASO{2}{1},WASO{2}{2})
set(gca,'XTickLabel',Drug_Group)
sigstar({[1,2]},p)

%% Temporal evolution
figure
% Plot in time
Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
NoLegends = {'',''};
timebins = 5:10:(size(Prop_time.(Session_type{sess}){1}.Wake,1)*10);
LimitGoodMouse = 500; % at least 500s not in noise
clear TempProfile
clear REM_1hr MnWk
Smo = 1;
for sess=1:2
    for i = 1:2
        TempProfile{i}.Tot = Prop_time.(Session_type{sess}){i}.Tot;
        TempProfile{i}.Wake = smooth2a(Prop_time.(Session_type{sess}){i}.Wake./TempProfile{i}.Tot,Smo,0);
        TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.Tot),Smo,0);
        TempProfile{i}.REMOverSleep = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),Smo,0);
        REM_1hr.(Session_type{sess})(i,:) = nanmean(TempProfile{i}.REMOverSleep(1:4,:),1);

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
legend(Drug_Group)


% REM post falling asleep
clear p
figure
A = {REM_1hr.sleep_pre(1,:),REM_1hr.sleep_pre(2,:),...
    REM_1hr.sleep_post(1,:),REM_1hr.sleep_post(2,:)};
MakeSpreadAndBoxPlot_SB(A,[Cols,Cols],[1,2,4,5],[Drug_Group,Drug_Group],1,0)
xtickangle(45)
ylabel('REM/Total')
[p(1),h] = ranksum(A{1},A{2});
[p(2),h] = ranksum(A{3},A{4});
sigstar({[1,2],[4,5]},p)


errorbar(1:60,nanmean( WASO_dropwake{2}{1}),stdError( WASO_dropwake{2}{1}),'k')
hold on
errorbar(1:60,nanmean( WASO_dropwake{2}{2}),stdError( WASO_dropwake{2}{1}),'r')

 legend(Drug_Group)
xlabel('wake longer than XX s')
ylabel('WASO')

for ii = 1:60
    [p(ii),h] = ranksum( WASO_dropwake{2}{1}(:,ii),WASO_dropwake{2}{2}(:,ii))
end