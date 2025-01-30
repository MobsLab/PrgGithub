
%figureEC50 

lim1=0.5;
lim2=1;


% ------------------------------------------
%--------- Mouse 17 ------------------------

%Gauche
NosePoke017=[22
26.7
20.7
14.4
6.5
3.0
1.1
1.1];

Voltage017=[10
8
6
4
2
0
-lim1
-lim2
];


SD017=[15.9
7.8
5.8
8.4
3.2
1.1];






%Droite
DNosePoke017=[1.5
0.6
0.0
0.2
0.2
0.3
0.3
0.3];
  
DSD017=[1.1
0.5
0.0
0.4
0.4
0.7];
    


% ------------------------------------------
%--------- Mouse 13 ------------------------

%Gauche
NosePoke013=[61.5
67.1
51.1
24.9
10.8
7.0
7.0
7.0];

Voltage013=[10
8
6
4
2
0
-lim1
-lim2
];


SD013=[33.4
18.5
5.1
3.3
5.7
3.2];

%Droite
DNosePoke013=[1.5
2.6
1.3
0.9
1.8
1.2
1.2
1.2];
  
DSD013=[1.1
2.4
1.1
1.1
2.2
2.5];

% ------------------------------------------
%--------- Mouse 07 ------------------------

% droite
NosePoke007=[47.2
40.2
36.7
14.0
7.4
7.4
7.4];

Voltage007=[8
6
4
2
0
-lim1
-lim2
];

SD007=[3.2
5.3
1.0
4.9
2.1];

%Gauche
DNosePoke007=[0.5
0.1
0.2
0.4
0.8
0.8
0.8];

DSD007=[0.6
0.2
0.4
0.3
1.4];


%------------------------------------------------------------------
%---------- PLOT --------------


[Perc,Vmax17,EC5017,T17,V17]=fitsigmoid(Voltage017(end:-1:1),NosePoke017(end:-1:1));
%figure('color',[1 1 1]), hold on,
%plot(Voltage017,NosePoke017,'ko','markerfacecolor','k')
%plot(T17,V17,'r','linewidth',2)




[Perc,Vmax13,EC5013,T13,V13]=fitsigmoid(Voltage013(end:-1:1),NosePoke013(end:-1:1));
%figure('color',[1 1 1]), hold on,
%plot(Voltage013,NosePoke013,'ko','markerfacecolor','k')
%plot(T13,V13,'r','linewidth',2)



[Perc,Vmax07,EC5007,T07,V07]=fitsigmoid(Voltage007(end:-1:1),NosePoke007(end:-1:1));
%figure('color',[1 1 1]), hold on,
%plot(Voltage007,NosePoke007,'ko','markerfacecolor','k')
%plot(T07,V07,'r','linewidth',2)




figure('color',[1 1 1]), hold on,
errorbar(Voltage017(1:end-2),NosePoke017(1:end-2),SD017,'k+')
errorbar(Voltage013(1:end-2),NosePoke013(1:end-2),SD013,'b+')
errorbar(Voltage007(1:end-2),NosePoke007(1:end-2),SD007,'r+')

% plot(Voltage017(2:end-1),NosePoke017(2:end-1),'ko','markerfacecolor','k')
plot(Voltage017(1:end-2),NosePoke017(1:end-2),'ko','markerfacecolor','k','MarkerSize',8)
plot(T17,V17,'k','linewidth',2)
plot(Voltage013(1:end-2),NosePoke013(1:end-2),'bo','markerfacecolor','b','MarkerSize',8)
plot(T13,V13,'b','linewidth',2)
plot(Voltage007(1:end-2),NosePoke007(1:end-2),'ro','markerfacecolor','r','MarkerSize',8)
plot(T07,V07,'r','linewidth',2)
xlim([-1 12])
xlabel('Stimulation voltage (V)')
ylabel('Percentage of time spent in NosePoke (%)')
legend('Mouse 17','Mouse 13','Mouse 07')


%-- inverse sigmoid --

figure('color',[1 1 1]), hold on,
% errorbar(Voltage017(1:end-2),NosePoke017(end-1:-1:2),SD017(end:-1:1),'k+'
% )
errorbar(Voltage017(1:end-2),NosePoke017(end-2:-1:1),SD017(end:-1:1),'k+')
errorbar(Voltage013(1:end-2),NosePoke013(end-2:-1:1),SD013(end:-1:1),'b+')
errorbar(Voltage007(1:end-2)+2,NosePoke007(end-2:-1:1),SD007(end:-1:1),'r+')

% plot(Voltage017(1:end-2),NosePoke017(end-1:-1:2),'ko','markerfacecolor','
% k')
plot(Voltage017(1:end-2),NosePoke017(end-2:-1:1),'ko','markerfacecolor','k','MarkerSize',8)
v17=V17(T17>0);
v17=v17(end:-1:1);
plot(T17(T17>0),v17,'k','linewidth',2)
plot(Voltage013(1:end-2),NosePoke013(end-2:-1:1),'bo','markerfacecolor','b','MarkerSize',8)
v13=V13(T13>0);
v13=v13(end:-1:1);
plot(T13(T13>0),v13,'b','linewidth',2)
plot(Voltage007(1:end-2)+2,NosePoke007(end-2:-1:1),'ro','markerfacecolor','r','MarkerSize',8)
v07=V07(T07>0);
v07=v07(end:-1:1);
plot(T07(T07>0)+2,v07,'r','linewidth',2)

% plot nose poke droit
errorbar(Voltage017(1:end-2),DNosePoke017(end-2:-1:1),DSD017(end:-1:1),'k+')
errorbar(Voltage013(1:end-2),DNosePoke013(end-2:-1:1),DSD013(end:-1:1),'b+')
errorbar(Voltage007(1:end-2)+2,DNosePoke007(end-2:-1:1),DSD007(end:-1:1),'r+')

plot(Voltage017(1:end-2),DNosePoke017(end-1:-1:2),'ko','markerfacecolor','k','MarkerSize',8)
plot(Voltage017(1:end-2),DNosePoke017(end-1:-1:2),'k--','linewidth',2)

plot(Voltage013(1:end-2),DNosePoke013(end-2:-1:1),'bo','markerfacecolor','b','MarkerSize',8)
plot(Voltage013(1:end-2),DNosePoke013(end-2:-1:1),'b--','linewidth',2)

plot(Voltage007(1:end-2)+2,DNosePoke007(end-2:-1:1),'ro','markerfacecolor','r','MarkerSize',8)
plot(Voltage007(1:end-2)+2,DNosePoke007(end-2:-1:1),'r--','linewidth',2)
%-
xlim([-1 12])
ylim([0 95])
xlabel('Stimulation voltage (V)')
ylabel('Percentage of time spent in NosePoke (%)')
legend('Mouse 17','Mouse 13','Mouse 07')

for i=0:10
vol{i+1}=2*i;
end

set(gca,'xtick',0:2:11)
set(gca,'xticklabel',vol)


Bil07=[floor(EC5007*10)/10 floor(Vmax07*10)/10];
Bil13=[floor(EC5013*10)/10 floor(Vmax13*10)/10];
Bil17=[floor(EC5017*10)/10 floor(Vmax17*10)/10];

[Bil07; Bil13; Bil17]
