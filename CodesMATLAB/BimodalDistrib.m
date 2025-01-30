function [PBimod,PUnimod,amplUp,p,CHI]=BimodalDistrib(Y,Nkm,modNB,N,AntoncodeOK)

% Nkm=3;
% modNB=2;
modNB=min(modNB,Nkm);

try
    AntoncodeOK;
catch
    AntoncodeOK=1;
end

nBins=50;
%nBins=100;

try
    N;
    n=N(2);
    m=N(1);
catch
    m=min(Y);
    n=max(Y);
    le=n-m;
    m=m-le/3;
    n=n+le/3;
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


Bins=[m:(abs(n-m))/nBins:n];

[c,s]=kmeans(Y,Nkm);

[BD,id]=sort(c);

if modNB==2&Nkm==3
    s(s==id(3))=id(2);
    val=unique(s);
    s2=s;
    s2(val(1))=1;
    s2(val(2))=2;    
    s=s2;
end


[h,x]=hist(Y,Bins);
[hs2,x2]=hist(Y(s==2),Bins);
[hs1,x1]=hist(Y(s==1),Bins);
if modNB==3
    [hs3,x3]=hist(Y(s==3),Bins);
end

Clu1m=mean(Y(s==1));
Clu1s=std(Y(s==1));
Clu2m=mean(Y(s==2));
Clu2s=std(Y(s==2));
if modNB==3
Clu3m=mean(Y(s==3));
Clu3s=std(Y(s==3));
end

amplUp=abs(Clu1m-Clu2m);
if modNB==3
amplUp(2)=abs(Clu1m-Clu3m);
amplUp(3)=abs(Clu2m-Clu3m);
end

if 0
    
    y = normrnd(mean(Y),std(Y),length(Y),1);
    [hb,x]=hist(y,Bins);

    y1 = normrnd(mean(Y(s==1)),std(Y(s==1)),length(Y(s==1)),1);
    y2 = normrnd(mean(Y(s==2)),std(Y(s==2)),length(Y(s==2)),1);
    [h2,x2]=hist(y2,Bins);
    [h1,x1]=hist(y1,Bins);
    if modNB==3
    y3 = normrnd(mean(Y(s==3)),std(Y(s==3)),length(Y(s==3)),1);
    [h3,x3]=hist(y3,Bins);
    end
    
else
    y = normrnd(mean(Y),std(Y),10*length(Y),1);
    [hb,x]=hist(y,Bins);
    y1 = normrnd(mean(Y(s==1)),std(Y(s==1)),10*length(Y(s==1)),1);
    y2 = normrnd(mean(Y(s==2)),std(Y(s==2)),10*length(Y(s==2)),1);
    [h2,x2]=hist(y1,Bins);
    [h1,x1]=hist(y2,Bins);

        if modNB==3
        y3 = normrnd(mean(Y(s==3)),std(Y(s==3)),10*length(Y(s==3)),1);
        [h3,x3]=hist(y3,Bins);
        end

    hb=hb/10;
    h1=h1/10;
    h2=h2/10;
    if modNB==3
        h3=h3/10;
    end
    
end




%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

id=find(h>0);


chiU=sum((hb(id)-h(id)).^2./h(id).^2);
PUnimod=1-gammainc(chiU/2,(length(id)-3)/2);

if modNB==3
chiB=sum((h1(id)+h2(id)+h3(id)-h(id)).^2./h(id).^2);
PBimod=1-gammainc(chiB/2,(length(id)-3)/2);

else
chiB=sum((h1(id)+h2(id)-h(id)).^2./h(id).^2);
PBimod=1-gammainc(chiB/2,(length(id)-3)/2);
end


CHI=[chiU chiB];


p=[1,1];

if AntoncodeOK
[p,bin] = MultimodalTest(Y,Nkm);
end

disp(' ')
if PBimod>0.05&PUnimod<0.05
    texte3=' The distribution is bimodal';
    if ~AntoncodeOK
        p=[1 PUnimod];
    end
    modality=1;
elseif PUnimod>0.05&PBimod<0.05
        texte3=' The distribution is unimodal -- Pas de Up-states';
         if ~AntoncodeOK
             p=[PBimod 1]; 
         end
else 
    
   disp(['****** Try Anton''s code *******']) 
   disp(' ')
%     try
%         [p,bin] = MultimodalTest(Y(100:4000),2);
%     catch
        [p,bin] = MultimodalTest(Y,Nkm);
        
%     end
    
    if p(1)>0.05&p(2)<0.05   
    texte3=' The distribution is bimodal (test bimod)';
    elseif p(1)<0.05&p(2)<0.05
       texte3=' The distribution seems bimodal (test bimod) -- unimodal also significant';  
    else
       texte3=' The distribution is unimodal -- Pas de Up-states (test bimod)';
    end
    
end



disp(['****** ',texte3,' *******'])
disp(' ')

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

if 1

figure, hold on, 
bar(Bins,h,1,'k')
plot(Bins,hb,'b','linewidth',2)
plot(Bins,hs2,'g','linewidth',2)
plot(Bins,hs1,'y','linewidth',2)
if modNB==3
plot(Bins,h3,'m','linewidth',2)
plot(Bins,h1+h2+h3,'r','linewidth',2)
else
plot(Bins,h1+h2,'r','linewidth',2)
end

ylabel('Number of occurrence')
title(['n=',num2str(length(Y)),',  mean=', num2str(floor(nanmean(Y)*100)/100),',  Clu1=', num2str(floor(nanmean(Y(s==1))*100)/100),',  Clu2=', num2str(floor(nanmean(Y(s==2))*100)/100),',   p uni: ', num2str(floor(PUnimod*1000)/1000),',   p bi: ', num2str(floor(PBimod*1000)/1000)])


end

disp(['*****  p Unimod: ',num2str(PUnimod)])

if modNB==3
disp(['*****  p Trimod: ',num2str(PBimod)])
else
disp(['*****  p Bimod: ',num2str(PBimod)])
end
if modNB==3
disp(['*****  Anton''s code, p Unimod: ',num2str(p(1)),' , p Bimod: ',num2str(p(2)),' , p Trimod: ',num2str(p(3))])
else
disp(['*****  Anton''s code, p Unimod: ',num2str(p(1)),' , p Bimod: ',num2str(p(2))])
end
disp(' ')




