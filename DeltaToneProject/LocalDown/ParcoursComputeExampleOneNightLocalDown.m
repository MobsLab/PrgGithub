%%ParcoursComputeExampleOneNightLocalDown
% 25.09.2019 KJ
%
% Infos
%   Examples homeostasis figures
%
% see
%     ComputeExampleOneNightLocalDown PlotExampleOneNightLocalDown 
%
%




Dir = PathForExperimentsLocalDeltaDown('hemisphere');


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)

    clearvars -except Dir p 
    
    id_tetrodes = Dir.tetrodes{p};
    hemisphere = Dir.hemisphere{p};
    
    try
       ComputeExampleOneNightLocalDown
    catch
        disp('error for this record')
    end

    
    
end