% ParcoursGenerateSpectrogramClinicalRecord_VC
% 03.07.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   GenerateSpectrogramClinicalRecord_VC
%

Dir = ListOfClinicalTrialDreemAnalyse('all');

for p=1:length(Dir.filename)
    try
        clearvars -except Dir p

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        GenerateSpectrogramClinicalRecord_VC(p,Dir);

        cd([FolderClinicFigures '/IDfigures/Specgram_VC_eden'])

        %title
        filename_png = ['VC_specgram_' num2str(Dir.filereference{p})  '.png'];
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
        
    catch
        disp('error for this record')
    
    end
    
end