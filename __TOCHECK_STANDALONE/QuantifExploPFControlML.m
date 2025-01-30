function [PercIn,PercOut,PercInb,PercOutb,m1,m2,m1b,m2b,SiPF,SiPFb,SiGlob,A]=QuantifExploPFControlML(PF,PFb,X,Y,smo)


try
    smo;
catch
    smo=2;
end

try
    logy;
catch
    logy=0;
end

dee=0;

load('MyColormaps','mycmap')

%load ParametersAnalyseICSS limMaz X Y

% try
    
    load xyMax
    yMaz;
%     if min(Data(X))<15&min(Data(Y))<15
        [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(X),Data(Y),50,smo,logy,[0 abs(yMaz(1)-yMaz(2)) 0 abs(xMaz(1)-xMaz(2))],0,1);
        %[x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(X),Data(Y),51,smo,logy,[],0); % add by Marie on 18/02/2014
%     else
%         disp('pb intermediate')
%         [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(X),Data(Y),51,smo,logy,[xMaz yMaz]);
%     end


% catch
%     disp(['pb ',pwd])
%     [x,y,A,x1,x2,Sig]=PlotTrajOcc(Data(X),Data(Y),51,smo,logy);
% end


set(gcf,'Colormap',mycmap)

res=pwd;
le=length(res);
title([res(le-16:le)])

clear idxY
clear idxN
a=1;b=1;
for i=1:length(x)
    if PF(round(y(i))+dee,round(x(i))+dee)==1
        idxY(a)=i;
        a=a+1;
    else
        idxN(b)=i;
        b=b+1;
    end
end

try
    figure('color',[1 1 1]),
    %figure(3),clf
    subplot(2,2,1), imagesc(PF), axis xy, title([res(le-16:le),', control'])
    hold on, plot(round(x)+dee,round(y)+dee,'w.')
    hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
    subplot(2,2,2),PlotErrorBar2(length(idxY)/(length(idxY)+length(idxN))*100,length(idxN)/(length(idxY)+length(idxN))*100,0)
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'In' 'Out'})
end


clear idxY
clear idxN
a=1;b=1;
for i=1:length(x)
    if PFb(round(y(i))+dee,round(x(i))+dee)==1
        idxY(a)=i;
        a=a+1;
    else
        idxN(b)=i;
        b=b+1;
    end
end

try
    subplot(2,2,3), imagesc(PFb), axis xy
    hold on, plot(round(x)+dee,round(y)+dee,'w.')
    hold on, plot(round(x(idxY))+dee,round(y(idxY))+dee,'k.')%,'markerfacecolor','k')
    subplot(2,2,4),PlotErrorBar2(length(idxY)/(length(idxY)+length(idxN))*100,length(idxN)/(length(idxY)+length(idxN))*100,0)
    set(gca,'xtick',[1 2])
    set(gca,'xticklabel',{'In' 'Out'})
end

try
    PercInb=length(idxY)/length(x)*100;
catch
    PercInb=0;
end

try
    PercOutb=length(idxN)/length(x)*100;
catch
    PercOutb=0;
end



clear idxY
clear idxN
a=1;b=1;
for i=1:length(x)
    if PF(round(y(i))+dee,round(x(i))+dee)==1
        idxY(a)=i;
        a=a+1;
    else
        idxN(b)=i;
        b=b+1;
    end
end

try
    PercIn=length(idxY)/length(x)*100;
catch
    PercIn=0;
end

try
    PercOut=length(idxN)/length(x)*100;
catch
    PercOut=0;
end


m1=A;
m1(PF==0)=0;
m2=A;
m2(PF==1)=0;
m1=nanmean(m1(:)); %*62*62/length(find(PF==0));
m2=nanmean(m2(:));%*62*62/length(find(PF==1));

m1b=A;
m1b(PFb==0)=0;
m2b=A;
m2b(PFb==1)=0;
m1b=nanmean(m1b(:));%*62*62/length(find(PF==0));
m2b=nanmean(m2b(:));%*62*62/length(find(PF==1));

SiPF=length(find(PF==1));
SiPFb=length(find(PFb==1));

SiGlob=length(find(A>0));

% disp(' ')
% disp(' ********* ')
% disp(' ')
% disp(['Out: ',num2str(m1), ', In: ',num2str(m2),'; Out (large):', num2str(m1b), ', In (Large):',num2str(m2b)])
% disp(' ')



