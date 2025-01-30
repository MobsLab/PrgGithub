

function FearContextSess = FearContextSess2

Mouse=[923 926 927 928 929];
Dir = PathForExperimentsTRAPMice('TestC');

for mouse=1:length(Dir.path)
    Mouse_names{mouse}=['M' num2str(Dir.ExpeInfo{mouse}{1}.nmouse)];
    FearContextSess.(Mouse_names{mouse}){1} = Dir.path{mouse}{1};
end






