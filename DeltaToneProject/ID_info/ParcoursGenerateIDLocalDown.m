% ParcoursGenerateIDLocalDown
% 21.08.2017 KJ
%
% Generate, plot and save figure for all records in the path
%
% Info
%   see GenerateIDLocalDown
%


Dir = PathForExperimentsDeltaSleepSpikes('all');

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        clearvars -except Dir p

        GenerateIDLocalDown;

        %title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
        filename_fig = ['LocalDown_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        % suptitle
        suplabel(title_fig,'t');
        %save figure
        savefig(filename_fig)
        cd([FolderFigureDelta 'IDfigures/LocalDown'])
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
    catch 
        disp('problem with this record')
    end
end