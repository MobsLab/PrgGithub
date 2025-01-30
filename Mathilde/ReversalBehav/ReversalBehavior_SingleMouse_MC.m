%% Parameters
indir = '/media/nas5/ProjetReversalBehavior/';
ntest = 4;
ncond = 3;
suf = {'TestPre'; 'TestPost'; 'Cond'};
subsuf = {'PAG', 'MFB'};
old = [913, 934, 935, 938];

%% parameters you need to update to look at the mouse you want :
Day = '20201216';
MouseNum = 1138;

% Experiment = 'ReversalWake';
Experiment = 'ReversalWake_sham';

% Mice / Day / Grp
% 1138 : 20201216 sham
% 1139 : 20210106 expe
% 1140 : 20201217 sham
% 1141 : 20201229 expe
% 1142 : 20201218 sham
% 1143 : 20201230 expe

% 913 : 20190529 expe
% 934 : 20190612 expe
% 935 : 20190613 sham
% 938 : 20190618 sham

%% Get the data (from pre- and post- tests x4)
for i = 1:1:ntest
    % Pre Tests
    cd([indir 'M' num2str(MouseNum) '/' Day '/' Experiment '/' suf{1} '/' suf{1} num2str(i)]);
    if isfile('cleanBehavResources.mat') == 1 % because CleanBlablablaAligned variables are not always in the same BehavResources
        a = load('cleanBehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    else
        a = load('BehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    end
    Pre_Occup(i,:) = a.Occup(:,[1:5 8:end]); % get rid of 'inside' and 'outside' zones
    Pre_Xtsd{i} = a.CleanAlignedXtsd;
    Pre_Ytsd{i} = a.CleanAlignedYtsd;
    Pre_PosMat{i} = a.PosMat;
    Pre_Vtsd{i} = a.Vtsd;
    Pre_ZoneIndices{i} = a.ZoneIndices;
    Pre_timeShock{i} = End(a.CleanZoneEpochAligned{1})-Start(a.CleanZoneEpochAligned{1});
    Pre_timeSafe{i} = End(a.CleanZoneEpochAligned{2})-Start(a.CleanZoneEpochAligned{2});
    
    % Tests Post PAG
    cd([indir 'M' num2str(MouseNum) '/' Day '/' Experiment '/' suf{2} '/' suf{2} subsuf{1} '/' suf{2} subsuf{1} num2str(i)]);
    if isfile('cleanBehavResources.mat') == 1
        b = load('cleanBehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    else
        b = load('BehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    end
    PostPAG_Occup(i,:) = b.Occup(:,[1:5 8:end]);
    PostPAG_Xtsd{i} = b.CleanAlignedXtsd;
    PostPAG_Ytsd{i} = b.CleanAlignedYtsd;
    PostPAG_PosMat{i} = b.PosMat;
    PostPAG_Vtsd{i} = b.Vtsd;
    PostPAG_ZoneIndices{i} = b.ZoneIndices;
    PostPAG_timeShock{i} = End(b.CleanZoneEpochAligned{1})-Start(b.CleanZoneEpochAligned{1});
    PostPAG_timeSafe{i} = End(b.CleanZoneEpochAligned{2})-Start(b.CleanZoneEpochAligned{2});
    
    % Tests Post MFB
    cd([indir 'M' num2str(MouseNum) '/' Day '/' Experiment '/' suf{2} '/' suf{2} subsuf{2} '/' suf{2} subsuf{2} num2str(i)]);
    if isfile('cleanBehavResources.mat') == 1
        c = load('cleanBehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    else
        c = load('BehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd');
    end
    PostMFB_Occup(i,:) = c.Occup(:,[1:5 8:end]);
    PostMFB_Xtsd{i} = c.CleanAlignedXtsd;
    PostMFB_Ytsd{i} = c.CleanAlignedYtsd;
    PostMFB_PosMat{i} = c.PosMat;
    PostMFB_Vtsd{i} = c.Vtsd;
    PostMFB_ZoneIndices{i} = c.ZoneIndices;
    PostMFB_timeShock{i} = End(c.CleanZoneEpochAligned{1})-Start(c.CleanZoneEpochAligned{1});
    PostMFB_timeSafe{i} = End(c.CleanZoneEpochAligned{2})-Start(c.CleanZoneEpochAligned{2});
end

% Get the data (from conditioning sessions x3)
for j = 1:1:ncond
    % Cond PAG
    cd([indir 'M' num2str(MouseNum) '/' Day '/' Experiment '/' suf{3} '/' suf{3} subsuf{1} '/' suf{3} subsuf{1} num2str(j)]);
    if isfile('cleanBehavResources.mat') == 1
        d = load('cleanBehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd','Ratio_IMAonREAL');
    else
        d = load('BehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd','Ratio_IMAonREAL');
    end
    CondPAG_Occup(j,:) = d.Occup(:,[1:5 8:end]);
    CondPAG_Xtsd{j} = d.CleanAlignedXtsd;
    CondPAG_Ytsd{j} = d.CleanAlignedYtsd;
    CondPAG_PosMat{j} = d.PosMat;
    CondPAG_Vtsd{j} = d.Vtsd;
    CondPAG_ZoneIndices{j} = d.ZoneIndices;
    CondPAG_timeShock{j} = End(d.CleanZoneEpochAligned{1})-Start(d.CleanZoneEpochAligned{1});
    CondPAG_timeSafe{j} = End(d.CleanZoneEpochAligned{2})-Start(d.CleanZoneEpochAligned{2});
    CondPAG_StimTime{j} = find(CondPAG_PosMat{j}(:,4)==1);
    CondPAG_Ratio_IMAonREAL = d.Ratio_IMAonREAL;
    
    % Cond MFB
    cd([indir 'M' num2str(MouseNum) '/' Day '/' Experiment '/' suf{3} '/' suf{3} subsuf{2} '/' suf{3} subsuf{2} num2str(j)]);
    if isfile('cleanBehavResources.mat') == 1
        e = load('cleanBehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd','Ratio_IMAonREAL');
        
    else
        e = load('BehavResources.mat', 'Occup', 'CleanAlignedXtsd', 'CleanAlignedYtsd', 'CleanZoneEpochAligned','ZoneIndices','PosMat','Vtsd','Ratio_IMAonREAL');
    end
    CondMFB_Occup(j,:) = e.Occup(:,[1:5 8:end]);
    CondMFB_Xtsd{j} = e.CleanAlignedXtsd;
    CondMFB_Ytsd{j} = e.CleanAlignedYtsd;
    CondMFB_PosMat{j} = e.PosMat;
    CondMFB_Vtsd{j} = e.Vtsd;
    CondMFB_ZoneIndices{j} = e.ZoneIndices;
    CondMFB_timeShock{j} = End(e.CleanZoneEpochAligned{1})-Start(e.CleanZoneEpochAligned{1});
    CondMFB_timeSafe{j} = End(e.CleanZoneEpochAligned{2})-Start(e.CleanZoneEpochAligned{2});
    CondMFB_StimTime{j} = find(CondMFB_PosMat{j}(:,4)==1);
    CondMFB_Ratio_IMAonREAL = e.Ratio_IMAonREAL;
end

% average occupancy
% calculate mean
Pre_Occup_mean = mean(Pre_Occup,1);
PostPAG_Occup_mean = mean(PostPAG_Occup,1);
PostMFB_Occup_mean = mean(PostMFB_Occup,1);
CondPAG_Occup_mean = mean(CondPAG_Occup,1);
CondMFB_Occup_mean = mean(CondMFB_Occup,1);
% calculte stdError
Pre_Occup_std = stdError(Pre_Occup);
PostPAG_Occup_std = stdError(PostPAG_Occup);
PostMFB_Occup_std = stdError(PostMFB_Occup);
CondPAG_Occup_std = stdError(CondPAG_Occup);
CondMFB_Occup_std = stdError(CondMFB_Occup);

% calculate the first enter in the shock zone
% for pre and post tests
for k = 1:ntest
    if isempty(Pre_ZoneIndices{k}{1})
        Pre_FirstTime(k) = 120;
    else
        Pre_FirstZoneIndices(k) = Pre_ZoneIndices{k}{1}(1);
        Pre_FirstTime(k) = Pre_PosMat{k}(Pre_FirstZoneIndices(k),1);
    end
    
    if isempty(PostPAG_ZoneIndices{k}{1})
        PostPAG_FirstTime(k) = 120;
    else
        PostPAG_FirstZoneIndices(k) = PostPAG_ZoneIndices{k}{1}(1);
        PostPAG_FirstTime(k) = PostPAG_PosMat{k}(PostPAG_FirstZoneIndices(k),1);
    end
    
    if isempty(PostMFB_ZoneIndices{k}{1})
        PostMFB_FirstTime(k) = 120;
    else
        PostMFB_FirstZoneIndices(k) = PostMFB_ZoneIndices{k}{1}(1);
        PostMFB_FirstTime(k) = PostMFB_PosMat{k}(PostMFB_FirstZoneIndices(k),1);
    end
    Pre_PostPAG_PostMFB_FirstTime(k, 1:3) = [Pre_FirstTime(k) PostPAG_FirstTime(k) PostMFB_FirstTime(k)];
end

% for conditioning sessions
for l = 1:ncond
    if isempty(CondPAG_ZoneIndices{l}{1})
        CondPAG_FirstTime(l) = 300;
    else
        CondPAG_FirstZoneIndices(l) = CondPAG_ZoneIndices{l}{1}(1);
        CondPAG_FirstTime(l) = CondPAG_PosMat{l}(CondPAG_FirstZoneIndices(l),1);
    end
    
    if isempty(CondMFB_ZoneIndices{l}{1})
        CondMFB_FirstTime(l) = 300;
    else
        CondMFB_FirstZoneIndices(l) = CondMFB_ZoneIndices{l}{1}(1);
        CondMFB_FirstTime(l) = CondMFB_PosMat{l}(CondMFB_FirstZoneIndices(l),1);
    end
    CondPAG_CondMFB_FirstTime(l, 1:2) = [CondPAG_FirstTime(l) CondMFB_FirstTime(l)];
end

% calculate mean and std
Pre_PostPAG_PostMFB_FirstTime_mean = mean(Pre_PostPAG_PostMFB_FirstTime,1);
Pre_PostPAG_PostMFB_FirstTime_std = stdError(Pre_PostPAG_PostMFB_FirstTime);
CondPAG_CondMFB_FirstTime_mean = mean(CondPAG_CondMFB_FirstTime,1);
CondPAG_CondMFB_FirstTime_std = stdError(CondPAG_CondMFB_FirstTime);

% Calculate number of entries into the shock zone
% for pre- and post-tests (x4)
for m = 1:ntest
    if isempty(Pre_ZoneIndices{m}{1})
        Pre_entnb(m) = 0;
    else
        Pre_entnb(m)=length(find(diff(Pre_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PostPAG_ZoneIndices{m}{1})
        PostPAG_entnb(m) = 0;
    else
        PostPAG_entnb(m)=length(find(diff(PostPAG_ZoneIndices{m}{1})>1))+1;
    end
    
    if isempty(PostMFB_ZoneIndices{m}{1})
        PostMFB_entnb(m) = 0;
    else
        PostMFB_entnb(m)=length(find(diff(PostMFB_ZoneIndices{m}{1})>1))+1;
    end
end

% for cond sessions (x3)
for n = 1:ncond
    if isempty(CondPAG_ZoneIndices{n}{1})
        CondPAG_entnb(n) = 0;
    else
        CondPAG_entnb(n)=length(find(diff(CondPAG_ZoneIndices{n}{1})>1))+1;
    end
    
    if isempty(CondMFB_ZoneIndices{n}{1})
        CondMFB_entnb(n) = 0;
    else
        CondMFB_entnb(n)=length(find(diff(CondMFB_ZoneIndices{n}{1})>1))+1;
    end
end

% calculate mean and std
Pre_PostPAG_PostMFB_entnb = [Pre_entnb; PostPAG_entnb; PostMFB_entnb]';
Pre_PostPAG_PostMFB_entnb_mean = mean(Pre_PostPAG_PostMFB_entnb,1);
Pre_PostPAG_PostMFB_entnb_std = stdError(Pre_PostPAG_PostMFB_entnb);
CondPAG_CondMFB_entnb = [CondPAG_entnb; CondMFB_entnb]';
CondPAG_CondMFB_entnb_mean = mean(CondPAG_CondMFB_entnb,1);
CondPAG_CondMFB_entnb_std = stdError(CondPAG_CondMFB_entnb);

% Calculate speed in the shock zone
% for tests pre and post
for p=1:ntest
    % Test Pre shock zone speed
    if isempty(Pre_ZoneIndices{p}{1})
        Pre_VZone_mean(p) = 0;
    else
        Pre_Vtemp{p}=Data(Pre_Vtsd{p});
        Pre_VZone{p}=Pre_Vtemp{p}(Pre_ZoneIndices{p}{1}(1:end-1),1);
        Pre_VZone_mean(p)=nanmean(Pre_VZone{p},1);
    end
    % Test Post PAG shock zone speed
    if isempty(PostPAG_ZoneIndices{p}{1})
        PostPAG_VZone_mean(p) = 0;
    else
        PostPAG_Vtemp{p}=Data(PostPAG_Vtsd{p});
        PostPAG_VZone{p}=PostPAG_Vtemp{p}(PostPAG_ZoneIndices{p}{1}(1:end-1),1);
        PostPAG_VZone_mean(p)=nanmean(PostPAG_VZone{p},1);
    end
    % Test Post MFB shock zone speed
    if isempty(PostMFB_ZoneIndices{p}{1})
        PostMFB_VZone_mean(p) = 0;
    else
        PostMFB_Vtemp{p}=Data(PostMFB_Vtsd{p});
        PostMFB_VZone{p}=PostMFB_Vtemp{p}(PostMFB_ZoneIndices{p}{1}(1:end-1),1);
        PostMFB_VZone_mean(p)=nanmean(PostMFB_VZone{p},1);
    end
end

% for conditioning sessions
for q=1:ncond
    % Cond PAG shock zone speed
    if isempty(CondPAG_ZoneIndices{q}{1})
        CondPAG_VZone_mean(q) = 0;
    else
        CondPAG_Vtemp{q}=Data(CondPAG_Vtsd{q});
        CondPAG_VZone{q}=CondPAG_Vtemp{q}(CondPAG_ZoneIndices{q}{1}(1:end-1),1);
        CondPAG_VZone_mean(q)=nanmean(CondPAG_VZone{q},1);
    end
    % Cond MFB shock zone speed
    if isempty(CondMFB_ZoneIndices{q}{1})
        CondMFB_VZone_mean(q) = 0;
    else
        CondMFB_Vtemp{q}=Data(CondMFB_Vtsd{q});
        CondMFB_VZone{q}=CondMFB_Vtemp{q}(CondMFB_ZoneIndices{q}{1}(1:end-1),1);
        CondMFB_VZone_mean(q)=nanmean(CondMFB_VZone{q},1);
    end
end

% calculate mean and std
Pre_PostPAG_PostMFB_VZmean = [Pre_VZone_mean; PostPAG_VZone_mean; PostMFB_VZone_mean]';
Pre_PostPAG_PostMFB_VZmean_mean = nanmean(Pre_PostPAG_PostMFB_VZmean,1);
Pre_PostPAG_PostMFB_VZmean_std = stdError(Pre_PostPAG_PostMFB_VZmean);
CondPAG_CondMFB_VZmean = [CondPAG_VZone_mean; CondMFB_VZone_mean]';
CondPAG_CondMFB_VZmean_mean = nanmean(CondPAG_CondMFB_VZmean,1);
CondPAG_CondMFB_VZmean_std = stdError(CondPAG_CondMFB_VZmean);

%% plot the figure
figure
% Trajectories during pre- et post- tests
for i = 1:1:ntest
    subplot(251), plot(Data(Pre_Xtsd{i}),Data(Pre_Ytsd{i})), hold on
    title('Test Pre')
    ylim([0 1])
    xlim([0 1])
    legend({'trial 1', 'trial 2', 'trial 3', 'trial 4'})
    makepretty
    subplot(253), plot(Data(PostPAG_Xtsd{i}),Data(PostPAG_Ytsd{i})), hold on
    title('Test Post PAG')
    ylim([0 1])
    xlim([0 1])
    makepretty
    subplot(255), plot(Data(PostMFB_Xtsd{i}),Data(PostMFB_Ytsd{i})), hold on
    title('Test Post MFB')
    ylim([0 1])
    xlim([0 1])
    makepretty
end

% trajectories during conditioning (PAG & MFB)
for j = 1:1:ncond
    CondPAG_X{j} = Data(CondPAG_Xtsd{j});
    CondPAG_Y{j} = Data(CondPAG_Ytsd{j});
    CondMFB_X{j} = Data(CondMFB_Xtsd{j});
    CondMFB_Y{j} = Data(CondMFB_Ytsd{j});
    % PostPAG
    subplot(252), plot(Data(CondPAG_Xtsd{j}),Data(CondPAG_Ytsd{j})), hold on
    title('Cond PAG')
    ylim([0 1])
    xlim([0 1])
    for jj = 1:length(CondPAG_StimTime{j}) % add dots for the stimulations
        plot(CondPAG_X{j}(CondPAG_StimTime{j}(jj)), CondPAG_Y{j}(CondPAG_StimTime{j}(jj)), 'r.', 'MarkerSize', 20), hold on
    end
    makepretty
    % Post MFB
    subplot(254), plot(Data(CondMFB_Xtsd{j}),Data(CondMFB_Ytsd{j})), hold on
    title('Cond MFB')
    ylim([0 1])
    xlim([0 1])
    for jj = 1:length(CondMFB_StimTime{j})
        plot(CondMFB_X{j}(CondMFB_StimTime{j}(jj)), CondMFB_Y{j}(CondMFB_StimTime{j}(jj)), 'g.', 'MarkerSize', 20, 'color', [0 0.6 0.2]), hold on
    end
    makepretty
end


subplot(256),bar([Pre_Occup_mean(1)*100 Pre_Occup_mean(4)*100 Pre_Occup_mean(6)*100 Pre_Occup_mean(3)*100 Pre_Occup_mean(7)*100 Pre_Occup_mean(5)*100 Pre_Occup_mean(2)*100 sum(Pre_Occup_mean(2:end)*100)], 'FaceColor', [0.3 0.3 0.3])
hold on
errorbar([[Pre_Occup_mean(1)*100 Pre_Occup_mean(4)*100 Pre_Occup_mean(6)*100 Pre_Occup_mean(3)*100 Pre_Occup_mean(7)*100 Pre_Occup_mean(5)*100 Pre_Occup_mean(2)*100 sum(Pre_Occup_mean(2:end)*100)]],...
    [[Pre_Occup_std(1)*100 Pre_Occup_std(4)*100 Pre_Occup_std(6)*100 Pre_Occup_std(3)*100 Pre_Occup_std(7)*100 Pre_Occup_std(5)*100 Pre_Occup_std(2)*100 std(Pre_Occup_mean(2:end)*100)]],'.','Color', 'k');
set(gca,'Xtick',[1:8],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim', 'EverythgButStim'});
line([-0.2 9],[21.5 21.5],'color','k','linestyle','--')
xtickangle(45)
ylim([0 100])
ylabel('% time spent')
makepretty
subplot(257),bar([CondPAG_Occup_mean(1)*100 CondPAG_Occup_mean(4)*100 CondPAG_Occup_mean(6)*100 CondPAG_Occup_mean(3)*100 CondPAG_Occup_mean(7)*100 CondPAG_Occup_mean(5)*100 CondPAG_Occup_mean(2)*100 sum(CondPAG_Occup_mean(2:end)*100)], 'FaceColor', [0.3 0.3 0.3])
hold on
errorbar([[CondPAG_Occup_mean(1)*100 CondPAG_Occup_mean(4)*100 CondPAG_Occup_mean(6)*100 CondPAG_Occup_mean(3)*100 CondPAG_Occup_mean(7)*100 CondPAG_Occup_mean(5)*100 CondPAG_Occup_mean(2)*100 sum(CondPAG_Occup_mean(2:end)*100)]],...
    [[CondPAG_Occup_std(1)*100 CondPAG_Occup_std(4)*100 CondPAG_Occup_std(6)*100 CondPAG_Occup_std(3)*100 CondPAG_Occup_std(7)*100 CondPAG_Occup_std(5)*100 CondPAG_Occup_std(2)*100 std(CondPAG_Occup_mean(2:end)*100)]],'.','Color', 'k');
set(gca,'Xtick',[1:8],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim', 'EverythgButStim'});
line([-0.2 9],[21.5 21.5],'color','k','linestyle','--')
xtickangle(45)
ylim([0 100])
makepretty
subplot(258),bar([PostPAG_Occup_mean(1)*100 PostPAG_Occup_mean(4)*100 PostPAG_Occup_mean(6)*100 PostPAG_Occup_mean(3)*100 PostPAG_Occup_mean(7)*100 PostPAG_Occup_mean(5)*100 PostPAG_Occup_mean(2)*100 sum(PostPAG_Occup_mean(2:end)*100)], 'FaceColor', [0.3 0.3 0.3])
hold on
errorbar([[PostPAG_Occup_mean(1)*100 PostPAG_Occup_mean(4)*100 PostPAG_Occup_mean(6)*100 PostPAG_Occup_mean(3)*100 PostPAG_Occup_mean(7)*100 PostPAG_Occup_mean(5)*100 PostPAG_Occup_mean(2)*100 sum(PostPAG_Occup_mean(2:end)*100)]],...
    [[PostPAG_Occup_std(1)*100 PostPAG_Occup_std(4)*100 PostPAG_Occup_std(6)*100 PostPAG_Occup_std(3)*100 PostPAG_Occup_std(7)*100 PostPAG_Occup_std(5)*100 PostPAG_Occup_std(2)*100 std(PostPAG_Occup_mean(2:end)*100)]],'.','Color', 'k');
set(gca,'Xtick',[1:8],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim', 'EverythgButStim'});
line([-0.2 9],[21.5 21.5],'color','k','linestyle','--')
xtickangle(45)
ylim([0 100])
makepretty
subplot(259),bar([CondMFB_Occup_mean(1)*100 CondMFB_Occup_mean(4)*100 CondMFB_Occup_mean(6)*100 CondMFB_Occup_mean(3)*100 CondMFB_Occup_mean(7)*100 CondMFB_Occup_mean(5)*100 CondMFB_Occup_mean(2)*100 sum(CondMFB_Occup_mean(2:end)*100)], 'FaceColor', [0.3 0.3 0.3])
hold on
errorbar([[CondMFB_Occup_mean(1)*100 CondMFB_Occup_mean(4)*100 CondMFB_Occup_mean(6)*100 CondMFB_Occup_mean(3)*100 CondMFB_Occup_mean(7)*100 CondMFB_Occup_mean(5)*100 CondMFB_Occup_mean(2)*100 sum(CondMFB_Occup_mean(2:end)*100)]],...
    [[CondMFB_Occup_std(1)*100 CondMFB_Occup_std(4)*100 CondMFB_Occup_std(6)*100 CondMFB_Occup_std(3)*100 CondMFB_Occup_std(7)*100 CondMFB_Occup_std(5)*100 CondMFB_Occup_std(2)*100 std(CondMFB_Occup_mean(2:end)*100)]],'.','Color', 'k');
set(gca,'Xtick',[1:8],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim', 'EverythgButStim'});
line([-0.2 9],[21.5 21.5],'color','k','linestyle','--')
xtickangle(45)
ylim([0 100])
makepretty
subplot(2,5,10),bar([PostMFB_Occup_mean(1)*100 PostMFB_Occup_mean(4)*100 PostMFB_Occup_mean(6)*100 PostMFB_Occup_mean(3)*100 PostMFB_Occup_mean(7)*100 PostMFB_Occup_mean(5)*100 PostMFB_Occup_mean(2)*100 sum(PostMFB_Occup_mean(2:end)*100)], 'FaceColor', [0.3 0.3 0.3])
hold on
errorbar([[PostMFB_Occup_mean(1)*100 PostMFB_Occup_mean(4)*100 PostMFB_Occup_mean(6)*100 PostMFB_Occup_mean(3)*100 PostMFB_Occup_mean(7)*100 PostMFB_Occup_mean(5)*100 PostMFB_Occup_mean(2)*100 sum(PostMFB_Occup_mean(2:end)*100)]],...
    [[PostMFB_Occup_std(1)*100 PostMFB_Occup_std(4)*100 PostMFB_Occup_std(6)*100 PostMFB_Occup_std(3)*100 PostMFB_Occup_std(7)*100 PostMFB_Occup_std(5)*100 PostMFB_Occup_std(2)*100 std(PostMFB_Occup_mean(2:end)*100)]],'.','Color', 'k');
set(gca,'Xtick',[1:8],'XtickLabel',{'Stim', 'CentreStim', 'CornerStim', 'Centre', 'CornerNoStim', 'CentreNoStim', 'NoStim', 'EverythgButStim'});
line([-0.2 9],[21.5 21.5],'color','k','linestyle','--')
xtickangle(45)
ylim([0 100])
makepretty
suptitle (['' num2str(MouseNum) ' ']);

% %% plot a figure with different behavior paramaters in the shock zone
% % Shock zone occupancy
% figure,subplot(221),bar([Pre_Occup_mean(1)*100  PostPAG_Occup_mean(1)*100  PostMFB_Occup_mean(1)*100], 'FaceColor', [0.3 0.3 0.3])
% hold on
% errorbar([[Pre_Occup_mean(1)*100 PostPAG_Occup_mean(1)*100  PostMFB_Occup_mean(1)*100]],...
%     [[Pre_Occup_std(1)*100  PostPAG_Occup_std(1)*100  PostMFB_Occup_std(1)*100]],'.', 'Color', 'k');
% set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre','TestPostPAG','TestPostMFB'});
% line([-0.2 4.2],[21.5 21.5],'color','k','linestyle','--')
% ylabel('% time spent')
% ylim([0 50])
% title('Stim zone occupancy')
% makepretty
% % number of entries in shock zone
% subplot(222),bar([Pre_PostPAG_PostMFB_entnb_mean(1) Pre_PostPAG_PostMFB_entnb_mean(2) Pre_PostPAG_PostMFB_entnb_mean(3)], 'FaceColor', [0.3 0.3 0.3])
% hold on
% errorbar([Pre_PostPAG_PostMFB_entnb_mean(1) Pre_PostPAG_PostMFB_entnb_mean(2) Pre_PostPAG_PostMFB_entnb_mean(3)],...
%     [Pre_PostPAG_PostMFB_entnb_std(1)  Pre_PostPAG_PostMFB_entnb_std(2) Pre_PostPAG_PostMFB_entnb_std(3)],'.', 'Color', 'k')
% set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre','TestPostPAG','TestPostMFB'});
% ylabel('number of entries')
% ylim([0 6])
% title('Number of entries in the stim zone')
% makepretty
% % first time to enter the shock zone
% subplot(223),bar([Pre_PostPAG_PostMFB_FirstTime_mean(1) Pre_PostPAG_PostMFB_FirstTime_mean(2) Pre_PostPAG_PostMFB_FirstTime_mean(3)], 'FaceColor', [0.3 0.3 0.3])
% hold on
% errorbar([Pre_PostPAG_PostMFB_FirstTime_mean(1) Pre_PostPAG_PostMFB_FirstTime_mean(2) Pre_PostPAG_PostMFB_FirstTime_mean(3)],...
%     [Pre_PostPAG_PostMFB_FirstTime_std(1) Pre_PostPAG_PostMFB_FirstTime_std(2) Pre_PostPAG_PostMFB_FirstTime_std(3)],'.', 'Color', 'k')
% set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre','TestPostPAG','TestPostMFB'});
% ylabel('Time (s)')
% ylim([0 150])
% line([-0.2 4.2],[120 120],'color','k','linestyle','--')
% title('First time to enter the stim zone')
% makepretty
% % average speed in shock zone
% subplot(224),bar([Pre_PostPAG_PostMFB_VZmean_mean(1) Pre_PostPAG_PostMFB_VZmean_mean(2) Pre_PostPAG_PostMFB_VZmean_mean(3)], 'FaceColor', [0.3 0.3 0.3])
% hold on
% errorbar([Pre_PostPAG_PostMFB_VZmean_mean(1) Pre_PostPAG_PostMFB_VZmean_mean(2) Pre_PostPAG_PostMFB_VZmean_mean(3)],...
%     [Pre_PostPAG_PostMFB_VZmean_std(1) Pre_PostPAG_PostMFB_VZmean_std(2) Pre_PostPAG_PostMFB_VZmean_std(3)],'.', 'Color', 'k')
% set(gca,'Xtick',[1:3],'XtickLabel',{'TestPre', 'TestPostPAG','TestPostMFB'});
% ylabel('speed (cm/s)')
% ylim([0 10])
% title('Average speed in the stim zone')
% suptitle (['' num2str(MouseNum) ' ']);
% makepretty

