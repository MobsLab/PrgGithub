Detections2=[];
j=1;
for i=1:length(DETECTIONS2)
    if find(DETECTIONS2(i)==FIRE2(:))~=0
        disp('ahah')
    elseif find(DETECTIONS2(i)==FIRE2(:))==0
        Detections2(j)=DETECTIONS2(i);
        j=j+1;
    end
end
%--------------------------------------------------------------------------------------------------------------------------------------

res=pwd;
load DeltaTone
load([res,'/LFPData/InfoLFP']);
all_FIRE=[FIRE2;FIRE3;FIRE5];
all_actualFIRE=[FIREactual2;FIREactual3;FIREactual5];
all_DETECTIONS=[DETECTIONS2;DETECTIONS3;DETECTIONS5]; %DETECTIONS3=detections(:,1)+tpsdeb{1,3}*1E4;

%--------------------------------------------------------------------------------------------------------------------------------------


rawLFP_FIRES={};
rawLFP_actualFIRES={};
rawLFP_actualDETECTIONS={};

for num=1:length(InfoLFP.channel)-3;
    ch=InfoLFP.channel(num);
    clear LFP
    load([res,'/LFPData/LFP',num2str(ch)]);
    try
    LFP_fire=PlotRipRaw(LFP,all_FIRE/1E4,1000); close
    rawLFP_FIRES{ch+1}=LFP_fire;
    end
    try
    LFP_fire=PlotRipRaw(LFP,all_actualFIRE/1E4,1000); close
    rawLFP_actualFIRES{ch+1}=LFP_fire;
    end
    try
    LFP_fire=PlotRipRaw(LFP,all_DETECTIONS/1E4,1000); close
    rawLFP_DETECTIONS{ch+1}=LFP_fire;
    end
    disp(['channel # ',num2str(ch),' > done'])
end
save rawLFP_DETECTIONS rawLFP_DETECTIONS 
save rawLFP_Tone2 rawLFP_FIRES rawLFP_actualFIRES

%--------------------------------------------------------------------------------------------------------------------------------------

figure, subplot(2,1,1)
a=rawLFP_FIRES{PaCx_deep+1};
b=rawLFP_FIRES{PaCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{PaCx_deep+1};
b=rawLFP_actualFIRES{PaCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (fire corrected evt)')


figure, subplot(2,1,1)
a=rawLFP_FIRES{PFCx_deep+1};
b=rawLFP_FIRES{PFCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{PFCx_deep+1};
b=rawLFP_actualFIRES{PFCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_FIRES{MoCx_deep+1};
b=rawLFP_FIRES{MoCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{MoCx_deep+1};
b=rawLFP_actualFIRES{MoCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_FIRES{NRT_deep+1};
b=rawLFP_FIRES{NRT_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{NRT_deep+1};
b=rawLFP_actualFIRES{NRT_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_FIRES{dHPC_deep+1};
b=rawLFP_FIRES{dHPC_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{dHPC_deep+1};
b=rawLFP_actualFIRES{dHPC_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_FIRES{Bulb_deep+1};
b=rawLFP_FIRES{Bulb_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{Bulb_deep+1};
b=rawLFP_actualFIRES{Bulb_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (fire corrected evt)')

%----------------------------------------------------------------------------------------------------------------

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{PaCx_deep+1};
b=rawLFP_DETECTIONS{PaCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (detections evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{PaCx_deep+1};
b=rawLFP_actualFIRES{PaCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{PFCx_deep+1};
b=rawLFP_DETECTIONS{PFCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{PFCx_deep+1};
b=rawLFP_actualFIRES{PFCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{MoCx_deep+1};
b=rawLFP_DETECTIONS{MoCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (detections evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{MoCx_deep+1};
b=rawLFP_actualFIRES{MoCx_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{NRT_deep+1};
b=rawLFP_DETECTIONS{NRT_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (detections evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{NRT_deep+1};
b=rawLFP_actualFIRES{NRT_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{dHPC_deep+1};
b=rawLFP_DETECTIONS{dHPC_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (detections evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{dHPC_deep+1};
b=rawLFP_actualFIRES{dHPC_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC Deep vs Sup Layer (fire corrected evt)')

figure, subplot(2,1,1)
a=rawLFP_DETECTIONS{Bulb_deep+1};
b=rawLFP_FIRES{Bulb_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (detections evt)')
hold on, subplot(2,1,2)
a=rawLFP_actualFIRES{Bulb_deep+1};
b=rawLFP_actualFIRES{Bulb_sup+1};
hold on, plot(a(:,1),a(:,2),'k','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb Deep vs Sup Layer (fire corrected evt)')
