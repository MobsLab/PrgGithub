% ParcoursGenerateIDDreemRandomStim
% 24.03.2018 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   PlotIDDreemRandomStim DreemIDRandomStim
%

Dir = ListOfDreemRecordsRandomStim('all');

for p=1:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
%     
%     %spectro
%     MakeSpectrogramDreemRecord(p,Dir,'savefolder',fullfile(FolderRandomStimPreprocess, 'Spectrograms'))
%     
%     %ID
%     DreemIDRandomStim(p,Dir);
    
    %% plot
    PlotIDDreemRandomStim(Dir.filereference{p});

    %title
    filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
    filename_png = fullfile(FolderRandomStimFigures, 'IDfigures1',filename_png);
    %save figure
    set(gcf,'units','normalized','outerposition',[0 0 1 1])
    saveas(gcf,filename_png,'png')
    close all
    
end



