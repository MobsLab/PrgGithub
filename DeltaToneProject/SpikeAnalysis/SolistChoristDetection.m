% SolistChoristDetection
% 22.12.2016 KJ
%
% 
% 
% 
%   see 
%



%% Dir

%Dir = PathForExperimentsDeltaKJHD('all');
Dir = PathForExperimentsDeltaSleepSpikes('all');

clearvars -except Dir

%condition 
Dir.condition=Dir.manipe;
for p=1:length(Dir.path)
    if strcmpi(Dir.manipe{p},'DeltaToneAll')
        Dir.condition{p} = ['Tone ' num2str(Dir.delay{p}*1000) 'ms'];
    end
end


%% loop over records
for p=1:length(Dir.path)
    try
        disp(' ')
        disp('****************************************************************')
        eval(['cd(Dir.path{',num2str(p),'}'')'])
        disp(pwd)

        clearvars -except Dir p
        %params
        binsize_cc = 10;
        nbins_cc = 500;

        %% Load
        %Epoch and Spikes
        load StateEpochSB SWSEpoch Wake REMEpoch
        
        %MUA
        load SpikeData
        eval('load SpikesToAnalyse/PFCx_Neurons')
        NumNeurons=number;
        clear number
        
        %Down states
        try
            load newDownState Down
        catch
            try
                load DownSpk Down
            catch
                Down = intervalSet([],[]);
            end
        end
        start_down = Start(Down);
        end_down = End(Down);
        tdowns = (Start(Down)+End(Down)/2);
        
        
        %% Soloist vs Chorist
        
        Ssws=Restrict(S,SWSEpoch);
        nb_neuron = length(NumNeurons);
        
        for i=1:length(NumNeurons)
            num=1:length(NumNeurons);
            num(i)=[];
            [Cc(i,:), Bc] = CrossCorr(Range(Ssws{NumNeurons(i)}),Range(PoolNeurons(Ssws,NumNeurons(num))), binsize_cc, nbins_cc);
        end
        
        Cc_norm = Cc;
        Cc_norm(isnan(Cc_norm))=0;
        Cc_norm=zscore(Cc_norm')';
        Cc_norm=SmoothDec(Cc_norm,[0.001 3]);
        
        Chorist_idx = [];
        Soloist_idx = [];
        for i=1:length(NumNeurons)
            if mean(Cc_norm(i,240:260)) > mean(Cc_norm(i,1:200))
                Chorist_idx = [Chorist_idx i];
            else
                Soloist_idx = [Soloist_idx i];
            end
        end

        %% Correlogram down-delta soloist
        for i=1:length(Soloist_idx)
            [Cc_solo(i,:), Bc] = CrossCorr(Range(Ssws{NumNeurons(Soloist_idx(i))}), start_down, binsize_cc, nbins_cc);
        end
        for i=1:length(Soloist_idx)
            [Cc_down_solo(i,:), Bc] = CrossCorr(start_down, Range(Ssws{NumNeurons(Soloist_idx(i))}), binsize_cc, nbins_cc);
        end
        
        %% Correlogram down-delta chorist 
        for i=1:length(Chorist_idx)
            [Cc_chor(i,:), Bc] = CrossCorr(Range(Ssws{NumNeurons(Chorist_idx(i))}), start_down, binsize_cc, nbins_cc);
        end
        for i=1:length(Chorist_idx)
            [Cc_down_chor(i,:), Bc] = CrossCorr(start_down, Range(Ssws{NumNeurons(Chorist_idx(i))}), binsize_cc, nbins_cc);
        end
        
        
        %% plot
        figure, hold on
        
        %soloist
        subplot(2,2,1),hold on
        try
            y1 = SmoothDec(zscore(Cc_solo')',[0.001 3]);
        catch
            y1 = SmoothDec(zscore(Cc_solo')',3);
        end
        plot(Bc, y1);
        title('Down states on Soloist')
        
        subplot(2,2,2),hold on
        try
            y2 = SmoothDec(zscore(Cc_down_solo')',[0.001 3]);
        catch
            y2 = SmoothDec(zscore(Cc_down_solo')',3);
        end
        plot(Bc, y2);
        title('Soloist on Down states')
        
        %chorist
        subplot(2,2,3),hold on
        try
            y3 = SmoothDec(zscore(Cc_chor')',[0.001 3]);
        catch
            y3 = SmoothDec(zscore(Cc_chor')',3);
        end
        plot(Bc, y3);
        title('Down states on Chorist')
        
        subplot(2,2,4),hold on
        try
            y4 = SmoothDec(zscore(Cc_down_chor')',[0.001 3]);
        catch
            y4 = SmoothDec(zscore(Cc_down_chor')',3);
        end
        plot(Bc, y4);
        title('Chorist on Down states')
        
        
        %% save fig
        %title
        filename_fig = ['SolistChoristDetection_' Dir.name{p}  '_' Dir.date{p}];
        filename_png = [filename_fig  '.png'];
        %save figure
        cd([FolderFigureDelta 'IDfigures/Soloist/'])
        saveas(gcf,filename_png,'png')
        close all
        
    end
end





