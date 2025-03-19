%%ParcoursDownstatesPermutationsPlot
%
% 24.08.2019 KJ
%
% see
%   DownstatesPermutations DownstatesPermutationsPlot DownstatesPermutationsPlot2


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
    
    [sws_perm_effect, idsws]  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
    [wake_perm_effect, idwake]  = GetPermutationEffect(wake_real, wake_perm, duration_bins);

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
            plot(duration_bins(idsws(1)), sws_real(idsws(1)),'or','markerfacecolor','k'), hold on
            plot(duration_bins(idsws(2)), sws_perm{idsws(3)}(idsws(2)),'or','markerfacecolor','k'), hold on
            line(duration_bins(idsws(1:2)), [sws_real(idsws(1)) sws_perm{idsws(3)}(idsws(2))], 'color','k'), hold on
            
        elseif i==2 %wake
            plot(duration_bins(idwake(1)), wake_real(idwake(1)),'or','markerfacecolor','w'), hold on
            plot(duration_bins(idwake(2)), wake_perm{idwake(3)}(idwake(2)),'or','markerfacecolor','w'), hold on
            line(duration_bins(idwake(1:2)), [wake_real(idwake(1)) wake_perm{idwake(3)}(idwake(2))], 'color','w'), hold on
        end
        
        %textbox
        if i==1
            text_info = {[num2str(down_res.nb_neuron{p}) ' neurons'], ...
                         ['Fr (SWS): ' num2str(down_res.firingrate.sws{p})  ' Hz'], ...
                         ['Perm effect (SWS): ' num2str(sws_perm_effect) ]};
             
            position_box = [0.25 0.84 0.26 0.07];
             
        elseif i==2
            text_info = {[num2str(down_res.nb_neuron{p}) ' neurons'], ...
                         ['Fr (Wake): ' num2str(down_res.firingrate.wake{p})  ' Hz'], ...   
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



