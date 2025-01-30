%function [ output_args ] = test_fwiine( input_args )
%TEST_FWIINE example uses fWIIne function acquisition for Wiimote accel.
%sensor
%
%test_fwiine.m      v1.1        2008-05-10      William Alozy
%
%test_fwiine.m      v1.0        2008-01-19      William Alozy   


%--------------------------- initialization
a=0;b=0;c=0;t=0;
A=[0,0,0,0];

% Start Wiimote
fWIIne(1);
disp('Press a key / Pressez une touche / Pulse una tecla ');
pause;
tic;
%--------------------------- principal

for j=1:100
    [a,b,c]=fWIIne(3);
    t=toc;
    tic;
    disp([a,b,c]);
    pause(0.01);
    A=[A;[a,b,c,t]]; 
end;

%--------------------------- fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);
