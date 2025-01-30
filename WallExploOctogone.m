
% if save ==0 > result aren't saved
% if save ==1 > result are saved
Save=1;
disp(['save    >         ',num2str(Save)])

%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°1        ------------------------------------
%---------------------------------------------------------------------------------------------------------------
try load behavDataAlltrial1
catch
load ICSS-Mouse-114-21012014-01-ExploEnvBord-wideband
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


% Definition de l'octogone exterieur
disp('click on each angle')
[Xocto,Yocto]=ginput;
Xcentre=mean(Xocto);
Ycentre=mean(Yocto);
Ax=[Xcentre;Xocto(1,1)]; Ay=[Ycentre;Yocto(1,1)];
hold on, plot(Ax,Ay,'g','linewidth',2)
Bx=[Xcentre;Xocto(2,1)]; By=[Ycentre;Yocto(2,1)];
hold on, plot(Bx,By,'g','linewidth',2)
Cx=[Xcentre;Xocto(3,1)]; Cy=[Ycentre;Yocto(3,1)];
hold on, plot(Cx,Cy,'g','linewidth',2)
Dx=[Xcentre;Xocto(4,1)]; Dy=[Ycentre;Yocto(4,1)];
hold on, plot(Dx,Dy,'g','linewidth',2)
Ex=[Xcentre;Xocto(5,1)]; Ey=[Ycentre;Yocto(5,1)];
hold on, plot(Ex,Ey,'g','linewidth',2)
Fx=[Xcentre;Xocto(6,1)]; Fy=[Ycentre;Yocto(6,1)];
hold on, plot(Fx,Fy,'g','linewidth',2)
Gx=[Xcentre;Xocto(7,1)]; Gy=[Ycentre;Yocto(7,1)];
hold on, plot(Gx,Gy,'g','linewidth',2)
Hx=[Xcentre;Xocto(8,1)]; Hy=[Ycentre;Yocto(8,1)];
hold on, plot(Hx,Hy,'g','linewidth',2)

% Definition du rayon du cercle circonscrit optimal
VTheta=0:1:360;
VTheta=VTheta*pi/180;

for i=1:8
    Rayon=sqrt((Xocto(i,1)-mean(Xocto)).*(Xocto(i,1)-mean(Xocto))+(Yocto(i,1)-mean(Yocto)).*(Yocto(i,1)-mean(Yocto)));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    figure, plot(X,Y)
    hold on, plot(Ax,Ay,'g','linewidth',2)
    hold on, plot(Bx,By,'g','linewidth',2)
    hold on, plot(Cx,Cy,'g','linewidth',2)
    hold on, plot(Dx,Dy,'g','linewidth',2)
    hold on, plot(Ex,Ey,'g','linewidth',2)
    hold on, plot(Fx,Fy,'g','linewidth',2)
    hold on, plot(Gx,Gy,'g','linewidth',2)
    hold on, plot(Hx,Hy,'g','linewidth',2)
    hold on, plot(XCercle, YCercle,'g','linewidth',2)
    hold on, title(['Cercle circonscrit selon angle numero ',num2str(i)])
end

disp('choisir angle optimal (1:8)')
angle=input('     choisir angle optimal (1:8)    >>>  ');
Rayon=sqrt((Xocto(angle,1)-mean(Xocto)).*(Xocto(angle,1)-mean(Xocto))+(Yocto(angle,1)-mean(Yocto)).*(Yocto(angle,1)-mean(Yocto)));
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
close all
figure, plot(X,Y)
hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, title(['Cercle circonscrit selon angle numero ',num2str(i)])
    
    

% Definition de l'octogone central
for fac=Rayon*0.68:Rayon*0.01:Rayon*0.72
    figure, plot(X,Y)
    hold on, plot(XCercle, YCercle,'r','linewidth',2)
    
    degrees = linspace(0, 2*pi, 361);
    c = fac*cos(degrees+53)+mean(Xocto);
    s = fac*sin(degrees+53)+mean(Yocto);
    step = 360/8;
    hold on, plot(c(1:step:361), s(1:step:361),'r','linewidth',2)
    
    A1 = polyarea(XCercle, YCercle);
    A2 = polyarea(Xocto, Yocto);
    A3 = polyarea(c(1:step:361), s(1:step:361));
    title(['fac',num2str(fac), '- Real Octogone/2 : ',num2str(A2/2),' - False Octogone : ',num2str(A3)])
end

fac=input('     choisir fac optimal    >>>  ');
RayonIns=fac;
c = RayonIns*cos(degrees+53)+mean(Xocto);
XoctoIns=c(1:step:361);
s = RayonIns*sin(degrees+53)+mean(Yocto);
YoctoIns=s(1:step:361);
step = 360/8;
close all
figure, plot(X,Y)
hold on, plot(Xocto,Yocto,'r','linewidth',3)
hold on, plot(XoctoIns, YoctoIns,'r','linewidth',2)
A1 = polyarea(Xocto, Yocto);
A2 = polyarea(XoctoIns, YoctoIns);
title(['Real Octogone : ',num2str(A1),' - False Octogone : ',num2str(A2),' - Half-Real: ',num2str(A1/2)])



%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside1=[];
in=inpolygon(X,Y,XoctoIns,YoctoIns);
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
figure, plot(X,Y)
hold on, plot(XoctoIns, YoctoIns,'r','linewidth',2)

InOut1=[];
a=2;
InOut1(1,1:4)=POSinside1(1,1:4);
for i=1:length(POSinside1)-1
    if diff(POSinside1(i:i+1,3))>2
        InOut1(a,1:4)=POSinside1(i,1:4);
        InOut1(a,5)=i;
        a=a+1;
    end
end

for i=2:length(POSinside1)-1
    if diff(POSinside1(i-1:i,3))>2
        InOut1(a,1:4)=POSinside1(i,1:4);
        InOut1(a,5)=i;
        a=a+1;
    end
end
InOut1(a,1:4)=POSinside1(length(POSinside1),1:4);
disp(' ')
disp(' ')
disp(['   number of transition in session 1: ', num2str(length(InOut1))])

for i=1:length(InOut1);
    hold on, plot(InOut1(i,1),InOut1(i,2),'go','linewidth',2)
end
title(['number of transition in session 1:',num2str(length(InOut1))])
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



if Save==1;
    save  behavDataAlltrial1 POSth1 POSinside1  InOut1 TransMin1 tpsIns1 TPSrelatif1 TPStotal1 
    save  OctoData1 Xcentre Ycentre Rayon Xocto Yocto RayonIns XoctoIns YoctoIns  
    clearvars -except Save
end
end

%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
%--------------------------------------------------      Session n°2        ------------------------------------
%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------
try behavDataAlltrial2
catch
    
load ICSS-Mouse-114-21012014-02-ExploEnvBord2-wideband
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

% Definition de l'octogone exterieur
figure, plot(X,Y)
disp('click on each angle')
[Xocto,Yocto]=ginput;
Xcentre=mean(Xocto);
Ycentre=mean(Yocto);
Ax=[Xcentre;Xocto(1,1)]; Ay=[Ycentre;Yocto(1,1)];
hold on, plot(Ax,Ay,'g','linewidth',2)
Bx=[Xcentre;Xocto(2,1)]; By=[Ycentre;Yocto(2,1)];
hold on, plot(Bx,By,'g','linewidth',2)
Cx=[Xcentre;Xocto(3,1)]; Cy=[Ycentre;Yocto(3,1)];
hold on, plot(Cx,Cy,'g','linewidth',2)
Dx=[Xcentre;Xocto(4,1)]; Dy=[Ycentre;Yocto(4,1)];
hold on, plot(Dx,Dy,'g','linewidth',2)
Ex=[Xcentre;Xocto(5,1)]; Ey=[Ycentre;Yocto(5,1)];
hold on, plot(Ex,Ey,'g','linewidth',2)
Fx=[Xcentre;Xocto(6,1)]; Fy=[Ycentre;Yocto(6,1)];
hold on, plot(Fx,Fy,'g','linewidth',2)
Gx=[Xcentre;Xocto(7,1)]; Gy=[Ycentre;Yocto(7,1)];
hold on, plot(Gx,Gy,'g','linewidth',2)
Hx=[Xcentre;Xocto(8,1)]; Hy=[Ycentre;Yocto(8,1)];
hold on, plot(Hx,Hy,'g','linewidth',2)

% Definition du rayon du cercle circonscrit optimal
VTheta=0:1:360;
VTheta=VTheta*pi/180;

for i=1:8
    Rayon=sqrt((Xocto(i,1)-mean(Xocto)).*(Xocto(i,1)-mean(Xocto))+(Yocto(i,1)-mean(Yocto)).*(Yocto(i,1)-mean(Yocto)));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    figure, plot(X,Y)
    hold on, plot(Ax,Ay,'g','linewidth',2)
    hold on, plot(Bx,By,'g','linewidth',2)
    hold on, plot(Cx,Cy,'g','linewidth',2)
    hold on, plot(Dx,Dy,'g','linewidth',2)
    hold on, plot(Ex,Ey,'g','linewidth',2)
    hold on, plot(Fx,Fy,'g','linewidth',2)
    hold on, plot(Gx,Gy,'g','linewidth',2)
    hold on, plot(Hx,Hy,'g','linewidth',2)
    hold on, plot(XCercle, YCercle,'g','linewidth',2)
    hold on, title(['Cercle circonscrit selon angle numero ',num2str(i)])
end

disp('choisir angle optimal (1:8)')
angle=input('     choisir angle optimal (1:8)    >>>  ');
Rayon=sqrt((Xocto(angle,1)-mean(Xocto)).*(Xocto(angle,1)-mean(Xocto))+(Yocto(angle,1)-mean(Yocto)).*(Yocto(angle,1)-mean(Yocto)));
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
close all
figure, plot(X,Y)
hold on, plot(XCercle, YCercle,'r','linewidth',2)
hold on, title(['Cercle circonscrit selon angle numero ',num2str(i)])
    
    

% Definition de l'octogone central
for fac=Rayon*0.68:Rayon*0.01:Rayon*0.72
    figure, plot(X,Y)
    hold on, plot(XCercle, YCercle,'r','linewidth',2)
    
    degrees = linspace(0, 2*pi, 361);
    c = fac*cos(degrees+53)+mean(Xocto);
    s = fac*sin(degrees+53)+mean(Yocto);
    step = 360/8;
    hold on, plot(c(1:step:361), s(1:step:361),'r','linewidth',2)
    
    A1 = polyarea(XCercle, YCercle);
    A2 = polyarea(Xocto, Yocto);
    A3 = polyarea(c(1:step:361), s(1:step:361));
    title(['fac',num2str(fac), '- Real Octogone/2 : ',num2str(A2/2),' - False Octogone : ',num2str(A3)])
end

fac=input('     choisir fac optimal    >>>  ');
RayonIns=fac;
c = RayonIns*cos(degrees+53)+mean(Xocto);
XoctoIns=c(1:step:361);
s = RayonIns*sin(degrees+53)+mean(Yocto);
YoctoIns=s(1:step:361);
step = 360/8;
close all
figure, plot(X,Y)
hold on, plot(Xocto,Yocto,'r','linewidth',3)
hold on, plot(XoctoIns, YoctoIns,'r','linewidth',2)
A1 = polyarea(Xocto, Yocto);
A2 = polyarea(XoctoIns, YoctoIns);
title(['Real Octogone : ',num2str(A1),' - False Octogone : ',num2str(A2),' - Half-Real: ',num2str(A1/2)])
disp(' ')
disp(' ')
disp(' ')
disp(' ')

%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSinside2=[];
in=inpolygon(X,Y,XoctoIns,YoctoIns);
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
figure, plot(X,Y)
hold on, plot(XoctoIns, YoctoIns,'r','linewidth',2)

InOut2=[];
a=2;
InOut2(1,1:4)=POSinside2(1,1:4);
for i=1:length(POSinside2)-1
    if diff(POSinside2(i:i+1,3))>2
        InOut2(a,1:4)=POSinside2(i,1:4);
        InOut2(a,5)=i;
        a=a+1;
    end
end

for i=2:length(POSinside2)-1
    if diff(POSinside2(i-1:i,3))>2
        InOut2(a,1:4)=POSinside2(i,1:4);
        InOut2(a,5)=i;
        a=a+1;
    end
end
InOut2(a,1:4)=POSinside2(length(POSinside2),1:4);
TransMin2=length(InOut2)/((length(Pos)/8)/60);
disp(' ')
disp(' ')
disp(['   number of transition in session 2: ', num2str(length(InOut2))])

for i=1:length(InOut2);
    hold on, plot(InOut2(i,1),InOut2(i,2),'go','linewidth',2)
end
title(['number of transition in session 2:',num2str(length(InOut2))])

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
    save  OctoData2 Xcentre Ycentre Rayon Xocto Yocto RayonIns XoctoIns YoctoIns
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