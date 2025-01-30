

clear all
close all

%% path

% RipControl/RipInhib
GetAllSalineSessions_BM
Drug_Group={'RipControl','RipInhib'};
Group = [7 8];
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            if length(UMazeSleepSess.(Mouse_names{mouse}))==3
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
            else
                try
                    SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                    SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                end
            end
            Dir.(Drug_Group{group}){mouse}{1} = SleepPostSess.(Mouse_names{mouse}){1};
        end
    end
end


% Saline/DZP
GetAllSalineSessions_BM
Drug_Group={'Saline','DZP'};
Group = [13 15];
for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        try
            UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
            SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
            if length(UMazeSleepSess.(Mouse_names{mouse}))==3
                SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                SleepPostPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(3);
            else
                try
                    SleepPreSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(1);
                    SleepPostSess.(Mouse_names{mouse}) = UMazeSleepSess.(Mouse_names{mouse})(2);
                end
            end
            Dir.(Drug_Group{group}){mouse}{1} = SleepPostSess.(Mouse_names{mouse}){1};
        end
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
            %             try
            try
                load([Dir.(Drug_Group{group}){mouse}{1} 'StateEpochSB.mat'], 'Wake' , 'Sleep' , 'SWSEpoch' , 'REMEpoch', 'Epoch' , 'TotalNoiseEpoch')
                Epoch;
            catch
                load([Dir.(Drug_Group{group}){mouse}{1} 'SleepScoring_Accelero.mat'], 'Wake' , 'Sleep' , 'SWSEpoch' ,...
                    'REMEpoch', 'Epoch' , 'TotalNoiseEpoch')
            end
            load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'], 'Vtsd')
            Speed_smooth = tsd(Range(Vtsd) , runmean(Data(Vtsd) , ceil(smootime/median(diff(Range(Vtsd,'s'))))));
            Moving = thresholdIntervals(Vtsd , SpeedLim ,'Direction', 'Above');
            try
                load([Dir.(Drug_Group{group}){mouse}{1} 'HeartBeatInfo.mat'])
            end
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
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
                    elseif state==2 % wake
                        Epoch_to_use{1} = Wake;
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
                    elseif state==3 % NREM
                        Epoch_to_use{1} = SWSEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
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
                            sum(DurationEpoch(and(Epoch_to_use{1} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))))/...
                            sum(DurationEpoch(and(Epoch_to_use{2} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))));
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
        disp(Mouse_names{mouse})
    end
    HR_Wake{group}(HR_Wake{group}==0) = NaN;
    HR_Wake_Moving{group}(HR_Wake_Moving{group}==0) = NaN;
    meanHeartRatesInBins{group}(meanHeartRatesInBins{group}==0) = NaN;
end
Prop.Wake{1}([2 9])=NaN; Prop_bin.Wake{1}([2 9],:)=NaN; % mice that didn't sleep during Sleep Pre
SFI.Wake{1}([2 9])=NaN;

Prop.REM_s_l_e_e_p{1}([1 2])=NaN; Prop.REM_t_o_t_a_l{1}([1 2])=NaN; % no HPC channels
Prop_bin.REM_s_l_e_e_p{1}([1 2],:)=NaN; Prop_bin.REM_t_o_t_a_l{1}([1 2],:)=NaN;
EpNumb.REM_s_l_e_e_p{1}([1 2])=NaN; EpNumb.REM_t_o_t_a_l{1}([1 2])=NaN;
MedianDur.REM_s_l_e_e_p{1}([1 2])=NaN; MedianDur.REM_t_o_t_a_l{1}([1 2])=NaN;
MeanDur.REM_s_l_e_e_p{1}([1 2])=NaN; MeanDur.REM_t_o_t_a_l{1}([1 2])=NaN;
SFI.REM_s_l_e_e_p{1}([1 2])=NaN; SFI.REM_t_o_t_a_l{1}([1 2])=NaN;
LatencyToState.REM_s_l_e_e_p{1}([1 2])=NaN; LatencyToState.REM_t_o_t_a_l{1}([1 2])=NaN;

Prop.REM_s_l_e_e_p{2}([1 2])=NaN; Prop.REM_t_o_t_a_l{2}([1 2])=NaN; % no HPC channels
Prop_bin.REM_s_l_e_e_p{2}([1 2],:)=NaN; Prop_bin.REM_t_o_t_a_l{2}([1 2],:)=NaN;
EpNumb.REM_s_l_e_e_p{2}([1 2])=NaN; EpNumb.REM_t_o_t_a_l{2}([1 2])=NaN;
MedianDur.REM_s_l_e_e_p{2}([1 2])=NaN; MedianDur.REM_t_o_t_a_l{2}([1 2])=NaN;
MeanDur.REM_s_l_e_e_p{2}([1 2])=NaN; MeanDur.REM_t_o_t_a_l{2}([1 2])=NaN;
SFI.REM_s_l_e_e_p{2}([1 2])=NaN; SFI.REM_t_o_t_a_l{2}([1 2])=NaN;
LatencyToState.REM_s_l_e_e_p{2}([1 2])=NaN; LatencyToState.REM_t_o_t_a_l{2}([1 2])=NaN;

% 1189 bad heart
HR_Wake_First5min{1}(5) = NaN;
HR_Wake_First5min{2}(3) = NaN;


%% figures
Cols2 = {'b','r'};
Cols = {[0 0 1],[1 0 0]};
X = [1:2];
Legends = {'RipControl','RipInhib'};
NoLegends = {'',''};
Legends = {'Saline','DZP'};

figure
subplot(292)
MakeSpreadAndBoxPlot3_SB(Prop.Wake,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('Wake proportion')

subplot(295)
MakeSpreadAndBoxPlot3_SB(Prop.REM_s_l_e_e_p,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('REM/sleep proportion')

subplot(298)
MakeSpreadAndBoxPlot3_SB(Prop.REM_t_o_t_a_l,Cols,X,Legends,'showpoints',1,'paired',0)
ylabel('REM/total proportion')

n=1;
for state=[2 4 5]
    subplot(2,3,n+3)
    for group=1:length(Drug_Group)
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
    if state==1, ylabel('Wake proportion')
    elseif state==4, ylabel('REM/sleep proportion')
    elseif state==5, ylabel('REM/total proportion'), end
    if state==1, legend(Legends{1},Legends{2}), end
    n=n+1;
end


% HR
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(HR_Wake,Cols,X,Legends,'showpoints',1,'paired',0)

subplot(122)
MakeSpreadAndBoxPlot3_SB(HR_Wake_Moving,Cols,X,Legends,'showpoints',1,'paired',0)



for group=1:2
    HR_Wake_First5min{group} = HR_Wake{grou}-l.HR_Wake{group};
end




figure
for state=1:4
    subplot(5,4,state)
    MakeSpreadAndBoxPlot3_SB(Prop.(States{state}),Cols,X,NoLegends,'showpoints',1,'paired',0)
    title(States{state})
    if state==1; ylabel('proportion'); end
    
    subplot(5,4,state+4)
    MakeSpreadAndBoxPlot3_SB(MeanDur.(States{state}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if state==1; ylabel('mean dur'); end
    
    subplot(5,4,state+8)
    MakeSpreadAndBoxPlot3_SB(EpNumb.(States{state}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if state==1; ylabel('ep number'); end
    
    subplot(5,4,state+12)
    MakeSpreadAndBoxPlot3_SB(SFI.(States{state}),Cols,X,NoLegends,'showpoints',1,'paired',0);
    if state==1; ylabel('fragmentation index'); end
    
    subplot(5,4,state+16)
    MakeSpreadAndBoxPlot3_SB(LatencyToState.(States{state}),Cols,X,Legends,'showpoints',1,'paired',0);
    if state==1; ylabel('latency'); end
end


%% non used
% Temperature
load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'], 'MouseTemp')
Temp_tsd = tsd(MouseTemp(:,1)*1e4 , MouseTemp(:,2));
clear T
T = Restrict(Temp_tsd , intervalSet(0 , 60*60e4));
Temp_interp{group}(mouse,:) = interp1(linspace(0,1,length(Data(T))) , movmean(Data(T),15,'omitnan') , linspace(0,1,1.8e3));
MeanTemp{group}(mouse,:) = nanmean(MouseTemp(:,2));
TEMP{group}(mouse,1:length(MouseTemp)) = movmean(MouseTemp(:,2),30,'omitnan');
MeanTemp_Sleep{group}(mouse,:) = nanmean(Data(Restrict(Temp_tsd , and(Sleep , intervalSet(0,60*60e4)))));
MeanTemp_Wake_NotMoving{group}(mouse,:) = nanmean(Data(Restrict(Temp_tsd , and(Wake , intervalSet(0,5*60e4))-Moving)));

for group=1:length(Drug_Group)
    TEMP_norm{group} = nanmean(TEMP{group}(:,1:1e4)')-MeanTemp_Pre{group};
    TEMP_norm_evol{group} = TEMP{group}-MeanTemp_Pre{group}';
%     TEMP_norm{group}(TEMP_norm{group}==0)=NaN;
    MeanTEMP{group} = MeanTemp{group}-MeanTemp_Pre{group}';
    MeanTemp_Sleep2{group} = MeanTemp_Sleep{group}-MeanTemp_Sleep_Pre{group};
    MeanTemp_Wake_NotMoving2{group} = MeanTemp_Wake_NotMoving{group}-MeanTemp_Pre{group}';
end


% Grooming
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for mouse=1:length(Dir.(Drug_Group{group}))
        try
            
            clear Wake TotalNoiseEpoch
            load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'],'Vtsd')
            load([Dir.(Drug_Group{group}){mouse}{1} 'behavResources.mat'],'MovAcctsd')
            load([Dir.(Drug_Group{group}){mouse}{1} 'SleepScoring_Accelero.mat'],'Wake','TotalNoiseEpoch')
            Wake = or(Wake,TotalNoiseEpoch);
            
            Grooming_Epoch = FindGrooming_BM(Vtsd , MovAcctsd);
            Grooming_dur{group}(mouse) = sum(DurationEpoch(and(Grooming_Epoch , and(Wake , intervalSet(0,10*60e4)))))/1e4;
            Grooming_density{group}(mouse) = Grooming_dur{group}(mouse)./(sum(DurationEpoch(and(Wake , intervalSet(0,10*60e4))))./60e4);
        end
    end
end



clear all

Group=[7 8];
Session_type = {'sleep_pre','sleep_post'};
Drug_Group = {'RipControl','RipInhib'};

for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(Group(group));
    for sess=1:length(Session_type)
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM('drugs',Mouse,lower(Session_type{sess}),...
            'accelero');
    end
end


for group=1:length(Drug_Group)
    Mouse = Drugs_Groups_UMaze_BM(Group(group));
    for mouse=1:length(Mouse)
        
        %         Mean_Acc_Start{group}(mouse) = nanmean(log10(Data(Restrict(OutPutData.(Drug_Group{group}).sleep_post.accelero.tsd{mouse,1}...
        %             , intervalSet(0 , 5*60e4)))))./nanmean(log10(Data(Restrict(OutPutData.(Drug_Group{group}).sleep_pre.accelero.tsd{mouse,2} , intervalSet(0,60*60e4)))));
        
%         Mean_Acc_Start{group}(mouse) = movmean(log10(Data(Restrict(OutPutData.(Drug_Group{group}).sleep_post.accelero.tsd{mouse,1}...
%             , intervalSet(0 , 5*60e4)))));
        clear D, D = movmean(log10(Data(Restrict(OutPutData.(Drug_Group{group}).sleep_post.accelero.tsd{mouse,1} , intervalSet(0 , 60*60e4)))), 90 , 'omitnan');
        D = D(1:10:end);
        Acc_mice{group}(mouse,1:length(D)) = D;
        
        %         EMG_mice{group}() = Data(OutPutData.(Drug_Group{group}).sleep_post.emg_pect.tsd{1,1})
    end
end
Acc_mice{1}(6,:)=NaN;

figure
MakeSpreadAndBoxPlot3_SB(Mean_EMG_Start,{[.3, .745, .93],[.85, .325, .098]},[1,2],Drug_Group,'showpoints',1,'paired',0)



figure
plot(Acc_mice{1}' , 'k')

clf
plot(nanmean(Acc_mice{1}) , 'k')
hold on
plot(nanmean(Acc_mice{2}) , 'r')


Data_to_use = movmean(Acc_mice{1}' , 1e3 , 'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,60,18000) , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
Data_to_use = movmean(Acc_mice{2}' , 1e3 , 'omitnan')';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(linspace(0,60,18000) , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
ylim([6.5 8])



