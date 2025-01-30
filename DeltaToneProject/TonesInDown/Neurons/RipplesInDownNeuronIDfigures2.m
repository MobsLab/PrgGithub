%%RipplesInDownNeuronIDfigures2
% 11.09.2018 KJ
%
%
%   
%
% see
%   
%


clear

Dir1=PathForExperimentsDeltaSleepSpikes('RdmTone');
Dir2=PathForExperimentsDeltaSleepSpikes('DeltaT0');
Dir = MergePathForExperiment(Dir1,Dir2);
Dir = CheckPathForExperiment_KJ(Dir);


for p=1:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    t_start = -5000;
    t_end   = 5000;
    binsize_peth = 100;
    binsize_mua = 2;
    minDuration = 40;

    %% load
    
    load('SpikeData.mat', 'S')
    % Substages
    load('SleepSubstages.mat', 'Epoch')
    N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7}; 
    % ripples
    load('Ripples.mat', 'Ripples')
    tRipples = ts(Ripples(:,2)*10);
    

    %% Raster PETH
    for i=1:length(S)
        
        % PETH in N1
        peth_tsd = PSTH_KJ(S{i}, Restrict(tRipples, N1), t_start, t_end, binsize_peth);
        
        subplot(3,1,1), hold on
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        set(gca, 'XLim', [t_start t_end]/10);
        if max(Data(peth_tsd)) > 0
            set(gca, 'YLim', [0 max(Data(peth_tsd)) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Ripples in N1 (n= ' num2str(length(Restrict(tRipples, N1))) ' tones)'])
        
        % PETH in N2
        peth_tsd = PSTH_KJ(S{i}, Restrict(tRipples, N2), t_start, t_end, binsize_peth);
        
        subplot(3,1,2), hold on
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        set(gca, 'XLim', [t_start t_end]/10);
        if max(Data(peth_tsd)) > 0
            set(gca, 'YLim', [0 max(Data(peth_tsd)) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Ripples in N2 (n= ' num2str(length(Restrict(tRipples, N2))) ' tones)'])
        
        % PETH in N3
        peth_tsd = PSTH_KJ(S{i}, Restrict(tRipples, N3), t_start, t_end, binsize_peth);
        
        subplot(3,1,3), hold on
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        set(gca, 'XLim', [t_start t_end]/10);
        if max(Data(peth_tsd)) > 0
            set(gca, 'YLim', [0 max(Data(peth_tsd)) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Ripples in N3 (n= ' num2str(length(Restrict(tRipples, N3))) ' tones)'])
        
        
        
        %% title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' (rip - neuron '  num2str(i) ')'];
        filename_fig = ['IDrip2_' Dir.name{p}  '_' Dir.date{p} '_neuron_' num2str(i)];
        filename_png = [filename_fig  '.png'];
        % suptitle
        suplabel(title_fig,'t');
        %save figure
        filename_png = fullfile(FolderFigureDelta,'IDfigures','TonesInDown','Neurons',filename_png);
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        saveas(gcf,filename_png,'png')
        close all
            
    end
    

end



