%%ToneInDownRasterNeuronPlot2
% 18.04.2018 KJ
%
% raster of tones around down states
%
%   see 
%       ToneInDownRasterNeuron
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneInDownRasterNeuron.mat'))

%{'inside', 'outside', 'around'}
select_tone = 'inside'; 
%{'before','after','postdown'}
select_order = 'before';


for p=1:length(tones_res.path)
    for i=1:length(neuron_pop)
        select_neurons = neuron_pop{i};
        raster_tsd = tones_res.rasters.(select_tone).(select_neurons){p};
        x_mua = Range(raster_tsd);
        MatMUA{i,p} = Data(raster_tsd)';

        if ~strcmpi(select_tone,'outside')
            [~,idx_order] = sort(tones_res.(select_tone).(select_order){p});
            MatMUA{i,p} = MatMUA{i,p}(idx_order, :);
        end
    end
end


%% Plot
gap = [0.04 0.02];

%color map style
co=jet;
co(1,:)=[0 0 0]; %silences (M=0) are in black


for p=1:length(tones_res.path)
    
    figure, hold on
    colormap(co);
    
    for i=1:length(neuron_pop)
        subtightplot(1,length(neuron_pop),i, gap), hold on
        imagesc(x_mua/1E4, 1:size(MatMUA{i,p} ,1), MatMUA{i,p} ), hold on
        axis xy, hold on
        line([0 0], ylim,'Linewidth',2,'color','w'), hold on
        line([0.025 0.025], ylim,'Linewidth',1,'color',[0.7 0.7 0.7]), hold on
        set(gca,'YLim', [0 size(MatMUA{i,p} ,1)], 'XLim',[-0.5 0.5]);
        set(gca, 'Xticklabel',{});
        
        if i==1
            ylabel('# tones'),
            title([tones_res.name{p} ' (' tones_res.manipe{p} ')']),
        else
            title(neuron_pop{i}),
        end

    end
    
end




