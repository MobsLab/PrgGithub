function Dir = CheckPathForExperiment_KJ(Dir1)

% look if the paths exist, change them otherwise
%
% see
%   RestrictPathForExperiment IntersectPathForExperiment MergePathForExperiment
 
%% evaluate inputs

if nargin<1
    error('Not enough input arguents')
end


%% check Dir1

for i=1:length(Dir1.path)
    
    try temp=Dir1.manipe{i}; catch, temp='ManipeDir1';end
    Dir1.manipe{i}=temp;
    
    try temp=Dir1.CorrecAmpli(i); catch, temp=1;end
    Dir1.CorrecAmpli(i)=temp;
end

%% check path
for i=1:length(Dir1.path)
    if exist(Dir1.path{i},'dir')==7
        Dir.path{i} = Dir1.path{i};
    else        
        Dir.path{i} = strrep(Dir1.path{i}, '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/', '/media/karimjunior/MOBs_KJ/');
    end
end


%% keep other fields

Dir.name        = Dir1.name;
Dir.group       = Dir1.group;
Dir.manipe      = Dir1.manipe;
Dir.CorrecAmpli = Dir1.CorrecAmpli;
try 
    Dir.delay = Dir1.delay;
end
try 
    Dir.date = Dir1.date;
end

end
