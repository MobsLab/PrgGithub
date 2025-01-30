function Results = ReconstructPosition(session,units,channel,varargin)

%ReconstructPosition - Bayesian reconstruction of the animal's position
%
%
%
%
%








% USAGE
%
%   output = ReconstructPosition(session,units,varargin)
%
%   session
%   units
%   channel
%
%    =========================================================================
%     Properties    Values
%    -------------------------------------------------------------------------
%     'division'   phase or time (default = 'phase')
%     'phi'        length of the phase window - phase division (default = pi/3) 
%     'k'          number of iterations per cycle - phase division (default = 6) 
%     'tho'        length of the time window (default = 0.020s)
%     'pixel'       (default = 250/768)      
%     'nBins'       (default = 250) 
%     'minv'        (default = 5)   
%     'show'       plot reconstruction          
%    =========================================================================
%
%   OUTPUT
%
%
%

%output=[];
% Defaults
division = 'phase';
phi = pi/3;
k = 6;
tho = 0.020;
pixel = 250/768;
nBins = 200;
minv = 5;
show = 'on';

% Check number of parameters
if nargin <2  || mod(length(varargin),2) ~= 0,
  error('Incorrect number of parameters (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
end

% Check parameter sizes
for i = 1:2:length(varargin),
	if ~ischar(varargin{i}),
		error(['Parameter ' num2str(i+2) ' is not a property (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).']);
	end
	switch(lower(varargin{i})),
        case 'division',
			division = varargin{i+1};
            if ~isstring(division,'time','phase'),
				error('Incorrect value for property ''division'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
        case 'tho',
			tho = varargin{i+1};
            if ~isscalar(tho),
				error('Incorrect value for property ''tho'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
        case 'phi',
			phi = varargin{i+1};
            if ~isscalar(phi),
				error('Incorrect value for property ''phi'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
        case 'k',
			k = varargin{i+1};
            if ~isinteger(k)||(k<1),
				error('Incorrect value for property ''k'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
		case 'show',
			show = varargin{i+1};
            if ~isstring(show,'on','off'),
				error('Incorrect value for property ''show'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end  
        case 'pixel',
			pixel = varargin{i+1};
            if ~isscalar(pixel),
				error('Incorrect value for property ''pixel'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
        case 'nBins',
			nBins = varargin{i+1};
            if ~isinteger(nBins),
				error('Incorrect value for property ''nBins'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
            end
        case 'minv',
			minv = varargin{i+1};
			if ~isscalar(minv),
				error('Incorrect value for property ''minv'' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).');
			end    
		otherwise,
			error(['Unknown property ''' num2str(varargin{i}) ''' (type ''help <a href="matlab:help ReconstructPosition">ReconstructPosition</a>'' for details).']);
	end
end

SetCurrentSession(session);

conditions = {'PseudoActiveForward','PseudoActiveBackward','PseudoActiveForward','PseudoActiveBackward','Active'};
repeat = [1 1 2 2 1];

%Number of units
nUnit = size(units,1);

% Get linearized positions (discard immobile periods)
positions = GetPositions('coordinates','video','pixel',pixel);
x = GetPositions('coordinates','real','pixel',pixel);
v = LinearVelocity(x,30);
[periods,in] = Threshold(v,'>',minv,'min',10,'max',1);
positions = positions(in,:);
xFull = LinearizeTrainTrack(positions);

% Get all Spikes 
spikesFull = GetSpikes(units,'output','full');

Results = {};

% Loop through conditions
for j = 1:length(conditions),
    
    % Get session start/stop times
	e = GetEvents(['.*' conditions{j}]);
	n = GetEvents(['.*' conditions{j}],'output','descriptions'); % Subsession order
	n = regexp(n,['.*[0-9]{4}-([0-9]{2}.*)[.-]' conditions{j}],'tokens');
    
    
	% Test e if there is a repeat of condition (ex = two 'PseudoActiveBackward' conditions in the same session)
    if repeat(j) == 1,
		% First recording of this condition
		if length(e) >= 2,
			e = e([1 2])';
			n = n{1}{1}{1};
		else
			% This was not recorded at all (store dummy variables and skip)
			%DBInsertDummyVariables(id,name,j);
			%DBInsertDummyFigures(name);
			continue;
		end
	else
		% Second recording of this condition
		if length(e) == 4,
			e = e([3 4])';
			n = n{3}{1}{1};
		else
			% This was recorded only once (store dummy variables and skip)
			%DBInsertDummyVariables(id,name,j);
			%DBInsertDummyFigures(name);
			continue;
		end
    end
    
    %Name

    % Restrict
    x = Restrict(xFull,e);
	spikes = Restrict(spikesFull,e);
    
    %conditions to use or not use a neuron

    %Occupation P(x)
    map = Map(x,spikes(:,1),'nbins',nBins,'smooth',5);
    occupancy = map.time;
    occupancy = occupancy ./ sum(occupancy);

    % Firing Curve of each units (can become an external function)
    curves = [];
    for i=1:size(units,1),

        spk = GetSpikes(units(i,:));
        spk = Restrict(spk,e);
        %if size(spk,1)==0,continue;end
        
        [curve,unused] = FiringCurve(x,spk,'nbins',nBins,'smooth',5,'type','cl','minpeak',5);
        cur = [units(i,:) curve.rate];
        curves = [curves;cur];

    end

    %Reconstruction --------------------------------------------------------
    
    %Time intervals on which the position is reconstructed
    
    start  = e(1,1);
    finish = e(1,2);
    intervals = [];
    
    if strcmp(division,'phase'),
        
        % Do we need to compute phases or can we restore them from a previous run?
        fil = Recall('fil',channel);
        if isempty(fil);
            lfp = GetLFP(channel);
            fil = FilterLFP(lfp,'passband','theta');
            Store(fil,'fil',channel);
        end
        [unused,unused2,unwrapped] = Phase(fil);
        
        % Restrict
        phase = Restrict(unwrapped,e);
        signal = Restrict(fil,e);

        %Delete the periods before the first postion timestamp and after the last one, and then delete the period before the first peak
        etape = j
        signal(signal(:,1)<x(1,1),:)=[];
        tim = SineWavePeaks(signal(1:400,:));
        phase(phase(:,1)<tim(1),:)=[];
        phase(phase(:,1)>x(size(x,1),1),:)=[];
        
        %Get the time intervals corresponding to the phase division
        intervals = phaseIntervals(phase,phi);
        
    else % strcmp(division,'time')
        T = start;
        while T < finish,
            if T + tho < finish,
                intervals = [intervals;T];
            else
                intervals = [intervals;finish];
            end
            T = T + tho;                
        end
    end

    it = 1; 
    estimation = [];
    while it < size(intervals,1),
    
        % Interval Dt on which we compute each probability        
        Dt = [intervals(it) intervals(it+1)];
        
        %Restrict and check if there is spikes
        Tspike = Restrict(spikes,Dt);
        if isempty(Tspike),
            ProbXN = ones(1,nBins)/nBins;          
            estimation = [estimation ProbXN'];  % Store the results in a matrix position x time                      
            it = it + 1;    %iterations
            continue;
        end
          
        %Get the firing vector
        Tspike = Tspike(:,2:3);
        [unic,unused,ind] = unique(Tspike,'rows');
        
        Nfiring =[];
        for k = 1:size(unic,1),
            Nfiring = [Nfiring;[unic(k,:) sum(ind==k)]];
        end
        
        
        % Bayesian -------------------------
    
        % Compute P(n|x)
        ProbNX = []; % P(n|x) for each bin
        for bin = 1:nBins, %for each x (bin)
            probni = []; %list of P(ni|x)
            for c = 1:size(Nfiring,1);%for each cells firing during Dt
                
                ni = Nfiring(c,3);%number of spike of the cell during Dt
                fi = curves(curves(:,1)==Nfiring(c,1)&curves(:,2)==Nfiring(c,2),3:size(curves,2)); %firing curve for cell c
                
                % P(ni|x)
                prob = tho * fi(bin);
                prob = (prob^ni)/factorial(ni);
                prob = prob *exp(-tho*fi(bin));
            
                probni = [probni prob];
            end
            ProbNX = [ProbNX prod(probni)];
        end
        
        % Compute P(n)
        Pn = sum(occupancy.*ProbNX);  
        
        % Compute P(x|n)
        ProbXN = ProbNX .* occupancy;
        ProbXN = ProbXN ./ Pn;        
        %          -------------------------
        
        
        % Store the results in a matrix position x time
        estimation = [estimation ProbXN'];
        
        %iterations
        it = it + 1;
        
    end
    %-------------------------------
    
%     fig = figure; hold on;
%     plot(meanErrorReconstruction(estimation,intervals,x,6,nBins));

    
    %Center the estimation matrix
    x = Interpolate(x,intervals); 
    x(1,:) = [];% the matrix and vector dimensions must fit
%     pos = ceil( x(:,2) * nBins);
%     estimationCent = CenterMat(estimation,pos);
    
%     %average
%     n = floor(size(estimationCent,2)/k)*k; 
%     estim = reshape(estimationCent(:,1:n),nBins,k,[]);
%     estim = mean(estim,3);
    
    Results{j,1} = estimation ;
    Results{j,2} = x ;
    Results{j,3} = intervals ;
    
end

function DBInsertDummyVariables(id,name,i)

	DBInsertVariable([id i nan nan nan nan],'Variables',name,'','',{'ReconstructPosition'});


function DBInsertDummyFigures(name)

fig = figure;
DBInsertFigure(fig,'Reconstruction',name,'','',{'ReconstructPosition'});
close(fig);


function intervals = phaseIntervals(phases,phi)

% Delete the phases before the first peak of the signal

phases = [phases(:,2) phases(:,1)];
phStart = phases(1,1);
phFinish = phases(size(phases,1),1);

%Create list of phases regurlaly spaced between start and end.
th = phStart;
ph = [];
while th < phFinish,
    
    if th + phi < phFinish,
        ph = [ph th];
    else
        ph = [ph phFinish];
    end
    th = th + phi; 
end

intervals = Interpolate(phases,ph');
intervals = intervals(:,2);

function output=meanErrorReconstruction(estimation,intervals,positions,k,nBins)

% k = 6 (default) , is the number of time Bins par cycle theta


% Create a 3D matrix
% it is a the list of the estimation matrix on each theta cycle
matrice = [];
it = 1;
while it<size(estimation,2),
    
    if it + (k-1) <= size(estimation,2),
        estimCycle= [];
        for j = it:it+5,
            estimCycle = [estimCycle estimation(:,j)];
        end
        
        matrice = cat(3,matrice,estimCycle);
    end
    it = it + k;
end

nCycles = size(matrice,3);

% TODO : linéariser l'estimation de la position
[unused,posEstimated] = max(matrice,[],1);
posEstimated = posEstimated ./nBins;

distance = [];
for c = 1:nCycles,
    dCycle = [];
    for j = 1:k,
        pos = Interpolate(positions,intervals((c-1)*k + j + 1));
        
        if isempty(pos),
            d = 0;
        else
            d = posEstimated(:,j,c) - pos(:,2);
        end
        
        dCycle = [dCycle d];
    end
    
    if sum(dCycle)~=0,
        distance = [distance;dCycle];
    end
end

output = mean(distance,1);


function output = CenterMat(matrix,vector)


% Center each column of matrix around the index given by vector
% This function allows to centre the estimation matrix around the real
% position bin, for each time bins.

% matrix to center (estimation)
% vector = list of index (pos)

% condition :
%
%   size(vector) = size(matrix,2)
%   isint(vector)
%   vector is in (1:size(matrix,1))


%number of bin, center bin, number of columns
nBins = size(matrix,1);
center = round(nBins/2);
N = size(matrix,2);

%Shift matrix
vect = vector - center;
shift = repmat(vect',nBins,1);

%Initial index matrix
matIndex = 1:nBins;
matIndex = repmat(matIndex',1,N);

%New Index
matIndex = matIndex + shift;
matIndex = mod(matIndex,nBins);
matIndex(matIndex==0)=nBins;
matIndex = matIndex + repmat((0:N-1) .*nBins,nBins,1);

% Unwrapped index
unwrap = matIndex(:);

%unwrap matrix and change index
m = matrix(:);
m = m(unwrap);

%reshape
output = reshape(m,nBins,N);














