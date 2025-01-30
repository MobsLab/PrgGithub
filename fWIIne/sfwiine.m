function [sys,x0,str,ts] = sfwiine(t,x,u,flag)
%SFWIINE S-Function for Wiimote data acquisition / S-fonction pour acquisition des donnres de la wiimote / S-funcion para adquisicion de datos de la Wiimote.
%
%    William Alozy
%    $Revision: 0.2 $  $Date: 2008/05/10 22:19:00 $
%
%    See also fWIIne / READ ME_LISEZ MOI.txt
%    http://sourceforge.net/projects/fwiine
%    http://fwiineur.blogspot.com/
%
%
switch flag,
  case 0
    [sys,x0,str,ts]=mdlInitializeSizes(); disp('init');% Initialization / Initialisation / Inicializacion
  case 1
    sys = mdlDerivatives(t,x,u); disp('case 1 never');% Unused / Non utilise / No utilizada
  case 2
    sys=mdlUpdate(t,x,u);
  case 3
    sys = mdlOutputs(t,x,u); % Ouput result / resultat acquisition / resulatdo de adquisicion de datos
  case { 4, 9 } % Never encountered / ne doit jamais arriver / No se debe encontrar nunca
    sys = []; disp('case 4 9 never ');disp(flag);
    fWIIne(0); % Stop Wiimote Com 
  otherwise
    error(['Unhandled flag = ',num2str(flag)]); % Simulink error ? / Erreur de Simulink ?
    disp('other never');
    fWIIne(0);% Stop Wiimote
end
% end of main function / fin de la fonction principale / fin de la funcion
% principal

%==============================================================
% mdlInitializeSizes
%
% Return dimensions, initial conditions and step time
% function is called once at simulation start
%
% Retourne les dimensions, conditions initiales et temps d'echantillonage.
% Cette fonction n'est appellee qu'une fois par Simulink en debut de
% simulation.
%
% Devolve dimensiones, condiciones iniciales y muestreo
% Este function se ha llamada una primera vez al inicio de la simulacion
%
%==============================================================
%
function [sys,x0,str,ts] = mdlInitializeSizes(A,B,C,D)
clear all;close all;
fWIIne(1);
% Dimensions / Dimensiones
sizes = simsizes;
sizes.NumContStates  = 0;
sizes.NumDiscStates  = 0;
sizes.NumOutputs     = 14;
sizes.NumInputs      = 1;
sizes.DirFeedthrough = 0;      
sizes.NumSampleTimes = 1;
sys = simsizes(sizes);
% Initial conditions / Conditions initiales /condiciones iniciales
x0  = [];%0;
str = []; % empty matrix / Matrice vide / Matriz vacia
tic; 
ts = [-1 0]; % same rate as simulation / meme echantillonnage que la simulation / lo mismo muestreo que la simulacion
% End of mdlInitializeSizes / Fin de mdlInitializeSizes.
%

%==============================================================
% mdlDerivatives
% Unused / Non utilise / No utilizada
%==============================================================
%
function sys = mdlDerivatives(t,x,u,A,B,C,D)
% Fin de mdlDerivatives.

%=============================================================================
% mdlUpdate
% Unused / Non utilise / No utilizada
%=============================================================================
%
function sys=mdlUpdate(t,x,u)
sys = [];

%==============================================================
% mdlOutputs
% Return outputs result / Retourne resultat acquis. / resulatdo de datos 
%==============================================================
%
function sys = mdlOutputs(t,x,u,A,B,C,D)

[a,b,c,d,e,f,g,h,i,j,k,l,m]=fWIIne(5);
t=toc;
tic;
pause(0.005); %pause
sys = [a,b,c,d,e,f,g,h,i,j,k,l,m,t];
% End of mdlOutputs. / Fin de mdlOutputs.


