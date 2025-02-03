function ripples=ObsRipples(LFP, voieLFP,paramRip,voieLFPNoise)

try
    voieLFPNoise;
catch
    voieLFPNoise=0;
end


if voieLFPNoise>0
    

    NoiseRip=FilterLFP(LFP{voieLFPNoise},[130 200],96);
    rgFilNoise=Range(NoiseRip,'s');
    filteredNoise=[rgFilNoise-rgFilNoise(1) Data(NoiseRip)];
    
    FilRip=FilterLFP(LFP{voieLFP},[130 200],96);
    rgFil=Range(FilRip,'s');
    filtered=[rgFil-rgFil(1) Data(FilRip)];
    
    %filtered=[Range(FilRip,'s') Data(FilRip)];
    
    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'noise',filteredNoise,'show','off');
    
    [maps,data,stats] = RippleStats(filtered,ripples);
    PlotRippleStats(ripples,maps,data,stats)

    %SeeRipples(LFP,voieLFP,Epoch,voieLFPNoise)


else
    FilRip=FilterLFP(LFP{voieLFP},[130 200],96);
    
    rgFil=Range(FilRip,'s');
    filtered=[rgFil-rgFil(1) Data(FilRip)];
    
    
    %filtered=[Range(FilRip,'s') Data(FilRip)];
    
    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip);
    
%    [ripples,stdev,noise] = FindRipples(filtered,'thresholds',paramRip,'stdev',300);
    
    [maps,data,stats] = RippleStats(filtered,ripples);
    PlotRippleStats(ripples,maps,data,stats)
    %SeeRipples(LFP,voieLFP,Epoch,voieLFP)

end



