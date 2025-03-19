%%BalancedAccuracySleepStaging
% 11.04.2019 KJ
%
% compute the balanced accuracy for a sleep staging result
%
% function bacc = CohenKappaSleepStaging(confusion_matrix, varargin)
%
% INPUT:
% - confusion_matrix    confusion matrix (see classperf CountMatrix), must be diagonal
%                           
%
%

%
%
% OUTPUT:
% - cohen_kappa     = cohen's kappa 
%
%
%   see 
%       
%


function baccuracy = BalancedAccuracySleepStaging(confusion_matrix, varargin)


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

CM = confusion_matrix;

% balanced accuracy
baccuracy = mean(diag(CM) ./ sum(CM,1)');



end

