function SetCurrentSessionScanFrequency(filename)

load behavResources tpsEvt

[filename,path] = uigetfile('*.xml','Please select a parameter file for; this session');


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


%---------------------------------------------------------------------------------------------
% Event files 00
%---------------------------------------------------------------------------------------------
DATA.events00.time = [];
DATA.events00.description = {};

eventFiles00 = dir([path sepMark '*ScanFreqency-wideband.e00.evt']);

if ~isempty(eventFiles00),
    for i = 1:length(eventFiles00),
        events = LoadEvents([path sepMark eventFiles00(i).name]);
        if isempty(events.time), continue; end
        DATA.events00.time = [DATA.events00.time ; events.time];
        DATA.events00.description = {DATA.events00.description{:} events.description{:}}';
        disp(['... loaded event file ''' eventFiles00(i).name '''']);
        durationSessionEvt00(i)=length(DATA.events00.time);
    end
else
    disp('... (no event file found)');
end
Events00=DATA.events00.time;
% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles00)
    if i==1
        Evt00{i}=Events00(1:durationSessionEvt00(i));
    elseif i>1
        Evt00{i}=Events00(durationSessionEvt00(i-1)+1:durationSessionEvt00(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=2:length(eventFiles00)
    val=cell2mat(tpsEvt(i+1));
    Evt00{i}=Evt00{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt00)
    if i==1
        Event00(1:length(Evt00{i}),1)=Evt00{i};
    elseif i>1
        Event00(length(Event00)+1:(length(Event00)+length(Evt00{i})),1)=Evt00{i};
    end
end
%---------------------------------------------------------------------------------------------
% Event files 01
%---------------------------------------------------------------------------------------------
DATA.events01.time = [];
DATA.events01.description = {};
eventFiles01 = dir([path sepMark '*ScanFreqency-wideband.e01.evt']);
if ~isempty(eventFiles01),
    for i = 1:length(eventFiles01),
        events = LoadEvents([path sepMark eventFiles01(i).name]);
        if isempty(events.time), continue; end
        DATA.events01.time = [DATA.events01.time ; events.time];
        DATA.events01.description = {DATA.events01.description{:} events.description{:}}';
        durationSessionEvt01(i)=length(DATA.events01.time);
        disp(['... loaded event file ''' eventFiles01(i).name '''']);
    end
else
    disp('... (no event file found)');
end
Events01=DATA.events01.time;

% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles01)
    if i==1
        Evt01{i}=Events01(1:durationSessionEvt01(i));
    elseif i>1
        Evt01{i}=Events01(durationSessionEvt01(i-1)+1:durationSessionEvt01(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=1:length(eventFiles01)
    val=cell2mat(tpsEvt(NbSession(i)+1));
    Evt01{i}=Evt01{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt01)
    if i==1
        Event01(1:length(Evt01{i}),1)=Evt01{i};
    elseif i>1
        Event01(length(Event01)+1:(length(Event01)+length(Evt01{i})),1)=Evt01{i};
    end
end
%---------------------------------------------------------------------------------------------
% Event files 02
%---------------------------------------------------------------------------------------------
DATA.events02.time = [];
DATA.events02.description = {};
eventFiles02 = dir([path sepMark '*ScanFreqency-wideband.e02.evt']);
if ~isempty(eventFiles02),
    for i = 1:length(eventFiles02),
        events = LoadEvents([path sepMark eventFiles02(i).name]);
        if isempty(events.time), continue; end
        DATA.events02.time = [DATA.events02.time ; events.time];
        DATA.events02.description = {DATA.events02.description{:} events.description{:}}';
        durationSessionEvt02(i)=length(DATA.events02.time);
        disp(['... loaded event file ''' eventFiles02(i).name '''']);
    end
else
    disp('... (no event file found)');
end
Events02=DATA.events02.time;

% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles02)
    if i==1
        Evt02{i}=Events02(1:durationSessionEvt02(i));
    elseif i>1
        Evt02{i}=Events02(durationSessionEvt02(i-1)+1:durationSessionEvt02(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=1:length(eventFiles02)
    val=cell2mat(tpsEvt(NbSession(i)+1));
    Evt02{i}=Evt02{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt02)
    if i==1
        Event02(1:length(Evt02{i}),1)=Evt02{i};
    elseif i>1
        Event02(length(Event02)+1:(length(Event02)+length(Evt02{i})),1)=Evt02{i};
    end
end

%---------------------------------------------------------------------------------------------
% Event files 03
%---------------------------------------------------------------------------------------------
DATA.events03.time = [];
DATA.events03.description = {};
eventFiles03 = dir([path sepMark '*ScanFreqency-wideband.e03.evt']);
if ~isempty(eventFiles03),
    for i = 1:length(eventFiles03),
        events = LoadEvents([path sepMark eventFiles03(i).name]);
        if isempty(events.time), continue; end
        DATA.events03.time = [DATA.events03.time ; events.time];
        DATA.events03.description = {DATA.events03.description{:} events.description{:}}';
        durationSessionEvt03(i)=length(DATA.events03.time);
        disp(['... loaded event file ''' eventFiles03(i).name '''']);
    end
else
    disp('... (no event file found)');
end
Events03=DATA.events03.time;

% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles03)
    if i==1
        Evt03{i}=Events03(1:durationSessionEvt03(i));
    elseif i>1
        Evt03{i}=Events03(durationSessionEvt03(i-1)+1:durationSessionEvt03(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=1:length(eventFiles03)
    val=cell2mat(tpsEvt(NbSession(i)+1));
    Evt03{i}=Evt03{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt03)
    if i==1
        Event03(1:length(Evt03{i}),1)=Evt03{i};
    elseif i>1
        Event03(length(Event03)+1:(length(Event03)+length(Evt03{i})),1)=Evt03{i};
    end
end
%---------------------------------------------------------------------------------------------
% Event files 04
%---------------------------------------------------------------------------------------------
DATA.events04.time = [];
DATA.events04.description = {};
eventFiles04 = dir([path sepMark '*ScanFreqency-wideband.e04.evt']);
if ~isempty(eventFiles04),
    for i = 1:length(eventFiles04),
        events = LoadEvents([path sepMark eventFiles04(i).name]);
        if isempty(events.time), continue; end
        DATA.events04.time = [DATA.events04.time ; events.time];
        DATA.events04.description = {DATA.events04.description{:} events.description{:}}';
        durationSessionEvt04(i)=length(DATA.events04.time);
        disp(['... loaded event file ''' eventFiles04(i).name '''']);
    end
else
    disp('... (no event file found)');
end
Events04=DATA.events04.time;

% 1/ separation en cellules individuelles par fichiers d'acquisition
for i=1:length(eventFiles04)
    if i==1
        Evt04{i}=Events04(1:durationSessionEvt04(i));
    elseif i>1
        Evt04{i}=Events04(durationSessionEvt04(i-1)+1:durationSessionEvt04(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=1:length(eventFiles04)
    val=cell2mat(tpsEvt(NbSession(i)+1));
    Evt04{i}=Evt04{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt04)
    if i==1
        Event04(1:length(Evt04{i}),1)=Evt04{i};
    elseif i>1
        Event04(length(Event04)+1:(length(Event04)+length(Evt04{i})),1)=Evt04{i};
    end
end
%---------------------------------------------------------------------------------------------
% Event files 05
%---------------------------------------------------------------------------------------------
DATA.events05.time = [];05
DATA.events05.description = {};
eventFiles05 = dir([path sepMark '*ScanFreqency-wideband.e05.evt']);
if ~isempty(eventFiles05),
    for i = 1:length(eventFiles05),
        events = LoadEvents([path sepMark eventFiles05(i).name]);
        if isempty(events.time), continue; end
        DATA.events05.time = [DATA.events05.time ; events.time];
        DATA.events05.description = {DATA.events05.description{:} events.description{:}}';
        durationSessionEvt05(i)=length(DATA.events05.time);
        disp(['... loaded event file ''' eventFiles05(i).name '''']);
    end
else
    disp('... (no event file found)');
end
Events05=DATA.events05.time;

for i=1:length(eventFiles05)
    if i==1
        Evt05{i}=Events05(1:durationSessionEvt05(i));
    elseif i>1
        Evt05{i}=Events05(durationSessionEvt05(i-1)+1:durationSessionEvt05(i));
    end
end

% 2/ ajout du temps correspondant (fin du fichier précedent)
NbSession=input('what number of session concerned? ');
for i=1:length(eventFiles05)
    val=cell2mat(tpsEvt(NbSession(i)+1));
    Evt05{i}=Evt05{i}+val;
    i=i+1;
end

% 3/ reformation d'une matrice unique
for i=1:length(Evt05)
    if i==1
        Event05(1:length(Evt05{i}),1)=Evt05{i};
    elseif i>1
        Event05(length(Event05)+1:(length(Event05)+length(Evt05{i})),1)=Evt05{i};
    end
end

%--------------------------------------------------------------------------
save behavResources -append Event00 Event01 Event02 Event03 Event04 Event05
%--------------------------------------------------------------------------


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