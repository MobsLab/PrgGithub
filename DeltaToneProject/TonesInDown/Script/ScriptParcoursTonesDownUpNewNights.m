%%ScriptParcoursTonesDownUpNewNights
% 14.05.2019 KJ
%
%
%   see 
%       ScriptTonesInDownOneNight





clear

Dir=PathForExperimentsRandomTonesSpikes;


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    cd(Dir.path{p})
    disp(pwd)
    
    clearvars -except Dir p
    
    x = 'IDfigures_Mouse*';
    filelist = dir(x);
    uiopen(filelist(1).name,1)

    ScriptTonesInDownOneNight;
    ScriptTonesInUpOneNight
    
end