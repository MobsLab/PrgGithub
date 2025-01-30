function [hypnogram, StageEpochs] = ParseHypnogramFromText(filename)
%
%    [hypnogram, StageEpochs] = ParseHypnogramFromText(filename)
%
% INPUT:
% - filename                Filename of the txt file
% 
%
% OUTPUT:
% - Hypnogram               array - sleep stages (30s epochs)
%                           1: N1, 2: N2, 3: N3, 4: REM, 5: Wake      
%


%params
stage_epoch_duration = 30E4;

% Read and load the file
lines = importdata(filename);
% Select the subselection of the file corresponding to the Hypnogram
idx = find(strcmp(lines.textdata, 'Sleep Stage'));
hypnogram = lines.textdata(idx+1:end, 1);

% Replace each element by the real stage name/number
hypnogram(strcmp(hypnogram, 'SLEEP-S0')) = {0};
hypnogram(strcmp(hypnogram, 'SLEEP-S1')) = {1};
hypnogram(strcmp(hypnogram, 'SLEEP-S2')) = {2};
hypnogram(strcmp(hypnogram, 'SLEEP-S3')) = {3};
hypnogram(strcmp(hypnogram, 'SLEEP-REM')) = {4};
hypnogram(strcmp(hypnogram, 'SLEEP-MT')) = {-1};
% cell 2 mat
hypnogram = cell2mat(hypnogram);

%% Sleep Stages IntervalSet
stage_ind = -1:4;
for ss = stage_ind
    start_substage = find(hypnogram==ss);
    intv = intervalSet((start_substage-1)*stage_epoch_duration,start_substage*stage_epoch_duration);
    if ss==0 %Wake
        StageEpochs{5} = mergeCloseIntervals(intv, 10);
    elseif ss==-1 %Noise
        StageEpochs{6} = mergeCloseIntervals(intv, 10);
    else
        StageEpochs{ss} = mergeCloseIntervals(intv, 10);
    end
end