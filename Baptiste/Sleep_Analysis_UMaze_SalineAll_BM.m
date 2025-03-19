
clear all
close all

%% path
% All eyelid
GetAllSalineSessions_BM
Group = 22;
Drug_Group={'Eyelid'};

for group = 1:length(Group)
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
        end
        try, DIR{1}{mouse} = SleepPreSess.(Mouse_names{mouse}){1}; end
        try, DIR{2}{mouse} = SleepPostSess.(Mouse_names{mouse}){1}; end
    end
end

%% basic parameters
States={'Sleep','Wake','NREM','REM_s_l_e_e_p','REM_t_o_t_a_l'};
window_size = 60; % in minutes, starting from recording beginning
window_size2 = 40; % after first sleep for REM
window_size3 = 5; % for HR
smootime = 1;
SpeedLim = 2;

%% data collection
for sess=1:2
    clear Epoch1
    for mouse=1:length(Mouse)
        try
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                
                clear Wake Sleep SWSEpoch REMEpoch EKG Epoch EKG Vtsd TotalNoiseEpoch
                
                load([DIR{sess}{mouse} 'StateEpochSB.mat'], 'Wake' , 'Sleep' , 'SWSEpoch' , 'REMEpoch', 'Epoch' , 'TotalNoiseEpoch')
                try
                    load([DIR{sess}{mouse} 'behavResources.mat'], 'Vtsd')
                    Speed_smooth = tsd(Range(Vtsd) , runmean(Data(Vtsd) , ceil(smootime/median(diff(Range(Vtsd,'s'))))));
                    Moving = thresholdIntervals(Vtsd , SpeedLim ,'Direction', 'Above');
                    %                     catch
                    %                         load([DIR{sess}{mouse} 'behavResources.mat'], 'Mov')
                    %                         Speed_smooth = tsd(Range(Vtsd) , runmean(Data(Vtsd) , ceil(smootime/median(diff(Range(Vtsd,'s'))))));
                    %                         Moving = thresholdIntervals(Vtsd , 2e7 ,'Direction', 'Above');
                end
                try
                    load([DIR{sess}{mouse} 'HeartBeatInfo.mat'])
                end
                Wake = or(Wake , TotalNoiseEpoch);
                Tot = or(Epoch , TotalNoiseEpoch);
                try
                    Long_Sleep = dropShortIntervals(Sleep , 20e4);
                    St = Start(Long_Sleep);
                    Start_Sleep = St(1);
                end
                REM_min(mouse) = min(DurationEpoch(REMEpoch))/1e4;
                for state=1:length(States)
                    try
                        if sess==1
                            if state==1 % sleep
                                Epoch_to_use{1} = Sleep;
                                Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                                Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                                Epoch_to_use{2} = Tot;
                            elseif state==2 % wake
                                Epoch_to_use{1} = Wake;
                                Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                                Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                                Epoch_to_use{2} = Tot;
                            elseif state==3 % NREM
                                Epoch_to_use{1} = SWSEpoch;
                                Epoch_to_use{2} = Sleep;
                            elseif state==4 % REM over sleep
                                Epoch_to_use{1} = REMEpoch;
                                %                                 Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , .5e4);
                                Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 3e4);
                                Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                                Epoch_to_use{2} = Sleep;
                                Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                            elseif state==5 % REM over tot
                                Epoch_to_use{1} = REMEpoch;
                                Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                                Epoch_to_use{2} = Tot;
                                Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                            end
                        else % for sleep post, restrict to first 90 min
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
                                %                                 Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , .5e4);
                                Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 3e4);
                                Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                                Epoch_to_use{2} = Sleep;
                                Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                            elseif state==5 % REM over tot
                                Epoch_to_use{1} = REMEpoch;
                                Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                                Epoch_to_use{2} = Tot;
                                Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(Start_Sleep,Start_Sleep+40*60e4));
                            end
                        end
                        
                        Prop.(States{state}){sess}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                        MeanDur.(States{state}){sess}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                        MedianDur.(States{state}){sess}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                        EpNumb.(States{state}){sess}(mouse) = length(Start(Epoch_to_use{1}));
                        try
                            LatencyToState_pre.(States{state}){sess}{mouse} = Start(Epoch_to_use{1})/1e4;
                            State_Duration.(States{state}){sess}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                            LatencyToState.(States{state}){sess}(mouse) = LatencyToState_pre.(States{state}){sess}{mouse}(find(State_Duration.(States{state}){sess}{mouse}>20,1));
                        end
                        Dur.(States{state}){sess}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/60e4;
                        SFI.(States{state}){sess} = EpNumb.(States{state}){sess}./Dur.(States{state}){sess}(mouse);
                        
                        for bin=1:window_size/10
                            Prop_bin.(States{state}){sess}(mouse,bin) = ...
                                sum(DurationEpoch(and(Epoch_to_use{1} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))))/...
                                sum(DurationEpoch(and(Epoch_to_use{2} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))));
                        end
                        
                    end
                end
                if sess==1
                    HR_Wake{sess}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size*60e4)))));
                    HRVar_Wake{sess}(mouse) = nanmean(movstd(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size*60e4)))),5));
                else
                    HR_Wake{sess}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size3*60e4)))));
                    HRVar_Wake{sess}(mouse) = nanmean(movstd(Data(Restrict(EKG.HBRate , and(Wake , intervalSet(0,window_size3*60e4)))),5));
                end
                HR_Wake_Moving{sess}(mouse) = nanmean(Data(Restrict(EKG.HBRate , and(and(Wake,Moving) , intervalSet(0,window_size*60e4)))));
                try, TotDur{sess}(mouse) = sum(DurationEpoch(Epoch1{mouse,1}))/3600e4; end
            end
            disp(Mouse_names{mouse})
        end
    end
    HR_Wake{sess}(HR_Wake{sess}==0) = NaN;
    HRVar_Wake{sess}(HRVar_Wake{sess}==0) = NaN;
    
    Prop.REM_s_l_e_e_p{sess}([4 8 14 15 17 18])=NaN;
    Prop.NREM{sess}([4 8 14 15 17 18])=NaN;
    SFI.REM_s_l_e_e_p{sess}([4 8 14 15 17 18])=NaN;
    MeanDur.REM_s_l_e_e_p{sess}([4 8 14 15 17 18])=NaN;
end
Prop.Wake{2}([4 8])=NaN;
SFI.Wake{2}([4 8])=NaN;
MeanDur.Wake{2}([4 8])=NaN;

HR_Wake{group}([6 23]) = NaN; % 667 already sleeping, 1251 HR insane in SleepPre


%% figures
Cols = {[0 0 1],[1 0 0]};
X = [1:2];
Legends = {'Sleep Pre','Sleep Post'};
NoLegends = {'',''};

figure
for state=1:4
    subplot(1,4,state)
    MakeSpreadAndBoxPlot3_SB(Prop.(States{state}),Cols,X,NoLegends,'showpoints',0,'paired',1);
    title(States{state})
    if state==1; ylabel('proportion'); end
end


figure
MakeSpreadAndBoxPlot3_SB(HR_Wake,Cols,X,NoLegends,'showpoints',0,'paired',1);



HR_Wake_First5min{group} = HR_Wake{2}-HR_Wake{1};


HR_Wake_First5min{group} = HR_Wake_Moving{2}-HR_Wake_Moving{1};

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







