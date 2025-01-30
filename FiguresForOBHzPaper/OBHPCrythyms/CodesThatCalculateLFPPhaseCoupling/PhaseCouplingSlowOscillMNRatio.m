function [Index,IndexRand,FinalSig]=PhaseCouplingSlowOscillMNRatio(Sig1,Sig2,Epoch,DoStats,DoFig,MNRatio)

%Sig1, Sig2 : LFP filtered signals in the correct band
% If you want to directly supply the two sets of filtered LFPs, but them in
% Sig1 and leave Sig2 empty
% Ex: FreqRange =
%
%      1     3     5     7     9    11    13    15
%      2     4     6     8    10    12    14    16
% Epoch : Epoch to use for calculations
% DoFig is 1 if you want a figure
% DoStats is > 1 if you want to shuffle data and do the bootstrap,
% indicates number of perumatations to do
% MNRatio=[A1,B1;A2,B2] : ratio of phase coupling Si1 will be multiplied by
% A1 and Sig2 by B1 then A2, B2 etc. Don't forget 1:1

NumBins=80;
Smax=log(NumBins);
Signal{1}=Sig1; Signal{2}=Sig2;
% Step one : for each mini-epoch filter in freq ranges, get instantaneous phase with Hilbert
for p=1:length(Start(Epoch))
    LitEpoch=subset(Epoch,p);
    for s=1:2
        Hil=hilbert(Data(Restrict(Signal{s},subset(Epoch,p))));
        Phase{s}{p}=phase(Hil);
    end
end

% Step two : put all these epochs together and look at distribution of
% phases, claculate synchronization index

for mn=1:length(MNRatio)
    AllPhaseDiff=[];
    for p=1:length(Start(Epoch))
        AllPhaseDiff=[AllPhaseDiff;(mod(MNRatio(mn,1).*Phase{1}{p}-MNRatio(mn,2).*Phase{2}{p},2*pi))];
    end
    [Y1,X1]=hist(AllPhaseDiff,NumBins);
    Y1=Y1/sum(Y1);

    S=-sum(Y1.*log(Y1));
    Index.Shannon(mn)=(Smax-S)/Smax;
    Index.VectLength(mn)=sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
    
    if DoStats>0
        for sh=1:DoStats
            AllPhaseDiff=[];
            for p=1:length(Start(Epoch))
                snip=ceil(rand(1)*length(Phase{1}{p}));
                temp1=[Phase{1}{p}(snip:end);Phase{1}{p}(1:snip-1)];
                snip=ceil(rand(1)*length(Phase{2}{p}));
                temp2=[Phase{2}{p}(snip:end);Phase{2}{p}(1:snip-1)];
                AllPhaseDiff=[AllPhaseDiff,(mod(temp1-temp2,2*pi))'];
            end
            
            [Y,X]=hist(AllPhaseDiff,NumBins);
            Y=Y/sum(Y);
            S=-sum(Y.*log(Y));
            IndexRand.Shannon(mn,sh)=(Smax-S)/Smax;
            IndexRand.VectLength(mn,sh)=sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
            
        end
    end
end


FinalSig.Shannon=zeros(length(MNRatio),1);
FinalSig.VectLength=zeros(length(MNRatio),1);

if   DoStats>1
    
    for mn=1:length(MNRatio)
        Perc95=prctile(IndexRand.Shannon(mn,:),99);
        if Index.Shannon(mn)>Perc95
            FinalSig.Shannon(mn)=Index.Shannon(mn);
        end
        Perc95=prctile(IndexRand.VectLength(mn,:),99);
        if Index.VectLength(mn)>Perc95
            FinalSig.VectLength(mn)=Index.VectLength(mn);
        end
    end
    
end



end