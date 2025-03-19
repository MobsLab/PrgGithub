% Figure3PowerDensityPlot2
% 06.12.2016 KJ
%
% Collect data to plot the figures from the Figure3.pdf - e, of Gaetan PhD
% 
% 
%   see Figure3PowerDensity Figure3PowerDensityPlot
%


clear
load([FolderProjetDelta 'Data/Figure3PowerDensity.mat']) 

animals = figure3_res.name;
animals = unique(animals(~cellfun('isempty',animals)));

scattersize = 15;

%loop over animals

figure, hold on
for m=1:4  
    down_durations = [];
    up_durations = [];
    so_amplitudes = [];
    
    for p=1:length(figure3_res.path)
        if strcmpi(figure3_res.name{p},animals{m}) 
            down_durations = [down_durations figure3_res.graphE.down_durations{p}/10];
            up_durations = [up_durations figure3_res.graphE.up_durations{p}/10];
            so_amplitudes = [so_amplitudes figure3_res.graphE.so_amplitudes{p}];
        end
    end
    
    bad_down = down_durations>300;
    bad_up = up_durations > 500000 | up_durations<300;
    
    down_durations(bad_down|bad_up)=[];
    up_durations(bad_down|bad_up)=[];
    so_amplitudes(bad_down|bad_up)=[];
    
    c = log(so_amplitudes);
    
    %plot
    subplot(2,2,m), hold on
    scatter(down_durations, up_durations, scattersize, c, 'filled','o'), hold on
    set(gca,'YScale','log'), hold on
    xlabel('Down duration (ms)'), ylabel('Up duration(ms)');
    title(animals{m});

end









