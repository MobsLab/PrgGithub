function  [p,t,st,Pt,group]=CalculANOVA(A,B,C,D)

GA=[ones(size(A,1),1); 2*ones(size(B,1),1); ones(size(C,1),1); 2*ones(size(D,1),1)];
GB=[ones(size(A,1)+size(B,1),1); 2*ones(size(C,1)+size(D,1),1)];
X=[A;B;C;D];

PlotErrorBar4(A,B,C,D)

group{1}=GA;
group{2}=GB;
[p,t,st] = anovan(X, group,'model','interaction');
% [anvA, anvB, anvAB] = TwoWayAnova(X, GA, GB);

[h,p12]=ttest2(A,B);
[h,p34]=ttest2(C,D);

[h,p13]=ttest2(A,C);
[h,p24]=ttest2(B,D);

[h,p14]=ttest2(A,D);
[h,p23]=ttest2(B,C);

Pt=[p12,p34,p13,p24,p14,p23];

% disp('Pt=[p12,p34,p13,p24,p14,p23];')