%%DeltaSingleChannelDensityPlot
% 10.03.2018 KJ
%
%   Plot down and delta density for PFCx channels
%   -> plot  
%
% see
%   DeltaMultiChannelAnalysis2 DeltaSingleChannelAnalysis
%


% load
clear
load(fullfile(FolderDeltaDataKJ,'DeltaSingleChannelAnalysis.mat'))
Dir = PathForExperimentsBasalSleepSpike;

for p=9:12%:length(single_res.path)
    
    %subplot dimension
    nx = numSubplots(length(single_res.channels{p}));
    ny = nx(1); nx = nx(2);
    
    density = single_res.density;
    %plot
    figure, hold on
    for i=1:length(single_res.channels{p})
        subplot(nx,ny,i), hold on
        
        xd = density.x{p};
        d_down  = density.down{p};
        d_delta = density.delta{p}{i}; 
        
        %distances and similarities
        frechet_distance = DiscreteFrechetDist(d_down, d_delta);
        %regression
        
        idx_down = d_down > max(d_down)/8;
        idx_delta = d_delta > max(d_delta)/8;
        
        [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
        reg_down    = polyval(p_down,xd);
        [p_delta,~] = polyfit(xd(idx_delta), d_delta(idx_delta), 1);
        reg_delta   = polyval(p_delta,xd);
        
        h(1) = plot(xd, d_down, 'color', 'b'); hold on
        plot(xd, reg_down, 'color', 'b'), hold on
        h(2) = plot(xd, d_delta, 'color', 'r'); hold on
        plot(xd, reg_delta, 'color', 'r'),
        set(gca, 'XTickLabel',{''}), hold on
        
        if i==1
            legend(h, 'down states','delta waves'),
        end

        %title with info
        title_fig = ['ch ' num2str(single_res.channels{p}(i)) '-'];
        title_fig = [title_fig ' dw:' num2str(single_res.down_only{p}(i))];
        title_fig = [title_fig ' dt:' num2str(single_res.delta_only{p}(i))];
        title_fig = [title_fig ' b:' num2str(single_res.down_delta{p}(i))];
        title_fig = [title_fig ' Dist:' num2str(round(frechet_distance,3))];
        title(title_fig)
        set(gca, 'fontsize',8), hold on
        
        y_lim = get(gca,'ylim'); y_lim(1)=0;
        ylim(y_lim);
        
    end
    
    suplabel([single_res.name{p}  ' - ' Dir.date{p} ' ('  single_res.manipe{p} ')'], 't');
        
end


