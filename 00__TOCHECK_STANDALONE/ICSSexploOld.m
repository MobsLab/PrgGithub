function [M,Mt,Vit,OmS,OmtS]=ICSSexploOld(namefile,vitTh,smo)

try
    smo;
    som=[smo smo];
catch
    smo=[2 2];
end

try
    vitTh;
catch
    vitTh=10;
end

M=dlmread(namefile);

Mt=M;
dt=1/30;

for i=1:length(M)-1
Vx = (M(i,1)-M(i+1,1))/(dt);
Vy = (M(i,2)-M(i+1,2))/(dt);
Vitesse(i) = sqrt(Vx^2+Vy^2);
end;

Vit=SmoothDec(Vitesse',1);
M=M(Vit>vitTh,:);


[Om, x1, x2] = hist2d(M(:,1),M(:,2), 100, 100);
[Omt, x1, x2] = hist2d(Mt(:,1),Mt(:,2), 100, 100);

OmtS=SmoothDec(Omt,smo);
OmS=SmoothDec(Om,smo);
Qk=percentile(OmS(:),99);
Qkt=percentile(OmtS(:),99);


figure('Color',[1 1 1])

subplot(2,2,1),hold on
    plot(Mt(:,2),Mt(:,1),'k')
try
    plot(Mt(Mt(:,3)==2,2),Mt(Mt(:,3)==2,1),'r')
    plot(Mt(Mt(:,3)==3,2),Mt(Mt(:,3)==3,1),'b')
    plot(Mt(Mt(:,3)==4,2),Mt(Mt(:,3)==4,1),'g')
end
    title(namefile)
    
subplot(2,2,2)
    imagesc(OmtS), axis xy
    caxis([0 Qkt])
    
subplot(2,2,3),hold on
    plot(M(:,2),M(:,1),'k')
try
    plot(M(M(:,3)==2,2),M(M(:,3)==2,1),'r')
    plot(M(M(:,3)==3,2),M(M(:,3)==3,1),'b')
    plot(M(M(:,3)==4,2),M(M(:,3)==4,1),'g')
end

subplot(2,2,4)
    imagesc(OmS), axis xy
    caxis([0 Qk])
    









