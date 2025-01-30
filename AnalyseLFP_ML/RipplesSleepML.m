% RipplesSleepML

%cd('C:\Users\Noname\Desktop\Marie\Data\ICSS-Mouse-29-03022012')
%cd('C:\Users\Noname\Desktop\Marie\Data\ICSS-Mouse-26-10112011')
cell=0;

load behavResources
load LFPData
if cell
    load SpikeData S cellnames;
end

try
    load GoodEpoch
    SWSEpoch;
    REMEpoch;
%     WakeEpoch;
    thetaPeriod;
catch
    error('Missing file from sleep scoring'); 
end
SleepEpoch=or(SWSEpoch,REMEpoch);

try
    num;
catch
    num=input('Enter LFP channel to analyse: ');
end
channel=num;



%%
%     
%     %--------------------------------------------------------------------------
%     % find theta epochs
%     %--------------------------------------------------------------------------
% 
%     pasTheta=100;
% 
%     FilTheta=FilterLFP(Restrict(LFP{num},SleepEpoch),[5 10],1024);
%     FilDelta=FilterLFP(Restrict(LFP{num},SleepEpoch),[3 6],1024);
% 
%     HilTheta=hilbert(Data(FilTheta));
%     HilDelta=hilbert(Data(FilDelta));
% 
%     ThetaRatio=abs(HilTheta)./abs(HilDelta);
%     rgThetaRatio=Range(FilTheta,'s');
% 
%     ThetaRatio=SmoothDec(ThetaRatio(1:pasTheta:end),50);
%     rgThetaRatio=rgThetaRatio(1:pasTheta:end);
% 
%     plot(rgThetaRatio,ThetaRatio,'k','linewidth',2)
% 
%     ThetaRatioTSD=tsd(rgThetaRatio*1E4,ThetaRatio);
% 
%     thetaPeriod=thresholdIntervals(ThetaRatioTSD,2.5,'Direction','Above');
%     thetaPeriod=mergeCloseIntervals(thetaPeriod,10*1E4);
%     thetaPeriod=dropShortIntervals(thetaPeriod,20*1E4);

%     % hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)
%     % hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')],[0 30],'color','b','linewidth',4)
% 
%     hold on, line([Start(thetaPeriod,'s') Start(thetaPeriod,'s')]',(ones(size(Start(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)
%     hold on, line([End(thetaPeriod,'s') End(thetaPeriod,'s')]',(ones(size(End(thetaPeriod,'s'),1),1)*[0 30])','color','b','linewidth',4)

%     
%     SWSEpoch=SleepEpoch-thetaPeriod;
%     REMEpoch=and(SleepEpoch,thetaPeriod);

%%
    
    DurationSWS= sum(End((SWSEpoch),'s')-Start((SWSEpoch),'s'));
    DurationREM=sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
    DurationPeriod=sum(End(SleepEpoch,'s')-Start(SleepEpoch,'s'));
    RatioREMSWS=DurationREM/DurationSWS*100;
    
%     %--- ?
%     params.Fs=1250;
%     params.trialave=0;
%     params.err=[1 0.0500];
%     params.pad=2;
%     params.fpass=[0 30];
%     movingwin=[3 0.2];
%     params.tapers=[3 5]; %params.tapers=[1 2];
%     [Sp,t,f]=mtspecgramc(Data(Restrict(LFP{num},SleepEpoch)),movingwin,params);
% 
    ste=Start(SleepEpoch);
    eee=End(SleepEpoch);
%     Stsd=tsd(t*1E4+ste(1),Sp);
%     
%     freq=f;
%     SpectrumSWS=mean(Data(Restrict(Stsd,SWSEpoch)));
%     SpectrumREM=mean(Data(Restrict(Stsd,thetaPeriod)));


 %------------   
 %------------
    disp(' ')
    disp(pwd)
    disp(' ')

    disp(['channel: ',num2str(floor(num))])
    disp(['Duration of recording: ',num2str(DurationPeriod), ' s'])
    disp(['Duration SWS: ',num2str(floor(DurationSWS)),' s'])
    disp(['Duration REM: ',num2str(floor(DurationREM)),' s'])
    disp(['Ratio REM/SWS: ' ,num2str(floor(DurationREM/DurationSWS*100*10)/10),' %'])

%%
    %--------------------------------------------------------------------------
    % find Ripples event
    %----------------------------------------------------------------------
    
    %hold on, plot(Range(Restrict(LFP{1},SleepEpoch),'s'),Data(Restrict(LFP{1},SleepEpoch)),'r')

    ParamRip=[3 5];
    %ParamRip=[4 7];

    Ripples=[];
    for i=1:length(ste)
        try
            FilRip=FilterLFP(Restrict(LFP{num},subset(SleepEpoch,i)),[130 250],96);
            filtered=[Range(FilRip,'s') Data(FilRip)];
            rgFil=Range(FilRip,'s');
            [ripples,stdev,noise] = FindRipples(filtered,'thresholds',ParamRip);
            if length(ripples)>1
                Ripples=[Ripples;ripples];
            end
        end
    end
try
    M=PlotRipRaw(LFP{num},Ripples,70);
end

        RIPtsd=tsd((Ripples(:,2))*1E4,Ripples);

        ripSWS=length(Range(Restrict(RIPtsd,SWSEpoch)));
        ripREM=length(Range(Restrict(RIPtsd,REMEpoch)));

    try
        M=PlotRipRaw(LFP{num},Data(Restrict(RIPtsd,thetaPeriod)),70);
    end

        ripplesEpoch=intervalSet((Ripples(:,1)-0.03)*1E4, (Ripples(:,3)+0.03)*1E4);
        ripplesEpoch=mergeCloseIntervals(ripplesEpoch,10);
        
NombreRipples=size(Ripples,1);
FreqIntactRipplesDuringSWS=ripSWS/DurationSWS;
FreqIntactRipplesDuringREM=ripREM/DurationREM;

%------------
%------------
disp(' ')
disp(' ')
disp(['Number of ripples during SWS: ',num2str(ripSWS)])
disp(['Number of ripples during REM: ',num2str(ripREM)])
disp(['Frequency of ripples during SWS: ',num2str(ripSWS/DurationSWS),' Hz'])
disp(['Frequency of ripples during REM: ',num2str(ripREM/DurationREM),' Hz'])


%%
if cell
%--------------------------------------------------------------------------
% Characteristics for each cell
%----------------------------------------------------------------------
partRipp=zeros(length(Start(ripplesEpoch)),length(cellnames));
 
for c=1:length(cellnames)
    ss=S{c};
    rg=Range(ss,'s');
    FreqFiring=length(ss)/max(rg(end),eee(1)*10^-4);    
    
    NombreSpikes=length(Restrict(ss,SleepEpoch));
    NbStimREM=length(Restrict(ss,REMEpoch));
    NbStimSWS=length(Restrict(ss,SWSEpoch));
    FreqStimTheta=NbStimREM/sum(End(REMEpoch,'s')-Start(REMEpoch,'s'));
    FreqStimSWS=NbStimSWS/sum(End(SWSEpoch,'s')-Start(SWSEpoch,'s'));

    %Nombre de spike qui tombent pendant une ripple
    NbSpikeRipples=length(Restrict(ss,ripplesEpoch));

    nbri=0;ripBurstiness=[];
    for kj=1:length(Start(ripplesEpoch))
        
        if length(Restrict(ss,subset(ripplesEpoch,kj)))>=1
            nbri=nbri+1;
            ripBurstiness=[ripBurstiness,length(Restrict(ss,subset(ripplesEpoch,kj)))];
            partRipp(kj,c)=1;
        end
    end

    %Nombre de Ripples qui contienne le spike de cette cellule
    NbRipplesWithSpikes=nbri;

    % Pourcentage de Ripples contenant un spike de cette cellule
    PercRipSpike=floor(10*NbRipplesWithSpikes/NombreRipples*100)/10;

    % Pourcentage de Spike tombant dans une ripple
    PercStimRipples=floor(10*NbSpikeRipples/NombreSpikes*100)/10;

    nbStimulationREM=length(Restrict(ss,and(GoodEpoch,thetaPeriod)));
    nbStimulationSWS=length(Restrict(ss,(GoodEpoch-thetaPeriod)));

    OccurenceBefore=length(Range(Restrict(ss,intervalSet(0,ste(1)))));
    FreqBefore=OccurenceBefore/ste(1)*1E4;
    
 %------------
 %------------
    disp(' ')
    disp(' ')
    disp(['Neuron ',num2str(cellnames{c})]);
    disp(['Neuron frequency : ',num2str(FreqFiring),' Hz']);

    disp(' ')
    disp(['Number of spike during SleepEpoch: ',num2str(NombreSpikes)])
    disp(['Number of spike during REM/theta : ',num2str(NbStimREM)])
    disp(['Number of spike during SWS : ',num2str(NbStimSWS)])
    disp(['Firing frequency during REM/theta : ',num2str(FreqStimTheta),' Hz'])
    disp(['Firing frequency during SWS : ',num2str(FreqStimSWS),' Hz'])
    disp(['Occurence before: ',num2str(OccurenceBefore)])
    disp(['Frequence before: ',num2str(FreqBefore)])
    
    disp(' ')
    disp(['Nb spike during ripples: ',num2str(NbSpikeRipples)]) 
    disp(['Nb ripples with spikes: ',num2str(NbRipplesWithSpikes)])
    disp(['Percentage of (sleepEpoch) spikes during ripples : ',num2str(PercStimRipples),' %'])
    disp(['Percentage of ripples with spikes: ',num2str(PercRipSpike),' %'])
    disp(['Mean (max min) number of spike per ripple :',num2str(mean(ripBurstiness)),' (',num2str(max(ripBurstiness)),' ',num2str(min(ripBurstiness)),')'])

Res(1,c)=num ;
Res(2,c)=c ;

Res(3,c)=DurationPeriod;
Res(4,c)=DurationSWS;
Res(5,c)=DurationREM;
Res(6,c)=floor(DurationREM/DurationSWS*100*10)/10;
Res(7,c)=ripSWS;
Res(8,c)=ripREM;
Res(9,c)=ripSWS/DurationSWS;
Res(10,c)=ripREM/DurationREM;
Res(11,c)=mean(ripBurstiness) ;
Res(12,c)=NombreSpikes; 
Res(13,c)=NbStimREM ;
Res(14,c)=NbStimSWS  ;
Res(15,c)=FreqStimTheta;  
Res(16,c)=FreqStimSWS ;
Res(17,c)=PercStimRipples ;
Res(18,c)=NbSpikeRipples ;
Res(19,c)=NbRipplesWithSpikes ;
Res(20,c)=OccurenceBefore;
Res(21,c)=FreqBefore;
Res(22,c)=NombreRipples;

    
    
    
    %%------------ PLOT ------------

%     bu=Range(Restrict(ss,SleepEpoch));
% 
%     figure('color',[1 1 1]),
%     subplot(2,1,1),imagesc(Range(Restrict(Stsd,thetaPeriod),'s'),f,10*log10(Data(Restrict(Stsd,thetaPeriod))')), axis xy
%     subplot(2,1,2),imagesc(Range(Restrict(Stsd,SWSEpoch),'s'),f,10*log10(Data(Restrict(Stsd,SWSEpoch))')), axis xy
% 
%     figure('color',[1 1 1]),
%     subplot(2,2,1), plot(f,10*log10(mean(Data(Restrict(Stsd,thetaPeriod)))),'k','linewidth',1), title('REM'), xlabel('Frequency (Hz)'), ylabel('Power')
%     subplot(2,2,2),
%     plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,thetaPeriod)))),'k','linewidth',1), title('REM'), xlabel('Frequency (log scale)'), ylabel('Power (log scale)')
%     xlim([-5 10*log10(30)])
%     subplot(2,2,3), plot(f,10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'k','linewidth',1), title('SWS'), xlabel('Frequency (Hz)'), ylabel('Power')
%     subplot(2,2,4),
%     plot(10*log10(f),10*log10(mean(Data(Restrict(Stsd,SWSEpoch)))),'k','linewidth',1), title('SWS'), xlabel('Frequency (log scale)'), ylabel('Power (log scale)')
%     xlim([-5 10*log10(30)])
%     
%     
%     
    


end


%%
% 
%         eval(['save ResAnalysisSPWRStimCtrl',num2str(c),' channel DurationSWS DurationREM RatioREMSWS NbStimREM NbStimSWS  FreqStimTheta  FreqStimSWS PercStimRiplpes NbIntactRipplesOutsideStim NbIntactRipplesDuringSWS NbIntactRipplesDuringREM FreqIntactRipplesDuringSWS FreqIntactRipplesDuringREM NbRipplesCorrectedDuringSWS NbRipplesCorrectedDuringREM FreqRipplesCorrectedDuringSWS FreqRipplesCorrectedDuringREM freq SpectrumSWS SpectrumREM NbSpikeRipples NombreRipples NombreSpikes DurationPeriod NbRipplesWithSpikes Thr OccurenceBefore FreqBefore'])
%         eval(['save ResAnalysisSPWRStimCtrl channel DurationSWS DurationREM RatioREMSWS NbStimREM NbStimSWS  FreqStimTheta  FreqStimSWS PercStimRiplpes NbIntactRipplesOutsideStim NbIntactRipplesDuringSWS NbIntactRipplesDuringREM FreqIntactRipplesDuringSWS FreqIntactRipplesDuringREM NbRipplesCorrectedDuringSWS NbRipplesCorrectedDuringREM FreqRipplesCorrectedDuringSWS FreqRipplesCorrectedDuringREM freq SpectrumSWS SpectrumREM NbSpikeRipples NombreRipples NombreSpikes DurationPeriod NbRipplesWithSpikes Thr OccurenceBefore FreqBefore'])


close all

Ti{1}='num' ;
Ti{2}='c';

Ti{3}='DurationPeriod';
Ti{4}='DurationSWS';
Ti{5}='DurationREM';
Ti{6}='floor(DurationREM/DurationSWS*100*10)/10';
Ti{7}='ripSWS';
Ti{8}='ripREM';
Ti{9}='ripSWS/DurationSWS';
Ti{10}='ripREM/DurationREM';
Ti{11}='ripBurstiness' ;
Ti{12}='NombreSpikes SleepEpoch'; 
Ti{13}='NbStimREM' ;
Ti{14}='NbStimSWS'  ;
Ti{15}='FreqStimTheta';  
Ti{16}='FreqStimSWS' ;
Ti{17}='PercStimRipples' ;
Ti{18}='NbSpikeRipples' ;
Ti{19}='NbRipplesWithSpikes' ;
Ti{20}='OccurenceBefore';
Ti{21}='FreqBefore';
Ti{22}='NombreRipples';

save ResAnalysisSPWRStimCtrl Res Ti partRipp


if 1
    RipplesSleepMLsuite(Res,Ti,partRipp)
end
end