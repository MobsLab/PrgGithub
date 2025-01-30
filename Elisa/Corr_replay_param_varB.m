
var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond',...
    'B-occ-cz-post', 'B-occ-cz-cond', 'B-diff-occup-cz-post-pre', 'B-diff-occup-cz-cond-pre',...
    'B-latency-enter-cz-post', 'B-cz-entries-post', 'B-cz-entries-cond'};

mice_pos = {'Mouse1117', 'Mouse1161', 'Mouse1162', 'Mouse1168', 'Mouse1336', 'Mouse1334', ...
    'Mouse1281', 'Mouse1257', 'Mouse1223', 'Mouse1182_1', 'Mouse1182_2', 'Mouse1199_1', 'Mouse1199_2',...
            'Mouse1317_1', 'Mouse1317_2', 'Mouse1239_1', 'Mouse1239_2', 'Mouse1228'};

        
M1=conditioning_explo_results_POS_2;
M1=conditioning_explo_results_NEG;

%% NEG
%% 1)
i=6;
figure

A=M1(4,:); B=M1(i,:);
B(19)=NaN; B(and(A>8 , B>400))=NaN;

PlotCorrelations_BM(A , B)
axis square
xlabel('replays'), ylabel('occup post')

%% 2)
i=12;
figure

A=M1(4,:); B=M1(i,:);
B(19)=NaN; B(and(A>8 , B>12))=NaN;

PlotCorrelations_BM(A , B , 'method','spearman')
% PlotCorrelations_BM(A , B , 'method','pearson')
axis square
xlabel('replays'), ylabel('occup post')


%% POS
%% 1)
i=6;
figure

A=M1(4,:); B=M1(i,:);
% B(19)=NaN; B(and(A>8 , B>400))=NaN;

PlotCorrelations_BM(A , B)
axis square
xlabel('replays'), ylabel('occup post')

%% 2)
i=12;
figure

A=M1(4,:); B=M1(i,:);
% B(19)=NaN; B(and(A>8 , B>12))=NaN;

PlotCorrelations_BM(A , B , 'method','spearman')
% PlotCorrelations_BM(A , B , 'method','pearson')
axis square
xlabel('replays'), ylabel('occup post')




