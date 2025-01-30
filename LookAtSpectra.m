function LookAtSpectra(Epoch,LFP,titstr)
params.Fs=1/median(diff(Range(LFP,'s')));
params.err=[1 0.0500];
params.pad=2;
params.trialave=0;
figure
for g=1:3
    
 if g==1
        params.fpass=[0 200];
        params.tapers=[10 19];
    elseif g==2
        params.fpass=[0 20];
        params.tapers= [3 5];
    else
        params.fpass=[50 200];
        params.tapers= [6 8];
 end
    
 
clear Freq
Sp=[];
for k=1:length(Start(Epoch))
    try
    Ep=subset(Epoch,k);
    dat=Data(Restrict(LFP,Ep));
    [S,f]=mtspectrumc(dat,params);
    try
        Freq;
    catch
        Freq=f;
    end
    Stsd=tsd(f,S);
    S2=Restrict(Stsd,ts(Freq(1:10:end)));
    Sp=[Sp;Data(S2)'];
    end
end
subplot(2,3,g)
plot(Freq(1:10:end),10*log10(nanmean(Sp)),'b','linewidth',2)
shadedErrorBar(Freq(1:10:end),10*log10(nanmean(Sp)),stdError(10*log10(Sp)),'-b');
if g==1
    ylabel('log10 plot')
end
if g==2
  try
    title(titstr) 
  end
end
subplot(2,3,g+3)
plot(Freq(1:10:end),Freq(1:10:end).*nanmean(Sp),'b','linewidth',2)
shadedErrorBar(Freq(1:10:end),Freq(1:10:end).*nanmean(Sp),Freq(1:10:end).*stdError((Sp)),'-b');
if g==1
    ylabel('whitened plot')
end
end

end