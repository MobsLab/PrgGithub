

clear all
[Dir_CD1_CD1cage,Dir_CD1_C57cage,Dir_Sleep_CD1InCage,Dir_Sleep_CD1NOTInCage,Dir_Sleep_Ctrl,...
    Info_CD1_CD1cage,Info_CD1_C57cage,Info_Sleep_CD1InCage,Info_Sleep_CD1NOTInCage,Info_Sleep_Ctrl] = Get_SD_Path_UmazeComp;
Drug_Group = {'Sleep_CD1','Sleep_no_CD1','Ctrl'};

mouse=1;
for i=1:length(Dir_Sleep_CD1InCage)
    for j=1:length(Dir_Sleep_CD1InCage{i}.path)
        
        Dir.Sleep_CD1{mouse}{1} = Dir_Sleep_CD1InCage{i}.path{j}{1};
        mouse = mouse+1;
        
    end
end
for mouse=1:length(Dir_Sleep_CD1NOTInCage{1}.path)
    Dir.Sleep_no_CD1{mouse}{1} = Dir_Sleep_CD1NOTInCage{1}.path{mouse}{1} ;
end
for mouse=1:length(Dir_Sleep_Ctrl{1}.path)
    Dir.Ctrl{mouse}{1} = Dir_Sleep_Ctrl{1}.path{mouse}{1} ;
end


States={'Sleep','Wake','NREM','REM_s_l_e_e_p','REM_t_o_t_a_l'};
window_size = 240; % in minutes
smootime = 1;

clear Prop_bin
for group=1:length(Drug_Group)
    disp(Drug_Group{group})
    for mouse=1:length(Dir.(Drug_Group{group}))
        try
            
            clear Wake Sleep SWSEpoch REMEpoch EKG Epoch EKG Vtsd
            load([Dir.(Drug_Group{group}){mouse}{1} 'SleepScoring_Accelero.mat'], 'Wake' , 'Sleep' , 'SWSEpoch' , 'REMEpoch', 'Epoch' , 'TotalNoiseEpoch')
            Wake = or(Wake , TotalNoiseEpoch);
            Tot = or(Epoch , TotalNoiseEpoch);
            
            for state=1:length(States)
                try
                    if state==1 % sleep
                        Epoch_to_use{1} = Sleep;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
                    elseif state==2 % wake
                        Epoch_to_use{1} = Wake;
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
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Sleep;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
                    elseif state==5 % REM over tot
                        Epoch_to_use{1} = REMEpoch;
                        Epoch_to_use{1} = and(Epoch_to_use{1} , intervalSet(0,window_size*60e4));
                        Epoch_to_use{2} = Tot;
                        Epoch_to_use{2} = and(Epoch_to_use{2} , intervalSet(0,window_size*60e4));
                    end
                    
                    Prop.(States{state}){group}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                    
                    for bin=1:window_size/10
                        Prop_bin.(States{state}){group}(mouse,bin) = ...
                            sum(DurationEpoch(and(Epoch_to_use{1} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))))/...
                            sum(DurationEpoch(and(Epoch_to_use{2} , intervalSet(10*(bin-1)*60e4,10*bin*60e4))));
                    end
                end
            end
            try, TotDur{group}(mouse) = sum(DurationEpoch(Epoch1{mouse,1}))/3600e4; end
        end
        disp(mouse)
    end
end


Cols2 = {'b','r','g'};
Cols = {[0 0 1],[1 0 0],[0 1 0]};
X = [1:3];
Legends = {'With CD1','No CD1','Ctrl'};

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
for state=[1 4 5]
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
    elseif state==4, ylabel('REM/total proportion'), end
    if state==1, legend(Legends{1},Legends{2},Legends{3}), end
    n=n+1;
end























