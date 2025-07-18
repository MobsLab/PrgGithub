%%DownstatesPermutationsPlot2
%
% 14.03.2018 KJ
%
% see
%   DownstatesPermutations


% load
clear
load(fullfile(FolderDeltaDataKJ,'DownstatesPermutations.mat'))

fontsize = 20;
sz = 80;

path_permuted = [1:6 25:28 34 37];
path_unchanged = [15 16 18 21 22 24];

%get permutation effect
for p=1:length(down_res.path)
    
    %% data
    sws_real  = down_res.real.sws{p};
    wake_real = down_res.real.wake{p};

    sws_perm  = down_res.perm.sws(p,:);
    wake_perm = down_res.perm.wake(p,:);

    %effect
    sws_perm_effect(p)  = GetPermutationEffect(sws_real, sws_perm, duration_bins,1);
%     wake_perm_effect(p) = GetPermutationEffect(wake_real, wake_perm, duration_bins,1);

    nb_neurons(p) = down_res.nb_neuron{p};
    sws_firingrate(p) = down_res.firingrate.sws{p};
%     if ~isempty(down_res.neuronClass{p})
%         nb_interneurons(p) = sum(down_res.neuronClass{p}<0);
%     else
%         nb_interneurons(p) = nan;
%     end

end


%% PLOT

%% good and bad examples
figure, hold on

%lot of neurons: permuted
subplot(2,2,1), hold on
for p=path_permuted
    sws_real  = down_res.real.sws{p};
    sws_perm  = down_res.perm.sws(p,:);
    [~, idx]  = GetPermutationEffect(sws_real, sws_perm, duration_bins,1);
    
    hold on, plot(duration_bins, sws_real ,'r','linewidth',2),
    hold on, plot(duration_bins, sws_perm{idx(3)} ,'color','r','linewidth',1), hold on
    
    plot(duration_bins(idx(1)), sws_real(idx(1)),'or','markerfacecolor','k'), hold on
    plot(duration_bins(idx(2)), sws_perm{idx(3)}(idx(2)),'or','markerfacecolor','k'), hold on
    line(duration_bins(idx(1:2)), [sws_real(idx(1)) sws_perm{idx(3)}(idx(2))], 'color','k'), hold on

    
end
%properties
set(gca,'xscale','log','yscale','log'), hold on
set(gca,'ylim',[1 1E6],'xlim',[10 1000],'xtick',[10 50 100 200 300 500 1500]), hold on
set(gca,'FontName','Times','fontsize',fontsize),
xlabel('down duration (ms)'), ylabel('number of down')


%few neurons: unchanged
subplot(2,2,3), hold on
for p=path_unchanged
    sws_real  = down_res.real.sws{p};
    sws_perm  = down_res.perm.sws(p,:);
    [~, idx]  = GetPermutationEffect(sws_real, sws_perm, duration_bins,1);
    
    hold on, plot(duration_bins, sws_real ,'r','linewidth',2),
    hold on, plot(duration_bins, sws_perm{idx(3)} ,'color','r','linewidth',1), hold on
    
    plot(duration_bins(idx(1)), sws_real(idx(1)),'or','markerfacecolor','k'), hold on
    plot(duration_bins(idx(2)), sws_perm{idx(3)}(idx(2)),'or','markerfacecolor','k'), hold on
    line(duration_bins(idx(1:2)), [sws_real(idx(1)) sws_perm{idx(3)}(idx(2))], 'color','k'), hold on

    
end
%properties
set(gca,'xscale','log','yscale','log'), hold on
set(gca,'ylim',[1 1E6],'xlim',[10 1000],'xtick',[10 50 100 200 300 500 1500]), hold on
set(gca,'FontName','Times','fontsize',fontsize),
xlabel('down duration (ms)'), ylabel('number of down')



%% permutation and number of neurons
subplot(2,2,[2 4]), hold on

sws_perm_effect(sws_perm_effect<0)=0;
%scatter plot of effects
scatter(nb_neurons, sws_perm_effect,sz,'k','filled')
ylim([0 300])
line([0 120], [100 100],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
line([30 30], [10 300],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
line([40 40], [10 300],'Linewidth',1,'color',[0.6 0.6 0.6]), hold on
set(gca,'FontName','Times','fontsize',fontsize),
xlabel('number of neurons'), ylabel('permutation effect'),
set(gca,'yscale','log', 'ytick',[10 20 30 50 100 150 200 300]), hold on



