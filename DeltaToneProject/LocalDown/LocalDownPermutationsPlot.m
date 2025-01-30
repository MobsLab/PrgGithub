%%LocalDownPermutationsPlot
%
% 14.03.2018 KJ
%
% see
%   DownstatesPermutations DownstatesPermutationsPlot2 LocalDownPermutations
%  

% load
clear
load(fullfile(FolderDeltaDataKJ,'LocalDownPermutations.mat'))

fontsize = 20;

a=0;
%get permutation effect
for p=1:length(down_res.path)
    
    for tt=1:down_res.nb_tetrodes{p}
        %% data
        sws_real  = down_res.local.real.sws{p,tt};
        wake_real = down_res.local.real.wake{p,tt};

        sws_perm  = down_res.local.perm.sws{p,tt};
        wake_perm = down_res.local.perm.wake{p,tt};

        %effect
        a=a+1;
        sws_perm_effect(a)  = GetPermutationEffect(sws_real, sws_perm, duration_bins,1);
    %     wake_perm_effect(p) = GetPermutationEffect(wake_real, wake_perm, duration_bins,1);

        nb_neurons(a) = down_res.local.nb_neuron{p,tt};
    end
end


%% permutation and number of neurons
figure, hold on

% sws_perm_effect(sws_perm_effect<0)=0;
%scatter plot of effects
scatter(nb_neurons, sws_perm_effect,35,'k','filled')
% ylim([0 300])
line([0 120], [100 100],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
line([30 30], [10 300],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
line([40 40], [10 300],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
set(gca,'FontName','Times','fontsize',fontsize),
xlabel('number of neurons'), ylabel('permutation effect'),
% set(gca,'yscale','log'), hold on