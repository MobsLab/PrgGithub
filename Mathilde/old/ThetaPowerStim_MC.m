
% Dir{1}=PathForExperiments_Opto('Baseline_20Hz');
Dir{2}=PathForExperiments_Opto('Stim_20Hz');

number = 1;
% for i=1:length(Dir)       % !! here we only use recordings with stimulations
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
    TTLEpoch_merged(j) = mergeCloseIntervals(TTLEpoch(j),1e4);  % merge all stims times closer to 1s to avoid slots and replace it with an entire step of 1 min
    
    for k = 1:length(Start(TTLEpoch_merged(j)))
        LittleEpoch(j) = subset(TTLEpoch_merged(j),k);
        Freq_Stim(j,k) = round(1./(median(diff(Start(and(TTLEpoch(j),LittleEpoch(j)),'s')))));
        Time_Stim(j,k) = min(Start(and(TTLEpoch(j),LittleEpoch(j))));
    end
    
    sptsd(j)= tsd(SpectroH{j}{2}*1e4, SpectroH{j}{1});
    
    events{j}=Start(TTLEpoch_merged(j))/1E4;   % to find opto stimulations
    ev{j}=ts(events{j}*1e4);
    temp_SWS=Restrict(ev{j},SWSTime{j});
    temp_REM=Restrict(ev{j},REMTime{j});
    temp_wake=Restrict(ev{j},wakeTime{j});
    events_SWS{j}=Range(temp_SWS);    % opto stimulations in each state
    events_REM{j}=Range(temp_REM);
    events_wake{j}=Range(temp_wake);
    
    for l=1:length(SpectroH{j}{3})
        for  a =1:length(events_SWS{j})
            [M_SWS(number,l,a,:),S_SWS(number,l,a,:),t]=mETAverage(events_SWS{j}(a),Range(sptsd(j)),SpectroH{j}{1}(:,l),1000,1000);
            % trigger each line (frequency) of the spectrum on events
            % M is a 4 dimensional matrix such as M(session/mouse number (number), freq (l), stim number (a), time)
        end
        
        for b=1:length(events_REM{j})
            [M_REM(number,l,b,:),S_REM(number,l,b,:),t]=mETAverage(events_REM{j}(b),Range(sptsd(j)),SpectroH{j}{1}(:,l),1000,1000);
        end
        
        for c=1:length(events_wake{j})
            [M_wake(number,l,c,:),S_wake(number,l,c,:),t]=mETAverage(events_wake{j}(c),Range(sptsd(j)),SpectroH{j}{1}(:,l),1000,1000);
        end
        
    end
    
    Data_Mat_wake=squeeze(mean(M_wake(number,find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:))); % frequency band average (here 6 to 9Hz) to get the theta
    Data_Mat_SWS=squeeze(mean(M_SWS(number,find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:)));
    Data_Mat_REM=squeeze(mean(M_REM(number,find(SpectroH{j}{3}<9&SpectroH{j}{3}>6),:,:)));
    
%     DirId(number) = i;
    MouseId(number) = Dir{2}.nMice{j} ;
    number=number+1;
end

%% Plot
figure, shadedErrorBar(t/1e4,Data_Mat_SWS,{@mean,@stdError},'-r',1);
hold on
shadedErrorBar(t/1e4,Data_Mat_REM,{@mean,@stdError},'-g',1);
hold on
shadedErrorBar(t/1e4,Data_Mat_wake,{@mean,@stdError},'-b',1);
ylabel('Theta power')
xlabel('Times (s)')
xlim([-20 +50])

legend('NREM','','','','REM','','','','wake','','','')
