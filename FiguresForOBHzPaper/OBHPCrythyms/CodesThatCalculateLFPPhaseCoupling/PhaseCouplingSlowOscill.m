function [Index,IndexRand,Phase]=PhaseCouplingSlowOscill(Sig1,Sig2,FreqRange,Epoch,DoStats,DoFig)

%Sig1, Sig2 : LFP signals, can be whitened if you want
% Ex: FreqRange =
%
%      1     3     5     7     9    11    13    15
%      2     4     6     8    10    12    14    16
% Epoch : Epoch to use for calculations
% DoFig is 1 if you want a figure
% DoStats is > 1 if you want to shuffle data and do the bootstrap,
% indicates number of perumatations to do
NumBins=80;
Smax=log(NumBins);
Signal{1}=Sig1; Signal{2}=Sig2;

% Step one : for each mini-epoch filter in freq ranges, get instantaneous phase with Hilbert
for p=1:length(Start(Epoch))
%     disp([num2str(100*p/length(Start(Epoch))),'% done'])
    LitEpoch=subset(Epoch,p);
    for f=1:size(FreqRange,2)
        for s=1:2
            tempFil=FilterLFP(Restrict(Signal{s},LitEpoch),FreqRange(:,f),1024);
            Hil=hilbert(Data(tempFil));
            Phase{s}{p,f}=phase(Hil);
        end
    end
end

% Step two : put all these epochs together and look at distribution of
% phases, claculate synchronization index
if DoFig
    fig1=figure('units','normalized','outerposition',[0 0 1 1]);
    ha = tight_subplot(size(FreqRange,2),size(FreqRange,2),[.01 .01],[.01 .01],[.01 .01]);
end

for f=1:size(FreqRange,2)
%     disp([num2str(100*f/size(FreqRange,2)),'% done'])
    for ff=1:size(FreqRange,2)
        AllPhaseDiff=[];
        for p=1:length(Start(Epoch))
            AllPhaseDiff=[AllPhaseDiff;(mod(Phase{1}{p,f}-Phase{2}{p,ff},2*pi))];
        end
        if DoFig
            [Y1,X1]=hist(AllPhaseDiff,NumBins);
            Y1=Y1/sum(Y1);
        else
            [Y1,X1]=hist(AllPhaseDiff,NumBins);
            Y1=Y1/sum(Y1);
        end
        S=-sum(Y1.*log(Y1));
        Index.Shannon(f,ff)=(Smax-S)/Smax;
        Index.VectLength(f,ff)=sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
        
        if DoStats>0
            for sh=1:DoStats
                
                AllPhaseDiff=[];
                for p=1:length(Start(Epoch))
                    snip=ceil(rand(1)*length(Phase{1}{p,f}));
                    temp1=[Phase{1}{p,f}(snip:end);Phase{1}{p,f}(1:snip-1)];
                    snip=ceil(rand(1)*length(Phase{2}{p,f}));
                    temp2=[Phase{2}{p,f}(snip:end);Phase{2}{p,f}(1:snip-1)];
                    AllPhaseDiff=[AllPhaseDiff,(mod(temp1-temp2,2*pi))'];
                end
                
                [Y,X]=hist(AllPhaseDiff,NumBins);
                Y=Y/sum(Y);
                S=-sum(Y.*log(Y));
                IndexRand.Shannon{f,ff}(sh)=(Smax-S)/Smax;
                IndexRand.VectLength{f,ff}(sh)=sqrt(sum(cos(AllPhaseDiff)).^2+sum(sin(AllPhaseDiff)).^2)/length(AllPhaseDiff);
                if DoFig
%                     axes(ha((ff-1)*size(FreqRange,2)+f))
                    plot(X,Y,'color',[0.6 0.6 0.6]),hold on
                end
            end
        end
        
        if DoFig
            bar(X1,Y1), hold on
            xlim([0 2*pi])
            set(gca,'XTick',[])
            set(gca,'YTick',[])
        end
    end
end


if   DoStats>1
    FinalSig.Shannon=zeros(size(FreqRange,2),size(FreqRange,2));
    FinalSig.VectLength=zeros(size(FreqRange,2),size(FreqRange,2));
    
    for f=1:size(FreqRange,2)
        for ff=1:size(FreqRange,2)
            Perc95=prctile(IndexRand.Shannon{f,ff},99);
            if Index.Shannon(f,ff)>Perc95
                FinalSig.Shannon(f,ff)=Index.Shannon(f,ff);
            end
            Perc95=prctile(IndexRand.VectLength{f,ff},99);
            if Index.VectLength(f,ff)>Perc95
                FinalSig.VectLength(f,ff)=Index.VectLength(f,ff);
            end
        end
    end
end




end