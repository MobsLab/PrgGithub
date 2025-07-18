function PlotBarMarie(A,B,label)

%input
%
% A must be in (number of measures) x (number of conditions)
% B must be in (number of measures) x (number of conditions)
% label must be a cell array (label{n}='condition n'), with length(label)='number of conditions' 
%
%


[M1,S1,E1]=MeanDifNan(A);
[M2,S2,E2]=MeanDifNan(B);

figure('Color',[1 1 1])
hold on, errorbar([1:size(M1,2)]-0.14,M1,E1,'k+')
hold on, errorbar([1:size(M2,2)]+0.14,M2,E2,'k+')
hold on, bar([M1;M2],1)


try
set(gca,'xticklabel',label)
set(gca,'xtick',[1:size(M1,2)])
end
