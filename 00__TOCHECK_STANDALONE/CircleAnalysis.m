
% if save ==0 > result aren't saved
% if save ==1 > result are saved
clear all

Save=1;
disp(['save    >         ',num2str(Save)])


%---------------------------------------------------------------------------------------------------------------
%---------------------------------------------------------------------------------------------------------------

load behavResources
posX=Data(X);
posY=Data(Y);
tpsX=Range(X);
tpsY=Range(Y);


try load Circle
catch
    
    % Definition du centre du cercle
    figure, plot(posX,posY)
    hold on, axis([-5 105 -5 105])
    hold on, title('determiner les quatres limites du cercle')
    disp('determiner les quatres limites du cercle')
    [x,y]=ginput;
    Xcentre=mean(x);
    Ycentre=mean(y);
    hold on, plot(Xcentre,Ycentre,'go','linewidth',3)
    
    % Definition de la limite de l'arene
    VTheta=0:1:360;
    VTheta=VTheta*pi/180;
    
    close all
    figure, a=1;
    for i=1:4
        Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
        XCercle = Xcentre + Rayon * cos(VTheta);
        YCercle = Ycentre + Rayon * sin(VTheta);
        hold on, subplot(2,2,a)
        hold on, plot(posX,posY)
        hold on, axis([-5 105 -5 105])
        hold on, plot(XCercle, YCercle,'g','linewidth',2)
        hold on, title(['Cercle circonscrit selon axe  (nord/sud-est/ouest) > ',num2str(i)])
        a=a+1;
    end
    
    i=input('     choisir axe optimal (1-2)    >>>  ');
    Rayon=sqrt((x(i,1)-Xcentre).*(x(i,1)-Xcentre)+(y(i,1)-Ycentre).*(y(i,1)-Ycentre));
    XCercle = Xcentre + Rayon * cos(VTheta);
    YCercle = Ycentre + Rayon * sin(VTheta);
    close all
    figure, plot(posX,posY)
    hold on, plot(XCercle, YCercle,'r','linewidth',2)
    hold on, title(['Cercle session n°1 ',num2str(i)])
    
    % Definition de l'arène interieure (50% de l'aire totale)
    Air=(Rayon^2)*pi;
    AirIns=Air/2;
    RayonIns=sqrt(AirIns/pi);
    XCercleIns = Xcentre + RayonIns * cos(VTheta);
    YCercleIns = Ycentre + RayonIns * sin(VTheta);
    hold on, plot(XCercleIns, YCercleIns,'g','linewidth',2)
    hold on, axis([-5 105 -5 105])
    A1 = polyarea(XCercleIns, YCercleIns);
    A2 = polyarea(XCercle, YCercle);
    title(['Inside Circle Area = ',num2str(A1),'  vs  ',num2str(A2/2)]);
    
    %---------------------------------------------------------------------------------------
    save  Circle Xcentre Ycentre Rayon XCercle YCercle XCercleIns YCercleIns RayonIns  

    clear all
    load behavResources
    load Circle
    posX=Data(X);
    posY=Data(Y);
    tpsX=Range(X);
    tpsY=Range(Y);
end

%---------------------------------------------------------------------------------------
close all
figure, plot(posX,posY)
hold on, axis([-5 105 -5 105])
hold on, plot(XCercle,YCercle,'r','linewidth',3)
hold on, plot(XCercleIns, YCercleIns,'r','linewidth',2)
A1 = polyarea(XCercle, YCercle);
A2 = polyarea(XCercleIns, YCercleIns);
title(['Extenal Circle : ',num2str(A1),' - Internal Circle : ',num2str(A2)])

%---------------------------------------------------------------------------------------------------------------
%---------------------- adaptation a l'octogone centrale  ------------------------------
% >>> Restriction des données au perimetre central (position/temps/vitesse)
POSins=[];
in=inpolygon(posX,posY,XCercleIns,YCercleIns);
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
for i=2:length(posAll)
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
save  behavDataCircle posAll tpsIns InOut TransMin X Y
%--------------------------------------------------------------------------