%%ParcoursHomeostasisAllnightsFakePlot2
% 24.08.2019 KJ
%
% Infos
%   script about real and fake slow waves
%
% see
%    FakeSlowWaveOneNight1 ParcoursHomeostasisAllnightsFakePlot ParcoursHomeostasisAllnightsFake


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
    
    
    %time of beginning of NREM
    start_night(p) = min(Range(Qdensity.down)/3600e4);

    
    %slopes for the beginning of the night
    windowslope = 4*3600e4; %4h
    
    slope_distance   = CompareDecreaseDensity(Data(Qdensity.down), Data(Qdensity.deep.good), Range(Qdensity.down)/3600e4);
    
    
    
end








% 
% sz = 25;
% 
% figure, hold on
% 
% for p=1:length(homeo_res.path)
% 
%     %get data
%     Qdensity.deep.good = homeo_res.Qdensity.deep.good{p};
%     Qdensity.deep.fake = homeo_res.Qdensity.deep.fake{p};
%     Qdensity.sup.good = homeo_res.Qdensity.sup.good{p};
%     Qdensity.sup.fake = homeo_res.Qdensity.sup.fake{p};
%     
%     Qdensity.down = homeo_res.Qdensity.down{p};
%     
%     %down states
%     subplot(3,1,1), hold on
%     scatter(Range(Qdensity.down)/3600e4, Data(Qdensity.down), sz, 'filled'),
%     title('down state'),
%     
%     %good deep
%     subplot(3,1,2), hold on
%     scatter(Range(Qdensity.deep.good)/3600e4, Data(Qdensity.deep.good)*4, sz, 'filled'),
%     title('good delta deep'),
%     
%     %fake deep
%     subplot(3,1,3), hold on
%     scatter(Range(Qdensity.deep.fake)/3600e4, Data(Qdensity.deep.fake)*4, sz, 'filled'),
%     title('fake delta deep'),
%     
% end
% 
% 
% 
% 
% 














