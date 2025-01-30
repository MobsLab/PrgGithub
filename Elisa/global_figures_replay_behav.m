
%% all labels for data measures

% yl = {'occupancy of the conditioning zone (%)', 'differential occupancy of the conditioning zone (post-pre, %)', ...
%     'latency to enter in the conditioning zone (s)', 'differential latency to enter in the conditioning zone (post-pre, s)', ...
%     'entries in the conditioning zone', 'differential entries in the conditioning zone (post-pre)'};

%%
cd('/media/nas7/Modelling_Behaviour/Conditioning_Project/'Mouse906', 'Mouse911', 'Mouse912', 'Mouse977',...
    'Mouse994', 'Mouse1230_1', 'Mouse1230_2'};From_Elisa')

var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond',...
    'B-occ-cz-post', 'B-occ-cz-cond', 'B-diff-occup-cz-post-pre', 'B-diff-occup-cz-cond-pre',...
    'B-latency-enter-cz-post', 'B-cz-entries-post', 'B-cz-entries-cond', 'B-diff-latency', 'B-perc-diff-occup-cz-post-pre', ...
    'B-diff-cz-entries-post-pre', 'B-perc-cz-occup-post'};

mice_neg = {'Mouse1117', 'Mouse1161', 'Mouse1162', 'Mouse1168', 'Mouse1182', 'Mouse1186', 'Mouse1239',...
    'Mouse797', 'Mouse798', 'Mouse828', 'Mouse861', 'Mouse882', 
mice_pos = {'Mouse1117', 'Mouse1161', 'Mouse1162', 'Mouse1168', 'Mouse1336', 'Mouse1334',...
    'Mouse1281', 'Mouse1257', 'Mouse1223', 'Mouse1182_1', 'Mouse1182_2', 'Mouse1199_1', 'Mouse1199_2',...
    'Mouse1317_1', 'Mouse1317_2', 'Mouse1239_1', 'Mouse1239_2', 'Mouse1228'};

method={'spearman','pearson'};
met = method{1};
eliminate_mice = 1;
metrics = [16 14 10 13 11 15];

yl = {'Occup stim zone, TestPost (%)', 'Occup diff, TestPost-TestPre (%)', ...
    'Latency stim zone, TestPost (s)', 'Latency diff, TestPost-TestPre (s)', ...
    'Entries stim zone, TestPost (#)', 'Entries diff, TestPost-TestPre (#)'};

% load data
load('GF_conditioning_explo_results_POS_4lines.mat');
D4P = GF_conditioning_explo_results_POS_4lines;
load('GF_conditioning_explo_results_NEG_4lines.mat');
D4N = GF_conditioning_explo_results_NEG_4lines;

  
%% just negative
% small corrections on data
D4N(metrics([3 4]),:) = D4N(metrics([3 4]),:)* 600 / 1000; % transform latencies in seconds
Diff_Latency_Neg = D4N(metrics(4), :); 
Diff_Occup_Neg = D4N(metrics(2), :); 

ind_neg = or(Diff_Occup_Neg>0 , Diff_Occup_Neg<-50); % mice that didn't learn or dirty in TestPre
D4N(metrics,ind_neg) = NaN;
D4N(metrics,19) = NaN; % 2nd Maze experiment
D4N(metrics(4),16) = NaN; % outlier for latency

An=D4N(4, :); % replay buffer size

% figures
figure
for i=1:length(metrics)
    subplot(3,2,i)
    
    Bn=D4N(metrics(i), :);
    [Rn, Pn] = PlotCorrelations_BM_EM(An , Bn , 'method',met,'color','r', 'legend', 1); %legend 1 does not show the legend
    axis square
    xlabel('# replay model');
    ylabel(yl{i})
    if i==1
        ylim([0 35])
    elseif i==2
        ylim([-60 10])
    elseif i==3        
        ylim([0 1500])
    elseif i==4        
        ylim([-500 1500])
    elseif i==5        
        ylim([0 14])
    elseif i==6     
        ylim([-20 0])
    end
    txt = ['\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
    text(max(An) + 3,max(Bn),txt);
end

% figures to keep in mind
figure
subplot(121)
Bn=D4N(metrics(4), :);
[Rn, Pn] = PlotCorrelations_BM_EM(An , Bn , 'method',met,'color','k', 'legend', 1); %legend 1 does not show the legend
axis square
xlabel('# replay model'); ylabel(yl{4});
txt = ['\color{black} R = ' num2str(Rn) '     P = ' num2str(Pn)]; text(max(An) + 3,max(Bn),txt);

subplot(122)
Bn=D4N(metrics(2), :);
[Rn, Pn] = PlotCorrelations_BM_EM(An , Bn , 'method',met,'color','k', 'legend', 1); %legend 1 does not show the legend
axis square
xlabel('# replay model'); ylabel(yl{2});
txt = ['\color{black} R = ' num2str(Rn) '     P = ' num2str(Pn)]; text(max(An) + 3,max(Bn),txt);


%% just positive
D4P(metrics([3 4]),:) = D4P(metrics([3 4]),:)*600/1000; % transform latencies in seconds

D4P(metrics(2), [4 7 11]) = NaN; % outlier for TestPre occupancy
D4P(metrics(4), 2) = NaN; % outlier for TestPre latency
D4P(metrics(6), D4P(metrics(6),:)<0) = NaN; % mice that didn't learn
% D4P(metrics, [11 13 15 17]) = NaN; % 2nd Maze experiment

Ap=D4P(4, :); % replay buffer size
met='pearson';

figure
for i=1:length(metrics)
    subplot(3,2,i)
    
    Bp = D4P(metrics(i), :);
    [Rp, Pp] = PlotCorrelations_BM(Ap , Bp , 'method',met,'color','b', 'legend', 0); %legend 1 does not show the legend
    axis square    
    xlabel('# replay model');
    ylabel(yl{i});
        if i==1
        ylim([0 70])
    elseif i==2
        ylim([0 50])
    elseif i==3        
        ylim([0 90])
    elseif i==4        
        ylim([-200 60])
    elseif i==5        
        ylim([0 30])
    elseif i==6     
        ylim([-10 20])
        end
end

% figures to keep in mind
figure
Bp=D4P(metrics(6), :);
[Rn, Pn] = PlotCorrelations_BM_EM(Ap , Bp , 'method',met,'color','k', 'legend', 1); %legend 1 does not show the legend
axis square
xlabel('# replay model'); ylabel(yl{6}), ylim([0 17])
txt = ['\color{black} R = ' num2str(Rn) '     P = ' num2str(Pn)]; text(max(An) + 3,max(Bn),txt);



%% negative and positive
figure
for i=1:length(metrics)
    subplot(3,2,i)
    
    yyaxis right
    xlabel('# replay model');
    ylabel(yl{i});
    
    if or(i== 3, i==4)
        An=D4N(4, :) * 600 / 1000; Bn=D4N(metrics(i), :) * 600 / 1000;
    else
        An=D4N(4, :); Bn=D4N(metrics(i), :);
    end
    
    if and(eliminate_mice==1, or(i==3, i==4))
        Bn(19)=NaN;  % 2nd passage
        Bn(Bn<-160)=NaN;  % not learn, in TestPre enter too late in cz and in TestPost too soon (this last in particular) 
    elseif and(eliminate_mice==1, or(i==1, i==2))
       Bn(Bn>0)=NaN; Bn(Bn<-50)=NaN; Bn(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse
    end

    [Rn, Pn] = PlotCorrelations_BM_EM(An , Bn , 'method',met,'color','r', 'legend', 1); %legend 1 does not show the legend

    axis square
    hold on
    
    yyaxis left
    ylabel(yl{i})
    
    if or(i== 3, i==4)
        Ap=D4P(4, :) * 600 / 1000; Bp=D4P(metrics(i), :) * 600 / 1000;
    else
        Ap=D4P(4, :); Bp=D4P(metrics(i), :);
    end

    [Rp, Pp] = PlotCorrelations_BM_EM(Ap , Bp , 'method',met,'color','b', 'legend', 1); %legend 1 does not show the legend

    yyaxis right
    xlabel('# replay model')
    ylabel(yl{i})

    txt = ['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
    text(max(An) + 3,max(Bn),txt);

end


% replays number
Cols = {[1 .2 .2],[.2 1 .2]};
X = 1:2;
Legends = {'Negative','Positive'};
NoLegends = {'',''};

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({D4N(4,:) D4P(4,:)},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('replay buffer size')
title('All mice')

subplot(122)
A = D4N(4,:); A([13 17 19]) = NaN;
B = D4P(4,:); B(D4P(metrics(6),:)<0) = NaN;% B([11 13 15 17]) = NaN;
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0); 
title('Mice clean')

figure
MakeSpreadAndBoxPlot3_SB({D4N(4,:)./D4N(7,:) D4P(4,:)./D4P(7,:)},Cols,X,Legends,'showpoints',1,'paired',0); 
ylabel('replay buffer size')
title('All mice')


for param=1:3
    Param{param}{1} = D4N(param,:);
    Param{param}{2} = D4P(param,:);
end


figure
for param=1:3
    subplot(1,3,param)
    MakeSpreadAndBoxPlot3_SB(Param{param},Cols,X,Legends,'showpoints',1,'paired',0);
    title(var(param))
end



figure
subplot(121)
PlotCorrelations_BM(D4N(4,:) , D4N(7,:))
subplot(122)
PlotCorrelations_BM(D4N(4,:) , D4N(12,:))


figure
subplot(121)
PlotCorrelations_BM(D4P(4,:) , D4P(7,:))
subplot(122)
PlotCorrelations_BM(D4P(4,:) , D4P(12,:))


