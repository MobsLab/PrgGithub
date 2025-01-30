function [tDeltaT2,tDeltaP2,usedEpoch]=FindDeltaWavesChan(struct,Epoch,chan,plo,thD,th)

% ch2  channel in superficial layers or EcoG/EEG
% ch channel in deep layers
usedEpoch=Epoch;

try
    plo;
catch
    plo=0;
end

try
    thD;
catch
    thD=2;
end

try
    th;
catch
    th=10000;
end

relativ=1;
%relativ=0; absTh=1E2;

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

load LFPData/InfoLFP
try
if isempty(chan)
    clear chan
end
end
    
try
    chan
    ch=chan(1);
    ch2=chan(2);
catch
    eval(['load(''ChannelsToAnalyse/',struct,'_deep.mat'')'])
    ch=channel;
    eval(['load(''ChannelsToAnalyse/',struct,'_sup.mat'')'])
    ch2=channel;
end

eval(['load(''LFPData/LFP',num2str(ch),'.mat'')'])
eegDeep=LFP;

eval(['load(''LFPData/LFP',num2str(ch2),'.mat'')'])
eegSup=LFP;

clear LFP
%eval(['load(''SpectrumDataL/Spectrum',num2str(channel),'.mat'')'])


%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

EEGsleep=ResampleTSD(tsd(Range(eegDeep),(abs(Data(eegDeep))+abs(Data(eegSup)))),100);

%figure, hist(Data(EEGsleep),1000), yl=ylim; hold on, line([th th],yl,'color','r')
%lfp=CleanLFP(EEGsleep,[-2500 2500]);

badEpoch=thresholdIntervals(EEGsleep,th,'Direction','Above');

badEpoch=dropShortIntervals(badEpoch,0.01E4);
badEpoch=mergeCloseIntervals(badEpoch,4E4);
badEpoch=dropShortIntervals(badEpoch,4E4);

rg=Range(EEGsleep);
try
    Epoch;
catch
    Epoch=intervalSet(rg(1),rg(end));
    
end

deb=rg(1);
goodEpoch=Epoch-badEpoch;

if InfoLFP.depth(InfoLFP.channel==ch2)==1
    EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Data(eegSup)-Data(eegDeep)),100);
else
    EEGsleepD=ResampleTSD(tsd(Range(eegDeep),2*Data(eegSup)-Data(eegDeep)),100);
    disp('EEG or EcoG')
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


%thD=2; %2

clear tDelta
tDeltaP=[];
tDeltaT=[];
for i=1:length(Start(goodEpoch))
    try
        lfp=Restrict(EEGsleepD,subset(goodEpoch,i));
        
        Filt_EEGd = FilterLFP(lfp, [1 5], 1024);
        
        eegd=Data(Filt_EEGd)';
        td=Range(Filt_EEGd,'s')';
        
        de = diff(eegd);
        de1 = [de 0];
        de2 = [0 de];
        
        %finding peaks
        upPeaksIdx = find(de1 < 0 & de2 > 0);
        downPeaksIdx = find(de1 > 0 & de2 < 0);
        
        PeaksIdx = [upPeaksIdx downPeaksIdx];
        PeaksIdx = sort(PeaksIdx);
        
        Peaks = eegd(PeaksIdx);
        %   Peaks = abs(Peaks);
        
        tDeltatemp=td(PeaksIdx);
        
        if relativ
            DetectThresholdP=+mean(Data(Filt_EEGd))+thD*std(Data(Filt_EEGd));
            DetectThresholdT=-mean(Data(Filt_EEGd))-thD*std(Data(Filt_EEGd));
            %thD*std(Data(Filt_EEGd))
        else
            DetectThresholdP=+mean(Data(Filt_EEGd))+absTh;
            DetectThresholdT=-mean(Data(Filt_EEGd))-absTh;
        end
        
        % length(tDeltatemp)
        
        idsT=find((Peaks<DetectThresholdT));
        idsP=find((Peaks>DetectThresholdP));
        
        tDeltatempT=tDeltatemp(idsT);
        tDeltatempP=tDeltatemp(idsP);
        
        tDeltaT=[tDeltaT,tDeltatempT];
        tDeltaP=[tDeltaP,tDeltatempP];
    catch
        usedEpoch=usedEpoch-subset(goodEpoch,i);
        usedEpoch=CleanUpEpoch(usedEpoch);
    end
end

tDeltaT=ts(sort(tDeltaT)*1E4);
tDeltaP=ts(sort(tDeltaP)*1E4);

tdeltaT=Range(tDeltaT);
tdeltaP=Range(tDeltaP);

idd=find(tdeltaT+1E4<rg(end)&tdeltaT-1E4>0);
tDeltaT2=tdeltaT(idd);
tDeltaT2=ts(tDeltaT2);

idd=find(tdeltaP+1E4<rg(end)&tdeltaP-1E4>0);
tDeltaP2=tdeltaP(idd);
tDeltaP2=ts(tDeltaP2);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if plo
    
    figure('color',[1 1 1]),
    
    subplot(2,1,1), hold on
    tbins=4;nbbins=300;
    
    [ma1,sa1,tpsa1]=mETAverage(Range(tDeltaT2), Range(eegSup),Data(eegSup),tbins,nbbins);
    [ma2,sa2,tpsa2]=mETAverage(Range(tDeltaT2), Range(eegDeep),Data(eegDeep),tbins,nbbins);
    plot(tpsa1,ma1,'b','linewidth',2),
    plot(tpsa1,ma1+sa1,'b','linewidth',1),
    plot(tpsa1,ma1-sa1,'b','linewidth',1),
    
    plot(tpsa2,ma2,'r','linewidth',2),
    plot(tpsa2,ma2+sa2,'r','linewidth',1),
    plot(tpsa2,ma2-sa2,'r','linewidth',1),
    
    yl=ylim;
    line([0 0],[yl(1) yl(2)],'color','k')
    title(['Delta waves Throughs, Superficial (blue), deep (red), n=',num2str(length(Range(tDeltaT2)))])
    
    subplot(2,1,2), hold on
    tbins=4;nbbins=300;
    [ma1,sa1,tpsa1]=mETAverage(Range(tDeltaP2), Range(eegSup),Data(eegSup),tbins,nbbins);
    [ma2,sa2,tpsa2]=mETAverage(Range(tDeltaP2), Range(eegDeep),Data(eegDeep),tbins,nbbins);
    plot(tpsa1,ma1,'b','linewidth',2),
    plot(tpsa1,ma1+sa1,'b','linewidth',1),
    plot(tpsa1,ma1-sa1,'b','linewidth',1),
    
    plot(tpsa2,ma2,'r','linewidth',2),
    plot(tpsa2,ma2+sa2,'r','linewidth',1),
    plot(tpsa2,ma2-sa2,'r','linewidth',1),
    yl=ylim;
    line([0 0],[yl(1) yl(2)],'color','k')
    title(['Delta waves Peaks, Superficial (blue), deep (red), n=',num2str(length(Range(tDeltaP2)))])
    
    set(gcf,'position',[73   125   518   765])
end

