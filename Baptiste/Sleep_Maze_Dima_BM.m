

clear all, close all
SpeedLim = 2;

Dir = PathForExperimentsERC('UMazePAG');
mice_PAG_neurons = [905,906,911,994,1161,1162,1168,1182,1186,1230,1239];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
sta = [3 2 4 5];
mouse=1;

for ff = 1:length(Dir.name)
    if ismember(eval(Dir.name{ff}(6:end)),mice_PAG_neurons)
        cd(Dir.path{ff}{1})
        disp(Dir.path{ff}{1})
        
        try, load('SleepScoring_OBGamma.mat','Sleep','Wake','SWSEpoch','REMEpoch'), catch, load('SleepScoring_Accelero.mat','Sleep','Wake','SWSEpoch','REMEpoch'), end
        load('behavResources.mat', 'SessionEpoch')
        
        SleepEpoch{1} = SessionEpoch.PreSleep;
        SleepEpoch{2} = SessionEpoch.PostSleep;
        
        for sess=1:2
            for state=1:length(States)
                
                if state==1 % sleep
                    Epoch_to_use{1} = and(Sleep , SleepEpoch{sess}); Epoch_to_use{2} = SleepEpoch{sess};
                elseif state==2 % wake
                    Epoch_to_use{1} = and(Wake , SleepEpoch{sess}); Epoch_to_use{2} = SleepEpoch{sess};
                elseif state==3 % NREM
                    Epoch_to_use{1} = and(SWSEpoch , SleepEpoch{sess}); Epoch_to_use{2} = and(Sleep , SleepEpoch{sess});
                elseif state==4 % REM
                    Epoch_to_use{1} = and(REMEpoch , SleepEpoch{sess}); Epoch_to_use{2} = and(Sleep , SleepEpoch{sess});
                end
                
                Prop.(States{state}).(Session_type{sess})(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                MeanDur.(States{state}).(Session_type{sess})(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                MedianDur.(States{state}).(Session_type{sess})(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                EpNumb.(States{state}).(Session_type{sess})(mouse) = length(Start(Epoch_to_use{1}));
                try
                    LatencyToState_pre.(States{state}).(Session_type{sess}){mouse} = Start(Epoch_to_use{1})/1e4;
                    State_Duration.(States{state}).(Session_type{sess}){mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                    LatencyToState.(States{state}).(Session_type{sess})(mouse) = LatencyToState_pre.(States{state}).(Session_type{sess}){mouse}(find(State_Duration.(States{state}).(Session_type{sess}){mouse}>20,1));
                end
                
                % OB Low
                load('B_Low_Spectrum.mat')
                OB_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
                OB_Low.(States{state}).(Session_type{sess})(mouse,:) = Restrict(OB_Sp_tsd , Epoch_to_use{1});
                % HPC Low
                load('H_Low_Spectrum.mat')
                HPC_Sp_tsd = tsd(Spectro{2}*1e4 , Spectro{1});
                HPC_Low.(States{state}).(Session_type{sess})(mouse,:) = Restrict(HPC_Sp_tsd , Epoch_to_use{1});
                
            end
            SFI.(Session_type{sess}) = EpNumb.(States{2}).(Session_type{sess})./(sum(DurationEpoch(and(Sleep , SleepEpoch{sess})))/3600e4);
            
            load('SWR.mat')
            RipplesDensity.(Session_type{sess})(mouse) = length(Range(tRipples))/(sum(DurationEpoch(and(SWSEpoch , SleepEpoch{sess})))/1e4);
            
            TotDur.(Session_type{sess})(mouse) = sum(DurationEpoch(SleepEpoch{sess}))/3600e4;
        end
        mouse=mouse+1;
    end
end


%% figures
Cols = {[1 0 0],[0 0 1]};
X = [1:2];
Legends = {'Sleep Pre','Sleep Post'};
NoLegends = {'',''};

for state=1:4
    figure
    
    subplot(131)
    MakeSpreadAndBoxPlot3_SB({Prop.(States{state}).(Session_type{1}) Prop.(States{state}).(Session_type{2})},Cols,X,Legends,'showpoints',0,'paired',1);
    title('Proportion'); 
    if state==2; ylim([0 1]); elseif state==3;  ylim([.78 1]); elseif state==4; ylim([0 .21]); end
    ylabel('proportion')
    
    subplot(132)
    MakeSpreadAndBoxPlot3_SB({MeanDur.(States{state}).(Session_type{1}) MeanDur.(States{state}).(Session_type{2})},Cols,X,Legends,'showpoints',0,'paired',1);
    title('Mean duration'); 
    ylabel('time (s)')
    
    subplot(133)
    MakeSpreadAndBoxPlot3_SB({EpNumb.(States{state}).(Session_type{1}) EpNumb.(States{state}).(Session_type{2})},Cols,X,Legends,'showpoints',0,'paired',1);
    title('Episodes number'); 
    ylabel('#')
    
    a=suptitle(States{state}); a.FontSize=20;
end

figure
MakeSpreadAndBoxPlot3_SB({TotDur.sleep_pre TotDur.sleep_post},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 6]), ylabel('time (h)'), title('Sleep Pre')


figure
MakeSpreadAndBoxPlot3_SB({RipplesDensity.sleep_pre RipplesDensity.sleep_post},Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.2 .95]), ylabel('ripples occurence (#/s)'), title('Sleep Pre')


figure
MakeSpreadAndBoxPlot3_SB({SFI.(Session_type{1}) SFI.(Session_type{2})},Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Sleep fragmentation index (a.u.)')



