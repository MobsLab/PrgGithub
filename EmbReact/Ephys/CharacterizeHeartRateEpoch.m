function [HRInfo,HRSliceBySlice,SliceDur]=CharacterizeHeartRateEpoch(EKG,Epoch,LimEpSize)
%LimEpSize in s


if sum(Stop(Epoch)-Start(Epoch))>LimEpSize*1e4 & not(isempty(EKG))
    AllHB=diff(Range(EKG.HBTimes,'s'));AllHB(AllHB>0.2)=NaN;
    tps=Range(EKG.HBTimes);
    EKG.AllHB=tsd(tps(1:end-1),AllHB);
    count1=1;

    %OveralInfo
    HRInfo.MeanHR=nanmean(Data(Restrict(EKG.HBRate,Epoch)));
    HRInfo.StdHR=nanstd(Data(Restrict(EKG.HBRate,Epoch)));
    HRInfo.StdInterHB=nanstd(Data(Restrict(EKG.AllHB,Epoch)));
    
    %Individual Spectra
    if not(isempty(Start(Epoch)))
        if sum(Stop(Epoch)-Start(Epoch))>LimEpSize*1e4
            for s=1:length(Start(Epoch))
                dur=(Stop(subset(Epoch,s))-Start(subset(Epoch,s)));
                Str=Start(subset(Epoch,s));
                if  dur<LimEpSize*1.5*1e4 & dur>LimEpSize*0.75*1e4
                    HRSliceBySlice.MeanHR(count1)=nanmean(Data(Restrict(EKG.HBRate,subset(Epoch,s))));
                    HRSliceBySlice.StdHR(count1)=nanstd(Data(Restrict(EKG.HBRate,subset(Epoch,s))));
                    HRSliceBySlice.StdInterHB(count1)=nanstd(Data(Restrict(EKG.AllHB,subset(Epoch,s))));
                    SliceDur(count1)=dur/1e4;
                    count1=count1+1;
                else
                    numbins=round(dur/(LimEpSize*1e4));
                    epdur=dur/numbins;
                    for nn=1:numbins
                        EpochInUse=intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                        HRSliceBySlice.MeanHR(count1)=nanmean(Data(Restrict(EKG.HBRate,EpochInUse)));
                        HRSliceBySlice.StdHR(count1)=nanstd(Data(Restrict(EKG.HBRate,EpochInUse)));
                        HRSliceBySlice.StdInterHB(count1)=nanstd(Data(Restrict(EKG.AllHB,EpochInUse)));
                        SliceDur(count1)=dur/1e4;
                        count1=count1+1;
                    end
                end
            end
        end
    end
    
else
    HRInfo.MeanHR=NaN;
    HRInfo.StdHR=NaN;
    HRInfo.StdInterHB=NaN;
    HRSliceBySlice.MeanHR=NaN;
    HRSliceBySlice.StdHR=NaN;
    HRSliceBySlice.StdInterHB=NaN;
    SliceDur=NaN;
end

