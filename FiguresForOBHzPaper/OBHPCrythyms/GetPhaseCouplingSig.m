function FinalSig=GetPhaseCouplingSig(Index,IndexRand,FreqRange)
FinalSig.Shannon=zeros(size(FreqRange,2),1);
FinalSig.VectLength=zeros(size(FreqRange,2),1);

for f=1:size(FreqRange,2)
        Perc95=prctile(IndexRand.Shannon{f},99.9);
        if Index.Shannon(f)>Perc95
            FinalSig.Shannon(f)=Index.Shannon(f);
        end
        Perc95=prctile(IndexRand.VectLength{f},99.9);
        if Index.VectLength(f)>Perc95
            FinalSig.VectLength(f)=Index.VectLength(f);
        end
end
end