function AO = DIRACPhasePlaceCells(A)
  
  

A= getResource(A, 'PosPhi');
phi = phi{1};
  
A = getResource(A, 'ThetaNorm');
thetaNorm = thetaNorm{1};


A = getResource(A, 'HippoCellList');
A = getResource(A, 'HippoSpikeData');

[A, runsUp] = getResource(A, 'RunsUp');
runsUp = runsUp{1};

[A, runsDown] = getResource(A, 'RunsDown');
runsDown = runsDown{1};  
  
%%%%%%%%%%%%%

% register resources


A = registerResource(A, 'SpikePosUp', 'tsdArray', {'HippoCellList', 1}, ...
    'spikePosUp', ...
    ['tsd containing times of spike and positions of rat on track for each spike', ...
    'during upbound journeys']);

A = registerResource(A, 'SpikePosDown', 'tsdArray', {'HippoCellList', 1}, ...
    'spikePosDown', ...
    ['tsd containing times of spike and positions of rat on track for each spike', ...
    'during downbound journeys']);

A = registerResource(A, 'SpikePhaseUp', 'tsdArray', {'HippoCellList', 1}, ...
    'spikePhaseUp', ...
    ['tsd containing times of spike and theta phase for each spike', ...
    'during upbound journeys, first column is phase, next column is cycle number']);

A = registerResource(A, 'SpikePhaseDown', 'tsdArray', {'HippoCellList', 1}, ...
    'spikePhaseDown', ...
    ['tsd containing times of spike and theta phase for each spike', ...
    'during downbound journeys,  first column is phase, next column is cycle number']);



% A = registerResource(A, 'SpikePosUpByLap', 'cell', {'HippoCellList', 1}, ...
%     'spikePosUpByLap', ...
%     ['tsd containing times of spike and positions of rat on track for each spike', ...
%     'lap by lap during upbound journeys']);
% 
% A = registerResource(A, 'SpikePosDownByLap', 'cell', {'HippoCellList', 1}, ...
%     'spikePosDownByLap', ...
%     ['tsd containing times of spike and positions of rat on track for each spike', ...
%     'lap by lap during downbound journeys']);
% 
% A = registerResource(A, 'SpikePhaseUpByLap', 'cell', {'HippoCellList', 1}, ...
%     'spikePhaseUpByLap', ...
%     ['tsd containing times of spike and theta phase for each spike lap by lap', ...
%     'during upbound journeys, first column is phase, next column is cycle number']);
% 
% A = registerResource(A, 'SpikePhaseDownByLap', 'cell', {'HippoCellList', 1}, ...
%     'spikePhaseDownByLap', ...
%     ['tsd containing times of spike and theta phase for each spike lap by lap', ...
%     'during downbound journeys,  first column is phase, next column is cycle number']);


display('1');

spikePosUp = {};
spikePosDown = {};

for i = 1:length(S)
    SUp{i} = Restrict(S{i}, runsUp);
    SDown{i} = Restrict(S{i}, runsDown);
    spikePosUp{i} = Restrict(phi, SUp{i}, 'time', 'align');
    spikePosDown{i} = Restrict(phi, SDown{i}, 'time', 'align');
end

display('2');

spikePosUp = tsdArray(spikePosUp');
spikePosDown = tsdArray(spikePosDown');

spikePhaseUp = ThetaPhase(SUp, thetaNorm, 0, 1e20);
spikePhaseDown = ThetaPhase(SDown, thetaNorm, 0, 1e20);

display('2.5');

% spikePosUpByLap = {};
% spikePosDownByLap = {};
% spikePhaseUpByLap = {};
% spikePhaseDownByLap = {};
% 
% for i = 1:length(S)
%     display(i);
%     spikePosUpByLap{i} = intervalSplit(spikePosUp{i}, runsUp);
%     spikePosDownByLap{i} = intervalSplit(spikePosDown{i}, runsDown);
%     spikePhaseUpByLap{i} = intervalSplit(spikePhaseUp{i}, runsUp);
%     spikePhaseDownByLap{i} = intervalSplit(spikePhaseDown{i}, runsDown);
% end
% 
% spikePosUpByLap = spikePosUpByLap';
% spikePosDownByLap = spikePosDownByLap';
% spikePhaseUpByLap = spikePhaseUpByLap';
% spikePhaseDownByLap = spikePhaseDownByLap';

display('3');

pdir = pwd;

indir = ['/home/fpbatta/Data/DIRAC/' current_dataset(A)];
cd(indir);

fname = List2Cell('thetaCR.txt');
fname = fname{1};

thetaEEG = [];

try
eval(['! bunzip2 ' fname '.bz2']);
thetaEEG = ReadCR_tsd(fname);
eval(['! bzip2 ' fname ]);
except
;
end


cd(pdir);

outdir = ['/home/fpbatta/Data/Mate/' current_dataset(A)];

mkdir(outdir)
cd (outdir)
%%%%%%%%%
    %save PhasePrecMeas  phi spikePosUpByLap spikePosDownByLap spikePhaseUpByLap spikePhaseDownByLap spikePosUp spikePosDown spikePhaseUp spikePhaseDown
    save PhasePrecMeas  phi  spikePosUp spikePosDown spikePhaseUp spikePhaseDown
    save thetaEEG thetaEEG
  


cd(pdir)








%%%%%%%%%%%%%%%%%%%%%
  A =  saveAllResources(A);

  AO = A;
  
  
  