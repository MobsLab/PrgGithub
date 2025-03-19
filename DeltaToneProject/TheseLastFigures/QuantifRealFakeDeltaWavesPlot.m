%%QuantifRealFakeDeltaWavesPlot
% 12.09.2019 KJ
%
%   
%   
%
% see
%   QuantifRealFakeDeltaWaves CharacterisationDeltaDownStates




% load
clear
load(fullfile(FolderDeltaDataKJ,'QuantifRealFakeDeltaWaves.mat'))

animals = unique(quantif_res.name);



%Whole night
for m=1:length(animals)

    mouse.deep.recall    = [];
    mouse.deep.precision = [];
    mouse.sup.recall     = [];
    mouse.sup.precision  = [];
    for p=1:length(quantif_res.path)
        if strcmpi(quantif_res.name{p},animals{m})
            mouse.deep.recall(end+1,1)    = quantif_res.deep.nb_real{p} / quantif_res.nb_down{p};
            mouse.deep.precision(end+1,1) = quantif_res.deep.nb_real{p} / quantif_res.deep.nb_delta{p};
            mouse.sup.recall(end+1,1)    = quantif_res.sup.nb_real{p} / quantif_res.nb_down{p};
            mouse.sup.precision(end+1,1) = quantif_res.sup.nb_real{p} / quantif_res.sup.nb_delta{p};
        end
    end
    
    %NREM
    nrem.deep.recall(m,1)     = mean(mouse.deep.recall);
    nrem.deep.precision(m,1)  = mean(mouse.deep.precision);
    nrem.sup.recall(m,1)      = mean(mouse.sup.recall);
    nrem.sup.precision(m,1)   = mean(mouse.sup.precision);
    
end


%Substages
for s=1:3
    for m=1:length(animals)

        mouse.deep.recall    = [];
        mouse.deep.precision = [];
        mouse.sup.recall     = [];
        mouse.sup.precision  = [];
        for p=1:length(quantif_res.path)
            if strcmpi(quantif_res.name{p},animals{m})
                mouse.deep.recall(end+1,1)    = quantif_res.deep.sub.nb_real{p,s} / quantif_res.sub.nb_down{p,s};
                mouse.deep.precision(end+1,1) = quantif_res.deep.sub.nb_real{p,s} / quantif_res.deep.sub.nb_delta{p,s};
                mouse.sup.recall(end+1,1)    = quantif_res.sup.sub.nb_real{p,s} / quantif_res.sub.nb_down{p,s};
                mouse.sup.precision(end+1,1) = quantif_res.sup.sub.nb_real{p,s} / quantif_res.sup.sub.nb_delta{p,s};
            end
        end

        %NREM
        substages.deep.recall(m,s)     = mean(mouse.deep.recall);
        substages.deep.precision(m,s)  = mean(mouse.deep.precision);
        substages.sup.recall(m,s)      = mean(mouse.sup.recall);
        substages.sup.precision(m,s)   = mean(mouse.sup.precision);

    end
end


%% data plot

data_recall.deep = 100*(1-[nrem.deep.recall substages.deep.recall]);
data_recall.sup = 100*(1-[nrem.sup.recall substages.sup.recall]);
data_precision.deep = 100*(1-[nrem.deep.precision substages.deep.precision]);
data_precision.sup = 100*(1-[nrem.sup.precision substages.sup.precision]);



%% PLOT

figure, hold on
show_sig = 'sig';


% Recall deep
subplot(2,2,1), hold on
PlotErrorBarN_KJ(data_recall.deep, 'newfig',0, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca, 'xlim',[0 5], 'ylim',[0 100],'ytick',0:20:100),
set(gca, 'XTick',1:4 ,'XTickLabel',{'NREM','N1','N2','N3'})
ylabel('% missed')
title('Deep deltas')

% Precision deep
subplot(2,2,2), hold on
PlotErrorBarN_KJ(data_precision.deep, 'newfig',0, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca, 'xlim',[0 5], 'ylim',[0 100],'ytick',0:20:100),
set(gca, 'XTick',1:4 ,'XTickLabel',{'NREM','N1','N2','N3'})
ylabel('% fake')
title('Deep deltas')


% Recall sup
subplot(2,2,3), hold on
PlotErrorBarN_KJ(data_recall.sup, 'newfig',0, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca, 'xlim',[0 5], 'ylim',[0 100],'ytick',0:20:100),
set(gca, 'XTick',1:4 ,'XTickLabel',{'NREM','N1','N2','N3'})
ylabel('% missed')
title('Sup deltas')

% Precision deep
subplot(2,2,4), hold on
PlotErrorBarN_KJ(data_precision.sup, 'newfig',0, 'paired',1, 'ShowSigstar',show_sig); hold on
set(gca, 'xlim',[0 5], 'ylim',[0 100],'ytick',0:20:100),
set(gca, 'XTick',1:4 ,'XTickLabel',{'NREM','N1','N2','N3'})
ylabel('% fake')
title('Sup deltas')










