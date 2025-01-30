function Dir = FusionListOfDreemRecord(Dir1,Dir2)


%Function for Dreem Data
% -> merge Path for Experiments

% example:
% Dir1=ListOfDreemRecordsStimImpact('highso');
% Dir2=ListOfDreemRecordsStimImpact('kusers');
% Dir = FusionListOfDreemRecord(Dir1,Dir2);
%
% other function
% 
 
%% evaluate inputs

if nargin<2
    error('Not enough input arguents')
end

%% concatenate Dir1 and Dir2

%if one is empty
if ~isfield(Dir1,'filereference')
    Dir = Dir2;

else
    dir_attr = fieldnames(Dir1);
    
    for i=1:length(dir_attr)
       try 
            Dir.(dir_attr{i}) = [Dir1.(dir_attr{i}), Dir2.(dir_attr{i})]; 
       catch
            Dir.(dir_attr{i}) = [Dir1.(dir_attr{i}); Dir2.(dir_attr{i})]; 
       end
    end
 
end

end

