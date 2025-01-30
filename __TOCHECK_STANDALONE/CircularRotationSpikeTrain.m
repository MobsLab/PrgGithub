function [Sc,delc]=CircularRotationSpikeTrain(S,del)


for i=1:length(S)
spk{i}=Range(S{i});
lim(i)=spk{i}(end);
end
ma=max(lim);


for i=1:length(S)
    delc(i)=rand(1)*del*2;
    spk{i}=mod(spk{i}+delc(i)*1E4,ma);
    Sc{i}=tsd(sort(spk{i}),ones(length(spk{i}),1));
end

Sc=tsdArray(Sc);
