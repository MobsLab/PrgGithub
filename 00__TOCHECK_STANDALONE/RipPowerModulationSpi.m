function [M1RipPre,M2RipPre,M3RipPre,M1RipPost,M2RipPost,M3RipPost,M1SpiPre,M2SpiPre,M3SpiPre,M1SpiPost,M2SpiPost,M3SpiPost,M1PowPre,M2PowPre,M3PowPre,M1PowPost,M2PowPost,M3PowPost]=RipPowerModulationSpi(Struct,LowHigh,fac)

%cd \\NASDELUXE\DataMOBs\ProjetLPS\Mouse055\20130403\BULB-Mouse-55-03042013

try 
    fac;
catch
    fac=1;
end

try
    LowHigh;
catch
    LowHigh='H';
end

try
Struct;
catch
Struct='Pfc';
end


    load behavResources PreEpoch VEHEpoch LPSEpoch H24Epoch H48Epoch CPEpoch DPCPXEpoch 



try
    try
        Epoch2=LPSEpoch;

    end

    try
        Epoch2=CPEpoch;
        PreEpoch=or(VEHEpoch,PreEpoch);
    end

    try
        Epoch2=DPCPXEpoch;
        PreEpoch=VEHEpoch;
    end


    try
        Epoch2=H24Epoch;
        PreEpoch=H24Epoch;
    end

    try
        Epoch2=H48Epoch;
        PreEpoch=H48Epoch;
    end

    Epoch2;

catch
    
    try
        Epoch2=VEHEpoch;
    end
end

    load StateEpoch NoiseEpoch WeirdNoiseEpoch GndNoiseEpoch 
try
    PreEpoch=PreEpoch-NoiseEpoch;
end
try
    PreEpoch=PreEpoch-GndNoiseEpoch;
end
try
    PreEpoch=PreEpoch-WeirdNoiseEpoch;
end
try
Epoch2=Epoch2-NoiseEpoch;
end
try
    Epoch2=Epoch2-GndNoiseEpoch;
end
try
    Epoch2=Epoch2-WeirdNoiseEpoch;
end


load SpindlesRipples Rip
load Spindles SpiH SpiL


if Struct=='Pfc'
num=2;
elseif Struct=='Par'
num=3;
elseif Struct=='Aud'
num=4;
end

if LowHigh=='H'
    for i=1:3
    GoodSpiH{i}=SpiH{num,i};
    end
else
    for i=1:3
    GoodSpiH{i}=SpiL{num,i};
    end
end
GoodRip=Rip;

try
load LFPdHPC
catch
    load SpindlesRipples LFPh
end

try
for i=1:length(LFP)
LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
end
LFPRip=LFP{1};
catch
  LFPRip=LFPh{1};
  LFP=LFPh;
  
end

    
riptsd=tsd(Rip(:,2)*1E4,Rip);
riptsdtemp=Restrict(riptsd,PreEpoch);
GoodRipPre=Data(riptsdtemp);
riptsdtemp=Restrict(riptsd,Epoch2);
GoodRipPost=Data(riptsdtemp);                  
                    
M1RipPre=PlotRipRaw(LFP{1},GoodRipPre(:,2),80);close
M2RipPre=PlotRipRaw(LFP{2},GoodRipPre(:,2),80);close
if length(LFP)>2
    M3RipPre=PlotRipRaw(LFP{3},GoodRipPre(:,2),80);close
else
    M3RipPre=[];
end

M1RipPost=PlotRipRaw(LFP{1},GoodRipPost(:,2),80);close
M2RipPost=PlotRipRaw(LFP{2},GoodRipPost(:,2),80);close
if length(LFP)>2
    M3RipPost=PlotRipRaw(LFP{3},GoodRipPost(:,2),80);close
else
    M3RipPost=[];
end
figure('color',[1 1 1]),
subplot(2,1,1),
try
plot(M1RipPre(:,1),M1RipPre(:,2),'b','linewidth',2)
hold on, plot(M2RipPre(:,1),M2RipPre(:,2),'k','linewidth',2)
if length(LFP)>2
    hold on, plot(M3RipPre(:,1),M3RipPre(:,2),'r','linewidth',2)
end
end
subplot(2,1,2),
plot(M1RipPost(:,1),M1RipPost(:,2),'b','linewidth',2)
hold on, plot(M2RipPost(:,1),M2RipPost(:,2),'k','linewidth',2)
if length(LFP)>2
hold on, plot(M3RipPost(:,1),M3RipPost(:,2),'r','linewidth',2)
end
title(pwd)



if Struct=='Pfc'
    try
        load('ChannelsToAnalyse/PFCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    try
    load('ChannelsToAnalyse/PFCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    end
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end
    catch
        load LFPFCx
    end
    
elseif Struct=='Par'
    try
    load('ChannelsToAnalyse/PaCx_deep')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{1}=LFP;
    load('ChannelsToAnalyse/PaCx_sup')
    eval(['load(''LFPData/LFP',num2str(channel),''')'])
    LFPtemp{2}=LFP;
    LFP=LFPtemp;
    try
        LFP=tsdArray(LFP);
    end   
    catch
        
    load LFPPaCx
    end
    
elseif Struct=='Aud'
        load LFPAuCx
end

for i=1:length(LFP)
LFP{i}=tsd(Range(LFP{i}),Data(LFP{i})*fac);
end
try
LFPSpi=LFP{2};
catch
    LFPSpi=LFP{1};
end

for i=1:3
    try
spitsdH{i}=tsd(GoodSpiH{i}(:,2)*1E4,GoodSpiH{i});
    catch
        try
spitsdH{i}=tsd(GoodSpiH{i-1}(:,2)*1E4,GoodSpiH{i-1});
        catch
spitsdH{i}=tsd(1,1);
        end
    end
    
end
try
spitsdH=tsdArray(spitsdH);
end

spitsdtemp=Restrict(spitsdH,PreEpoch);
for i=1:3
    GoodSpiPreH{i}=Data(spitsdtemp{i});
end
spitsdtemp=Restrict(spitsdH,Epoch2);
for i=1:3
    GoodSpiPostH{i}=Data(spitsdtemp{i});
end


ylF=[0 0];
figure('color',[1 1 1]), 
for i=1:3
try
    M1SpiPre{i}=PlotRipRaw(LFP{1},GoodSpiPreH{i},500);close
    catch
    M1SpiPre{i}=[];
end
try
M2SpiPre{i}=PlotRipRaw(LFP{2},GoodSpiPreH{i},500);close
catch
    M2SpiPre{i}=[];
end
try
M3SpiPre{i}=PlotRipRaw(LFP{3},GoodSpiPreH{i},500);close
catch
    M3SpiPre{i}=[];
end
subplot(2,3,i),
try
plot(M1SpiPre{i}(:,1),M1SpiPre{i}(:,2),'b','linewidth',2)
end
try
hold on, plot(M2SpiPre{i}(:,1),M2SpiPre{i}(:,2),'k','linewidth',2)
end
try
hold on, plot(M3SpiPre{i}(:,1),M3SpiPre{i}(:,2),'r','linewidth',2)
end
yl=ylim;
ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
end
subplot(2,3,1),ylim(ylF)
subplot(2,3,2),ylim(ylF),title(pwd)
subplot(2,3,3),ylim(ylF)


for i=1:3
try
    M1SpiPost{i}=PlotRipRaw(LFP{1},GoodSpiPostH{i},500);close
catch
    M1SpiPost{i}= [];
end
try
M2SpiPost{i}=PlotRipRaw(LFP{2},GoodSpiPostH{i},500);close
catch
  M2SpiPost{i}= []; 
end
try
M3SpiPost{i}=PlotRipRaw(LFP{3},GoodSpiPostH{i},500);close
catch
    M3SpiPost{i}=[];
end
    subplot(2,3,i+3),
    try
        plot(M1SpiPost{i}(:,1),M1SpiPost{i}(:,2),'b','linewidth',2)
    end
    try
hold on, plot(M2SpiPost{i}(:,1),M2SpiPost{i}(:,2),'k','linewidth',2)
        end
    
try
hold on, plot(M3SpiPost{i}(:,1),M3SpiPost{i}(:,2),'r','linewidth',2)
end
yl=ylim;
ylF=[min(ylF(1),yl(1)) max(ylF(2),yl(2))];
end
subplot(2,3,4),ylim(ylF)
subplot(2,3,5),ylim(ylF)
subplot(2,3,6),ylim(ylF)



Filrip=FilterLFP(LFPRip,[120 350],128);
PowerRip=tsd(Range(Filrip), abs(hilbert(Data(Filrip))));
% 
% M1b=PlotRipRaw(PowerRip,SpiH{2,1},500);close
% M2b=PlotRipRaw(PowerRip,SpiH{2,2},500);close
% M3b=PlotRipRaw(PowerRip,SpiH{2,3},500);close
% figure('color',[1 1 1]),
% plot(M1b(:,1),M1b(:,2),'b','linewidth',2)
% hold on, plot(M2b(:,1),M2b(:,2),'k','linewidth',2)
% % hold on, plot(M3b(:,1),M3b(:,2),'r','linewidth',2)
% 
try
 M1PowPre=PlotRipRaw(PowerRip,GoodSpiPreH{1},500);close
catch
    M1PowPre=[];
end
try
 M2PowPre=PlotRipRaw(PowerRip,GoodSpiPreH{2},500);close
catch
    M2PowPre=[];
end

try
 M3PowPre=PlotRipRaw(PowerRip,GoodSpiPreH{3},500);close
catch
    M3PowPre=[];
end
% figure('color',[1 1 1]),
% plot(M1bef(:,1),M1bef(:,2),'b','linewidth',2)
% hold on, plot(M2bef(:,1),M2bef(:,2),'k','linewidth',2)
% title('Before drug')
% 
try
 M1PowPost=PlotRipRaw(PowerRip,GoodSpiPostH{1},500);close
catch
    M1PowPost=[];
end

try
    M2PowPost=PlotRipRaw(PowerRip,GoodSpiPostH{2},500);close
catch
    M2PowPost=[];
end
try
 M3PowPost=PlotRipRaw(PowerRip,GoodSpiPostH{3},500);close
 catch
     M3PowPost=[];
 end
 % figure('color',[1 1 1]),
% plot(M1aft(:,1),M1aft(:,2),'b','linewidth',2)
% hold on, plot(M2aft(:,1),M2aft(:,2),'k','linewidth',2)
% title('After drug')

% figure('color',[1 1 1]), hold on
% plot(M1bef(:,1),M1bef(:,2),'k','linewidth',2)
% plot(M1aft(:,1),M1aft(:,2),'r','linewidth',2)
% ylim([100 170])
% title('Before vs. after drug')


figure('color',[1 1 1]), 
subplot(3,1,1),hold on
try
    plot(M1PowPre(:,1),SmoothDec(M1PowPre(:,2),2),'k','linewidth',2)
end
try
plot(M1PowPost(:,1),SmoothDec(M1PowPost(:,2),2),'r','linewidth',2)
end
%ylim([100 170])
title('ch1, Before vs. after drug')
subplot(3,1,2),hold on
try
    plot(M2PowPre(:,1),SmoothDec(M2PowPre(:,2),2),'k','linewidth',2)
end
try
plot(M2PowPost(:,1),SmoothDec(M2PowPost(:,2),2),'r','linewidth',2)
end
%ylim([100 170])
title('ch2, Before vs. after drug')
subplot(3,1,3),hold on
try
    plot(M3PowPre(:,1),SmoothDec(M3PowPre(:,2),2),'k','linewidth',2)
end
try
    plot(M3PowPost(:,1),SmoothDec(M3PowPost(:,2),2),'r','linewidth',2)
end
%ylim([100 170])
title('ch3, Before vs. after drug')


% M1b=PlotRipRaw(PowerRip,SpiL{2,1},800);close
% M2b=PlotRipRaw(PowerRip,SpiL{2,2},800);close
% M3b=PlotRipRaw(PowerRip,SpiL{2,3},800);close
% figure('color',[1 1 1]),
% plot(M1b(:,1),M1b(:,2),'b','linewidth',2)
% hold on, plot(M2b(:,1),M2b(:,2),'k','linewidth',2)
% hold on, plot(M3b(:,1),M3b(:,2),'r','linewidth',2)

if 0
save GoodRipSpi GoodRip GoodSpiH
end
