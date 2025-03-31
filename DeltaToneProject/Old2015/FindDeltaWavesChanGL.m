function [tDelta,DeltaEpoch]=FindDeltaWavesChanGL(struct,Epoch,chan,plo,thD,th,freqDelta)

% ch2  channel in superficial layers or EcoG/EEG
% ch channel in deep layers
% th threshold remove short delta (in ms)
% thD sd threshold for delta extrema detection
% freqDelta freq used to filter the signal
%
% output:
% tDelta: !!! en 1E-4 s (faire ts(tDelta) en sortie)
%

usedEpoch=Epoch;

try
    plo;
catch
    plo=0;
end

try
    thD(1);
catch
    thD=2;
end

try
    th(1);
catch
    th=75;
end


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
    try
        eval(['load(''ChannelsToAnalyse/',struct,'_sup.mat'')'])
    catch
        eval(['load(''ChannelsToAnalyse/',struct,'_deltasup.mat'')'])
    end
            
    ch2=channel;
end

eval(['load(''LFPData/LFP',num2str(ch),'.mat'')'])
eegDeep=LFP;

eval(['load(''LFPData/LFP',num2str(ch2),'.mat'')'])
eegSup=LFP;

clear LFP


%--------------------------------------------------------------------------
%------------------- difference [EEGdeep;EEGsup] --------------------------
%--------------------------------------------------------------------------

% find factor to increase EEGsup signal compared to EEGdeep
k=1;
for i=0.1:0.1:4
    S(k)=std(Data(eegDeep)-i*Data(eegSup));
    k=k+1;
end
Factor=find(S==min(S))*0.1;

% Difference between EEG deep and EEG sup (*factor)
EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Factor*Data(eegSup)-Data(eegDeep)),100); 

%--------------------------------------------------------------------------
%----------------- ensure quality of choosen Epoch ------------------------
%--------------------------------------------------------------------------

% EEGsleep=ResampleTSD(tsd(Range(eegDeep),(abs(Data(eegDeep))+abs(Data(eegSup)))),100);
% 
% badEpoch=thresholdIntervals(EEGsleep,th,'Direction','Above');
% badEpoch=dropShortIntervals(badEpoch,0.01E4);
% badEpoch=mergeCloseIntervals(badEpoch,4E4);
% badEpoch=dropShortIntervals(badEpoch,4E4);
% 
% rg=Range(EEGsleep);
% try
%     Epoch;
% catch
%     Epoch=intervalSet(rg(1),rg(end));
%     
% end
% 
% deb=rg(1);
% goodEpoch=Epoch-badEpoch;

% if InfoLFP.depth(InfoLFP.channel==ch2)==1
%     EEGsleepD=ResampleTSD(tsd(Range(eegDeep),Data(eegSup)-Data(eegDeep)),100);
% else
%     EEGsleepD=ResampleTSD(tsd(Range(eegDeep),2*Data(eegSup)-Data(eegDeep)),100);
%     disp('EEG or EcoG')
% end

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

try
    freqDelta;
catch
freqDelta=[1 5];
end

clear tDelta
tDelta=[];
Filt_EEGd = FilterLFP(EEGsleepD, freqDelta, 1024);
Filt_EEGd = Restrict(Filt_EEGd,Epoch);
OK=max(-Data(Filt_EEGd),0);
try
    DeltaEpoch1=thresholdIntervals(tsd(Range(Restrict(EEGsleepD,Epoch)), OK),thD*std(OK(OK>0)),'Direction','Above');
    
    DeltaEpoch=dropShortIntervals(DeltaEpoch1,th*10); % crucial element for noise detection (75ms) !!!!!!!!!!!!!!!!!!!!!!!!!!
    tDelta=Start(DeltaEpoch)+(End(DeltaEpoch)-Start(DeltaEpoch))/2;
    
    disp(['number of detected Delta Waves = ',num2str(length(tDelta))])
catch
    disp(['no delta wave detected during SWS'])
end



%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------


if plo
    
    figure('color',[1 1 1]),
    
    subplot(2,2,1:2), hold on
    tbins=4;nbbins=300;
    
    [ma1,sa1,tpsa1]=mETAverage(Range(ts(tDelta)), Range(eegSup),Data(eegSup),tbins,nbbins);
    [ma2,sa2,tpsa2]=mETAverage(Range(ts(tDelta)), Range(eegDeep),Data(eegDeep),tbins,nbbins);
    plot(tpsa1,ma1,'b','linewidth',2),
    plot(tpsa1,ma1+sa1,'b','linewidth',1),
    plot(tpsa1,ma1-sa1,'b','linewidth',1),
    
    plot(tpsa2,ma2,'r','linewidth',2),
    plot(tpsa2,ma2+sa2,'r','linewidth',1),
    plot(tpsa2,ma2-sa2,'r','linewidth',1),
    
    yl=ylim;
    line([0 0],[yl(1) yl(2)],'color','k')
    title(['Delta waves, Superficial (blue), deep (red), n=',num2str(length(Range(ts(tDelta))))])
    
    subplot(2,2,3), hist(End(DeltaEpoch,'s')-Start(DeltaEpoch,'s'),[0:0.001:0.4]),xlim([0 0.39])
    [C,B]=CrossCorr(tDelta,tDelta,10,500);C(B==0)=0;
    [h,b]=hist(diff(tDelta)/1E4,[0:1E-2:2.5]);h(end)=0;
    subplot(2,2,4),hold on, 
    plotyy(B/1E3,C,b,h), 
    
    yl=ylim; line([0 0],yl,'color','r')
    set(gcf,'position',[73   125   518   765])
end