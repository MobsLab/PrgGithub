function [Oc,OcS]=OccupancyMap(filename,GoodEpoch,sizeMap,smo,ca,list,logg)


eval(['load ',filename])
try
    th;
catch
th=0.95;
end

try
    sizeMap;
catch
    sizeMap=50;
end
try
    smo;
catch
    smo=2;
end

try
    logg;
catch
    logg=0;
end

%X=tsd(Pos(:,1)*1E4,Pos(:,2));
%Y=tsd(Pos(:,1)*1E4,Pos(:,3));


X=tsd(Pos(:,1)*1E4,Pos(:,2));
Y=tsd(Pos(:,1)*1E4,Pos(:,3));



Xr=Restrict(X,subset(GoodEpoch,list));
Yr=Restrict(Y,subset(GoodEpoch,list));

figure, 
%subplot(3,1,1), plot(Data(X), Data(Y))
subplot(2,1,1), hold on

% for i=1:length(Start(GoodEpoch))

try
    list;
catch
    list=[1:length(Start(GoodEpoch))];
end

for i=list
    
    
    subepoch=subset(GoodEpoch,i);
    
    st=Start(subepoch)-3E4;
    en=End(subepoch)+3E4;
    st(st<0)=0;

    bandEpoch=intervalSet(st,en);
  
    plot(Data(Restrict(X,bandEpoch)),Data(Restrict(Y,bandEpoch)),'r')  
    plot(Data(Restrict(X,subepoch)),Data(Restrict(Y,subepoch)),'b')  
    Xsub=Data(Restrict(X,subepoch));
    Ysub=Data(Restrict(Y,subepoch));    
    plot(Xsub(1),Ysub(1),'bo','markerfacecolor','b','linewidth',5)
    ylim([0 300])
    xlim([0 300])
end
%plot(Data(Xr),Data(Yr),'k','linewidth',2)  

[occH, x1, x2] = hist2d(Data(Xr), Data(Yr), sizeMap, sizeMap);
if logg==1
subplot(2,1,2), imagesc(x1,x2,log(SmoothDec(occH,[smo,smo])')), axis xy
else
subplot(2,1,2), imagesc(x1,x2,(SmoothDec(occH,[smo,smo])')), axis xy
end
ylim([0 300])
xlim([0 300])
try
caxis([ca])
end

if logg==1
OcS=log(SmoothDec(occH,[smo,smo])');
else
OcS=(SmoothDec(occH,[smo,smo])');
end
Oc=occH;
