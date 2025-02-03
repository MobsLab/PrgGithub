
function PlotVerifMFBstimEfficiencySpace(stim,X,Y,Epoch,paramMin,paramMax,ti,ma)

nameFile=pwd;
nameFile=nameFile(end-17:end);

try 
    ti;
catch
    ti=[];
end

load('MyColormaps','mycmap')

Xrtemp=rescale(Data(X),paramMin,paramMax);
Yrtemp=rescale(Data(Y),paramMin,paramMax);

Xrtsd=tsd(Range(X),Xrtemp);
Yrtsd=tsd(Range(Y),Yrtemp);

Xrtsd=Restrict(Xrtsd,Epoch);
Yrtsd=Restrict(Yrtsd,Epoch);

Xr=Data(Xrtsd);
Yr=Data(Yrtsd);

pxr=Data(Restrict(Xrtsd,Restrict(stim,Epoch)));
pyr=Data(Restrict(Yrtsd,Restrict(stim,Epoch)));
% 
% 
% [map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(stim,Epoch),Xrtsd,Yrtsd);

% Xr=rescale([40;Data(Restrict(X,Epoch));320],paramMin,paramMax);
% Yr=rescale([40;Data(Restrict(Y,Epoch));320],paramMin,paramMax);
% 
% Xr=Xr(2:end-1);
% Yr=Yr(2:end-1);
% 
% Xrtsd=tsd(Range(Restrict(X,Epoch)),Xr);
% Yrtsd=tsd(Range(Restrict(Y,Epoch)),Yr);
% 
% pxr=Data(Restrict(Xrtsd,Restrict(stim,Epoch)));
% pyr=Data(Restrict(Yrtsd,Restrict(stim,Epoch)));


[map,mapS,stats,px,py,FR,sizeFinal,PrField,C,ScField,pfH,pf]=PlaceField(Restrict(stim,Epoch),Restrict(X,Epoch),Restrict(Y,Epoch),'limitmaze',[0 140 0 160],'smoothing',2.8);



figure('color',[1 1 1])
imagesc(mapS.time),axis xy, 
try
    caxis([0 ma])
end
colorbar
hold on, plot(Xr,Yr,'r')
set(gcf,'Colormap',mycmap)
title([ti,' ',nameFile])


figure('color',[1 1 1])
hold on, plot(Xr,Yr,'k')
title([ti,' ',nameFile])

figure('color',[1 1 1])
imagesc(mapS.time),axis xy, 
try
    caxis([0 ma])
end
colorbar
set(gcf,'Colormap',mycmap)
title([ti,' ',nameFile])


figure('color',[1 1 1])
hold on, plot(Xr,Yr,'k')
hold on, plot(pxr,pyr,'r.')

figure('color',[1 1 1])
imagesc(mapS.rate),axis xy, colorbar
title([ti,' ',nameFile])

figure('color',[1 1 1])
imagesc(mapS.rate),axis xy, colorbar
hold on, plot(Xr,Yr,'w')
title([ti,' ',nameFile])
