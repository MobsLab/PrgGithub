function [position,st,tsh,tlo,rthenl,lthenr,uniqpos,tch]=LocatePts(position,choicemask,rewmask,xc,yc,xl,yl,xr,yr)

position(5,:)=0;
%choicezone
a=choicemask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=diag(a);
ind=find(g);
position(5,ind)=4;
tsh=[];
tlo=[];
%rewzone
a=rewmask(max(floor(position(2,:)),1),max(floor(position(1,:)),1));
g=diag(a);
ind=find(g);
position(5,ind)=5;

goodpos=find(position(5,:)==0);
for k=1:length(goodpos)
   t=goodpos(k);
    [vall,indl]=min(sqrt((xl-position(1,goodpos(k))).^2+(yl-position(2,goodpos(k))).^2));
    [valc,indc]=min(sqrt((xc-position(1,goodpos(k))).^2+(yc-position(2,goodpos(k))).^2));
    [valr,indr]=min(sqrt((xr-position(1,goodpos(k))).^2+(yr-position(2,goodpos(k))).^2));
   [val,ind]=min([valc;vall;valr]);
   if isnan(val)~=1
   position(5,t)=ind;
   else
          position(5,t)=NaN;

   end
end

    starting=find(~isnan(position(5,:)),1,'first');
    if starting~=1
    position(5,1:starting)=position(5,starting+1);
    end
for z=2:length(position)
    if isnan(position(5,z))==1
        position(5,z)=position(5,z-1);
    end
end

% get changes in location
      dpos=diff(position(5,:));
      zeroind=find(dpos);
      uniqpos=[position(5,zeroind),position(5,zeroind(end)+1)];
      for t=2:length(uniqpos)
         if isnan(uniqpos(t))==1
             uniqpos(t)=uniqpos(t-1);
         end
      end
      diffuniq=diff(uniqpos);
      zeroinduniq=find(diffuniq);
      uniqpos=[uniqpos(zeroinduniq),uniqpos(zeroinduniq(end)+1)];

%come back to position
num=1;
for i=1:length(position(5,:))
    if position(5,i)==uniqpos(num)
        position(6,i)=num;
    elseif isnan(position(5,i))==1
        position(6,i)=num;
    elseif position(5,i)==uniqpos(num+1)
        num=num+1;
        position(6,i)=num;
    end
end
sh=findstr(uniqpos,[4,1,5]);
dt=median(diff( position(3,:)));
for y=1:length(sh)
    tsh(y)=(find(position(6,:)==sh(y)+2,1,'first')-find(position(6,:)==sh(y),1,'last'))*dt;
end
lo=findstr(uniqpos,[4,2,5]);
for y=1:length(lo)
    tlo(y)=(find(position(6,:)==lo(y)+2,1,'first')-find(position(6,:)==lo(y),1,'last'))*dt;
end
ch=findstr(uniqpos,[4]);
for y=1:length(lo)
    tch(y)=(find(position(6,:)==ch(y),1,'first')-find(position(6,:)==ch(y),1,'last'))*dt;
end

lthenr=findstr(uniqpos,[2,4,1,5]);
rthenl=findstr(uniqpos,[1,4,2,5]);

      rewind=find(uniqpos==5);
      start1=find(uniqpos==1 | uniqpos==2,1,'first'); 
      start2=find(rewind>start1,1,'first');
      retval=0;
      choiceval=0;

      st=[];
     
st(1)=uniqpos(start1)-1;
     
for r=start2:length(rewind)-1
    uniqposint=uniqpos(rewind(r):rewind(r+1));
   
    lastchoice=find(uniqposint==4,1,'last');
    if sum(uniqposint==3)~=0 & sum(uniqposint(lastchoice:end)==3)==0
        retval=1;
    end
    if sum(uniqposint==1 | uniqposint==2)~=0
          choiceval=1;
    end
    if retval==1 & choiceval==1
%          plot(uniqposint,'.')
%     pause
    if sum(size(uniqposint(lastchoice+1)))==0;
        st=[st,0];
    else
    st=[st,uniqposint(lastchoice+1)-1];
    end
    end
    retval=0;
    choiceval=0;
end
st(st~=1 & st~=0)=[];
st(st==1)=2;
st(st==0)=1;
st(st==2)=0;


end