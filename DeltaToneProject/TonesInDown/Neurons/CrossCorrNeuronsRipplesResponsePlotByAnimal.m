%%CrossCorrNeuronsRipplesResponsePlotByAnimal
% 18.09.2018 KJ
%
%   Cross-correlogram between population of neurons
%
% see
%   CrossCorrNeuronsRipplesResponse_KJ CrossCorrNeuronsRipplesResponsePlot
%



%load
clear

load(fullfile(FolderDeltaDataKJ,'CrossCorrNeuronsRipplesResponse_KJ.mat'))
animals = unique(ccneur_res.name);


for m=1:length(animals)

    
    %% Pool
    CC.predown = [];
    CC.postdown = [];
    CC.night = [];
    for p=1:length(ccneur_res.path)
        CC.predown  = [CC.predown ; ccneur_res.predown{p}'];
        CC.postdown = [CC.postdown ; ccneur_res.postdown{p}'];
        CC.night    = [CC.night ; ccneur_res.nightCc{p}'];
    end

    for s=1:5
        CC.substage{s} = [];
        for p=1:length(ccneur_res.path)
            CC.substage{s} = [CC.substage{s}; ccneur_res.substagesCc{p,s}'];
        end
    end
    t_corr = ccneur_res.t_corr{1};


    %% Plot
    figure, hold on

    subplot(2,3,1), hold on
    plot(t_corr, CC.predown), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3')
    xlim([-15 15]),
    title('Correlo before Down'),

    subplot(2,3,2), hold on
    plot(t_corr, CC.postdown), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3'),
    xlim([-15 15]),
    title('Correlo after Down'),

    subplot(2,3,3), hold on
    plot(t_corr, CC.substage{5}), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3'),
    xlim([-15 15]),
    title('Correlo in Wake'),

    subplot(2,3,4), hold on
    plot(t_corr, CC.night), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3'),
    xlim([-15 15]),
    title('Correlo whole night'),

    subplot(2,3,5), hold on
    plot(t_corr, CC.substage{2}), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3'),
    xlim([-15 15]),
    title('Correlo in N2'),

    subplot(2,3,6), hold on
    plot(t_corr, CC.substage{3}), hold on
    line([0 0], get(gca,'ylim'),'color', [0.7 0.7 0.7]),
    xlabel('time from groupe 2 (ms)'), ylabel('group 3'),
    xlim([-15 15]),
    title('Correlo in N3'),
    
    suplabel(animals{m},'t');
    
end




