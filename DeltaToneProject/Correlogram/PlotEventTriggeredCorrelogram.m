% PlotEventTriggeredCorrelogram - Plot correlations of a group of event-triggered signals
%
%%  USAGE
% [corr_matrix, event_triggered_matrix]=PlotEventTriggeredCorrelogram(signal, events, durations, <options>)
%
%% INPUT
%
%    signal         tsd 
%                   (e.g LFP, MUA...)
%    events         ts
%                   list of events to trigger the signal on.  
%    durations      durations before and after synchronizing events for each
%                   event (in ms)
%    <options>      optional list of property-value pairs (see table below)
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'smooth'      smoothing parameters (eg [])
%                   (default = [0 0])
%     'pmax'        maximum p-value: put the correlation to 0 where 
%                   the p-value exceed pmax (default = 1)
%    =========================================================================
%
%% OUTPUT
%
%    corr_matrix                correlation matrix
%    event_triggered_matrix     all the signals extracted
%   
%
%% SEE
%    PlotRipRaw, SyncMap
%
% 16.09.2016 KJ   
%


function [corr_matrix, event_triggered_matrix] = PlotEventTriggeredCorrelogram(signal, events, durations, varargin)

%% CHECK INPUTS

% Check number of parameters
if nargin < 3 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).');
end

% Check parameter sizes
if ~isdvector(durations,'#2')
	error('Parameter ''durations'' is not a vector of 2 elements (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).');
end

%% Parse parameter list
for i = 1:2:length(varargin)
	if ~ischar(varargin{i})
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).']);
	end
	switch(lower(varargin{i}))
		case 'smooth'
			smooth_param = varargin{i+1};
			if ~isdvector(smooth_param,'#2')
				error('Incorrect value for property ''smooth'' (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).');
			end
		case 'pmax'
			pmax = varargin{i+1};
			if ~isscalar(pmax) || pmax<0,
				error('Incorrect value for property ''pmax'' (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).');
			end
        otherwise
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help PlotEventTriggeredCorrelogram">PlotEventTriggeredCorrelogram</a>'' for details).']);
	end
end

% Default values
if ~exist('smooth_param','var')
    smooth_param = [0 0];
end
if ~exist('pmax','var')
    pmax = 1;
end


%% Extract piece of signals triggered on events
samplingRate = round(1/median(diff(Range(signal,'s'))));
durations = durations/1000;
nBins = floor(samplingRate*diff(durations)/2)*2+1;
rg=Range(signal,'s');
samples = [rg-rg(1) Data(signal)];
[r,i] = Sync(samples, Range(events)/1E4, 'durations', durations);
T = SyncMap(r, i, 'durations', durations, 'nbins', nBins, 'smooth', 0);  % matrix of all signals sync on events

if size(T,2)>nBins
    nBins=nBins+1;
elseif size(T,2)<nBins
    nBins=nBins-1;
end

M = [((1:nBins)'-ceil(nBins/2))/nBins*diff(durations)' mean(T)' std(T)' stdError(T)'];  % mean signal


%% correlation matrix
[r,p] = corrcoef(T);
corr_matrix = r - diag(diag(r));  % remove the diagonal terms
significant_matrix = corr_matrix;
significant_matrix(p>pmax) = 0;  % keep only significant correlations
smoothed_matrix = SmoothDec(significant_matrix, smooth_param);

%results
event_triggered_matrix = T;

%% plot
figure('units','normalized','outerposition',[0 0 1 1]);
correlAx = axes('position', [0.1 0.05 0.7 0.65]);
signalAxUp = axes('position', [0.1 0.75 0.7 0.15]);
signalAxRight = axes('position', [0.85 0.05 0.1 0.65]);

axes(correlAx);
imagesc(M(:,1), M(:,1), smoothed_matrix), 
axis xy, caxis([-0.3 0.3]), hold on

axes(signalAxUp);
hold on, plot(M(:,1), M(:,2),'k','linewidth',2),
xlabel('time(s)')

axes(signalAxRight);
hold on, plot(M(:,2), M(:,1), 'k','linewidth',2),
ylabel('time(s)')
    
    
end







