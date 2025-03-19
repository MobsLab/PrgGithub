

clear all
close all

%%
Drug_Group={'Novel','UMazePAG'};
for group=1:length(Drug_Group)
    DIR.(Drug_Group{group}) = PathForExperimentsERC(Drug_Group{group});
    for mouse=1:length(DIR.(Drug_Group{group}).path)
        Dir.(Drug_Group{group}){mouse} = DIR.(Drug_Group{group}).path{mouse};
    end
end

%% basic parameters
States={'Sleep','Wake','NREM','REM_s_l_e_e_p','REM_t_o_t_a_l'};
window_size = 60; % in minutes, starting from recording beginning
window_size2 = 40; % after first sleep for REM
window_size3 = 5; % for HR
smootime = 1;
SpeedLim = 1;

%% data collection
clear Prop_bin
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for mouse=1:length(Dir.(Drug_Group{group}))
        try
            
            clear Wake Sleep SWSEpoch REMEpoch EKG Epoch EKG Vtsd TotalNoiseEpoch
            
            try
                load([Dir.(Drug_Group{group}){mouse}{1} 'SleepScoring_Accelero.mat'], 'Wake' , 'Sleep' , 'SWSEpoch' ,...
                    'REMEpoch', 'Epoch' , 'TotalNoiseEpoch')
            end
            load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'], 'Vtsd','SessionEpoch')
            %             Speed_smooth = tsd(Range(Vtsd) , runmean(Data(Vtsd) , ceil(smootime/median(diff(Range(Vtsd,'s'))))));
            %             Moving = thresholdIntervals(Vtsd , SpeedLim ,'Direction', 'Above');
            %             try
            %                 load([Dir.(Drug_Group{group}){mouse}{1} 'HeartBeatInfo.mat'])
            %             end
            
            
            % ERC specificity
            Epoch = SessionEpoch.PostSleep;
            Wake = and(Wake , SessionEpoch.PostSleep);
            Sleep = and(Sleep , SessionEpoch.PostSleep);
            SWSEpoch = and(SWSEpoch , SessionEpoch.PostSleep);
            REMEpoch = and(REMEpoch , SessionEpoch.PostSleep);
            TotalNoiseEpoch = and(TotalNoiseEpoch , SessionEpoch.PostSleep);
            
            Wake = or(Wake , TotalNoiseEpoch);
            Tot = or(Epoch , TotalNoiseEpoch);
            
            Long_Sleep = dropShortIntervals(Sleep , 20e4);
            St = Start(Long_Sleep);
            Start_Sleep = St(1);
            
            for state=1:length(States)
                try
                    if state==1 % sleep
                        Epoch_to_use{1} = Sleep;
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                    elseif state==2 % wake
                        Epoch_to_use{1} = Wake;
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                    elseif state==3 % NREM
                        Epoch_to_use{1} = SWSEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start(SessionEpoch.PostSleep),Start(SessionEpoch.PostSleep)+window_size*60e4));
                    elseif state==4 % REM over sleep
                        Epoch_to_use{1} = REMEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+window_size2*60e4));
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+window_size2*60e4));
                    elseif state==5 % REM over tot
                        Epoch_to_use{1} = REMEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+window_size2*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+window_size2*60e4));
                    end
                    %
                    Prop.(States{state}){group}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                    MeanDur.(States{state}){group}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                    MedianDur.(States{state}){group}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                    EpNumb.(States{state}){group}(mouse) = length(Start(Epoch_to_use{1}));
                    try
                        LatencyToState_pre.(States{state}){group}{mouse} = Start(Epoch_to_use{1})/1e4;
                        State_Duration.(States{state}){group}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                        LatencyToState.(States{state}){group}(mouse) = LatencyToState_pre.(States{state}){group}{mouse}(find(State_Duration.(States{state}){group}{mouse}>20,1));
                    end
                    Dur.(States{state}){group}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/60e4;
                    SFI.(States{state}){group} = EpNumb.(States{state}){group}./Dur.(States{state}){group}(mouse);
                    
                    for bin=1:window_size/10
                        Prop_bin.(States{state}){group}(mouse,bin) = ...
                            sum(DurationEpoch(and(Epoch_to_use{1} , intervalSet(Start(SessionEpoch.PostSleep)+10*(bin-1)*60e4,Start(SessionEpoch.PostSleep)+10*bin*60e4))))/...
                            sum(DurationEpoch(and(Epoch_to_use{2} , intervalSet(Start(SessionEpoch.PostSleep)+10*(bin-1)*60e4,Start(SessionEpoch.PostSleep)+10*bin*60e4))));
                    end
                    %
                end
            end
            HR_Wake{group}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size3*60e4)))));
            HR_Wake_Moving{group}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(and(Wake,Moving) , intervalSet(0,window_size3*60e4)))));
            heartRate = Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size3*60e4)));
            speed = Restrict(Vtsd , heartRate);
            [meanHeartRatesInBins{group}(mouse,:) , ~] = HeartRateVsSpeed_Curve_BM(speed, heartRate);
            try, TotDur{group}(mouse) = sum(DurationEpoch(Epoch1{mouse,1}))/3600e4; end
            
            HR_REM{group}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Sleep , intervalSet(Start_Sleep,Start_Sleep+60*60e4))-Moving)));
        end
        disp(mouse)
    end
    try
        HR_Wake{group}(HR_Wake{group}==0) = NaN;
        HR_Wake_Moving{group}(HR_Wake_Moving{group}==0) = NaN;
        meanHeartRatesInBins{group}(meanHeartRatesInBins{group}==0) = NaN;
    end
end


%% figures
Cols2 = {'b','r'};
Cols = {[0 0 1],[1 0 0]};
X = [1:2];
Legends = Drug_Group;
NoLegends = {'',''};

figure
subplot(262)
MakeSpreadAndBoxPlot3_SB(Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Wake proportion')

subplot(265)
MakeSpreadAndBoxPlot3_SB(Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('REM/sleep proportion')

n=1;
for state=[2 4]
    subplot(2,2,n+2)
    for group=1:2
        errorbar([10:10:window_size] , nanmean(Prop_bin.(States{state}){group}) , stdError(Prop_bin.(States{state}){group}) , Cols2{group}), hold on
    end
    try
        for bin=1:window_size/10
            [p.(States{state})(bin)] = ranksum(Prop_bin.(States{state}){1}(:,bin) , Prop_bin.(States{state}){2}(:,bin));
        end
        y = ylim; Y = ones(1,9)*y(2)*1.1; X2 = [10:10:window_size];
        plot(X2(p.(States{state})<.05) , Y(p.(States{state})<.05) , '*k'), ylim([0 Y(1)])
    end
    makepretty
    xlabel('time (min)'), xlim([0 window_size])
    if state==2, ylabel('Wake proportion')
    elseif state==4, ylabel('REM/sleep proportion'), end
    if state==2, legend(Legends), end
    n=n+1;
end

%% old