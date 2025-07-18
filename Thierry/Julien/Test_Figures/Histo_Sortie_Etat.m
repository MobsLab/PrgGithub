function Histo_Sortie_Etat
figure
VectTotal = vectTotal;
pas = 1000; % en millisecondes, multiple de 50

pasNb = pas./50;
Nb = floor(length(VectTotal(1,:))./pasNb);

A = NaN(length(VectTotal(:,1)),Nb);


for k = 1:Nb
    A(:,k) = VectTotal(:,k*pasNb);
end

b = NaN(Nb,3);

for k = 1:Nb
    b(k,1) = sum(A(:,k)==1);
    b(k,2) = sum(A(:,k)==3);
    b(k,3) = sum(A(:,k)==4);

end

X = 1:Nb;
X = X.*(pas/1000);
X = X-30;
bar(X,b,'stacked')
legend('SWS','REM','Wake')
xlim([0 30])
end