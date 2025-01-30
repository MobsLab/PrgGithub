load ICSS-Mouse-07-03052011-05-QuantifExploCTRL2-wideband.mat

t=[0 180 210 390 420 600 630 810 840 1020];% temps en seconde
j=Pos(end,1)/T(end);
T=round(T*j);
V=[Pos(:,1),Pos(:,2),-Pos(:,3),[Vit;0]];
PC=[];
F=figure;

for k=2:2:length(T)-1
    
    PosC=V(V(:,1)>=T(k) & V(:,1)<T(k+1),:);
    
    Art=find(PosC(:,4)> min(10*median(PosC(:,4)),200));
    if isempty(Art)==0 && Art(1)==1
        Art(1)=[];
    end
    
    PosC(Art,:)=[];
    
    figure(F), subplot(3,2,k/2), scatter(PosC(:,2),PosC(:,3),25,PosC(:,1),'filled')
    hold on, plot(PosC(:,2),PosC(:,3),'k-')
    xlim([0 350])
    ylim([-300 0])
    Title(['Interval ', num2str(k),' : ',num2str(T(k)),'s - ',num2str(T(k+1)),'s.']);
    PC=[PC;PosC];
    figure(F), subplot(3,2,5), hold on, plot(PosC(:,2),PosC(:,3),'k-')
    
    
    %     figure, plot(PosCorr(:,2),PosCorr(:,3));
    %     xlim([0 350])
    %     ylim([0 300])
    %
    %     PosC=[PosC;PosCorr];
    clear PosC Art
end
figure(F), subplot(3,2,5), scatter(PC(:,2),PC(:,3),15,PC(:,1),'filled')
title('Intervals 2, 4, 6, and 8')
    xlim([0 350])
    ylim([-300 0])
