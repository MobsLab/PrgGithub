function Dir = MergePathForExperiment_SB(Dir1,Dir2)

% example:
% Dir1=PathForExperimentsML('DPCPX');
% Dir2=PathForExperimentsML('LPS');
% Dir = MergePathForExperiment(Dir1,Dir2);
%
% other function
% RestrictPathForExperiment.m IntersectPathForExperiment.m
 
%% evaluate inputs

if nargin<2
    error('Not enough input arguents')
end



%% concatenate Dir1 and Dir2


Dir.path=[Dir1.path,Dir2.path];
Dir.ExpeInfo=[Dir1.ExpeInfo,Dir2.ExpeInfo];

end

