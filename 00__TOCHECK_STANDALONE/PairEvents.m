function [paired,unpaired]=PairEvents(ev1,ev2,lag)
%ev and lag should be in right time units!
paired=[];
unpaired=[];
for i=1:length(ev1)
tdiff=abs(ev1(i)-ev2);
a=find(tdiff<lag);
if size(a,1)>0
    paired=[paired,ev1(i)];
else
        unpaired=[unpaired,ev1(i)];
end

end