res=pwd;
load([res,'/LFPData/InfoLFP']);


%-------------------------------------------------------------------------------------------------------------------------------------

figure,
for i=1:32
    hold on, subplot(3,1,1)
    a=rawLFP_TONEtime1{i};
    hold on, plot(a(:,1),(i*100)+a(:,2),'k','linewidth',1)
    hold on, subplot(3,1,2)
    a=rawLFP_TONEtime2{i};
    hold on, plot(a(:,1),(i*100)+a(:,2),'k','linewidth',1)
    hold on, subplot(3,1,3)
    a=rawLFP_DeltaDetect{i};
    hold on, plot(a(:,1),(i*100)+a(:,2),'k','linewidth',1)
end

%--------------------------------------------------------------------------------------------------------------------------------------
load([res,'/ChannelsToAnalyse/Bulb_deep']);
Bulb_deep=channel;
load([res,'/ChannelsToAnalyse/Bulb_sup']);
Bulb_sup=channel;

load([res,'/ChannelsToAnalyse/MoCx_deep']);
MoCx_deep=channel;
load([res,'/ChannelsToAnalyse/MoCx_sup']);
MoCx_sup=channel;

load([res,'/ChannelsToAnalyse/PaCx_deep']);
PaCx_deep=channel;
load([res,'/ChannelsToAnalyse/PaCx_sup']);
PaCx_sup=channel;

load([res,'/ChannelsToAnalyse/PFCx_deep']);
PFCx_deep=channel;
load([res,'/ChannelsToAnalyse/PFCx_sup']);
PFCx_sup=channel;

load([res,'/ChannelsToAnalyse/dHPC_deep']);
dHPC_deep=channel;
load([res,'/ChannelsToAnalyse/dHPC_sup']);
dHPC_sup=channel;

load([res,'/ChannelsToAnalyse/NRT_deep']);
NRT_deep=channel;
load([res,'/ChannelsToAnalyse/NRT_sup']);
NRT_sup=channel;
%--------------------------------------------

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{PaCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{PaCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{PaCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{PaCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{PaCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{PaCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (detection only evt)')

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{PFCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{PFCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{PFCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{PFCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{PFCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{PFCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (detection only evt)')

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{MoCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{MoCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{MoCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{MoCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{MoCx_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{MoCx_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (detection only evt)')

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{NRT_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{NRT_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{NRT_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{NRT_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{NRT_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{NRT_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (detection only evt)')

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{dHPC_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{dHPC_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{dHPC_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{dHPC_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{dHPC_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{dHPC_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (detection only evt)')

figure, subplot(3,1,1)
a=rawLFP_TONEtime1{Bulb_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime1{Bulb_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (fire evt)')
hold on, subplot(3,1,2)
a=rawLFP_TONEtime2{Bulb_deep+1-InfoLFP.channel(1)};
b=rawLFP_TONEtime2{Bulb_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (fire corrected evt)')
hold on, subplot(3,1,3)
a=rawLFP_DeltaDetect{Bulb_deep+1-InfoLFP.channel(1)};
b=rawLFP_DeltaDetect{Bulb_sup+1-InfoLFP.channel(1)};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (detection only evt)')