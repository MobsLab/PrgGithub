%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%- test_fwiine4.m----------------------------------------------------------
%- displaying acceleration and angular rate values ------------------------
%- v0.1 --------------- September 2009 - William Alozy --------------------
%--------------------------------------------------------------------------
% - Object :    To record data from the Wiimote accelerometer and Wii
%               Motion Plus(WMP)
% - Objet  :    Enregistrer les donnees de l'accelerometre de la Wiimote et
%               du Wii Motion Plus(WMP)
%
%--------------------------------------------------------------------------
% 0.1 : sources 
%       http://fwiineur.blogspot.com/
%       Please start test_fwiine4 and follow the instructions inside Matlab
%       prompt
%       
%--------------------------------------------------------------------------

clear all; close all;
%--------------------------- initialization
a=0;b=0;c=0;d=0;e=0;f=0;t=0;
A=[0,0,0,0,0,0,0];

a1=0;z1=0;e1=0;Button1=0;r1=0;t1=0;y1=0;
disp('...');
disp('Pre-requisite             /   Pre-requis : ');
disp('Wiimote : paired          /   Wiimote : appairee ');
disp('WiiMotionPlus : unplugged ? /   WiiMotionPlus : debranche ?');
disp('...');
disp('Press [ENTER] if WiiMotionPlus is unplugged / Pressez [ENTREE] si WiiMotionPlus debranche ');
pause;
% Start Wiimote
fWIIne(1);
pause(0.02);
%--------------------------- plugging WMP
disp('...');
disp('Please plug WMP and press Button 1 to start / Branchez le WMP et pressez le Bouton 1 pour demarrer');
while 1
    [a,b,c,d,e,f,a1,z1,e1,Button1,r1,t1,y1]=fWIIne(5);
    pause(0.01);
    if Button1==1; break; end;
end;

disp('...');
disp('Starting Recording / Demarrage enregistrement  - 16s.');
disp('...running...');
tic;
%--------------------------- principal
for j=1:1000
    [a,b,c,d,e,f]=fWIIne(8);
    t=toc;
    tic;
   % disp([a,b,c,d,e,f]);
    pause(0.01);
    A=[A;[a,b,c,d,e,f,t]]; 
end;

%--------------------------- fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);



disp('-------------------');
disp('Starting analysis/Démarrage analyse');
disp('-------------------');
%--------------- Sampling time : error statistic distribution -------------
%--------------- Echantillonage : erreur statistique ----------------------
taille_A = size(A);
taille_data = taille_A(1,1);
taille_col = taille_A(1,2);
nbre_col = 10;
if taille_col<10
        A=[A(:,1:6) zeros(taille_data, nbre_col-taille_col) A(:,7)];
end;

hist(A(:,10),50);
title('Sampling time of the measure T(n)-T(n-1)');
legend('record');
xlabel('s.');ylabel('Nbr of data');

%--------------- Re-Sampling measurement ----------------------------------
%--------------- Re-echantillonage mesure ---------------------------------
% sampling time choice / choix du nouveau pas d'echantillonnage
t_sample=0.016; %previously : 0.015s
t_step=0;
%AS=[ax ay az 0 0 0 t_sample t_cumul_record]
AS=[0 0 0 0 0 0 0 0];
% cumulative time and sampling time / tps cumule et echantillonnage
for i=2:taille_data
    A(i,9)=A(i-1,9)+A(i,10);
    if (A(i,9)>t_sample+t_step)
        if (i==2)
            t_step = A(i,9);
            A(i,8)=t_sample+t_step;
        else
            A(i,8)=t_sample+t_step;
        end;
        t_step=t_step+t_sample;
        AS=[AS;[A(i,1) A(i,2) A(i,3) A(i,4) A(i,5) A(i,6) A(i,8) A(i,9)]];
    else
        %do nothing / rien
    end;    
end;

%--------------- displaying------------------------------------------------
taille_as = size(AS);
taille_data_as = taille_as(1,1);

disp('Av. sampling time in s. : ');
disp(mean(A(1:taille_data,10)));
disp('Selected sampling time in s. : ');
disp(t_sample);


%--------------- displaying -----------------------------------------------
%--------------- affichage ------------------------------------------------
% - Pitch and Roll
figure;
subplot(2,1,1);
plot(A(:,9),A(:,1),'b',A(:,9),A(:,2),'g',A(:,9),A(:,3),'r');
title(' Accelerometer Values - blue=Ax / green=Ay / red=Az');
xlabel('s');ylabel('.g m/s²');
subplot(2,1,2);
plot(A(:,9),A(:,4),'b',A(:,9),A(:,5),'g',A(:,9),A(:,6),'r');
title('Gyroscope Values - blue=dRx / green=dRy / red=dRz');
xlabel('s');ylabel('.ratioxx.deg/s²');
