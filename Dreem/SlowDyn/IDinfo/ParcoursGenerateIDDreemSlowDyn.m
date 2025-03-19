% ParcoursGenerateIDDreemSlowDyn
% 13.06.2018 KJ
%
% Infos
%   Loop over all record: generate and save data, plot and save figures 
%
% SEE 
%   PlotIDDreemSlowDyn GenerateIDDreemSlowDyn
%

load(fullfile(FolderSlowDyn,'PathSlowDynSfrms.mat'))

for p=1:length(Dir.filereference)
    clearvars -except Dir p

    disp(' ')
    disp('****************************************************************')
    disp(Dir.filename{p})
    
    if exist(fullfile(FolderSlowDynID,['IdFigureData_' num2str(Dir.filereference{p}) '.mat']),'file')~=2
        
        %% compute
        try
            spectrofolder = fullfile(FolderSlowDynPreprocess, 'Spectrograms');
            spectro_file = fullfile(spectrofolder,num2str(Dir.filereference{p}),['Spectro_' num2str(Dir.filereference{p}) '_ch_1.mat']);
            if exist(spectro_file,'file')~=2
                MakeSpectrogramDreemRecord(p,Dir,'savefolder', spectrofolder);
            end

            %ID
            DreemIDSlowDyn(p,Dir);
        catch
            disp('error')
        end
        
    end

    
        try
            %% plot
            %title
            filename_png = ['IDfigures_' num2str(Dir.filereference{p})  '.png'];
            filename_png = fullfile(FolderSlowDynFigures, 'IDfigures1',filename_png);

            if exist(filename_png,'file')~=2
                try
                    PlotIDDreemSlowDyn(Dir.filereference{p});

                    %save figure
                    set(gcf,'units','normalized','outerposition',[0 0 1 1])
                    saveas(gcf,filename_png,'png')
                    close all
                end
            else
                disp('already ploted')
            end
        catch
            disp('error for plot')
        end
    
end



