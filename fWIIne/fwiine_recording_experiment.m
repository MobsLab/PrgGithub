
%FWIINE_RECORDING_EXPERIMENT example uses fWIIne function acquisition 
% for recording Wiimote accel. sensor values
%fwiine_recording_experiment.m
%v1.0        2008-08-30      William Alozy   


%--------------------------- initialization / initialisation
a=0;b=0;c=0;d=0;e=0;t=0;
A=[0,0,0,0,0,0];

% Start Wiimote
fWIIne(1);
disp('Press a key / Pressez une touche / Pulse una tecla ');
pause;
tic;
%--------------------------- main / principal

for j=1:6000
    [a,b,c,d,e]=fWIIne(6);
    t=toc;
    tic;
    %disp([a,b,c,d,e]);
    %pause(0.01);
    A=[A;[a,b,c,d,e,t]]; 
end;

%--------------------------- end / fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);



regexpessai =input('Enter filename/Entrez nom du fichier : ','s');
disp('saving acquis. file.../sauvegarde fichier acquis...');
if (isempty(regexpessai))
    save('default.txt','A','-ASCII');
else
    save(regexpessai, 'A','-ASCII');
end;
disp('...done');
