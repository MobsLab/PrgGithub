
res=pwd;
load([res,'/ChannelsToAnalyse/Bulb_deep']);
Bulb_deep=channel+decal;
load([res,'/ChannelsToAnalyse/Bulb_sup']);
Bulb_sup=channel+decal;

load([res,'/ChannelsToAnalyse/MoCx_deep']);
MoCx_deep=channel+decal;
load([res,'/ChannelsToAnalyse/MoCx_sup']);
MoCx_sup=channel+decal;

load([res,'/ChannelsToAnalyse/PaCx_deep']);
PaCx_deep=channel+decal;
load([res,'/ChannelsToAnalyse/PaCx_sup']);
PaCx_sup=channel+decal;

load([res,'/ChannelsToAnalyse/PFCx_deep']);
PFCx_deep=channel+decal;
load([res,'/ChannelsToAnalyse/PFCx_sup']);
PFCx_sup=channel+decal;

load([res,'/ChannelsToAnalyse/dHPC_deep']);
dHPC_deep=channel+decal;
load([res,'/ChannelsToAnalyse/dHPC_sup']);
dHPC_sup=channel+decal;
%dHPC_sup=46-31; %mouse 244 - 23022015

load([res,'/ChannelsToAnalyse/NRT_deep']);
NRT_deep=channel+decal;
load([res,'/ChannelsToAnalyse/NRT_sup']);
NRT_sup=channel+decal;

%---------------------------------------------------
%                   plot Intan Event Signal
%---------------------------------------------------
load([res,'/LFPData/LFP',num2str(0)]);
Tone=Data(LFP);
Time=Range(LFP);
figure, plot(Time,Tone)
hold on, plot(SingleTone,1,'go','markerfacecolor','r')


load([res,'/LFPData/InfoLFP']);

i=1;
for num=0:31;
    clear LFP
    load([res,'/LFPData/LFP',num2str(num)]);
    LFP_fires_actual=PlotRipRaw(LFP,fires_actual_time(:,1)/1E4,1000); close
    rawLFP_fires_actual{i}=LFP_fires_actual;
    LFP_fires=PlotRipRaw(LFP,fires(:,1)/1E4,1000); close
    rawLFP_fires{i}=LFP_fires;
    LFP_detections=PlotRipRaw(LFP,detections(:,1)/1E4,1000); close
    rawLFP_detections{i}=LFP_detections;
    i=i+1;
    disp(['channel # ',num2str(num),' > done'])
end


save rawLFP -append rawLFP_fires_actual rawLFP_Detections rawLFP_Fires


figure, subplot(2,1,1)
a=rawLFP_Tone{PaCx_deep};
b=rawLFP_Tone{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCX deep and sup layer ERPs (DIGout detection)')
a=rawLFP_Fires{PaCx_deep};
b=rawLFP_Fires{PaCx_sup};
hold on, subplot(2,1,2)
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCX deep and sup layer ERPs (fires matrices)')





figure, subplot(6,1,1)
a=rawLFP_Tone{Bulb_deep};
b=rawLFP_Tone{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_Tone{MoCx_deep};
b=rawLFP_Tone{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_Tone{PaCx_deep};
b=rawLFP_Tone{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_Tone{PFCx_deep};
b=rawLFP_Tone{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_Tone{dHPC_deep};
b=rawLFP_Tone{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_Tone{NRT_deep};
b=rawLFP_Tone{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('Tone EVent (DIGout)')


figure, subplot(6,1,1)
a=rawLFP_Fires{Bulb_deep};
b=rawLFP_Fires{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_Fires{MoCx_deep};
b=rawLFP_Fires{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_Fires{PaCx_deep};
b=rawLFP_Fires{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_Fires{PFCx_deep};
b=rawLFP_Fires{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_Fires{dHPC_deep};
b=rawLFP_Fires{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_Fires{NRT_deep};
b=rawLFP_Fires{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('fires matrices')





figure, subplot(6,1,1)
a=rawLFP_Detections{Bulb_deep};
b=rawLFP_Detections{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_Detections{MoCx_deep};
b=rawLFP_Detections{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_Detections{PaCx_deep};
b=rawLFP_Detections{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_Detections{PFCx_deep};
b=rawLFP_Detections{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_Detections{dHPC_deep};
b=rawLFP_Detections{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_Detections{NRT_deep};
b=rawLFP_Detections{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('detections matrices')




