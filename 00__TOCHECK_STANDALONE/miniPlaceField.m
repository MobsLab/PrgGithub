function miniPlaceField(tsa,X,Y,sizeMap,smo)

try
    smo;
catch
    smo=1;
end

ColorPF=jet;
ColorPF(1,:)=[1 1 1];

[occH, x1, x2] = hist2d(Data(X), Data(Y), sizeMap, sizeMap);
pX = Restrict(X,tsa,'align','closest');
pY = Restrict(Y, tsa,'align','closest');
pfH = hist2d(Data(pX), Data(pY), x1, x2);

pf = 30 * pfH./occH;
pf(occH==0)=0;
PF=SmoothDec(pf,[smo,smo]);
occHs=SmoothDec(occH,[smo,smo]);
pfHs=SmoothDec(pfH,[smo,smo]);


pfHs=pfHs+1;
pfHs(occH==0)=0;
PF=PF+1;
PF(occH==0)=0;


figure('Color',[1 1 1])
subplot(1,3,1), imagesc(occHs'), axis xy
ca=caxis;
caxis([0 ca(2)])
subplot(1,3,2), imagesc(pfHs'), axis xy
ca=caxis;
caxis([0 ca(2)])
subplot(1,3,3), imagesc(PF'), axis xy
ca=caxis;
caxis([0 ca(2)])

colormap(ColorPF)






