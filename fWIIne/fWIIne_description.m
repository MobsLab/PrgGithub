% function fWIIne(option, var1, var2)  - description / descripcion
%     
% 0) To Shutdown Com. / Terminer la Com. / Parar la Com ...
%
%     fWIIne(0);
% 
% 1) To Initialize Com / Initializer la Com / inicializar la Com ...
%
%     fWIIne(1);  
%
% 2) To Print Accel + IR  values / Pour ecrire les valeurs d'Accel et IR /
%    Par escribir valor de accel y IR ...
%
%     fWIIne(2);
%
% 3) To Return Positions (motion sensor) / Pour retourner les valeurs d'accel. /
%    Para devolver accel. valores ...
%
%     [aX,aY,aZ]=fWIIne(3);
%
% 4) To Return Positions (motion+IR sensor) / Pour retourner les valeurs des
%    capteurs d'Accel et IR / Para devolver valores (captadores de
%    accel. y IR) ...
%
%     [aX,aY,aZ,ir1X,ir1Y,ir2X,ir2Y,ir1flag,ir2flag]=fWIIne(4);
%
% 5) To Return Positions (motion+IR sensor+Button A,B,1,2) / Pour retourner
%    les valeurs des capteurs d'accel, IR et bouton / Para devolver valores
%    (captadores de accel,IR y pulsadores) ...
%
%     [aX,aY,aZ,ir1X,ir1Y,ir2X,ir2Y,ir1flag,ir2flag,Button1,Button2,ButtonA,ButtonB]=fWIIne(5);
%
% 6) To Return Positions (motion sensor) and Orientation (Pitch,Roll) / 
%    Pour retourner les valeurs d'accel. et orientation (tangage,roulis) /
%    Para devolver accel. valores y la orientacion
%
%     [aX,aY,aZ,Pitch,Roll]=fWIIne(6);
%
% 7) To Return Positions (motion+IR sensor (4 dots) +Button A,B,1,2) / Pour retourner
%    les valeurs des capteurs d'accel, IR (4 points) et bouton / Para devolver valores
%    (captadores de accel,IR (4 puntos) y pulsadores) ...
%
%     [aX,aY,aZ,ir1X,ir1Y,ir2X,ir2Y,ir1flag,ir2flag,Button1,Button2,ButtonA,ButtonB]=fWIIne(5);    
%     [aX,aY,aZ,ir1X,ir1Y,ir2X,ir2Y,ir1flag,ir2flag,ir3X,ir3Y,ir4X,ir4Y,ir3flag,ir4flag,Button1,Button2,ButtonA,ButtonB]=fWIIne(7);
%
%  3) To Return data from Wiimote(acceleration) and Wii Motion Plus (angular rate) / Pour retourner les donnees de la Wiimote 
%     (acceleration) et du Wii Motion Plus (derivee angulaire)
%    
%     [aX,aY,aZ,dRx,dRy,dRz]=fWIIne(8);
%
%%
   

