function [close,far]=CloseEvents(ev1,ev2)
%ev and lag should be in right time units!
close=[];
far=[];
for i=1:length(ev1)
    tdiff(i)=min(abs(ev1(i)-ev2));
end
lag=median(tdiff);

for i=1:length(ev1)
    a=find(tdiff(i)<lag);
    if size(a,1)>0
        close=[close,ev1(i)];
    else
        far=[far,ev1(i)];
    end
end

end