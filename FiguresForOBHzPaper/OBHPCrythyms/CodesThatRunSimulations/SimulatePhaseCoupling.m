function [Index,IndexRand,IsSig,LFP1,LFP2,PhaseDiff]=SimulatePhaseCoupling(Options,DoStats)

% Options.smoofactfreq=1; % what timescale should frequency noise vary on
% Options.eps=5; % strength of coupling
% Options.n=1; % n:m coupling
% Options.m=1; % n:m coupling
% Options.dt=0.001; % time step for euler method, seconds
% Options.TMax=100; % duration of simulation, seconds
% Options.MeanFrq1=4*(2*pi); % Mean Freq for first oscillator
% Options.MeanFrq2=7*(2*pi); % Mean Freq for first oscillator
% Options.StdFrq1=4*(2*pi); % Std of freq for first oscillator
% Options.StdFrq2=7*(2*pi); % Std of freq for first oscillator
% Options.FreqRange1=[1:12;3:14]; % Frequencies to filter
% Options.FreqRange2=[1:12;3:14]; % Frequencies to filter
% Options.BinNum=80; % number of bins to establish historgram of phases
% Options.Shuffles=500; % number of shuffles of data points for
% significance testing
% Options.NMRatiosToTest=[1,1;1,1.5;1,2;1,3;1,4]; % different coupling
% ratios to test
% Options.alpha=0.01; significance level

dt=Options.dt;
TMax=Options.TMax;
m=Options.m;
n=Options.n;
eps=Options.eps;
smoofactfreq=Options.smoofactfreq;
FreqRange1=Options.FreqRange1;
FreqRange2=Options.FreqRange2;
BinNum=Options.BinNum;
Shuffles=Options.Shuffles;


Oscill.Phase{1}(1)=0;% initialize
Oscill.MeanFreq{1}=Options.MeanFrq1;
Oscill.StdFreq{1}=Options.StdFrq1;
temp=abs(randn(1,floor((TMax)/(dt*smoofactfreq))+1)*Oscill.StdFreq{1}+Oscill.MeanFreq{1});
Oscill.Freq{1}=interp1([dt:dt*smoofactfreq:TMax+dt*smoofactfreq],temp,[dt:dt:TMax]);

Oscill.Phase{2}(1)=0; % initialize
Oscill.MeanFreq{2}=Options.MeanFrq2;
Oscill.StdFreq{2}=Options.StdFrq2;
temp=abs(randn(1,floor((TMax)/(dt*smoofactfreq))+1)*Oscill.StdFreq{2}+Oscill.MeanFreq{2});
Oscill.Freq{2}=interp1([dt:dt*smoofactfreq:TMax+dt*smoofactfreq],temp,[dt:dt:TMax]);


for t=2:floor(TMax/dt)
    
    % apply euler method
    delPh= Oscill.Freq{1}(t-1)+eps*sin(n*Oscill.Phase{2}(t-1)-m*Oscill.Phase{1}(t-1));
    Oscill.Phase{1}(t)=Oscill.Phase{1}(t-1)+dt*delPh;
    
    delPh= Oscill.Freq{2}(t-1)+eps*sin(n*Oscill.Phase{1}(t-1)-m*Oscill.Phase{2}(t-1));
    Oscill.Phase{2}(t)=Oscill.Phase{2}(t-1)+dt*delPh;
    
end

LFP1=tsd([dt:dt:TMax]*1e4,sin(Oscill.Phase{1})');
LFP2=tsd([dt:dt:TMax]*1e4,sin(Oscill.Phase{2})');

if DoStats
    Smax=log(BinNum);
    for f=1:size(FreqRange1,2)
        disp(num2str(100*f/size(FreqRange1,2)))
        % filter LFP1 in a given range & get phase with Hilbert transform
        FilLFP1=FilterLFP(LFP1,FreqRange1(:,f),1024);
        Hil1=hilbert(Data(FilLFP1));
        Phase1=phase(Hil1);
        for ff=1:size(FreqRange2,2)
            % filter LFP2 in a given range & get phase with Hilbert transform
            FilLFP2=FilterLFP(LFP2,FreqRange2(:,ff),1024);
            Hil2=hilbert(Data(FilLFP2));
            Phase2=phase(Hil2);
            
            % Phase differences for a range of coupling parameters
            for nm=1:size(Options.NMRatiosToTest,1)
                PhaseDiff{f,ff,nm}=(mod(Options.NMRatiosToTest(nm,2)*Phase2-Options.NMRatiosToTest(nm,1)*Phase1,2*pi));
                [Y,X]=hist(PhaseDiff{f,ff,nm},BinNum);
                Y=Y/sum(Y);
                S=-sum(Y.*log(Y));
                Index.Shannon(f,ff,nm)=(Smax-S)/Smax;
                Index.VectStr(f,ff,nm)=sqrt(sum(cos(PhaseDiff{f,ff,nm})).^2+sum(sin(PhaseDiff{f,ff,nm}).^2))./length(PhaseDiff{f,ff,nm});
                for sh=1:Shuffles
                    snip=ceil(rand(1)*length(Phase1));
                    RandPhaseDiff=(mod(Phase2-Phase1([snip:length(Phase1),1:snip-1]),2*pi));
                    [Y,X]=hist(RandPhaseDiff,BinNum);
                    Y=Y/sum(Y);
                    S=-sum(Y.*log(Y));
                    IndexRand.Shannon{f,ff,nm}(sh)=(Smax-S)/Smax;
                    IndexRand.VectStr{f,ff,nm}(sh)=sqrt(sum(cos(RandPhaseDiff)).^2+sum(sin(RandPhaseDiff)).^2)./length(RandPhaseDiff);
                end
            end
        end
    end
    
    
    % Look at significance
    for f=1:size(FreqRange1,2)
        for ff=1:size(FreqRange2,2)
            for nm=1:size(Options.NMRatiosToTest,1)
                IsSig.Shannon(f,ff,nm)=Index.Shannon(f,ff,nm)>prctile(IndexRand.Shannon{f,ff,nm},100-Options.alpha*100);
                IsSig.VectStr(f,ff,nm)=Index.VectStr(f,ff,nm)>prctile(IndexRand.VectStr{f,ff,nm},100-Options.alpha*100);
            end
        end
    end
    
else
    Index=[];
    IndexRand=[];
    IsSig=[];
    PhaseDiff=[];
end
end
