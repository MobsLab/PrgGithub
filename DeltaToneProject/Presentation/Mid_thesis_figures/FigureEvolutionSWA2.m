% FigureEvolutionSWA2
% 14.12.2016 KJ
%
% Plot the rate success for random tone relative to the delay between the
% tone and the preceeding delta/down
% 
% 
%   see Figure3PowerDensityPlot2 FigureRandomDelaySuccess1
%


clear
load([FolderProjetDelta 'Data/Figure3PowerDensity.mat']) 

animals = figure3_res.name;
animals = unique(animals(~cellfun('isempty',animals)));

scattersize = 15;

%selected night
%list_path = [1 2 3 4 25 26 59 72 73 30 44 45 46 70 75 71]; %test
list_path = [1 2 25 26 59];

i=0;
for p=list_path  
    i=i+1;
    figure, hold on
    down_durations = figure3_res.graphE.down_durations{p}/10;
    up_durations = figure3_res.graphE.up_durations{p}/10;
    so_amplitudes = figure3_res.graphE.so_amplitudes{p};
    
    bad_down = down_durations>500;
    bad_up = up_durations > 500000 | up_durations<200;
    
    down_durations(bad_down|bad_up)=[];
    up_durations(bad_down|bad_up)=[];
    so_amplitudes(bad_down|bad_up)=[];
    
    c = log(so_amplitudes);
    
    %plot
    scatter(down_durations, up_durations, scattersize, c, 'filled','o'), hold on
    set(gca,'YScale','log'), hold on
    xlim([50 300]), 
    xlabel('Down duration (ms)'), ylabel('Up duration(ms)');
    title(figure3_res.path{p});
        
    %save figure
    filename_eps = ['FigureEvolutionSWA2_' num2str(i) '.eps'];
    cd('/home/mobsjunior/Dropbox/Mobs_member/KarimJr/Presentation/Mid-thesis/Figure/')
    saveas(gcf,filename_eps,'epsc')
    close all

end






