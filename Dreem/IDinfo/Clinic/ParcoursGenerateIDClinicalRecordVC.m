% ParcoursGenerateIDClinicalRecordVC
% 13.01.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   PlotIDClinicalRecord GenerateIDClinicalRecordVC
%

Dir = ListOfClinicalTrialDreemAnalyse('all');

for p=56
        clearvars -except Dir p list_fileref

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        a = GenerateIDClinicalRecordVC(p,Dir,'tosave',1,'toplot',1);
        %PlotIDClinicalRecordVC(Dir.filereference{p});

        cd([FolderClinicFigures '/IDfigures/ID_VC'])

        %title
        filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
    
end



