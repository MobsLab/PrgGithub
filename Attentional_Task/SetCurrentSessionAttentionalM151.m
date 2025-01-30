%SetCurrentSessionAttentional - Load all data for a given recording session.
%
% Set current session files and read data from disk. Calling SetCurrentSession
% without parameters will display a file selection dialog.
%
%  USAGE
%
%    SetCurrentSession(filename)
%
%    filename            optional parameter file name; use 'same' to force reload
%
%  NOTE
%
%    If no parameter file name is specified, an interactive file selection
%    dialog is displayed.

% Copyright (C) 2004-2010 by Michaël Zugaro (modified for the Attentional protocol


function SetCurrentSessionAttentional(filename)

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
%  	if isempty(findstr(filename,'/')),
%  		filename = [pwd '/' filename];
%  	end
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

% Event file(s) : channel 03
DATA.events17.time = [];
DATA.events17.description = {};

eventFiles17 = dir([path sepMark '*.e03.evt']);

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


% Event file(s) : channel 05
DATA.events18.time = [];
DATA.events18.description = {};
eventFiles18 = dir([path sepMark '*.e05.evt']);
if ~isempty(eventFiles18),
	for i = 1:length(eventFiles18),
		events = LoadEvents([path sepMark eventFiles18(i).name]);
		if isempty(events.time), continue; end
		DATA.events18.time = [DATA.events18.time ; events.time];
		DATA.events18.description = {DATA.events18.description{:} events.description{:}}';
        durationSessionEvt18(i)=length(DATA.events18.time);
		disp(['... loaded event file ''' eventFiles18(i).name '''']);
	end
else
	disp('... (no event file found)');
end
Events18=DATA.events18.time;

% Event file(s) : channel 22
DATA.events19.time = [];
DATA.events19.description = {};
eventFiles19 = dir([path sepMark '*.e22.evt']);
if ~isempty(eventFiles19),
	for i = 1:length(eventFiles19),
		events = LoadEvents([path sepMark eventFiles19(i).name]);
		if isempty(events.time), continue; end
		DATA.events19.time = [DATA.events19.time ; events.time];
		DATA.events19.description = {DATA.events19.description{:} events.description{:}}';
        durationSessionEvt19(i)=length(DATA.events19.time);
		disp(['... loaded event file ''' eventFiles19(i).name '''']);
	end
else
	disp('... (no event file found)');
end
Events19=DATA.events19.time;

% Event file(s) : channel 34
DATA.events20.time = [];
DATA.events20.description = {};
eventFiles20 = dir([path sepMark '*.e34.evt']);
if ~isempty(eventFiles20),
	for i = 1:length(eventFiles20),
		events = LoadEvents([path sepMark eventFiles20(i).name]);
		if isempty(events.time), continue; end
		DATA.events20.time = [DATA.events20.time ; events.time];
		DATA.events20.description = {DATA.events20.description{:} events.description{:}}';
        durationSessionEvt20(i)=length(DATA.events20.time);
		disp(['... loaded event file ''' eventFiles20(i).name '''']);
	end
else
	disp('... (no event file found)');
end
Events20=DATA.events20.time;


%-------------------------------------------------------------------------
%--------------------  time compensation of evt  -------------------------
%-------------------------------------------------------------------------
% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles17)
    if i==1
        try
            Evt17{i}=Events17(1:durationSessionEvt17(i));
        end
        try
            Evt18{i}=Events18(1:durationSessionEvt18(i));
        end
        try
            Evt19{i}=Events19(1:durationSessionEvt19(i));
        end
        try
            Evt20{i}=Events20(1:durationSessionEvt20(i));
        end
        try
            Evt21{i}=Events21(1:durationSessionEvt21(i));
        end
    elseif i>1
        try
            Evt17{i}=Events17(durationSessionEvt17(i-1)+1:durationSessionEvt17(i));
        end
        try
            Evt18{i}=Events18(durationSessionEvt18(i-1)+1:durationSessionEvt18(i));
        end
        try
            Evt19{i}=Events19(durationSessionEvt19(i-1)+1:durationSessionEvt19(i));
        end
        try
            Evt20{i}=Events20(durationSessionEvt20(i-1)+1:durationSessionEvt20(i));
        end
        try
            Evt21{i}=Events21(durationSessionEvt21(i-1)+1:durationSessionEvt21(i));
        end
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
i=1;
for k=3:length(tpsEvt)-((length(tpsEvt)-2)/2)
        val=cell2mat(tpsEvt(k));
        try
            Evt17{i}=Evt17{i}+val;
        end
        try
            Evt18{i}=Evt18{i}+val;
        end
        try
            Evt19{i}=Evt19{i}+val;
        end
        try
            Evt20{i}=Evt20{i}+val;
        end
        try
            Evt21{i}=Evt21{i}+val;
        end
        i=i+1;
end

% 3/ reformation d'une matrice unique
try
    clear Event17 Event18 Event19 Event20 Event20
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
    for i=1:length(Evt18)
        if i==1
            Event18(1:length(Evt18{i}),1)=Evt18{i};
        elseif i>1
            Event18(length(Event18)+1:(length(Event18)+length(Evt18{i})),1)=Evt18{i};
        end
    end
end
try
    for i=1:length(Evt19)
        if i==1
            Event19(1:length(Evt19{i}),1)=Evt19{i};
        elseif i>1
            Event19(length(Event19)+1:(length(Event19)+length(Evt19{i})),1)=Evt19{i};
        end
    end
end
try
    for i=1:length(Evt20)
        if i==1
            Event20(1:length(Evt20{i}),1)=Evt20{i};
        elseif i>1
            Event20(length(Event20)+1:(length(Event20)+length(Evt20{i})),1)=Evt20{i};
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
% 3/ Assignation d'une valeur unique pour la composante globale 
%          standard=1 / deviant=2 / habituation=0
try
    if durationSessionEvt18(1)<27
        Event18(1:durationSessionEvt18(1),2)=2; % global deviant
    elseif durationSessionEvt18(1)>27
        Event18(1:20,2)=0;    % global habituation
        Event18(21:durationSessionEvt18(1),2)=1;   % global standard
    end
    
    for i=1:(length(durationSessionEvt18)-1)
        if durationSessionEvt18(i+1)-durationSessionEvt18(i)<27
            Event18(durationSessionEvt18(i)+1:durationSessionEvt18(i+1),2)=2;    % global deviant
        elseif durationSessionEvt18(i+1)-durationSessionEvt18(i)>27
            Event18(durationSessionEvt18(i)+1:durationSessionEvt18(i)+21,2)=0;   % global habituation
            Event18(durationSessionEvt18(i)+22:durationSessionEvt18(i+1),2)=1;   % global standard
        end
    end
end
%-------
try
    if durationSessionEvt19(1)<27
        Event19(1:durationSessionEvt19(1),2)=2; % global deviant
    elseif durationSessionEvt19(1)>27
        Event19(1:20,2)=0;    % global habituation
        Event19(21:durationSessionEvt19(1),2)=1;   % global standard
    end
    
    for i=1:(length(durationSessionEvt19)-1)
        if durationSessionEvt19(i+1)-durationSessionEvt19(i)<27
            Event19(durationSessionEvt19(i)+1:durationSessionEvt19(i+1),2)=2;    % global deviant
        elseif durationSessionEvt19(i+1)-durationSessionEvt19(i)>27
            Event19(durationSessionEvt19(i)+1:durationSessionEvt19(i)+21,2)=0;   % global habituation
            Event19(durationSessionEvt19(i)+22:durationSessionEvt19(i+1),2)=1;   % global standard
        end
    end
end
%-------
try
    if durationSessionEvt20(1)<15
        Event20(1:durationSessionEvt20(1),2)=2; % global deviant
    elseif durationSessionEvt20(1)>15
        Event20(1:durationSessionEvt20(1),2)=0;   % global habituation
    end
    
    for i=1:(length(durationSessionEvt20)-1)
        if durationSessionEvt20(i+1)-durationSessionEvt20(i)<15
            Event20(durationSessionEvt20(i)+1:durationSessionEvt20(i+1),2)=2;    % global deviant
        elseif durationSessionEvt20(i+1)-durationSessionEvt20(i)>15
            Event20(durationSessionEvt20(i)+1:durationSessionEvt20(i+1),2)=0;   % global habituation
        end
    end
end
%------------------------------------    
try
    save behavResources -append Event17 Event18 Event19 Event20 
catch
    save behavResources -append Event17 
end
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