function FigureAnesthesia_Ap(A,B,plo)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
try
    plo;
catch
    plo=1;
end

if plo
    figure, hold on
end

p = [];
stats = {};
star = {};
plot = NaN(length(A), 2);
for j = 1:length(A)
    plot(j,1) = mean(A{j});
    plot(j,2) = mean(B{j});
end
bar(plot,1)

for k = 1:length(A)
    errorbar((k-1)+0.86,plot(k,1),stdError(A{k}),'color','k')
    errorbar(k+0.14,plot(k,2),stdError(B{k}),'color','k')
    
    [p(k), ~, stats{k}] = ranksum(A{k}, B{k});
    star{k} = [(k-1)+0.86, k+0.14];  
end


p(p>0.05) = NaN;
sigstar(star,p)
hold off
legend('opto','no opto')
end

