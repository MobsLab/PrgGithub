%% load data and variables

load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_POS_3lines.mat')
M5P = conditioning_explo_results_POS_3lines;

load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_NEG_3lines.mat')
M5N = conditioning_explo_results_NEG_3lines;

% load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_POS_2.mat')
% M5P = conditioning_explo_results_POS_2;
% 
load('/home/mobs/Desktop/Elisa/Matlab_variables/conditioning_explo_results_NEG.mat')
M5N_ = conditioning_explo_results_NEG;

var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond',...
    'B-occ-cz-post', 'B-occ-cz-cond', 'B-diff-occup-cz-post-pre', 'B-diff-occup-cz-cond-pre',...
    'B-latency-enter-cz-post', 'B-cz-entries-post', 'B-cz-entries-cond'}

%% 
var = {'W-values', 'alpha', 'discount-rate', 'replay-buffer-size', 'B-stim-cond',...
    'B-occ-cz-post', 'B-occ-cz-cond', 'B-diff-occup-cz-post-pre', 'B-diff-occup-cz-cond-pre',...
    'B-latency-enter-cz-post', 'B-cz-entries-post', 'B-cz-entries-cond', 'B-diff-latency', 'B-perc-diff-occup-cz-post-pre'}

load('/home/mobs/Desktop/Elisa/Matlab_variables/NEW_conditioning_explo_results_POS_4lines.mat');
load('/home/mobs/Desktop/Elisa/Matlab_variables/NEW_conditioning_explo_results_NEG_4lines.mat');
new_M4P = NEW_conditioning_explo_results_POS_4lines;
new_M4N = NEW_conditioning_explo_results_NEG_4lines;


figure
subplot(121)
% yyaxis right
% xlabel('# replay model')
% ylabel('diff occupancy of the shock zone (post-pre)')
A=new_M4N(4, :); B=new_M4N(14, :);
B(B>0)=NaN; B(B<-50)=NaN; B(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse
% B(19)=NaN;  % 2nd passage
% B(B<-50) = NaN;
[Rn, Pn] = PlotCorrelations_BM_EM(A , B , 'method','spearman','color','r', 'legend', 1); %legend 1 does not show the legend
axis square

hold on

% yyaxis left
% ylabel('diff occupancy of the reward zone (post-pre)')
% A=M5P(4, :); B=M5P(8, :);
% % B([11 13 15 17]) = NaN; % 2nd passage
% % B(B>80) = NaN;  % take too much to go to the reward, not learned
% % A(and(A>8 , B>20))=NaN; % weird mouse (Mouse1336)
% [Rp, Pp] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','b', 'legend', 1); %legend 1 does not show the legend
% 

% yyaxis right
xlabel('# replay model')
ylabel('diff occupancy of the shock zone (post-pre), %')

% txt = ['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
% text(2.5,-200,txt)
txt = ['\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
text(2.5,0,txt)



subplot(122)

yyaxis right
xlabel('# replay model')
ylabel('diff latency to enter the shock zone (post-pre), s')
A=new_M4N(4, :) * 600 / 1000; B=new_M4N(13, :) * 600 / 1000;
B(19)=NaN;  % 2nd passage
B(B<-160)=NaN;  % not learn, in TestPre enter too late in cz and in TestPost too soon (this last in particular) 

[Rn, Pn] = PlotCorrelations_BM_EM(A , B , 'method','spearman','color','r', 'legend', 1); %legend 1 does not show the legend
axis square

hold on

yyaxis left
ylabel('diff latency to enter the shock zone (post-pre), s')
A=new_M4P(4, :) * 600 / 1000; B=new_M4P(13, :) * 600 / 1000;
B([11 13 15 17]) = NaN; % 2nd passage
B(B>50) = NaN;  % take too much to go to the reward, not learned
% A(and(A>8 , B>20))=NaN; % weird mouse (Mouse1336)
[Rp, Pp] = PlotCorrelations_BM_EM(A , B , 'method','spearman','color','b', 'legend', 1); %legend 1 does not show the legend


yyaxis right
xlabel('# replay model')
ylabel('diff latency to enter the shock zone (post-pre), s')

txt = ['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
text(1.5,750,txt)

% txt = ['\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
% text(2.5,1250,txt)



%%

A=M5P(4, :); B=M5P(6, :);
B(B<700)=NaN; 


figure
PlotCorrelations_BM_EM(A , B , 'method','pearson','legend', 0)
PlotCorrelations_BM_EM(A , B , 'method','spearman')
axis square
xlabel('replay #'), ylabel('Latency TestPost')


Cols = {[1 0 0],[0 1 0]};
X = [1 2];
Legends = {'Neg','Pos'};


figure
MakeSpreadAndBoxPlot3_SB({M5N(4,:) M5P(4,:)},Cols,X,Legends,'showpoints',1,'paired',0,'optiontest','ttest')
A=M5N(4,:);
B=M5P(4,:);
A(19)=NaN; %2 exp of a mouse
B([11 13 15 17]) = NaN; % 2nd passage

figure
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0)
MakeSpreadAndBoxPlot3_SB({A B},Cols,X,Legends,'showpoints',1,'paired',0,'optiontest','ttest')

[h,p] = ttest2(M5N(4,:) , M5P(4,:))
[h,p] = ttest2(A , B)





%% Latency vs model replay POS and NEG (conditioning zone is 5 lines of tiles)
figure
subplot(121)
% yyaxis right
% xlabel('# replay model')
% ylabel('diff occupancy of the shock zone (post-pre)')
A=M5N_(4, :); B=M5N_(8, :);
B(B>0)=NaN; B(B<-800)=NaN; B(19)=NaN;  % spend more time in sz in post than pre, spend too much time in sz in pre (no homog behav), 2 exp of a mouse
% B(19)=NaN;  % 2nd passage
[Rn, Pn] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','r', 'legend', 1); %legend 1 does not show the legend
axis square

hold on

% yyaxis left
% ylabel('diff occupancy of the reward zone (post-pre)')
% A=M5P(4, :); B=M5P(8, :);
% % B([11 13 15 17]) = NaN; % 2nd passage
% % B(B>80) = NaN;  % take too much to go to the reward, not learned
% % A(and(A>8 , B>20))=NaN; % weird mouse (Mouse1336)
% [Rp, Pp] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','b', 'legend', 1); %legend 1 does not show the legend
% 

% yyaxis right
xlabel('# replay model')
ylabel('diff occupancy of the shock zone (post-pre)')

% txt = ['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
% text(2.5,-200,txt)
txt = ['\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
text(2.5,-200,txt)



subplot(122)

yyaxis right
xlabel('# replay model')
ylabel('latency to enter the shock zone')
A=M5N(4, :); B=M5N(10, :);
B(19)=NaN;  % 2nd passage
[Rn, Pn] = PlotCorrelations_BM_EM(A , B , 'method','spearman','color','r', 'legend', 1); %legend 1 does not show the legend
axis square

hold on

yyaxis left
ylabel('latency to enter the reward zone')
A=M5P(4, :); B=M5P(10, :);
B([11 13 15 17]) = NaN; % 2nd passage
B(B>80) = NaN;  % take too much to go to the reward, not learned
A(and(A>8 , B>20))=NaN; % weird mouse (Mouse1336)
[Rp, Pp] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','b', 'legend', 1); %legend 1 does not show the legend


yyaxis right
xlabel('# replay model')
ylabel('latency to enter the shock zone')

txt = ['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
text(2.5,1250,txt)

% txt = ['\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)];
% text(2.5,1250,txt)



%% drafts

% co =  {'r','g'};
co = [1 0 0; 0 1 0];
set(gca,'ColorOrder', co, 'NextPlot', 'ReplaceChildren');
% set(gca,'ColorOrder',cOrder,'nextplot','replacechildren');
% colororder({'r','g'})
% f = get(gca,'Children')
% legend(f,['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)]);

% map = get(gca,'ColorOrder');
% co =  {'r','g'};
% set(gca,'ColorOrder', {'r','g'}, 'NextPlot', 'ReplaceChildren')
% f = get(gca,'Children')
% legend(f,['\color{blue} R = ' num2str(Rp) '     P = ' num2str(Pp) newline '\color{red} R = ' num2str(Rn) '     P = ' num2str(Pn)]);
% %hold on 
%f = get(gca,'Children')
%legend(f,['R = ' num2str(Rn) '     P = ' num2str(Pn)]);

A=M5P(4, :); B=M5P(10, :);
B([11 13 15 17]) = NaN; % 2nd passage
B(B>80) = NaN;  % take too much to go to the reward, not learned
A(and(A>8 , B>20))=NaN; % weird mouse
[Rp, Pp] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','b')


[R, P, ~, ~, ~, ~] = PlotCorrelations_BM_EM(A , B , 'method','pearson','color','r')













