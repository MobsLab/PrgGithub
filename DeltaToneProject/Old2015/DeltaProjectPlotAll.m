directoryName1=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/');
directoryName2=('/media/DataMOBs24/BreathFeedBack/Mouse243-244/');
smo=1;


%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%       confirm coherence between Delta Waves and On-line Detection          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% Mouse 244 - Random Tone (22022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015'])

load ToneEvent
Tone=SingleTone;
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;
[C_Tone_dMoCx,B_Tone_dMoCx]=CrossCorr(Tone,Range(Dmot),20,1000); 
[C_Tone_dPaCx,B_Tone_dPaCx]=CrossCorr(Tone,Range(Dpar),20,1000); 
[C_Tone_dPFCx,B_Tone_dPFCx]=CrossCorr(Tone,Range(Dpfc),20,1000); 

figure, subplot(5,1,1)
hold on, plot(SmoothDec((B_Tone_dMoCx/1E3),smo),C_Tone_dMoCx,'g')
hold on, plot(SmoothDec((B_Tone_dPaCx/1E3),smo),C_Tone_dPaCx,'r')
hold on, plot(SmoothDec((B_Tone_dPFCx/1E3),smo),C_Tone_dPFCx,'b')
hold on, xlim([-2 2])
hold on, title(['Single Tone (no trigger) vs Delta Waves (MoCx-g PFCx-b PaCx-r)'])

load ToneEvent
Tone=SeqTone([1:10:end]);
hold on, subplot(5,1,2)
[C_Tone_dMoCx,B_Tone_dMoCx]=CrossCorr(Tone,Range(Dmot),20,1000); 
[C_Tone_dPaCx,B_Tone_dPaCx]=CrossCorr(Tone,Range(Dpar),20,1000); 
[C_Tone_dPFCx,B_Tone_dPFCx]=CrossCorr(Tone,Range(Dpfc),20,1000); 
hold on, plot(SmoothDec((B_Tone_dMoCx/1E3),smo),C_Tone_dMoCx,'g')
hold on, plot(SmoothDec((B_Tone_dPaCx/1E3),smo),C_Tone_dPaCx,'r')
hold on, plot(SmoothDec((B_Tone_dPFCx/1E3),smo),C_Tone_dPFCx,'b')
hold on, xlim([-2 2])
hold on, title(['Seq Tone (no trigger) vs Delta Waves (MoCx-g PFCx-b PaCx-r)'])

% -------------------------------------------------------------------------
% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])

load ToneEvent
Tone=SingleTone;
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;
[C_Tone_dMoCx,B_Tone_dMoCx]=CrossCorr(Tone,Range(Dmot),20,1000); 
[C_Tone_dPaCx,B_Tone_dPaCx]=CrossCorr(Tone,Range(Dpar),20,1000); 
[C_Tone_dPFCx,B_Tone_dPFCx]=CrossCorr(Tone,Range(Dpfc),20,1000); 

hold on, subplot(5,1,3)
hold on, plot(SmoothDec((B_Tone_dMoCx/1E3),smo),C_Tone_dMoCx,'g')
hold on, plot(SmoothDec((B_Tone_dPaCx/1E3),smo),C_Tone_dPaCx,'r')
hold on, plot(SmoothDec((B_Tone_dPFCx/1E3),smo),C_Tone_dPFCx,'b')
hold on, xlim([-2 2])
hold on, title(['Single Tone (trig MoCx) vs Delta Waves (MoCx-g PFCx-b PaCx-r) '])

% -------------------------------------------------------------------------
% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])

load ToneEvent
Tone=SingleTone;
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;
[C_Tone_dMoCx,B_Tone_dMoCx]=CrossCorr(Tone,Range(Dmot),20,1000); 
[C_Tone_dPaCx,B_Tone_dPaCx]=CrossCorr(Tone,Range(Dpar),20,1000); 
[C_Tone_dPFCx,B_Tone_dPFCx]=CrossCorr(Tone,Range(Dpfc),20,1000); 

hold on, subplot(5,1,4)
hold on, plot(SmoothDec((B_Tone_dMoCx/1E3),smo),C_Tone_dMoCx,'g')
hold on, plot(SmoothDec((B_Tone_dPaCx/1E3),smo),C_Tone_dPaCx,'r')
hold on, plot(SmoothDec((B_Tone_dPFCx/1E3),smo),C_Tone_dPFCx,'b')
hold on, xlim([-2 2])
hold on, title(['Single Tone (trig ParCx) vs Delta Waves (MoCx-g PFCx-b PaCx-r) '])

% -------------------------------------------------------------------------
% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])

load ToneEvent
Tone=SeqTone;
load DeltaPFCx
Dpfc=tDeltaT2;
load DeltaPaCx
Dpar=tDeltaT2;
load DeltaMoCx
Dmot=tDeltaT2;
[C_Tone_dMoCx,B_Tone_dMoCx]=CrossCorr(Tone,Range(Dmot),20,1000); 
[C_Tone_dPaCx,B_Tone_dPaCx]=CrossCorr(Tone,Range(Dpar),20,1000); 
[C_Tone_dPFCx,B_Tone_dPFCx]=CrossCorr(Tone,Range(Dpfc),20,1000); 

hold on, subplot(5,1,5)
hold on, plot(SmoothDec((B_Tone_dMoCx/1E3),smo),C_Tone_dMoCx,'g')
hold on, plot(SmoothDec((B_Tone_dPaCx/1E3),smo),C_Tone_dPaCx,'r')
hold on, plot(SmoothDec((B_Tone_dPFCx/1E3),smo),C_Tone_dPFCx,'b')
hold on, xlim([-2 2])
hold on, title(['Sequence Tone (trig ParCx) vs Delta Waves (MoCx-g PFCx-b PaCx-r) '])
% -------------------------------------------------------------------------



%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%                 what tone stimulation does to LFP signal ?          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% -------------------------------------------------------------------------
% Mouse 244 - Random Tone (22022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
plot_LFPall_Tone;
ylabel(['Tone (no trigger)'])

% -------------------------------------------------------------------------
% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
try
    plot_LFPall_Tone;
    ylabel(['Single Tone (trig MoCx)'])
end

% -------------------------------------------------------------------------
% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
try
    plot_LFPall_Tone;
    ylabel(['Single Tone (trig ParCx)'])
end

% -------------------------------------------------------------------------
% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
try
    plot_LFPall_Tone;
    ylabel(['Sequence Tone (trig ParCx)'])
end


%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%                 what tone stimulation does to spiking activity ?          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

figure, 
% -------------------------------------------------------------------------
%                             Prefrontal MUA
% -------------------------------------------------------------------------
% Mouse 244 - Random Single Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load SpikeData
PFCx_Spk=PoolNeurons(S,[36:71]);
load ToneEvent
Tone=SingleTone;
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000); 
hold on, subplot(4,1,1)
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'k')

% Mouse 244 - Random Seq Tone (22022015) :
Tone=SeqTone([1:10:end]);
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000); 
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'ko-')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
PFCx_Spk=PoolNeurons(S,[1:45]);
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000); 
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'g')

% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
PFCx_Spk=PoolNeurons(S,[1:28]);
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000);
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'r')

% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load SpikeData
load ToneEvent
Tone=SeqTone;
PFCx_Spk=PoolNeurons(S,[1:29]);
[C_PFCxSpk_Tone,B_PFCxSpk_Tone]=CrossCorr(Tone,Range(PFCx_Spk),20,1000);
hold on, plot(SmoothDec((B_PFCxSpk_Tone/1E3),smo),C_PFCxSpk_Tone,'rd-')
hold on, xlabel('MUA PFCx')
hold on, xlim([-1 1])

% -------------------------------------------------------------------------
%                             Hippocampal MUA
% -------------------------------------------------------------------------
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load SpikeData
dHPC_Spk=PoolNeurons(S,[72:73]);
load ToneEvent
Tone=SingleTone;
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000);
hold on, subplot(4,1,2)
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'k')

% Mouse 244 - Random Seq Tone (22022015) :
Tone=SeqTone([1:10:end]);
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000);
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'ko-')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
dHPC_Spk=PoolNeurons(S,[46:121]);
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000);
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'g')

% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
dHPC_Spk=PoolNeurons(S,[29:30]);
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000);
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'r')

% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load SpikeData
load ToneEvent
Tone=SeqTone;
dHPC_Spk=PoolNeurons(S,[30:32]);
[C_dHPCSpk_Tone,B_dHPCSpk_Tone]=CrossCorr(Tone,Range(dHPC_Spk),20,1000);
hold on, plot(SmoothDec((B_dHPCSpk_Tone/1E3),smo),C_dHPCSpk_Tone,'ro-')
hold on, xlabel('Hippocampal MUA')
hold on, xlim([-1 1])


% -------------------------------------------------------------------------
%                             Thalamic MUA
% -------------------------------------------------------------------------
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load SpikeData
NRT_Spk=PoolNeurons(S,[74:76]);
load ToneEvent
Tone=SingleTone;
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
hold on, subplot(4,1,3)
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'k')

% Mouse 244 - Random Seq Tone (22022015) :
Tone=SeqTone([1:10:end]);
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'ko-')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
NRT_Spk=PoolNeurons(S,[122:124]);
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'g')

% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
NRT_Spk=PoolNeurons(S,[31:33]);
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'r')

% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load SpikeData
load ToneEvent
Tone=SeqTone;
NRT_Spk=PoolNeurons(S,[33:39]);
[C_NRTSpk_Tone,B_NRTSpk_Tone]=CrossCorr(Tone,Range(NRT_Spk),20,1000); 
hold on, plot(SmoothDec((B_NRTSpk_Tone/1E3),smo),C_NRTSpk_Tone,'ro-')
hold on, xlabel('Thalamic MUA')
hold on, xlim([-1 1])

% -------------------------------------------------------------------------
%                             OlfBulb MUA
% -------------------------------------------------------------------------
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load SpikeData
OBulb_Spk=PoolNeurons(S,[77]);
load ToneEvent
Tone=SingleTone;
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 
hold on, subplot(4,1,4)
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'k')

% Mouse 244 - Random Seq Tone (22022015) :
Tone=SeqTone([1:10:end]);
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'k')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
OBulb_Spk=PoolNeurons(S,[125]);
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'g')

% Mouse 244 - Single Tone triggered by ParCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load SpikeData
load ToneEvent
Tone=SingleTone;
OBulb_Spk=PoolNeurons(S,[34]);
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'r')

% Mouse 244 - Seq Tone triggered by ParCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load SpikeData
load ToneEvent
Tone=SeqTone;
OBulb_Spk=PoolNeurons(S,[40]);
[C_OBulbSpk_Tone,B_OBulbSpk_Tone]=CrossCorr(Tone,Range(OBulb_Spk),20,1000); 
hold on, plot(SmoothDec((B_OBulbSpk_Tone/1E3),smo),C_OBulbSpk_Tone,'ro-')
hold on, xlabel('Olfactory Bulb MUA')
hold on, xlim([-1 1])
hold on, title('black: random tone , green: MoCx delta, red: PaCx delta')



%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%                 what tone stimulation does to oscillatory activity ?          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
DeltaWaveToneCrossCorr;

%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%                 Generate auto correlogram of Delta Waves          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
DeltaWaveAutoCorr;

%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%                 Generate cross correlogram of Delta Waves          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
DeltaWaveCrossCorr;

