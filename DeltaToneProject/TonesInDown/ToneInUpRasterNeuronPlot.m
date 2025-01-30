%%ToneInUpRasterNeuronPlot
% 18.04.2018 KJ
%
% raster of tones around down states
%
%   see 
%       ToneInUpRasterNeuron ToneInDownRasterNeuronPlot
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneInUpRasterNeuron.mat'))

%{'inside'}
select_tone = 'inside'; 

% {'all','excited','neutral','inhibit'}
select_neurons = 'all';

%{'before','after','postup','postdown'}
select_order = 'postdown';


%% Plot
figure, hold on
gap = [0.08 0.04];

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black
colormap(co);

npath = 4;% length(tones_res.path);
for p=1:npath
    
    raster_tsd = tones_res.rasters.(select_tone).(select_neurons){p};
    x_mua = Range(raster_tsd);
    MatMUA = Data(raster_tsd)';
    
    if ~strcmpi(select_tone,'outside')
        [~,idx_order] = sort(tones_res.(select_tone).(select_order){p});
        MatMUA = MatMUA(idx_order, :);
    end
    
    %raster
    subtightplot(2,npath/2,p, gap), hold on
    imagesc(x_mua/1E4, 1:size(MatMUA,1), MatMUA), hold on
    axis xy, hold on
    line([0 0], ylim,'Linewidth',2,'color','w'), hold on
    line([0.04 0.04], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
    
    yyaxis right
    y_mua = mean(MatMUA,1);
    y_mua = Smooth(y_mua ,1);
    y_mua = y_mua / mean(y_mua(x_mua<-1e4));
    
    plot(x_mua/1E4, y_mua, 'color', 'w', 'linewidth', 2);
    
    yyaxis left
    set(gca,'YLim', [0 size(MatMUA,1)], 'XLim',[-0.5 2]);
    title([tones_res.name{p} ' (' tones_res.manipe{p} ')']),
    
    
    %xlabel, ylabel
    if p==1 || p==3
        ylabel('# tones'),
    end
    
end

