function  [p,t,st,Pt,group]=CalculANOVAmultipleOneway(A)

X=[];
G=[];
for i=1:length(A)
if length(A{i})>1
X=[X;A{i}];
G=[G;i*ones(size(A{i},1),1)];
end

end

if length(A)==6
    PlotErrorBar6(A{1},A{2},A{3},A{4},A{5},A{6})
elseif length(A)==5
    PlotErrorBar5(A{1},A{2},A{3},A{4},A{5})
elseif length(A)==4
    PlotErrorBar4(A{1},A{2},A{3},A{4}) 
elseif length(A)==3
    PlotErrorBar3(A{1},A{2},A{3})  
end

group{1}=G;
[p,t,st] = anovan(X, group,'model','linear');

% [anvA, anvB, anvAB] = TwoWayAnova(X, GA, GB);

for i=1:length(A)
    for j=i+1:length(A)
[h,Pt{i,j}]=ttest2(A{i},A{j});
    end
end
