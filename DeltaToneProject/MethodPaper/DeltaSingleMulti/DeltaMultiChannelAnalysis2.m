%%DeltaMultiChannelAnalysis2
% 07.03.2018 KJ
%
%   Find which pair of PFCx channels is the best for the detection of delta/down
%   -> analysis  
%
% see
%   DetectDeltaDepthMultiChannel DeltaMultiChannelAnalysis
%


% load
clear
load([FolderProjetDelta 'Data/DeltaMultiChannelAnalysis.mat'])
Dir=PathForExperimentsBasalSleepSpike;

for p=5:8%1:length(multi_res.path)

    %subplot dimension
    nx = numSubplots(length(multi_res.duo_channels{p}));
    ny = nx(1); nx = nx(2);
    
    density = multi_res.density{p};
    %plot
    figure, hold on
    for i=1:length(multi_res.duo_channels{p})
        subplot(nx,ny,i), hold on
        
        %distances and similarities
        frechet_distance = DiscreteFrechetDist(density.down, density.delta{i});        
        
        plot(density.x, density.down, 'color', 'b'), hold on
        plot(density.x, density.delta{i}, 'color', 'r'),
        set(gca, 'XTickLabel',{''}), hold on
        
        if i==1
            legend('down states','delta waves'),
        end

        %title with info
        title_fig = ['ch ' num2str(multi_res.duo_channels{p}(i,1)) '-' num2str(multi_res.duo_channels{p}(i,2))];
        title_fig = [title_fig ' dw:' num2str(multi_res.down_only{p}(i))];
        title_fig = [title_fig ' dt:' num2str(multi_res.delta_only{p}(i))];
        title_fig = [title_fig ' b:' num2str(multi_res.down_delta{p}(i))];
        title_fig = [title_fig ' Dist:' num2str(round(frechet_distance,3))];
        title(title_fig)
        set(gca, 'fontsize',8), hold on
        
    end
    
    suplabel([multi_res.name{p}  ' - ' Dir.date{p} ' ('  multi_res.manipe{p} ')'], 't');
        
end


