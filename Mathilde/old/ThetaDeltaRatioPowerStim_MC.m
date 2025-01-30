% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number = 1;
% for i=1:length(Dir)           % !! here we only use recordings with stimulations
for j=1:length(Dir{2}.path)     % each mouse / recording
    cd(Dir{2}.path{j}{1});
    
    load LFPData/DigInfo2
    digTSD(j)=DigTSD;
    load H_Low_Spectrum
    SpectroH{j} = Spectro;
    load SleepScoring_OBGamma REMEpoch SWSEpoch Wake
    REMTime{j}=REMEpoch;
    wakeTime{j}=Wake;
    SWSTime{j}=SWSEpoch;
    
    TTLEpoch(j) = thresholdIntervals(digTSD(j),0.99,'Direction','Above');   % column of time above .99 to get ON stim
    TTLEpoch_merged(j) = mergeCloseIntervals(TTLEpoch(j),1e4);              % merge all stims times closer to 1s to avoid slots and replace it with an entire step of 1 min
    
    for k = 1:length(Start(TTLEpoch_merged(j)))
        LittleEpoch(j) = subset(TTLEpoch_merged(j),k);
        Freq_Stim(j,k) = round(1./(median(diff(Start(and(TTLEpoch(j),LittleEpoch(j)),'s')))));
        Time_Stim(j,k) = min(Start(and(TTLEpoch(j),LittleEpoch(j))));
    end
    
    sptsd(j)= tsd(SpectroH{j}{2}*1e4, SpectroH{j}{1});
    
    events{j}=Start(TTLEpoch_merged(j))/1E4;    % to find opto stimulations
    ev{j}=ts(events{j}*1e4);
    temp_SWS=Restrict(ev{j},SWSTime{j});
    temp_REM=Restrict(ev{j},REMTime{j});
    temp_wake=Restrict(ev{j},wakeTime{j});
    events_SWS{j}=Range(temp_SWS);              % opto stimulations in each state
    events_REM{j}=Range(temp_REM);
    events_wake{j}=Range(temp_wake);
    
    % trigger each line (frequency) of the spectrum on events
    for f=1:length(SpectroH{j}{3})
        for  s =1:length(events_SWS{j})
            [M_SWS{number}(f,s,:),S_SWS{number}(f,s,:),t_SWS]=mETAverage(events_SWS{j}(s),Range(sptsd(j)),SpectroH{j}{1}(:,f),1000,1000); 
        end
        
        for r=1:length(events_REM{j})
            [M_REM{number}(f,r,:),S_REM{number}(f,r,:),t_REM]=mETAverage(events_REM{j}(r),Range(sptsd(j)),SpectroH{j}{1}(:,f),1000,1000);
        end
        
        for w=1:length(events_wake{j})
            [M_wake{number}(f,w,:),S_wake{number}(f,w,:),t_wake]=mETAverage(events_wake{j}(w),Range(sptsd(j)),SpectroH{j}{1}(:,f),1000,1000);
        end
        
    end
       
    % mean across frequencies bands and events to get the average signal
    % for each mouse
    for l=1:length(M_SWS)
        avdata_theta_SWS(l,:)=squeeze(nanmean(nanmean(M_SWS{l}(find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:))));
        avdata_delta_SWS(l,:)=squeeze(nanmean(nanmean(M_SWS{l}(find(SpectroH{j}{3}<4&SpectroH{j}{3}>0.5),:,:))));
    end
    
    for m=1:length(M_REM)
        avdata_theta_REM(m,:)=squeeze(nanmean(nanmean(M_REM{m}(find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:))));
        avdata_delta_REM(m,:)=squeeze(nanmean(nanmean(M_REM{m}(find(SpectroH{j}{3}<4&SpectroH{j}{3}>0.5),:,:))));
    end
    
    for n=1:length(M_wake)
        avdata_theta_wake(n,:)=squeeze(nanmean(nanmean(M_wake{n}(find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:))));
        avdata_delta_wake(n,:)=squeeze(nanmean(nanmean(M_wake{n}(find(SpectroH{j}{3}<4&SpectroH{j}{3}>0.5),:,:))));
    end
    
    % compute average theta / delta ratio
    Data_Mat_SWS=avdata_theta_SWS./avdata_delta_SWS;
    Data_Mat_REM=avdata_theta_REM./avdata_delta_REM;
    Data_Mat_wake=avdata_theta_wake./avdata_delta_wake;
    
    
%     DirId(number) = i;
    MouseId(number) = Dir{2}.nMice{j} ;
    number=number+1;
end

%% Plot
figure, shadedErrorBar(t_SWS/1e4,Data_Mat_SWS,{@mean,@stdError},'-r',1);
hold on
shadedErrorBar(t_REM/1e4,Data_Mat_REM,{@mean,@stdError},'-g',1);
hold on
shadedErrorBar(t_wake/1e4,Data_Mat_wake,{@mean,@stdError},'-b',1);
ylabel('Theta/Delta power')
xlabel('Times (s)')
% xlim([-10 +30])

legend('NREM','','','','REM','','','','wake','','','')

