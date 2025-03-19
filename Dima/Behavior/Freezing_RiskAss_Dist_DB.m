%% Parameters
sav=0;
old = 0;
% Directory to save and name of the figure to save
dir_out = '/home/mobsrick/Dropbox/MOBS_workingON/Dima/Ongoing results/Behavior/';
name_out = 'Dist_';

ZoneNames = {'Shock','NearShock','FarShock','Center','FarSafe','NearSafe','Safe'};
ZoneThresh = [0.15, 0.30, 0.4, 0.5, 0.6, 0.85, 1;...
    0, 0.15, 0.30, 0.4, 0.5, 0.6, 0.85];

Dir = PathForExperimentsERC_Dima('UMazePAG');
Dir = RestrictPathForExperiment(Dir, 'nMice', [797 798 828 861 882 905 912 977 994]);

%% Get Data
for i = 1:length(Dir.path)
        a{i} = load([Dir.path{i}{1} '/behavResources.mat'], 'behavResources',...
            'SessionEpoch', 'ZoneEpoch', 'FreezeAccEpoch','CleanLinearDist','ZoneEpoch');
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



%% Create Zones
% for i=1:length(a)
%     for j=1:length(ZoneNames)
%         if j~=1
%             temp1 = thresholdIntervals(Restrict(a{i}.CleanLinearDist,CondEpoch{i}),ZoneThresh(1,j),'Direction','Below');
%             temp2 = thresholdIntervals(Restrict(a{i}.CleanLinearDist,CondEpoch{i}),ZoneThresh(2,j),'Direction','Above');
%             NewZones{i}{j} = and(temp1,temp2);
%             clear temp1 temp2
%         else
%             NewZones{i}{j} = thresholdIntervals(Restrict(a{i}.CleanLinearDist,CondEpoch{i}),ZoneThresh(1,j),...
%                 'Direction','Below');
%         end
%     end
% end

for i=1:length(a)
    if i<8
        Shock{i} = a{i}.ZoneEpoch.Shock;
        CentreShock{i} = a{i}.ZoneEpoch.CentreShock;
        Centre{i} = a{i}.ZoneEpoch.Centre;
        CentreSafe{i} = a{i}.ZoneEpoch.CentreNoShock;
        Safe{i} = a{i}.ZoneEpoch.NoShock;
    else
        Shock{i} = a{i}.ZoneEpoch.Shock;
        CentreShock{i} = or(a{i}.ZoneEpoch.CentreShock,a{i}.ZoneEpoch.FarShock);
        Centre{i} = a{i}.ZoneEpoch.Centre;
        CentreSafe{i} = or(a{i}.ZoneEpoch.CentreNoShock,a{i}.ZoneEpoch.FarNoShock);
        Safe{i} = a{i}.ZoneEpoch.NoShock;
    end
end

%% Process freezing
for i = 1:length(a)
    for k=1:length(id_Cond{i})
        eval(['FreezingCond{i}{k} = and(a{i}.FreezeAccEpoch,a{i}.SessionEpoch.Cond' num2str(k) ');']);
        
        time = sum(End(FreezingCond{i}{k})-Start(FreezingCond{i}{k}));
        
%         eval(['time = sum(End(a{i}.SessionEpoch.Cond' num2str(k) ')-Start(a{i}.SessionEpoch.Cond' num2str(k) '));']);
        
        tempMazeEpoch = or(a{i}.ZoneEpoch.NoShock,a{i}.ZoneEpoch.CentreNoShock);
        tempMazeEpoch = or(tempMazeEpoch,a{i}.ZoneEpoch.Centre);
        tempMazeEpoch = or(tempMazeEpoch,a{i}.ZoneEpoch.CentreShock);
        % Safe
        FreezingCondSafe{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.NoShock);
        FreezingCondSafePerc(i,k) = sum(End(FreezingCondSafe{i}{k})-Start(FreezingCondSafe{i}{k}))/...
            time*100;
        % CentreShock
        if i<8
            FreezingCondCentreShock{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.CentreShock);
            FreezingCondCentreShockPerc(i,k) = sum(End(FreezingCondCentreShock{i}{k})-Start(FreezingCondCentreShock{i}{k}))/...
                time*100;
        else
            FreezingCondCentreShock{i}{k} = and(FreezingCond{i}{k},...
                or(a{i}.ZoneEpoch.CentreShock,a{i}.ZoneEpoch.FarShock));
            FreezingCondCentreShockPerc(i,k) = sum(End(FreezingCondCentreShock{i}{k})-Start(FreezingCondCentreShock{i}{k}))/...
                time*100;
        end
        
        % Centre
        FreezingCondCentre{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.Centre);
        FreezingCondCentrePerc(i,k) = sum(End(FreezingCondCentre{i}{k})-Start(FreezingCondCentre{i}{k}))/...
            time*100;
        
        
        % CentreSafe
        if i<8
            FreezingCondCentreSafe{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.CentreNoShock);
            FreezingCondCentreSafePerc(i,k) = sum(End(FreezingCondCentreSafe{i}{k})-Start(FreezingCondCentreSafe{i}{k}))/...
                time*100;
        else
            FreezingCondCentreSafe{i}{k} = and(FreezingCond{i}{k},...
                or(a{i}.ZoneEpoch.CentreNoShock,a{i}.ZoneEpoch.FarNoShock));
            FreezingCondCentreSafePerc(i,k) = sum(End(FreezingCondCentreSafe{i}{k})-Start(FreezingCondCentreSafe{i}{k}))/...
                time*100;
        end
        
        FreezingCondAllExcSZ{i}{k} = and(FreezingCond{i}{k},tempMazeEpoch);
        FreezingCondAllExcSZPerc(i,k) = sum(End(FreezingCondAllExcSZ{i}{k})-Start(FreezingCondAllExcSZ{i}{k}))/...
            time*100;
        
        % Shock
        FreezingCondShock{i}{k} = and(FreezingCond{i}{k},a{i}.ZoneEpoch.Shock);
        FreezingCondShockPerc(i,k) = sum(End(FreezingCondShock{i}{k})-Start(FreezingCondShock{i}{k}))/...
            time*100;
        
        clear tempMazeEpoch
    end
end

FreezingCondSafePercMean = mean(FreezingCondSafePerc,2);
FreezingCondCentreShockPercMean = mean(FreezingCondCentreShockPerc,2);
FreezingCondCentrePercMean = mean(FreezingCondCentrePerc,2);
FreezingCondCentreSafePercMean = mean(FreezingCondCentreSafePerc,2);
FreezingCondShockPercMean = mean(FreezingCondShockPerc,2);
FreezingCondAllExcSZPercMean = mean(FreezingCondAllExcSZPerc,2);

%%%%% Distribution
for i=1:length(a)
    FreezingZonesEpoch{i}{1} = and(a{i}.FreezeAccEpoch,Shock{i});
    FreezingZonesEpoch{i}{2} = and(a{i}.FreezeAccEpoch,CentreShock{i});
    FreezingZonesEpoch{i}{3} = and(a{i}.FreezeAccEpoch,Centre{i});
    FreezingZonesEpoch{i}{4} = and(a{i}.FreezeAccEpoch,CentreSafe{i});
    FreezingZonesEpoch{i}{5} = and(a{i}.FreezeAccEpoch,Safe{i});
    timeTemp = sum(End(CondEpoch{i}) - Start(CondEpoch{i}));
    for j=1:5
        FreezingZonesPerc(i,j) = sum(End(FreezingZonesEpoch{i}{j})-Start(FreezingZonesEpoch{i}{j}))/timeTemp*100;
    end
    clear timeTemp
end


%% Plot

Mean1 = mean(FreezingCondShockPercMean);
Std1 = std(FreezingCondShockPercMean/0.22)/sqrt(length(a));
Mean2 = mean(FreezingCondCentreShockPercMean);
Std2 = std(FreezingCondCentreShockPercMean/0.245)/sqrt(length(a));
Mean3 = mean(FreezingCondCentrePercMean);
Std3 = std(FreezingCondCentrePercMean/0.07)/sqrt(length(a));
Mean4 = mean(FreezingCondCentreSafePercMean);
Std4 = std(FreezingCondCentreSafePercMean/0.245)/sqrt(length(a));
Mean5 = mean(FreezingCondSafePercMean);
Std5 = std(FreezingCondSafePercMean/0.22)/sqrt(length(a));

fh = figure('units', 'normalized', 'outerposition', [0 0 0.65 0.65]);
errorbar([1:5],[Mean1/0.22 Mean2/0.245 Mean3/0.07 Mean4/0.245 Mean5/0.22], [Std1 Std2 Std3 Std4 Std5],'Color','k','LineWidth',3)
% errorbar([1:5],[Mean1 Mean2 Mean3 Mean4 Mean5], [Std1 Std2 Std3 Std4 Std5],'Color','k','LineWidth',3)
set(gca,'Xtick',[1:5],'XtickLabel',{'Shock', 'CentreShock','Centre','CentreSafe','Safe'});
set(gca, 'FontSize', 18, 'FontWeight',  'bold');
ylabel('Deviation from equally distributed freezing');
hold on
xlim([0.5 5.5])
ylim([0 250])
line(xlim,[100 100],'Color','k','LineStyle','--','LineWidth',5);
box off
        
if sav
    saveas(gcf, [dir_out name_out 'FreezeCond.fig']);
    saveFigure(gcf,[name_out 'FreezeCond'],dir_out);
end

