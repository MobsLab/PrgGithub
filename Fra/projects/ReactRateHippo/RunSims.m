function RunSims

%ehs = 0.04:0.02:0.08;
ehs = 0.3;
ReactRateNetworkSim2('Hopfield', 0)

for i = 1:length(ehs)
    
    %ReactRateNetworkSim2('SynEnhance', ehs(i))
    ReactRateNetworkSim2('ExcEnhance', ehs(i))
end

