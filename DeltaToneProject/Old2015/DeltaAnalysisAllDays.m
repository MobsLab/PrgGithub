directoryName_Mouse243_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse243');
directoryName_Mouse244_Day1=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150222/Breath-Mouse-243-244-22022015/Mouse244');
directoryName_Mouse243_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse243');
directoryName_Mouse244_Day2=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Electrophy/Breath-Mouse-243-244-29032015/Mouse244');
directoryName_Mouse243_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse243');
directoryName_Mouse244_Day3=('/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150331/Electrophy/Breath-Mouse-243-244-31032015/Mouse244');
directoryName_Mouse243_Day4=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150401/Breath-Mouse-243-244-01042015/Mouse243');
directoryName_Mouse244_Day4=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150401/Breath-Mouse-243-244-01042015/Mouse244');
directoryName_Mouse243_Day5=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150409/Breath-Mouse-243-244-09042015/Mouse243');
directoryName_Mouse244_Day5=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/20150409/Breath-Mouse-243-244-09042015/Mouse244');

smo=1;


%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
%%       confirm coherence between Delta Waves and On-line Detection          
%% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% Mouse 243:
cd([directoryName_Mouse243_Day1])
load newDeltaPaCx
DeltaPaCx_M243_Day1=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day1=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day1=tDelta;

% Day2 :
cd([directoryName_Mouse243_Day2])
load newDeltaPaCx
DeltaPaCx_M243_Day2=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day2=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day2=tDelta;

% Day3 :
cd([directoryName_Mouse243_Day3])
load newDeltaPaCx
DeltaPaCx_M243_Day3=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day3=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day3=tDelta;

% Day4 :
cd([directoryName_Mouse243_Day4])
load newDeltaPaCx
DeltaPaCx_M243_Day4=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day4=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day4=tDelta;

% Day5 :
cd([directoryName_Mouse243_Day5])
load newDeltaPaCx
DeltaPaCx_M243_Day5=tDelta;
load newDeltaPFCx
DeltaPFCx_M243_Day5=tDelta;
load newDeltaMoCx
DeltaMoCx_M243_Day5=tDelta;

% -------------------------------------------------------------------------
% Mouse 244:
cd([directoryName_Mouse244_Day1])
load newDeltaPaCx
DeltaPaCx_M244_Day1=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day1=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day1=tDelta;

% Day2 :
cd([directoryName_Mouse244_Day2])
load newDeltaPaCx
DeltaPaCx_M244_Day2=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day2=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day2=tDelta;

% Day3 :
cd([directoryName_Mouse244_Day3])
load newDeltaPaCx
DeltaPaCx_M244_Day3=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day3=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day3=tDelta;

% Day4 :
cd([directoryName_Mouse244_Day4])
load newDeltaPaCx
DeltaPaCx_M244_Day4=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day4=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day4=tDelta;

% Day5 :
cd([directoryName_Mouse244_Day5])
load newDeltaPaCx
DeltaPaCx_M244_Day5=tDelta;
load newDeltaPFCx
DeltaPFCx_M244_Day5=tDelta;
load newDeltaMoCx
DeltaMoCx_M244_Day5=tDelta;

% -------------------------------------------------------------------------
figure, subplot(3,5,1)
hold on, hist(DeltaPaCx_M243_Day1,1000)
title(['PaCx Delta occurence during Day 1'])
hold on, subplot(3,5,2)
hold on, hist(DeltaPaCx_M243_Day2,1000)
title(['PaCx Delta occurence during Day 2'])
hold on, subplot(3,5,3)
hold on, hist(DeltaPaCx_M243_Day3,1000)
title(['PaCx Delta occurence during Day 3'])
hold on, subplot(3,5,4)
hold on, hist(DeltaPaCx_M243_Day4,1000)
title(['PaCx Delta occurence during Day 4'])
hold on, subplot(3,5,5)
hold on, hist(DeltaPaCx_M243_Day5,1000)
title(['PaCx Delta occurence during Day 5'])

hold on, subplot(3,5,6)
hold on, hist(DeltaPFCx_M243_Day1,1000)
title(['PFCx Delta occurence during Day 1'])
hold on, subplot(3,5,7)
hold on, hist(DeltaPFCx_M243_Day2,1000)
title(['PFCx Delta occurence during Day 2'])
hold on, subplot(3,5,8)
hold on, hist(DeltaPFCx_M243_Day3,1000)
title(['PFCx Delta occurence during Day 3'])
hold on, subplot(3,5,9)
hold on, hist(DeltaPFCx_M243_Day4,1000)
title(['PFCx Delta occurence during Day 4'])
hold on, subplot(3,5,10)
hold on, hist(DeltaPFCx_M243_Day5,1000)
title(['PFCx Delta occurence during Day 5'])

hold on,subplot(3,5,11)
hold on, hist(DeltaMoCx_M243_Day1,1000)
title(['MoCx Delta occurence during Day 1'])
hold on, subplot(3,5,12)
hold on, hist(DeltaMoCx_M243_Day2,1000)
title(['MoCx Delta occurence during Day 2'])
hold on, subplot(3,5,13)
hold on, hist(DeltaMoCx_M243_Day3,1000)
title(['MoCx Delta occurence during Day 3'])
hold on, subplot(3,5,14)
hold on, hist(DeltaMoCx_M243_Day4,1000)
title(['MoCx Delta occurence during Day 4'])
hold on, subplot(3,5,15)
hold on, hist(DeltaMoCx_M243_Day5,1000)
title(['MoCx Delta occurence during Day 5'])

% -------------------------------------------------------------------------
figure, subplot(3,5,1)
hold on, hist(DeltaPaCx_M244_Day1,1000)
title(['PaCx Delta occurence during Day 1'])
hold on, subplot(3,5,2)
hold on, hist(DeltaPaCx_M244_Day2,1000)
title(['PaCx Delta occurence during Day 2'])
hold on, subplot(3,5,3)
hold on, hist(DeltaPaCx_M244_Day3,1000)
title(['PaCx Delta occurence during Day 3'])
hold on, subplot(3,5,4)
hold on, hist(DeltaPaCx_M244_Day4,1000)
title(['PaCx Delta occurence during Day 4'])
hold on, subplot(3,5,5)
hold on, hist(DeltaPaCx_M244_Day5,1000)
title(['PaCx Delta occurence during Day 5'])

hold on, subplot(3,5,6)
hold on, hist(DeltaPFCx_M244_Day1,1000)
title(['PFCx Delta occurence during Day 1'])
hold on, subplot(3,5,7)
hold on, hist(DeltaPFCx_M244_Day2,1000)
title(['PFCx Delta occurence during Day 2'])
hold on, subplot(3,5,8)
hold on, hist(DeltaPFCx_M244_Day3,1000)
title(['PFCx Delta occurence during Day 3'])
hold on, subplot(3,5,9)
hold on, hist(DeltaPFCx_M244_Day4,1000)
title(['PFCx Delta occurence during Day 4'])
hold on, subplot(3,5,10)
hold on, hist(DeltaPFCx_M244_Day5,1000)
title(['PFCx Delta occurence during Day 5'])

hold on,subplot(3,5,11)
hold on, hist(DeltaMoCx_M244_Day1,1000)
title(['MoCx Delta occurence during Day 1'])
hold on, subplot(3,5,12)
hold on, hist(DeltaMoCx_M244_Day2,1000)
title(['MoCx Delta occurence during Day 2'])
hold on, subplot(3,5,13)
hold on, hist(DeltaMoCx_M244_Day3,1000)
title(['MoCx Delta occurence during Day 3'])
hold on, subplot(3,5,14)
hold on, hist(DeltaMoCx_M244_Day4,1000)
title(['MoCx Delta occurence during Day 4'])
hold on, subplot(3,5,15)
hold on, hist(DeltaMoCx_M244_Day5,1000)
title(['MoCx Delta occurence during Day 5'])

% -------------------------------------------------------------------------
num=2000;
tot=length(tDelta);
sbin=80;
nbin=200;

[C1,B1]=CrossCorr(DeltaPaCx_M243_Day1,DeltaPaCx_M243_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaPaCx_M243_Day2,DeltaPaCx_M243_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaPaCx_M243_Day3,DeltaPaCx_M243_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaPaCx_M243_Day4,DeltaPaCx_M243_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaPaCx_M243_Day5,DeltaPaCx_M243_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta PaCx - Mouse 243 ')

[C1,B1]=CrossCorr(DeltaPFCx_M243_Day1,DeltaPFCx_M243_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaPFCx_M243_Day2,DeltaPFCx_M243_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaPFCx_M243_Day3,DeltaPFCx_M243_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaPFCx_M243_Day4,DeltaPFCx_M243_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaPFCx_M243_Day5,DeltaPFCx_M243_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta PFCx - Mouse 243 ')

[C1,B1]=CrossCorr(DeltaMoCx_M243_Day1,DeltaMoCx_M243_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaMoCx_M243_Day2,DeltaMoCx_M243_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaMoCx_M243_Day3,DeltaMoCx_M243_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaMoCx_M243_Day4,DeltaMoCx_M243_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaMoCx_M243_Day5,DeltaMoCx_M243_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta MoCx - Mouse 243 ')

%--------------------------------------------------------------------------
[C1,B1]=CrossCorr(DeltaPaCx_M244_Day1,DeltaPaCx_M244_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaPaCx_M244_Day2,DeltaPaCx_M244_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaPaCx_M244_Day3,DeltaPaCx_M244_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaPaCx_M244_Day4,DeltaPaCx_M244_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaPaCx_M244_Day5,DeltaPaCx_M244_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta PaCx - Mouse 244 ')

[C1,B1]=CrossCorr(DeltaPFCx_M244_Day1,DeltaPFCx_M244_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaPFCx_M244_Day2,DeltaPFCx_M244_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaPFCx_M244_Day3,DeltaPFCx_M244_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaPFCx_M244_Day4,DeltaPFCx_M244_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaPFCx_M244_Day5,DeltaPFCx_M244_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta PFCx - Mouse 244 ')

[C1,B1]=CrossCorr(DeltaMoCx_M244_Day1,DeltaMoCx_M244_Day1,sbin,nbin); C1(B1==0)=0;
[C2,B2]=CrossCorr(DeltaMoCx_M244_Day2,DeltaMoCx_M244_Day2,sbin,nbin); C2(B2==0)=0;
[C3,B3]=CrossCorr(DeltaMoCx_M244_Day3,DeltaMoCx_M244_Day3,sbin,nbin); C3(B3==0)=0;
[C4,B4]=CrossCorr(DeltaMoCx_M244_Day4,DeltaMoCx_M244_Day4,sbin,nbin); C4(B4==0)=0;
[C5,B5]=CrossCorr(DeltaMoCx_M244_Day5,DeltaMoCx_M244_Day5,sbin,nbin); C5(B5==0)=0;
C=mean([C1,C2,C3,C4,C5],2);
B=mean([B1,B2,B3,B4,B5],2);
err=(std([C1,C2,C3,C4,C5]')); err=err';
figure, plot(B/1E3,smooth(C,smo),'linewidth',2)
hold on, plot(B/1E3,smooth(C+err,smo))
hold on, plot(B/1E3,smooth(C-err,smo))
hold on, title(' All Days mean Delta MoCx - Mouse 244 ')


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

