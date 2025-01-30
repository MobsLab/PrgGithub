%BilanEffectCPMarie

stru='PFCx_deep';
stru='PFCx_sup';
stru='PaCx_deep';
 stru='PaCx_sup';


WT=[];

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end

% 
% load('ChannelsToAnalyse/PFCx_deep.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% 

% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
try
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse082/20130802/BULB-Mouse-82-02082013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP






KO=[];

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
%eval(['load SpiMarie',num2str(channel)])
try

eval(['load SpiMarie',num2str(channel)])
KO=[KO;mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(Spi(:,2)>st2(1),4))];
end

% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse052/20130122/BULB-Mouse-52-22012013
%    
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end


cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse054/20130314/BULB-Mouse-54-14032013
   clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse065/BULB-Mouse-65-05062013
   clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];


cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse066/BULB-Mouse-66-05062013
   
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];


PlotErrorBar6(WT(:,1),WT(:,2),WT(:,3),KO(:,1),KO(:,2),KO(:,3))
title(stru)



stru='PFCx_deep';
%stru='PFCx_sup';
%stru='PaCx_deep';
% stru='PaCx_sup';


WT=[];

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse051/20130110/BULB-Mouse-51-10012013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end

% 
% load('ChannelsToAnalyse/PFCx_deep.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% end
% try
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% 

% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse060/20130430/BULB-Mouse-60-30042013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse061/20130430/BULB-Mouse-61-30042013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
try
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse082/20130802/BULB-Mouse-82-02082013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse083/20130802/BULB-Mouse-83-02082013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
WT=[WT;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end
% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP






KO=[];

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse047/20130111/BULB-Mouse-47-11012013
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
%eval(['load SpiMarie',num2str(channel)])
try

eval(['load SpiMarie',num2str(channel)])
KO=[KO;mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(Spi(:,2)>st2(1),4))];
end

% clear
% load('ChannelsToAnalyse/PFCx_sup.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_deep.mat')
% EffetSpindlesCP
% clear
% load('ChannelsToAnalyse/PaCx_sup.mat')
% EffetSpindlesCP

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse052/20130122/BULB-Mouse-52-22012013
%    
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end


cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse054/20130314/BULB-Mouse-54-14032013
   clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
try
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];
end

cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse065/BULB-Mouse-65-05062013
   clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];


cd /media/DataMOBsRAID5/ProjetAstro/ProjetCannabinoids/Mouse066/BULB-Mouse-66-05062013
   
clear channel
eval(['load(''ChannelsToAnalyse/',stru,'.mat'')'])
% load('ChannelsToAnalyse/PFCx_deep.mat')
% load('ChannelsToAnalyse/PFCx_sup.mat')
% load('ChannelsToAnalyse/PaCx_deep.mat')
% load('ChannelsToAnalyse/PaCx_sup.mat')
eval(['load SpiMarie',num2str(channel)])
KO=[KO;[mean(Spi(Spi(:,2)<st1(1),4)),mean(Spi(find(Spi(:,2)>st1(1)&Spi(:,2)<st2(1)),4)),mean(Spi(Spi(:,2)>st2(1),4))]];


PlotErrorBar6(WT(:,1),WT(:,2),WT(:,3),KO(:,1),KO(:,2),KO(:,3))
title(stru)
[h,p]=ttest2(WT(:,3),KO(:,3))
 A{1}=WT(1:4,1);
 A{2}=WT(1:4,2);
A{3}=WT(1:4,3);
B{1}=KO(:,1);
B{2}=KO(:,2);
B{3}=KO(:,3);
[p,t,st,Pt,group]=CalculANOVAmultipleTwoway(A,B);

 
 A{1}=WT(2:5,1);
 A{2}=WT(2:5,2);
A{3}=WT(2:5,3);
B{1}=KO(:,1);
B{2}=KO(:,2);
B{3}=KO(:,3);
[p,t,st,Pt,group]=CalculANOVAmultipleTwoway(A,B);


