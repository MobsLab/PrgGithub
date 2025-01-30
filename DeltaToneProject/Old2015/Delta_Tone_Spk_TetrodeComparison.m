res=pwd;
load SpikeData
load ToneEvent
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;
smo=1;

disp(' ')
toto=input('Single or Seq Tone ?   ');
disp(' ')

if strcmp('Single', toto)
    Tone=SingleTone;
elseif strcmp('Seq', toto)
    Tone=SeqTone;
end

disp(' ')
PFCx_Tt1=input('Which neurons from PFCx Tt1 ? ');
PFCx_Tt1=PoolNeurons(S,PFCx_Tt1);
disp(' ')
disp(' ')
PFCx_Tt2=input('Which neurons from PFCx Tt2 ? ');
PFCx_Tt2=PoolNeurons(S,PFCx_Tt2);
disp(' ')
disp(' ')
PFCx_Tt3=input('Which neurons from PFCx Tt3 ? ');
PFCx_Tt3=PoolNeurons(S,PFCx_Tt3);
disp(' ')



% -------------------------------------------------------------------------
[C_PFCxTt1_Tone,B_PFCxTt1_Tone]=CrossCorrGL(Tone,Range(PFCx_Tt1),20,1000); 
[C_PFCxTt2_Tone,B_PFCxTt2_Tone]=CrossCorrGL(Tone,Range(PFCx_Tt2),20,1000); 
[C_PFCxTt3_Tone,B_PFCxTt3_Tone]=CrossCorrGL(Tone,Range(PFCx_Tt3),20,1000); 
% -------------------------------------------------------------------------
[C_PFCxTt1_DeltaMoCx,B_PFCxTt1_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(PFCx_Tt1),20,1000); 
[C_PFCxTt2_DeltaMoCx,B_PFCxTt2_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(PFCx_Tt2),20,1000); 
[C_PFCxTt3_DeltaMoCx,B_PFCxTt3_DeltaMoCx]=CrossCorrGL(Range(Dmot),Range(PFCx_Tt3),20,1000); 
% -------------------------------------------------------------------------
[C_PFCxTt1_DeltaPaCx,B_PFCxTt1_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(PFCx_Tt1),20,1000); 
[C_PFCxTt2_DeltaPaCx,B_PFCxTt2_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(PFCx_Tt2),20,1000); 
[C_PFCxTt3_DeltaPaCx,B_PFCxTt3_DeltaPaCx]=CrossCorrGL(Range(Dpar),Range(PFCx_Tt3),20,1000); 
% -------------------------------------------------------------------------
[C_PFCxTt1_DeltaPFCx,B_PFCxTt1_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(PFCx_Tt1),20,1000); 
[C_PFCxTt2_DeltaPFCx,B_PFCxTt2_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(PFCx_Tt2),20,1000); 
[C_PFCxTt3_DeltaPFCx,B_PFCxTt3_DeltaPFCx]=CrossCorrGL(Range(Dpfc),Range(PFCx_Tt3),20,1000); 



figure, subplot(4,1,1)
hold on, plot(SmoothDec((B_PFCxTt1_Tone/1E3),smo),C_PFCxTt1_Tone,'k')
hold on, plot(SmoothDec((B_PFCxTt2_Tone/1E3),smo),C_PFCxTt2_Tone,'b')
hold on, plot(SmoothDec((B_PFCxTt3_Tone/1E3),smo),C_PFCxTt3_Tone,'r')
hold on, title(['Spk vs Tone (Tt1-k Tt2-b Tt3-r)'])
hold on, xlim([-2 2])
yl=ylim;
hold on, ylim([0 yl(2)])
hold on, subplot(4,1,2)
hold on, plot(SmoothDec((B_PFCxTt1_DeltaMoCx/1E3),smo),C_PFCxTt1_DeltaMoCx,'k')
hold on, plot(SmoothDec((B_PFCxTt2_DeltaMoCx/1E3),smo),C_PFCxTt2_DeltaMoCx,'b')
hold on, plot(SmoothDec((B_PFCxTt3_DeltaMoCx/1E3),smo),C_PFCxTt3_DeltaMoCx,'r')
hold on, title(['Spk vs Delta MoCx  (Tt1-k Tt2-b Tt3-r)'])
hold on, xlim([-2 2])
yl=ylim;
hold on, ylim([0 yl(2)])
hold on, subplot(4,1,3)
hold on, plot(SmoothDec((B_PFCxTt1_DeltaPaCx/1E3),smo),C_PFCxTt1_DeltaPaCx,'k')
hold on, plot(SmoothDec((B_PFCxTt2_DeltaPaCx/1E3),smo),C_PFCxTt2_DeltaPaCx,'b')
hold on, plot(SmoothDec((B_PFCxTt3_DeltaPaCx/1E3),smo),C_PFCxTt3_DeltaPaCx,'r')
hold on, title(['Spk vs Delta ParCx (Tt1-k Tt2-b Tt3-r)'])
hold on, xlim([-2 2])
yl=ylim;
hold on, ylim([0 yl(2)])
hold on, subplot(4,1,4)
hold on, plot(SmoothDec((B_PFCxTt1_DeltaPFCx/1E3),smo),C_PFCxTt1_DeltaPFCx,'k')
hold on, plot(SmoothDec((B_PFCxTt2_DeltaPFCx/1E3),smo),C_PFCxTt2_DeltaPFCx,'b')
hold on, plot(SmoothDec((B_PFCxTt3_DeltaPFCx/1E3),smo),C_PFCxTt3_DeltaPFCx,'r')
hold on, title(['Spk vs Delta PFCx (Tt1-k Tt2-b Tt3-r)'])
hold on, xlim([-2 2])

saveFigure(1,(['Spike_Tone_Delta_Allneuron_TetrodeComaprison']),res)