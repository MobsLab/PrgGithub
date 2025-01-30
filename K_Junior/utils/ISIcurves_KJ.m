%%ISIcurves_KJ
% 10.07.2019 KJ
%
% function [x_isi, y_isi] = ISIcurves_KJ(events, edges)
%
% INPUT:
% - events                      ts - events to deal with
% - edges                       vector - edges for ISI histograms (e.g 0:10:500, for bins of 10 ms between 0 and 500ms)
%                           
% - normalization (optional)    = normalization for histograms (e.g 'count', 'countdensity', 'probability', 'pdf' ..)  
%                               (default 'count')
%

% OUTPUT:
% - x_isi           = abscissa of ISI curves
% - y_isi           = values of ISI curves
%
%
%       see MakeIDSleepData2 
%


function [x_isi, y_isi] = ISIcurves_KJ(events, edges, varargin)

%% CHECK INPUTS

if nargin < 2 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch (lower(varargin{i}))
        case 'normalization'
            normalization = varargin{i+1};
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

%check if exist and assign default value if not
if ~exist('normalization','var')
    normalization = 'count';
end


%% ISI
intervals = diff(Range(events)/10); %in ms
[y_isi, x_isi] = histcounts(intervals, edges,'Normalization',normalization);
x_isi = x_isi(1:end-1) + diff(x_isi);


end


