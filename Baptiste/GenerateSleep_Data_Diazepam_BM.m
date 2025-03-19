


clear all
% preliminary variables
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Group=[13 15];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
sta = [3 2 4 5];
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type)
        [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] =...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples');
    end
end


n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            for state=1:length(States)
                try
                    if sess==1
                        if state==1 % sleep
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                        elseif state==2 % wake
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,2};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                            Epoch_to_use{3} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                        elseif state==3 % NREM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4};
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                        elseif state==4 % REM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,5};
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                        end
                    else % for sleep post, restrict to first 60 min
                        if state==1 % sleep
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 20e4);
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                        elseif state==2 % wake
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,2};
                            Epoch_to_use{1} = mergeCloseIntervals(Epoch_to_use{1} , 2e4);
                            Epoch_to_use{1} = dropShortIntervals(Epoch_to_use{1} , 5e4);
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                            Epoch_to_use{3} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                            Epoch_to_use{3} = and(Epoch_to_use{3} , intervalSet(0,60*60e4));
                        elseif state==3 % NREM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4};
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
                        elseif state==4 % REM
                            Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,5};
                            Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,60*60e4));
%                             Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,90*60e4));
                            Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                            Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,60*60e4));
%                             Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,90*60e4));
                        end
                    end
                    Prop.(States{state}){sess}{n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                    MeanDur.(States{state}){sess}{n}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                    MedianDur.(States{state}){sess}{n}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                    EpNumb.(States{state}){sess}{n}(mouse) = length(Start(Epoch_to_use{1}));
                    try
                        LatencyToState_pre.(States{state}){sess}{n}{mouse} = Start(Epoch_to_use{1})/1e4;
                        State_Duration.(States{state}){sess}{n}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                        LatencyToState.(States{state}){sess}{n}(mouse) = LatencyToState_pre.(States{state}){sess}{mouse}(find(State_Duration.(States{state}){sess}{mouse}>20,1));
                    end
                    TotDur.(States{state}){sess}{n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/60e4;
                    if sess<3
                        try, SFI.(States{state}){sess}{n} = EpNumb.(States{state}){sess}{n}./(sum(DurationEpoch(Epoch_to_use{3}))/3600e4); end
                    else
                        try, SFI.(States{state}){sess}{n} = EpNumb.(States{state}){sess}{n}./(sum(DurationEpoch(Epoch_to_use{1}))/3600e4); end
                    end
                    % HR
                    %                     HR.(States{state}){sess}{n}(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartrate.tsd{mouse,1} , Epoch_to_use{1})));
                    % HRVar
                    %                     HRVar.(States{state}){sess}{n}(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartratevar.tsd{mouse,1} , Epoch_to_use{1})));
                    % OB Low
                    %                     OB_Low.(States{state}){sess}{n}(mouse,:) = OutPutData.(Session_type{sess}).(Drug_Group{group}).ob_low.mean(mouse,sta(state),:);
                    % HPC Low
                    %                     HPC_Low.(States{state}){sess}{n}(mouse,:) = OutPutData.(Session_type{sess}).(Drug_Group{group}).hpc_low.mean(mouse,sta(state),:);
                    
                    if state==3
                        try
                            RipplesDensity{sess}{n}(mouse) = length(Data(Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).ripples.ts{mouse,4} , Epoch_to_use{1})))./(sum(DurationEpoch(Epoch_to_use{1}))/1e4);
                            RipplesDensity{sess}{n}(RipplesDensity{sess}{n}==0) = NaN;
                        end
                    end
                end
            end
            try, TotDur{sess}{n}(mouse) = sum(DurationEpoch(Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1}))/3600e4; end
        end
        disp(Mouse_names{mouse})
    end
    n=n+1;
end


% mice without HPC
Prop.REM{1}{1}(1:2)=NaN; Prop.REM{2}{1}(1:2)=NaN;

%% figures
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
X = [1:2];
Legends = {'Saline','DZP'};
NoLegends = {'',''};

Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
Legends = {'RipControl','RipInhib'};


for state=2:4
    figure
    for sess=1:2
        subplot(2,3,1+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(Prop.(States{state}){sess},Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Proportion'); end
        if state==2; ylim([0 1]); elseif state==3;  ylim([.78 1]); elseif state==4; ylim([0 .21]); end
        ylabel('proportion')
        
        subplot(2,3,2+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(MeanDur.(States{state}){sess},Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Mean duration'); end
        ylabel('time (s)')
        
        subplot(2,3,3+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(EpNumb.(States{state}){sess},Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Episodes number'); end
        ylabel('#')
    end
    a=suptitle(States{state}); a.FontSize=20;
end


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Prop.Wake{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Wake prop')

subplot(122)
MakeSpreadAndBoxPlot3_SB(Prop.REM{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM prop')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(EpNumb.REM{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')

subplot(122)
MakeSpreadAndBoxPlot3_SB(EpNumb.REM{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(RipplesDensity{1},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')

subplot(122)
MakeSpreadAndBoxPlot3_SB(RipplesDensity{2},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('REM ep number (#)')




