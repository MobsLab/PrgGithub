%%ParcoursTonesAndDeltaOneNight
% 14.05.2019 KJ
%
%
%   see 
%       ScriptLoadDeltaTonesOneNight ScriptTonesInDeltaOneNight ScriptTonesOutDeltaOneNight



clear

Dir = PathForExperimentsRandomTonesDelta;

%get data for each record
for p=10:11%length(Dir.path)

    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p

    ScriptLoadDeltaTonesOneNight

    %inside delta
    ScriptTonesInDeltaOneNight
    title([Dir.name{p} ' - ' Dir.date{p}])
    
    foldername='/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Projet_Delta/Figures_DeltaFeedback/LabMeeting/20190729/TonesInDeltaFigures/';
    filename_fig1 = ['TonesInDelta_' Dir.name{p} '_' Dir.date{p} '.png'];
    saveas(gcf,fullfile(foldername,filename_fig1),'png')

    %outside delta
    ScriptTonesOutDeltaOneNight
    title([Dir.name{p} ' - ' Dir.date{p}])
    
    foldername='/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Projet_Delta/Figures_DeltaFeedback/LabMeeting/20190729/TonesInDeltaFigures/';
    filename_fig2 = ['TonesInUp_' Dir.name{p} '_' Dir.date{p} '.png'];
    saveas(gcf,fullfile(foldername,filename_fig2),'png')

    
end




