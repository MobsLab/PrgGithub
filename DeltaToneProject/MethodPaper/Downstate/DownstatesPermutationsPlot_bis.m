%%DownstatesPermutationsPlot_bis
%
% 31.01.2018 KJ
%
% see
%   DownstatesPermutations

%load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis.mat'))
load(fullfile(FolderDeltaDataKJ,'DownstatesSubpopulationAnalysis2.mat'))

%params
duration_bins = 0:10:1200; %duration bins for downstates


for p=[1 10 15]
    
    disp(' ')
    disp('****************************************************************')
    disp(downsub_res.path{p})
    
    
    %% subpopulation
    for i=1:length(range_nbneurons)
        if ~isempty(downsub_res.sub.real.sws{p,i})
            %real down    
            sws_real   = GetDurationDistribution(downsub_res.sub.real.sws{p,i}, duration_bins);
            wake_real  = GetDurationDistribution(downsub_res.sub.real.wake{p,i}, duration_bins);

            %permuted
            clear sws_perm wake_perm
            for k=1:length(permutation_range)    
                sws_perm{k}   = GetDurationDistribution(permsub_res.sws{p,i,k}, duration_bins);
                wake_perm{k}  = GetDurationDistribution(permsub_res.wake{p,i,k}, duration_bins);
            end

            sws_perm_effect  = GetPermutationEffect(sws_real, sws_perm, duration_bins);
            wake_perm_effect = GetPermutationEffect(wake_real, wake_perm, duration_bins);
            
            figure, hold on

            for t=1:2
                subplot(2,2,t), hold on
                h(1) = plot(duration_bins, sws_real ,'r','linewidth',2); hold on
                h(2) = plot(duration_bins, wake_real ,'k','linewidth',2); hold on

                %permutations
                for k=1:length(permutation_range)
                    if t==1 %sws permutations
                        plot(duration_bins, sws_perm{k} ,'r','linewidth',1), hold on
                    elseif t==2 %wake permutations
                        plot(duration_bins, wake_perm{k} ,'k','linewidth',1), hold on
                    end
                end

                %textbox
                text_info = {[num2str(downsub_res.sub.nb_neuron{p,i}) ' neurons'], ...
                             ['Fr (SWS): ' num2str(downsub_res.sub.firingrate.sws{p,i})  ' Hz'], ...
                             ['Fr (Wake): ' num2str(downsub_res.sub.firingrate.wake{p,i})  ' Hz'], ...   
                             ['Perm effect (SWS): ' num2str(sws_perm_effect) ], ...
                             ['Perm effect (Wake): ' num2str(wake_perm_effect)]};    
                annotation('textbox',...
                [0.6 0.3 0.2 0.1],...
                'String',text_info,...
                'FontWeight','bold',...
                'FitBoxToText','off');

                %properties
                set(gca,'xscale','log','yscale','log'), hold on
                set(gca,'ylim',[1 1E6],'xlim',[10 1500],'xtick',[10 50 100 200 500 1500]), hold on
                legend(h,'SWS','Wake'), xlabel('down duration (ms)'), ylabel('number of down')

            end

            %difference
            subplot(2,2,3), hold on
            diff_wake_sleep = log(sws_real) - log(wake_real);
            plot(duration_bins, diff_wake_sleep)
            set(gca,'xscale','log'), hold on
            set(gca,'xlim',[10 1500],'xtick',[10 50 100 200 500 1500], 'ylim',[0 6.5]), hold on
            xlabel('down duration (ms)'), ylabel('log difference')


            %main title
            title = [downsub_res.name{p} ' - '  downsub_res.date{p}];
            suplabel(title,'t');
            
            
        
        end
    end
    
end



