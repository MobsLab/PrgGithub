%%DownstatesPermutationsPlotAll
%
% 31.01.2018 KJ
%
% see
%   DownstatesPermutations DownstatesPermutationsPlot2

% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesPermutations.mat'))


for p=1:length(down_res.path)

    %% data
    sws_real  = down_res.real.sws{p};
    wake_real = down_res.real.wake{p};

    sws_perm  = down_res.perm.sws(p,:);
    wake_perm = down_res.perm.wake(p,:);
    
    
    %effect
    
    [sws_perm_effect, sws_bins]  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
    [wake_perm_effect, wake_bins]  = GetPermutationEffect(wake_real, wake_perm, duration_bins);

    %% plot
    figure, hold on

    for i=1:2
        subplot(1,2,i), hold on
        h(1) = plot(duration_bins, sws_real ,'r','linewidth',2); hold on
        h(2) = plot(duration_bins, wake_real ,'k','linewidth',2); hold on

        %permutations
        for k=1:length(permutation_range)
            if i==1 %sws permutations
                plot(duration_bins, sws_perm{k} ,'r','linewidth',1), hold on
            elseif i==2 %wake permutations
                plot(duration_bins, wake_perm{k} ,'k','linewidth',1), hold on
            end
        end
        
        %distance
        if i==1 %sws
            plot(duration_bins(sws_bins(1)), sws_real(sws_bins(1)),'or','markerfacecolor','r'), hold on
            plot(duration_bins(sws_bins(2)), sws_perm{k}(sws_bins(2)),'or','markerfacecolor','r'), hold on
            line(duration_bins(sws_bins), [sws_real(sws_bins(1)) sws_perm{k}(sws_bins(2))], 'color','r'), hold on
        elseif i==2 %wake
            plot(duration_bins(wake_bins(1)), wake_real(wake_bins(1)),'or','markerfacecolor','r'), hold on
            plot(duration_bins(wake_bins(2)), wake_perm{k}(wake_bins(2)),'or','markerfacecolor','r'), hold on
            line(duration_bins(wake_bins), [wake_real(wake_bins(1)) wake_perm{k}(wake_bins(2))], 'color','r'), hold on
        end

        %textbox
        if i==1
            text_info = {[num2str(down_res.nb_neuron{p}) ' neurons'], ...
                         ['Fr (SWS): ' num2str(down_res.firingrate.sws{p})  ' Hz'], ...
                         ['Fr (Wake): ' num2str(down_res.firingrate.wake{p})  ' Hz'], ...   
                         ['Perm effect (SWS): ' num2str(sws_perm_effect) ], ...
                         ['Perm effect (Wake): ' num2str(wake_perm_effect)]};    
            annotation('textbox',...
            [0.7 0.7 0.11 0.11],...
            'String',text_info,...
            'FontWeight','bold',...
            'FitBoxToText','off');
        end
        
        %properties
        set(gca,'xscale','log','yscale','log'), hold on
        set(gca,'ylim',[1 1E6],'xlim',[10 1500],'xtick',[10 50 100 200 500 1500]), hold on
        set(gca,'FontName','Times','fontsize',20),
        legend(h,'SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')

    end

end



