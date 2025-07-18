%CompTrackGab

clear
close all

load Positions


% Compute speed
PosGs=PosG;
PosGs(:,2)=smooth(PosG(:,2),3);
PosGs(:,3)=smooth(PosG(:,3),3);
clear Vitesse
for i=1:length(PosGs)-1
    try
%     try
%     Vx = (PosGs(i-1,2)-PosGs(i+1,2))/(PosGs(i+1,1)-PosGs(i-1,1));
%     Vy = (PosGs(i-1,3)-PosGs(i+1,3))/(PosGs(i+1,1)-PosGs(i-1,1));
%     catch
    Vx = (PosGs(i,2)-PosGs(i+1,2))/(PosGs(i+1,1)-PosGs(i,1));
    Vy = (PosGs(i,3)-PosGs(i+1,3))/(PosGs(i+1,1)-PosGs(i,1));
%     end       

    Vitesse(i) = sqrt(Vx^2+Vy^2);
    
    if isnan(Vitesse(i))
        try
            Vitesse(i)=Vitesse(i+1);
        catch
            Vitesse(i)=Vitesse(i-1);
        end
    end

    if isinf(Vitesse(i))
        try
            Vitesse(i)=Vitesse(i+1);
        catch
            Vitesse(i)=Vitesse(i-1);
        end
    end
    end

end

VitG=smooth(Vitesse',3);

VitG(isinf(VitG))=nan;

save Positions



figure('color',[1 1 1]), plot((PosG(:,2)-min(PosG(:,2)))/max(PosG(:,2)),(PosG(:,3)-min(PosG(:,3)))/max(PosG(:,3)),'r')
hold on, plot((Pos(:,2)-min(Pos(:,2)))/max(Pos(:,2)),(Pos(:,3)-min(Pos(:,3)))/max(Pos(:,3)),'k')
title('Black: tracking Offline, Red: tracking Online')


figure('color',[1 1 1]), plot(Pos(2:end,2),Pos(2:end,3),'k')
hold on, scatter(Pos(2:end,2),Pos(2:end,3),30,Vit,'filled')
caxis([0 60]), colorbar
title('Tracking Offline')

figure('color',[1 1 1]), plot(PosG(2:end,2),PosG(2:end,3),'k')
hold on, scatter(PosG(2:end,2),PosG(2:end,3),30,VitG,'filled')
caxis([0 60]), colorbar
title('Tracking Online')

figure('color',[1 1 1]), 
subplot(3,1,1), hist(Vit,100),title('Tracking Offline'),xlabel('Speed'),ylabel('Occurence')
subplot(3,1,2), hist(VitG,100),title('Tracking Online'),xlabel('Speed'),ylabel('Occurence')

[h1,b1]=hist(Vit,100);
[h2,b2]=hist(VitG,b1);
subplot(3,1,3), plot(b1,h1,'k','linewidth',2), hold on, plot(b2,h2,'r','linewidth',2),xlabel('Speed'),ylabel('Occurence')
title('Black: tracking Offline, Red: tracking Online')

% 
% THVit=30;
% 
% figure('color',[1 1 1]),
% subplot(2,1,1), hold on, 
% plot(Pos(2:end,2),Pos(2:end,3),'k')
% plot(Pos(find(Vit>THVit),2),Pos(find(Vit>THVit),3),'r.')%,'markerfacecolor','r')
% 
% subplot(2,1,2), hold on
% plot(PosG(2:end,2),PosG(2:end,3),'k')
% plot(PosG(find(VitG>THVit),2),PosG(find(VitG>THVit),3),'r.')%','markerfacecolor','r')


if 0

PosTsd=tsd(Pos(:,1)*1E4,Pos(:,2:3));
PosGTsd=tsd(PosG(:,1)*1E4,PosG(:,2:3));
PosGTsd=Restrict(PosGTsd,PosTsd);

PosG2=Data(PosGTsd);
Pos2=Data(PosTsd);

tpsPosG2=Range(PosGTsd,'s');

for i=1:length(PosG2)-1
    Vx = (PosG2(i,1)-PosG2(i+1,1))/(tpsPosG2(i+1)-tpsPosG2(i,1));
    Vy = (PosG2(i,2)-PosG2(i+1,2))/(tpsPosG2(i+1)-tpsPosG2(i));
    VitesseG2(i) = sqrt(Vx^2+Vy^2);
end;
VitesseG2(isnan(VitesseG2))=0;
VitG2=SmoothDec(VitesseG2',1);


figure('color',[1 1 1]), plot((PosG2(:,1)-min(PosG2(:,1)))/max(PosG2(:,1)),(PosG2(:,2)-min(PosG2(:,2)))/max(PosG2(:,2)),'r')
hold on, plot((Pos2(:,1)-min(Pos2(:,1)))/max(Pos2(:,1)),(Pos2(:,2)-min(Pos2(:,2)))/max(Pos2(:,2)),'k')





figure('color',[1 1 1]), 
subplot(3,1,1), hist(Vit,100)
subplot(3,1,2), hist(VitG,100)
subplot(3,1,3), hist(VitG2,100)


figure, plot(Pos(2:end,2),Pos(2:end,3),'k')
hold on, scatter(Pos(2:end,2),Pos(2:end,3),30,log(1+Vit),'filled')
caxis([2 4.5])
figure, plot(PosG(2:end,2),PosG(2:end,3),'k')
hold on, scatter(PosG(2:end,2),PosG(2:end,3),30,log(1+VitG),'filled')

end

