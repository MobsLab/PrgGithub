% ParcoursGenerateStimPolarPlot
% 03.08.2017 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   ParcoursGenerateIDClinicalRecordVC GenerateIDClinicalRecordVC
%

Dir = ListOfClinicalTrialDreemAnalyse('UpPhase');
all_phases = [];

for p=1:length(Dir.filename)
        clearvars -except Dir p all_phases

        disp(' ')
        disp('****************************************************************')
        disp(Dir.filename{p})
        
        %% data and plot 
        
        %Load Data
        try
            cd(FolderProcessDreem)
            datafile = ['IDfigures_' num2str(Dir.filereference{p}) '.mat'];
            load(datafile)
        catch
            disp('File not loaded')
        end
        if ~exist('infos','var')
            error('data not loaded.')
        end
        
        %peak at 45°
        all_phases = [all_phases ; phase_tone + pi/2];

end


mean_phase = circ_mean(all_phases);

%plot
figure('Color',[1 1 1],'units','normalized','outerposition',[0 0 1 1]);
[theta, rho] = rose(all_phases,36); close

polarplot(theta,rho,'MarkerFaceColor','auto'), hold on
polarplot([mean_phase mean_phase],get(gca,'rlim'),'color','k','linewidth',2), hold on




% if strcmpi(Dir.condition{p},'upphase')
%     title(['Subject ' num2str(Dir.subject{p}) ' - Ascending phase']);
% else
%     title(['Subject ' num2str(Dir.subject{p}) ' - ' Dir.condition{p}]);
% end

% %% save figure
% cd([FolderClinicFigures '/IDfigures/polarstim_eden'])
% %title
% filename_png = ['PolarStim_' num2str(Dir.filereference{p})  '.png'];
% %save figure
% set(gcf,'units','normalized','outerposition',[0 0 1 1])
% saveas(gcf,filename_png,'png')
% close all



