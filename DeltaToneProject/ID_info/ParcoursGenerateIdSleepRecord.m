% ParcoursGenerateIdSleepRecord
% 07.11.2016 KJ
%
% Generate, plot and save figure for all records in the path
%
% Info
%   see GenerateIDSleepRecord
%


% Dir1=PathForExperimentsDeltaWavesTone('Basal');
% Dir2=PathForExperimentsDeltaWavesTone('RdmTone');
% Dir3=PathForExperimentsDeltaWavesTone('DeltaToneAll');
% Dir = MergePathForExperiment(Dir1,Dir2);
% Dir = MergePathForExperiment(Dir,Dir3);
% clear Dir1 Dir2 Dir3

Dir=PathForExperimentsDeltaToInclude('basal');

for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)
        clearvars -except Dir p

        idfigures = dir('IDfigures_*');
        if isempty(idfigures)
            GenerateIDSleepRecord;

            %title
            title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
            filename_fig = ['IDfigures_' Dir.name{p}  '_' Dir.date{p}];
            filename_png = [filename_fig  '.png'];
            % suptitle
            suplabel(title_fig,'t');
            %save figure
            savefig(filename_fig)
            cd([FolderFigureDelta 'IDfigures/'])
            set(gcf,'units','normalized','outerposition',[0 0 1 1])
            saveas(gcf,filename_png,'png')
            close all
        end
    catch 
        disp('problem with this record')
    end
end