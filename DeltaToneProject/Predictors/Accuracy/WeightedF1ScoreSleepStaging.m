%%WeightedF1ScoreSleepStaging
% 16.04.2019 KJ
%
% compute the weighted f1-score for a sleep staging result
%
% function fscore = WeightedF1ScoreSleepStaging(confusion_matrix, varargin)
%
% INPUT:
% - confusion_matrix    confusion matrix (see classperf CountMatrix), must be diagonal
%                           
%
%

%
%
% OUTPUT:
% - fscore     = weigthed f1 score
%
%
%   see 
%       CohenKappaSleepScoring
%


function fscore = WeightedF1ScoreSleepStaging(confusion_matrix, varargin)


%% CHECK INPUTS

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% % Parse parameter list
% for i = 1:2:length(varargin)
%     if ~ischar(varargin{i})
%         error(['Parameter ' num2str(i+2) ' is not a property.']);
%     end
%     switch(lower(varargin{i}))
% 
%         otherwise
%             error(['Unknown property ''' num2str(varargin{i}) '''.']);
%     end
% end


for i=1:5
    precision = confusion_matrix(i,i) / sum(confusion_matrix(i,:));
    recall = confusion_matrix(i,i) / sum(confusion_matrix(:,i));
    f1score(i) = 2 * precision * recall / (precision + recall);
end

% weigths
weights = sum(confusion_matrix,1);
weights = weights / sum(weights);

% result
fscore = sum(f1score .* weights);



end


