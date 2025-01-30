% wrong version
Dir{2}=PathForExperiments_Opto('Stim_20Hz');
number = 1;
for i=1:length(Dir{2}.path)
    cd(Dir{2}.path{i}{1});
    
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    epREM{i}=REMEpoch;
    epWake{i}=Wake;
    epSWS{i}=SWSEpoch;
    load Bulb_deep_High_Spectrum
    SpectroB{i}=Spectro;
    sptsdB(i)= tsd(SpectroB{i}{2}*1e4, SpectroB{i}{1});
    
    [Stim, StimREM, StimSWS, StimWake] = FindOptoStim_MC(Wake, SWSEpoch, REMEpoch); % to find optogenetic stimulations
    events{i}=Stim;
    eventsSWS{i}=StimSWS;
    eventsREM{i}=StimREM;
    eventsWake{i}=StimWake;

    % compute average spectrograms for each mouse
    [Mrem{i},Srem{i},TPS]=AverageSpectrogram(sptsdB(i),SpectroB{i}{3},Restrict(ts(events{i}*1e4),epREM{i}),500,300,0);
    [Msws{i},Ssws{i},TPS]=AverageSpectrogram(sptsdB(i),SpectroB{i}{3},Restrict(ts(events{i}*1e4),epSWS{i}),500,300,0);
    [Mwake{i},Swake{i},TPS]=AverageSpectrogram(sptsdB(i),SpectroB{i}{3},Restrict(ts(events{i}*1e4),epWake{i}),500,300,0);

    dataMwake=cat(3,Mwake{:});   % convert cell arrays in 3D arrays (third dimension being mice)              
    dataMrem=cat(3,Mrem{:});
    dataMsws=cat(3,Msws{:});
    avdataMwake=nanmean(dataMwake,3);   % compute average spectro across the third dimension
    avdataMsws=nanmean(dataMsws,3);
    avdataMrem=nanmean(dataMrem,3);
       
    % trigger each line (frequencies) of the spectro on events(=stims)
    for f=1:length(SpectroB{i}{3})
        for evS=1:length(eventsSWS{i})
            [MatSWS{number}(f,evS,:),S_SWS{number}(f,evS,:),tps]=mETAverage(eventsSWS{i}(evS),Range(sptsdB(i)),SpectroB{i}{1}(:,f),1000,1000);
        end
        for evR=1:length(eventsREM{i})
            [MatREM{number}(f,evR,:),S_REM{number}(f,evR,:),tps]=mETAverage(eventsREM{i}(evR),Range(sptsdB(i)),SpectroB{i}{1}(:,f),1000,1000); % trigger each line (frequency) of the spectrum on events
        end
        for evW=1:length(eventsWake{i})
            [MatWake{number}(f,evW,:),S_Wake{number}(f,evW,:),tps]=mETAverage(eventsWake{i}(evW),Range(sptsdB(i)),SpectroB{i}{1}(:,f),1000,1000);
        end
    end
    
    % average across frequencies bands (theta & delta) and events to get the average signal for each mouse
    for matS=1:length(MatSWS)
        BetaSWS(matS,:)=squeeze(nanmean(nanmean(MatSWS{matS}(find(SpectroB{i}{3}<30&SpectroB{i}{3}>21),:,:),1)));   % frequency band average to get the theta
        
    end
    for matR=1:length(MatREM)
        BetaREM(matR,:)=squeeze(nanmean(nanmean(MatREM{matR}(find(SpectroB{i}{3}<30&SpectroB{i}{3}>21),:,:),1)));   
    end
    for matW=1:length(MatWake)
        BetaWake(matW,:)=squeeze(nanmean(nanmean(MatWake{matW}(find(SpectroB{i}{3}<30&SpectroB{i}{3}>21),:,:),1)));   
    end
    



T=tps/1E3;                       % to define time window before and during the stim
BeforeStim=find(T>-10&T<0);
DuringStim=find(T>0&T<10);


MouseId(number) = Dir{2}.nMice{i} ;
number=number+1;

end

%%
% bar plot theta power before VS during the stim
% subplot(6,5,18),

figure,PlotErrorBar2_MC(mean(BetaREM(:,BeforeStim),2),mean(BetaREM(:,DuringStim),2),0);
% ylim([0 4e+04])
ylabel('Beta power')
xticks(1:2)
xticklabels({'Before','During'});
title('REM')
% subplot(6,5,19),
figure,PlotErrorBar2_MC(mean(BetaSWS(:,BeforeStim),2),mean(BetaSWS(:,DuringStim),2),0);
% ylim([0 4e+04])
ylabel('Beta power')
xticks(1:2)
xticklabels({'Before','During'});
title('NREM')
% subplot(6,5,20),
figure,PlotErrorBar2_MC(mean(BetaWake(:,BeforeStim),2),mean(BetaWake(:,DuringStim),2),0);
% ylim([0 4e+04])
ylabel('Beta power')
xticks(1:2)
xticklabels({'Before','During'});
title('Wake')

