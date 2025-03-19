%%DeltaSingleChannelRipplesCorrelationPlot
% 11.03.2018 KJ
%
%   Compare delta waves detection for each location of PFCx
%   Look at their relations with ripples 
%
% see
%   DeltaSingleChannelRipplesCorrelation
%



% load
clear
load([FolderProjetDelta 'Data/DeltaSingleChannelRipplesCorrelation.mat'])
Dir = PathForExperimentsBasalSleepSpike;
smoothing=0;

for p=[1 5 9 13 15 17 19]
    
    %subplot dimension
    nx = numSubplots(length(correlo_res.channels{p}));
    ny = nx(1); nx = nx(2);
    
    %down ripples curves
    x_down_onset = Range(correlo_res.down.onset{p});
    y_down_onset = Smooth(Data(correlo_res.down.onset{p}),smoothing);

    x_downalone_onset = Range(correlo_res.down_alone.onset{p});
    y_downalone_onset = Smooth(Data(correlo_res.down_alone.onset{p}),smoothing);
    
    
    %plot
    figure, hold on
    for ch=1:length(correlo_res.channels{p})
        subplot(nx,ny,ch), hold on
        
        %delta ripples curves
        x_delta_onset = Range(correlo_res.delta.onset{p,ch});
        y_delta_onset = Smooth(Data(correlo_res.delta.onset{p,ch}),smoothing);
        
        plot(x_down_onset, y_down_onset,'b'), hold on
        plot(x_downalone_onset, y_downalone_onset,'r'), hold on
        plot(x_delta_onset, y_delta_onset,'c'), hold on
        
        legend('down','down alone','delta'), ylim([0 1]), hold on
        ylabel('probability'), xlabel('ms')

        %title with info
        title_fig = ['ch ' num2str(correlo_res.channels{p}(ch)) '-'];
        title(title_fig)
        set(gca, 'fontsize',8), hold on

        
    end
    
    suplabel([correlo_res.name{p}  ' - ' Dir.date{p} ' ('  correlo_res.manipe{p} ')'], 't');
        
end

