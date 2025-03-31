% PlotOneIsiCurve
% 03.10.2018 KJ
%
%       
%
% SEE 
%   PlotOneMotherCurve PlotOneDensityCurve
%

clear
load(fullfile(FolderSlowDynData,'QuantifSlowWaveSlowDyn.mat'))

%rec
records = [167864, 96579, 176286];


%% Plot
figure, hold on

for r=1:length(records)

    p = find(cell2mat(quantif_res.filereference)==records(r));
    
    y_isi = quantif_res.y_isi{p} / sum(quantif_res.y_isi{p});
    
    [~, idx] = max(y_isi);
    m = quantif_res.x_isi{p}(idx);
    
    subplot(2,3,r), hold on
    bar(quantif_res.x_isi{p}, y_isi), hold on
    line([m m], ylim, 'color', [0.3 0.3 0.3]), hold on
    xlim([min(edges),edges(end-1)]),
    xlabel('Inter SW Interval (ms)'),
    if r==1
        ylabel('probability'),
    end
    title([num2str(quantif_res.age{p}) ' y-o / peak = ' num2str(m) 'ms']),
    
    set(gca, 'xlim', [0 4000], 'fontsize', 20),
end





