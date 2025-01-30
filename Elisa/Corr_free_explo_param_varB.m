load('/home/mobs/Desktop/Elisa/Matlab_variables/model_results_saline_2.mat')

%% free exploration
var = {'beta_hab', 'thigmotaxis_hab', 'direct_persist_hab', 'immobility_hab', ...
'p1_hab', 'p2_hab', 'p3_hab', 'gamma_hab', 'k_hab', 'bp_hab', 'Wm_hab',...
'Wnm_hab', 'beta_pre', 'thigmotaxis_pre', 'direct_persist_pre',...
'immobility_pre', 'p1_pre', 'p2_pre', 'p3_pre', 'gamma_pre', 'k_pre',...
'bp_pre', 'Wm_pre', 'Wnm_pre', 'beta_post', 'thigmotaxis_post',...
'direct_persist_post', 'immobility_post', 'p1_post', 'p2_post',...
'p3_post', 'gamma_post', 'k_post', 'bp_post', 'Wm_post', 'Wnm_post',...
'B_all_stim_free', 'B_all_freez_cond_all', 'B_diff_occup_shock_zone',...
'B_thigmo_cond_free', 'B_learning_rate', 'B_thigmo_hab',...
'B_immobility_hab', 'B_thigmo_pre', 'B_immobility_pre', 'B_thigmo_post',...
'B_immobility_post'};

% thigmo data DZP vs thigmo model
figure

A = saline(44,:); B = saline(14,:);


[Rp, Pp] = PlotCorrelations_BM_EM(A , B, 'color', 'blue', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')

hold on
A = saline(46,:); B = saline(26,:); 


[Rpo, Ppo] = PlotCorrelations_BM_EM(A , B, 'color', 'red', 'legend', 1);
% set(gca , 'Xscale' , 'log')
xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')
axis square

A = model_results_DZP_post(13,:); B = model_results_DZP_post(2,:);
% A(and(A>80 , B>14000))=NaN;  % outlier, M688

[Rh, Ph] = PlotCorrelations_BM_EM(A , B, 'color', 'green', 'method', 'spearman', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis Hab DATA'), ylabel('Thigmotaxis Hab MODEL')

txt = ['\color{blue} PRE sal - R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} POST sal - R = ' num2str(Rpo) '     P = ' num2str(Ppo) newline '\color{green} POST DZP - R = ' num2str(Rh) '     P = ' num2str(Ph)];
% text(30,20,txt)
text(30,20,txt)
%%


% thigmo data vs thigmo model
figure
A = saline(42,:); B = saline(2,:);
% A(and(A>80 , B>14000))=NaN;  % outlier, M688

[Rh, Ph] = PlotCorrelations_BM_EM(A , B, 'color', 'red', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis Hab DATA'), ylabel('Thigmotaxis Hab MODEL')
hold on

A = saline(44,:); B = saline(14,:);


[Rp, Pp] = PlotCorrelations_BM_EM(A , B, 'color', 'blue', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')


A = saline(46,:); B = saline(26,:);


[Rpo, Ppo] = PlotCorrelations_BM_EM(A , B, 'color', 'green', 'legend', 1);
% set(gca , 'Xscale' , 'log')
xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')
axis square


txt = ['\color{red} HAB - R = ' num2str(Rh) '     P = ' num2str(Ph) newline '\color{blue} PRE - R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{green} POST - R = ' num2str(Rpo) '     P = ' num2str(Ppo)];
% text(30,20,txt)
text(30,20,txt)


% immo data vs immo model
figure
A = saline(43,:); B = saline(4,:);
% A(and(A>80 , B>14000))=NaN;  % outlier, M688

[Rh, Ph] = PlotCorrelations_BM_EM(A , B, 'color', 'red', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis Hab DATA'), ylabel('Thigmotaxis Hab MODEL')
hold on

A = saline(45,:); B = saline(16,:);


[Rp, Pp] = PlotCorrelations_BM_EM(A , B, 'color', 'blue', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')


A = saline(47,:); B = saline(28,:);


[Rpo, Ppo] = PlotCorrelations_BM_EM(A , B, 'color', 'green', 'legend', 1);
% set(gca , 'Xscale' , 'log')
xlabel('Immobility - DATA'), ylabel('Immobility - MODEL')

axis square

txt = ['\color{red} R = ' num2str(Rh) '     P = ' num2str(Ph) newline '\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{green} R = ' num2str(Rpo) '     P = ' num2str(Ppo)];
% text(30,20,txt)
text(400,200,txt)


% direct persist data vs direct persist model
figure
A = saline(43,:); B = saline(3,:);
% A(and(A>80 , B>14000))=NaN;  % outlier, M688

[Rh, Ph] = PlotCorrelations_BM_EM(A , B, 'color', 'red', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis Hab DATA'), ylabel('Thigmotaxis Hab MODEL')
hold on

A = saline(45,:); B = saline(15,:);


[Rp, Pp] = PlotCorrelations_BM_EM(A , B, 'color', 'blue', 'legend', 1);
% set(gca , 'Xscale' , 'log')
% xlabel('Thigmotaxis - DATA'), ylabel('Thigmotaxis - MODEL')


A = saline(47,:); B = saline(29,:);


[Rpo, Ppo] = PlotCorrelations_BM_EM(A , B, 'color', 'green', 'legend', 1);
% set(gca , 'Xscale' , 'log')
xlabel('Immobility - DATA'), ylabel('Immobility - MODEL')

axis square

txt = ['\color{red} R = ' num2str(Rh) '     P = ' num2str(Ph) newline '\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{green} R = ' num2str(Rpo) '     P = ' num2str(Ppo)];
% text(30,20,txt)
text(400,200,txt)


% immobility hab vs freez cond
figure

A = saline(4,:); B = saline(38,:);
A(and(A>80 , B>14000))=NaN;  % outlier, M688

PlotCorrelations_BM(A , log10(B))
set(gca , 'Xscale' , 'log')
xlabel('Immobility hab'), ylabel('Freezing time, cond')

% immobility pre vs stim cond
figure

A = saline(16,:); B = saline(37,:);
A(B>30)=NaN;  % too much stim

PlotCorrelations_BM(A , B)
xlabel('Immobility TestPre'), ylabel('Eyelid number, cond')


% p3 hab vs freez cond
figure

A = saline(7,:); B = saline(38,:);
A(and(A>.9 , B>14000))=NaN;   % outlier, M688
PlotCorrelations_BM(A , B)
xlabel('p3, Hab'), ylabel('Freezing time, cond')


% p1 pre vs stim cond
figure

A = saline(17,:); B = saline(37,:);
A(B>30)=NaN; % too much stim
PlotCorrelations_BM(sqrt(sqrt(A)) , B)
xlabel('p1, Pre'), ylabel('Eyelid number, cond')


% p3 hab vs imm hab
% figure
% 
% A = saline(7,:); B = saline(4,:);
% % A(B>30)=NaN;
% % PlotCorrelations_BM(sqrt(sqrt(A)) , B)
% PlotCorrelations_BM(A , log10(B));
% set(gca , 'Xscale' , 'log')
% xlabel('p3, Hab'), ylabel('Immobility, Hab')


% p1 pre vs imm pre
figure

A = saline(17,:); B = saline(16,:);
% PlotCorrelations_BM(sqrt(sqrt(A)) , B)
PlotCorrelations_BM(A , B);

xlabel('p1, Pre'), ylabel('Immobility, pre')


%% contitioned exploration

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_neg_1shockzone.mat');
% M = conditioning_explo_results_neg_1shockzone;
M = GF_conditioning_explo_results_NEG_4lines;

%% Ripples post sleep NEGATIVE
load('/home/mobs/Desktop/Elisa/data/ERC_RipplesAversive.mat');
mice_neg = {Mouse1117, Mouse1161, Mouse1162, Mouse1168, Mouse1182, Mouse1186, Mouse1239, ...
            Mouse797, Mouse798', Mouse828, Mouse861, Mouse882, Mouse906, Mouse911, Mouse912, Mouse977', ...
            Mouse994};
% nMice = [797 798 828 861 882 905 906 911 912 977 994 1117 1161 1162 1168 1182 1186 1199 1230 1239];
% 12, 13, 14, 15, 16, 17

ripples = zeros(length(mice_neg) + 2, 1);
for m=1:length(mice_neg)
    d = cell2mat(mice_neg(m));
    ripples(m) = length(d.PostSleep);
end

for m=1:length(Mouse1230)
    c = cell2mat(Mouse1230(m));
    ripples(length(mice_neg) + m) = length(c.PostSleep);
end


figure
A = M(4,:);
B = ripples';
% B(or(B<2500, B>5500))=NaN; % eliminate extreme cases of ripples (too little or too many)
PlotCorrelations_BM(A , B)

axis square
xlabel('replay-model'), ylabel('ripples-post-sleep')


%%
% correlation between model parameters in conditioning exploration model 
figure
PlotCorrelations_BM(M(1,:) , M(2,:))
% PlotCorrelations_BM(M(:,1) , M(:,2))

axis square
xlabel('W-values'), ylabel('alpha')




%% Replays prediction of TestPost behavior NEGATIVE (shock zone in latency was 1 subareas and in diff occupancy 2 subareas)
% occup diff

figure
subplot(121)

% A=M(:,4)'; B=M(:,6)';
% A=M(:,4); B=M(:,6)';
% A=M(4, :)'; B=M(6, :)';
A=M(4, :); B=M(6, :);


B(B>0)=NaN; B(B<-800)=NaN; B(19)=NaN;   % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse

PlotCorrelations_BM_EM(A , B , 'method','pearson')
axis square
xlabel('replay #'), ylabel('Occupancy TestPre-TestPost')


% latency
% subplot(122)
figure

% A=M(:,4)'; B=M(:,7)';
% A=M(4, :)'; B=M(7, :)';
A=M(4, :); B=M(7, :);


B(19)=NaN; %2 exp of a mouse


PlotCorrelations_BM_EM(A , B , 'method','spearman')
xlabel('replay #'), ylabel('Latency Shock zone, TestPost')
axis square


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_NEG.mat')
M5N = conditioning_explo_results_NEG;

var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond',...
    'B-occ-cz-post', 'B-occ-cz-cond', 'B-diff-occup-cz-post-pre', 'B-diff-occup-cz-cond-pre',...
    'B-latency-enter-cz-post', 'B-cz-entries-post', 'B-cz-entries-cond'};


%% Replays prediction of TestPost behavior NEGATIVE (shock zone in latency and diff occupancy is 5 lines of tiles)
% occup diff

figure
subplot(121)

% A=M(:,4)'; B=M(:,6)';
% A=M(:,4); B=M(:,6)';
% A=M(4, :)'; B=M(6, :)';
A=M5(4, :); B=M5(8, :);


B(B>0)=NaN; B(B<-800)=NaN; B(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse

PlotCorrelations_BM_EM(A , B , 'method','pearson')
axis square
xlabel('replay #'), ylabel('Occupancy TestPost-TestPre')


% latency
subplot(122)

% A=M(:,4)'; B=M(:,7)';
% A=M(4, :)'; B=M(7, :)';
A=M5(4, :); B=M5(10, :);


B(19)=NaN;  %2 exp of a mouse

PlotCorrelations_BM_EM(A , B , 'method','spearman')
% PlotCorrelations_BM_EM(A , B , 'method','pearson')
xlabel('replay #'), ylabel('Latency Shock zone, TestPost')
axis square

% saveas(gcf, '/home/mobs/Desktop/Elisa/Matlab_figures/Replays_september/Replay_predict_behav_post.jpg')

% occup post
i=6;
figure

A=M5(4,:); B=M5(i,:);
B(19)=NaN; B(and(A>8 , B>400))=NaN;  %2 exp of a mouse, if stay too much in sz

PlotCorrelations_BM(A , B)
axis square
xlabel('replays'), ylabel('occup post')


% entries cond
% i=12;
% figure
% 
% A=M5(4,:); B=M5(i,:);
% B(19)=NaN; B(and(A>8 , B>12))=NaN;  %2 exp of a mouse, too much entries in sz
% 
% % PlotCorrelations_BM(A , B , 'method','spearman')
% PlotCorrelations_BM(A , B , 'method','pearson')
% axis square
% xlabel('replays'), ylabel('entries shock zone cond')

% negative stimulation
i=5;
figure

A=M5(4,:); B=M5(i,:);
B(19)=NaN; %2 exp of a mouse
% B(B>25)=NaN;
% B(11) = NaN;
% B(13) = NaN;
% B(15)= NaN;
% B(17) = NaN;  %  %2 exp of a mouse

% PlotCorrelations_BM(A , B , 'method','spearman')
PlotCorrelations_BM(A , B , 'method','pearson')
axis square
xlabel('replays'), ylabel('negative stimulation received')



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Replays prediction of TestPost behavior POSITIVE (shock zone in latency was 1 subareas and in diff occupancy 2 subareas)

load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_POS_as_OLD.mat')
M5P_O = conditioning_explo_results_POS_as_OLD;


var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-diff-occup-cz-post-pre', ...
    'B-latency-enter-cz-post'};

figure
subplot(121)

% A=M(:,4)'; B=M(:,6)';
% A=M(:,4); B=M(:,6)';
% A=M(4, :)'; B=M(6, :)';
A=M5P_O(4, :); B=M5P_O(5, :);

% B(11) = NaN;
% B(13) = NaN;
% B(15)= NaN;
% B(17) = NaN;

% B(B>0)=NaN; B(B<-800)=NaN; B(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse

PlotCorrelations_BM_EM(A , B , 'method','pearson')
axis square
xlabel('replay #'), ylabel('Occupancy TestPre-TestPost')


% latency
subplot(122)

% A=M(:,4)'; B=M(:,7)';
% A=M(4, :)'; B=M(7, :)';
A=M5P_O(4, :); B=M5P_O(6, :);


% % B(19)=NaN;  %2 exp of a mouse
B(11) = NaN;
B(13) = NaN;
B(15)= NaN;
B(17) = NaN;  %  %2 exp of a mouse
% B(B>80) = NaN;  % take too much to go to the reward, not learned

% PlotCorrelations_BM_EM(log10(A) , B , 'method','spearman')
PlotCorrelations_BM_EM(A , B , 'method','spearman')
% PlotCorrelations_BM_EM(A , log10(B) , 'method','spearman')
xlabel('replay #'), ylabel('Latency Reward zone, TestPost')
% set(gca , 'Xscale' , 'log')
axis square



%% Replays prediction of TestPost behavior POSITIVE (shock zone in latency and diff occupancy is 5 lines of tiles)

load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_POS_2.mat')
M5P = conditioning_explo_results_POS_2;

mice_pos = {'Mouse1117', 'Mouse1161', 'Mouse1162', 'Mouse1168', 'Mouse1336', 'Mouse1334', ...
    'Mouse1281', 'Mouse1257', 'Mouse1223', 'Mouse1182_1', 'Mouse1182_2', 'Mouse1199_1', 'Mouse1199_2', ...
            'Mouse1317_1', 'Mouse1317_2', 'Mouse1239_1', 'Mouse1239_2', 'Mouse1228'};
        
%%

% correlation between model parameters in conditioning exploration model 
figure
PlotCorrelations_BM(M5P(:,1)' , M5P(:,2)')
% PlotCorrelations_BM(M(:,1) , M(:,2))

axis square
xlabel('W-values'), ylabel('alpha')


%%
figure
subplot(121)

% A=M(:,4)'; B=M(:,6)';
% A=M(:,4); B=M(:,6)';
% A=M(4, :)'; B=M(6, :)';
A=M5P(4, :); B=M5P(8, :);

% B(11) = NaN;
% B(13) = NaN;
% B(15)= NaN;
% B(17) = NaN;

% B(B>0)=NaN; B(B<-800)=NaN; B(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse

PlotCorrelations_BM_EM(A , B , 'method','pearson')
axis square
xlabel('replay #'), ylabel('Occupancy TestPost-TestPre')


% latency
subplot(122)

% A=M(:,4)'; B=M(:,7)';
% A=M(4, :)'; B=M(7, :)';
A=M5P(4, :); B=M5P(10, :);


B([11 13 15 17]) = NaN; % 2nd passage
B(B>80) = NaN;  % take too much to go to the reward, not learned
A(and(A>8 , B>20))=NaN; % weird mouse

% PlotCorrelations_BM_EM(log10(A) , B , 'method','spearman')
PlotCorrelations_BM_EM(A , B , 'method','spearman')
% PlotCorrelations_BM_EM(A , log10(B) , 'method','spearman')
xlabel('replay #'), ylabel('Latency Reward zone, TestPost')
% set(gca , 'Xscale' , 'log')
axis square


% %entries cond
% i=12;
% figure
% 
% A=M5P(4,:); B=M5P(i,:);
% B(11) = NaN;
% B(13) = NaN;
% B(15)= NaN;
% B(17) = NaN;  %  %2 exp of a mouse
% 
% % PlotCorrelations_BM(A , B , 'method','spearman')
% PlotCorrelations_BM(A , B , 'method','pearson')
% axis square
% xlabel('replays'), ylabel('entries reward zone cond')


%positive stimulation
i=5;
figure

A=M5P(4,:); B=M5P(i,:);
B(11) = NaN;
B(13) = NaN;
B(15)= NaN;
B(17) = NaN;  %  %2 exp of a mouse

% PlotCorrelations_BM(A , B , 'method','spearman')
PlotCorrelations_BM(A , B , 'method','pearson')
axis square
xlabel('replays'), ylabel('positive stimulation received')



%%


% 
% figure
% 
% A = saline(5,:); B = saline(37,:);
% A(B>30)=NaN;
% 
% 
% 
% 
% 
% 
% 
% % A = saline(19,:); B = saline(38,:);
% % A(and(A>.8 , B>14000))=NaN;
% % PlotCorrelations_BM(log10(A) , B)
% % xlabel('p3, Hab'), ylabel('Freezing time, cond')
% 
% % A(B>30)=NaN;
% PlotCorrelations_BM(A , log10(B))
% PlotCorrelations_BM(A , B)
% set(gca , 'Xscale' , 'log')
% xlabel('Immobility hab'), ylabel('Freezing time, cond')
% 
% 
% figure
% 
% A = saline(16,:); B = saline(37,:);
% A(B>30)=NaN;
% 
% PlotCorrelations_BM(A , B)
% xlabel('Immobility TestPre'), ylabel('Eyelid number, cond')




