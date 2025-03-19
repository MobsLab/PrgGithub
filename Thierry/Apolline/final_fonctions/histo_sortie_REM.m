function [] = histo_sortie_REM(VectTotal,pas)
%histo_sortie_REM this function plot the bar graph of the percentages of
%stim in each state (Wake, SWS, REM) during ..s after the start time of
%the stim. 
%   VectTotal = the matrice of the state of the mouse for several times
%   before and after the stim
%   pas = (en millisecondes, multiple de 50) the time between each bar on
%   the graph


pasNb = pas./50;
Nb = floor(length(VectTotal(1,:))./pasNb);

A = NaN(length(VectTotal(:,1)),Nb);


for k = 1:Nb
    A(:,k) = VectTotal(:,k*pasNb);
end

b = NaN(Nb,3);

for k = 1:Nb
    b(k,1) = (sum(A(:,k)==1));
    b(k,2) = (sum(A(:,k)==3));
    b(k,3) = (sum(A(:,k)==4));

end

b = (b./length(VectTotal(:,1)))*100;

X = 1:Nb;
X = X.*(pas/1000);
X = X-30;

figure
bar(X(floor(Nb./2):end),b(floor(Nb./2):end,:),'stacked') %for only the 30s after the stim
% bar(X,b,'stacked') %for the 30s before and the 30s after the stim

legend('SWS','REM','Wake')
ylim([0 100])

ylabel('percentage of stimulations')
xlabel('time after the stimulation')

end

