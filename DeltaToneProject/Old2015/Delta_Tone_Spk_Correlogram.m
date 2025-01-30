
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Generate auto correlogram of Delta Waves           -------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
load SpikeData
load ToneEvent

disp(' ')
toto=input('Single or Seq Tone ?   ');
disp(' ')

if strcmp('Single', toto)
    Tone=SingleTone;
elseif strcmp('Seq', toto)
    Tone=SeqTone;
end

% -------------------------------------------------------------------------
for i=1:length(S)
    [C_Tone,B_Tone]=CrossCorr(Tone,Range(S{i}),20,1000); %C_Tone(B_Tone==0)=0;
    C_Spk_Tone{i}=C_Tone;
    B_Spk_Tone{i}=B_Tone;
end
% -------------------------------------------------------------------------
% tone compared to delta :
% -------------------------------------------------------------------------
load DeltaMoCx 
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorr(Range(tDeltaT2),Tone,20,1000); %C_MoCx(B_MoCx==0)=0;
    C_SingleTone_Delta_MoCx{i}=C_MoCx;
    B_SingleTone_Delta_MoCx{i}=B_MoCx;
end

load DeltaPaCx 
for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorr(Range(tDeltaT2),Tone,20,1000); %C_PaCx(B_PaCx==0)=0;
    C_SingleTone_Delta_PaCx{i}=C_PaCx;
    B_SingleTone_Delta_PaCx{i}=B_PaCx;
end

load DeltaPFCx 
for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorr(Range(tDeltaT2),Tone,20,1000); %C_PFCx(B_PFCx==0)=0;
    C_SingleTone_Delta_PFCx{i}=C_PFCx;
    B_SingleTone_Delta_PFCx{i}=B_PFCx;
end

% -------------------------------------------------------------------------
% spikes compared to delta :
% -------------------------------------------------------------------------
load DeltaMoCx 
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorr(Range(tDeltaT2),Range(S{i}),20,1000); %C_MoCx(B_MoCx==0)=0;
    C_Spk_Delta_MoCx{i}=C_MoCx;
    B_Spk_Delta_MoCx{i}=B_MoCx;
end

load DeltaPaCx 
for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorr(Range(tDeltaT2),Range(S{i}),20,1000); %C_PaCx(B_PaCx==0)=0;
    C_Spk_Delta_PaCx{i}=C_PaCx;
    B_Spk_Delta_PaCx{i}=B_PaCx;
end

load DeltaPFCx 
for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorr(Range(tDeltaT2),Range(S{i}),20,1000); %C_PFCx(B_PFCx==0)=0;
    C_Spk_Delta_PFCx{i}=C_PFCx;
    B_Spk_Delta_PFCx{i}=B_PFCx;
end
% -------------------------------------------------------------------------
% spikes compared to Spindles :
% -------------------------------------------------------------------------
try
load SpindlesMoCxSup 
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_MoCx(B_MoCx==0)=0;
    C_Spk_SpiHighSup_MoCx{i}=C_MoCx;
    B_Spk_SpiHighSup_MoCx{i}=B_MoCx;
end
end

load SpindlesPaCxSup 
for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_PaCx(B_PaCx==0)=0;
    C_Spk_SpiHighSup_PaCx{i}=C_PaCx;
    B_Spk_SpiHighSup_PaCx{i}=B_PaCx;
end

load SpindlesPFCxSup 
for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_PFCx(B_PFCx==0)=0;
    C_Spk_SpiHighSup_PFCx{i}=C_PFCx;
    B_Spk_SpiHighSup_PFCx{i}=B_PFCx;
end
% -------------------------------------------------------------------------
% spikes compared to Spindles :
% -------------------------------------------------------------------------
try
    load SpindlesMoCxDeep
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_MoCx(B_MoCx==0)=0;
    C_Spk_SpiHighDeep_MoCx{i}=C_MoCx;
    B_Spk_SpiHighDeep_MoCx{i}=B_MoCx;
end
end

load SpindlesPaCxDeep
for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_PaCx(B_PaCx==0)=0;
    C_Spk_SpiHighDeep_PaCx{i}=C_PaCx;
    B_Spk_SpiHighDeep_PaCx{i}=B_PaCx;
end

load SpindlesPFCxDeep 
for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorr(SpiHigh(:,1)*1E4,Range(S{i}),20,1000); %C_PFCx(B_PFCx==0)=0;
    C_Spk_SpiHighDeep_PFCx{i}=C_PFCx;
    B_Spk_SpiHighDeep_PFCx{i}=B_PFCx;
end
% -------------------------------------------------------------------------
% plot all that
% -------------------------------------------------------------------------

smo=1;
figure, plot(SmoothDec((B_SingleTone_Delta_MoCx{i}/1E3),smo),C_SingleTone_Delta_MoCx{i},'g')
hold on, plot(SmoothDec((B_SingleTone_Delta_PaCx{i}/1E3),smo),C_SingleTone_Delta_PaCx{i},'r')
hold on, plot(SmoothDec((B_SingleTone_Delta_PFCx{i}/1E3),smo),C_SingleTone_Delta_PFCx{i},'b')
hold on, xlim([-2 2])
hold on, title(['Tone vs Delta Waves (MoCx-g PFCx-b PaCx-r '])

for i=1:length(S)
    figure, subplot(4,1,1)
    hold on, plot(SmoothDec((B_Spk_Tone{i}/1E3),smo),C_Spk_Tone{i},'k')
    hold on, xlim([-2 2])
    hold on, title(['Tone Occurence, Spk#: ',num2str(i),' - ',num2str(cellnames{i})])
    hold on, subplot(4,1,2)
    hold on, plot(SmoothDec((B_Spk_Delta_MoCx{i}/1E3),smo),C_Spk_Delta_MoCx{i},'g')
    hold on, plot(SmoothDec((B_Spk_Delta_PaCx{i}/1E3),smo),C_Spk_Delta_PaCx{i},'r')
    hold on, plot(SmoothDec((B_Spk_Delta_PFCx{i}/1E3),smo),C_Spk_Delta_PFCx{i},'b')
    hold on, xlim([-2 2])
    hold on, title(['Delta Waves, Spk#: ',num2str(i),' - ',num2str(cellnames{i})])
    hold on, subplot(4,1,3)
    hold on, plot(B_Spk_SpiHighSup_PaCx{i}/1E3,C_Spk_SpiHighSup_PaCx{i},'r')
    hold on, plot(B_Spk_SpiHighSup_PFCx{i}/1E3,C_Spk_SpiHighSup_PFCx{i},'b')
    hold on, xlim([-2 2])
    hold on, title(['Spindles High, Sup Layer, Spk#: ',num2str(i),' - ',num2str(cellnames{i})])
    hold on, subplot(4,1,4)
    hold on, plot(B_Spk_SpiHighDeep_PaCx{i}/1E3,C_Spk_SpiHighDeep_PaCx{i},'r')
    hold on, plot(B_Spk_SpiHighDeep_PFCx{i}/1E3,C_Spk_SpiHighDeep_PFCx{i},'b')
    hold on, xlim([-2 2])
    hold on, title(['Spindles High, Deep Layer, Spk#: ',num2str(i),' - ',num2str(cellnames{i})])
end

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
disp(' ')
PFCx_neurons=input('Which neurons from PFCx ? ');
PFCx_Spk=PoolNeurons(S,PFCx_neurons);
disp(' ')

disp(' ')
dHPC_neurons=input('Which neurons from dHPC ? ');
dHPC_Spk=PoolNeurons(S,dHPC_neurons);
disp(' ')

disp(' ')
NRT_neurons=input('Which neurons from NRT ? ');
NRT_Spk=PoolNeurons(S,NRT_neurons);
disp(' ')

disp(' ')
OBulb_neurons=input('Which neurons from OBulb ? ');
OBulb_Spk=PoolNeurons(S,OBulb_neurons);
disp(' ')


% -------------------------------------------------------------------------
load ToneEvent
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000); 
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 

% -------------------------------------------------------------------------
load DeltaMoCx 
[C_PFCxSpk_DeltaMoCx,B_PFCxSpk_DeltaMoCx]=CrossCorr(Range(tDeltaT2),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaMoCx,B_dHPCSpk_DeltaMoCx]=CrossCorr(Range(tDeltaT2),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaMoCx,B_NRTSpk_DeltaMoCx]=CrossCorr(Range(tDeltaT2),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaMoCx,B_OBulbSpk_DeltaMoCx]=CrossCorr(Range(tDeltaT2),Range(OBulb_Spk),20,1000); 

load DeltaPaCx 
[C_PFCxSpk_DeltaPaCx,B_PFCxSpk_DeltaPaCx]=CrossCorr(Range(tDeltaT2),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaPaCx,B_dHPCSpk_DeltaPaCx]=CrossCorr(Range(tDeltaT2),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaPaCx,B_NRTSpk_DeltaPaCx]=CrossCorr(Range(tDeltaT2),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaPaCx,B_OBulbSpk_DeltaPaCx]=CrossCorr(Range(tDeltaT2),Range(OBulb_Spk),20,1000);

load DeltaPFCx 
[C_PFCxSpk_DeltaPFCx,B_PFCxSpk_DeltaPFCx]=CrossCorr(Range(tDeltaT2),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaPFCx,B_dHPCSpk_DeltaPFCx]=CrossCorr(Range(tDeltaT2),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaPFCx,B_NRTSpk_DeltaPFCx]=CrossCorr(Range(tDeltaT2),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaPFCx,B_OBulbSpk_DeltaPFCx]=CrossCorr(Range(tDeltaT2),Range(OBulb_Spk),20,1000);
% -------------------------------------------------------------------------

figure, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'r')
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'c')
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'g')
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'b')
hold on, title(['Spk vs Tone (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
figure, plot(SmoothDec((B_PFCxSpk_DeltaMoCx/1E3),smo),C_PFCxSpk_DeltaMoCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaMoCx/1E3),smo),C_dHPCSpk_DeltaMoCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaMoCx/1E3),smo),C_NRTSpk_DeltaMoCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaMoCx/1E3),smo),C_OBulbSpk_DeltaMoCx,'b')
hold on, title(['Spk vs Delta MoCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
figure, plot(SmoothDec((B_PFCxSpk_DeltaPaCx/1E3),smo),C_PFCxSpk_DeltaPaCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaPaCx/1E3),smo),C_dHPCSpk_DeltaPaCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaPaCx/1E3),smo),C_NRTSpk_DeltaPaCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaPaCx/1E3),smo),C_OBulbSpk_DeltaPaCx,'b')
hold on, title(['Spk vs Delta ParCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
figure, plot(SmoothDec((B_PFCxSpk_DeltaPFCx/1E3),smo),C_PFCxSpk_DeltaPFCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaPFCx/1E3),smo),C_dHPCSpk_DeltaPFCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaPFCx/1E3),smo),C_NRTSpk_DeltaPFCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaPFCx/1E3),smo),C_OBulbSpk_DeltaPFCx,'b')
hold on, title(['Spk vs Delta PFCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])

load ToneEvent
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;

[A,B,C]=mjPETH(Range(Dmot),Tone,Range(Dpfc),20,100,1,1);
hold on, xlabel('ref=Delta MoCx, tx= Tone, ty=Delta PFCx')

[A,B,C]=mjPETH(Range(Dpar),Tone,Range(Dpfc),20,100,1,1);
hold on, xlabel('ref=Delta PaCx, tx= Tone, ty=Delta PFCx')

[A,B,C]=mjPETH(Range(Dpar),Tone,Range(Dmot),20,100,1,1);
hold on, xlabel('ref=Delta PaCx, tx= Tone, ty=Delta MoCx')

[A,B,C]=mjPETH(Range(Dpfc),Tone,Range(Dmot),20,100,1,1);
hold on, xlabel('ref=Delta PFCx, tx= Tone, ty=Delta MoCx')

[A,B,C]=mjPETH(Range(Dmot),Tone,Range(Dpar),20,100,1,1);
hold on, xlabel('ref=Delta MoCx, tx= Tone, ty=Delta PaCx')

[A,B,C]=mjPETH(Range(Dpfc),Tone,Range(Dpar),20,100,1,1);
hold on, xlabel('ref=Delta PFCx, tx= Tone, ty=Delta PaCx')


% 
% [A,B,C]=mjPETH(Range(Dmot),SeqTone,Range(Dpfc),20,100,1,1);
% 
% [A,B,C]=mjPETH(Range(Dpar),Tone,Range(Dpfc),20,100,1,1);
% [A,B,C]=mjPETH(Range(Dpar),SeqTone,Range(Dpfc),20,100,1,1);
% 
% [A,B,C]=mjPETH(Range(Dmot),Range(Dpar),Range(Dpfc),20,100,1,1);
% [A,B,C]=mjPETH(Range(Dpar),Range(Dmot),Range(Dpfc),20,100,1,1);
% [A,B,C]=mjPETH(Range(Dpar),Range(Dpfc),Range(Dmot),20,100,1,1);
% 
% [A,B,C]=mjPETH(Range(tDeltaT2),Tone,Range(Dpfc),20,100,2,0.5);
% 
% [A,B,C]=mjPETH(Range(tDeltaT2),Tone,Range(Dpfc),20,100,1,1);
% Dmot=tDeltaT2;
% load DeltaPaCx
% [A,B,C]=mjPETH(Range(tDeltaT2),Tone,Range(Dpfc),20,100,1,1);
% [A,B,C]=mjPETH(Range(tDeltaT2),Range(Dmot),Range(Dpfc),20,100,1,1);
% doc mjPETH
% edit mjPETH
% [A,B,C]=mjPETH(Range(tDeltaT2),Tone,Range(Dpfc),20,100,1,1);
% [A,B,C]=mjPETH(Range(tDeltaT2),Tone,Tone,20,100,1,1);






