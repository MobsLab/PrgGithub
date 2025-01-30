function Dir = FusionListOfClinicalTrial(Dir1,Dir2)


%Function for Dreem Data
% -> merge Path for Experiments

% example:
% Dir1=PathForExperimentsClinicalTrialDreem('Habituation');
% Dir2=PathForExperimentsClinicalTrialDreem('Sham');
% Dir = FusionPathForRecords(Dir1,Dir2);
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
    Dir.filereference = [Dir1.filereference, Dir2.filereference];
    Dir.filename = [Dir1.filename, Dir2.filename];
    Dir.processing = [Dir1.processing, Dir2.processing];
    Dir.date = [Dir1.date, Dir2.date];
    Dir.subject = [Dir1.subject, Dir2.subject];
    Dir.night = [Dir1.night, Dir2.night];
    Dir.condition = [Dir1.condition, Dir2.condition];
    Dir.channel_sw = [Dir1.channel_sw, Dir2.channel_sw];
end

end

