function [FR,FRt,dur,durT]=FiringRateEpoch(S,Epoch)

[dur,durT]=DurationEpoch(Epoch);

for i=1:length(Start(Epoch))
    FR(i)=length(Range(Restrict(S,subset(Epoch,i))))/(dur(i)/1E4);
end
FRt=length(Range(Restrict(S,Epoch)))/(durT/1E4);



