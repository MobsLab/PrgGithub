function id=dropLongIntervals(Epoch,th)

for i=1:length(Start(Epoch))    
    dur(i)=End(subset(Epoch,i))-Start(subset(Epoch,i));
end

id=find(dur<th);

