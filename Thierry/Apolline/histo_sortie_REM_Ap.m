
VectTotal = vectTotal;
figure
pas = 1000; % en millisecondes, multiple de 50

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

bar(X(floor(Nb./2):end),b(floor(Nb./2):end,:),'stacked') %for only the 30s after the stim
% bar(X,b,'stacked') %for the 30s before and the 30s after the stim

legend('SWS','REM','Wake')
ylim([0 100])

ylabel('nb de stim')
xlabel('temps de latence (s)')
str = sprintf('%d stim',Nb_Total_Stim);
legend(str)