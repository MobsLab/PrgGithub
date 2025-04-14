clear all;

%uiload;
load('./read_wmdf/floater');
traj=p_xy(:,:,[1]); %t=1 (i=17 c) ,t=7 (i=195)

%uiload;
load('./read_wmdf/pr916');
trajp=p_xy(:,:,[1,2]); %t=3 (i=27 cp), t=5 (i=29)
n=1;
mytraj(:,:,1)=traj(:,:,1);
%mytraj(:,:,2)=traj(:,:,2);
%mytraj(:,:,3)=traj(:,:,3);
%mytraj(:,:,1)=trajp(:,:,1);
%mytraj(:,:,5)=trajp(:,:,2);
WMinit;

sg=mytraj*sc;
Q=zeros(1,n);
Z20=zeros(1,n);
X=zeros(1,n);
P=zeros(1,n);
SN=zeros(1,n);
for i=1:n
[per_c,per_cp]=Q_percents(sg(:,:,i),sg(:,:,i),Xctr,Yctr);
Q(i)=per_c;
[Z20(i), dum]=Z_percents(sg(:,:,i),sg(:,:,i),Xp,Yp,20);
[X(i) dum]=Crossings(sg(:,:,i),sg(:,:,i),Xp,Yp,5);
[SN(i) P(i)]=Final_measure(sg(:,:,i),Xp,Yp);
end

display('This is for Q:')
Q=Q

display('This is for Z20:')
Z20=Z20

display('This is for X:')
X=X

display('This is for Proximity--P:')
P=P

display('This is for Proximity--New measure:')
SN=SN

figure(1)
for i=1:n
   
     subplot(1,n,i)
  
  
   loc=mytraj(:,:,i);
    plot(loc(:,1),loc(:,2));
    
     scale=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Rplat=5;
Rplat_s=Rplat/scale;
xplat_s=Xp/scale;
yplat_s=Yp/scale;
sc
     hold on; circle([xplat_s/sc yplat_s/sc],Rplat_s/sc,25,'r-');   
      hold on; circle([Xctr/(scale*sc) Yctr/(scale*sc)],60/(scale*sc),200,'black');
   axis equal; axis off; axis ij; 
  
end

