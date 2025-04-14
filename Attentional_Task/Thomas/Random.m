tps=[0:0.001:850];
NPTimeIn=A(A(:,2)==3,1);%Entrée
NPTimeOut=A(A(:,2)==5,1);%Sortie
Sound=A(A(:,2)==1,1);%Sortie
Soundrandom=Sound+rand(length(Sound),1)*32-16;Sounrandom=sort(Soundrandom);
Stim=A(A(:,2)==2,1);%Stims
NPEpoch=intervalSet(NPTimeIn*1e4,NPTimeOut*1e4);
NP=zeros(1,length(tps));
for k=1:length(Start(NPEpoch))
    tempEp=subset(NPEpoch,k);
    beg=find(tps==Start(tempEp,'s'));
    stp=find(tps==Stop(tempEp,'s'));
    NP(beg:stp)=1;
end
NPtsd=tsd(tps*1e4,NP');
[M,T]=PlotRipRaw(NPtsd,Soundrandom,10000);close all
%figure
%plot(M(:,1),M(:,2))
%line([0 0],ylim,'color','k','linewidth',3)

X=[];
for (i=1:100)
    Soundrandom=Sound+rand(length(Sound),1)*32-16;Sounrandom=sort(Soundrandom);
    [M,T]=PlotRipRaw(NPtsd,Soundrandom,10000);close all
    %X=[X,M(:,2)];
    X=[X,M(:,2)];
end
[M,T]=PlotRipRaw(NPtsd,Sound,10000);close all
figure
%plot(M(:,1),X','k')
plot(M(:,1),X','k')
hold on
plot(M(:,1),M(:,2),'r','linewidth',1)
line([0 0],ylim,'color','r','linewidth',3)

