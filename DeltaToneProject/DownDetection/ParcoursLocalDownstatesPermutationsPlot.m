%%ParcoursLocalDownstatesPermutationsPlot
%
% 24.08.2019 KJ
%
% see
%   DownstatesPermutations DownstatesPermutationsPlot DownstatesPermutationsPlot2


% load
clear
load(fullfile(FolderDeltaDataKJ,'LocalDownPermutations.mat'))


for p=1:length(down_res.path)
    
    for tt=1:down_res.nb_tetrodes{p}
    
        %% data
        sws_real  = down_res.local.real.sws{p,tt};
        wake_real = down_res.local.real.wake{p,tt};

        sws_perm  = down_res.local.perm.sws{p,tt};
        wake_perm = down_res.local.perm.wake{p,tt};


        %effect
        try
            [sws_perm_effect, idsws]  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
            [wake_perm_effect, idwake]  = GetPermutationEffect(wake_real, wake_perm, duration_bins);
        end
        
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

            try
                %distance
                if i==1 %sws
                    plot(duration_bins(idsws(1)), sws_real(idsws(1)),'or','markerfacecolor','k'), hold on
                    plot(duration_bins(idsws(2)), sws_perm{idsws(3)}(idsws(2)),'or','markerfacecolor','k'), hold on
                    line(duration_bins(idsws(1:2)), [sws_real(idsws(1)) sws_perm{idsws(3)}(idsws(2))], 'color','k'), hold on

                elseif i==2 %wake
                    plot(duration_bins(idwake(1)), wake_real(idwake(1)),'or','markerfacecolor','w'), hold on
                    plot(duration_bins(idwake(2)), wake_perm{idwake(3)}(idwake(2)),'or','markerfacecolor','w'), hold on
                    line(duration_bins(idwake(1:2)), [wake_real(idwake(1)) wake_perm{idwake(3)}(idwake(2))], 'color','w'), hold on
                end
            end

            %textbox
            if i==1
                text_info = {[num2str(down_res.local.nb_neuron{p,tt}) ' neurons'], ...
                             ['Fr (SWS): ' num2str(down_res.local.fr.sws{p,tt})  ' Hz'], ...
                             ['Perm effect (SWS): ' num2str(sws_perm_effect) ]};

                position_box = [0.25 0.84 0.26 0.07];

            elseif i==2
                text_info = {[num2str(down_res.local.nb_neuron{p,tt}) ' neurons'], ...
                             ['Fr (Wake): ' num2str(down_res.local.fr.wake{p,tt})  ' Hz'], ...   
                             ['Perm effect (Wake): ' num2str(wake_perm_effect)]}; 

                position_box = [0.67 0.84 0.26 0.07];
            end

            %textbox
            annotation('textbox',...
            position_box,...
            'String',text_info,...
            'FontWeight','bold',...
            'linestyle','none',...
            'fontsize',17,...
            'FitBoxToText','off');

            %properties
            set(gca,'xscale','log','yscale','log'), hold on
            set(gca,'ylim',[1 1E6],'xlim',[10 1500],'xtick',[10 50 100 200 500 1500]), hold on
            set(gca,'FontName','Times','fontsize',18),
            xlabel('down duration (ms)'), ylabel('number of down')

            if i==1
               legend(h,'SWS','Wake'), 
            end

        end

    end
end



