
function SoundCondSess = SoundCondSess2

CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');


for mouse=1:length(Dir.path)
    Mouse_names{mouse}=Dir.name{mouse}([1 6:8]);
    SoundCondSess.(Mouse_names{mouse}){1} = Dir.path{mouse};
end




