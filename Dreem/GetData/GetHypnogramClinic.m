function [Hypnograms, scorer, ref_score] = GetHypnogramClinic(filereference)
%   [hypnograms, scorer, ref_score] = GetHypnograms(filereference)
%
% INPUT:
% - filereference       Reference of the record
%
%
% OUTPUT:
% - hypnograms:         cell array - contain hypnograms (1, 2 or 3)
% - scorer:             {'livio','dreem','dreem','pascal'}
% - ref_score:          {'livio','livio','pascal','pascal'}
%
%
% INFO
%   livio is synchronized on EEG data from h5 files
%
%       see 
%           GetRecordClinic
%


%% CHECK INPUTS

if nargin < 1,
  error('Incorrect number of parameters.');
end


if ~exist('stage_epoch_duration','var')
    stage_epoch_duration = 30E4;
end

scorer = {'dreem','livio','dreem','pascal'};
ref_score = {'livio','livio','pascal','pascal'};


%% load
filename = [FolderClinicHypnogram num2str(filereference) '.h5'];

hypno = cell(0);
if exist(filename, 'file') == 2
    for i=1:length(scorer)
        try
            hypno{i} = double(h5read(filename,['/' ref_score{i} '_' scorer{i} '/']));
        end
    end
else
    disp(['File ' filename ' does not exist'])
end


%% Format data
stage_ind = 0:4;

if ~isempty(hypno)
    for i=1:length(scorer)
        clear StageEpochs
        for ss = stage_ind
            start_substage = find(hypno{i}==ss);
            intv = intervalSet((start_substage-1)*stage_epoch_duration,start_substage*stage_epoch_duration);
            if ss==0 %Wake
                StageEpochs{5} = mergeCloseIntervals(intv, 10);
            else
                StageEpochs{ss} = mergeCloseIntervals(intv, 10);
            end
        end
        Hypnograms{i} = StageEpochs;
    end
else
    Hypnograms = cell(0);
    scorer = cell(0);
    ref_score = cell(0);
end


end













