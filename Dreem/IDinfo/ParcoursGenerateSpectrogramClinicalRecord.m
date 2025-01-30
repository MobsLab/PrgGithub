% ParcoursGenerateSpectrogramClinicalRecord
% 13.03.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   GenerateSpectrogramClinicalRecord
%

Dir = ListOfClinicalTrialDreem('all');

for p=18
    try
        clearvars -except Dir p

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        GenerateSpectrogramClinicalRecord(p,Dir,'tosave',1,'toplot',1);

        cd([FolderClinicFigures '/IDfigures/Spectrogram'])

        %title
        filename_png = ['ID_specgram_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
    catch
        disp('error for this record')
    
    end
    
end