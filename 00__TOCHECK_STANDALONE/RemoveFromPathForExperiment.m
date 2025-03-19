function DirR = RemoveFromPathForExperiment(Dir,varargin)


% examples
% Dir=RemoveFromPathForExperiment(Dir,'nMice',[245 246]);
% Dir=RemoveFromPathForExperiment(Dir,'Group',{'OBX','hemiOBX'});
%
% other function:
% MergePathForExperiment.m IntersectPathForExperiment.m RestrictPathForExperiment.m

%% evaluate inputs

if nargin<3
    error('Not enough input arguents')
end

nameGroup=[];
nameMice=[];
nameTreatment=[];
nameSession=[];

if strcmp(varargin(1),'Group')
    temp=varargin{2};
    try temp{1};nameGroup=temp; catch, nameGroup{1}=temp;end
    temp=[]; for nn=1:length(nameGroup), temp=[temp,' ',nameGroup{nn},' +'];end
    disp(['Removing groups',temp(1:end-1),' from Dir'])
    
elseif  strcmp(varargin(1),'nMice')
    nameMice=varargin{2};
    disp(['Removing Mice ',num2str(nameMice),' from Dir'])
    
elseif  strcmp(varargin(1),'Session')
    tempT=varargin{2};
    try tempT{1};nameSession=tempT; catch, nameSession{1}=tempT;end
    tempT=[]; for nt=1:length(nameSession), tempT=[tempT,' ',nameSession{nt},' +'];end    
    disp(['Removing Session',tempT(1:end-1),' from Dir'])
    
elseif  strcmp(varargin(1),'Treatment')
    tempT=varargin{2};
    try tempT{1};nameTreatment=tempT; catch, nameTreatment{1}=tempT;end
    tempT=[]; for nt=1:length(nameTreatment), tempT=[tempT,' ',nameTreatment{nt},' +'];end    
    disp(['Removing Treatments',tempT(1:end-1),' from Dir'])
else
    error('accepted vargin = ''Group'' or ''nMice'' or ''Treatment'' or ''Session''' )
end


%% initialization of new dir

DirR.path=[];
DirR.CorrecAmpli=[];
DirR.group=[];
DirR.name=[];
DirR.manipe=[];
try Dir.Session{1}; DirR.Session=[];end
try Dir.delay{1}; DirR.delay=[];end
try Dir.date{1}; DirR.date=[];end
try Dir.Treatment{1}; DirR.Treatment=[];end

%% loop for groups

if isempty(nameGroup)
    indexKeep = [];
else
    indexRemove = [];
    for nn=1:length(nameGroup)
        for j=1:length(Dir.group)
            indexRemove=[indexRemove find(strcmp(Dir.group{j},nameGroup{nn}))];
        end
        if isempty(indexRemove)
            disp(['Group(s) is(are) empty'])
        end
        indexRemove=unique(indexRemove);
        indexKeep = [1:1:length(Dir.path)];
        indexKeep(indexRemove)=[];
    end
end


for i=1:length(indexKeep)
    DirR.path=[DirR.path,Dir.path(indexKeep(i))];
    DirR.name=[DirR.name,Dir.name(indexKeep(i))];
    
    try temp=Dir.manipe(indexKeep(i)); catch, temp=['Manipe',nameGroup{nn}];end
    DirR.manipe=[DirR.manipe,temp];
    
    try temp=Dir.CorrecAmpli(indexKeep(i)); catch, temp=1;end
    DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
    
    try DirR.delay=[DirR.delay,Dir.delay(indexKeep(i))];end
    
    try DirR.date=[DirR.date,Dir.date(indexKeep(i))];end
    
    try DirR.Session=[DirR.Session,Dir.Session(indexKeep(i))];end
    
    try DirR.Treatment=[DirR.Treatment,Dir.Treatment(indexKeep(i))];end
end

for i=1:length(indexKeep)
    for j=1:length(Dir.group)
        DirR.group{j}{i}=Dir.group{j}{indexKeep(i)};
    end
end



%% loop for mice

if isempty(nameMice)
    idxKeep = [];
else
    idxRemove = [];
    for nn=1:length(nameMice)
        temp=num2str(nameMice(nn));
        while length(temp)<3, temp=['0',temp];end
        nameM=['Mouse',temp];
        
        
        if sum(strcmp(unique(Dir.name),nameM))==0
            disp(['No ',nameM,' in Dir'])
        else
            index=find(strcmp(Dir.name,nameM));
            idxRemove = [idxRemove index];
        end
        idxKeep = [1:1:length(Dir.path)];
        idxKeep(idxRemove)=[];
    end
end

    try
        for i=1:length(idxKeep)
            DirR.path=[DirR.path,Dir.path(idxKeep(i))];
            DirR.name=[DirR.name,Dir.name(idxKeep(i))];
            
            try temp=Dir.manipe(idxKeep(i)); catch, temp=['Manipe',nameGroup{nn}];end
            DirR.manipe=[DirR.manipe,temp];
            
            try temp=Dir.CorrecAmpli(idxKeep(i)); catch, temp=1;end
            DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
            
            try DirR.delay=[DirR.delay,Dir.delay(idxKeep(i))];end
            
            try DirR.date=[DirR.date,Dir.date(idxKeep(i))];end
            
            try DirR.Session=[DirR.Session,Dir.Session(idxKeep(i))];end
            
            try DirR.Treatment=[DirR.Treatment,Dir.Treatment(idxKeep(i))];end
        end
    catch
        keyboard
    end

for i=1:length(idxKeep)
    for j=1:length(Dir.group)
        DirR.group{j}{i}=Dir.group{j}{idxKeep(i)};
    end
end


%% loop for treatments

if isempty(nameTreatment)
    indexKeep = [];
else
    indexRemove = [];
    for nn=1:length(nameTreatment)
        if sum(strcmp(unique(Dir.Treatment),nameTreatment{nn}))==0
            disp(['Group ',nameTreatment{nn},' is empty'])
        else
            indexRemove=find(strcmp(Dir.Treatment,nameTreatment{nn}));
        end
    end
    indexKeep = [1:1:length(Dir.path)];
    indexKeep(indexRemove)=[];
end

for i=1:length(indexKeep)
    DirR.path=[DirR.path,Dir.path(indexKeep(i))];
    DirR.name=[DirR.name,Dir.name(indexKeep(i))];
    
    try temp=Dir.manipe(indexKeep(i)); catch, temp=['Manipe',nameGroup{nn}];end
    DirR.manipe=[DirR.manipe,temp];
    
    try temp=Dir.CorrecAmpli(indexKeep(i)); catch, temp=1;end
    DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
    
    try DirR.delay=[DirR.delay,Dir.delay(indexKeep(i))];end
    
    try DirR.date=[DirR.date,Dir.date(indexKeep(i))];end
    
    try DirR.Session=[DirR.Session,Dir.Session(indexKeep(i))];end
    
    try DirR.Treatment=[DirR.Treatment,Dir.Treatment(indexKeep(i))];end
end

for i=1:length(indexKeep)
    for j=1:length(Dir.group)
        DirR.group{j}{i}=Dir.group{j}{indexKeep(i)};
    end
end

%% loop for sessions
if isempty(nameSession)
    indexKeep=[];
else
    indexRemove = [];
    for nn=1:length(nameSession)
        session_ok=strfind(unique(Dir.Session),nameSession{nn});
        if session_ok{nn}==0 %
            disp(['Session ',nameSession{nn},' is empty'])
        else
            indexRemove=strfind(Dir.Session,nameSession{nn});
        end
    end
    indexKeep = [1:1:length(Dir.path)];
    indexKeep(indexRemove)=[];
end

for i=1:length(indexKeep)
    DirR.path=[DirR.path,Dir.path(indexKeep(i))];
    DirR.name=[DirR.name,Dir.name(indexKeep(i))];
    
    try temp=Dir.manipe(indexKeep(i)); catch, temp=['Manipe',nameGroup{nn}];end
    DirR.manipe=[DirR.manipe,temp];
    
    try temp=Dir.CorrecAmpli(indexKeep(i)); catch, temp=1;end
    DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
    
    try DirR.delay=[DirR.delay,Dir.delay(indexKeep(i))];end
    
    try DirR.date=[DirR.date,Dir.date(indexKeep(i))];end
    
    try DirR.Session=[DirR.Session,Dir.Session(indexKeep(i))];end
    
    try DirR.Treatment=[DirR.Treatment,Dir.Treatment(indexKeep(i))];end
end



