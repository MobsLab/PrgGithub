%function [ output_args ] = test_fwiine( input_args )
%TEST_FWIINE_3 example uses fWIIne function acquisition for Wiimote accel.
%and 4 IR dots
%sensor and 4 IR dots
%test_fwiine_3.m      v1.0        2009-02-05      William Alozy   


%--------------------------- initialization
a=0;b=0;c=0;d=0;e=0;t=0;
ax=0;ay=0;az=0;ir1x=0;ir1y=0;ir2x=0;ir2y=0;ir1h=0;ir2h=0;ir3x=0;ir3y=0;ir4x=0;ir4y=0;ir3h=0;ir4h=0;p1=0;p2=0;pa=0;pb=0;
A=[0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

% Start Wiimote
fWIIne(1);
disp('Press a key / Pressez une touche / Pulse una tecla ');
pause;
tic;
%--------------------------- principal

for j=1:6000
    [ax,ay,az,ir1x,ir1y,ir2x,ir2y,ir1h,ir2h,ir3x,ir3y,ir4x,ir4y,ir3h,ir4h,p1,p2,pa,pb]=fWIIne(7);
    t=toc;
    tic;
    %disp([ax,ay,az,ir1x,ir1y,ir2x,ir2y,ir1h,ir2h,ir3x,ir3y,ir4x,ir4y,ir3h,ir4h,p1,p2,pa,pb]);
    disp([ir1h,ir2h,p1]);
%pause(0.01);
    A=[A;[ax,ay,az,ir1x,ir1y,ir2x,ir2y,ir1h,ir2h,ir3x,ir3y,ir4x,ir4y,ir3h,ir4h,p1,p2,pa,pb,t]]; 
end;

%--------------------------- fin
% Stop Wiimote
disp('End/Fin');
fWIIne(0);
