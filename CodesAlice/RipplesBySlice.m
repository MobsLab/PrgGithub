function [NumRipBySlice,SliceDur]=RipplesBySlice(Riptsd,Epoch,LimEpSize)

% LimEpSize : desired slice duration

count1=1;

%Spectra of Epoch in slices
if not(isempty(Start(Epoch)))
    if sum(Stop(Epoch)-Start(Epoch))>LimEpSize*1e4
        for s=1:length(Start(Epoch))
            dur=(Stop(subset(Epoch,s))-Start(subset(Epoch,s)));
            Str=Start(subset(Epoch,s));
            if  dur<LimEpSize*1.5*1e4 & dur>LimEpSize*0.75*1e4
                NumRipBySlice(count1,:)=length(Range(Restrict(Riptsd,subset(Epoch,s))));
                SliceDur(count1)=dur/1e4;
                count1=count1+1;
            else
                numbins=round(dur/(LimEpSize*1e4));
                epdur=dur/numbins;
                for nn=1:numbins
                    EpochInUse=intervalSet(Str+epdur*(nn-1),Str+epdur*(nn));
                    NumRipBySlice(count1,:)=length(Range(Restrict(Riptsd,EpochInUse)));
                    SliceDur(count1)=epdur/1e4;
                    count1=count1+1;
                end
                
            end
        end
    else
        NumRipBySlice=NaN;
        SliceDur=NaN;
    end
else
    NumRipBySlice=NaN;
    SliceDur=NaN;
end

end