function DirR = RestrictPathForExperiment(Dir,varargin)


% examples
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246]);
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'});
% Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
% Dir=RestrictPathForExperiment(Dir,'Treatment','CNO1');
%
% other function:
% MergePathForExperiment.m IntersectPathForExperiment.m

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
    disp(['Getting groups',temp(1:end-1),' from Dir'])
    
elseif  strcmp(varargin(1),'nMice')
    nameMice=varargin{2};
    disp(['Getting Mice ',num2str(nameMice),' from Dir'])
    
elseif  strcmp(varargin(1),'Session')
    tempT=varargin{2};
    try tempT{1};nameSession=tempT; catch, nameSession{1}=tempT;end
    tempT=[]; for nt=1:length(nameSession), tempT=[tempT,' ',nameSession{nt},' +'];end
    disp(['Getting Session',tempT(1:end-1),' from Dir'])
    
elseif  strcmp(varargin(1),'Treatment')
    tempT=varargin{2};
    try tempT{1};nameTreatment=tempT; catch, nameTreatment{1}=tempT;end
    tempT=[]; for nt=1:length(nameTreatment), tempT=[tempT,' ',nameTreatment{nt},' +'];end
    disp(['Getting Treatments',tempT(1:end-1),' from Dir'])
else
    error('accepted vargin = ''Group'' or ''nMice'' or ''Treatment''')
end


%% initialization of new dir

DirR.path=[];
DirR.correcAmpli=[];
DirR.group=[];
DirR.name=[];
DirR.manipe=[];
try Dir.Session{1}; DirR.Session=[];end
try Dir.delay{1}; DirR.delay=[];end
try Dir.date{1}; DirR.date=[];end
try Dir.Treatment{1}; DirR.Treatment=[];end

%% loop for groups

index = [];
for nn=1:length(nameGroup)
    for j=1:length(Dir.group)
        index=[index find(strcmp(Dir.group{j},nameGroup{nn}))];
    end
    if isempty(index)
        disp(['Group(s) is(are) empty'])
    end
    index=unique(index);
end


for i=1:length(index)
    DirR.path=[DirR.path,Dir.path(index(i))];
    DirR.name=[DirR.name,Dir.name(index(i))];
    
    try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
    DirR.manipe=[DirR.manipe,temp];
    
    try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
    DirR.correcAmpli=[DirR.correcAmpli,temp];
    
    try DirR.delay=[DirR.delay,Dir.delay(index(i))];end
    
    try DirR.date=[DirR.date,Dir.date(index(i))];end
    
    try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
    
    try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
end

for i=1:length(index)
    try
        for j=1:length(Dir.group)
            DirR.group{j}{i}=Dir.group{j}{index(i)};
        end
    catch
        DirR.group{i}=Dir.group{index(i)};
    end
end



%% loop for mice

idx = [];
for nn=1:length(nameMice)
    temp=num2str(nameMice(nn));
    while length(temp)<3, temp=['0',temp];end
    nameM=['Mouse',temp];
    
    
    if sum(strcmp(unique(Dir.name),nameM))==0
        disp(['No ',nameM,' in Dir'])
    else
        index=find(strcmp(Dir.name,nameM));
        idx = [idx index];
    end
    try
        for i=1:length(index)
            DirR.path=[DirR.path,Dir.path(index(i))];
            DirR.name=[DirR.name,Dir.name(index(i))];
            
            try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
            DirR.manipe=[DirR.manipe,temp];
            
            try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
            DirR.correcAmpli=[DirR.correcAmpli,temp];
            
            try DirR.delay=[DirR.delay,Dir.delay(index(i))];end
            
            try DirR.date=[DirR.date,Dir.date(index(i))];end
            
            try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
            
            try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
        end
    catch
        keyboard
    end
    
end

if isfield(Dir,'group')
    for i=1:length(idx)
        try
            for j=1:length(Dir.group)
                DirR.group{j}{i}=Dir.group{j}{i};
            end
        catch
            DirR.group{i}=Dir.group{idx(i)};
        end
    end
end

%% loop for treatments

for nn=1:length(nameTreatment)
    if sum(strcmp(unique(Dir.Treatment),nameTreatment{nn}))==0
        index=[];
        disp(['Group ',nameTreatment{nn},' is empty'])
    else
        index=find(strcmp(Dir.Treatment,nameTreatment{nn}));
    end
    
    for i=1:length(index)
        DirR.path=[DirR.path,Dir.path(index(i))];
        DirR.name=[DirR.name,Dir.name(index(i))];
        DirR.group=[DirR.group,Dir.group(index(i))];
        
        try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
        DirR.manipe=[DirR.manipe,temp];
        
        try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
        DirR.correcAmpli=[DirR.correcAmpli,temp];
        
        try DirR.delay=[DirR.delay,Dir.delay(index(i))];end
        
        try DirR.date=[DirR.date,Dir.date(index(i))];end
        
        try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
        
        try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
    end
    
end

%% loop for sessions

for nn=1:length(nameSession)
    session_ok=strfind(unique(Dir.Session),nameSession{nn});
    if session_ok{nn}==0 %
        index=[];
        disp(['Session ',nameSession{nn},' is empty'])
    else
        indexarray=strfind(Dir.Session,nameSession{nn});
        index=[];
        for k=1:length(indexarray)
            if ~isempty(indexarray{k})
                index=[index, k];
            end
        end
    end
    
    for i=1:length(index)
        DirR.path=[DirR.path,Dir.path(index(i))];
        DirR.name=[DirR.name,Dir.name(index(i))];
        DirR.group=[DirR.group,Dir.group(index(i))];
        
        try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
        DirR.manipe=[DirR.manipe,temp];
        
        try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
        DirR.correcAmpli=[DirR.correcAmpli,temp];
        
        try DirR.delay=[DirR.delay,Dir.delay(index(i))];end
        
        try DirR.date=[DirR.date,Dir.date(index(i))];end
        
        try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
        
        try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
    end
    
end