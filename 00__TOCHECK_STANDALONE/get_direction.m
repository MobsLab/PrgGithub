function     [t1bu,t1bbu,d1bu,d1bbu,t2bu,t2bbu,t2cbu,d2bu,d2bbu,d2cbu]=get_direction(position,xl,yl,xc,yc,xr,yr,choicemask,rewmask,fname);


% number of points --> time
% distance
cd(fname); 
 refim= load('reference_image.mat');
   refim=refim.ref;   
dt=median(diff( position(3,:)));

% get rid of reward and choice pts
position(isnan(position))=0;
a=choicemask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=diag(a);
ind=find(g);
position(1,ind)=0;
position(2,ind)=0;
a=rewmask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=diag(a);
ind=find(g);
position(1,ind)=0;
position(2,ind)=0;
position(position==0)=NaN;
goodpos=find(~isnan(position(1,:)));
t1=[];
t2=[];
d1=[];
d2=[];
t1b=[];
t2b=[];
d1b=[];
d2b=[];
t1c=[];
t2c=[];
d1c=[];
d2c=[];
for k=1:length(goodpos)-2
   t=goodpos(k);
   for p=1:3
    [vall(p),indl(p)]=min(sqrt((xl-position(1,goodpos(k+p-1))).^2+(yl-position(2,goodpos(k+p-1))).^2));
    [valc(p),indc(p)]=min(sqrt((xc-position(1,goodpos(k+p-1))).^2+(yc-position(2,goodpos(k+p-1))).^2));
    [valr(p),indr(p)]=min(sqrt((xr-position(1,goodpos(k+p-1))).^2+(yr-position(2,goodpos(k+p-1))).^2));
   end
[val,ind]=min([vall;valc;valr]);
if ind(1)==ind(2) & ind(2)==ind(3)
        ind=ind(1);
    if ind==1
        xloc=xl;
        yloc=yl;
        indloc=indl(1);
    elseif ind==2
        xloc=xc;
        yloc=yc;
       indloc=indc(1);

    else
        xloc=xr;
        yloc=yr;
        indloc=indr(1);
 end
    xint=xloc;
    xint(indloc)=NaN;
    yint=yloc;
    yint(indloc)=NaN;
    [nval,nind]=min(sqrt((xint-position(1,t)).^2+(yint-position(2,t)).^2));
    dist0=sqrt((xloc(min(indloc,nind))-position(1,t)).^2+(yloc(min(indloc,nind))-position(2,t)).^2);
    dist1=sqrt((xloc(min(indloc,nind))-position(1,goodpos(k+1))).^2+(yloc(min(indloc,nind))-position(2,goodpos(k+1))).^2);
    dist2=sqrt((xloc(min(indloc,nind))-position(1,goodpos(k+2))).^2+(yloc(min(indloc,nind))-position(2,goodpos(k+2))).^2);
    if dist1-dist0<0==0
       
        t1=[t1,t];
        d1=[d1,mean(abs(dist1-dist0))];
    else
        t1b=[t1b,t];
        d1b=[d1b,mean(abs(dist1-dist0))];
  
    end
    
    if dist1-dist0<0==0 &  dist2-dist0<0==0
        t2=[t2,t];
        d2=[d2,mean(abs(dist1-dist0))];
    elseif dist1-dist0<0==1 &  dist2-dist0<0==1
        t2b=[t2b,t];
        d2b=[d2b,mean(abs(dist1-dist0))];
    else
        t2c=[t2c,t];
        d2c=[d2c,mean(abs(dist1-dist0))];
        
    end
% else
%         clf
%         imagesc(double(refim));
% hold on
% scatter(position(1,t),position(2,t),'r','filled')
% scatter(position(1,goodpos(k+1)),position(2,goodpos(k+1)),'b','filled')
% scatter(position(1,goodpos(k+2)),position(2,goodpos(k+2)),'k','filled')
% pause
        

    end
    
end

t1diff=diff(t1);
cht1=find(t1diff~=1);
cht1=[t1(1),cht1];
d1bu=[];
t1bu=[];
for u=1:length(cht1)-1
    if cht1(u+1)-cht1(u)>3
        d1bu=[d1bu,sum(d1(cht1(u):cht1(u+1)))];
        t1bu=[t1bu,cht1(u+1)-cht1(u)]*dt;
    end
end

t1bdiff=diff(t1b);
cht1b=find(t1bdiff~=1);
cht1b=[t1b(1),cht1b];
d1bbu=[];
t1bbu=[];

for u=1:length(cht1b)-1
    if cht1b(u+1)-cht1b(u)>3
        d1bbu=[d1bbu,sum(d1b(cht1b(u):cht1b(u+1)))];
        t1bbu=[t1bbu,cht1b(u+1)-cht1b(u)]*dt;
    end
end

t2diff=diff(t2);
cht2=find(t2diff~=1);
cht2=[t2(1),cht2];
d2bu=[];
t2bu=[];

for u=1:length(cht2)-1
    if cht2(u+1)-cht2(u)>3
        d2bu=[d2bu,sum(d2(cht2(u):cht2(u+1)))];
        t2bu=[t2bu,cht2(u+1)-cht2(u)]*dt;
    end
end

t2bdiff=diff(t2b);
cht2b=find(t2bdiff~=1);
cht2b=[t2b(1),cht2b];
d2bbu=[];
t2bbu=[];

for u=1:length(cht2b)-1
    if cht2b(u+1)-cht2b(u)>3
        d2bbu=[d2bbu,sum(d2b(cht2b(u):cht2b(u+1)))];
        t2bbu=[t2bbu,cht2b(u+1)-cht2b(u)]*dt;
    end
end

t2cdiff=diff(t2c);
cht2c=find(t2cdiff~=1);
cht2c=[t2c(1),cht2c];
d2cbu=[];
t2cbu=[];

for u=1:length(cht2c)-1
    if cht2c(u+1)-cht2c(u)>3
        d2cbu=[d2cbu,sum(d2c(cht2c(u):cht2c(u+1)))];
        t2cbu=[t2cbu,cht2c(u+1)-cht2c(u)]*dt;
    end
end

cd ..
end
