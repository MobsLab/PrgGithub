function SetCurrentSessionAttentional2(filename)

load behavResources

global DATA;

res=pwd;
if res(3)=='\' ||res(1)=='\'
    windob=1;
else
    windob=0;
end

if windob
    sepMark='\';
else
    sepMark='/';
end


% Initialization
if isempty(DATA),
	format long g;
	DATA.session.basename = '';
	DATA.session.path = '';
	DATA.positions = [];
	DATA.spikes = [];
	DATA.events = [];
	% Default settings
	Settings;
end

if nargin == 0 || (strcmp(filename,'same') && isempty(DATA.session.basename)),
	% Interactive mode
	[filename,path] = uigetfile('*.xml','Please select a parameter file for; this session');
	if filename == 0,return; end
    if windob ==0
        filename = [path filename];
    end
end

if strcmp(filename,'same'),
	% Force reload
	path = DATA.session.path;
	basename = DATA.session.basename;
else
	% Parse file name
	while filename(end) == sepMark, filename(end) = []; end
	[path,basename] = fileparts(filename);
	if isempty(path)|path(1)~=sepMark, path = [pwd sepMark path]; end
	path = strrep(path,[sepMark '.' sepMark],sepMark); %'/./','/'); [sepMark '.' sepMark],sepMark
end

disp(['Loading session files for ' basename]);

% File already loaded?
try
    DATA.session.basename;
catch
    ProblemSetCurrentsession;
end
if strcmp(basename,DATA.session.basename) & strcmp(path,DATA.session.path) & ~strcmp(filename,'same'),
    disp(['... session files already loaded, skipping - type SetCurrentSession(''same'') to force reload']);
    disp('Done');
    return
end


% Parameter file
DATA = LoadParameters([path sepMark basename '.xml']);
disp(['... loaded parameter file ''' basename '.xml''']);

% Event file(s) : channel 17
DATA.events17.time = [];
DATA.events17.description = {};

eventFiles17 = dir([path sepMark '*.e17.evt']);

if ~isempty(eventFiles17),
	for i = 1:length(eventFiles17),
		events = LoadEvents([path sepMark eventFiles17(i).name]);
		if isempty(events.time), continue; end
		DATA.events17.time = [DATA.events17.time ; events.time];
		DATA.events17.description = {DATA.events17.description{:} events.description{:}}';
		disp(['... loaded event file ''' eventFiles17(i).name '''']);
        durationSessionEvt17(i)=length(DATA.events17.time);
	end
else
	disp('... (no event file found)');
end
Events17=DATA.events17.time;

% Event file(s) : channel 21
DATA.events21.time = [];
DATA.events21.description = {};
eventFiles21 = dir([path sepMark '*.e21.evt']);
if ~isempty(eventFiles21),
	for i = 1:length(eventFiles21),
		events = LoadEvents([path sepMark eventFiles21(i).name]);
		if isempty(events.time), continue; end
		DATA.events21.time = [DATA.events21.time ; events.time];
		DATA.events21.description = {DATA.events21.description{:} events.description{:}}';
        durationSessionEvt21(i)=length(DATA.events21.time);
		disp(['... loaded event file ''' eventFiles21(i).name '''']);
	end
else
	disp('... (no event file found)');
end
Events21=DATA.events21.time;


%-------------------------------------------------------------------------
%--------------------  time compensation of evt  -------------------------
%-------------------------------------------------------------------------
% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles17)
    if i==1
            Evt17{i}=Events17(1:durationSessionEvt17(i));
    elseif i>1
            Evt17{i}=Events17(durationSessionEvt17(i-1)+1:durationSessionEvt17(i));
    end
end
for i=1:length(eventFiles21)
    if i==1
            Evt21{i}=Events21(1:durationSessionEvt21(i));
    elseif i>1
            Evt21{i}=Events21(durationSessionEvt21(i-1)+1:durationSessionEvt21(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)

for i=2:length(eventFiles17)
    val=cell2mat(tpsEvt(i+1));
        Evt17{i}=Evt17{i}+val;
    i=i+1;
end
for i=1:length(eventFiles21)
    val=cell2mat(tpsEvt(i+1));
        Evt21{i}=Evt21{i}+val;
    i=i+1;
end
               
               
% 3/ reformation d'une matrice unique
try
    clear Event17 Event21
end
try
    for i=1:length(Evt17)
        if i==1
            Event17(1:length(Evt17{i}),1)=Evt17{i};
        elseif i>1
            Event17(length(Event17)+1:(length(Event17)+length(Evt17{i})),1)=Evt17{i};
        end
    end
end

try
    for i=1:length(Evt21)
        if i==1
            Event21(1:length(Evt21{i}),1)=Evt21{i};
        elseif i>1
            Event21(length(Event21)+1:(length(Event21)+length(Evt21{i})),1)=Evt21{i};
        end
    end
end

%------------------------------------    
save behavResources -append Event17 Event21


%-------------------------------------------------------------------------
%------------------------  Positions files  ------------------------------
%-------------------------------------------------------------------------
try
            DATA.positions = [];
            if exist([path '/' basename '.pos']),
                DATA.positions = LoadPositions([path sepMark basename '.pos'],DATA.rates.video);
                disp(['... loaded positions file ''' basename '.pos''']);
            elseif exist([path '/' basename '.whl']),
                DATA.positions = LoadPositions([path sepMark basename '.whl'],DATA.rates.video);
                disp(['... loaded positions file ''' basename '.whl''']);
            elseif exist([path '/' basename '.whl']),
                DATA.positions = LoadPositions([path sepMark basename '.mqa'],DATA.rates.video);
                disp(['... loaded positions file ''' basename '.mqa''']);
            else
                disp('... (no positions file found)');
            end
end

%-------------------------------------------------------------------------
%----------------------------  Spike files  ------------------------------
%-------------------------------------------------------------------------

DATA.spikes = [];
for i = 1:DATA.spikeGroups.nGroups,
	filename = [path '/' basename '.' int2str(i) '.clu'];
	if exist(filename,'file'),
		try
			DATA.spikes = [DATA.spikes;LoadSpikeTimes(filename,DATA.rates.wideband)];
			disp(['... loaded spike files ''' basename '.' int2str(i) '.clu''']);
		catch
			disp(['... (could not load spike files ''' basename '.' int2str(i) '.clu'')']);
		end
	else
		filename = [path sepMark basename '.clu.' int2str(i)];
		if exist(filename,'file'),
			try
				DATA.spikes = [DATA.spikes;LoadSpikeTimes(filename,DATA.rates.wideband)];
				disp(['... loaded spike files ''' basename '.clu.' int2str(i) '''']);
			catch
				disp(['... (could not load spike files ''' basename '.clu.' int2str(i) ''')']);
			end
		end
	end
end
if isempty(DATA.spikes),
	disp('... (no spike files found)');
end

% This is updated only once the files have been properly loaded
DATA.session.basename = basename;
DATA.session.path = path;

disp('Done');