%% Parameters
sav=1;
old = 0;
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
name_out = 'RABehavior';

ZoneNames = {'Shock','NearShock','FarShock','Center','FarSafe','NearSafe','Safe'};
ZoneThresh = [0.15, 0.30, 0.4, 0.5, 0.6, 0.85, 1;...
    0, 0.15, 0.30, 0.4, 0.5, 0.6, 0.85];

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 912 977 994]);

%% Get Data
for i = 1:length(Dir.path)
        a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources',...
            'SessionEpoch', 'ZoneEpoch', 'FreezeAccEpoch','CleanLinearDist', 'RAUser','RAEpoch');
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

% CondEpoch
for i=1:length(a)
    CondEpoch{i} = or(a{i}.SessionEpoch.Cond1,a{i}.SessionEpoch.Cond2);
    CondEpoch{i} = or(CondEpoch{i},a{i}.SessionEpoch.Cond3);
    CondEpoch{i} = or(CondEpoch{i},a{i}.SessionEpoch.Cond4);
end


%% Process RiskAssesment
RACondToShock_tot = zeros(1,length(a));
RACondToSafe_tot = zeros(1,length(a));

for i = 1:length(a)
    
    %%%%%%%%%%%%%%%%%%%% ToShock %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RACondToShock{i} = and(a{i}.RAEpoch.ToShock,CondEpoch{i});
    
    % Check the quality
    StartTimes = Start(RACondToShock{i});
    EndTimes = End(RACondToShock{i});
    
    StartTimesOut = zeros(1,length(StartTimes));
    EndTimesOut = zeros(1,length(EndTimes));
    
    
    ToShockTimesTS{i} = ts(a{i}.RAUser.ToShock.Time*1e4);
    for j=1:length(Start(RACondToShock{i}))
        idx_RAToShock{i} = find(a{i}.RAUser.ToShock.Time*1e4 == Data(Restrict(ToShockTimesTS{i},subset(RACondToShock{i},j))));
        if sum(idx_RAToShock{i}) > 0
            if a{i}.RAUser.ToShock.grade(idx_RAToShock{i}) > 0
                StartTimesOut(j) = StartTimes(j);
                EndTimesOut(j) = EndTimes(j);
            end
        end
    end
    StartTimesOut = nonzeros(StartTimesOut);
    EndTimesOut = nonzeros(EndTimesOut);
    
    RACondToShock{i} = intervalSet(StartTimesOut,EndTimesOut);
    
    % Check the location
    if ~isempty(Start(RACondToShock{i}))
        for j = 1:length(StartTimesOut)
            temp = Restrict(a{i}.CleanLinearDist,subset(RACondToShock{i},j));
            if mean(Data(temp))<0.5
                RACondToShock_tot(i) = RACondToShock_tot(i) + 1;
            end
        end
    end
    
    clear StartTimes EndTimes StartTimesOut EndTimesOut
    
    %%%%%%%%%%%%%%%%%%%% ToSafe %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    RACondToSafe{i} = and(a{i}.RAEpoch.ToSafe,CondEpoch{i});
    
    % Check the quality
    StartTimes = Start(RACondToSafe{i});
    EndTimes = End(RACondToSafe{i});
    
    StartTimesOut = zeros(1,length(StartTimes));
    EndTimesOut = zeros(1,length(EndTimes));
    
    
    ToSafeTimesTS{i} = ts(a{i}.RAUser.ToSafe.Time*1e4);
    for j=1:length(Start(RACondToSafe{i}))
        idx_RAToSafe{i} = find(a{i}.RAUser.ToSafe.Time*1e4 == Data(Restrict(ToSafeTimesTS{i},subset(RACondToSafe{i},j))));
        if sum(idx_RAToSafe{i}) > 0
            if a{i}.RAUser.ToSafe.grade(idx_RAToSafe{i}) > 0
                StartTimesOut(j) = StartTimes(j);
                EndTimesOut(j) = EndTimes(j);
            end
        end
    end
    StartTimesOut = nonzeros(StartTimesOut);
    EndTimesOut = nonzeros(EndTimesOut);
    
    RACondToSafe{i} = intervalSet(StartTimesOut,EndTimesOut);
    
    % Check the location
    if ~isempty(Start(RACondToSafe{i}))
        for j = 1:length(StartTimesOut)
            temp = Restrict(a{i}.CleanLinearDist,subset(RACondToSafe{i},j));
            if mean(Data(temp))>0.5
                RACondToSafe_tot(i) = RACondToSafe_tot(i) + 1;
            end
        end
    end
    
    clear StartTimes EndTimes StartTimesOut EndTimesOut
end

%% Plot

fh = figure('units', 'normalized', 'outerposition', [0 0 0.4 0.6]);
[p_occ,h_occ, her_occ] = PlotErrorBarN_DB([RACondToShock_tot' RACondToSafe_tot'],...
    'barcolors', [1 0 0], 'barwidth', 0.6, 'newfig', 0, 'showpoints',0);
h_occ.FaceColor = 'flat';
h_occ.CData(2,:) = [0 0 1];
set(gca,'Xtick',[1:2],'XtickLabel',{'ToShock', 'ToSafe'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold','FontName','Times New Roman');
set(gca, 'LineWidth', 3);
set(h_occ, 'LineWidth', 3);
set(her_occ, 'LineWidth', 3);
ylabel('# events');

%% Save it
if sav
    saveas(fh, [dir_out name_out '.fig']);
    saveFigure(fh,name_out,dir_out);
end