%DeltaWaveAutoCorr
directoryName1=('/media/DataMOBs25/BreathDeltaProject/Mouse243-244/');
directoryName2=('/media/DataMOBs24/BreathFeedBack/Mouse243-244/');
smo=1;
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Generate auto correlogram of Delta Waves           -------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% -------------------------- Motor cortex --------------------------
% Mouse 244 - No Tone (22022015) :
cd([directoryName2,'20150222/Breath-Mouse-243-244-22022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaMoCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
figure, subplot(5,2,1)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
hold on, ylabel('NoTone Day')
[C,B] = CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1] = CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,2)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('Motor Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('NoTone Day')

% Mouse 244 - Random Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaMoCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,3)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
hold on, ylabel('Random Tone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,4)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('Motor Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('Random Tone Day')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaMoCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,5)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
hold on, ylabel('MoCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,6)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('Motor Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('MoCxDeltaTone Day')


% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaMoCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,7)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,8)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('Motor Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone Day')


% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaMoCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,9)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone-10* Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,10)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('Motor Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone-10* Day')




% -------------------------- Parietal cortex --------------------------
% Mouse 244 - No Tone (22022015) :
cd([directoryName2,'20150222/Breath-Mouse-243-244-22022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPaCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
figure, subplot(5,2,1)
hold on, plot(B/1E3,C)
hold on, title('PaCx Delta - all SWS epoch')
hold on, ylabel('NoTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,2)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PaCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('NoTone Day')

% Mouse 244 - Random Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPaCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,3)
hold on, plot(B/1E3,C)
hold on, title('PaCx Delta - all SWS epoch')
hold on, ylabel('Random Tone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,4)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PaCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('Random Tone Day')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPaCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,5)
hold on, plot(B/1E3,C)
hold on, title('PaCx Delta - all SWS epoch')
hold on, ylabel('MoCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,6)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PaCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('MoCxDeltaTone Day')


% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPaCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,7)
hold on, plot(B/1E3,C)
hold on, title('PaCx Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,8)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PaCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone Day')


% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPaCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,9)
hold on, plot(B/1E3,C)
hold on, title('PaCx Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone-10* Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,10)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PaCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone-10* Day')






% -------------------------- Parietal cortex --------------------------
% Mouse 244 - No Tone (22022015) :
cd([directoryName2,'20150222/Breath-Mouse-243-244-22022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPFCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
figure, subplot(5,2,1)
hold on, plot(B/1E3,C)
hold on, title('PFCx Delta - all SWS epoch')
hold on, ylabel('NoTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,2)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PFCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('NoTone Day')

% Mouse 244 - Random Tone (23022015) :
cd([directoryName2,'20150223/Breath-Mouse-243-244-23022015/Mouse244'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPFCx
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,3)
hold on, plot(B/1E3,C)
hold on, title('PFCx Delta - all SWS epoch')
hold on, ylabel('Random Tone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,4)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PFCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('Random Tone Day')

% Mouse 244 - Single Tone triggered by MoCx Delta Waves (05032015) :
cd([directoryName1,'/20150305/Mouse244/Electrophy/Breath-Mouse-244-05032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPFCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,5)
hold on, plot(B/1E3,C)
hold on, title('PFCx Delta - all SWS epoch')
hold on, ylabel('MoCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,6)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PFCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('MoCxDeltaTone Day')


% Mouse 244 - Single Tone triggered by PaCx Delta Waves (06032015) :
cd([directoryName1,'/20150306/Mouse244/Electrophy/Breath-Mouse-244-06032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPFCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,7)
hold on, plot(B/1E3,C)
hold on, title('PFCx Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,8)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PFCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone Day')


% Mouse 244 - Sequence Tone triggered by PaCx Delta Waves (09032015) :
cd([directoryName1,'/20150309/Mouse244/Electrophy/Breath-Mouse-244-09032015'])
load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);
load DeltaPFCx 
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(5,2,9)
hold on, plot(B/1E3,C)
hold on, title('PFCx Delta - all SWS epoch')
hold on, ylabel('PaCxDeltaTone-10* Day')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(5,2,10)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('PFCx Delta - SWS start (black) vs SWS end (red)')
hold on, ylabel('PaCxDeltaTone-10* Day')



