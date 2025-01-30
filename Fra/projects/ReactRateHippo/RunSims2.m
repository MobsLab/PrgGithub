function RunSims

ehs = 0.1:0.1:0.5;
%ReactRateNetworkSim2('Hopfield', 0)

for i = 1:length(ehs)
    
    ReactRateNetworkSim2('SynEnhance', ehs(i))
    ReactRateNetworkSim2('ExcEnhance', ehs(i))
end

