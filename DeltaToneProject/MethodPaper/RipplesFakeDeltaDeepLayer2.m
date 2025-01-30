%%RipplesFakeDeltaDeepLayer2
% 13.03.2018 KJ
%
%   Show that fake detections happen after SPW-Rs and change the coupling
%   
%   see
%       RipplesFakeDeltaDeepLayer
%


% load
clear
load(fullfile(FolderProjetDelta,'Data','RipplesFakeDeltaDeepLayer2.mat'))

smoothing=1;

%% average

for p=1:length(ondelta.lfp_deep)


TDelta_deep = [];
TDelta_sup = [];
TDelta_mua = [];

TRip_deep_ls = [];
TRip_sup_ls = [];
TRip_mua_ls = [];

TRip_deep_hs = [];
TRip_sup_hs = [];
TRip_mua_hs = [];

TRip_deep_lm = [];
TRip_sup_lm = [];

TRip_deep_hm = [];
TRip_sup_hm = [];

corr_deep = [];
corr_sup = [];
corr_diff = [];
corr_down = [];



    if ~isempty(ondelta.lfp_deep{p})
        
        %on deltas
        TDelta_deep = [TDelta_deep ondelta.lfp_deep{p}'];
        TDelta_sup  = [TDelta_sup ondelta.lfp_sup{p}'];
        TDelta_mua  = [TDelta_mua ondelta.mua{p}'];
        
        %on ripples
        TRip_deep_ls = [TRip_deep_ls onrip.low_sup.lfp_deep{p}'];
        TRip_sup_ls = [TRip_sup_ls onrip.low_sup.lfp_sup{p}'];
        TRip_mua_ls = [TRip_mua_ls onrip.low_sup.mua{p}'];

        TRip_deep_hs = [TRip_deep_hs onrip.high_sup.lfp_deep{p}'];
        TRip_sup_hs = [TRip_sup_hs onrip.high_sup.lfp_sup{p}'];
        TRip_mua_hs = [TRip_mua_hs onrip.high_sup.mua{p}'];

        TRip_deep_lm = [TRip_deep_lm onrip.low_mua.lfp_deep{p}'];
        TRip_sup_lm = [TRip_sup_lm onrip.low_mua.lfp_sup{p}'];

        TRip_deep_hm = [TRip_deep_hm onrip.high_mua.lfp_deep{p}'];
        TRip_sup_hm = [TRip_sup_hm onrip.high_mua.lfp_sup{p}'];
        
        %correlograms
        corr_deep = [corr_deep rip_corr.deep{p}];
        corr_sup = [corr_sup rip_corr.sup{p}];
        corr_diff = [corr_diff rip_corr.diff{p}];
        corr_down = [corr_down rip_corr.down{p}];


%mean
TDelta_deep = mean(TDelta_deep,2);
TDelta_sup = mean(TDelta_sup,2);
TDelta_mua = mean(TDelta_mua,2);

TRip_deep_ls = mean(TRip_deep_ls,2);
TRip_sup_ls = mean(TRip_sup_ls,2);
TRip_mua_ls = mean(TRip_mua_ls,2);

TRip_deep_hs = mean(TRip_deep_hs,2);
TRip_sup_hs = mean(TRip_sup_hs,2);
TRip_mua_hs = mean(TRip_mua_hs,2);

TRip_deep_lm = mean(TRip_deep_lm,2);
TRip_sup_lm = mean(TRip_sup_lm,2);

TRip_deep_hm = mean(TRip_deep_hm,2);
TRip_sup_hm = mean(TRip_sup_hm,2);

corr_deep = mean(corr_deep,2);
corr_sup = mean(corr_sup,2);
corr_diff = mean(corr_diff,2);
corr_down = mean(corr_down,2);


x_corr = rip_corr.x_cor{1};


%% PLOT

figure, hold on

%lfp and mua on deltas
subplot(2,3,1),
hold on, h(1) = plot(x_resp,TDelta_deep, 'r');
hold on, h(2) = plot(x_resp,TDelta_sup, 'b');
ylim([-2000 2000]),
yyaxis right
hold on, h(3) = plot(x_mua,TDelta_mua, 'k', 'linewidth',2);
ylim([0 6]),
yyaxis left
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6])
title('On delta waves'), legend(h,'Deep','Sup','MUA')
clear h

% low sup
subplot(2,3,2),
hold on, h(1) = plot(x_resp,TRip_deep_ls, 'r');
hold on, h(2) = plot(x_resp,TRip_sup_ls, 'b');
ylim([-2000 2000]),
yyaxis right
hold on, h(3) = plot(x_mua,TRip_mua_ls, 'k', 'linewidth',2);
ylim([0 6]),
yyaxis left
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6])
title('On Ripples - low amplitude in sup'), legend(h,'Deep','Sup','MUA')
clear h


% high sup
subplot(2,3,3),
hold on, h(1) = plot(x_resp,TRip_deep_hs, 'r');
hold on, h(2) = plot(x_resp,TRip_sup_hs, 'b');
ylim([-2000 2000]),
yyaxis right
hold on, h(3) = plot(x_mua,TRip_mua_hs, 'k', 'linewidth',2);
ylim([0 6]),
yyaxis left
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6])
title('On Ripples - high amplitude in sup'), legend(h,'Deep','Sup','MUA')
clear h

% correlo
subplot(2,3,4),
hold on, h(1) = plot(x_corr,Smooth(corr_deep,smoothing), 'r');
hold on, h(2) = plot(x_corr,Smooth(corr_sup,smoothing), 'b');
hold on, h(3) = plot(x_corr,Smooth(corr_diff,smoothing), 'color', [0.7 0.7 0.7]);
hold on, h(4) = plot(x_corr,Smooth(corr_down,smoothing), 'k', 'linewidth',2);
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6]);
title('Correlogram on ripples'), legend(h,'Delta deep','Sup','2-layers', 'Down')
clear h

%low mua 
subplot(2,3,5),
hold on, h(1) = plot(x_resp,TRip_deep_lm, 'r');
hold on, h(2) = plot(x_resp,TRip_sup_lm, 'b');
ylim([-2000 2000]),
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6])
title('On Ripples - low mua response'), legend(h,'Deep','Sup')
clear h

% high mua
subplot(2,3,6),
hold on, h(1) = plot(x_resp,TRip_deep_hm, 'r');
hold on, h(2) = plot(x_resp,TRip_sup_hm, 'b');
ylim([-2000 2000]),
line([0 0],get(gca,'ylim'),'color',[0.6 0.6 0.6])
title('On Ripples - high mua response'), legend(h,'Deep','Sup')
clear h

    end
end


