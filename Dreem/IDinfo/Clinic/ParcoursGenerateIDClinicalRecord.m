% ParcoursGenerateIDClinicalRecord
% 13.01.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   PlotIDClinicalRecord
%

Dir = ListOfClinicalTrialDreem('all');

for p=1:length(Dir.filename)
    try
        clearvars -except Dir p

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        a = GenerateIDClinicalRecord(p,Dir,'tosave',1,'toplot',1);
        PlotIDClinicalRecord(Dir.filereference{p});

        cd([FolderClinicFigures '/IDfigures/ID'])

        %title
        filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
    catch
        disp('error for this record')
    end
    
end