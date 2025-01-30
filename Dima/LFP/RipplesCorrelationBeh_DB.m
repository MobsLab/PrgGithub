%% Parameters
sav=0;
old = 0;
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/DuringTask/';

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 906 911 912]);

%% Get Data
for i = 1:length(Dir.path)
        Rip{i} = load([Dir.path{i}{1} 'Ripples.mat'], 'ripples');
        a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources', 'SessionEpoch', 'ZoneEpoch',...
            'FreezeAccEpoch');
end

%% Find indices of PreTests and PostTest session in the structure
id_Pre = cell(1,length(a));
id_Post = cell(1,length(a));
id_Cond = cell(1,length(a));

for i=1:length(a)
    id_Pre{i} = zeros(1,length(a{i}.behavResources));
    id_Cond{i} = zeros(1,length(a{i}.behavResources));
    id_Post{i} = zeros(1,length(a{i}.behavResources));
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPre'))
            id_Pre{i}(k) = 1;
        end
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'TestPost'))
            id_Post{i}(k) = 1;
        end
    end
    for k=1:length(a{i}.behavResources)
        if ~isempty(strfind(a{i}.behavResources(k).SessionName,'Cond'))
            id_Cond{i}(k) = 1;
        end
    end
    id_Cond{i}=find(id_Cond{i});
    id_Pre{i}=find(id_Pre{i});
    id_Post{i}=find(id_Post{i});
end

%% Calculate average occupancy
% Calculate occupancy de novo
for i=1:length(a)
    for k=1:length(id_Pre{i})
        for t=1:length(a{i}.behavResources(id_Pre{i}(k)).Zone)
            Pre_Occup(i,k,t)=size(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Pre{i}(k)).CleanXtsd),1);
        end
    end
    for k=1:length(id_Post{i})
        for t=1:length(a{i}.behavResources(id_Post{i}(k)).Zone)
            Post_Occup(i,k,t)=size(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{t},1)./...
                size(Data(a{i}.behavResources(id_Post{i}(k)).CleanXtsd),1);
        end
    end
end
Pre_Occup = squeeze(Pre_Occup(:,:,1));
Post_Occup = squeeze(Post_Occup(:,:,1));

Pre_Occup_mean = mean(Pre_Occup,2);
Pre_Occup_std = std(Pre_Occup,0,2);
Post_Occup_mean = mean(Post_Occup,2);
Post_Occup_std = std(Post_Occup,0,2);
% Wilcoxon signed rank task between Pre and PostTest
p_pre_post = signrank(Pre_Occup_mean, Post_Occup_mean);

%% Prepare the 'first enter to shock zone' array
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_FirstTime(i,k) = 240;
        else
            Pre_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1}(1);
            Pre_FirstTime(i,k) = a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(Pre_FirstZoneIndices{i}{k}(1),1)-...
                a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(1,1);
        end
    end
    
    for k=1:length(id_Post{i})
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})
            Post_FirstTime(i,k) = 240;
        else
            Post_FirstZoneIndices{i}{k} = a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1}(1);
            Post_FirstTime(i,k) = a{i}.behavResources(id_Post{i}(k)).CleanPosMat(Post_FirstZoneIndices{i}{k}(1),1)-...
                 a{i}.behavResources(id_Post{i}(k)).CleanPosMat(1,1);
        end
    end
end
    
Pre_FirstTime_mean = mean(Pre_FirstTime,2);
Pre_FirstTime_std = std(Pre_FirstTime,0,2);
Post_FirstTime_mean = mean(Post_FirstTime,2);
Post_FirstTime_std = std(Post_FirstTime,0,2);
% Wilcoxon test
p_FirstTime_pre_post = signrank(Pre_FirstTime_mean,Post_FirstTime_mean);

%% Calculate number of entries into the shock zone
% Check with smb if it's correct way to calculate (plus one entry even if one frame it was outside )
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})
            Pre_entnum(i,k) = 0;
        else
            Pre_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{1})>1))+1;
        end
    end
    
    for k=1:length(id_Post{i})   
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})
            Post_entnum(i,k) = 0;
        else
            Post_entnum(i,k)=length(find(diff(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{1})>1))+1;
        end
    end
    
end
Pre_entnum_mean = mean(Pre_entnum,2);
Pre_entnum_std = std(Pre_entnum,0,2);
Post_entnum_mean = mean(Post_entnum,2);
Post_entnum_std = std(Post_entnum,0,2);
% Wilcoxon test
p_entnum_pre_post = signrank(Pre_entnum_mean, Post_entnum_mean);

%% Calculate speed in the safe zone and in the noshock + shock vs everything else
% I skip the last point in ZoneIndices because length(Xtsd)=length(Vtsd)+1
% - UPD 18/07/2018 - Could do length(Start(ZoneEpoch))
for i = 1:length(a)
    for k=1:length(id_Pre{i})
        % PreTest SafeZone speed
        if isempty(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2})
            VZmean_pre(i,k) = 0;
        else
            if old
                Vtemp_pre{i}{k} = tsd(Range(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Pre{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_pre{i}{k}=Data(a{i}.behavResources(id_Pre{i}(k)).CleanVtsd);
            end
            VZone_pre{i}{k}=Vtemp_pre{i}{k}(a{i}.behavResources(id_Pre{i}(k)).CleanZoneIndices{2}(1:end-1),1);
            VZmean_pre(i,k)=nanmean(VZone_pre{i}{k},1);
        end
    end
    
    % PostTest SafeZone speed
    for k=1:length(id_Post{i})
        % PreTest SafeZone speed
        if isempty(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{2})
            VZmean_post(i,k) = 0;
        else
            if old
                Vtemp_post{i}{k} = tsd(Range(a{i}.behavResources(id_Post{i}(k)).CleanVtsd),...
                    (Data(a{i}.behavResources(id_Post{i}(k)).CleanVtsd)./...
                    ([diff(a{i}.behavResources(id_Post{i}(k)).CleanPosMat(:,1));-1])));
            else
                Vtemp_post{i}{k}=Data(a{i}.behavResources(id_Post{i}(k)).CleanVtsd);
            end
            VZone_post{i}{k}=Vtemp_post{i}{k}(a{i}.behavResources(id_Post{i}(k)).CleanZoneIndices{2}(1:end-1),1);
            VZmean_post(i,k)=nanmean(VZone_post{i}{k},1);
        end
    end
    
end

Pre_VZmean_mean = mean(VZmean_pre,2);
Pre_VZmean_std = std(VZmean_pre,0,2);
Post_VZmean_mean = mean(VZmean_post,2);
Post_VZmean_std = std(VZmean_post,0,2);
% Wilcoxon test
p_VZmean_pre_post = signrank(Pre_VZmean_mean, Post_VZmean_mean);

%% Process freezing
for i = 1:length(a)
    for k=1:length(id_Cond{i})
        eval(['FreezingCond{i}{k} = and(a{i}.FreezeAccEpoch,a{i}.SessionEpoch.Cond' num2str(k) ');']);
        eval(['time = sum(End(a{i}.SessionEpoch.Cond' num2str(k) ')-Start(a{i}.SessionEpoch.Cond' num2str(k) '));']);
        FreezingCondSafe{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.NoShock);
        FreezingCondSafePerc(i,k) = sum(End(FreezingCondSafe{i}{k})-Start(FreezingCondSafe{i}{k}))/...
            time*100;
        
        FreezingCondShock{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.Shock);
        FreezingCondShockPerc(i,k) = sum(End(FreezingCondShock{i}{k})-Start(FreezingCondShock{i}{k}))/...
            time*100;
    end
end

FreezingCondSafePercMean = mean(FreezingCondSafePerc,2);
FreezingCondShockPercMean = mean(FreezingCondShockPerc,2);

%% Prepare intervalSets for ripples
for i=1:1:length(Dir.path)
    IS_TestPre{i} = or(a{i}.SessionEpoch.TestPre1,a{i}.SessionEpoch.TestPre2);
    IS_TestPre{i} = or(IS_TestPre{i},a{i}.SessionEpoch.TestPre3);
    IS_TestPre{i} = or(IS_TestPre{i},a{i}.SessionEpoch.TestPre4);

    IS_TestPost{i} = or(a{i}.SessionEpoch.TestPost1,a{i}.SessionEpoch.TestPost2);
    IS_TestPost{i} = or(IS_TestPost{i},a{i}.SessionEpoch.TestPost3);
    IS_TestPost{i} = or(IS_TestPost{i},a{i}.SessionEpoch.TestPost4);
    
    IS_Cond{i} = or(a{i}.SessionEpoch.Cond1,a{i}.SessionEpoch.Cond2);
    IS_Cond{i} = or(IS_Cond{i},a{i}.SessionEpoch.Cond3);
    IS_Cond{i} = or(IS_Cond{i},a{i}.SessionEpoch.Cond4);
end


%% Calculate ripples density in the shock zone

% Extract ripples for TestPre and -Post in the safe Zone
for i = 1:length(Dir.path)
    ripplesPeak{i}=ts(Rip{i}.ripples(:,2)*1e4);
    PreRipples{i}=Restrict(ripplesPeak{i},IS_TestPre{i});
    PostRipples{i}=Restrict(ripplesPeak{i},IS_TestPost{i});
    CondRipples{i}=Restrict(ripplesPeak{i},IS_Cond{i});
    
    PreRipples_Safe{i}=Restrict(ripplesPeak{i},and(IS_TestPre{i}, a{i}.ZoneEpoch.NoShock));
    PostRipples_Safe{i}=Restrict(ripplesPeak{i},and(IS_TestPost{i}, a{i}.ZoneEpoch.NoShock));
    
    PreRipples_Shock{i}=Restrict(ripplesPeak{i},and(IS_TestPre{i}, a{i}.ZoneEpoch.Shock));
    PostRipples_Shock{i}=Restrict(ripplesPeak{i},and(IS_TestPost{i}, a{i}.ZoneEpoch.Shock));
    
    CondRipples_Shock{i}=Restrict(ripplesPeak{i},and(IS_Cond{i}, a{i}.ZoneEpoch.Shock));
    CondRipples_Safe{i}=Restrict(ripplesPeak{i},and(IS_Cond{i}, a{i}.ZoneEpoch.NoShock));
    
    CondRipples_ShockFreeze{i}=Restrict(ripplesPeak{i},and(and(IS_Cond{i}, a{i}.ZoneEpoch.Shock),a{i}.FreezeAccEpoch));
    CondRipples_SafeFreeze{i}=Restrict(ripplesPeak{i},and(and(IS_Cond{i}, a{i}.ZoneEpoch.NoShock),a{i}.FreezeAccEpoch));
    
end

for i=1:length(Dir.path)
    % Cond
    Cond_N_Shock(i)=length(Range(CondRipples_Shock{i}));
    Cond_N_Safe(i)=length(Range(CondRipples_Safe{i}));
    
    Cond_N_ShockFreeze(i)=length(Range(CondRipples_ShockFreeze{i}));
    Cond_N_SafeFreeze(i)=length(Range(CondRipples_SafeFreeze{i}));
    % Normalize to the duration of sleep
    TimeShock{i} = and(IS_Cond{i}, a{i}.ZoneEpoch.Shock);
    Cond_N_norm_Shock(i) = Cond_N_Shock(i)/((sum(End(TimeShock{i})- Start(TimeShock{i})))/1e4); 
    TimeSafe{i} = and(IS_Cond{i}, a{i}.ZoneEpoch.NoShock);
    Cond_N_norm_Safe(i) = Cond_N_Safe(i)/((sum(End(TimeSafe{i})- Start(TimeSafe{i})))/1e4);
    
    TimeShockFreeze{i} = and(and(IS_Cond{i}, a{i}.ZoneEpoch.Shock),a{i}.FreezeAccEpoch);
    Cond_N_norm_ShockFreeze(i) = Cond_N_ShockFreeze(i)/((sum(End(TimeShockFreeze{i})- Start(TimeShockFreeze{i})))/1e4); 
    TimeSafeFreeze{i} = and(and(IS_Cond{i}, a{i}.ZoneEpoch.NoShock),a{i}.FreezeAccEpoch);
    Cond_N_norm_SafeFreeze(i) = Cond_N_SafeFreeze(i)/((sum(End(TimeSafeFreeze{i})- Start(TimeSafeFreeze{i})))/1e4);
    
    % WholeMaze
    Pre_N(i)=length(Range(PreRipples{i}));
    Post_N(i)=length(Range(PostRipples{i}));
    % Normalize to the duration of sleep
    TimePre{i} = IS_TestPre{i};
    Pre_N_norm_all(i) = Pre_N(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = IS_TestPost{i};
    Post_N_norm_all(i) = Post_N(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    
    % Shcok Zone
    Pre_N_Shock(i)=length(Range(PreRipples_Shock{i}));
    Post_N_Shock(i)=length(Range(PostRipples_Shock{i}));
    % Normalize to the duration of SWSSleep
    TimePre{i} = and(IS_TestPre{i}, a{i}.ZoneEpoch.Shock);
    Pre_N_norm_Shock(i) = Pre_N_Shock(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = and(IS_TestPost{i}, a{i}.ZoneEpoch.Shock);
    Post_N_norm_Shock(i) = Post_N_Shock(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    
    % Safe Zone
    Pre_N_Safe(i)=length(Range(PreRipples_Safe{i}));
    Post_N_Safe(i)=length(Range(PostRipples_Safe{i}));
    % Normalize to the duration of SWSSleep
    TimePre{i} = and(IS_TestPre{i}, a{i}.ZoneEpoch.NoShock);
    Pre_N_norm_Safe(i) = Pre_N_Safe(i)/((sum(End(TimePre{i})- Start(TimePre{i})))/1e4); 
    TimePost{i} = and(IS_TestPost{i}, a{i}.ZoneEpoch.NoShock);
    Post_N_norm_Safe(i) = Post_N_Safe(i)/((sum(End(TimePost{i})- Start(TimePost{i})))/1e4);
    
end

%% Plot

f1 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);

% % Absolute number
% subplot(221)
% [p_Con,h, her] = PlotErrorBarN_DB([Cond_N_norm_Shock' Cond_N_norm_Safe'], 'barcolors', [0 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
% % ylim([0 0.4]);
% ylim([0 0.25]);
% set(gca,'Xtick',[1:2],'XtickLabel',{'ShockZone', 'SafeZone'});
% set(gca, 'FontSize', 14, 'FontWeight',  'bold');
% h.FaceColor = 'flat';
% h.CData(1,:) = [1 0 0];
% h.CData(2,:) = [0 0 1];
% set(h, 'LineWidth', 3);
% set(her, 'LineWidth', 3);
% ylabel('Ripples/s');
% title('Ripples density during conditioning', 'FontSize', 14);
%
% boxpost = [0.34 0.9 0.35 0.1];
% annotation(f1,'textbox',boxpost,'String','During Conditioning','LineStyle','none','HorizontalAlignment','center','FontWeight','bold',...
%         'FitBoxToText','off', 'FontSize', 20);
%
% subplot(222)
scatter(Cond_N_norm_Safe',(Post_VZmean_mean-Pre_VZmean_mean), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('Speed in safe zone (cm/s)');
xlabel('Density of ripples in safe zone (ripples/s)');
title('Correlation: ripples density vs speed - safe zone', 'FontSize', 14);
[CC,pv] = corrcoef(Cond_N_norm_Safe',(Post_VZmean_mean-Pre_VZmean_mean));
boxpost = [0.755 0.875 0.2 0.05];
towrite = ['r=' num2str(round(CC(1,2),2)) ', p=' num2str(round(pv(1,2),2))];
annotation(f1,'textbox',boxpost,'String',towrite,'LineStyle','none','HorizontalAlignment','center','FontWeight','bold',...
    'FitBoxToText','off', 'FontSize', 12);

f2 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);
scatter(Cond_N_norm_Safe',(Post_entnum_mean-Pre_entnum_mean), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('#Entries');
xlabel('Density of ripples in safe zone (ripples/s)');
title('Correlation: ripples density vs #entriesSZ - safe zone', 'FontSize', 14);
[CC,pv] = corrcoef(Cond_N_norm_Safe',(Post_entnum_mean-Pre_entnum_mean));
boxpost = [0.755 0.875 0.2 0.05];
towrite = ['r=' num2str(round(CC(1,2),2)) ', p=' num2str(round(pv(1,2),2))];
annotation(f2,'textbox',boxpost,'String',towrite,'LineStyle','none','HorizontalAlignment','center','FontWeight','bold',...
    'FitBoxToText','off', 'FontSize', 12);



f3 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);
scatter(Cond_N_norm_Safe',(Post_FirstTime_mean-Pre_FirstTime_mean), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('Time (s)');
xlabel('Density of ripples in safe zone (ripples/s)');
title('Correlation: ripples density vs 1stTimeShZ - safe zone', 'FontSize', 14);
[CC,pv] = corrcoef(Cond_N_norm_Safe',(Post_FirstTime_mean-Pre_FirstTime_mean));
boxpost = [0.755 0.875 0.2 0.05];
towrite = ['r=' num2str(round(CC(1,2),2)) ', p=' num2str(round(pv(1,2),2))];
annotation(f3,'textbox',boxpost,'String',towrite,'LineStyle','none','HorizontalAlignment','center','FontWeight','bold',...
    'FitBoxToText','off', 'FontSize', 12);

f4 = figure('units', 'normalized', 'outerposition', [0 0 0.8 0.6]);
scatter(Cond_N_norm_Safe',(Post_Occup_mean-Pre_Occup_mean), 'filled','MarkerFaceColor','k')
hold on
l = lsline;
set(l,'Color','k','LineWidth',3)
set(gca, 'FontSize', 14, 'FontWeight',  'bold');
ylabel('% Occupancy');
xlabel('Density of ripples in safe zone (ripples/s)');
title('Correlation: ripples density vs Occupancy - safe zone', 'FontSize', 14);
[CC,pv] = corrcoef(Cond_N_norm_Safe',(Post_Occup_mean-Pre_Occup_mean));
boxpost = [0.755 0.875 0.2 0.05];
towrite = ['r=' num2str(round(CC(1,2),2)) ', p=' num2str(round(pv(1,2),2))];
annotation(f4,'textbox',boxpost,'String',towrite,'LineStyle','none','HorizontalAlignment','center','FontWeight','bold',...
    'FitBoxToText','off', 'FontSize', 12);
