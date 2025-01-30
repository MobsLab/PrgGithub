%%DetectionMetrics_KJ
% 30.07.2019 KJ
%
% function [precision, recall, fscore] = DetectionMetrics_KJ(Epoch1, Epoch2, varargin)
%
% INPUT:
% - event1                  ts - events to deal with
% - event2                  ts - events to deal with
%
% - margin (optional)       = in ms - margin to look around the events
%                           (default [0 0])
%
% OUTPUT:
% - precision      
% - recall
% - fscore
%
%


function [precision, recall, fscore] = DetectionMetrics_KJ(EpochTrue, EpochDetect, varargin)

%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch (lower(varargin{i}))
        case 'margin'
            margin = varargin{i+1};

        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('margin','var')
    margin = [0 0];
end

center_true = (Start(EpochTrue) + End(EpochTrue))/2;
larger_detect_epochs = [Start(EpochDetect)+margin(1), End(EpochDetect)+margin(2)];
[status, ~, ~] = InIntervals(center_true, larger_detect_epochs);
% count
both12      = sum(status);
true_only   = length(center_true) - both12;
detect_only = length(Start(EpochDetect)) - both12;

%recall, precision, fscore
recall      = both12 / (both12 + true_only);
precision   = both12 / (both12 + detect_only);
fscore      = 2*recall*precision / (recall+precision);

    
end


