%%TonesInDownNeuronIDfigures
% 04.09.2018 KJ
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


for p=1%:length(Dir.path)
    disp(' ')
    disp('****************************************************************')
    eval(['cd(Dir.path{',num2str(p),'}'')'])
    disp(pwd)
    
    clearvars -except Dir p
    
    %params
    t_start = -15000;
    t_end   = 15000;
    binsize = 50;
    binsize_mua = 2;
    minDuration = 40;
    intv_success_down = 1000; %100ms
    intv_success_up = 500; %50ms
    

    %% load
    
    load('SpikeData.mat', 'S')
    % Substages
    load('SleepSubstages.mat', 'Epoch')
    N1 = Epoch{1}; N2 = Epoch{2}; N3 = Epoch{3}; REM = Epoch{4}; Wake = Epoch{5}; NREM = Epoch{7}; 
    % tones
    load('behavResources.mat', 'ToneEvent')
    
    %% MUA

    %MUA
    MUA  = GetMuaNeurons_KJ('PFCx', 'binsize',binsize_mua); 

    %Down
    down_PFCx = FindDownKJ(MUA, 'low_thresh', 0.5, 'minDuration', minDuration,'maxDuration', 600, 'mergeGap', 10, 'predown_size', 30, 'method', 'mono');
    st_down   = Start(down_PFCx);
    end_down  = End(down_PFCx);
    %Up
    up_PFCx = intervalSet(end_down(1:end-1), st_down(2:end));
    st_up = Start(up_PFCx);
    end_up = End(up_PFCx);
    
    %% Tones
    ToneNREM = Restrict(ToneEvent, NREM);
    ToneDown = Restrict(ToneNREM, down_PFCx);
    ToneUp   = Restrict(ToneNREM, up_PFCx);
   
    

    %% Raster PETH
    for i=1:length(S)
        
        figure, hold on
        
        %tones in wake
        peth_tsd = PETH_tsd(S{i}, Restrict(ToneEvent, Wake), t_start, t_end, binsize);
        subplot(4,1,1), hold on
        
        dArea =  Data(peth_tsd);
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        if max(dArea) > 0
            set(gca, 'YLim', [0 max(dArea) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Tones in wake (n=' num2str(length(Restrict(ToneEvent, Wake))) ')'])
        
        % tones in up
        peth_tsd = PETH_tsd(S{i}, ToneUp, t_start, t_end, binsize);
        subplot(4,1,2), hold on
        dArea =  Data(peth_tsd);
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        if max(dArea) > 0
            set(gca, 'YLim', [0 max(dArea) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Tones in Up (n=' num2str(length(ToneUp)) ')'])
        
        % tones in down
        peth_tsd = PETH_tsd(S{i}, ToneDown, t_start, t_end, binsize);
        subplot(4,1,3), hold on
        dArea =  Data(peth_tsd);
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        if max(dArea) > 0
            set(gca, 'YLim', [0 max(dArea) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Tones in Down (n=' num2str(length(ToneDown)) ')'])
        
        % tones in NREM
        peth_tsd = PETH_tsd(S{i}, ToneNREM, t_start, t_end, binsize);
        subplot(4,1,4), hold on
        dArea =  Data(peth_tsd);
        area(Range(peth_tsd, 'ms'), Data(peth_tsd), 'FaceColor', 'k');
        if max(dArea) > 0
            set(gca, 'YLim', [0 max(dArea) * 1.2]);
        end
        yl = get(gca, 'YTick');
        yl = yl(yl==floor(yl));
        set(gca, 'YTick', yl);
        title(['Tones in NREM (n=' num2str(length(ToneNREM)) ')'])
    
        %title
        title_fig = [Dir.name{p}  ' - ' Dir.date{p} ' (neuron '  num2str(i) ')'];
        filename_fig = ['IDneurons_' Dir.name{p}  '_' Dir.date{p} '_neuron_' num2str(i)];
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



