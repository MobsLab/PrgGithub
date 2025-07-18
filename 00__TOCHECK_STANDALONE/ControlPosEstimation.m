


delayErr=0;
del=350;
pas=1;
a=1500; b=3000;

load PosPrediced
errAbs=sqrt((posE(:,1)-posR(:,1)).^2+(posE(:,2)-posR(:,2)).^2);
errXY=abs(posE-posR);



figure('color',[1 1 1])

subplot(2,2,1), hold on, plot(posR(a:pas:b,1),'k','linewidth',2),plot(posE(a:pas:b,1),'r','linewidth',2), plot(errXY(a:pas:b,1),'g','linewidth',2),plot(errAbs(a:pas:b),'b','linewidth',2), xlim([1 length(errXY(a:pas:b))])
ylabel('Position X axis')
ylim([0 105])
title('Red: estimated position, Black: true position')

subplot(2,2,3), hold on, plot(posR(a:pas:b,2),'k','linewidth',2), plot(posE(a:pas:b,2),'r','linewidth',2),plot(errXY(a:pas:b,2),'g','linewidth',2),plot(errAbs(a:pas:b),'b','linewidth',2), xlim([1 length(errXY(a:pas:b))])
ylabel('Position Y axis')
ylim([0 105])
subplot(2,2,[2,4]), hold on, 

plot(posR(a:pas:b,1),posR(a:pas:b,2),'k','linewidth',2), plot(posE(a:pas:b,1),posE(a:pas:b,2),'r','linewidth',2), 

ylim([-5 120])
xlim([-5 120])
%scatter(posE(a:pas:b,1),posE(a:pas:b,2),40,errAbs(a:pas:b),'filled'), colorbar



figure('color',[1 1 1]), hold on
for i=a:pas:b
line([posR(i,1),posE(i,1)],[posR(i,2),posE(i,2)],'color',[0.7 0.7 0.7])
end
plot(posE(a:pas:b,1),posE(a:pas:b,2),'r','linewidth',2)
plot(posR(a:pas:b,1),posR(a:pas:b,2),'k','linewidth',2)
hold on, scatter(posE(a:pas:b,1),posE(a:pas:b,2),35,errAbs(a:pas:b),'filled'), caxis([0 60]),colorbar

ylim([-5 120])
xlim([-5 120])



%--------------------------------------------------------------------------


if delayErr

if del>0
    posRd=posR(1:end-del,:);
    posEd=posE(del+1:end,:);
else
    posEd=posE(1:end+del,:);
    posRd=posR(-del+1:end,:);
    
end

%[posE,posR]=swithPos(posE,posR,400)


errAbsD=sqrt((posEd(:,1)-posRd(:,1)).^2+(posEd(:,2)-posRd(:,2)).^2);
errXYD=abs(posEd-posRd);


figure('color',[1 1 1])

subplot(2,2,1), hold on, plot(posRd(:,1),'k','linewidth',2), plot(posEd(:,1),'r','linewidth',2),plot(errXYD(:,1),'g','linewidth',2),plot(errAbsD,'b','linewidth',2), xlim([1 length(errXYD)])
ylabel('Position X axis')
title('Red: estimated position, Black: true position')

subplot(2,2,3), hold on, plot(posRd(:,2),'k','linewidth',2), plot(posEd(:,2),'r','linewidth',2),plot(errXYD(:,2),'g','linewidth',2),plot(errAbsD,'b','linewidth',2), xlim([1 length(errXYD)])
ylabel('Position Y axis')
subplot(2,2,[2,4]), hold on, plot(posRd(deb:end,1),posRd(deb:end,2),'k','linewidth',2), scatter(posEd(deb:end,1),posEd(deb:end,2),20,errAbsD(deb:end),'filled'), colorbar

end

bin=[0:1:80];
h=hist(errAbs(1:end),bin);

if 1
    figure('color',[1 1 1]), hold on
    plot(bin,h,'k','linewidth',2)
    xlabel('Erreur between true and predicted position')
end


if delayErr
hD=hist(errAbsD(1:end),bin);
plot(bin,hD,'r','linewidth',2)
title('black: true prediction, red: with delay')
end





save Analysis h bin errAbs errXY



