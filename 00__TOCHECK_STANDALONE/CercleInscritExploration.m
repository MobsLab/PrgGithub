load behavResources X Y
[Oc1,OcS1,OcR1,OcRS1]=OccupancyMapKB(X,Y,'axis',[0 1],'smoothing',0.5,'size',62,'limitmaze',[0 350]);

CC=OcR1;
CC(CC>0)=1;
GG=GravityCenter(CC);

[B,L,N,A] = bwboundaries(BW);


center=[30;30];

[xgrid,ygrid]=meshgrid([1:62],[1:62]);


M=(xgrid-center(1)).^2+(ygrid-center(2)).^2;

dis=1600;
r=0;
figure(1), clf

while r==0
    dis=dis-100;
M2=M;
M2(M2<=dis)=1;
M2(M2>dis)=0;
o=OcR1;
o(M2==1)=0;
r=length(find(o>0));
figure(1), imagesc(M2+OcR1), title(num2str(r))
pause(1)
end

dis=dis+100;

M2=M;
M2(M2<=dis)=1;
M2(M2>dis)=0;

figure(1), imagesc(M2+OcR1)


