function Dir = IntersectPathForExperiment(Dir1,Dir2)

% example:
% Dir1=PathForExperimentsML('DPCPX');
% Dir2=PathForExperimentsML('LPS');
% Dir = IntersectPathForExperiment(Dir1,Dir2);
%
% other function
% RestrictPathForExperiment.m MergePathForExperiment.m
 
%% evaluate inputs

if nargin<2
    error('Not enough input arguents')
end


%% check Dir1

for i=1:length(Dir1.path)
    
    try temp=Dir1.manipe{i}; catch, temp='ManipeDir1';end
    Dir1.manipe{i}=temp;
    
    try temp=Dir1.CorrecAmpli(i); catch, temp=1;end
    Dir1.CorrecAmpli(i)=temp;
end


%% check Dir2

for i=1:length(Dir2.path)
    
    try temp=Dir2.manipe{i}; catch, temp='ManipeDir2';end
    Dir2.manipe{i}=temp;
    
    try temp=Dir2.CorrecAmpli(i); catch, temp=1;end
    Dir2.CorrecAmpli(i)=temp;
    
end

%% check same path in both Dir1 and Dir2
same_rec = [];
for i=1:length(Dir1.path)
    for p=1:length(Dir2.path)
        if strcmp(Dir1.path{i},Dir2.path{p})
            same_rec = [same_rec i];
        elseif strcmp(Dir1.name{i},Dir2.name{p}) && strcmp(Dir1.manipe{i},Dir2.manipe{p})
            try
                if strcmp(Dir1.date{i},Dir2.date{p})
                    same_rec = [same_rec i];
                end
            end
        end
    end
end

%% concatenate Dir1 and Dir2

Dir.path=Dir1.path(same_rec);
Dir.name=Dir1.name(same_rec);
for i=1:length(Dir1.group)
    Dir.group{i}=Dir1.group{i}(same_rec);
end
Dir.manipe=Dir1.manipe(same_rec);
Dir.CorrecAmpli=Dir1.CorrecAmpli(same_rec);
try 
    Dir.delay=Dir1.delay(same_rec);
end
try 
    Dir.date=Dir1.date(same_rec);
end

end
