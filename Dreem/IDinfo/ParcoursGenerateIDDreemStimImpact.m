% ParcoursGenerateIDDreemStimImpact
% 24.03.2018 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   PlotIDDreemStimImpact GenerateIDDreemStimImpact
%

Dir = ListOfDreemRecordsStimImpact('all');

for p=16:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
%     %% compute
%     try
%         MakeSpectrogramDreemRecord(p,Dir,'savefolder',fullfile(FolderStimImpactPreprocess, 'Spectrograms'))
%         
%         %ID
%         DreemIDStimImpact(p,Dir);
%     catch
%         disp('error')
%     end
%     
    
    try
        savefile = fullfile(FolderStimImpactID,['IdFigureData_' num2str(Dir.filereference{p}) '.mat']);
        [signals, ~, stimulations, ~, ~] = GetRecordDreem(Dir.filename{p});
        disp('Mean curves analysis')
        if exist(savefile,'file')==2    
            [meancurves_stim, nb_events, intensities] = DreemIDfunc_Stimcurves('signals',signals,'stimulations',stimulations);
            save(savefile,'-append', 'meancurves_stim', 'nb_events', 'intensities')
        else
            disp('already done')
        end
    
    %% plot
    
        PlotIDDreemStimImpact(Dir.filereference{p});

        %title
        filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
        filename_png = fullfile(FolderStimImpactFigures, 'IDfigures1',filename_png);
        %save figure
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
    catch
        disp('error for plot')
    end
    
end



