%%PoolToneDuringDownStateEffectPlot
% 16.04.2018 KJ
%
% effect of tones around down states
%
%   see 
%       ToneDuringDownStateEffect ToneDuringDownStateEffectPlot
%

%load
clear
load(fullfile(FolderDeltaDataKJ,'ToneDuringDownStateEffect.mat'))

%{'inside', 'before', 'after'}
select_tone = 'inside'; 

% {'after','post','before'};
select_order = 'before';


%% pool
ibefore = [];
iafter = [];
ipostdown = [];

for p=1:4%length(tones_res.path)
    ibefore   = [ibefore ; tones_res.(select_tone).ibefore{p}/10];
    iafter    = [iafter ; tones_res.(select_tone).iafter{p}/10];
    ipostdown = [ipostdown ; tones_res.(select_tone).ipostdown{p}/10];
    
end


%% order

%before
[d_before.bef, idx] = sort(ibefore);
d_after.bef         = iafter(idx);
d_postdown.bef      = ipostdown(idx);
%after
[d_after.after, idx] = sort(iafter);
d_before.after       = ibefore(idx);
d_postdown.after     = ipostdown(idx);
%post
[d_postdown.post , idx] = sort(ipostdown);
d_after.post            = iafter(idx);
d_before.post           = ibefore(idx);


%% distrib
ratio_tonein = abs(ibefore ./ iafter);
edges = -3:0.1:8;
[y_distrib, x_distrib] = histcounts(ratio_tonein, edges,'Normalization','probability');
x_distrib= x_distrib(1:end-1) + diff(x_distrib);


%% Plot
figure, hold on
sz=25;
gap = [0.1 0.06];


%before
subtightplot(2,2,1,gap), hold on
scatter(-d_before.bef,1:length(d_before.bef), sz,'r','filled'), hold on
scatter(d_after.bef,1:length(d_after.bef), sz,'b','filled')
scatter(d_postdown.bef,1:length(d_postdown.bef),sz,[0 0.8 0],'filled')

xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
title('ordered by down state beginning '),


%after
subtightplot(2,2,2,gap), hold on
scatter(-d_before.after,1:length(d_before.after), sz,'r','filled'), hold on
scatter(d_after.after,1:length(d_after.after), sz,'b','filled')
scatter(d_postdown.after,1:length(d_postdown.after),sz,[0 0.8 0],'filled')

xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
title('ordered by down state end '),


%post
subtightplot(2,2,3,gap), hold on
scatter(-d_before.post,1:length(d_before.post), sz,'r','filled'), hold on
scatter(d_after.post,1:length(d_after.post), sz,'b','filled')
scatter(d_postdown.post,1:length(d_postdown.post),sz,[0 0.8 0],'filled')

xlabel('time relative to tones (ms)'), ylabel('#tones'), xlim([-400 800])
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])
title('ordered by down state after '),


%Distrib
subtightplot(2,2,4,gap), hold on
plot(x_distrib, Smooth(y_distrib,1),'linewidth',2), hold on
xlabel('log(time before/time after)'), ylabel('probability')
line([0 0],get(gca,'ylim'),'color',[0.7 0.7 0.7])




