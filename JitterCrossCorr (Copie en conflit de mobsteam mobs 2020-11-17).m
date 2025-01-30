function [Cn,B,mod,C1,C2]=JitterCrossCorr(tpsref,Spk,nbrand,jit,param1,param2,smo)


jit=jit*10;

try
    smo;
    catch
    smo=[];
end

r=Range(tpsref);
s=Range(Spk);

[C1,B]=CrossCorr(r,s,param1,param2);  

for a=1:nbrand
    [C2(a,:),B]=CrossCorr(r+rand(length(r),1)*jit*2-jit,s,param1,param2);  
end
Cn=(C1-mean(C2))/std(C2);
mod=sqrt(sum(Cn.*Cn));

if ~isempty(smo)
figure, hold on
plot(B/1E3,runmean(mean(C2),smo),'r','linewidth',2),
plot(B/1E3,runmean(mean(C2)+std(C2),smo),'r')
plot(B/1E3,runmean(mean(C2)-std(C2),smo),'r')
plot(B/1E3,runmean(C1,smo),'k','linewidth',2)
yl=ylim;
line([0 0],yl,'color',[0.7 0.7 0.7])
title(num2str(mod))
end



