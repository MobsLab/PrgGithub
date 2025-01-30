
Mouse = Drugs_Groups_UMaze_BM(22);
States={'Sleep','Wake','NREM','REM'};
Session_type={'sleep_pre','sleep_post'};

for sess=1:length(Session_type) % generate all data required for analyses
    [OutPutData.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(...
        'all_saline',Mouse,lower(Session_type{sess}),'heartrate');
end

time_window = 60; % time in minutes for study of states after record beginning
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:2
        for state=1:length(States)
            try
                if sess==1
                    if state==1 % sleep
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,3};
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                    elseif state==2 % wake
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,2};
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                        Epoch_to_use{3} = Epoch1.(Session_type{sess}){mouse,3};
                    elseif state==3 % NREM
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,4};
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                    elseif state==4 % REM
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,5};
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                    end
                else % for sleep post, restrict to first 90 min
                    if state==1 % sleep
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,3};
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,time_window*60e4));
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,time_window*60e4));
                    elseif state==2 % wake
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,2};
                        Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                        Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,time_window*60e4));
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,1};
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,time_window*60e4));
                        Epoch_to_use{3} = Epoch1.(Session_type{sess}){mouse,3};
                        Epoch_to_use{3} = and(Epoch_to_use{3} , intervalSet(0,time_window*60e4));
                    elseif state==3 % NREM
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,4};
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,time_window*60e4));
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,time_window*60e4));
                    elseif state==4 % REM
                        Epoch_to_use{1} = Epoch1.(Session_type{sess}){mouse,5};
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,time_window*60e4));
                        Epoch_to_use{2} = Epoch1.(Session_type{sess}){mouse,3};
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,time_window*60e4));
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
                TotDur.(States{state}){sess}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/60e4;
                if sess<3
                    try, SFI.(States{state}){sess} = EpNumb.(States{state}){sess}./(sum(DurationEpoch(Epoch_to_use{3}))/3600e4); end
                else
                    try, SFI.(States{state}){sess} = EpNumb.(States{state}){sess}./(sum(DurationEpoch(Epoch_to_use{1}))/3600e4); end
                end
            end
        end
        try, TotDur{sess}(mouse) = sum(DurationEpoch(Epoch1.(Session_type{sess}){mouse,1}))/3600e4; end
    end
    disp(Mouse_names{mouse})
end

Prop.REM{2}([4 8 14 15])=NaN;
Prop.Sleep{2}([4 8])=NaN;
Prop.Wake{2}([4 8])=NaN;
Prop.NREM{2}([4 8])=NaN;

Prop.REM{2}(Prop.REM{2}<.02)=NaN;

save('/media/nas7/ProjetEmbReact/DataEmbReact/PaperData/Sleep_UMaze_Eyelid.mat')

