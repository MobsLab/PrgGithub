function plotLFP(LFPs,voies,sp,plo)

try
    plo;
catch
    plo=1;
end
try
    sp;
catch
    sp=1000;
end

if plo
figure
end
tps=Range(LFPs{1},'s');
for i=1:length(voies)
    try
    hold on, plot(tps-tps(1),(i-1)*sp+Data(LFPs{voies(i)}),'k')
    end
end








