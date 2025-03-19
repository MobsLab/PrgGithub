%%CohenKappaSleepStaging
% 11.04.2019 KJ
%
% compute the cohen's kappa for a sleep staging result
%
% function cohen_kappa = CohenKappaSleepStaging(confusion_matrix, varargin)
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
%       CohenKappaSleepScoring
%


function cohen_kappa = CohenKappaSleepStaging(confusion_matrix, varargin)


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
Overall = sum(sum(CM,1),2);

%agreement
Pagree = trace(CM) / Overall;

% chance agreement
Pchance = sum(CM,1).*sum(CM,2)' / Overall.^2;


% Kappa
cohen_kappa = (Pagree - Pchance) / (1 - Pchance);



end



