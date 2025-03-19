load StateEpochSB SWSEpoch
endSWS=length(Start(SWSEpoch));
midSWS= floor(endSWS/2);

% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Generate auto correlogram of Delta Waves           -------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>

% -------------------------- Motor cortex --------------------------
load DeltaMoCx 

[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,1000); C(B==0)=0;
figure, subplot(3,1,1)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(3,1,2)
hold on, plot(B/1E3,C)
hold on, title('Motor Delta - all SWS epoch')


[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(3,1,3)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('DeltaT auto-correlogram - SWS begining (black) vs SWS end (red)')

% -------------------------- Parietal cortex --------------------------
load DeltaPaCx 

[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,1000); C(B==0)=0;
figure, subplot(3,1,1)
hold on, plot(B/1E3,C)
hold on, title('Parietal Delta - all SWS epoch')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(3,1,2)
hold on, plot(B/1E3,C)
hold on, title('Parietal Delta - all SWS epoch')

[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(3,1,3)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('DeltaT auto-correlogram - SWS begining (black) vs SWS end (red)')


% -------------------------- Prefrontal cortex --------------------------
load DeltaPFCx 

[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,1000); C(B==0)=0;
figure, subplot(3,1,1)
hold on, plot(B/1E3,C)
hold on, title('Prefrontal Delta - all SWS epoch')
[C,B]=CrossCorr(Range(Restrict(tDeltaT2,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),20,200); C(B==0)=0;
hold on, subplot(3,1,2)
hold on, plot(B/1E3,C)
hold on, title('Prefrontal Delta - all SWS epoch')

[C,B]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),20,200); C(B==0)=0;
[C1,B1]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),20,200); C1(B1==0)=0;
hold on, subplot(3,1,3)
hold on, plot(B/1E3,C,'k'), hold on, plot(B1/1E3,C1,'r')
hold on, title('DeltaT auto-correlogram - SWS begining (black) vs SWS end (red)')



% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% ----------------      Generate auto correlogram of Delta Waves           -------------------
% <><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><>
% -------------------------- Prefrontal cortex --------------------------
load DeltaPFCx 

load SpindlesPFCxDeep 
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiHigh(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiHigh(:,1)*1E4,2000,200);
figure, subplot(4,1,1)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC Delta > PFC High_Spindles (deep)')

load SpindlesPFCxSup
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiHigh(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiHigh(:,1)*1E4,2000,200);
hold on, subplot(4,1,2)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC Delta > PFC High_Spindles (sup)')

load SpindlesPFCxDeep 
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiLow(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiLow(:,1)*1E4,2000,200);
hold on, subplot(4,1,3)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC Delta > PFC Low_Spindles (deep)')

load SpindlesPFCxSup
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiLow(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiLow(:,1)*1E4,2000,200);
hold on, subplot(4,1,4)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC Delta > PFC Low_Spindles (sup)')

% -------------------------- Parietal cortex --------------------------
load DeltaPaCx 

load SpindlesPaCxDeep 
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiHigh(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiHigh(:,1)*1E4,2000,200);
figure, subplot(4,1,1)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx Delta > ParCx High_Spindles (deep)')

load SpindlesPaCxSup
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiHigh(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiHigh(:,1)*1E4,2000,200);
hold on, subplot(4,1,2)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx Delta > ParCx High_Spindles (sup)')

load SpindlesPaCxDeep 
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiLow(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiLow(:,1)*1E4,2000,200);
hold on, subplot(4,1,3)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx Delta > ParCx Low_Spindles (deep)')

load SpindlesPaCxSup
[C2,B2]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),SpiLow(:,1)*1E4,2000,200);
[C3,B3]=CrossCorr(Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),SpiLow(:,1)*1E4,2000,200);
hold on, subplot(4,1,4)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx Delta > ParCx Low_Spindles (sup)')

% -------------------------- Prefrontal cortex --------------------------
load DeltaPFCx 

load SpindlesPFCxDeep 
[C2,B2]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
figure, subplot(4,1,1)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC hi_Slow Waves > PFC Delta (deep)')

load SpindlesPFCxSup
[C2,B2]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,2)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC hi_Slow Waves > PFC Delta (sup)')

load SpindlesPFCxDeep 
[C2,B2]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,3)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC low_Slow Waves > PFC Delta (deep)')

load SpindlesPFCxSup
[C2,B2]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,4)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PFC low_Slow Waves > PFC Delta (sup)')

% -------------------------- Parietal cortex --------------------------
load DeltaPFCx 

load SpindlesPaCxDeep 
[C2,B2]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
figure, subplot(4,1,1)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx hi_Slow Waves > PFC Delta (deep)')

load SpindlesPaCxSup
[C2,B2]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWAHigh(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,2)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx hi_Slow Waves > PFC Delta (sup)')

load SpindlesPaCxDeep 
[C2,B2]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,3)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx low_Slow Waves > PFC Delta (deep)')

load SpindlesPaCxSup
[C2,B2]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,1:midSWS))),2000,200);
[C3,B3]=CrossCorr(SWALow(:,1)*1E4,Range(Restrict(tDeltaT2,subset(SWSEpoch,midSWS:endSWS))),2000,200);
hold on, subplot(4,1,4)
hold on, plot(B2/1E3,C2,'k'), 
hold on, plot(B3/1E3,C3,'r'), 
hold on, plot(0,min(min([C2 C3])):0.001:max(max([C2 C3])),'b','linewidth',1);
hold on, title(' PaCx low_Slow Waves > PFC Delta (sup)')


