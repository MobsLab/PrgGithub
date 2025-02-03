%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°1        ------------------------------------
%---------------------------------------------------------------------------------------------------------------

load ICSS-Mouse-114-21012014-03-ExploConfigE-wideband
POS1=[];
POS1=[POS1;Pos(1:(length(Pos)-1),1:3)];
POS1(:,4)=Vit;
POSth1=[];
POSth1=[POSth1;PosTh(1:(length(PosTh)-1),1:3)];
for i=1:length(PosTh)-1
        if ~isnan(PosTh(i,2)) && ~isnan(PosTh(i+1,2))
            Ndt=PosTh(i+1,1)-PosTh(i,1);
            Vx = (PosTh(i,2)-PosTh(i+1,2))/(Ndt);
            Vy = (PosTh(i,3)-PosTh(i+1,3))/(Ndt);
            Vitesse1(i) = sqrt(Vx^2+Vy^2);
        end
    end;
VitTh1=SmoothDec(Vitesse1',1);
POSth1(:,4)=VitTh1(:,1);    

X=POSth1(:,2);
Y=POSth1(:,3);
figure, plot(X,Y)
hold on, axis([50 600 0 500])
hold on, title('Determiner la taille maximale du lieu, en partant du coin Nord-Ouest')

% Definition de la limite circulaire de l'arene interieure (session 1 et 2)
[x,y]=ginput;
Xcentre=((x(2,1)-x(1,1))/2)+x(1,1);
Ycentre=((y(2,1)-y(1,1))/2)+y(1,1);
diffX=x(2,1)-x(1,1);
diffY=y(1,1)-y(2,1);
if diffY>diffX;
    Rayon = ((x(2,1)-x(1,1))/2);
    disp('rayon selon axes des X')
else
    Rayon = ((y(1,1)-y(2,1))/2);
    disp('rayon selon axes des Y')
end
    Rayon = Rayon-(0.1*Rayon);

VTheta=0:1:360;
VTheta=VTheta*pi/180;
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
hold on, plot(XCercle, YCercle,'k','linewidth',2)
hold on, title('Zone centrale du lieu - Session 1')

% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside1=[];
a=1;
for i=1:length(POSth1)
    if (X(i)-Xcentre)^2+(Y(i)-Ycentre)^2<(Rayon^2);
        POSinside1(a,:)=POSth1(i,:);
        a=a+1;
    end
end
hold on, plot(POSinside1(:,2), POSinside1(:,3),'r','linewidth',1)

% >>> Restriction des données au perimetre exterieur (position/temps/vitesse)
POSoutside1=[];
a=1;
for i=1:length(POSth1)
    if (X(i)-Xcentre)^2+(Y(i)-Ycentre)^2>(Rayon^2);
        POSoutside1(a,:)=POSth1(i,:);
        a=a+1;
    end
end
hold on, plot(POSoutside1(:,2), POSoutside1(:,3),'k','linewidth',1)

% >>> Calcul du nombre d'entrées/sorties
InOut1=[];
a=1;
for i=1:((length(POSth1))-1)
    if ((POSth1(i,2)-Xcentre)^2+(POSth1(i,3)-Ycentre)^2<=(Rayon^2)) & ((POSth1(i+1,2)-Xcentre)^2+(POSth1(i+1,3)-Ycentre)^2>=(Rayon^2))
        InOut1(a,1:4)=POSth1(i,:);
        InOut1(a+1,1:4)=POSth1(i+1,:);
        InOut1(a,5)=i;
        a=a+2;
    end
end
Transition1=length(InOut1)/2;
for b=1:length(InOut1);
    hold on, plot(InOut1(b,2),InOut1(b,3),'r+','linewidth',4)
end

% Calcul du temps passé dans le perimetre central (%)
tpsIns1=0;
for i=1:(length(POSinside1)-1)
    if POSinside1(i+1,1)-POSinside1(i,1)<0.11
       tpsIns1=tpsIns1+(POSinside1(i+1,1)-POSinside1(i,1));
    end
end
a=length(POSth1);
TPStotal1=POSth1(a,1);
TPSrelatif1=(tpsIns1/TPStotal1)*100;

% Calcul de la vitesse moyenne dans les deux perimètres
VitMoyIns1=mean(POSinside1(:,4));
VitMoyOut1=mean(POSoutside1(:,4));

save  behavDataAlltrial1 POS1 POSth1 POSinside1 POSoutside1 InOut1 tpsIns1 TPSrelatif1 TPStotal1 Transition1
save  CercleData Xcentre Ycentre Rayon XCercle YCercle
clearvars -except Xcentre Ycentre Rayon XCercle YCercle

%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°2        ------------------------------------
%---------------------------------------------------------------------------------------------------------------
load ICSS-Mouse-114-21012014-04-ExploConfigE-wideband
POS2=[];
POS2=[POS2;Pos(1:(length(Pos)-1),1:3)];
POS2(:,4)=Vit;
POSth2=[];
POSth2=[POSth2;PosTh(1:(length(PosTh)-1),1:3)];
for i=1:length(PosTh)-1
        if ~isnan(PosTh(i,2)) && ~isnan(PosTh(i+1,2))
            Ndt=PosTh(i+1,1)-PosTh(i,1);
            Vx = (PosTh(i,2)-PosTh(i+1,2))/(Ndt);
            Vy = (PosTh(i,3)-PosTh(i+1,3))/(Ndt);
            Vitesse2(i) = sqrt(Vx^2+Vy^2);
        end
    end;
VitTh2=SmoothDec(Vitesse2',1);
POSth2(:,4)=VitTh2(:,1);      

X=POSth2(:,2);
Y=POSth2(:,3);
figure, plot(X,Y)
hold on, axis([50 600 0 500])
hold on, plot(XCercle, YCercle,'k','linewidth',2)
hold on, title('Zone centrale du lieu - Session 2')


% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside2=[];
a=1;
for i=1:length(POSth2)
    if (X(i)-Xcentre)^2+(Y(i)-Ycentre)^2<(Rayon^2);
        POSinside2(a,:)=POSth2(i,:);
        a=a+1;
    end
end
hold on, plot(POSinside2(:,2), POSinside2(:,3),'r','linewidth',1)

% >>> Restriction des données au perimetre exterieur (position/temps/vitesse)
POSoutside2=[];
a=1;
for i=1:length(POSth2)
    if (X(i)-Xcentre)^2+(Y(i)-Ycentre)^2>(Rayon^2);
        POSoutside2(a,:)=POSth2(i,:);
        a=a+1;
    end
end
hold on, plot(POSoutside2(:,2), POSoutside2(:,3),'k','linewidth',1)

% >>> Calcul du nombre d'entrées/sorties
InOut2=[];
a=1;
for i=1:((length(POSth2))-1)
    if ((POSth2(i,2)-Xcentre)^2+(POSth2(i,3)-Ycentre)^2<=(Rayon^2)) & ((POSth2(i+1,2)-Xcentre)^2+(POSth2(i+1,3)-Ycentre)^2>=(Rayon^2))
        InOut2(a,1:4)=POSth2(i,:);
        InOut2(a+1,1:4)=POSth2(i+1,:);
        InOut2(a,5)=i;
        a=a+2;
    end
end
Transition2=length(InOut2)/2;
for b=1:length(InOut2);
    hold on, plot(InOut2(b,2),InOut2(b,3),'r+','linewidth',4)
end

% Calcul du temps passé dans le perimetre central (%)
tpsIns2=0;
for i=1:(length(POSinside2)-1)
    if POSinside2(i+1,1)-POSinside2(i,1)<0.11
       tpsIns2=tpsIns2+(POSinside2(i+1,1)-POSinside2(i,1));
    end
end
a=length(POSth2);
TPStotal2=POSth2(a,1);
TPSrelatif2=(tpsIns2/TPStotal2)*100;

% Calcul de la vitesse moyenne dans les deux perimètres
VitMoyIns2=mean(POSinside2(:,4));
VitMoyOut2=mean(POSoutside2(:,4));

save  behavDataAlltrial2 POS2 POSth2 POSinside2 POSoutside2 InOut2 tpsIns2 TPSrelatif2 TPStotal2 Transition2

%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------      Session n°1+2      ------------------------------------------
%---------------------------------------------------------------------------------------------------------------
clear all
load behavDataAlltrial1
load behavDataAlltrial2

POSth=[];
POSth=[POSth1;POSth2];
POSinside=[];
POSinside=[POSinside1;POSinside2];
POSoutside=[];
POSoutside=[POSoutside1;POSoutside2];
InOut=[];
InOut=[InOut1;InOut2];
tpsIns=tpsIns1+tpsIns2;
TPStotal=TPStotal1+TPStotal2;
TPSrelatif=(tpsIns/TPStotal)*100;
Transition=Transition1+Transition2;

save behavDataAll POSth POSinside POSoutside InOut tpsIns TPStotal TPSrelatif Transition
clear all

