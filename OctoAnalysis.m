
% if save ==0 > result aren't saved
% if save ==1 > result are saved
clear all

Save=0;
disp(['save    >         ',num2str(Save)])

%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------

load behavResources
posX=Data(X);
posY=Data(Y);
tpsX=Range(X);
tpsY=Range(Y);

figure, plot(posX,posY)
hold on, axis([-5 105 -5 105])

try load Octogone
catch
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
figure, a=1;
for i=1:8
    Rayon=sqrt((Xocto(i,1)-mean(Xocto)).*(Xocto(i,1)-mean(Xocto))+(Yocto(i,1)-mean(Yocto)).*(Yocto(i,1)-mean(Yocto)));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    hold on, subplot(2,4,a)
    hold on, plot(posX,posY)
    hold on, axis([-5 105 -5 105])
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
    a=a+1;
end

disp('choisir angle optimal (1:8)')
angle=input('     choisir angle optimal (1:8)    >>>  ');
Rayon=sqrt((Xocto(angle,1)-mean(Xocto)).*(Xocto(angle,1)-mean(Xocto))+(Yocto(angle,1)-mean(Yocto)).*(Yocto(angle,1)-mean(Yocto)));
XCercle = Xcentre + Rayon * cos(VTheta);
YCercle = Ycentre + Rayon * sin(VTheta);
close all
  

% Definition de l'octogone central
figure, a=1;
A2 = polyarea(Xocto, Yocto);
disp(' ')
disp(' ')
disp (['>>>>>>>>>  Half-Area of Octogone = ',num2str(A2/2), '     <<<<<<<'])
disp(' ')
disp(' ')

for fac=Rayon*0.67:Rayon*0.01:Rayon*0.72
    hold on, subplot(2,3,a)
    hold on, plot(posX,posY)
    hold on, plot(XCercle, YCercle,'r','linewidth',2)
    hold on, axis([-5 105 -5 105])
    degrees = linspace(0, 2*pi, 361);
    c = fac*cos(degrees+53)+mean(Xocto);
    s = fac*sin(degrees+53)+mean(Yocto);
    step = 360/8;
    hold on, plot(c(1:step:361), s(1:step:361),'r','linewidth',2)
    a=a+1;
    A1 = polyarea(XCercle, YCercle);
    A3 = polyarea(c(1:step:361), s(1:step:361));
    hold on, title(['fac: ',num2str(fac),'    - False Octogone : ',num2str(A3)])
end

fac=input('     choisir fac optimal    >>>  ');
RayonIns=fac;
c = RayonIns*cos(degrees+53)+mean(Xocto);
XoctoIns=c(1:step:361);
s = RayonIns*sin(degrees+53)+mean(Yocto);
YoctoIns=s(1:step:361);
step = 360/8;
close all

%---------------------------------------------------------------------------------------
save  Octogone Xcentre Ycentre Rayon Xocto Yocto RayonIns XoctoIns YoctoIns  

clear all
load behavResources
load Octogone
posX=Data(X);
posY=Data(Y);
tpsX=Range(X);
tpsY=Range(Y);
end

%---------------------------------------------------------------------------------------
close all
figure, plot(posX,posY)
hold on, axis([-5 105 -5 105])
hold on, plot(Xocto,Yocto,'r','linewidth',3)
hold on, plot(XoctoIns, YoctoIns,'r','linewidth',2)
A1 = polyarea(Xocto, Yocto);
A2 = polyarea(XoctoIns, YoctoIns);
title(['Extenal Octogone : ',num2str(A1),' - Internal Octogone : ',num2str(A2)])


%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSins=[];
in=inpolygon(posX,posY,XoctoIns,YoctoIns);
POSins=[posX(in),posY(in)];
hold on, plot(POSins(:,1), POSins(:,2),'r+','linewidth',1)

for i=1:length(POSins)
    for j=1:length(posX)
        if POSins(i,1)==posX(j,1) && POSins(i,2)==posY(j,1)
            posX(j,2)=1;
            posY(j,2)=1;
        end
    end
end
posAll(:,1)=posX(:,1);
posAll(:,2)=posY(:,1);
posAll(:,3)=posX(:,2);

% Calcul du temps passé dans le perimetre central (%)
tpsIns=size(POSins)/size(posX)*100;
disp(' ')
disp(' ')
disp (['>>>>>>>>>  % of time spent in central area = ',num2str(tpsIns), '%     <<<<<<<<<<'])
disp(' ')
disp(' ')

% >>> Calcul du nombre d'entrées/sorties
InOut=[];
a=2;
InOut(1,1:2)=POSins(1,1:2);
for i=1:length(posAll)-1
    if posAll(i,3)==1 && posAll(i+1,3)==0
        InOut(a,1:2)=posAll(i,1:2);
        a=a+1;
    end
end
for i=1:length(posAll)-1
    if posAll(i,3)==1 && posAll(i-1,3)==0
        InOut(a,1:2)=posAll(i,1:2);
        a=a+1;
    end
end

disp(' ')
disp(' ')
disp(['>>>>>>>>>  number of transition : ', num2str(length(InOut)), '     <<<<<<<<<<'])
disp(' ')
disp(' ')

for i=1:length(InOut);
    hold on, plot(InOut(i,1),InOut(i,2),'go','linewidth',2)
end
title(['number of transition : ',num2str(length(InOut))])
TransMin=length(InOut)/((length(posAll)/freq)/60);

disp(' ')
disp(' ')
ok=input('     number of transition ok ? (o/n)    >>>  ','s');
if ok=='n',
    numb=input('     what is the right number of transition    >>>  ');
    TransMin=numb/((length(posAll)/freq)/60);
    disp(['   number of transition in session 1: ', num2str(numb)])
else
end

%--------------------------------------------------------------------------
save  behavDataOcto posAll  tpsIns InOut TransMin X Y
%--------------------------------------------------------------------------