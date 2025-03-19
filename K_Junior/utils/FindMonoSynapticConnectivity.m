%FindMonoSynapticConnectivity
%16.01.2018 KJ
%
% [MatConnectivity,ConnectivityStrength] = FindMonoSynapticConnectivity(S);
% Find putative monosynaptic connectivity between neurons
%
%
%% INPUT:
%   S                           cellArray of tsd: each cell is of ts spike times for one neuron
%
%   window (optional)           double(2) (default [1.5 4])
%                               the time in ms in which we're searching for a monosynaptic connection
%   excit_lim (optional)        double (default 4)   
%                               be more demanding for excitation
%   inhib_lim (optional)        double (default 1.5)
%                               
%   binsize (optional)          double (default 0.5ms)
%                               size of the bin in ms for cross-correlogram 
%
%
%% OUTPUT:
% - MatConnectivity             Array of -1 / 0 / 1
% - ConnectivityStrength        Array
%
%
% USER EXAMPLE 
%       [MatConnectivity,ConnectivityStrength] = FindMonoSynapticConnectivity(S, 'window', [1 5]);
%       [MatConnectivity,ConnectivityStrength] = FindMonoSynapticConnectivity(S);
% 
% See 
%   MonoSynapticConnectivity
%
%


function [MatConnectivity, ConnectivityStrength] = FindMonoSynapticConnectivity(S,TT,varargin)


%% Initiation

if nargin < 1 || mod(length(varargin),2) ~= 0
  error('Incorrect number of parameters.');
end

% Parse parameter list
for i = 1:2:length(varargin)
    if ~ischar(varargin{i})
        error(['Parameter ' num2str(i+2) ' is not a property.']);
    end
    switch(lower(varargin{i}))
        case 'window'
            window = varargin{i+1};
            if isivector(window,'#2','>0')
                error('Incorrect value for property ''window''.');
            end
        case 'excit_lim'
            excit_lim = varargin{i+1};
            if ~isfloat(excit_lim) || excit_lim <=0
                error('Incorrect value for property ''excit_lim''.');
            end
        case 'inhib_lim'
            inhib_lim = varargin{i+1};
            if ~isfloat(inhib_lim) || inhib_lim <=0
                error('Incorrect value for property ''inhib_lim''.');
            end
        case 'binsize'
            binsize = varargin{i+1};
            if ~isfloat(binsize) || binsize <=0
                error('Incorrect value for property ''binsize''.');
            end
        otherwise
            error(['Unknown property ''' num2str(varargin{i}) '''.']);
    end
end

if ~exist('window', 'var')
    window = [1 4];
end
if ~exist('excit_lim', 'var')
    excit_lim = 4;
end
if ~exist('inhib_lim', 'var')
    inhib_lim = 1.5;
end
if ~exist('binsize', 'var')
    binsize = 0.2;
end

%for parfor loop
window_1 = window(1);
window_2 = window(2);


%% loop over pair of spikes
spike_pairs = nchoosek(1:length(S),2);
x = spike_pairs(:,1);
y = spike_pairs(:,2);
MatConnectivity1 = zeros(length(spike_pairs),1);
MatConnectivity2 = zeros(length(spike_pairs),1);
ConnectivityStrength1 = nan(length(spike_pairs),1);
ConnectivityStrength2 = nan(length(spike_pairs),1);

sametetrodes = zeros(size(spike_pairs,1),1);
for p=1:size(spike_pairs,1)
    if TT{spike_pairs(p,1)}(1)==TT{spike_pairs(p,2)}(1)
        sametetrodes(p) = 1;
    end
end

%remove MUA cell
ismua = zeros(size(spike_pairs,1),1);
for p=1:size(spike_pairs,1)
    if TT{spike_pairs(p,1)}(1)==1 || TT{spike_pairs(p,2)}(1)==1
        ismua(p)=1;
    end
end


%parfor loop
tic
parfor p=1:size(spike_pairs,1)
    if ismua(p)==0
        sp1 = x(p);
        sp2 = y(p);
        same_tetrode=sametetrodes(p);

        % Only look into probably isgnificant neurons
        [H0,t_corr] = CrossCorr(Range(S{sp1}),Range(S{sp2}),binsize,80/binsize);

        %first thresholds for pre-selection
        excit_thresh1 = mean(H0([1:find(t_corr<-10,1,'last'),find(t_corr>10,1,'first'):end])) + excit_lim * std(H0([1:find(t_corr<-10,1,'last'),find(t_corr>10,1,'first'):end])); %excitation thesh
        inhib_thresh1 = max([0,mean(H0([1:find(t_corr<-10,1,'last'),find(t_corr>10,1,'first'):end])) - inhib_lim * std(H0([1:find(t_corr<-10,1,'last'),find(t_corr>10,1,'first'):end]))]); %inhibition thesh

        h_after = H0(t_corr>=window_1 & t_corr<=window_2); % time after 0
        h_before = H0(t_corr>=-window_2 & t_corr<=-window_1); % time before 0
        h = [h_after h_before];

        if any(sum(h>excit_thresh1)>0 | sum(h<inhib_thresh1)>0) % If they're promising
            %jitter for confidence intervals
            [H0,Hm,HeI,HeS,Hstd,t_corr,HMaxMin] = XcJitter_KJ(Range(S{sp1}),Range(S{sp2}),binsize,80/binsize,0.99,'jitter',100); 
            %find connectivity
            [SynC,ConStr] = XcConnection_KJ(H0,Hm,HeI,HeS,Hstd,t_corr,HMaxMin,'same_tetrode',same_tetrode);
            %plot if connectivity
            if abs(SynC(1))==1 || abs(SynC(2))==1
                figure,
                disp('sig'),
                bar(t_corr,H0),
                hold on,
                plot(t_corr,HeI,'g','linewidth',2),
                plot(t_corr,HeS,'g','linewidth',2),
                plot(t_corr,t_corr*0+HMaxMin(1,1),'r','linewidth',2),
                plot(t_corr,t_corr*0+HMaxMin(2,1),'r','linewidth',2),
                plot(t_corr,t_corr*0+HMaxMin(1,2),'b','linewidth',2),
                plot(t_corr,t_corr*0+HMaxMin(2,2),'b','linewidth',2),
                disp(SynC)
            end

            MatConnectivity1(p) = SynC(1);
            MatConnectivity2(p) = SynC(2);
            ConnectivityStrength1(p) = ConStr(1);
            ConnectivityStrength2(p) = ConStr(2);
        end
        
    end
end


%assign data
MatConnectivity = nan(length(S));
ConnectivityStrength = nan(length(S));
for p=1:size(spike_pairs,1)
    sp1 = x(p);
    sp2 = y(p);
    MatConnectivity(sp1,sp2) = MatConnectivity1(p);
    MatConnectivity(sp2,sp1) = MatConnectivity2(p);
    ConnectivityStrength(sp1,sp2) = ConnectivityStrength1(p);
    ConnectivityStrength(sp2,sp1) = ConnectivityStrength2(p);
end

toc

end




