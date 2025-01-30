%%ParcoursHomeostasisAllnightsFakePlot
% 24.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 FakeSlowWaveOneNightHomeostasis ParcoursHomeostasisAllnightsFake


% load
clear
load(fullfile(FolderDeltaDataKJ,'ParcoursHomeostasisAllnightsFake.mat'))


for p=1:length(homeo_res.path)
    
    %get data
    Qdensity.deep.good = homeo_res.Qdensity.deep.good{p};
    Qdensity.deep.fake = homeo_res.Qdensity.deep.fake{p};
    Qdensity.sup.good = homeo_res.Qdensity.sup.good{p};
    Qdensity.sup.fake = homeo_res.Qdensity.sup.fake{p};
    
    Qdensity.down = homeo_res.Qdensity.down{p};
    
    
    figure, hold on
    
    %down and good deep
    subplot(4,1,1), hold on
    
    frechet_distance = DiscreteFrechetDist(Data(Qdensity.down), Data(Qdensity.deep.good));
%     slope_distance   = CompareDecreaseDensity(Data(Qdensity.down), Data(Qdensity.deep.good), Range(Qdensity.down)/3600e4);
    h(1) = plot(Range(Qdensity.down)/3600e4, Data(Qdensity.down), 'k');
    h(2) = plot(Range(Qdensity.deep.good)/3600e4, Data(Qdensity.deep.good)*4, 'b');
    title('down and good delta deep'),
    legend(h, 'down', ['delta (frechet=' num2str(frechet_distance) ')' ])
    
    
    %down and fake deep
    subplot(4,1,2), hold on
    
    frechet_distance = DiscreteFrechetDist(Data(Qdensity.down), Data(Qdensity.deep.fake));
%     slope_distance   = CompareDecreaseDensity(Data(Qdensity.down), Data(Qdensity.deep.fake), Range(Qdensity.down)/3600e4);
    h(1) = plot(Range(Qdensity.down)/3600e4, Data(Qdensity.down), 'k');
    h(2) = plot(Range(Qdensity.deep.fake)/3600e4, Data(Qdensity.deep.fake)*4, 'b');
    title('down and fake delta deep'),
    legend(h, 'down', ['delta (frechet=' num2str(frechet_distance) ')' ])
    
    
    %down and good sup
    subplot(4,1,3), hold on
    
    frechet_distance = DiscreteFrechetDist(Data(Qdensity.down), Data(Qdensity.sup.good));
%     slope_distance   = CompareDecreaseDensity(Data(Qdensity.down), Data(Qdensity.sup.good), Range(Qdensity.down)/3600e4);
    h(1) = plot(Range(Qdensity.down)/3600e4, Data(Qdensity.down), 'k');
    h(2) = plot(Range(Qdensity.sup.good)/3600e4, Data(Qdensity.sup.good)*4, 'b');
    title('down and good delta sup'),
    legend(h, 'down', ['delta (frechet=' num2str(frechet_distance) ')' ])
    
    
    %down and fake sup
    subplot(4,1,4), hold on
    
    frechet_distance = DiscreteFrechetDist(Data(Qdensity.down), Data(Qdensity.sup.fake));
%     slope_distance   = CompareDecreaseDensity(Data(Qdensity.down), Data(Qdensity.sup.fake), Range(Qdensity.down)/3600e4);
    h(1) = plot(Range(Qdensity.down)/3600e4, Data(Qdensity.down), 'k');
    h(2) = plot(Range(Qdensity.sup.fake)/3600e4, Data(Qdensity.sup.fake)*4, 'b');
    title('down and fake delta sup'),
    legend(h, 'down', ['delta (frechet=' num2str(frechet_distance) ')' ])
    
    %title
    suplabel([homeo_res.name{p} ' - ' homeo_res.date{p}], 't');
    
end







