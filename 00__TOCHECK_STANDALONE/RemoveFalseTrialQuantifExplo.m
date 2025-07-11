function numOK=RemoveFalseTrialQuantifExplo(num,lim,X,Y,QuantifExploEpoch,plo)


try
    plo;
catch
    plo=0;
end

le=length(num);
listOK=[];

if plo
figure('color',[1 1 1]),hold on
end


for i=1:length(num)
try
Epoch=subset(QuantifExploEpoch,num(i));

X1=Data(Restrict(X,Epoch));
Y1=Data(Restrict(Y,Epoch));
X1s=X1(1);
Y1s=Y1(1);

dis=tsd(Range(Restrict(X,Epoch)),sqrt((X1-X1s).*(X1-X1s)+(Y1-Y1s).*(Y1-Y1s)));

clear X1s
clear Y1s
if plo
    clf

    hold on, plot(Data(X),Data(Y),'color',[0.7 0.7 0.7])
    scatter(Data(Restrict(X,Epoch)),Data(Restrict(Y,Epoch)),30,Data(Restrict(dis,Epoch)),'filled'), caxis([0 lim]), title([num2str(num(i)),'  ',num2str(length(find(Data(dis)>lim)))])
    colorbar
    pause(2)
end

if length(find(Data(dis)>lim))>20
listOK=[listOK,i];
end
end
end

numOK=num(listOK);
