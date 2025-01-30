function [A,B,C,A1,B1,C1]=JointPETHRipSpiDelta(PF,Epoch)

try
    PF;
catch
    PF=1;
end

load RipplesdHPC25 dHPCrip
rip=ts(dHPCrip(:,2)*1E4);
load StateEpoch SWSEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch
try
        SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
    catch
        try
          SWSEpoch=SWSEpoch-NoiseEpoch-GndNoiseEpoch;  
        catch
          SWSEpoch=SWSEpoch-NoiseEpoch;
        end
end
SWSEpoch=dropShortIntervals(SWSEpoch,15E4);

load behavResources PreEpoch
try
    SWSEpoch=and(SWSEpoch,PreEpoch);
end
    
try
    Epoch;
    SWSEpoch=and(SWSEpoch,Epoch);
end

if PF
load DeltaPFCx
load SpindlesPFCxDeep
else
load DeltaPaCx
load SpindlesPaCxDeep
end

spiH=ts(SpiHigh(:,1)*1E4);

[A1,B1,C1]=mjPETH(Range(rip),Range(Restrict(spiH,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),100,50,1);
yl=ylim;
set(gcf,'position',[2007         465         560         420])
if PF
    title('PFC')
else
    title('Par Cx')
end
ylim(yl)

[A,B,C]=mjPETH(Range(rip),Range(Restrict(spiH,SWSEpoch)),Range(Restrict(tDeltaT2,SWSEpoch)),200,200,2);
yl=ylim;
set(gcf,'position',[2581         466         560         420])
if PF
    title('PFC')
else
    title('Par Cx')
end
ylim(yl)

