

function Power_Distributions_Channels_BM(Chan)


load('SleepScoring_OBGamma.mat','Wake','SWSEpoch','REMEpoch','Epoch')

i=0;
for channel=Chan % OB channels of the ferret
    i=i+1;
    
    load(['LFPData/LFP' num2str(channel) '.mat']);
    LFP_Chan{i} = Restrict(LFP , Epoch);
    
    Fil = FilterLFP(LFP_Chan{i},[40 60],1024);
    Enveloppe = tsd(Range(LFP_Chan{i}), abs(hilbert(Data(Fil))) );
    SmoothGamma{i} = tsd(Range(Enveloppe), runmean(Data(Enveloppe), ...
        ceil(3/median(diff(Range(Enveloppe,'s'))))));
    
    Fil = FilterLFP(LFP_Chan{i},[2 6],1024);
    Enveloppe = tsd(Range(LFP_Chan{i}), abs(hilbert(Data(Fil))) );
    SmoothTheta{i} = tsd(Range(Enveloppe), runmean(Data(Enveloppe), ...
        ceil(3/median(diff(Range(Enveloppe,'s'))))));
    
    Fil = FilterLFP(LFP_Chan{i},[.1 .5],1024);
    Enveloppe = tsd(Range(LFP_Chan{i}), abs(hilbert(Data(Fil))) );
    SmoothUL{i} = tsd(Range(Enveloppe), runmean(Data(Enveloppe), ...
        ceil(3/median(diff(Range(Enveloppe,'s'))))));
    
end

figure
for i=1:length(Chan)
    subplot(3,length(Chan),i)
    [Y,X]=hist(log(Data(SmoothGamma{i})),1000);
    Y=Y/sum(Y);
    plot(X,Y)
    grid on
    xlim([3 7])
    
    subplot(3,length(Chan),i+length(Chan))
    [Y,X]=hist(log(Data(SmoothTheta{i})),1000);
    Y=Y/sum(Y);
    plot(X,Y)
    grid on
    xlim([3 7])
    
    subplot(3,length(Chan),i+length(Chan)*2)
    [Y,X]=hist(log(Data(SmoothUL{i})),1000);
    Y=Y/sum(Y);
    plot(X,Y)
    grid on
    xlim([1.5 6])
end


figure
for i=1:length(Chan)
    subplot(3,length(Chan),i)
    [Y,X]=hist(log(Data(Restrict(SmoothGamma{i} , Wake))),100);
    Y=Y/sum(Y);
    plot(X,Y,'b')
    hold on
    [Y,X]=hist(log(Data(Restrict(SmoothGamma{i} , SWSEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'r')
    [Y,X]=hist(log(Data(Restrict(SmoothGamma{i} , REMEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'g')
    grid on
    xlim([3 7])
    title(['Channel' num2str(Chan(i))])
    if i==1, ylabel('Gamma'), legend('Wake','NREM','REM') , end
    
    subplot(3,length(Chan),i+length(Chan))
    [Y,X]=hist(log(Data(Restrict(SmoothTheta{i} , Wake))),100);
    Y=Y/sum(Y);
    plot(X,Y,'b')
    hold on
    [Y,X]=hist(log(Data(Restrict(SmoothTheta{i} , SWSEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'r')
    [Y,X]=hist(log(Data(Restrict(SmoothTheta{i} , REMEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'g')
    grid on
    xlim([3 7])
    if i==1, ylabel('Theta'), end
    
    subplot(3,length(Chan),i+length(Chan)*2)
    [Y,X]=hist(log(Data(Restrict(SmoothUL{i} , Wake))),100);
    Y=Y/sum(Y);
    plot(X,Y,'b')
    hold on
    [Y,X]=hist(log(Data(Restrict(SmoothUL{i} , SWSEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'r')
    [Y,X]=hist(log(Data(Restrict(SmoothUL{i} , REMEpoch))),100);
    Y=Y/sum(Y);
    plot(X,Y,'g')
    grid on
    xlim([1.5 6])
    xlabel('Power (a.u.)')
    if i==1, ylabel('Ultra Low'), end
end



















