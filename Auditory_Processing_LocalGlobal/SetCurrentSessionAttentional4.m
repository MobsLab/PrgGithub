function SetCurrentSessionAttentional4(filename)

[filename,path] = uigetfile('*.xml','Please select a parameter file for; this session');

load behavResources tpsEvt

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



protocole=input('does it was a classical AAAAB paradigm (press 1) or a new ABABA paradigm (press 2) ? ');
if protocole ==1
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Standard A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLstdGstd.time = [];
    DATA.eventsLstdGstd.description = {};
    eventsLstdGstd = dir([path sepMark '*BlocAAAAA-wideband.e01.evt']);
    if ~isempty(eventsLstdGstd),
        for i = 1:length(eventsLstdGstd),
            events = LoadEvents([path sepMark eventsLstdGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGstd.time = [DATA.eventsLstdGstd.time ; events.time];
            DATA.eventsLstdGstd.description = {DATA.eventsLstdGstd.description{:} events.description{:}}';
            durationSessionEvtLstdGstd(i)=length(DATA.eventsLstdGstd.time);
            disp(['... loaded event file ''' eventsLstdGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGstd=DATA.eventsLstdGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGstd)
        if i==1
            EvtLstdGstd{i}=LstdGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLstdGstd{i}=LstdGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGstd{i}=EvtLstdGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGstd)
        if i==1
            Event_LstdGstd(1:length(EvtLstdGstd{i}),1)=EvtLstdGstd{i};
        elseif i>1
            Event_LstdGstd(length(Event_LstdGstd)+1:(length(Event_LstdGstd)+length(EvtLstdGstd{i})),1)=EvtLstdGstd{i};
        end
    end
    
    Event_LstdGstd_A=Event_LstdGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Standard B
    %---------------------------------------------------------------------------------------------
    clear Event_LstdGstd;
    
    DATA.eventsLstdGstd.time = [];
    DATA.eventsLstdGstd.description = {};
    eventsLstdGstd = dir([path sepMark '*BlocBBBBB-wideband.e01.evt']);
    if ~isempty(eventsLstdGstd),
        for i = 1:length(eventsLstdGstd),
            events = LoadEvents([path sepMark eventsLstdGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGstd.time = [DATA.eventsLstdGstd.time ; events.time];
            DATA.eventsLstdGstd.description = {DATA.eventsLstdGstd.description{:} events.description{:}}';
            durationSessionEvtLstdGstd(i)=length(DATA.eventsLstdGstd.time);
            disp(['... loaded event file ''' eventsLstdGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGstd=DATA.eventsLstdGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGstd)
        if i==1
            EvtLstdGstd{i}=LstdGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLstdGstd{i}=LstdGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGstd{i}=EvtLstdGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGstd)
        if i==1
            Event_LstdGstd(1:length(EvtLstdGstd{i}),1)=EvtLstdGstd{i};
        elseif i>1
            Event_LstdGstd(length(Event_LstdGstd)+1:(length(Event_LstdGstd)+length(EvtLstdGstd{i})),1)=EvtLstdGstd{i};
        end
    end
    
    Event_LstdGstd_B=Event_LstdGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Deviant  Global Deviant A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLdvtGdvt.time = [];
    DATA.eventsLdvtGdvt.description = {};
    eventsLdvtGdvt = dir([path sepMark '*BlocAAAAA-wideband.e02.evt']);
    if ~isempty(eventsLdvtGdvt),
        for i = 1:length(eventsLdvtGdvt),
            events = LoadEvents([path sepMark eventsLdvtGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGdvt.time = [DATA.eventsLdvtGdvt.time ; events.time];
            DATA.eventsLdvtGdvt.description = {DATA.eventsLdvtGdvt.description{:} events.description{:}}';
            durationSessionEvtLdvtGdvt(i)=length(DATA.eventsLdvtGdvt.time);
            disp(['... loaded event file ''' eventsLdvtGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGdvt=DATA.eventsLdvtGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGdvt)
        if i==1
            EvtLdvtGdvt{i}=LdvtGdvt(1:durationSessionEvtLdvtGdvt(i));
        elseif i>1
            EvtLdvtGdvt{i}=LdvtGdvt(durationSessionEvtLdvtGdvt(i-1)+1:durationSessionEvtLdvtGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGdvt{i}=EvtLdvtGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGdvt)
        if i==1
            Event_LdvtGdvt(1:length(EvtLdvtGdvt{i}),1)=EvtLdvtGdvt{i};
        elseif i>1
            Event_LdvtGdvt(length(Event_LdvtGdvt)+1:(length(Event_LdvtGdvt)+length(EvtLdvtGdvt{i})),1)=EvtLdvtGdvt{i};
        end
    end
    
    Event_LdvtGdvt_A=Event_LdvtGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Deviant  Global Deviant B
    %---------------------------------------------------------------------------------------------
    clear Event_LdvtGdvt
    
    DATA.eventsLdvtGdvt.time = [];
    DATA.eventsLdvtGdvt.description = {};
    eventsLdvtGdvt = dir([path sepMark '*BlocBBBBB-wideband.e02.evt']);
    if ~isempty(eventsLdvtGdvt),
        for i = 1:length(eventsLdvtGdvt),
            events = LoadEvents([path sepMark eventsLdvtGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGdvt.time = [DATA.eventsLdvtGdvt.time ; events.time];
            DATA.eventsLdvtGdvt.description = {DATA.eventsLdvtGdvt.description{:} events.description{:}}';
            durationSessionEvtLdvtGdvt(i)=length(DATA.eventsLdvtGdvt.time);
            disp(['... loaded event file ''' eventsLdvtGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGdvt=DATA.eventsLdvtGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGdvt)
        if i==1
            EvtLdvtGdvt{i}=LdvtGdvt(1:durationSessionEvtLdvtGdvt(i));
        elseif i>1
            EvtLdvtGdvt{i}=LdvtGdvt(durationSessionEvtLdvtGdvt(i-1)+1:durationSessionEvtLdvtGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGdvt{i}=EvtLdvtGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGdvt)
        if i==1
            Event_LdvtGdvt(1:length(EvtLdvtGdvt{i}),1)=EvtLdvtGdvt{i};
        elseif i>1
            Event_LdvtGdvt(length(Event_LdvtGdvt)+1:(length(Event_LdvtGdvt)+length(EvtLdvtGdvt{i})),1)=EvtLdvtGdvt{i};
        end
    end
    
    Event_LdvtGdvt_B=Event_LdvtGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Deviant A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLstdGdvt.time = [];
    DATA.eventsLstdGdvt.description = {};
    eventsLstdGdvt = dir([path sepMark '*BlocAAAAB-wideband.e01.evt']);
    if ~isempty(eventsLstdGdvt),
        for i = 1:length(eventsLstdGdvt),
            events = LoadEvents([path sepMark eventsLstdGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGdvt.time = [DATA.eventsLstdGdvt.time ; events.time];
            DATA.eventsLstdGdvt.description = {DATA.eventsLstdGdvt.description{:} events.description{:}}';
            durationSessionEvtLstdGdvt(i)=length(DATA.eventsLstdGdvt.time);
            disp(['... loaded event file ''' eventsLstdGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGdvt=DATA.eventsLstdGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGdvt)
        if i==1
            EvtLstdGdvt{i}=LstdGdvt(1:durationSessionEvtLstdGdvt(i));
        elseif i>1
            EvtLstdGdvt{i}=LstdGdvt(durationSessionEvtLstdGdvt(i-1)+1:durationSessionEvtLstdGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGdvt{i}=EvtLstdGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGdvt)
        if i==1
            Event_LstdGdvt(1:length(EvtLstdGdvt{i}),1)=EvtLstdGdvt{i};
        elseif i>1
            Event_LstdGdvt(length(Event_LstdGdvt)+1:(length(Event_LstdGdvt)+length(EvtLstdGdvt{i})),1)=EvtLstdGdvt{i};
        end
    end
    
    Event_LstdGdvt_A=Event_LstdGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Deviant B
    %---------------------------------------------------------------------------------------------
    clear Event_LstdGdvt
    
    DATA.eventsLstdGdvt.time = [];
    DATA.eventsLstdGdvt.description = {};
    eventsLstdGdvt = dir([path sepMark '*BlocBBBBA-wideband.e01.evt']);
    if ~isempty(eventsLstdGdvt),
        for i = 1:length(eventsLstdGdvt),
            events = LoadEvents([path sepMark eventsLstdGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGdvt.time = [DATA.eventsLstdGdvt.time ; events.time];
            DATA.eventsLstdGdvt.description = {DATA.eventsLstdGdvt.description{:} events.description{:}}';
            durationSessionEvtLstdGdvt(i)=length(DATA.eventsLstdGdvt.time);
            disp(['... loaded event file ''' eventsLstdGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGdvt=DATA.eventsLstdGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGdvt)
        if i==1
            EvtLstdGdvt{i}=LstdGdvt(1:durationSessionEvtLstdGdvt(i));
        elseif i>1
            EvtLstdGdvt{i}=LstdGdvt(durationSessionEvtLstdGdvt(i-1)+1:durationSessionEvtLstdGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGdvt{i}=EvtLstdGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGdvt)
        if i==1
            Event_LstdGdvt(1:length(EvtLstdGdvt{i}),1)=EvtLstdGdvt{i};
        elseif i>1
            Event_LstdGdvt(length(Event_LstdGdvt)+1:(length(Event_LstdGdvt)+length(EvtLstdGdvt{i})),1)=EvtLstdGdvt{i};
        end
    end
    
    
    Event_LstdGdvt_B=Event_LstdGdvt*1E4;
    
    
    %---------------------------------------------------------------------------------------------
    %                             Local Deviant Global Standard A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLdvtGstd.time = [];
    DATA.eventsLdvtGstd.description = {};
    eventsLdvtGstd = dir([path sepMark '*BlocAAAAB-wideband.e02.evt']);
    if ~isempty(eventsLdvtGstd),
        for i = 1:length(eventsLdvtGstd),
            events = LoadEvents([path sepMark eventsLdvtGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGstd.time = [DATA.eventsLdvtGstd.time ; events.time];
            DATA.eventsLdvtGstd.description = {DATA.eventsLdvtGstd.description{:} events.description{:}}';
            durationSessionEvtLdvtGstd(i)=length(DATA.eventsLdvtGstd.time);
            disp(['... loaded event file ''' eventsLdvtGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGstd=DATA.eventsLdvtGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGstd)
        if i==1
            EvtLdvtGstd{i}=LdvtGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLdvtGstd{i}=LdvtGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGstd{i}=EvtLdvtGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGstd)
        if i==1
            Event_LdvtGstd(1:length(EvtLdvtGstd{i}),1)=EvtLdvtGstd{i};
        elseif i>1
            Event_LdvtGstd(length(Event_LdvtGstd)+1:(length(Event_LdvtGstd)+length(EvtLdvtGstd{i})),1)=EvtLdvtGstd{i};
        end
    end
    
    Event_LdvtGstd_A=Event_LdvtGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                             Local Deviant Global Standard B
    %---------------------------------------------------------------------------------------------
    clear Event_LdvtGstd
    
    DATA.eventsLdvtGstd.time = [];
    DATA.eventsLdvtGstd.description = {};
    eventsLdvtGstd = dir([path sepMark '*BlocBBBBA-wideband.e02.evt']);
    if ~isempty(eventsLdvtGstd),
        for i = 1:length(eventsLdvtGstd),
            events = LoadEvents([path sepMark eventsLdvtGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGstd.time = [DATA.eventsLdvtGstd.time ; events.time];
            DATA.eventsLdvtGstd.description = {DATA.eventsLdvtGstd.description{:} events.description{:}}';
            durationSessionEvtLdvtGstd(i)=length(DATA.eventsLdvtGstd.time);
            disp(['... loaded event file ''' eventsLdvtGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGstd=DATA.eventsLdvtGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGstd)
        if i==1
            EvtLdvtGstd{i}=LdvtGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLdvtGstd{i}=LdvtGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGstd{i}=EvtLdvtGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGstd)
        if i==1
            Event_LdvtGstd(1:length(EvtLdvtGstd{i}),1)=EvtLdvtGstd{i};
        elseif i>1
            Event_LdvtGstd(length(Event_LdvtGstd)+1:(length(Event_LdvtGstd)+length(EvtLdvtGstd{i})),1)=EvtLdvtGstd{i};
        end
    end
    
    Event_LdvtGstd_B=Event_LdvtGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Rare AAAA
    %---------------------------------------------------------------------------------------------
    DATA.eventsOmiRare.time = [];
    DATA.eventsOmiRare.description = {};
    eventsOmiRare = dir([path sepMark '*BlocAAAA*-wideband.e03.evt']);
    if ~isempty(eventsOmiRare),
        for i = 1:length(eventsOmiRare),
            events = LoadEvents([path sepMark eventsOmiRare(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiRare.time = [DATA.eventsOmiRare.time ; events.time];
            DATA.eventsOmiRare.description = {DATA.eventsOmiRare.description{:} events.description{:}}';
            durationSessionEvtOmiRare(i)=length(DATA.eventsOmiRare.time);
            disp(['... loaded event file ''' eventsOmiRare(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiRare=DATA.eventsOmiRare.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiRare)
        if i==1
            EvtOmiRare{i}=OmiRare(1:durationSessionEvtOmiRare(i));
        elseif i>1
            EvtOmiRare{i}=OmiRare(durationSessionEvtOmiRare(i-1)+1:durationSessionEvtOmiRare(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiRare)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiRare{i}=EvtOmiRare{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiRare)
        if i==1
            Event_OmiRare(1:length(EvtOmiRare{i}),1)=EvtOmiRare{i};
        elseif i>1
            Event_OmiRare(length(Event_OmiRare)+1:(length(Event_OmiRare)+length(EvtOmiRare{i})),1)=EvtOmiRare{i};
        end
    end
    
    Event_OmiRare_A=Event_OmiRare*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Rare BBBB
    %---------------------------------------------------------------------------------------------
    clear Event_OmiRare
    
    DATA.eventsOmiRare.time = [];
    DATA.eventsOmiRare.description = {};
    eventsOmiRare = dir([path sepMark '*BlocBBBB*-wideband.e03.evt']);
    if ~isempty(eventsOmiRare),
        for i = 1:length(eventsOmiRare),
            events = LoadEvents([path sepMark eventsOmiRare(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiRare.time = [DATA.eventsOmiRare.time ; events.time];
            DATA.eventsOmiRare.description = {DATA.eventsOmiRare.description{:} events.description{:}}';
            durationSessionEvtOmiRare(i)=length(DATA.eventsOmiRare.time);
            disp(['... loaded event file ''' eventsOmiRare(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiRare=DATA.eventsOmiRare.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiRare)
        if i==1
            EvtOmiRare{i}=OmiRare(1:durationSessionEvtOmiRare(i));
        elseif i>1
            EvtOmiRare{i}=OmiRare(durationSessionEvtOmiRare(i-1)+1:durationSessionEvtOmiRare(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiRare)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiRare{i}=EvtOmiRare{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiRare)
        if i==1
            Event_OmiRare(1:length(EvtOmiRare{i}),1)=EvtOmiRare{i};
        elseif i>1
            Event_OmiRare(length(Event_OmiRare)+1:(length(Event_OmiRare)+length(EvtOmiRare{i})),1)=EvtOmiRare{i};
        end
    end
    
    Event_OmiRare_B=Event_OmiRare*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Frequente AAAA
    %---------------------------------------------------------------------------------------------
    DATA.eventsOmiFreq.time = [];
    DATA.eventsOmiFreq.description = {};
    eventsOmiFreq = dir([path sepMark '*BlocOmiAAAA-wideband.e03.evt']);
    if ~isempty(eventsOmiFreq),
        for i = 1:length(eventsOmiFreq),
            events = LoadEvents([path sepMark eventsOmiFreq(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiFreq.time = [DATA.eventsOmiFreq.time ; events.time];
            DATA.eventsOmiFreq.description = {DATA.eventsOmiFreq.description{:} events.description{:}}';
            durationSessionEvtOmiFreq(i)=length(DATA.eventsOmiFreq.time);
            disp(['... loaded event file ''' eventsOmiFreq(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiFreq=DATA.eventsOmiFreq.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiFreq)
        if i==1
            EvtOmiFreq{i}=OmiFreq(1:durationSessionEvtOmiFreq(i));
        elseif i>1
            EvtOmiFreq{i}=OmiFreq(durationSessionEvtOmiFreq(i-1)+1:durationSessionEvtOmiFreq(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiFreq)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiFreq{i}=EvtOmiFreq{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiFreq)
        if i==1
            Event_OmiFreq(1:length(EvtOmiFreq{i}),1)=EvtOmiFreq{i};
        elseif i>1
            Event_OmiFreq(length(Event_OmiFreq)+1:(length(Event_OmiFreq)+length(EvtOmiFreq{i})),1)=EvtOmiFreq{i};
        end
    end
    
    Event_OmiFreq_A=Event_OmiFreq*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Frequente BBBB
    %---------------------------------------------------------------------------------------------
    clear Event_OmiFreq
    
    DATA.eventsOmiFreq.time = [];
    DATA.eventsOmiFreq.description = {};
    eventsOmiFreq = dir([path sepMark '*BlocOmiBBBB-wideband.e03.evt']);
    if ~isempty(eventsOmiFreq),
        for i = 1:length(eventsOmiFreq),
            events = LoadEvents([path sepMark eventsOmiFreq(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiFreq.time = [DATA.eventsOmiFreq.time ; events.time];
            DATA.eventsOmiFreq.description = {DATA.eventsOmiFreq.description{:} events.description{:}}';
            durationSessionEvtOmiFreq(i)=length(DATA.eventsOmiFreq.time);
            disp(['... loaded event file ''' eventsOmiFreq(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiFreq=DATA.eventsOmiFreq.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiFreq)
        if i==1
            EvtOmiFreq{i}=OmiFreq(1:durationSessionEvtOmiFreq(i));
        elseif i>1
            EvtOmiFreq{i}=OmiFreq(durationSessionEvtOmiFreq(i-1)+1:durationSessionEvtOmiFreq(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiFreq)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiFreq{i}=EvtOmiFreq{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiFreq)
        if i==1
            Event_OmiFreq(1:length(EvtOmiFreq{i}),1)=EvtOmiFreq{i};
        elseif i>1
            Event_OmiFreq(length(Event_OmiFreq)+1:(length(Event_OmiFreq)+length(EvtOmiFreq{i})),1)=EvtOmiFreq{i};
        end
    end
    
    Event_OmiFreq_B=Event_OmiFreq*1E4;
    
    
    
elseif protocole==2
    
    
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Standard A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLstdGstd.time = [];
    DATA.eventsLstdGstd.description = {};
    eventsLstdGstd = dir([path sepMark '*BlocABABA-wideband.e01.evt']);
    if ~isempty(eventsLstdGstd),
        for i = 1:length(eventsLstdGstd),
            events = LoadEvents([path sepMark eventsLstdGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGstd.time = [DATA.eventsLstdGstd.time ; events.time];
            DATA.eventsLstdGstd.description = {DATA.eventsLstdGstd.description{:} events.description{:}}';
            durationSessionEvtLstdGstd(i)=length(DATA.eventsLstdGstd.time);
            disp(['... loaded event file ''' eventsLstdGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGstd=DATA.eventsLstdGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGstd)
        if i==1
            EvtLstdGstd{i}=LstdGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLstdGstd{i}=LstdGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGstd{i}=EvtLstdGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGstd)
        if i==1
            Event_LstdGstd(1:length(EvtLstdGstd{i}),1)=EvtLstdGstd{i};
        elseif i>1
            Event_LstdGstd(length(Event_LstdGstd)+1:(length(Event_LstdGstd)+length(EvtLstdGstd{i})),1)=EvtLstdGstd{i};
        end
    end
    
    Event_LstdGstd_A=Event_LstdGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Standard B
    %---------------------------------------------------------------------------------------------
    clear Event_LstdGstd;
    
    DATA.eventsLstdGstd.time = [];
    DATA.eventsLstdGstd.description = {};
    eventsLstdGstd = dir([path sepMark '*BlocBABAB-wideband.e01.evt']);
    if ~isempty(eventsLstdGstd),
        for i = 1:length(eventsLstdGstd),
            events = LoadEvents([path sepMark eventsLstdGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGstd.time = [DATA.eventsLstdGstd.time ; events.time];
            DATA.eventsLstdGstd.description = {DATA.eventsLstdGstd.description{:} events.description{:}}';
            durationSessionEvtLstdGstd(i)=length(DATA.eventsLstdGstd.time);
            disp(['... loaded event file ''' eventsLstdGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGstd=DATA.eventsLstdGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGstd)
        if i==1
            EvtLstdGstd{i}=LstdGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLstdGstd{i}=LstdGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGstd{i}=EvtLstdGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGstd)
        if i==1
            Event_LstdGstd(1:length(EvtLstdGstd{i}),1)=EvtLstdGstd{i};
        elseif i>1
            Event_LstdGstd(length(Event_LstdGstd)+1:(length(Event_LstdGstd)+length(EvtLstdGstd{i})),1)=EvtLstdGstd{i};
        end
    end
    
    Event_LstdGstd_B=Event_LstdGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Deviant  Global Deviant A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLdvtGdvt.time = [];
    DATA.eventsLdvtGdvt.description = {};
    eventsLdvtGdvt = dir([path sepMark '*BlocABABA-wideband.e02.evt']);
    if ~isempty(eventsLdvtGdvt),
        for i = 1:length(eventsLdvtGdvt),
            events = LoadEvents([path sepMark eventsLdvtGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGdvt.time = [DATA.eventsLdvtGdvt.time ; events.time];
            DATA.eventsLdvtGdvt.description = {DATA.eventsLdvtGdvt.description{:} events.description{:}}';
            durationSessionEvtLdvtGdvt(i)=length(DATA.eventsLdvtGdvt.time);
            disp(['... loaded event file ''' eventsLdvtGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGdvt=DATA.eventsLdvtGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGdvt)
        if i==1
            EvtLdvtGdvt{i}=LdvtGdvt(1:durationSessionEvtLdvtGdvt(i));
        elseif i>1
            EvtLdvtGdvt{i}=LdvtGdvt(durationSessionEvtLdvtGdvt(i-1)+1:durationSessionEvtLdvtGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGdvt{i}=EvtLdvtGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGdvt)
        if i==1
            Event_LdvtGdvt(1:length(EvtLdvtGdvt{i}),1)=EvtLdvtGdvt{i};
        elseif i>1
            Event_LdvtGdvt(length(Event_LdvtGdvt)+1:(length(Event_LdvtGdvt)+length(EvtLdvtGdvt{i})),1)=EvtLdvtGdvt{i};
        end
    end
    
    Event_LdvtGdvt_A=Event_LdvtGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Deviant  Global Deviant B
    %---------------------------------------------------------------------------------------------
    clear Event_LdvtGdvt
    
    DATA.eventsLdvtGdvt.time = [];
    DATA.eventsLdvtGdvt.description = {};
    eventsLdvtGdvt = dir([path sepMark '*BlocBABAB-wideband.e02.evt']);
    if ~isempty(eventsLdvtGdvt),
        for i = 1:length(eventsLdvtGdvt),
            events = LoadEvents([path sepMark eventsLdvtGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGdvt.time = [DATA.eventsLdvtGdvt.time ; events.time];
            DATA.eventsLdvtGdvt.description = {DATA.eventsLdvtGdvt.description{:} events.description{:}}';
            durationSessionEvtLdvtGdvt(i)=length(DATA.eventsLdvtGdvt.time);
            disp(['... loaded event file ''' eventsLdvtGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGdvt=DATA.eventsLdvtGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGdvt)
        if i==1
            EvtLdvtGdvt{i}=LdvtGdvt(1:durationSessionEvtLdvtGdvt(i));
        elseif i>1
            EvtLdvtGdvt{i}=LdvtGdvt(durationSessionEvtLdvtGdvt(i-1)+1:durationSessionEvtLdvtGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGdvt{i}=EvtLdvtGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGdvt)
        if i==1
            Event_LdvtGdvt(1:length(EvtLdvtGdvt{i}),1)=EvtLdvtGdvt{i};
        elseif i>1
            Event_LdvtGdvt(length(Event_LdvtGdvt)+1:(length(Event_LdvtGdvt)+length(EvtLdvtGdvt{i})),1)=EvtLdvtGdvt{i};
        end
    end
    
    Event_LdvtGdvt_B=Event_LdvtGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Deviant A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLstdGdvt.time = [];
    DATA.eventsLstdGdvt.description = {};
    eventsLstdGdvt = dir([path sepMark '*BlocABABB-wideband.e01.evt']);
    if ~isempty(eventsLstdGdvt),
        for i = 1:length(eventsLstdGdvt),
            events = LoadEvents([path sepMark eventsLstdGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGdvt.time = [DATA.eventsLstdGdvt.time ; events.time];
            DATA.eventsLstdGdvt.description = {DATA.eventsLstdGdvt.description{:} events.description{:}}';
            durationSessionEvtLstdGdvt(i)=length(DATA.eventsLstdGdvt.time);
            disp(['... loaded event file ''' eventsLstdGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGdvt=DATA.eventsLstdGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGdvt)
        if i==1
            EvtLstdGdvt{i}=LstdGdvt(1:durationSessionEvtLstdGdvt(i));
        elseif i>1
            EvtLstdGdvt{i}=LstdGdvt(durationSessionEvtLstdGdvt(i-1)+1:durationSessionEvtLstdGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGdvt{i}=EvtLstdGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGdvt)
        if i==1
            Event_LstdGdvt(1:length(EvtLstdGdvt{i}),1)=EvtLstdGdvt{i};
        elseif i>1
            Event_LstdGdvt(length(Event_LstdGdvt)+1:(length(Event_LstdGdvt)+length(EvtLstdGdvt{i})),1)=EvtLstdGdvt{i};
        end
    end
    
    Event_LstdGdvt_A=Event_LstdGdvt*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                            Local Standard Global Deviant B
    %---------------------------------------------------------------------------------------------
    clear Event_LstdGdvt
    
    DATA.eventsLstdGdvt.time = [];
    DATA.eventsLstdGdvt.description = {};
    eventsLstdGdvt = dir([path sepMark '*BlocBABAA-wideband.e01.evt']);
    if ~isempty(eventsLstdGdvt),
        for i = 1:length(eventsLstdGdvt),
            events = LoadEvents([path sepMark eventsLstdGdvt(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLstdGdvt.time = [DATA.eventsLstdGdvt.time ; events.time];
            DATA.eventsLstdGdvt.description = {DATA.eventsLstdGdvt.description{:} events.description{:}}';
            durationSessionEvtLstdGdvt(i)=length(DATA.eventsLstdGdvt.time);
            disp(['... loaded event file ''' eventsLstdGdvt(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LstdGdvt=DATA.eventsLstdGdvt.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLstdGdvt)
        if i==1
            EvtLstdGdvt{i}=LstdGdvt(1:durationSessionEvtLstdGdvt(i));
        elseif i>1
            EvtLstdGdvt{i}=LstdGdvt(durationSessionEvtLstdGdvt(i-1)+1:durationSessionEvtLstdGdvt(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLstdGdvt)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLstdGdvt{i}=EvtLstdGdvt{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLstdGdvt)
        if i==1
            Event_LstdGdvt(1:length(EvtLstdGdvt{i}),1)=EvtLstdGdvt{i};
        elseif i>1
            Event_LstdGdvt(length(Event_LstdGdvt)+1:(length(Event_LstdGdvt)+length(EvtLstdGdvt{i})),1)=EvtLstdGdvt{i};
        end
    end
    
    Event_LstdGdvt_B=Event_LstdGdvt*1E4;
    
    
    %---------------------------------------------------------------------------------------------
    %                             Local Deviant Global Standard A
    %---------------------------------------------------------------------------------------------
    DATA.eventsLdvtGstd.time = [];
    DATA.eventsLdvtGstd.description = {};
    eventsLdvtGstd = dir([path sepMark '*BlocABABB-wideband.e02.evt']);
    if ~isempty(eventsLdvtGstd),
        for i = 1:length(eventsLdvtGstd),
            events = LoadEvents([path sepMark eventsLdvtGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGstd.time = [DATA.eventsLdvtGstd.time ; events.time];
            DATA.eventsLdvtGstd.description = {DATA.eventsLdvtGstd.description{:} events.description{:}}';
            durationSessionEvtLdvtGstd(i)=length(DATA.eventsLdvtGstd.time);
            disp(['... loaded event file ''' eventsLdvtGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGstd=DATA.eventsLdvtGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGstd)
        if i==1
            EvtLdvtGstd{i}=LdvtGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLdvtGstd{i}=LdvtGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGstd{i}=EvtLdvtGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGstd)
        if i==1
            Event_LdvtGstd(1:length(EvtLdvtGstd{i}),1)=EvtLdvtGstd{i};
        elseif i>1
            Event_LdvtGstd(length(Event_LdvtGstd)+1:(length(Event_LdvtGstd)+length(EvtLdvtGstd{i})),1)=EvtLdvtGstd{i};
        end
    end
    
    Event_LdvtGstd_A=Event_LdvtGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                             Local Deviant Global Standard B
    %---------------------------------------------------------------------------------------------
    clear Event_LdvtGstd
    
    DATA.eventsLdvtGstd.time = [];
    DATA.eventsLdvtGstd.description = {};
    eventsLdvtGstd = dir([path sepMark '*BlocBABAA-wideband.e02.evt']);
    if ~isempty(eventsLdvtGstd),
        for i = 1:length(eventsLdvtGstd),
            events = LoadEvents([path sepMark eventsLdvtGstd(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsLdvtGstd.time = [DATA.eventsLdvtGstd.time ; events.time];
            DATA.eventsLdvtGstd.description = {DATA.eventsLdvtGstd.description{:} events.description{:}}';
            durationSessionEvtLdvtGstd(i)=length(DATA.eventsLdvtGstd.time);
            disp(['... loaded event file ''' eventsLdvtGstd(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    LdvtGstd=DATA.eventsLdvtGstd.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsLdvtGstd)
        if i==1
            EvtLdvtGstd{i}=LdvtGstd(1:durationSessionEvtLstdGstd(i));
        elseif i>1
            EvtLdvtGstd{i}=LdvtGstd(durationSessionEvtLstdGstd(i-1)+1:durationSessionEvtLstdGstd(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsLdvtGstd)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtLdvtGstd{i}=EvtLdvtGstd{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtLdvtGstd)
        if i==1
            Event_LdvtGstd(1:length(EvtLdvtGstd{i}),1)=EvtLdvtGstd{i};
        elseif i>1
            Event_LdvtGstd(length(Event_LdvtGstd)+1:(length(Event_LdvtGstd)+length(EvtLdvtGstd{i})),1)=EvtLdvtGstd{i};
        end
    end
    
    Event_LdvtGstd_B=Event_LdvtGstd*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Rare AAAA
    %---------------------------------------------------------------------------------------------
    DATA.eventsOmiRare.time = [];
    DATA.eventsOmiRare.description = {};
    eventsOmiRare = dir([path sepMark '*BlocABAB*-wideband.e03.evt']);
    if ~isempty(eventsOmiRare),
        for i = 1:length(eventsOmiRare),
            events = LoadEvents([path sepMark eventsOmiRare(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiRare.time = [DATA.eventsOmiRare.time ; events.time];
            DATA.eventsOmiRare.description = {DATA.eventsOmiRare.description{:} events.description{:}}';
            durationSessionEvtOmiRare(i)=length(DATA.eventsOmiRare.time);
            disp(['... loaded event file ''' eventsOmiRare(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiRare=DATA.eventsOmiRare.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiRare)
        if i==1
            EvtOmiRare{i}=OmiRare(1:durationSessionEvtOmiRare(i));
        elseif i>1
            EvtOmiRare{i}=OmiRare(durationSessionEvtOmiRare(i-1)+1:durationSessionEvtOmiRare(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiRare)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiRare{i}=EvtOmiRare{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiRare)
        if i==1
            Event_OmiRare(1:length(EvtOmiRare{i}),1)=EvtOmiRare{i};
        elseif i>1
            Event_OmiRare(length(Event_OmiRare)+1:(length(Event_OmiRare)+length(EvtOmiRare{i})),1)=EvtOmiRare{i};
        end
    end
    
    Event_OmiRare_A=Event_OmiRare*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Rare BBBB
    %---------------------------------------------------------------------------------------------
    clear Event_OmiRare
    
    DATA.eventsOmiRare.time = [];
    DATA.eventsOmiRare.description = {};
    eventsOmiRare = dir([path sepMark '*BlocBABA*-wideband.e03.evt']);
    if ~isempty(eventsOmiRare),
        for i = 1:length(eventsOmiRare),
            events = LoadEvents([path sepMark eventsOmiRare(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiRare.time = [DATA.eventsOmiRare.time ; events.time];
            DATA.eventsOmiRare.description = {DATA.eventsOmiRare.description{:} events.description{:}}';
            durationSessionEvtOmiRare(i)=length(DATA.eventsOmiRare.time);
            disp(['... loaded event file ''' eventsOmiRare(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiRare=DATA.eventsOmiRare.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiRare)
        if i==1
            EvtOmiRare{i}=OmiRare(1:durationSessionEvtOmiRare(i));
        elseif i>1
            EvtOmiRare{i}=OmiRare(durationSessionEvtOmiRare(i-1)+1:durationSessionEvtOmiRare(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiRare)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiRare{i}=EvtOmiRare{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiRare)
        if i==1
            Event_OmiRare(1:length(EvtOmiRare{i}),1)=EvtOmiRare{i};
        elseif i>1
            Event_OmiRare(length(Event_OmiRare)+1:(length(Event_OmiRare)+length(EvtOmiRare{i})),1)=EvtOmiRare{i};
        end
    end
    
    Event_OmiRare_B=Event_OmiRare*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Frequente AAAA
    %---------------------------------------------------------------------------------------------
    DATA.eventsOmiFreq.time = [];
    DATA.eventsOmiFreq.description = {};
    eventsOmiFreq = dir([path sepMark '*BlocOmiABAB-wideband.e03.evt']);
    if ~isempty(eventsOmiFreq),
        for i = 1:length(eventsOmiFreq),
            events = LoadEvents([path sepMark eventsOmiFreq(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiFreq.time = [DATA.eventsOmiFreq.time ; events.time];
            DATA.eventsOmiFreq.description = {DATA.eventsOmiFreq.description{:} events.description{:}}';
            durationSessionEvtOmiFreq(i)=length(DATA.eventsOmiFreq.time);
            disp(['... loaded event file ''' eventsOmiFreq(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiFreq=DATA.eventsOmiFreq.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiFreq)
        if i==1
            EvtOmiFreq{i}=OmiFreq(1:durationSessionEvtOmiFreq(i));
        elseif i>1
            EvtOmiFreq{i}=OmiFreq(durationSessionEvtOmiFreq(i-1)+1:durationSessionEvtOmiFreq(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiFreq)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiFreq{i}=EvtOmiFreq{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiFreq)
        if i==1
            Event_OmiFreq(1:length(EvtOmiFreq{i}),1)=EvtOmiFreq{i};
        elseif i>1
            Event_OmiFreq(length(Event_OmiFreq)+1:(length(Event_OmiFreq)+length(EvtOmiFreq{i})),1)=EvtOmiFreq{i};
        end
    end
    
    Event_OmiFreq_A=Event_OmiFreq*1E4;
    
    %---------------------------------------------------------------------------------------------
    %                                     Omission Frequente BBBB
    %---------------------------------------------------------------------------------------------
    clear Event_OmiFreq
    
    DATA.eventsOmiFreq.time = [];
    DATA.eventsOmiFreq.description = {};
    eventsOmiFreq = dir([path sepMark '*BlocOmiBABA-wideband.e03.evt']);
    if ~isempty(eventsOmiFreq),
        for i = 1:length(eventsOmiFreq),
            events = LoadEvents([path sepMark eventsOmiFreq(i).name]);
            if isempty(events.time), continue; end
            DATA.eventsOmiFreq.time = [DATA.eventsOmiFreq.time ; events.time];
            DATA.eventsOmiFreq.description = {DATA.eventsOmiFreq.description{:} events.description{:}}';
            durationSessionEvtOmiFreq(i)=length(DATA.eventsOmiFreq.time);
            disp(['... loaded event file ''' eventsOmiFreq(i).name '''']);
        end
    else
        disp('... (no event file found)');
    end
    OmiFreq=DATA.eventsOmiFreq.time;
    
    % 1/ separation en cellules individuelles par fichiers d'acquisition
    for i=1:length(eventsOmiFreq)
        if i==1
            EvtOmiFreq{i}=OmiFreq(1:durationSessionEvtOmiFreq(i));
        elseif i>1
            EvtOmiFreq{i}=OmiFreq(durationSessionEvtOmiFreq(i-1)+1:durationSessionEvtOmiFreq(i));
        end
    end
    
    % 2/ ajout du temps correspondant (fin du fichier précedent)
    NbSession=input('what number of session concerned? ');
    for i=1:length(eventsOmiFreq)
        val=cell2mat(tpsEvt(1+NbSession(i)));
        EvtOmiFreq{i}=EvtOmiFreq{i}+val;
        i=i+1;
    end
    
    % 3/ reformation d'une matrice unique
    for i=1:length(EvtOmiFreq)
        if i==1
            Event_OmiFreq(1:length(EvtOmiFreq{i}),1)=EvtOmiFreq{i};
        elseif i>1
            Event_OmiFreq(length(Event_OmiFreq)+1:(length(Event_OmiFreq)+length(EvtOmiFreq{i})),1)=EvtOmiFreq{i};
        end
    end
    
    Event_OmiFreq_B=Event_OmiFreq*1E4;

end


%-------------------------------------------------------------------------------------------------------------------
save LocalGlobal Event_LstdGstd_A Event_LdvtGstd_A Event_LstdGdvt_A Event_LdvtGdvt_A Event_OmiRare_A Event_OmiFreq_A
%-------------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------------------
save LocalGlobal -append Event_LstdGstd_B Event_LdvtGstd_B Event_LstdGdvt_B Event_LdvtGdvt_B Event_OmiRare_B Event_OmiFreq_B
%---------------------------------------------------------------------------------------------------------------------------

disp('Done');