%AnalysisMarieStep1



load('LFPData/LFP11.mat')
%load('LFPData/LFP2.mat')
%load('LFPData/LFP9.mat')

tic,[t1,t2,t3,t,brst]=FindExtremPeaks(LFP,2,Epoch);toc

tused=t1;

lim=1;
[h,SpEpoch,brst]=ObsExtremPeaks(tused,lim);

            
SpRejected=[];
SpCorrected=[];
for i=1:length(Start(SpEpoch))
    valOsc=Data(Restrict(tused,subset(SpEpoch,i)));
    %length(find(valOsc<4))
    %     if length(find(valOsc>4))>length(find(valOsc<4))
    %     if length(find(valOsc<4))<2   
    if length(find(valOsc>6))>2        
        SpCorrected=[SpCorrected;[Start(subset(SpEpoch,i)) End(subset(SpEpoch,i))]]; 
    else
        SpRejected=[SpRejected;[Start(subset(SpEpoch,i)) End(subset(SpEpoch,i))]]; 
    end
end


[BE,id]=sort(SpCorrected(:,1));
SpCorrected=intervalSet(SpCorrected(id,1),SpCorrected(id,2));
SpCorrected=mergeCloseIntervals(SpCorrected,0.00001);


[BE,id]=sort(SpRejected(:,1));
SpRejected=intervalSet(SpRejected(id,1),SpRejected(id,2));
SpRejected=mergeCloseIntervals(SpRejected,0.00001);

(length(Start(SpEpoch))-length(Start(SpCorrected)))/length(Start(SpEpoch))*100

TotalEpoch=Epoch-SpEpoch;

%load('SpectrumDataL/Spectrum11.mat')
load('SpectrumDataL/Spectrum2.mat')
%load('SpectrumDataL/Spectrum5.mat')

Sptsd=tsd(t*1E4,Sp);

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

figure
subplot(2,1,1),
hold on, plot(f,mean(Data(Restrict(Sptsd,Epoch))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,TotalEpoch))),'k','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,SpEpoch))),'--','color',[0.7 0 0.7])
hold on, plot(f,mean(Data(Restrict(Sptsd,SpCorrected))),'r','linewidth',2)
hold on, plot(f,mean(Data(Restrict(Sptsd,SpRejected))),'b','linewidth',2)
subplot(2,1,2),

hold on, plot(f,10*log10(mean(Data(Restrict(Sptsd,Epoch)))),'--','color',[0.7 0.7 0.7])
hold on, plot(f,10*log10(mean(Data(Restrict(Sptsd,TotalEpoch)))),'k','linewidth',2)
hold on, plot(f,10*log10(mean(Data(Restrict(Sptsd,SpEpoch)))),'--','color',[0.7 0 0.7])
hold on, plot(f,10*log10(mean(Data(Restrict(Sptsd,SpCorrected)))),'r','linewidth',2)
hold on, plot(f,10*log10(mean(Data(Restrict(Sptsd,SpRejected)))),'b','linewidth',2)

%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------

