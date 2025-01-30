function DirR = RestrictPathForExperiment(Dir,varargin)


% example
% Dir=RestrictPathForExperiment(Dir,'nMice',[245 246]);
% Dir=RestrictPathForExperiment(Dir,'Group',{'OBX','hemiOBX'});
% Dir=RestrictPathForExperiment(Dir,'Group','OBX');
%
% other function:
% MergePathForExperiment.m

%% evaluate inputs

if nargin<3
    error('Not enough input arguents')
end

nameGroup=[];
nameMice=[];
nameTreatment=[];

if strcmp(varargin(1),'Group')
    temp=varargin{2};
    try temp{1};nameGroup=temp; catch, nameGroup{1}=temp;end
    temp=[]; for nn=1:length(nameGroup), temp=[temp,' ',nameGroup{nn},' +'];end
    disp(['Getting groups',temp(1:end-1),' from Dir'])
    
elseif  strcmp(varargin(1),'nMice')
    nameMice=varargin{2};
    disp(['Getting Mice ',num2str(nameMice),' from Dir'])
    
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
DirR.CorrecAmpli=[];
DirR.group=[];
DirR.name=[];
DirR.manipe=[];
try Dir.Session{1}; DirR.Session=[];end
try Dir.Treatment{1}; DirR.Treatment=[];end

%% loop for groups

for nn=1:length(nameGroup)
    if sum(strcmp(unique(Dir.group),nameGroup{nn}))==0
        index=[];
        disp(['Group ',nameGroup{nn},' is empty'])
    else
        index=find(strcmp(Dir.group,nameGroup{nn}));
    end
    
    for i=1:length(index)
        DirR.path=[DirR.path,Dir.path(index(i))];
        DirR.name=[DirR.name,Dir.name(index(i))];
        DirR.group=[DirR.group,Dir.group(index(i))];
        
        try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
        DirR.manipe=[DirR.manipe,temp];
        
        try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
        DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
        
        try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
        
        try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
    end

end


%% loop for mice

for nn=1:length(nameMice)
    temp=num2str(nameMice(nn));
    while length(temp)<3, temp=['0',temp];end
    nameM=['Mouse',temp];
    
    
    if sum(strcmp(unique(Dir.name),nameM))==0
        disp(['No ',nameM,' in Dir'])
    else
        index=find(strcmp(Dir.name,nameM));
    end
    
    for i=1:length(index)
        DirR.path=[DirR.path,Dir.path(index(i))];
        DirR.name=[DirR.name,Dir.name(index(i))];
        DirR.group=[DirR.group,Dir.group(index(i))];
        
        try temp=Dir.manipe(index(i)); catch, temp=['Manipe',nameGroup{nn}];end
        DirR.manipe=[DirR.manipe,temp];
        
        try temp=Dir.CorrecAmpli(index(i)); catch, temp=1;end
        DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
        
        try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
        
        try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
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
        DirR.CorrecAmpli=[DirR.CorrecAmpli,temp];
        
        try DirR.Session=[DirR.Session,Dir.Session(index(i))];end
        
        try DirR.Treatment=[DirR.Treatment,Dir.Treatment(index(i))];end
    end

end


