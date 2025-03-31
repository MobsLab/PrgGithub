


function MeanLatency=Get_Latency_BM(Epoch)

SZ_entries = Start(Epoch);

% if convertCharsToStrings(session)=='TestPost'
    
    Latency{1} = SZ_entries(min(find(and(SZ_entries>0 , SZ_entries<1.8e6))));
    Latency{2} = SZ_entries(min(find(and(SZ_entries>1.8e6 , SZ_entries<3.6e6))))-1.8e6;
    Latency{3} = SZ_entries(min(find(and(SZ_entries>3.6e6 , SZ_entries<5.4e6))))-3.6e6;
    Latency{4} = SZ_entries(min(find(and(SZ_entries>5.4e6 , SZ_entries<7.2e6))))-5.4e6;
    
    MeanLatency=[];
    for i=1:length(Latency)
        if ~isempty(Latency{i})
            MeanLatency=[MeanLatency Latency{i}];
        end
    end
    MeanLatency = mean(MeanLatency);
    
% elseif convertCharsToStrings(session)=='Ext'
    
    
end



