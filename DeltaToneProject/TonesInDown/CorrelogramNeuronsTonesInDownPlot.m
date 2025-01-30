%%CorrelogramNeuronsTonesInDownPlot
% 14.04.2018 KJ
%
%
% see
%   CorrelogramNeuronsTonesInDown
%


%load
clear

load(fullfile(FolderDeltaDataKJ,'CorrelogramNeuronsTonesInDown.mat'))

%{'all','excited','neutral','inhibit','down'}
colori = {'k', 'r', [0 0.39 0], 'm', [1 0.55 0]};
smoothing = 1;


%% PLOT

npop = 2;

%excited vs other groups
for p=1:length(corr_res.path)
    figure, hold on
    
    Cc = corr_res.corr1{p};
    xc = corr_res.xc1{p};
    
    for i=3:5
%         try
            %whole night
            subplot(2,3,1), hold on
            h1(i) = plot(xc.night{npop,i}, Cc.night{npop,i}, 'color', colori{i});

            %tones out
            subplot(2,3,2), hold on
            h2(i) = plot(xc.out{npop,i}, Cc.out{npop,i}, 'color', colori{i});

            %tones in
            subplot(2,3,3), hold on
            h3(i) = plot(xc.inside{npop,i}, Cc.inside{npop,i}, 'color', colori{i});

            %tones rem
            subplot(2,3,4), hold on
            h4(i) = plot(xc.nrem{npop,i}, Cc.nrem{npop,i}, 'color', colori{i});

            %down ends with
            subplot(2,3,5), hold on
            h5(i) = plot(xc.with{npop,i}, Cc.with{npop,i}, 'color', colori{i});

            %down ends with
            subplot(2,3,6), hold on
            h6(i) = plot(xc.without{npop,i}, Cc.without{npop,i}, 'color', colori{i});
%         end
    end
    
    %plot properties
    subplot(2,3,1), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Whole night'),
    
    subplot(2,3,2), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Just after Tones outside of down'),
    
    subplot(2,3,3), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Just after Tones inside of down'),
    
    subplot(2,3,4), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Just after Tones in NREM'),
    
    subplot(2,3,5), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Just after end of down states with tones'),
    
    subplot(2,3,6), hold on
    line([0 0],get(gca,'ylim'), 'color',[0.7 0.7 0.7]);
    ylabel('probability'), xlabel(['time from ' neurons_pop{npop} ' neurons'])
%     xlim([-200 200]),
    title('Just after end of down states without tones'),
    
    %maintitle
    suplabel(['Correlogram on ' neurons_pop{npop} ' neurons for ' corr_res.name{p}],'t');
    
end





