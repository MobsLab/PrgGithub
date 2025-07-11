
% if save ==0 > result aren't saved
% if save ==1 > result are saved
Save=1;
disp(['save    >         ',num2str(Save)])

%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°1        ------------------------------------
%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
try load behavDataAlltrial1
catch
load ICSS-Mouse-114-21012014-03-ExploConfigE-wideband
POSth1=[];
POSth1=[POSth1;PosTh(1:(length(PosTh)-1),1:3)];
for i=1:length(PosTh)-1
        if ~isnan(PosTh(i,2)) && ~isnan(PosTh(i+1,2))
            Ndt=PosTh(i+1,1)-PosTh(i,1);
            Vx = (PosTh(i,2)-PosTh(i+1,2))/(Ndt);
            Vy = (PosTh(i,3)-PosTh(i+1,3))/(Ndt);
            Vitesse1(i) = sqrt(Vx^2+Vy^2);
        end
end
VitTh1=SmoothDec(Vitesse1',1);
POSth1(:,4)=VitTh1(:,1);    

POSth1(POSth1(:,4)<30,:)=[];
POSth1(POSth1(:,4)>150,:)=[];
X=POSth1(:,2);
Y=POSth1(:,3);
figure, plot(X,Y)

%---------------------- definition du cercle ------------------------------
% Definition du centre du cercle
hold on, title('determiner les quatres limites du cercle')
disp('determiner les quatres limites du cercle')
[x,y]=ginput;
Xcentre=mean(x);
Ycentre=mean(y);
hold on, plot(Xcentre,Ycentre,'go','linewidth',3)

% Definition de la limite de l'arene
VTheta=0:1:360;
VTheta=VTheta*pi/180;

for i=1:2
    Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    figure, plot(X,Y)
    hold on, plot(XCercle, YCercle,'g','linewidth',2)
    hold on, title(['Cercle circonscrit selon axe choiICSS-Mouse-110-08122013-01-ExploConfigA-widebandsi numero (nord/sud-est/ouest) > ',num2str(i)])
end

i=input('     choisir axe optimal (1-2)    >>>  ');
Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
close all
figure, plot(X,Y)
hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, title(['Cercle session n°1 ',num2str(i)])

% Definition de l'arène interieure (50% de l'aire totale)
Air=(Rayon^2)*pi;
AirIns=Air/2;
RayonIns=sqrt(AirIns/pi);
XCercleIns = Xcentre + RayonIns * cos(VTheta);
YCercleIns = Ycentre + RayonIns * sin(VTheta);
hold on, plot(XCercleIns, YCercleIns,'g','linewidth',2)
A1 = polyarea(XCercleIns, YCercleIns);
A2 = polyarea(XCercle, YCercle);
title(['Inside Circle Area = ',num2str(A1),'  vs  ',num2str(A2/2)]);


%---------------------------------------------------------------------------------------------------------------
%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside1=[];
in=inpolygon(X,Y,XCercleIns,YCercleIns);
POSinside1=[X(in),Y(in)];
hold on, plot(POSinside1(:,1), POSinside1(:,2),'r+','linewidth',1)

for i=1:length(POSinside1)
    for j=1:length(POSth1)
        if POSinside1(i,1)==POSth1(j,2) && POSinside1(i,2)==POSth1(j,3)
            POSinside1(i,3)=POSth1(j,1);
            POSinside1(i,4)=POSth1(j,4);
        end
    end
end


% >>> Calcul du nombre d'entrées/sorties
InOut1=[];
a=1;
for i=1:((length(POSth1))-1)
    if ((POSth1(i,2)-Xcentre)^2+(POSth1(i,3)-Ycentre)^2<=(RayonIns^2)) & ((POSth1(i+1,2)-Xcentre)^2+(POSth1(i+1,3)-Ycentre)^2>=(RayonIns^2))
        InOut1(a,1:4)=POSth1(i,:);
        a=a+1;
    end
end
for i=1:((length(POSth1))-1)
    if ((POSth1(i,2)-Xcentre)^2+(POSth1(i,3)-Ycentre)^2>=(RayonIns^2)) & ((POSth1(i+1,2)-Xcentre)^2+(POSth1(i+1,3)-Ycentre)^2<=(RayonIns^2))
        InOut1(a,1:4)=POSth1(i,:);
        a=a+1;
    end
end
disp(' ')
disp(' ')
disp(['   number of transition in session 1: ', num2str(length(InOut1))])

hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, plot(XCercleIns, YCercleIns,'r','linewidth',2)
for i=1:length(InOut1);
    hold on, plot(InOut1(i,2),InOut1(i,3),'go','linewidth',2)
end
title(['number of transition in session 1:    ',num2str(length(InOut1))])

TransMin1=length(InOut1)/((length(Pos)/8)/60);
ok=input('     number of transition ok ? (o/n)    >>>  ','s');
if ok=='n',
    numb=input('     what is the right number of transition    >>>  ');
    TransMin1=numb/((length(Pos)/8)/60);
    disp(['   number of transition in session 1: ', num2str(numb)])
else
end

    
% Calcul du temps passé dans le perimetre central (%)
tpsIns1=0;
for i=1:(length(POSinside1)-1)
    if POSinside1(i+1,3)-POSinside1(i,3)>0 & POSinside1(i+1,3)-POSinside1(i,3)<2
       tpsIns1=tpsIns1+(POSinside1(i+1,3)-POSinside1(i,3));
    end
end
a=length(POSth1);
TPStotal1=POSth1(a,1);
TPSrelatif1=(tpsIns1/TPStotal1)*100;
disp(['   Time spent in central area in session 1: ', num2str(tpsIns1)])
disp(['   % of spent time in central area in session 1: ', num2str(TPSrelatif1)])
disp(' ')
disp(' ')
disp(' ')
disp(' ')


%---------------------------------------------------------------------------------------------------------------
if Save==1;
    save  behavDataAlltrial1 POSth1 POSinside1  InOut1 TransMin1 tpsIns1 TPSrelatif1 TPStotal1 
    save  CircleData1 Xcentre Ycentre Rayon XCercle YCercle RayonIns XCercleIns YCercleIns  
    clearvars -except Save
end
end

%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°2        ------------------------------------
%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
try load behavDataAlltrial2
catch
    
load ICSS-Mouse-114-21012014-04-ExploConfigE-wideband
POSth2=[];
POSth2=[POSth2;PosTh(1:(length(PosTh)-1),1:3)];
for i=1:length(PosTh)-1
        if ~isnan(PosTh(i,2)) && ~isnan(PosTh(i+1,2))
            Ndt=PosTh(i+1,1)-PosTh(i,1);
            Vx = (PosTh(i,2)-PosTh(i+1,2))/(Ndt);
            Vy = (PosTh(i,3)-PosTh(i+1,3))/(Ndt);
            Vitesse1(i) = sqrt(Vx^2+Vy^2);
        end
end
VitTh1=SmoothDec(Vitesse1',1);
POSth2(:,4)=VitTh1(:,1);    

POSth2(POSth2(:,4)<30,:)=[];
POSth2(POSth2(:,4)>150,:)=[];
X=POSth2(:,2);
Y=POSth2(:,3);

%---------------------- definition du cercle ------------------------------
% Definition du centre du cercle
figure, plot(X,Y)
hold on, title('determiner les quatres limites du cercle')
disp('determiner les quatres limites du cercle')
[x,y]=ginput;
Xcentre=mean(x);
Ycentre=mean(y);
hold on, plot(Xcentre,Ycentre,'go','linewidth',3)

% Definition de la limite de l'arene
VTheta=0:1:360;
VTheta=VTheta*pi/180;

for i=1:2
    Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    figure, plot(X,Y)
    hold on, plot(XCercle, YCercle,'g','linewidth',2)
    hold on, title(['Cercle circonscrit selon axe choisi numero (nord/sud-est/ouest) > ',num2str(i)])
end

i=input('     choisir axe optimal (1-2)    >>>  ');
Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
close all
figure, plot(X,Y)
hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, title(['Cercle session n°1 ',num2str(i)])

% Definition de l'arène interieure (50% de l'aire totale)
Air=(Rayon^2)*pi;
AirIns=Air/2;
RayonIns=sqrt(AirIns/pi);
XCercleIns = Xcentre + RayonIns * cos(VTheta);
YCercleIns = Ycentre + RayonIns * sin(VTheta);
hold on, plot(XCercleIns, YCercleIns,'g','linewidth',2)
A1 = polyarea(XCercleIns, YCercleIns);
A2 = polyarea(XCercle, YCercle);
title(['Inside Circle Area = ',num2str(A1),'  vs  ',num2str(A2/2)]);


%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside2=[];
in=inpolygon(X,Y,XCercleIns,YCercleIns);
POSinside2=[X(in),Y(in)];
hold on, plot(POSinside2(:,1), POSinside2(:,2),'r+','linewidth',1)

for i=1:length(POSinside2)
    for j=1:length(POSth2)
        if POSinside2(i,1)==POSth2(j,2) && POSinside2(i,2)==POSth2(j,3)
            POSinside2(i,3)=POSth2(j,1);
            POSinside2(i,4)=POSth2(j,4);
        end
    end
end


% >>> Calcul du nombre d'entrées/sorties
InOut2=[];
a=1;
for i=1:((length(POSth2))-1)
    if ((POSth2(i,2)-Xcentre)^2+(POSth2(i,3)-Ycentre)^2<=(RayonIns^2)) & ((POSth2(i+1,2)-Xcentre)^2+(POSth2(i+1,3)-Ycentre)^2>=(RayonIns^2))
        InOut2(a,1:4)=POSth2(i,:);
        a=a+1;
    end
end
for i=1:((length(POSth2))-1)
    if ((POSth2(i,2)-Xcentre)^2+(POSth2(i,3)-Ycentre)^2>=(RayonIns^2)) & ((POSth2(i+1,2)-Xcentre)^2+(POSth2(i+1,3)-Ycentre)^2<=(RayonIns^2))
        InOut2(a,1:4)=POSth2(i,:);
        a=a+1;
    end
end
disp(' ')
disp(' ')
disp(['   number of transition in session 1: ', num2str(length(InOut2))])

hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, plot(XCercleIns, YCercleIns,'r','linewidth',2)
for i=1:length(InOut2);
    hold on, plot(InOut2(i,2),InOut2(i,3),'go','linewidth',2)
end
title(['number of transition in session 1:    ',num2str(length(InOut2))])

TransMin2=length(InOut2)/((length(Pos)/8)/60);
ok=input('     number of transition ok ? (o/n)    >>>  ','s');
if ok=='n',
    numb=input('     what is the right number of transition    >>>  ');
    TransMin2=numb/((length(Pos)/8)/60);
    disp(['   number of transition in session 1: ', num2str(numb)])
else
end


% Calcul du temps passé dans le perimetre central (%)
tpsIns2=0;
for i=1:(length(POSinside2)-1)
    if POSinside2(i+1,3)-POSinside2(i,3)>0 & POSinside2(i+1,3)-POSinside2(i,3)<2
       tpsIns2=tpsIns2+(POSinside2(i+1,3)-POSinside2(i,3));
    end
end
a=length(POSth2);
TPStotal2=POSth2(a,1);
TPSrelatif2=(tpsIns2/TPStotal2)*100;
disp(['   Time spent in central area in session 2: ', num2str(tpsIns2)])
disp(['   % of spent time in central area in session 2: ', num2str(TPSrelatif2)])

if Save==1;
    save  behavDataAlltrial2 POSth2 POSinside2 InOut2 TransMin2 tpsIns2 TPSrelatif2 TPStotal2 
    save  CircleData2 Xcentre Ycentre Rayon XCercle YCercle RayonIns XCercleIns YCercleIns 
end
end


%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------      Session n°1+2      ------------------------------------------
%---------------------------------------------------------------------------------------------------------------
if Save==1;
    clear all
    load behavDataAlltrial1
    load behavDataAlltrial2

    POSth=[];
    POSth=[POSth1;POSth2];
    POSinside=[];
    POSinside=[POSinside1;POSinside2];
    InOut=[];
    InOut=[InOut1;InOut2];
    tpsIns=tpsIns1+tpsIns2;
    TPStotal=TPStotal1+TPStotal2;
    TPSrelatif=(tpsIns/TPStotal)*100;
    TransMin=(TransMin1+TransMin2)/2;

    save behavDataAll POSth POSinside InOut tpsIns TPStotal TPSrelatif TransMin
    clear all
end