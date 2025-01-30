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
load([FolderProjetDelta 'Data/DeltaSingleChannelAnalysis.mat'])
Dir = PathForExperimentsBasalSleepSpike;


%colors
nb_clusters = 5;
colori = [distinguishable_colors(nb_clusters) ; 0.6 0.6 0.6];
for i=1:nb_clusters+1
    colori_cluster{i} = colori(i,:);
end
color_curve = {[0.4 0.4 0.4], colori_cluster{4}, colori_cluster{2}};

p=18;    
density = single_res.density;
namech = {'2-layers','channel cluster 4', 'channel cluster 2'};

k=0;
%plot
figure, hold on
for i=[13 4 8]
    k=k+1;
    subplot(3,1,k), hold on

    xd = density.x{p};
    d_down  = density.down{p};
    d_delta = density.delta{p}{i}; 

    %distances and similarities
    frechet_distance = round(DiscreteFrechetDist(d_down, d_delta),2);
    %regression

    idx_down = d_down > max(d_down)/8;
    idx_delta = d_delta > max(d_delta)/8;

    [p_down,~]  = polyfit(xd(idx_down), d_down(idx_down), 1);
    reg_down    = polyval(p_down,xd);
    [p_delta,~] = polyfit(xd(idx_delta), d_delta(idx_delta), 1);
    reg_delta   = polyval(p_delta,xd);

    h(1) = plot(xd, d_down, 'color', 'b'); hold on
    plot(xd, reg_down, 'color', 'b'), hold on
    h(2) = plot(xd, d_delta, 'color', color_curve{k}); hold on
    plot(xd, reg_delta, 'color', color_curve{k}),
    set(gca, 'XTickLabel',{''}), hold on

    lgd{1} = 'Down State';
    lgd{2} = [namech{k}  ' - distance ' num2str(frechet_distance)];
    
    
    legend(h, lgd),
    ylabel('per min'),

    y_lim = get(gca,'ylim'); y_lim(1)=0;
    ylim(y_lim); set(gca,'yticklabel',0.5:0.5:1.5)
    xlim([2 10]),

end
set(gca,'xticklabel',0:8)





