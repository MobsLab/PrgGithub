function [P,f,VBinnedPhase]=PrefPhaseSpectrum(LFP,Sp,t,f,freq,N)

% Stsd=tsd(OBhigh_CNO{k}.Spectro{2}*1E4, OBhigh_CNO{k}.Spectro{1});
% f=OBhigh_CNO{k}.Spectro{3};
% SgnFiltre0=FilterLFP(LFP_OB{1},[1 3],1024);

try
    N;
catch
    N=30;
end

Stsd=tsd(t*1E4,Sp);
SgnFiltre0=FilterLFP(LFP,freq,1024);

PhaseTheta=angle(hilbert(Data(SgnFiltre0)))*180/pi+180;
% N=30;
interval=360/N;
BinnedPhase=floor(PhaseTheta/interval)+1;
VBinnedPhase=[interval/2:interval:360-interval/2];

for i=1:N
    EpochA=thresholdIntervals(tsd(Range(SgnFiltre0),PhaseTheta),VBinnedPhase(i)-interval/2,'Direction','Above');
    EpochB=thresholdIntervals(tsd(Range(SgnFiltre0),PhaseTheta),VBinnedPhase(i)+interval/2,'Direction','Below');
    P(i,:)=mean(Data(Restrict(Stsd,and(EpochA,EpochB))));
end

figure, 
subplot(131), plot(f,P'), title(['freq: ',num2str(freq(1)),', ',num2str(freq(2)),' Hz'])
subplot(132), imagesc(VBinnedPhase,f,P'), axis xy
subplot(133), contourf(VBinnedPhase,f,P','linestyle','none'), axis xy
