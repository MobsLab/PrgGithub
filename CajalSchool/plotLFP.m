function plotLFP(LFP,voies,plo)

try
    plo;
catch
    plo=1
end

if plo
figure
end
tps=Range(LFP{1},'s');

sp=std(Data(LFP{1}));
for i=1:length(voie)
    plot(tps-tps(1),(i-1)*sp*500+Data(LFP{voie(i)}),'k')
end








