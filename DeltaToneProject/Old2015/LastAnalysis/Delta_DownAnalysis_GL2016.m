% Delta_DownAnalysis(ch,plo,S,NumNeurons,LFPd,LFPs)

try
    ch;
catch
    ch=1; %Down perfect
end
try
    plo;
catch
    plo=1;
end


% ------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------
% --------------------------  Analyse LFP compared to Down  --------------------------------------
% ------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------

load ChannelsToAnalyse/PFCx_deep
eval(['load LFPData/LFP',num2str(channel)])
LFPd=LFP;
clear LFP

load ChannelsToAnalyse/PFCx_sup
eval(['load LFPData/LFP',num2str(channel)])
LFPs=LFP;
clear LFP

load StateEpochSB SWSEpoch REMEpoch Wake

load SpikeData
eval(['load SpikesToAnalyse/PFCx_Neurons'])
NumNeurons=number;
binSize=10;

disp(' ')
disp('**** Average LFP to Down ****')

for ch=[1 2]

    figure('color',[1 1 1]), hold on
    a=1;
    
    for limSizDown=[50 100 150 250];
        th=0.01;
        [Down,Qt,B,h1,b1,h2,b2,h3,b3,h4,b4,th]=FindDownGL(S,NumNeurons,SWSEpoch,binSize,th,ch,0,[0 limSizDown],1);close
        
        stDown=Start(Down,'s');
        [MLdeepStart,TLdeepStart]=PlotRipRaw(LFPd,stDown,800,1);close
        [MLsupStart,TLsupStart]=PlotRipRaw(LFPs,stDown,800,1);close
        
        tps=MLdeepStart(:,1);
        
        test=nanmean(TLdeepStart(:,:));
        maxx=max(nanmean(TLdeepStart(:,:)));
        HalfPeak=find(test>maxx/2);
        HalfPeakStartDeep=MLdeepStart(HalfPeak(1));
        HalfPeakEndDeep=MLdeepStart(HalfPeak(end));
        durationPeakDeep=HalfPeakEndDeep-HalfPeakStartDeep;
        
        test=nanmean(TLsupStart(:,:));
        minn=min(nanmean(TLsupStart(:,:)));
        HalfPeak=find(test<minn/2);
        HalfPeakStartSup=MLdeepStart(HalfPeak(1));
        HalfPeakEndSup=MLdeepStart(HalfPeak(end));
        durationPeakSup=HalfPeakEndSup-HalfPeakStartSup;
        
        hold on, subplot(4,4,a)
        hold on, plot(tps,nanmean(TLdeepStart(:,:)),'k')
        hold on, plot(tps,nanmean(TLsupStart(:,:)),'r')
        hold on, axis([-0.8 0.8 -1200 1200])
        hold on, title(['Spike th = ',num2str(th),' - Duration=',num2str(limSizDown),'ms, (n=',num2str(length(Start(Down))),')'])
        disp(' ')
        
        hold on, subplot(4,4,a+4)
        hold on, PlotErrorBar4(max(nanmean(TLdeepStart(:,:))),max(nanmean(TLsupStart(:,:))),min(nanmean(TLdeepStart(:,:))),min(nanmean(TLsupStart(:,:))),0), xlabel('Delta Wave max/min Amplitude'),
        
        hold on, subplot(4,4,a+8)
        hold on, PlotErrorBar2(HalfPeakStartDeep,durationPeakDeep,0), xlabel(['start = ',num2str(HalfPeakStartDeep),' s - duration = ',num2str(durationPeakDeep),'s']),title('Beginning & End of Half Peak in Deep Layer')
        
        hold on, subplot(4,4,a+12)
        hold on, PlotErrorBar2(HalfPeakStartSup,durationPeakSup,0), xlabel(['start = ',num2str(HalfPeakStartSup),' s - duration = ',num2str(durationPeakSup),'s']),title('Beginning & End of Half Peak in Sup Layer')
        
        a=a+1;
    end
end

% ------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------
% ------------------------------------------------------------------------------------------------





