%
% liste manipes
%-------------------------------------------------------------------------- 
%--------------------------------------------------------------------------
% 
%
%
%
%--------------------------------------------------------------------------
% Sleep
%-------------------------------------------------------------------------- 
%
%
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20120109/ICSS-Mouse-26-09012011
% 
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120207
% 
% %
% % cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208am/
% % 
% % cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120208pm/
% % 
% 
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse035/15052012/ICSS-Mouse-35-15052012
%
%
%
%--------------------------------------------------------------------------


%--------------------------------------------------------------------------
% wake manual
%--------------------------------------------------------------------------
% 
% 
% cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse017/20110614/ICSS-Mouse-17-14062011
% 
% cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse015/ICSS-Mouse-15-15062011
% 
% cd /media/Drobo2/DataD2/ICSS-Sleep/Mouse013/20110420/ICSS-Mouse-13-20042011
% 
% 
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
% wake place cell
%--------------------------------------------------------------------------
% 
% 
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse026/20111128/ICSS-Mouse-26-28112011
% 
% cd /media/DISK_2/Data2/ICSS-Sleep/Mouse029/20120209
% 
% cd /media/DISK_1/Data1/creationData/Mouse017/ICSS-Mouse-17-22062011
% 
%--------------------------------------------------------------------------



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
% 
% 
% load AnalyseResourcesICSS Res
% if renorm
%     Nor=Res{1};
%     Res{1}=Res{1}/mean(Nor);
%     Res{2}=Res{2}/mean(Nor);
%     Nor=Res{3};
%     Res{3}=Res{3}/mean(Nor);
%     Res{4}=Res{4}/mean(Nor);
% end
% Res1=Res;


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------





% 
% load ParametersAnalyseICSS
% varargin
% 
% [Res,mapS,pxS,pyS,PF,Xok,Yok]=AnalysisQuantifExploJan2012(o,N,M,varargin{1},varargin{2},varargin{3},varargin{4},varargin{5},varargin{6},varargin{7},varargin{8});














immobb=1; % remove immobile state
thPF=0.5;
smo=3;
sizeMap=50;
tpsTh=0.75*1E4;
Limdist=11;
Vth=20;
NumNeuron=0; % 0 si pas de place field, 6 pr M17-20110622
NumExplo=1; % Explo pour calculer le place field
limTemp=60;
posArt=1;
sav=0;
LargeAreaTh=6; %default value 6

Cctrl=1;

mi=8;
ma=57;

load behavResources

load('MyColormaps','mycmap')

% xM=max(Data(Restrict(Xok,and(TrackingEpoch,ExploEpoch))));
% yM=max(Data(Restrict(Yok,and(TrackingEpoch,ExploEpoch))));
% xm=min(Data(Restrict(Xok,and(TrackingEpoch,ExploEpoch))));
% ym=min(Data(Restrict(Yok,and(TrackingEpoch,ExploEpoch))));

xM=163;
xm=0;
yM=163;
ym=0;

for k=1:4
    try
figure('color',[1 1 1]), imagesc(mapS.rate), axis xy,hold on
EpochA2=subset(QuantifExploEpoch,M(k));
xa=rescale([xm; Data(Restrict(Xok,EpochA2)); xM],mi,ma);
xa=xa(2:end-1);
ya=rescale([ym; Data(Restrict(Yok,EpochA2)); yM],mi,ma);
ya=ya(2:end-1);
%plot(xa,ya,'color', 'w','linewidth',2)
plot(xa,ya, 'wo','markersize',2)
plot(xa(1),ya(1), 'ko','linewidth',2,'markerfacecolor','w','markersize',10)
title(['Trial no ',Num2str(k),' after sleep/MFB'])
    end
end


MAP=mapS.rate;
MAP(PF==0)=0;

for k=1:4
    try
figure('color',[1 1 1]), imagesc(MAP), axis xy,hold on
EpochA2=subset(QuantifExploEpoch,M(k));
xa=rescale([xm; Data(Restrict(Xok,EpochA2)); xM],mi,ma);
xa=xa(2:end-1);
ya=rescale([ym; Data(Restrict(Yok,EpochA2)); yM],mi,ma);
ya=ya(2:end-1);
%plot(xa,ya,'color', 'w','linewidth',2)
plot(xa,ya, 'wo','markersize',2)
plot(xa(1),ya(1), 'ko','linewidth',2,'markerfacecolor','w','markersize',10)
title(['Trial no ',Num2str(k),' after sleep/MFB'])
    end
end



for k=1:4
    try
figure('color',[1 1 1]), hold on
%plot(Data(Restrict(Xok,ExploEpoch)),Data(Restrict(Yok,ExploEpoch)),'color', [0.7 0.7 0.7])
plot(Data(Restrict(Xok,and(QuantifExploEpoch,TrackingEpoch))),Data(Restrict(Yok,and(QuantifExploEpoch,TrackingEpoch))),'color', [0.7 0.7 0.7])
EpochA2=subset(QuantifExploEpoch,M(k));
xa=Data(Restrict(Xok,EpochA2));
ya=Data(Restrict(Yok,EpochA2));
plot(xa,ya,'color', 'k','linewidth',2)
plot(xa(1),ya(1), 'ro','markerfacecolor','r')
title(['Trial no ',Num2str(k),' after sleep/MFB'])
    end
end



for k=1:4
    try
figure('color',[1 1 1])
EpochA2=subset(QuantifExploEpoch,M(k));
[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB((Restrict(Xok,EpochA2)),(Restrict(Yok,EpochA2)),'axis',[0 15],'smoothing',smo,'size',sizeMap,'limitmaze',[0 163]);close
imagesc(OcS1), axis xy, hold on
xa=rescale([xm; Data(Restrict(Xok,EpochA2)); xM],mi,ma);
xa=xa(2:end-1);
ya=rescale([ym; Data(Restrict(Yok,EpochA2)); yM],mi,ma);
ya=ya(2:end-1);
%plot(xa,ya,'color', 'w','linewidth',2)
plot(xa,ya, 'wo','markersize',2)
plot(xa(1),ya(1), 'ko','linewidth',2,'markerfacecolor','w','markersize',10)
title(['Trial no ',Num2str(k),' after sleep/MFB'])
set(gcf,'Colormap',mycmap)
    end
end

% 
% for i=1:15  
% %cd /media/DISK_1/Dropbox/Kteam/figurePresBuzsaki
% eval(['saveFigure(',num2str(i),',''FigureManipeSleep1n',num2str(i),''',''/media/DISK_1/Dropbox/Kteam/figurePresBuzsaki'')'])
% end
