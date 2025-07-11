function [M1t,tps1,M2t,tps2,id,Mhpc,Mpa,Mpf,MauC,Mauth,Mbulb,Mpir,Mamy,Mden,idmax,lagmax,lag,C]=ObsTimeGlobalActivity(tim,nam,freq,xl)

tic

try
    nam;
catch
    nam='hpc';
    freq=[100 200];
end

try
    freq;
catch
    freq=[100 200];
end

try
    xl;
catch
    xl=[-160 160];
end

Mhpc={};
Mpa={};
Mpf={};
MauC={};
Mauth={};
Mbulb={};
Mamy={};
Mpir={};
Mden={};

M1t=[];
M2t=[];
clear id

load('LFPData/InfoLFP')

a=1;
for i=0:31
    try
        clear LFP 
        load(['LFPData/LFP',num2str(i)])
        [m1,s1,tps1]=mETAverage(Range(tim,'ms'),Range(LFP,'ms'),Data(LFP),0.1,300);
        [m2,s2,tps2]=mETAverage(Range(tim,'ms'),Range(LFP,'ms'),Data(LFP),0.1,10000);        
        M1t=[M1t;m1'];
        M2t=[M2t;m2'];       
        id(a)=i;
        a=a+1;
    end
end

tps1=tps1*10;
tps2=tps2*10;

figure('color',[1 1 1]), 
subplot(3,2,1), plot(tps1,M1t,'k'),  xlim([-150 150])
subplot(3,2,2), plot(tps2,M2t,'k'),  xlim([-1500 1500]), ylim([-2E3 1.7E3])

a=1;
chHpc=InfoLFP.channel(strcmp(InfoLFP.structure,'dHPC'));
for num=chHpc
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''c''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''c''), title(InfoLFP.structure(find(id==',num2str(num),')))'])

eval(['Mhpc{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mhpc{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mhpc{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mhpc{a,4}=''',pwd,''';']);
a=a+1;
    end
end
% num=31;
% subplot(1,2,1), eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''c'',''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])
% subplot(1,2,2), eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''c'',''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])
% 

chPar=InfoLFP.channel(strcmp(InfoLFP.structure,'PaCx'));
a=1;
for num=chPar
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''color'',[0.6 0.3 0.3]), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''color'',[0.6 0.3 0.3]), title(InfoLFP.structure(find(id==',num2str(num),')))'])

eval(['Mpa{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mpa{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mpa{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mpa{a,4}=''',pwd,''';']);
a=a+1;
    end
end
% num=27;
% subplot(1,2,1), eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''color'',[0.6 0.3 0.3],''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])
% subplot(1,2,2), eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''color'',[0.6 0.3 0.3],''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])

chAud=InfoLFP.channel(strcmp(InfoLFP.structure,'AuCx'));
a=1;
for num=chAud
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''g''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''g''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['MauC{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['MauC{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['MauC{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['MauC{a,4}=''',pwd,''';']);
a=a+1;
    end
end


chPFC=InfoLFP.channel(strcmp(InfoLFP.structure,'PFCx'));
a=1;
for num=chPFC
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''r''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''r''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mpf{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mpf{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mpf{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mpf{a,4}=''',pwd,''';']);
a=a+1;
    end
end
% num=23;
% subplot(1,2,1), eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''r'',''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])
% subplot(1,2,2), eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''r'',''linewidth'',2), title(InfoLFP.structure(find(id==',num2str(num),')))'])
% 

chAuTh=InfoLFP.channel(strcmp(InfoLFP.structure,'AuTh'));
a=1;
for num=chAuTh
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''m''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''m''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mauth{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mauth{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mauth{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mauth{a,4}=''',pwd,''';']);
a=a+1;
    end
end

chPir=InfoLFP.channel(strcmp(InfoLFP.structure,'PiCx'));
a=1;
for num=chPir
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''color'',[0 0.5 0]), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''color'',[0 0.5 0]), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mpir{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mpir{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mpir{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mpir{a,4}=''',pwd,''';']);
a=a+1;
    end
end


chBulb=InfoLFP.channel(strcmp(InfoLFP.structure,'Bulb'));
a=1;
for num=chBulb
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''b''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''b''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mbulb{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mbulb{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mbulb{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mbulb{a,4}=''',pwd,''';']);
a=a+1;
    end
end


chAmy=InfoLFP.channel(strcmp(InfoLFP.structure,'Amyg'));
a=1;
for num=chAmy
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''y''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''y''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mamy{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mamy{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mamy{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mamy{a,4}=''',pwd,''';']);
a=a+1;
    end
end

chDen=InfoLFP.channel(strcmp(InfoLFP.structure,'DenG'));
a=1;
for num=chDen
    try
subplot(3,2,1), hold on
eval(['hold on, plot(tps1,M1t(find(id==',num2str(num),'),:),''c''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
subplot(3,2,2), hold on
eval(['hold on, plot(tps2,M2t(find(id==',num2str(num),'),:),''c''), title(InfoLFP.structure(find(id==',num2str(num),')))'])
eval(['Mden{a,1}=M2t(find(id==',num2str(num),'),:);'])
eval(['Mden{a,2}=InfoLFP.depth(InfoLFP.channel==',num2str(num),');']);
eval(['Mden{a,3}=InfoLFP.channel==',num2str(num),';']);
eval(['Mden{a,4}=''',pwd,''';']);
a=a+1;
    end
end


subplot(3,2,1),title(num2str(length(Range(tim))))
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7],'linestyle','--')
subplot(3,2,2),title(' ')
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7],'linestyle','--')

switch nam
    case 'hpc'
        Mtest=Mhpc;
    case 'bul'
        Mtest=Mbulb;
    case 'pfc'
        Mtest=Mpf;
    case 'par'
        Mtest=Mpa;
    case 'pir'
        Mtest=Mpir;        
end


% figure('color',[1 1 1]), 
subplot(3,2,3), hold on
try
  plot(tps2,Mtest{1,1},'k')
end
try
  plot(tps2,Mtest{2,1},'b')
end
try
plot(tps2,Mtest{3,1},'r')
end
try
plot(tps2,Mtest{4,1},'m')
end
try
plot(tps2,Mtest{5,1},'g')
end
try
xlim(xl)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7],'linestyle','--')
end


subplot(3,2,4), hold on
try
Fil1=FilterLFP(tsd(tps2*10,Mtest{1,1}'),freq);
end
try
Fil2=FilterLFP(tsd(tps2*10,Mtest{2,1}'),freq);
end
try
Fil3=FilterLFP(tsd(tps2*10,Mtest{3,1}'),freq);
end
try
Fil4=FilterLFP(tsd(tps2*10,Mtest{4,1}'),freq);
end
try
Fil5=FilterLFP(tsd(tps2*10,Mtest{5,1}'),freq);
end
try
hold on, plot(tps2,Data(Fil1),'k')
end
try
  hold on, plot(tps2,Data(Fil2),'b')
end
try
  hold on, plot(tps2,Data(Fil3),'r')
end
try
  hold on, plot(tps2,Data(Fil4),'m')
end  
try
  hold on, plot(tps2,Data(Fil5),'g')
end  
try
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7],'linestyle','--')
end
xlim(xl)

try
for i=1:size(Mbulb,1)
    si=Mbulb{i,1};
    idx=find(tps2>-2000&tps2<-200);
    t2=tps2(idx);
    t2b=t2-t2(1);
    si2=si(idx);
    fil=FilterLFP(tsd(t2*10,si2'),[1 4],1024);
    t3=tps2;
    t3b=t3-t2(1);
    [Xf,Yf,Yf2,param]=sine_fit(t2b,Data(fil),t3b);


    idx4=find(t3<2000&t3>300);
    t4=t3(idx4);
    si4=Yf2(idx4);
    idx5=find(tps2<2000&tps2>300);
    si5=si(idx5);
    [C{i},lag]=xcorr(si4,si5,'coeff');
    [MaxC(i),idm(i)]=max(C{i});
    [MaxC2(i),idm2(i)]=max(abs(C{i}));
end

[BE,idmax]=max(MaxC);
lagmax(1)=lag(idm(idmax));
lagmax(2)=lag(idm2(idmax));

si=Mbulb{idmax,1};
idx=find(tps2>-2000&tps2<-200);
t2=tps2(idx);
t2b=t2-t2(1);
si2=si(idx);
fil=FilterLFP(tsd(t2*10,si2'),[1 4],1024);
t3=tps2;
t3b=t3-t2(1);
[Xf,Yf,Yf2,param]=sine_fit(t2b,Data(fil),t3b);

% figure('color',[1 1 1]), 
% subplot(1,2,1), 
subplot(3,2,5), hold on
plot(tps2,si)
hold on, plot(t2,Data(fil),'m','linewidth',2)
hold on, plot(t3,Yf2,'r','linewidth',3)
hold on, plot(Xf+t2(1),Yf,'k','linewidth',3)
xlim([-2000 2000])
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7],'linestyle','--')
subplot(3,2,6), hold on
plot(lag,C{idmax},'k','linewidth',2)
yl=ylim;
xlim([-2000 2000])
line([0 0],yl,'color','r')
title(['Max: ',num2str(lagmax(1)),', Max(abs): ',num2str(lagmax(2))])
end

toc