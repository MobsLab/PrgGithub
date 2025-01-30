% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
res=pwd;
load([res,'/LFPData/InfoLFP']);
load rawLFP_Tone
load rawLFP_Delta
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
disp(' ')
decal=input('What gap between LFP channel and rawLFP_tone (decal=0 if only one mice recorded) ?     ');
disp(' ')
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
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
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>


% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
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
xlabel('Random Tone')
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(6,1,1)
a=rawLFP_dMoCx{Bulb_deep};
b=rawLFP_dMoCx{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_dMoCx{MoCx_deep};
b=rawLFP_dMoCx{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_dMoCx{PaCx_deep};
b=rawLFP_dMoCx{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_dMoCx{PFCx_deep};
b=rawLFP_dMoCx{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_dMoCx{dHPC_deep};
b=rawLFP_dMoCx{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_dMoCx{NRT_deep};
b=rawLFP_dMoCx{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('MoCx Delta')
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(6,1,1)
a=rawLFP_dPaCx{Bulb_deep};
b=rawLFP_dPaCx{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_dPaCx{MoCx_deep};
b=rawLFP_dPaCx{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_dPaCx{PaCx_deep};
b=rawLFP_dPaCx{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_dPaCx{PFCx_deep};
b=rawLFP_dPaCx{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_dPaCx{dHPC_deep};
b=rawLFP_dPaCx{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_dPaCx{NRT_deep};
b=rawLFP_dPaCx{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('PaCx Delta')
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
figure, subplot(6,1,1)
a=rawLFP_dPFCx{Bulb_deep};
b=rawLFP_dPFCx{Bulb_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('Bulb deep and sup layer ERPs')
hold on, subplot(6,1,2)
a=rawLFP_dPFCx{MoCx_deep};
b=rawLFP_dPFCx{MoCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('MoCx deep and sup layer ERPs')
hold on, subplot(6,1,3)
a=rawLFP_dPFCx{PaCx_deep};
b=rawLFP_dPFCx{PaCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PaCx deep and sup layer ERPs')
hold on, subplot(6,1,4)
a=rawLFP_dPFCx{PFCx_deep};
b=rawLFP_dPFCx{PFCx_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('PFCx deep and sup layer ERPs')
hold on, subplot(6,1,5)
a=rawLFP_dPFCx{dHPC_deep};
b=rawLFP_dPFCx{dHPC_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('dHPC deep and sup layer ERPs')
hold on, subplot(6,1,6)
a=rawLFP_dPFCx{NRT_deep};
b=rawLFP_dPFCx{NRT_sup};
hold on, plot(a(:,1),a(:,2),'b','linewidth',1)
hold on, plot(b(:,1),b(:,2),'r','linewidth',1)
hold on, title('NRT deep and sup layer ERPs')
xlabel('PFCx Delta')
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

mkdir('DeepSup_ERPs')
cd([res,'/DeepSup_ERPs'])
res2=pwd;
for i=1:4;
    saveFigure(i,(['DeepSup_ERPs',num2str(i)]),res2)
end
cd([res])
