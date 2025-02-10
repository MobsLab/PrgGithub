pathForExperimentName = 'Sub';
fig = true;
% fig = true
to_shift = 1e4;
speed_thresh = 2;


% Function to load and save CSV data (in the current folder)
function [data, idx] = loadAndSaveCSV(filePath, varName, varargin)
p = inputParser;
defaultwindowFlag = false;
addOptional(p,'window',defaultwindowFlag);

parse(p,varargin{:});
windowFlag = p.Results.window;
csvData = csvread(filePath);
idx = csvData(2:end, 1);
data = csvData(2:end, 2);
eval([strcat('idx', varName) '= idx;']);
eval([varName '= data;']);
if ~windowFlag
    save([varName '.mat'], strcat('idx', varName), strcat(varName));
else
    save([varName windowFlag '.mat'], strcat('idx', varName), strcat(varName));
end
end


% Mice_to_analyze = 994
Dir = PathForExperimentsERC(pathForExperimentName);

% We prepare the variable that will be saved.
% Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
window_list = [36; 108; 200; 252; 504];
for idx = 1:length(window_list)
    all_params.speed{idx}= {};
    all_params.LossPred{idx}= {};
    all_params.Error_Moving{idx} = {};
    all_params.Error_NonMoving{idx} = {};
    all_params.mean_conf{idx}= {};
    all_params.std_conf{idx}= {};
    all_params.mean_conf_moving{idx}= {};
    all_params.std_conf_moving{idx}= {};
    all_params.mean_conf_nmoving{idx}= {};
    all_params.std_conf_nmoving{idx}= {};
    all_params.mean_conf_nmovingrip{idx}= {};
    all_params.std_conf_nmovingrip{idx}= {};
    all_params.mean_conf_nmovingnrip{idx}= {};
    all_params.std_conf_nmovingnrip{idx}= {};
    all_params.tps{idx}= {};
    all_params.error_good{idx}= {};
    all_params.error_bad{idx}= {};
    all_params.Eerror_good{idx}= {};
    all_params.Eerror_bad{idx}= {};
    all_params.RandomEerror_bad{idx} = {};
    all_params.RandomEerror_good{idx} = {};
    all_params.conf_freezing{idx} = {};
    all_params.std_conf_freezing{idx} = {};
    all_params.err_freezing{idx} = {};
    all_params. std_err_freezing{idx} = {};
    all_params.err_post{idx} = {};
    all_params.std_err_post{idx} = {};
    all_params.conf_post{idx} = {};
    all_params.std_conf_post{idx} = {};
    all_params.conf_moving{idx} = {};
    all_params.conf_nmoving{idx} = {};
end

for imouse = 1:length(Dir.path)
    cd(Dir.path{imouse}{1});
    load('behavResources.mat');
    load('SWR.mat');
    % load('SpikeData.mat');
    cd(Dir.results{imouse}{1});
    for idx = 1:length(window_list)
        window_size = num2str(window_list(idx));

        try
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/linearPred.csv'], 'LinearPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/timeStepsPred.csv'], 'TimeStepsPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/lossPred.csv'], 'LossPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/linearTrue.csv'], 'LinearTrue', 'window', window_size);

            % Importing decoded position during sleep
            try
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/linearPred.csv'], 'LinearPredSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/timeStepsPred.csv'], 'TimeStepsPredSleep', 'window', window_size);
                load(['LinearPredSleep' , window_size '.mat'])
                load([ 'TimeStepsPredSleep' , window_size '.mat' ])
            catch
                disp("No sleep session found")
            end
        catch
            disp(['No window in', ' ', window_size, ' ', 'for ', Dir.name{imouse}])
            continue
        end

        load([ 'LinearPred' , window_size '.mat' ]);
        load([ 'TimeStepsPred' , window_size '.mat' ])
        load([ 'LossPred' ,window_size '.mat' ])
        load([ 'LinearTrue' ,  window_size '.mat' ])


        try
            % old fashion data
            % Range(S{1});
            % Stsd=S;
            t=Range(AlignedXtsd);
            X=AlignedXtsd;

            Y=AlignedYtsd;
            V=Vtsd;
            preSleep=SessionEpoch.PreSleep;
            try
                hab = or(SessionEpoch.Hab1,SessionEpoch.Hab2);
            catch error
                hab = SessionEpoch.Hab;
            end

            try
                testPre=or(or(SessionEpoch.Hab1,SessionEpoch.Hab2),or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
            catch
                testPre=or(SessionEpoch.Hab,or(or(SessionEpoch.TestPre1,SessionEpoch.TestPre2),or(SessionEpoch.TestPre3,SessionEpoch.TestPre4)));
            end

            cond=or(or(SessionEpoch.Cond1,SessionEpoch.Cond2),or(SessionEpoch.Cond3,SessionEpoch.Cond4));
            postSleep=SessionEpoch.PostSleep;
            testPost=or(or(SessionEpoch.TestPost1,SessionEpoch.TestPost2),or(SessionEpoch.TestPost3,SessionEpoch.TestPost4));
            try
                extinct = SessionEpoch.Extinct;
                sleep = or(preSleep,postSleep);
                tot=or(or(hab,or(testPre,or(testPost,or(cond,extinct)))),sleep);
            catch
                disp('no extinct session')
                sleep = or(preSleep,postSleep);
                tot=or(or(hab,or(testPre,or(testPost, cond))),sleep);
            end

        catch
            % Dima's style of data
            % clear Stsd
            % for i=1:length(S.C)
            %     test=S.C{1,i};
            %     Stsd{i}=ts(test.data);
            % end
            % Stsd=tsdArray(Stsd);
            t = AlignedXtsd.data;
            X = tsd(AlignedXtsd.t,AlignedXtsd.data);
            Y = tsd(AlignedYtsd.t,AlignedYtsd.data);
            V = tsd(Vtsd.t,Vtsd.data);
            hab1 = intervalSet(SessionEpoch.Hab1.start,SessionEpoch.Hab1.stop);
            hab2 = intervalSet(SessionEpoch.Hab2.start,SessionEpoch.Hab2.stop);
            testPre1=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre1.stop);
            testPre2=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre2.stop);
            testPre3=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre3.stop);
            testPre4=intervalSet(SessionEpoch.TestPre1.start,SessionEpoch.TestPre4.stop);
            testPre=or(or(hab1,hab2),or(or(testPre1,testPre2),or(testPre3,testPre4)));
            cond1 = intervalSet(SessionEpoch.Cond1.start,SessionEpoch.Cond1.stop);
            cond2 = intervalSet(SessionEpoch.Cond2.start,SessionEpoch.Cond2.stop);
            cond3 = intervalSet(SessionEpoch.Cond3.start,SessionEpoch.Cond3.stop);
            cond4 = intervalSet(SessionEpoch.Cond4.start,SessionEpoch.Cond4.stop);
            cond = or(or(cond1,cond2),or(cond3,cond4));
            postSleep = intervalSet(SessionEpoch.PostSleep.start,SessionEpoch.PostSleep.stop);
            preSleep = intervalSet(SessionEpoch.PreSleep.start,SessionEpoch.PreSleep.stop);
            sleep = or(preSleep,postSleep);
            tot = or(testPre,sleep);
        end

        disp(['this was' pwd,' ', window_size]); disp(' ')

        smootime = 2; % in s
        Smooth_Speed = tsd(Range(V) , movmean(Data(V), ceil(smootime/median(diff(Range(V,'s'))))));
        Vraw = V;
        V = Smooth_Speed;
        Moving=thresholdIntervals(V,speed_thresh,'Direction','Above');
        nonSleep = tot - sleep
        Moving = and(Moving,nonSleep)
        TotEpoch=intervalSet(0,max(Range(V)));
        NonMoving=TotEpoch-Moving;
        NonMoving = and(NonMoving, nonSleep)
        LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);
        LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
        LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);

        LossPredCorrected=LossPred;
        LossPredCorrected(LossPredCorrected<-15)=NaN;
        LossPredTsdCorrected=tsd(TimeStepsPred*1E4,LossPredCorrected);
        LossPredTsd = LossPredTsdCorrected;
        try
            LinearPredSleepTsd=tsd(TimeStepsPredSleep*1E4,LinearPredSleep);
        catch
        end

        notPre = or(or(cond, postSleep), testPost);

        % all_params.speed{imouse} = V;
        all_params.speed{idx}{imouse} = V;

        all_params.LossPred{idx}{imouse} = LossPredTsd;

        BadEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.75),'Direction','Above');
        GoodEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.10),'Direction','Below');

        stim=ts(Start(StimEpoch));
        RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);


        all_params.Error_Moving{idx}{imouse} = sqrt((Data(Restrict(LinearPredTsd, Moving)) - Data(Restrict(LinearTrueTsd, Moving))).^2);
        all_params.Error_NonMoving{idx}{imouse} = sqrt((Data(Restrict(LinearPredTsd, NonMoving)) - Data(Restrict(LinearTrueTsd, NonMoving))).^2);

        all_params.conf_moving{idx}{imouse} = Data(Restrict(LossPredTsd, Moving));
        all_params.conf_nmoving{idx}{imouse} = Data(Restrict(LossPredTsd, NonMoving));

    end
end

% Initialize empty arrays
data = [];       % Stores all values
group = [];      % Stores window size groups (idx)
condition = [];  % Stores condition labels (1 = Moving, 2 = NonMoving)

% Extract both conditions
dataCell1 = all_params.conf_moving;     % First condition (Moving)
dataCell2 = all_params.conf_nmoving;  
dataCell1 = all_params.Error_Moving;     % First condition (Moving)
dataCell2 = all_params.Error_NonMoving;  % Second condition (NonMoving)

% Function to process data and assign condition labels
processData = @(cellData, condLabel) arrayfun(@(i) ...
    struct('values', cellfun(@mean, cellData{i}(:), 'UniformOutput', true), ...
           'group', i, 'condition', condLabel), ...
    1:length(cellData), 'UniformOutput', false);

% Process all conditions (Taking mean per mouse)
dataStructs = [processData(dataCell1, 1), processData(dataCell2, 2)];

% Flatten data structure into arrays
for i = 1:length(dataStructs)
    if ~isempty(dataStructs{i}.values)
        data = [data; dataStructs{i}.values]; % Store means instead of full arrays
        group = [group; dataStructs{i}.group * ones(size(dataStructs{i}.values))];
        condition = [condition; dataStructs{i}.condition * ones(size(dataStructs{i}.values))];
    end
end

% Convert condition numbers to categorical labels
condition_labels = categorical(condition, [1, 2], {'Moving', 'NonMoving'});

% Step 2: Create the grouped boxplot
figure;
boxchart(group, data, 'GroupByColor', condition_labels);

% Step 3: Customize appearance
ax = gca;
ax.FontSize = 14;
ylabel('Prediction Error (Mean per Mouse)', 'FontSize', 14);
title('Prediction Error: Moving vs NonMoving', 'FontSize', 16);
xticks(1:length(dataCell1)); 

xticklabels(num2cell(window_list)); % Adjust as needed

% Step 4: Compute and overlay means
colors = {[0, 0.447, 0.741], [0.850, 0.325, 0.098]}; % Blue (Moving), Red (NonMoving)

hold on;
for i = 1:length(dataCell1)
    % Compute means for each condition at this idx
    meanVals = [mean(cellfun(@mean, dataCell1{i}(:))), ...
                mean(cellfun(@mean, dataCell2{i}(:)))];

    % Plot means slightly offset for visibility
    scatter(i - 0.1, meanVals(1), 100, colors{1}, 'filled', 'd'); % Moving
    scatter(i + 0.1, meanVals(2), 100, colors{2}, 'filled', 'd'); % NonMoving
    
    % Display mean values
    text(i - 0.1, meanVals(1), sprintf('%.2f', meanVals(1)), ...
         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'Color', colors{1});
    text(i + 0.1, meanVals(2), sprintf('%.2f', meanVals(2)), ...
         'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center', ...
         'FontSize', 12, 'Color', colors{2});
end

% Step 5: Add legend
legend({'Moving', 'NonMoving'}, 'Location', 'Best');

hold off;
