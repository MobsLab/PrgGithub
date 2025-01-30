function [p,F]= StatsSlopeCompare(X,Y,a_theo,namesXY,CorrType)

% [p,F]= StatsSlopeCompare(X,Y)
%
% inputs
% X and Y = vectors containing values of two parameters
% a_theo = theoretical slope (default =1) 
% namesXY (optional) = {'Name Factor X', 'Name Foctor Y'}
% CorrType (optional) = 'Pearson' (default), 'Kendall' or 'Spearman'
X=[1 5 3 5 4 18 9 16 15 14 7 2]';
Y=X+3;
%% get X and Y into columns if not already
if size(X,1)==1, X=X';end
if size(Y,1)==1, Y=Y';end


%% plot Data
figure('Color',[1 1 1])

plot(X,Y,'.','MarkerSize',20)
hold on, line([0 max(X)],[0 max(X)],'Color',[0.5 0.5 0.5],'LineStyle',':')

if exist('namesXY','var') && length(namesXY)==2
    xlabel(namesXY{1}); ylabel(namesXY{2});
    title(['Correlation between ',namesXY{1},' and ',namesXY{2}])
else
    xlabel('Factor X'); ylabel('Factor Y');
    title('Correlation between factors X and Y')
end


%% Correlation
if exist('CorrType','var') && sum(strcmp(CorrType,{'Pearson' 'Kendall' 'Spearman'}))
    [RHO,PVAL] = corr(X,Y,'type',CorrType);
else
    [RHO,PVAL] = corr(X,Y,'type','Pearson');
end
a = polyfit(X,Y,1);
b= a(2);
a = a(1);

hold on, line([0 max(X)],[b a*max(X)+b],'Color','b')
text(min(X),mean(Y),['r2=',num2str(floor(100*RHO)/100),', p=',num2str(floor(1E4*PVAL)/1E4)],'Color','b')

%% Stats Compare slope to linear
% inspired from "Comprendre et réaliser les tests statistiques à l'aide de
% R" 2eme edition, Gael Millot, p.682

if ~exist('a_theo','var')
    a_theo = 1;
end

n = length(Y);
Yd = a*X+b;
SCE = sum((Y-Yd).^2);
sa = sqrt(SCE / ((n-2)*(n-1)*var(X)));
ta_calc = (a - a_theo)/sa;
%pval= tcdf(ta_calc,(n-2))*2;

% s=regstats(Y,X);
% deltab=s.beta(3)-s.beta(4);
% se=sqrt(s.covb(3,3)+s.covb(4,4)-2*s.covb(3,4));
% ta_calc=deltab/se;
pval= tcdf(-abs(ta_calc),(n-2))*2;

%% display

hold on, line([0 max(X)],[mean(Y-a_theo*X) a_theo*max(X)+mean(Y-a_theo*X)],'Color','r')
text(min(X),max(Y),['slope different from ',num2str(floor(100*a_theo)/100),' : p=',num2str(floor(1E4*pval)/1E4)],'Color','r')



