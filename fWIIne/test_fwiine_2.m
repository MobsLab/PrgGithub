%function [ output_args ] = test_fwiine( input_args )
%TEST_FWIINE_2 example uses fWIIne function acquisition for Wiimote accel.
%sensor and oritentation
%test_fwiine_2.m      v1.0        2008-05-10      William Alozy   


%--------------------------- initialization
a=0;b=0;c=0;d=0;e=0;t=0;
A=[0,0,0,0,0,0];

% Start Wiimote
fWIIne(1);
disp('Press a key / Pressez une touche / Pulse una tecla ');
pause;
tic;
%--------------------------- principal

for j=1:1000
    [a,b,c,d,e]=fWIIne(6);
    t=toc;
    tic;
    disp([a,b,c,d,e]);
    %pause(0.01);
    A=[A;[a,b,c,d,e,t]]; 
end;

%--------------------------- fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);
