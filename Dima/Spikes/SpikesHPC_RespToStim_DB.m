
%% Parameters
clear all
nmouse = [797 798 828 861 882 905 906 911 912 977 994 1161 1162 1168 1182 1186];
% nmouse = 1117;
wi = 1.5;
nbins = 60;

%% Get data
Dir = PathForExperimentsERC('UMazePAG');
% Dir = PathForExperimentsERC('StimMFBWake');
Dir = RestrictPathForExperiment(Dir,'nMice',nmouse);
foldertosave = ChooseFolderForFigures_DB('Spikes');

% Allocate memory
spikes  = cell(length(Dir.path), 1);
QT = cell(length(Dir.path), 1);
stims  = cell(length(Dir.path), 1);
cell_ids = cell(length(Dir.path), 1);

for imouse = 1:length(Dir.path)
    spikes{imouse} = load([Dir.path{imouse}{1} 'SpikeData']);
    stims{imouse} = load([Dir.path{imouse}{1} 'behavResources.mat'],'TTLInfo',...
        'AlignedXtsd', 'AlignedYtsd', 'Vtsd', 'SessionEpoch');
    
    cell_ids{imouse} = zeros(length(spikes{imouse}.S), 1);
    
    Q = MakeQfromS(spikes{imouse}.S,0.05*1e4);
    time = Range(Q)/1e4;
    data = full(Data(Q));
    for icell = 1:length(spikes{imouse}.BasicNeuronInfo.idx_SUA)
        QT{imouse}{icell} = [time zscore(data(:,spikes{imouse}.BasicNeuronInfo.idx_SUA(icell)))];
        cell_ids{imouse}(icell) = spikes{imouse}.BasicNeuronInfo.idx_SUA(icell);
    end
    cell_ids{imouse} = nonzeros(cell_ids{imouse});
end

%% Do PETH
cells_ids_pooled = cell(1, 5e3);
cnt = 1;
for imouse = 1:length(Dir.path)
    for icell = 1:size(QT{imouse},2)
        [r,i] = Sync(QT{imouse}{icell}, Start(stims{imouse}.TTLInfo.StimEpoch)/1e4 ,'durations',[-wi wi]);
        T = SyncMap(r,i,'durations',[-wi wi],'nbins',nbins,'smooth',0);
        output(cnt,:) = mean(T);
        
        cell_ids_pooled{cnt} = [imouse cell_ids{imouse}(icell)];
        cnt = cnt+1;
    end
end
cell_ids_pooled = cell_ids_pooled(~cellfun('isempty',cell_ids_pooled));

%% Sort
[a,stimactid] = sort(mean(output(:,31:50),2)); % sorted by mu
Sweeps_toplot = output(stimactid,:);
cell_ids_sorted = cell_ids_pooled(stimactid);

%% Plot
f0 = figure ('units', 'normalized','outerposition', [0 1 0.3 0.8]);
imagesc([-1450:50:1500],[1:size(QT,2)],Sweeps_toplot)
hold on
line([0 0], ylim, 'Color', 'k', 'Linewidth',2)
colormap jet
set(gca,'LineWidth',3,'FontSize',18,'FontWeight','bold');
xlabel('Time around PAG stim (ms)')
ylabel('# neuron')
% caxis([-1 7])
% Save
saveas(f0, [foldertosave '/PETH_stim.fig']);
saveFigure(f0, 'PETH_stim', foldertosave);

%% Plot rate maps of shock-responsive cells

% % Calculate place fields
% cnt2=0;
% for icell = 500:length(cell_ids_sorted)
%     cnt2=cnt2+1;
%     cellid = cell_ids_sorted{icell};
%     if strcmp(Dir.name{cellid(1)}, 'Mouse1161')
%         SessionHab = or(stims{cellid(1)}.SessionEpoch.Hab1, stims{cellid(1)}.SessionEpoch.Hab2);
%     else
%         SessionHab = stims{cellid(1)}.SessionEpoch.Hab;
%     end
%     
%     [map{cnt2}, ~, stats{cnt2}, px{cnt2}, py{cnt2}, FR{cnt2}] = PlaceField_DB(spikes{cellid(1)}.S{cellid(2)},...
%             stims{cellid(1)}.AlignedXtsd, stims{cellid(1)}.AlignedYtsd, 'Epoch', ...
%             SessionHab, 'PlotResults',0, 'PlotPoisson',0);
% end
% 
% 
% % Number of rows and columns
% nrows = round(sqrt(cnt2));
% ncols = ceil(sqrt(cnt2));
% 
% % Rate map figure
% f1 = figure ('units', 'normalized','outerposition', [0 0 1 1]);
% for isp = 1:cnt2
%     subplot(nrows, ncols, isp);
%     if ~isempty(map{isp})
%         imagesc(map{isp}.rate);
%         axis xy
%         colormap jet
%         title([Dir.name{cell_ids_sorted{500-1+isp}(1)} ',FR=' num2str(round(FR{isp},2)) ' Hz, SpI=',...
%             num2str(round(stats{isp}.spatialInfo,2))], 'FontSize', 7);
%     end
% end
% mtit(f1, 'Rate maps of shock cells', 'FontSize', 16, 'xoff', 0, 'yoff', 0.035, 'zoff', 0.05);
% Save
% saveas(f1, [foldertosave '/placefields_shockcells.fig']);
% saveFigure(f1, 'placefields_shockcells', foldertosave);

% % Spike position figure
% f2 = figure ('units', 'normalized','outerposition', [0 0 1 1]);
% for isp = 1:cnt2
%     subplot(nrows, ncols, isp);
%     plot(Data(Restrict(Xtsd, SessionIS{isess})), Data(Restrict(Ytsd, SessionIS{isess})),...
%         'Color',[0.8 0.8 0.8]);
%     hold on
%     if ~isempty(px{isp, isess})
%         plot(px{isp, isess},py{isp, isess},'r.');
%     end
%     
%     [xl, yl] = DefineGoodFigLimits_2D(Data(Restrict(Xtsd, SessionIS{isess})),...
%         Data(Restrict(Ytsd, SessionIS{isess})));
%     xlim(xl);
%     ylim(yl);
%     title(['Cl' num2str(isp) ',FR=' num2str(round(FR{isp, isess},2)) ' Hz'])
% end