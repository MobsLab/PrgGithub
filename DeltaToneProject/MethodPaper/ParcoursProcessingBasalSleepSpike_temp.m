%ParcoursProcessingBasalSleepSpike_temp
% 29.11.2017 KJ
%
% processing for dataset
%
% see PathForExperimentsBasalSleepSpike
%


Dir=PathForExperimentsBasalSleepRhythms;

for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
 
    %%
    [down_curves, channel_curves, structures_curves, peak_value] = MakeIDfunc_LfpOnDown;
    save IdFigureData2 -append down_curves channel_curves structures_curves peak_value
    
    
%     PlotIDSleepData2
%     %title
%     title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' ('  Dir.manipe{p} ')'];
%     filename_fig = ['IDfigures2_' Dir.name{p}  '_' Dir.date{p}];
%     filename_png = [filename_fig  '.png'];
%     % suptitle
%     suplabel(title_fig,'t');
%     %save figure
%     savefig(filename_fig)
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     filename_png = fullfile(FolderFigureDelta, 'IDfigures','BasalDataSet','IDFigures2',filename_png);
%     saveas(gcf,filename_png,'png')
%     close all
    
    
end
