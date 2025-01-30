
function [OmtS,OmtSTh,PosTh,Vit]=OccMap(Pos,vidFrames,vitArt,vitTh,sizeMap,plo)


try
    plo;
catch
    plo=0;
end

% size(Pos)

vitsmo=6;

% Remove artefact
[PosTh,speed]=RemoveArtifacts(Pos,vitArt);

% size(Pos)

dt=1/median(diff(Pos(:,1)));


for i=1:length(PosTh)-1
    Vx = (PosTh(i,2)-PosTh(i+1,2))/(dt);
    Vy = (PosTh(i,3)-PosTh(i+1,3))/(dt);
    Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Vit=SmoothDec(Vitesse',vitsmo);
Vit=[Vit;Vit(end)];

PosTh=PosTh(find(Vit>vitTh),:);


[Omt, x1, x2] = hist2d(Pos(:,2),Pos(:,3), sizeMap,sizeMap);
Omt=Omt/sum(sum(Omt))*100;

OmtS=SmoothDec(Omt,sizeMap/25);
OmtS/sum(sum(OmtS))*100;


figure('Color',[1 1 1])

subplot(2,3,1)


hist(speed,100)

yl=ylim;
hold on,line([vitArt vitArt],yl,'Color','r')
xlim([0 max(speed)])
ylabel('total time')

subplot(2,3,2)
imagesc(OmtS')
ca=caxis;
% caxis([0 ca(2)/3*2])
if plo==1
imagesc(log(OmtS'))
ca=caxis;
caxis([ca(1)/3 ca(2)])
%hold on, plot(rescale(Pos(:,2),0,sizeMap),rescale(Pos(:,3),0,sizeMap),'-','Color',[0.7 0.7 0.7])
end
% caxis([0 0.5])

ca=caxis;
ca=floor(ca*100)/100;
title(['min:',num2str(ca(1)), '    max:',num2str(ca(2))])

subplot(2,3,3)
imshow(vidFrames)
hold on, plot(Pos(:,2),Pos(:,3),'-','Color','k')
% hold on, plot(Pos(:,2),Pos(:,3),'.','Color','k')
% title(['CV=',num2str(std(Omt(:))/mean(Omt(:)))])
title(['CV=',num2str(std(OmtS(:))/mean(OmtS(:)))])

subplot(2,3,4),


hist(Vit,100)
xlim([0 max(Vit)])

yl=ylim;
hold on,line([vitTh vitTh],yl,'Color','g') 

ylabel('time (with speed threshold)')

[OmtTh, x1, x2] = hist2d(PosTh(:,2),PosTh(:,3), sizeMap,sizeMap);
OmtTh=OmtTh/sum(sum(OmtTh))*100;
OmtSTh=SmoothDec(OmtTh,sizeMap/25);
OmtSTh=OmtSTh/sum(sum(OmtSTh))*100;

subplot(2,3,5)
imagesc(OmtSTh')
ca=caxis;
% caxis([0 ca(2)/3*2])
if plo==1
    imagesc(log(OmtSTh'))
ca=caxis;
caxis([ca(1)/3 ca(2)])
%hold on, plot(rescale(PosTh(:,2),0,sizeMap),rescale(PosTh(:,3),0,sizeMap),'-','Color',[0.7 0.7 0.7])
end
% caxis([0 0.5])
ca=caxis;
ca=floor(ca*100)/100;
title(['min:',num2str(ca(1)), '    max:',num2str(ca(2))])


subplot(2,3,6)
imshow(vidFrames)
hold on, plot(PosTh(:,2),PosTh(:,3),'-','Color','k')
% title(['CV=',num2str(std(OmtTh(:))/mean(OmtTh(:)))])
title(['CV=',num2str(std(OmtSTh(:))/mean(OmtSTh(:)))])

