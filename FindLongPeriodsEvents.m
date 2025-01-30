function LongPeriods=FindLongPeriodsEvents(EventsTs,lim)

% EventTs ts ou vector in 0.1ms (same timing as in ts or tsd
% lim time in sec


try
    lim;
catch
    lim=60;
end

% 
% try
% EventsTs=Range(EventsTs);
% end

int=diff(EventsTs/1E4);
id=find(int>lim);
try
LongPeriods=intervalSet(EventsTs([1;id(1:end)+1]),EventsTs([id;length(EventsTs)]));
catch
    EventsTs=EventsTs';
 LongPeriods=intervalSet(EventsTs([1;id(1:end)+1]),EventsTs([id;length(EventsTs)]));   
end



