%Spk_Tone_Delta_Analysis

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Generate auto correlogram of Delta Waves           -------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
res=pwd;
load SpikeData
load ToneEvent
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;

disp(' ')
toto=input('Single or Seq Tone ?   ');
disp(' ')

if strcmp('Single', toto)
    Tone=SingleTone;
elseif strcmp('Seq', toto)
    Tone=SeqTone;
end

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
for i=1:length(S)
    [C_Tone,B_Tone]=CrossCorrGL(Tone,Range(S{i}),20,1000); %C_Tone(B_Tone==0)=0;
    C_Spk_Tone{i}=C_Tone;
    B_Spk_Tone{i}=B_Tone;
end
% -------------------------------------------------------------------------
% tone compared to delta :
% -------------------------------------------------------------------------
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorrGL(Tone,Range(Dmot),20,1000); %C_MoCx(B_MoCx==0)=0;
    C_SingleTone_Delta_MoCx{i}=C_MoCx;
    B_SingleTone_Delta_MoCx{i}=B_MoCx;
end

for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorrGL(Tone,Range(Dpar),20,1000); %C_PaCx(B_PaCx==0)=0;
    C_SingleTone_Delta_PaCx{i}=C_PaCx;
    B_SingleTone_Delta_PaCx{i}=B_PaCx;
end

for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorrGL(Tone,Range(Dpfc),20,1000); %C_PFCx(B_PFCx==0)=0;
    C_SingleTone_Delta_PFCx{i}=C_PFCx;
    B_SingleTone_Delta_PFCx{i}=B_PFCx;
end

% -------------------------------------------------------------------------
% spikes compared to delta :
% -------------------------------------------------------------------------
for i=1:length(S)
    [C_MoCx,B_MoCx]=CrossCorrGL(Range(Dmot),Range(S{i}),20,1000); %C_MoCx(B_MoCx==0)=0;
    C_Spk_Delta_MoCx{i}=C_MoCx;
    B_Spk_Delta_MoCx{i}=B_MoCx;
end

for i=1:length(S)
    [C_PaCx,B_PaCx]=CrossCorrGL(Range(Dpar),Range(S{i}),20,1000); %C_PaCx(B_PaCx==0)=0;
    C_Spk_Delta_PaCx{i}=C_PaCx;
    B_Spk_Delta_PaCx{i}=B_PaCx;
end

for i=1:length(S)
    [C_PFCx,B_PFCx]=CrossCorrGL(Range(Dpfc),Range(S{i}),20,1000); %C_PFCx(B_PFCx==0)=0;
    C_Spk_Delta_PFCx{i}=C_PFCx;
    B_Spk_Delta_PFCx{i}=B_PFCx;
end

% -------------------------------------------------------------------------
% plot all that
% -------------------------------------------------------------------------
mkdir('SpikingActivity_Tone_Delta');
cd([res,'/SpikingActivity_Tone_Delta'])
res=pwd;

smo=1;
figure, plot(SmoothDec((B_SingleTone_Delta_MoCx{i}/1E3),smo),C_SingleTone_Delta_MoCx{i},'g')
hold on, plot(SmoothDec((B_SingleTone_Delta_PaCx{i}/1E3),smo),C_SingleTone_Delta_PaCx{i},'r')
hold on, plot(SmoothDec((B_SingleTone_Delta_PFCx{i}/1E3),smo),C_SingleTone_Delta_PFCx{i},'b')
hold on, xlim([-2 2])
hold on, title(['Tone vs Delta Waves (MoCx-g PFCx-b PaCx-r '])
saveFigure(1,(['Tone_Delta']),res)
close

a=1;
for i=PFCx_neurons(1):length(S)
    figure, subplot(2,1,1)
    hold on, plot(SmoothDec((B_Spk_Tone{i}/1E3),smo),C_Spk_Tone{i},'k')
    hold on, xlim([-2 2])
    hold on, title(['Tone Occurence'])
    hold on, subplot(2,1,2)
    hold on, plot(SmoothDec((B_Spk_Delta_MoCx{i}/1E3),smo),C_Spk_Delta_MoCx{i},'g')
    hold on, plot(SmoothDec((B_Spk_Delta_PaCx{i}/1E3),smo),C_Spk_Delta_PaCx{i},'r')
    hold on, plot(SmoothDec((B_Spk_Delta_PFCx{i}/1E3),smo),C_Spk_Delta_PFCx{i},'b')
    yl=ylim;
    ylim([0 yl(2)])
    hold on, xlim([-2 2])
    hold on, title(['Delta Waves (MoCx-g, PaCx-r, PFCx-b)'])
    hold on, legend(['neuron #',num2str(i)],cellnames{i})
    saveFigure(a,(['Spike_Tone_Delta_neuron#',num2str(i)]),res)
    a=a+1;
end




% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------



% -------------------------------------------------------------------------
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorrGL(Tone,Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorrGL(Tone,Range(dHPC_Spk),20,1000); 
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorrGL(Tone,Range(NRT_Spk),20,1000); 
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorrGL(Tone,Range(OBulb_Spk),20,1000); 

% -------------------------------------------------------------------------
[C_PFCxSpk_DeltaMoCx,B_PFCxSpk_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaMoCx,B_dHPCSpk_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaMoCx,B_NRTSpk_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaMoCx,B_OBulbSpk_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(OBulb_Spk),20,1000); 

[C_PFCxSpk_DeltaPaCx,B_PFCxSpk_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaPaCx,B_dHPCSpk_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaPaCx,B_NRTSpk_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaPaCx,B_OBulbSpk_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(OBulb_Spk),20,1000);

[C_PFCxSpk_DeltaPFCx,B_PFCxSpk_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(PFCx_Spk),20,1000); 
[C_dHPCSpk_DeltaPFCx,B_dHPCSpk_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(dHPC_Spk),20,1000); 
[C_NRTSpk_DeltaPFCx,B_NRTSpk_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(NRT_Spk),20,1000); 
[C_OBulbSpk_DeltaPFCx,B_OBulbSpk_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(OBulb_Spk),20,1000);
% -------------------------------------------------------------------------

figure, subplot(4,1,1)
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'r')
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'c')
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'g')
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'b')
hold on, title(['Spk vs Tone (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
hold on, subplot(4,1,2)
hold on, plot(SmoothDec((B_PFCxSpk_DeltaMoCx/1E3),smo),C_PFCxSpk_DeltaMoCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaMoCx/1E3),smo),C_dHPCSpk_DeltaMoCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaMoCx/1E3),smo),C_NRTSpk_DeltaMoCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaMoCx/1E3),smo),C_OBulbSpk_DeltaMoCx,'b')
hold on, title(['Spk vs Delta MoCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
hold on, subplot(4,1,3)
hold on, plot(SmoothDec((B_PFCxSpk_DeltaPaCx/1E3),smo),C_PFCxSpk_DeltaPaCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaPaCx/1E3),smo),C_dHPCSpk_DeltaPaCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaPaCx/1E3),smo),C_NRTSpk_DeltaPaCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaPaCx/1E3),smo),C_OBulbSpk_DeltaPaCx,'b')
hold on, title(['Spk vs Delta ParCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
hold on, subplot(4,1,4)
hold on, plot(SmoothDec((B_PFCxSpk_DeltaPFCx/1E3),smo),C_PFCxSpk_DeltaPFCx,'r')
hold on, plot(SmoothDec((B_dHPCSpk_DeltaPFCx/1E3),smo),C_dHPCSpk_DeltaPFCx,'c')
hold on, plot(SmoothDec((B_NRTSpk_DeltaPFCx/1E3),smo),C_NRTSpk_DeltaPFCx,'g')
hold on, plot(SmoothDec((B_OBulbSpk_DeltaPFCx/1E3),smo),C_OBulbSpk_DeltaPFCx,'b')
hold on, title(['Spk vs Delta PFCx (PFCx-r dHPC-c NRT-g OBulb-b'])
hold on, xlim([-2 2])
saveFigure(a,(['Spike_Tone_Delta_Allneuron']),res)

%----------------------------------------------------------------------------------

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






