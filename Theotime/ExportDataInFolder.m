% function [Dir, all_params] = ExportDataInFolder(Dir,Folder)
%EXPORTDATAINFOLDER Export encoder/decoder results in Folder
%   This function is mainly based on the following script:
%   LoadAndAnalyzeScript
%   This script is used to load the data from the results of the decoding
%   and analyze the results.
%   The data is saved in the folder of the input path.
%
%   Inputs:
%   pathForExperimentName: Path to the experiment folder.

Dir = PathForExperimentsERC('Sub')
Folder = '~/Dropbox/Mobs_member/Theotime De Charrin/data/';

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


% We prepare the variable that will be saved.
% Dir = RestrictPathForExperiment(Dir,'nMice', Mice_to_analyze);
window_list = [36; 108; 200; 252; 504];
clear all_params
for idx = 1:length(window_list)
    all_params.RealPos{idx}= {};
    all_params.PredPos{idx} = {};
    all_params.LinearPred{idx} = {};
    all_params.LinearPos{idx} = {};
    all_params.LossPred{idx} = {};

    all_params.PredPosPreSleep{idx} = {};
    all_params.LinearPredPreSleep{idx} = {};
    all_params.LossPredPreSleep{idx} = {};

    all_params.PredPosPostSleep{idx} = {};
    all_params.LinearPredPostSleep{idx} = {};
    all_params.LossPredPostSleep{idx} = {};

    all_params.StimTs{idx} = {};
    all_params.RippleTime{idx} = {};
    all_params.SleepEpoch{idx} = {};
    all_params.SleepREMEpoch{idx} = {};
    all_params.SleepSWSEpoch{idx} = {};
    all_params.SessionEpochs{idx} = {};
    all_params.Speed{idx} = {};
    % Also add the nb of training epochs
    all_params.TrainingLossEpochs{idx} = {};
    all_params.windowSize{idx} = window_list(idx);
end
all_params.Dir = Dir;

for imouse = 1:length(Dir.path)
    cd(Dir.path{imouse}{1});
    load('behavResources.mat');
    load('SWR.mat');
    load('SleepScoring_OBGamma.mat');
    % load('SpikeData.mat');
    cd(Dir.results{imouse}{1});
    for idx = 1:length(window_list)
        window_size = num2str(window_list(idx));

        try
            %% Importing the non sleep data : Linear and xy pred and true, timesteps.
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/timeStepsPred.csv'], 'TimeStepsPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/linearPred.csv'], 'LinearPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/lossPred.csv'], 'LossPred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/linearTrue.csv'], 'LinearTrue', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/featureTrue.csv'], 'FeatureTrue', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'results/' window_size '/featurePred.csv'], 'FeaturePred', 'window', window_size);
            loadAndSaveCSV([Dir.results{imouse}{1} 'models/' window_size '/full/fullModelLosses.csv'], 'TrainingLossEpochs', 'window', window_size);


            %% Importing decoded position during pre and post sleep : Linear and xy pred, timesteps.
            try
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/linearPred.csv'], 'LinearPredPostSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/featurePred.csv'], 'FeaturePostSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/timeStepsPred.csv'], 'TimeStepsPredPostSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PostSleep/lossPred.csv'], 'LossPredPostSleep', 'window', window_size);
                load([ 'FeaturePredPostSleep', window_size, '.mat' ]);
                load(['LinearPredPostSleep' , window_size '.mat'])
                load([ 'TimeStepsPredPostSleep' , window_size '.mat' ])
            catch
                disp("No PostSleep session found")
            end
            % Same for pre sleep
            try
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PreSleep/linearPred.csv'], 'LinearPredPreSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PreSleep/featurePred.csv'], 'FeaturePreSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PreSleep/timeStepsPred.csv'], 'TimeStepsPredPreSleep', 'window', window_size);
                loadAndSaveCSV([Dir.results{imouse}{1} 'results_Sleep/' window_size '/PreSleep/lossPred.csv'], 'LossPredPreSleep', 'window', window_size);
                load([ 'FeaturePredPreSleep', window_size, '.mat' ]);
                load(['LinearPredPreSleep' , window_size '.mat'])
                load([ 'TimeStepsPredPreSleep' , window_size '.mat' ])
            catch
                disp("No PreSleep session found")
            end
        catch
            disp(['No window in', ' ', window_size, ' ', 'for ', Dir.name{imouse}])
            continue
        end

        load([ 'FeaturePred' , window_size '.mat' ]);
        load([ 'LinearPred' , window_size '.mat' ]);
        load([ 'TimeStepsPred' , window_size '.mat' ]);
        load([ 'LossPred' ,window_size '.mat' ]);
        load([ 'LinearTrue' ,  window_size '.mat' ]);
        load([ 'FeatureTrue' ,  window_size '.mat' ]);
        load([ 'TrainingLossEpochs' ,  window_size '.mat' ]);


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

        LossPredTsd=tsd(TimeStepsPred*1E4,LossPred);
        LinearTrueTsd=tsd(TimeStepsPred*1E4,LinearTrue);
        LinearPredTsd=tsd(TimeStepsPred*1E4,LinearPred);
        FeatureTrueTsd=tsd(TimeStepsPred*1E4,FeatureTrue);
        FeaturePredTsd=tsd(TimeStepsPred*1E4,FeaturePred);

        % LossPredCorrected=LossPred;
        % LossPredCorrected(LossPredCorrected<-15)=NaN;
        % LossPredTsdCorrected=tsd(TimeStepsPred*1E4,LossPredCorrected);
        % LossPredTsd = LossPredTsdCorrected;

        try
            LinearPredPostSleepTsd=tsd(TimeStepsPredPostSleep*1E4,LinearPredPostSleep);
            FeaturePredPostSleepTsd=tsd(TimeStepsPredSleep*1E4,FeaturePredPostSleep);
            LossPredPostSleepTsd=tsd(TimeStepsPredPostSleep*1E4,LossPredPostSleep);
        catch
        end

        try
            LinearPredPreSleepTsd=tsd(TimeStepsPredPreSleep*1E4,LinearPredPreSleep);
            FeaturePredPreSleepTsd=tsd(TimeStepsPredPreSleep*1E4,FeaturePredPreSleep);
            LossPredPreSleepTsd=tsd(TimeStepsPredPreSleep*1E4,LossPredPreSleep);
        catch
        end

        % We save the data in the all_params structure
        all_params.RealPos{idx}{imouse} = FeatureTrueTsd;
        all_params.PredPos{idx}{imouse} = FeaturePredTsd;
        all_params.LinearPred{idx}{imouse} = LinearPredTsd;
        all_params.LinearPos{idx}{imouse} = LinearTrueTsd;
        all_params.LossPred{idx}{imouse} = LossPredTsd;
        all_params.TrainingLossEpochs{idx}{imouse} = TrainingLossEpochs;

        try
            all_params.PredPosPreSleep{idx}{imouse} = FeaturePredPreSleepTsd;
            all_params.LinearPredPreSleep{idx}{imouse} = LinearPredPreSleepTsd;
            all_params.LossPredPreSleep{idx}{imouse} = LossPredPreSleepTsd;
        catch
        end

        try
            all_params.PredPosPostSleep{idx}{imouse} = FeaturePredPostSleepTsd;
            all_params.LinearPredPostSleep{idx}{imouse} = LinearPredPostSleepTsd;
            all_params.LossPredPostSleep{idx}{imouse} = LossPredPostSleepTsd;
        catch
        end

        all_params.StimTs{idx}{imouse} = StimEpoch;
        all_params.RippleTime{idx}{imouse} = tRipples;
        all_params.SleepEpoch{idx}{imouse} = Epoch;
        all_params.SleepREMEpoch{idx}{imouse} = REMEpoch;
        all_params.SleepSWSEpoch{idx}{imouse} = SWSEpoch;
        all_params.SessionEpochs{idx}{imouse} = SessionEpoch;
        all_params.Speed{idx}{imouse} = V;
    end
    clearvars -except Dir all_params imouse window_list Folder

end
save([Folder 'nnAllParams.mat'], '-struct','all_params');
disp(['Your params were saved under' Folder 'nnAllParams.mat'])
