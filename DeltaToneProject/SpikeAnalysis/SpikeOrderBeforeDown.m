% SpikeOrderBeforeDown
% 29.08.2017 KJ
%
% 
% 
% 
%   see 
%


clear

%params
windowsize = 2E4; %400 ms

%% load data

%Epochs
load StateEpochSB SWSEpoch Wake REMEpoch

%MUA
load SpikeData
eval('load SpikesToAnalyse/PFCx_Neurons')
NumNeurons=number;
clear number
SpikeAll = PoolNeurons(S,NumNeurons);

%timestamps

% clusters = unique(s(:,2:3),'rows');
% clusters(clusters(:,2)==0,:)=[];
% clusters = clusters(NumNeurons,:);
% spike_tmp = s(ismember(s(:,2:3),clusters,'rows'),:);
% spike_tmp = [spike_tmp(:,1)*1E4 spike_tmp(:,2:3)];

spike_tmp = [];
spike_num = [];
for n=NumNeurons
    t = Range(PoolNeurons(S,n));
    spike_tmp = [spike_tmp ; t];
    spike_num = [spike_num ; ones(length(t),1) * n];
end
spike_tmp = [spike_tmp spike_num];
spike_tmp = sortrows(spike_tmp,1);

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


%% Order of spike before down
mean_bef_down = nan(length(start_down), length(NumNeurons));
last_bef_down = nan(length(start_down), length(NumNeurons));

for i=1:length(start_down)
    if mod(i,1000)==0
        disp(i);
    end
    
    s_before_down = spike_tmp(:,1)>start_down(i)-windowsize & spike_tmp(:,1)<=start_down(i);
    s_before_down = spike_tmp(s_before_down,:);

    for n=1:length(NumNeurons)
        s_before_neur = s_before_down(s_before_down(:,2)==NumNeurons(n),1) - (start_down(i)-1E4);
        if ~isempty(s_before_neur)
            mean_bef_down(i,n) = mean(s_before_neur);
            last_bef_down(i,n) = max(s_before_neur);            
        end
    end
end

%order
mean_bef_down(isnan(mean_bef_down)) = -1;
last_bef_down(isnan(last_bef_down)) = -1;

[~, mean_bef_order] = sort(mean_bef_down,2,'descend');
% mean_bef_order(mean_bef_down==-1) = nan;
[~, last_bef_order] = sort(last_bef_down,2,'descend');
% last_bef_order(last_bef_down==-1) = nan;


%% Kendall thau
[tau, pval] = corr(last_bef_order,'type', 'Kendall');
sig_tau1 = tau;
sig_tau1(pval>0.05)=0;

[tau, pval] = corr(mean_bef_order,'type', 'Kendall');
sig_tau2 = tau;
sig_tau2(pval>0.05)=0;
















