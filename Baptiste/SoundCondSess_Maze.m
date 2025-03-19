
function SoundCondSess = SoundCondSess_Maze

Dir=PathForExperimentsEmbReact('SoundTest');


for mouse=1:length(Dir.path)
    Mouse_names{mouse}=['M' num2str(Dir.ExpeInfo{mouse}{1}.nmouse)];
    SoundCondSess.(Mouse_names{mouse}){1} = Dir.path{mouse}{1};
end




