% LoadAndAnalyzeScript
% This script is used to load the data from the results of the decoding
% and analyze the results. It will plot the confidence of the network
% around ripples events, and the predicted vs actual Linear predicted distance.
% It will also plot the predLoss around ripples and in mean recording.
% It will also plot the confidence during ripples and the correlation/error matrix.
%
% Inputs:
% pathForExperimentName: Path to the experiment folder.
% fig: boolean to plot the figures or not.

pathForExperimentName = 'Sub';
fig = false;
fig = true
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
window_list = 200;
for idx = 1:length(window_list)
    all_params.speed{idx}= {};
    all_params.LossPred{idx}= {};
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

    all_params.Eerror_bad{idx} = {};
    all_params.Eerror_good{idx} = {};
end

window_size = num2str(window_list(1));

for imouse = 1:length(Dir.path)
    cd(Dir.path{imouse}{1});
    load('behavResources.mat');
    load('SWR.mat');
    % load('SpikeData.mat');
    cd(Dir.results{imouse}{1});
    window_size = '200';
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
            window_size = '252';
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

    disp([pwd,' ', window_size])

    smootime = 2; % in s
    Smooth_Speed = tsd(Range(V) , movmean(Data(V), ceil(smootime/median(diff(Range(V,'s'))))));
    Vraw = V;
    V = Smooth_Speed;
    Moving=thresholdIntervals(V,speed_thresh,'Direction','Above');
    TotEpoch=intervalSet(0,max(Range(V)));
    NonMoving=TotEpoch-Moving;
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

    all_params.speed{imouse} = V;
    all_params.LossPred{imouse} = LossPredTsd;

    BadEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.75),'Direction','Above');
    GoodEpoch=thresholdIntervals(LossPredTsd,quantile(Data(LossPredTsd), 0.10),'Direction','Below');
    stim=ts(Start(StimEpoch));
    RipEp=intervalSet(Range(tRipples)-0.2*1E4,Range(tRipples)+0.2*1E4);RipEp=mergeCloseIntervals(RipEp,1);

    if fig
        close all

        %% Plot the network confidence around ripples events, and the predicted vs actual Linear predicted distance.
        figure, plot(Range(Restrict(LossPredTsd, RipplesEpoch)), zscore(Data(Restrict(LossPredTsd, RipplesEpoch))), 'k.')
        hold on, plot(Range(Restrict(LinearPredTsd, RipplesEpoch)), Data(Restrict(LinearPredTsd, RipplesEpoch)), 'ko', 'markerfacecolor','k')
        hold on, plot(Range(Restrict(LinearTrueTsd, RipplesEpoch)), Data(Restrict(LinearTrueTsd, RipplesEpoch)), 'ko', 'markerfacecolor','y')

        saveFigure_BM(1, ['ripples'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')
        % figure, hist(Data(Restrict(LinearPredTsd, RipplesEpoch)))

        %% Plot the predLoss around ripples and in mean recording
        figure, histogram(Data(Restrict(LossPredTsd, RipplesEpoch)),20, 'FaceColor', [0.7 0.7 0.7]);
        hold on;
        % Add mean and median lines
        xline(mean(Data(Restrict(LossPredTsd, RipplesEpoch))), 'r', 'LineWidth', 2, 'Label', 'Mean', 'LabelHorizontalAlignment', 'left');
        xline(median(Data(Restrict(LossPredTsd, RipplesEpoch))), 'b', 'LineWidth', 2, 'Label', 'Median', 'LabelHorizontalAlignment', 'left');

        % Customize plot
        legend({'Data', 'Mean', 'Median'}, 'Location', 'best');
        xlabel('Value');
        ylabel('Frequency');
        title('Distribution of predicted loss during ripples');
        saveFigure_BM(2, ['lossDistribRipples'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')

        hold off;

        figure, histogram(Data(LossPredTsd), 'FaceColor', [0.7 0.7 0.7]);
        hold on;
        % Add mean and median lines
        xline(mean(Data(LossPredTsd)), 'r', 'LineWidth', 2, 'Label', 'Mean', 'LabelHorizontalAlignment', 'left');
        xline(median(Data(LossPredTsd)), 'b', 'LineWidth', 2, 'Label', 'Median', 'LabelHorizontalAlignment', 'left');

        % Customize plot
        legend({'Data', 'Mean', 'Median'}, 'Location', 'best');
        xlabel('Value');
        ylabel('Frequency');
        title('Overall Distribution of predicted loss');
        saveFigure_BM(3, ['lossDistrib'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')

        hold off;

        % LossPredCorrected = rmoutliers(LossPred, "percentiles", [.05
        % 100]);3
    end



    % Compute the mean and std of confidence around ripples for moving and non moving epochs (around and not around ripples)
    [m, s, tps] = mETAverage(Range(tRipples), Range(Restrict(LossPredTsdCorrected, Moving)), Data(Restrict(LossPredTsdCorrected, Moving)), 1, 2000);
    all_params.mean_conf_moving{imouse} = m;
    all_params.std_conf_moving{imouse} = s;

    [m, s, tps] = mETAverage(Range(tRipples), Range(Restrict(LossPredTsdCorrected, NonMoving)), Data(Restrict(LossPredTsdCorrected, NonMoving)), 1, 2000);
    all_params.mean_conf_nmoving{imouse} = m;
    all_params.std_conf_nmoving{imouse} = s;

    sw = Range(tRipples);

    [m, s, tps] = mETAverage(Range(tRipples), Range(Restrict(LossPredTsdCorrected, NonMoving)), Data(Restrict(LossPredTsdCorrected, NonMoving)), 1, 2000);
    all_params.mean_conf_nmovingrip{imouse} = m;
    all_params.std_conf_nmovingrip{imouse} = s;

    % maxnb_neurons = max(80, length(Stsd));
    % figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:50), ts(sw(1:100)), -1500,+1500,'BinSize',10);
    % title('my neurons have a nice ripple')

    notRipples= MonteCarloThisTs(tRipples, to_shift);
    [m, s, tps] = mETAverage(Range(ts(notRipples)), Range(Restrict(LossPredTsdCorrected, NonMoving)), Data(Restrict(LossPredTsdCorrected, NonMoving)), 1, 2000);
    all_params.mean_conf_nmovingnrip{imouse} = m;
    all_params.std_conf_nmovingnrip{imouse} = s;
    % figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:50), ts(notRipples(1:100)), -1500,+1500,'BinSize',10);
    % title(strcat( 'if shifted by  ',  num2str(to_shift/1e4), ' s the ripples are less nice'))


    pts = linspace(0, 1, 20);
    errorgood = histcounts2(Data(Restrict(Restrict(LinearPredTsd,testPre), GoodEpoch)),Data(Restrict(Restrict(LinearTrueTsd,testPre), GoodEpoch)), pts, pts);
    errorbad = histcounts2(Data(Restrict(Restrict(LinearPredTsd,testPre), BadEpoch)),Data(Restrict(Restrict(LinearTrueTsd,testPre), BadEpoch)), pts, pts);
    all_params.error_good{imouse} = errorgood;
    all_params.error_bad{imouse} = errorbad;

    % Compute the mean and std of confidence around ripples
    [m, s, tps] = mETAverage(Range(tRipples), Range(LossPredTsdCorrected), Data(LossPredTsdCorrected), 1, 2000);
    all_params.mean_conf{imouse} = m;
    all_params.std_conf{imouse} = s;
    all_params.tps{imouse} = tps;

    if fig
        figure
        shadedErrorBar(tps , movmean(-m,10,'omitnan') , movmean(s,10,'omitnan') , '-k')
        vline(0,'--r')
        xlabel('Time around ripples (ms)')
        text(1,3,'rip time','Color','r')

        legend('confidence prediction')
        title("Prediction Confidence increase around ripples.")
        saveFigure_BM(4, ['ConfidenceRipples'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')


        % figure, plot(tps, movmean(m,10,'omitnan'))

        figure;
        % PlotRipRaw(LossPredTsdCorrected , Range(tRipples)/1e4, 3000);
        % saveFigure_BM(5, ['RipRaw'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')


        %% Plot the confidence during ripples
        [h6,b6]=hist(Data(Restrict(LossPredTsd,RipEp)),50);
        figure, plot(b6,h6/max(h6),'color',[0.6 1 0.6])
        saveFigure_BM(6, ['ConfidenceDistrib'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')


        %% Plot the correlation/error matrix

        figure;
        scatter(Data(Restrict(Restrict(LinearTrueTsd,testPre), GoodEpoch)),Data(Restrict(Restrict(LinearPredTsd,testPre), GoodEpoch)), 'blue')
        hold on;
        scatter(Data(Restrict(Restrict(LinearTrueTsd,testPre), BadEpoch)),Data(Restrict(Restrict(LinearPredTsd,testPre), BadEpoch)), 'r')
        xlabel('True Linear Position')
        ylabel('Predicted Linear Position')
        legend({'GoodEpochs', 'BadEpochs'}, 'Location', 'best');
        saveFigure_BM(7, ['predError'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')

        figure;
        subplot(1,2,1);
        imagesc(pts,pts,errorgood)
        % colormap('jet'); % set the colorscheme
        % crameri('cork','pivot',0)
        crameri('-roma')
        axis equal;
        xlabel('Predicted LinearPos', 'FontSize', 15)
        ylabel('True LinearPos', 'FontSize', 15)
        set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
        title("Precision Matrix during good Epochs")
        grid on;
        subplot(1,2,2)
        imagesc(pts,pts,errorbad)
        % colormap('jet'); % set the colorscheme
        crameri('-roma')
        xlabel('Predicted LinearPos', 'FontSize', 15)
        ylabel('True LinearPos', 'FontSize', 15)
        axis equal;
        title("Precision Matrix during bad Epochs")
        set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
        saveFigure_BM(8, ['predErrorMatrix'  '_M' num2str(Dir.ExpeInfo{imouse}.nmouse)], '/home/mickey/download/figures/')
    end

    close all
    if ~(imouse == length(Dir.path))
        clearvars -except Dir all_params imouse fig to_shift speed_thresh
    end
end


%% To run only after full analysis

figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(zscore_nan_BM(cell2mat(all_params.mean_conf)), 5),2,'omitnan'),mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'))
title("Prediction Loss decreases around ripples. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple.')

saveFigure_BM(1, ['SubplotConfidenceRipples_allMicen9'], '/home/mickey/download/figures/')


figure;
subplot(1,2,1);
pts = linspace(0, 1, 20);

imagesc(pts,pts,mean(cat(3, all_params.error_good{:}),3, 'omitnan'))
% colormap('jet'); % set the colorscheme
crameri('-roma')
axis equal;
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal');
title("Error Matrix during good Epochs")
        xlabel('Predicted LinearPos', 'FontSize', 15)
        ylabel('True LinearPos', 'FontSize', 15)
grid on;
subplot(1,2,2)

imagesc(pts,pts,mean(cat(3, all_params.error_bad{:}),3, 'omitnan'))
% colormap('jet'); % set the colorscheme
crameri('-roma')
axis equal;
title("Error Matrix during bad Epochs")
        xlabel('Predicted LinearPos', 'FontSize', 15)
        ylabel('True LinearPos', 'FontSize', 15)
set(gca, 'XLim', pts([1 end]), 'YLim', pts([1 end]), 'YDir', 'normal')
saveFigure_BM(2, ['ErroMatrixGoodBadnMice9'], '/home/mickey/download/figures/')


figure
subplot(121)
Data_to_use = movmean(cell2mat(all_params.mean_conf),20,'omitnan')';
Conf_Inter = nanstd(Data_to_use)./sqrt(size(Data_to_use,1));

h=shadedErrorBar(all_params.tps{1} , nanmean(Data_to_use) , Conf_Inter , '-k');
title("20-moving average mean loss prediction")


subplot(122)
Data_to_use = movmean(cell2mat(all_params.std_conf),20,'omitnan')';
Conf_Inter = nanstd(Data_to_use)./sqrt(size(Data_to_use,1));
h=shadedErrorBar(all_params.tps{1} , nanmean(Data_to_use) , Conf_Inter , '-k');
title("20-moving average std of loss prediction")

saveFigure_BM(3, ['SubplotConfidenceRipples_allMicen9_movingaverage'], '/home/mickey/download/figures/')

figure
plot(cell2mat(all_params.mean_conf))


%% Bonus
% plot according to moving or not - freezing or not...
% instead of tRipples, chose a random range of times to plot the confidence around it
% monte carlo simulation to see if the confidence is different around ripples than in general

[m, s, tps] = mETAverage(Range(tRipples), Range(Restrict(LossPredTsdCorrected, NonMoving)), Data(Restrict(LossPredTsdCorrected, NonMoving)), 1, 2000);
figure, plot(m)
[m, s, tps] = mETAverage(Range(tRipples), Range(Restrict(LossPredTsdCorrected, Moving)), Data(Restrict(LossPredTsdCorrected, Moving)), 1, 2000);
figure, plot(m)

to_shift = 1e4;
events_to_center= MonteCarloThisTs(tRipples, to_shift);
sw = Range(tRipples);
load('/media/mickey/DataMOBS210/DimaERC2/M1336_Known/SpikeData.mat')
Stsd = S
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:50), ts(sw(1:100)), -1500,+1500,'BinSize',10);
title('my neurons have a nice ripple')
figure, [fh,sq,sweeps] = RasterPETH(PoolNeurons(Stsd,1:50), ts(events_to_center(1:100)), -1500,+1500,'BinSize',10);
title(strcat( 'if shifted by  ',  num2str(to_shift/1e4), ' s the ripples are less nice'))


%% Plot figures for moving and non moving Epochs

figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(zscore_nan_BM(cell2mat(all_params.mean_conf_moving)), 5),2,'omitnan'),mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'));
title("Prediction Loss decreases around ripples - only moving epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf_moving)), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only moving epochs.')


figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(zscore_nan_BM(cell2mat(all_params.mean_conf_nmoving)), 5),2,'omitnan'),mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only nmoving epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf_nmoving)), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only nmoving epochs.')

figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(zscore_nan_BM(cell2mat(all_params.mean_conf_nmovingrip)), 5),2,'omitnan'),mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only nmovingrip epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf_nmovingrip)), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only nmovingrip epochs.')

figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(zscore_nan_BM(cell2mat(all_params.mean_conf_nmovingnrip)), 5),2,'omitnan'),mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf)), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only nmovingnrip epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(zscore_nan_BM(cell2mat(all_params.std_conf_nmovingnrip)), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only nmovingnrip epochs.')

%% Do the same figures WITHOUT zscore, in order to compare absolute values

%%% for non moving non rip
figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(cell2mat(all_params.mean_conf_nmovingnrip), 5),2,'omitnan'),mean(movmean(cell2mat(all_params.std_conf_nmovingnrip), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only nmovingnrip epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(cell2mat(all_params.std_conf_nmovingnrip), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only nmovingnrip epochs.')

%%% for non moving rip
figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(cell2mat(all_params.mean_conf_nmovingrip), 5),2,'omitnan'),mean(movmean(cell2mat(all_params.std_conf_nmovingrip), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only nmovingrip epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')

legend('loss prediction')

subplot(1,2,2)

ystd = fillmissing(mean(movmean(cell2mat(all_params.std_conf_nmovingrip), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
coefficients = polyfit(x, ystd, 30);
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only nmovingrip epochs.')

%%% for moving
figure;
subplot(1,2,1)
shadedErrorBar(all_params.tps{1},mean(movmean(cell2mat(all_params.mean_conf_moving), 5),2,'omitnan'),mean(movmean(cell2mat(all_params.std_conf_moving), 5), 2, 'omitnan'));

title("Prediction Loss decreases around ripples - only moving epochs. n_{mice} = 9")
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('Prediction Loss')
text(1,3,'rip time','Color','r')
legend('loss prediction')
subplot(1,2,2)
ystd = fillmissing(mean(movmean(cell2mat(all_params.std_conf_moving), 5), 2, 'omitnan'), 'previous');
x = all_params.tps{1};
size(x)
xFit = linspace(min(x), max(x), 1000);
yFit = polyval(coefficients , xFit);
plot(x, ystd, 'b.', 'MarkerSize', 10, 'MarkerFaceColor', [0.7 0.7 0.7]); % Plot training data.
hold on; % Set hold on so the next plot does not blow away the one we just drew.
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
hline(0,'g--')
vline(0,'--r')
xlabel('Time around ripples (ms)')
ylabel('std')
text(1,3,'rip time','Color','r')
title('Standard error decreases right after the ripple  - only moving epochs.')

CorrelateTSDs(all_params.speed, all_params.LossPred, 'fig', true)