

%% Acute fluoxetine mice
Mouse=[688,739,777,779,849,893,1096,1224,1225,1226,   740,750,775,778,794];
Session_type={'sleep_pre','sleep_post'};
Drug_Group={'SalineSB','AcuteFlx'};

for sess=1:length(Session_type) 
    [OutPutData2.(Session_type{sess}) , Epoch2.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples');
end
Epoch2_original=Epoch2;

Epoch2=Epoch2_original;

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        Long_Sleep = dropShortIntervals(Epoch2.(Session_type{sess}){mouse,3} , 30e4); % wake > 30s
        Start_Long_Sleep = Start(Long_Sleep);
        
        Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(Start_Long_Sleep(1) , max(Stop(Epoch2.(Session_type{sess}){mouse,1})));
        Epoch_Before_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) = intervalSet(0 , Start_Long_Sleep(1));
        for cond=1:8
            Epoch2.(Session_type{sess}){mouse,cond} = and(Epoch2.(Session_type{sess}){mouse,cond} , Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}));
        end
        Epoch_Before_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch_Before_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(Epoch_Before_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4;
        Epoch_After_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}))-Start(Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse})))/60e4;
        Sleep_Before_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(and(Epoch_Before_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,3}))-Start(and(Epoch_Before_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,3})))/60e4;
        Sleep_After_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(and(Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,3}))-Start(and(Epoch_After_FirstSleep_Epoch.(Session_type{sess}).(Mouse_names{mouse}) , Epoch2.(Session_type{sess}){mouse,3})))/60e4;
    end
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        
        % Episodes number : Wake = density per hour, NREM/REM = density per sleep hour
        Wake_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,2})-Start(Epoch2.(Session_type{sess}){mouse,2}))/sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}));
        Wake_Start.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch2.(Session_type{sess}){mouse,2}))/(sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}))/3600e4);
        Wake_MeanDuration.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Epoch2.(Session_type{sess}){mouse,2})-Start(Epoch2.(Session_type{sess}){mouse,2}))/1e4;
        
        REM_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,5})-Start(Epoch2.(Session_type{sess}){mouse,5}))/sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3}));
        REM_prop_All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,5})-Start(Epoch2.(Session_type{sess}){mouse,5}))/sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}));
        REM_Start.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch2.(Session_type{sess}){mouse,5}))/(sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3}))/3600e4);
        REM_MeanDuration.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Epoch2.(Session_type{sess}){mouse,5})-Start(Epoch2.(Session_type{sess}){mouse,5}))/1e4;
        
        NREM_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3}));
        NREM_prop_All.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}));
        NREM_Start.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Epoch2.(Session_type{sess}){mouse,4}))/(sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3}))/3600e4);
        NREM_MeanDuration.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/1e4;

        Theta_prop.(Session_type{sess}).(Mouse_names{mouse}) = sum(Stop(or(Epoch2.(Session_type{sess}){mouse,2} , Epoch2.(Session_type{sess}){mouse,5}))-Start(or(Epoch2.(Session_type{sess}){mouse,2} , Epoch2.(Session_type{sess}){mouse,5})))/sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}));
        Theta_Start.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(or(Epoch2.(Session_type{sess}){mouse,2} , Epoch2.(Session_type{sess}){mouse,5})))/(sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}))/3600e4);
        Theta_MeanDuration.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(or(Epoch2.(Session_type{sess}){mouse,2} , Epoch2.(Session_type{sess}){mouse,5}))-Start(or(Epoch2.(Session_type{sess}){mouse,2} , Epoch2.(Session_type{sess}){mouse,5})))/1e4;
        
        % NREM - Wake transitions
        [aft_cell.(Session_type{sess}).(Mouse_names{mouse}),bef_cell.(Session_type{sess}).(Mouse_names{mouse})]=transEpoch(Epoch2.(Session_type{sess}){mouse,4} , Epoch2.(Session_type{sess}){mouse,2});
        
        NREM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        NREM_AfterWake.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        Wake_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        Wake_AfterNREM.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        
        Wake_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(NREM_AfterWake.(Session_type{sess}).(Mouse_names{mouse})));
        NREM_Wake_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Wake_AfterNREM.(Session_type{sess}).(Mouse_names{mouse})));
        
        Wake_NREM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = Wake_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);
        NREM_Wake_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = Wake_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);

        NREM_BeforeWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(NREM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        NREM_AfterWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(NREM_AfterWake.(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_AfterWake.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        Wake_BeforeNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Wake_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(Wake_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        Wake_AfterNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Wake_AfterNREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(Wake_AfterNREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        
        % NREM - REM transitions
        [aft_cell2.(Session_type{sess}).(Mouse_names{mouse}),bef_cell2.(Session_type{sess}).(Mouse_names{mouse})]=transEpoch(Epoch2.(Session_type{sess}){mouse,4},Epoch2.(Session_type{sess}){mouse,5});
        
        NREM_BeforeREM.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell2.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        NREM_AfterREM.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell2.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        REM_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell2.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        REM_AfterNREM.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell2.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        
        REM_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(NREM_AfterREM.(Session_type{sess}).(Mouse_names{mouse})));
        NREM_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(REM_AfterNREM.(Session_type{sess}).(Mouse_names{mouse})));
        
        REM_NREM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = REM_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);
        NREM_REM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = NREM_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);

        NREM_BeforeREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(NREM_BeforeREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_BeforeREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        NREM_AfterREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(NREM_AfterREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(NREM_AfterREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        REM_BeforeNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(REM_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        REM_AfterNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(REM_AfterNREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_AfterNREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
               
        % REM - Wake transitions
        [aft_cell3.(Session_type{sess}).(Mouse_names{mouse}),bef_cell3.(Session_type{sess}).(Mouse_names{mouse})]=transEpoch(Epoch2.(Session_type{sess}){mouse,5},Epoch2.(Session_type{sess}){mouse,2});
        
        REM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell3.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        REM_AfterWake.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell3.(Session_type{sess}).(Mouse_names{mouse}){1,2};
        Wake_BeforeREM.(Session_type{sess}).(Mouse_names{mouse}) = aft_cell3.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        Wake_AfterREM.(Session_type{sess}).(Mouse_names{mouse}) = bef_cell3.(Session_type{sess}).(Mouse_names{mouse}){2,1};
        
        Wake_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(REM_AfterWake.(Session_type{sess}).(Mouse_names{mouse})));
        REM_Wake_Transitions.(Session_type{sess}).(Mouse_names{mouse}) = length(Start(Wake_AfterREM.(Session_type{sess}).(Mouse_names{mouse})));
        
        Wake_REM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = Wake_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);
        REM_Wake_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse}) = REM_Wake_Transitions.(Session_type{sess}).(Mouse_names{mouse})/(sum(Stop(Epoch2.(Session_type{sess}){mouse,4})-Start(Epoch2.(Session_type{sess}){mouse,4}))/3600e4);

        REM_BeforeWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(REM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        REM_AfterWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(REM_AfterWake.(Session_type{sess}).(Mouse_names{mouse}))-Start(REM_AfterWake.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        Wake_BeforeREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Wake_BeforeREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(Wake_BeforeREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        Wake_AfterREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse}) = nanmean(Stop(Wake_AfterREM.(Session_type{sess}).(Mouse_names{mouse}))-Start(Wake_AfterREM.(Session_type{sess}).(Mouse_names{mouse})))/1e4;
        
        TotalTransitions.(Session_type{sess}).(Mouse_names{mouse}) = (length(Start(Epoch2.(Session_type{sess}){mouse,4})) + length(Start(Epoch2.(Session_type{sess}){mouse,5})) + length(Start(Epoch2.(Session_type{sess}){mouse,2})))/(sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1}))/3600e4);
    end
end


for group=1:length(Drug_Group)
    
    if group==1 % saline & MDZ mice
        Mouse=[688,739,777,779,849,893,1096,1224,1225,1226];
    elseif group==2 % Acute Flx
        Mouse=[740,750,775,778,794];
    end
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Wake_prop.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_prop.(Session_type{sess}).(Mouse_names{mouse});
            Wake_Start.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_Start.(Session_type{sess}).(Mouse_names{mouse});
            Wake_MeanDuration.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_MeanDuration.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_prop.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_prop.(Session_type{sess}).(Mouse_names{mouse});
            REM_prop_All.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_prop_All.(Session_type{sess}).(Mouse_names{mouse});
            REM_Start.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_Start.(Session_type{sess}).(Mouse_names{mouse});
            REM_MeanDuration.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_MeanDuration.(Session_type{sess}).(Mouse_names{mouse});
            
            NREM_prop.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_prop.(Session_type{sess}).(Mouse_names{mouse});
            NREM_prop_All.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_prop_All.(Session_type{sess}).(Mouse_names{mouse});
            NREM_Start.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_Start.(Session_type{sess}).(Mouse_names{mouse});
            NREM_MeanDuration.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_MeanDuration.(Session_type{sess}).(Mouse_names{mouse});            
            
            Theta_prop.(Drug_Group{group}).(Session_type{sess})(mouse) = Theta_prop.(Session_type{sess}).(Mouse_names{mouse});
            Theta_Start.(Drug_Group{group}).(Session_type{sess})(mouse) = Theta_Start.(Session_type{sess}).(Mouse_names{mouse});
            Theta_MeanDuration.(Drug_Group{group}).(Session_type{sess})(mouse) = Theta_MeanDuration.(Session_type{sess}).(Mouse_names{mouse});
          
            % NREM - Wake transitions
            NREM_BeforeWake.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse});
            NREM_AfterWake.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_AfterWake.(Session_type{sess}).(Mouse_names{mouse});
            Wake_BeforeNREM.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse});
            Wake_AfterNREM.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_AfterNREM.(Session_type{sess}).(Mouse_names{mouse});
            
            Wake_NREM_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            NREM_Wake_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_Wake_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            
            Wake_NREM_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_NREM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            NREM_Wake_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_Wake_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            
            NREM_BeforeWake_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_BeforeWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            NREM_AfterWake_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_AfterWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            Wake_BeforeNREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_BeforeNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            Wake_AfterNREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_AfterNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            
            % NREM - REM transitions
            NREM_BeforeREM.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_BeforeREM.(Session_type{sess}).(Mouse_names{mouse});
            NREM_AfterREM.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_AfterREM.(Session_type{sess}).(Mouse_names{mouse});
            REM_BeforeNREM.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_BeforeNREM.(Session_type{sess}).(Mouse_names{mouse});
            REM_AfterNREM.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_AfterNREM.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_NREM_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_NREM_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            NREM_REM_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_NREM_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_NREM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            NREM_REM_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_REM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            
            NREM_BeforeREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_BeforeREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            NREM_AfterREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = NREM_AfterREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            REM_BeforeNREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_BeforeNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            REM_AfterNREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_AfterNREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            
            % REM - Wake transitions
            REM_BeforeWake.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_BeforeWake.(Session_type{sess}).(Mouse_names{mouse});
            REM_AfterWake.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_AfterWake.(Session_type{sess}).(Mouse_names{mouse});
            Wake_BeforeREM.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_BeforeREM.(Session_type{sess}).(Mouse_names{mouse});
            Wake_AfterREM.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_AfterREM.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_Wake_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_Wake_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            Wake_REM_Transitions.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_REM_Transitions.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_Wake_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_Wake_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            Wake_REM_Transitions_PerNREM_Hour.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_REM_Transitions_PerNREM_Hour.(Session_type{sess}).(Mouse_names{mouse});
            
            REM_BeforeWake_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_BeforeWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            REM_AfterWake_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = REM_AfterWake_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            Wake_BeforeREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_BeforeREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            Wake_AfterREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(mouse) = Wake_AfterREM_MeanDur.(Session_type{sess}).(Mouse_names{mouse});
            
            
            TotalTransitions.(Drug_Group{group}).(Session_type{sess})(mouse) = TotalTransitions.(Session_type{sess}).(Mouse_names{mouse});
            
            Epoch_Before_FirstSleep_Epoch_Duration.(Drug_Group{group}).(Session_type{sess})(mouse) = Epoch_Before_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse});
            Epoch_After_FirstSleep_Epoch_Duration.(Drug_Group{group}).(Session_type{sess})(mouse) = Epoch_After_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse});
            Sleep_Before_FirstSleep_Epoch_Duration.(Drug_Group{group}).(Session_type{sess})(mouse) = Sleep_Before_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse});
            Sleep_After_FirstSleep_Epoch_Duration.(Drug_Group{group}).(Session_type{sess})(mouse) = Sleep_After_FirstSleep_Epoch_Duration.(Session_type{sess}).(Mouse_names{mouse});
        end
        NREM_BeforeWake_MeanDur.(Drug_Group{group}).(Session_type{sess})(NREM_BeforeWake_MeanDur.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
        NREM_BeforeREM_MeanDur.(Drug_Group{group}).(Session_type{sess})(NREM_BeforeREM_MeanDur.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
    end
end

%% Figures
Cols={[0 0 1],[1 .5 .5]};
X=[1:2];
Legends={'Saline','Acute Flx'};
NoLegends={'',''};

% Basic checks
figure
subplot(141)
MakeSpreadAndBoxPlot2_SB({Epoch_Before_FirstSleep_Epoch_Duration.SalineSB.sleep_post Epoch_Before_FirstSleep_Epoch_Duration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('time (min)')
title('Time before sleep onset')
ylim([0 85])
subplot(142)
MakeSpreadAndBoxPlot2_SB({Sleep_Before_FirstSleep_Epoch_Duration.SalineSB.sleep_post Sleep_Before_FirstSleep_Epoch_Duration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 85])
title('Sleep time before sleep onset')
subplot(143)
MakeSpreadAndBoxPlot2_SB({Epoch_After_FirstSleep_Epoch_Duration.SalineSB.sleep_post Epoch_After_FirstSleep_Epoch_Duration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 85])
title('Time after sleep onset')
subplot(144)
MakeSpreadAndBoxPlot2_SB({Sleep_After_FirstSleep_Epoch_Duration.SalineSB.sleep_post Sleep_After_FirstSleep_Epoch_Duration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 85])
title('Sleep time after sleep onset')

a=suptitle('Working epochs definition, Saline=10, Acute Flx=5'); a.FontSize=20;


%% Main state features
% REM
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_post REM_prop.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Proportion')
subplot(132)
MakeSpreadAndBoxPlot2_SB({REM_Start.SalineSB.sleep_post REM_Start.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Episode number')
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_MeanDuration.SalineSB.sleep_post REM_MeanDuration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Mean duration')
a=suptitle('REM'); a.FontSize=20;

% Wake
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Wake_prop.SalineSB.sleep_post Wake_prop.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Proportion')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Wake_Start.SalineSB.sleep_post Wake_Start.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Episode number')
subplot(133)
MakeSpreadAndBoxPlot2_SB({Wake_MeanDuration.SalineSB.sleep_post Wake_MeanDuration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Mean duration')
a=suptitle('Wake'); a.FontSize=20;

% NREM
figure
subplot(141)
MakeSpreadAndBoxPlot2_SB({NREM_prop_All.SalineSB.sleep_post NREM_prop_All.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Session proportion')
ylim([0 .94])
subplot(142)
MakeSpreadAndBoxPlot2_SB({NREM_prop.SalineSB.sleep_post NREM_prop.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Sleep proportion')
ylim([0 1.02])
subplot(143)
MakeSpreadAndBoxPlot2_SB({NREM_Start.SalineSB.sleep_post NREM_Start.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Episode number')
ylim([0 40])
subplot(144)
MakeSpreadAndBoxPlot2_SB({NREM_MeanDuration.SalineSB.sleep_post NREM_MeanDuration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Mean duration')
ylim([0 190])
    
a=suptitle('NREM'); a.FontSize=20;

% Theta state
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Theta_prop.SalineSB.sleep_post Theta_prop.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Proportion')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Theta_Start.SalineSB.sleep_post Theta_Start.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Episode number')
subplot(133)
MakeSpreadAndBoxPlot2_SB({Theta_MeanDuration.SalineSB.sleep_post Theta_MeanDuration.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Mean duration')
a=suptitle('Theta state'); a.FontSize=20;


% Correlations
figure
subplot(121)
PlotCorrelations_BM(Wake_prop.SalineSB.sleep_post , REM_prop_All.SalineSB.sleep_post,20,0,'r')
axis square
subplot(122)
PlotCorrelations_BM(Wake_prop.AcuteFlx.sleep_post , REM_prop_All.AcuteFlx.sleep_post,20,0,'r')
axis square

%% Transitions & proba
% Transitions
figure
subplot(171)
MakeSpreadAndBoxPlot2_SB({TotalTransitions.SalineSB.sleep_post TotalTransitions.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Total transitions')
ylim([0 65])
subplot(172)
MakeSpreadAndBoxPlot2_SB({REM_NREM_Transitions_PerNREM_Hour.SalineSB.sleep_post REM_NREM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM-NREM density')
ylim([0 40])
subplot(173)
MakeSpreadAndBoxPlot2_SB({NREM_REM_Transitions_PerNREM_Hour.SalineSB.sleep_post NREM_REM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('NREM-REM density')
ylim([0 40])
subplot(174)
MakeSpreadAndBoxPlot2_SB({Wake_NREM_Transitions_PerNREM_Hour.SalineSB.sleep_post Wake_NREM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake-NREM density')
ylim([0 40])
subplot(175)
MakeSpreadAndBoxPlot2_SB({NREM_Wake_Transitions_PerNREM_Hour.SalineSB.sleep_post NREM_Wake_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('NREM-Wake density')
ylim([0 40])
subplot(176)
MakeSpreadAndBoxPlot2_SB({REM_Wake_Transitions_PerNREM_Hour.SalineSB.sleep_post REM_Wake_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM-Wake density')
ylim([0 40])
subplot(177)
MakeSpreadAndBoxPlot2_SB({Wake_REM_Transitions_PerNREM_Hour.SalineSB.sleep_post Wake_REM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake-REM density')
ylim([0 40])

a=suptitle('Transitions study'); a.FontSize=20;


% Probabilities
figure
subplot(121)
MakeSpreadAndBoxPlot2_SB({NREM_REM_Transitions_PerNREM_Hour.SalineSB.sleep_post./(NREM_REM_Transitions_PerNREM_Hour.SalineSB.sleep_post + NREM_Wake_Transitions_PerNREM_Hour.SalineSB.sleep_post) NREM_REM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post./(NREM_REM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post + NREM_Wake_Transitions_PerNREM_Hour.AcuteFlx.sleep_post)} , {[0 0 1],[1 .5 .5]} , [1:2],{'Saline','Acute Flx'},'showpoints',1,'paired',0);
ylim([0 1.1])
title('P(NREM --> REM)')
subplot(122)
MakeSpreadAndBoxPlot2_SB({REM_NREM_Transitions_PerNREM_Hour.SalineSB.sleep_post./(REM_NREM_Transitions_PerNREM_Hour.SalineSB.sleep_post + REM_Wake_Transitions_PerNREM_Hour.SalineSB.sleep_post) REM_NREM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post./(REM_NREM_Transitions_PerNREM_Hour.AcuteFlx.sleep_post + REM_Wake_Transitions_PerNREM_Hour.AcuteFlx.sleep_post)} , {[0 0 1],[1 .5 .5]} , [1:2],{'Saline','Acute Flx'},'showpoints',1,'paired',0);
ylim([0 1.1])
title('P(REM --> NREM)')

a=suptitle('Probabilities study'); a.FontSize=20;


%% After/Before state
% NREM before/after something
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB({NREM_BeforeWake_MeanDur.SalineSB.sleep_post NREM_BeforeREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'NREM bef Wake','NREM bef REM'},'showpoints',0,'paired',1);
title('Saline features')
ylabel('time (s)')
ylim([0 400])
xtickangle(20)

subplot(232)
MakeSpreadAndBoxPlot2_SB({NREM_BeforeWake_MeanDur.SalineSB.sleep_post NREM_BeforeWake_MeanDur.AcuteFlx.sleep_post} , Cols,X,NoLegends,'showpoints',1,'paired',0);
title('NREM before Wake')
ylim([0 400])

subplot(233)
MakeSpreadAndBoxPlot2_SB({NREM_BeforeREM_MeanDur.SalineSB.sleep_post NREM_BeforeREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,NoLegends,'showpoints',1,'paired',0);
title('NREM before REM')
ylim([0 400])


subplot(234)
MakeSpreadAndBoxPlot2_SB({NREM_AfterWake_MeanDur.SalineSB.sleep_post NREM_AfterREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'NREM after Wake','NREM after REM'},'showpoints',0,'paired',1);
title('Sleep Post features')
ylabel('time (s)')
ylim([0 450])
xtickangle(20)

subplot(235)
MakeSpreadAndBoxPlot2_SB({NREM_AfterWake_MeanDur.SalineSB.sleep_post NREM_AfterWake_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('NREM after Wake')
ylim([0 450])

subplot(236)
MakeSpreadAndBoxPlot2_SB({NREM_AfterREM_MeanDur.SalineSB.sleep_post NREM_AfterREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('NREM after REM')
ylim([0 450])

a=suptitle('NREM features'); a.FontSize=20;


% REM before/after something
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB({REM_BeforeWake_MeanDur.SalineSB.sleep_post REM_BeforeNREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'REM bef Wake','REM bef NREM'},'showpoints',0,'paired',1);
title('Sleep Post features')
ylabel('time (s)')
ylim([0 160])
xtickangle(20)

subplot(232)
MakeSpreadAndBoxPlot2_SB({REM_BeforeWake_MeanDur.SalineSB.sleep_post REM_BeforeWake_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM before Wake')
ylim([0 160])

subplot(233)
MakeSpreadAndBoxPlot2_SB({REM_BeforeNREM_MeanDur.SalineSB.sleep_post REM_BeforeNREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM before NREM')
ylim([0 160])


subplot(234)
MakeSpreadAndBoxPlot2_SB({zeros(1,10) REM_AfterNREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'REM bef Wake','REM bef NREM'},'showpoints',0,'paired',1);
title('Sleep Post features')
ylabel('time (s)')
ylim([0 70])
xtickangle(20)

subplot(235)
MakeSpreadAndBoxPlot2_SB({REM_AfterWake_MeanDur.SalineSB.sleep_post REM_AfterWake_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM after Wake')
ylim([0 70])

subplot(236)
MakeSpreadAndBoxPlot2_SB({REM_AfterNREM_MeanDur.SalineSB.sleep_post REM_AfterNREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('REM after NREM')
ylim([0 70])

a=suptitle('REM features'); a.FontSize=20;


% Wake before/after something
figure
subplot(231)
MakeSpreadAndBoxPlot2_SB({zeros(1,10) Wake_BeforeNREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'Wake bef REM','Wake bef NREM'},'showpoints',0,'paired',1);
title('Sleep Post features')
ylabel('time (min)')
ylim([0 60])
xtickangle(20)

subplot(232)
MakeSpreadAndBoxPlot2_SB({Wake_BeforeREM_MeanDur.SalineSB.sleep_post Wake_BeforeREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake before REM')
ylim([0 60])

subplot(233)
MakeSpreadAndBoxPlot2_SB({Wake_BeforeNREM_MeanDur.SalineSB.sleep_post Wake_BeforeNREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake before NREM')
ylim([0 60])


subplot(234)
MakeSpreadAndBoxPlot2_SB({Wake_AfterREM_MeanDur.SalineSB.sleep_post Wake_AfterNREM_MeanDur.SalineSB.sleep_post} , {[.5 .5 1],[0 1 0]},[1 2],{'Wake aft REM','Wake aft NREM'},'showpoints',0,'paired',1);
title('Sleep Post features')
ylabel('time (min)')
ylim([0 60])

subplot(235)
MakeSpreadAndBoxPlot2_SB({Wake_AfterREM_MeanDur.SalineSB.sleep_post Wake_AfterREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake after REM')
ylim([0 60])

subplot(236)
MakeSpreadAndBoxPlot2_SB({Wake_AfterNREM_MeanDur.SalineSB.sleep_post Wake_AfterNREM_MeanDur.AcuteFlx.sleep_post} , Cols,X,Legends,'showpoints',1,'paired',0);
title('Wake after NREM')
ylim([0 60])

a=suptitle('Wake features'); a.FontSize=20;


Cols1={[0 0 1],[1  0 0],[.5 .5 1],[1 .5 .5]};
X=[1:2];
Legends={'Saline','Acute Flx'};
NoLegends={'',''}


% Compare REM and Wake 
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Wake_MeanDuration.SalineSB.sleep_post Wake_MeanDuration.AcuteFlx.sleep_post REM_MeanDuration.SalineSB.sleep_post REM_MeanDuration.AcuteFlx.sleep_post} , {[0 0 1],[1  0 0],[.5 .5 1],[1 .5 .5]} , [1:4],{'Wake, Saline','Wake, Acute Flx','REM, Saline','REM, Acute Flx'},'showpoints',1,'paired',0);
ylabel('time (s)')
title('Overview')
subplot(132)
MakeSpreadAndBoxPlot2_SB({Wake_AfterREM_MeanDur.SalineSB.sleep_post Wake_AfterREM_MeanDur.AcuteFlx.sleep_post Wake_AfterNREM_MeanDur.SalineSB.sleep_post Wake_AfterNREM_MeanDur.AcuteFlx.sleep_post   REM_AfterNREM_MeanDur.SalineSB.sleep_post REM_AfterNREM_MeanDur.AcuteFlx.sleep_post} , {[0 0 1],[1 .5 .5],[.3 .3 1],[1 .8 .8],[0 0 1],[1 .5 .5]},[1:6],{'Wake aft REM, Saline','Wake aft REM, Acute Flx','Wake aft NREM, Saline','Wake aft NREM, Acute Flx','REM, Saline','REM, Acute Flx'},'showpoints',1,'paired',0);
title('Epochs after something')
vline(4.5,'--k')
subplot(133)
MakeSpreadAndBoxPlot2_SB({Wake_BeforeNREM_MeanDur.SalineSB.sleep_post Wake_BeforeNREM_MeanDur.AcuteFlx.sleep_post   REM_BeforeNREM_MeanDur.SalineSB.sleep_post REM_BeforeNREM_MeanDur.AcuteFlx.sleep_post REM_BeforeWake_MeanDur.SalineSB.sleep_post REM_BeforeWake_MeanDur.AcuteFlx.sleep_post} , {[0 0 1],[1 .5 .5],[.3 .3 1],[1 .8 .8],[0 0 1],[1 .5 .5]},[1:6],{'Wake bef NREM, Saline','Wake bef NREM, Acute Flx','REM bef NREM, Saline','REM bef NREM, Acute Flx','REM bef Wake, Saline','REM bef Wake, Acute Flx'},'showpoints',1,'paired',0);
title('Epochs before something')
vline(2.5,'--k')

a=suptitle('Theta states features'); a.FontSize=20;






% Midazolam and sleep structure: Sleeping more
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({Wake_MeanDuration.SalineSB.sleep_post(1:7) Wake_MeanDuration.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);
subplot(132)
MakeSpreadAndBoxPlot2_SB({NREM_MeanDuration.SalineSB.sleep_post(1:7) NREM_MeanDuration.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);
subplot(133)
MakeSpreadAndBoxPlot2_SB({REM_MeanDuration.SalineSB.sleep_post(1:7) REM_MeanDuration.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);

figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_post(1:7) REM_prop.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);
subplot(132)
MakeSpreadAndBoxPlot2_SB({NREM_prop.SalineSB.sleep_post(1:7) NREM_prop.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);
subplot(133)
MakeSpreadAndBoxPlot2_SB({Wake_prop.SalineSB.sleep_post(1:7) Wake_prop.SalineSB.sleep_post(8:14)} , {[0 0 1],[0 1 0]},[1:2],{'Saline','Midazolam'},'showpoints',1,'paired',0);



%% others
% Look at transitions if differences
GetEmbReactMiceFolderList_BM

Mouse=[829,851,857,858,859,1005,1006,688,739,777,779,849,893,1096,740,750,775,778,794];
Session_type={'sleep_pre','sleep_post'};
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:2
        if sess==1
            cd(SleepSess.(Mouse_names{mouse}){1})
        else
            cd(SleepSess.(Mouse_names{mouse}){end})
        end
        
        load('StateEpochSB.mat', 'smooth_ghi', 'SWSEpoch','REMEpoch', 'Wake','Sleep','smooth_Theta')
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,Wake);
        NREM_Before_Wake = aft_cell{1,2};
        NREM_After_Wake = bef_cell{1,2};
        [aft_cell,bef_cell]=transEpoch(SWSEpoch,REMEpoch);
        NREM_Before_REM = aft_cell{1,2};
        NREM_After_REM = bef_cell{1,2};
        
        h=histogram(log(Data(Restrict(smooth_ghi , Wake))),'NumBins',1000);
        Y_tot.(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
        Y_tot.(Session_type{sess}).(Mouse_names{mouse}) = Y_tot.(Session_type{sess}).(Mouse_names{mouse})/sum(Y_tot.(Session_type{sess}).(Mouse_names{mouse}));
        [dip.(Session_type{sess}).(Mouse_names{mouse}),xl,xu, ifault, gcm, lcm, mn, mj] = HartigansDipTest(Data(Restrict(smooth_ghi , Wake)));
        
        Long_Sleep = dropShortIntervals(Sleep , 30e4); % wake > 30s
        Start_Long_Sleep = Start(Long_Sleep);
        Epoch_After_FirstSleep_Epoch = intervalSet(Start_Long_Sleep(1) , max(Range(smooth_ghi)));
        Epoch_Before_FirstSleep_Epoch = intervalSet(min(Range(smooth_ghi)) , Start_Long_Sleep(1));
        Start_Wake_AfterFirstSleep = Start(and(Wake , Epoch_After_FirstSleep_Epoch));
        Start_Wake_BeforeFirstSleep = Start(and(Wake , Epoch_Before_FirstSleep_Epoch));
        Wake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(Wake , Epoch_After_FirstSleep_Epoch);
        REM_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(REMEpoch , Epoch_After_FirstSleep_Epoch);
        NREM_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(SWSEpoch , Epoch_After_FirstSleep_Epoch);
        NREM_BeforeREM_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(NREM_Before_REM , Epoch_After_FirstSleep_Epoch);
        NREM_BeforeWake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(NREM_Before_Wake , Epoch_After_FirstSleep_Epoch);
        NREM_AfterREM_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(NREM_After_REM , Epoch_After_FirstSleep_Epoch);
        NREM_AfterWake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}) = and(NREM_After_Wake , Epoch_After_FirstSleep_Epoch);
        
        for ep = 1:length(Start_Wake_AfterFirstSleep)
            MeanGamma_DuringWake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_ghi , subset(and(Wake , Epoch_After_FirstSleep_Epoch) , ep));
            TransitionEpoch = intervalSet(Start_Wake_AfterFirstSleep(ep)-10e4 , Start_Wake_AfterFirstSleep(ep)+10e4);
            Gamma_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_ghi , TransitionEpoch);
            Theta_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_Theta , TransitionEpoch);
            clear TransitionEpoch
        end
        for ep = 1:length(Start_Wake_BeforeFirstSleep)
            MeanGamma_DuringWake_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_ghi , subset(and(Wake , Epoch_Before_FirstSleep_Epoch) , ep));
            TransitionEpoch = intervalSet(Start_Wake_BeforeFirstSleep(ep)-10e4 , Start_Wake_BeforeFirstSleep(ep)+10e4);
            Gamma_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_ghi , TransitionEpoch);
            Theta_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})(ep) = Restrict(smooth_Theta , TransitionEpoch);
            clear TransitionEpoch
        end
        
        clear Long_Sleep Start_Long_Sleep Epoch_After_FirstSleep_Epoch Epoch_Before_FirstSleep_Epoch Start_Wake_BeforeFirstSleep
    end
end


for group=1:2
    
    if group==1 % saline & MDZ mice
        Mouse=[688,739,777,779,849,893,1096,829,851,857,858,859,1005,1006];
    elseif group==2 % Acute Flx
        Mouse=[740,750,775,778,794];
    end
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Y_tot.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Y_tot.(Session_type{sess}).(Mouse_names{mouse});
            dip.(Drug_Group{group}).(Session_type{sess})(mouse) = dip.(Session_type{sess}).(Mouse_names{mouse});
            
            MeanGamma_DuringWake_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(MeanGamma_DuringWake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(MeanGamma_DuringWake_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            MeanGamma_DuringWake_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(MeanGamma_DuringWake_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(MeanGamma_DuringWake_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            Gamma_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(Gamma_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(Gamma_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            Theta_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(Theta_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(Theta_At_Wake_Transitions_AfterFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            Gamma_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(Gamma_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(Gamma_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            Theta_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(mouse , 1:length(Data(Theta_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse})))) = Data(Theta_At_Wake_Transitions_BeforeFirstSleep.(Session_type{sess}).(Mouse_names{mouse}));
            
            MeanGamma_DuringWake_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(MeanGamma_DuringWake_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            MeanGamma_DuringWake_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(MeanGamma_DuringWake_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            Gamma_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(Gamma_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            Theta_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})(Theta_At_Wake_Transitions_AfterFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            Gamma_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(Gamma_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
            Theta_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})(Theta_At_Wake_Transitions_BeforeFirstSleep.(Drug_Group{group}).(Session_type{sess})==0) = NaN;
        end
    end
end

% Plot gamma values during wake
figure
subplot(121)
group=1; sess=1;
Conf_Inter=nanstd(Y_tot.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(Y_tot.(Drug_Group{group}).(Session_type{sess}),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Y_tot.(Drug_Group{group}).(Session_type{sess}));
shadedErrorBar([1:1000] , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) , '-b',1); hold on;
group=2;
Conf_Inter=nanstd(Y_tot.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(Y_tot.(Drug_Group{group}).(Session_type{sess}),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Y_tot.(Drug_Group{group}).(Session_type{sess}));
shadedErrorBar([1:1000] , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) , '-r',1); hold on;
makepretty; ylabel('#'); xlabel('power (a.u.)'); f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Acute Flx')
title('sleep pre')

subplot(122)
group=1; sess=2;
Conf_Inter=nanstd(Y_tot.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(Y_tot.(Drug_Group{group}).(Session_type{sess}),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Y_tot.(Drug_Group{group}).(Session_type{sess}));
shadedErrorBar([1:1000] , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) , '-b',1); hold on;
group=2; sess=2;
Conf_Inter=nanstd(Y_tot.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(Y_tot.(Drug_Group{group}).(Session_type{sess}),1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Y_tot.(Drug_Group{group}).(Session_type{sess}));
shadedErrorBar([1:1000] , runmean(Mean_All_Sp,50) , runmean(Conf_Inter,50) , '-r',1); hold on;
makepretty; xlabel('power (a.u.)')
title('sleep post')

a=suptitle('Gamma values distributions during wake, sleep sessions, UMaze'); a.FontSize=20;



% Mean gamma values during wake after first sleep
figure
MakeSpreadAndBoxPlot2_SB({nanmean(MeanGamma_DuringWake_AfterFirstSleep.SalineSB.sleep_pre') nanmean(MeanGamma_DuringWake_AfterFirstSleep.AcuteFlx.sleep_pre') nanmean(MeanGamma_DuringWake_AfterFirstSleep.SalineSB.sleep_post') nanmean(MeanGamma_DuringWake_AfterFirstSleep.AcuteFlx.sleep_post')} , Cols,X,Legends,'showpoints',1,'paired',0);

figure
plot(Gamma_At_Wake_Transitions_BeforeFirstSleep.SalineSB.sleep_post')


% Gamma values at wake transitions after sleep onset
figure
subplot(121)
Conf_Inter=nanstd(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre)/sqrt(size(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-b',1); hold on;
Conf_Inter=nanstd(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre)/sqrt(size(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-r',1); hold on;
makepretty; xticks([0 12500 25000]); xticklabels({'-10s','0','+ 10s'}); ylabel('gamma power (a.u.)')
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Acute Flx')
title('Sleep Pre')

subplot(122)
Conf_Inter=nanstd(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post)/sqrt(size(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Gamma_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-b',1); hold on;
Conf_Inter=nanstd(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post)/sqrt(size(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Gamma_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-r',1); hold on;
makepretty; xticks([0 12500 25000]); xticklabels({'-10s','0','+ 10s'});
title('Sleep Post')

a=suptitle('Gamma values at wake transitions after sleep onset'); a.FontSize=20;


% Gamma values at wake transitions after sleep onset
figure
subplot(121)
Conf_Inter=nanstd(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre)/sqrt(size(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_pre);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-b',1); hold on;
Conf_Inter=nanstd(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre)/sqrt(size(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_pre);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-r',1); hold on;
makepretty; xticks([0 12500 25000]); xticklabels({'-10s','0','+ 10s'}); ylabel('gamma power (a.u.)')
f=get(gca,'Children'); legend([f(8),f(4)],'Saline','Acute Flx')
title('Sleep Pre')

subplot(122)
Conf_Inter=nanstd(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post)/sqrt(size(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Theta_At_Wake_Transitions_AfterFirstSleep.SalineSB.sleep_post);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-b',1); hold on;
Conf_Inter=nanstd(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post)/sqrt(size(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Theta_At_Wake_Transitions_AfterFirstSleep.AcuteFlx.sleep_post);
shadedErrorBar([1:25000] , Mean_All_Sp , Conf_Inter , '-r',1); hold on;
makepretty; xticks([0 12500 25000]); xticklabels({'-10s','0','+ 10s'}); ylim([1 2.8])
title('Sleep Post')

a=suptitle('Theta values at wake transitions after sleep onset'); a.FontSize=20;




Mouse=[829,851,857,858,859,1005,1006,688,739,777,779,849,893,1096,740,750,775,778,794];

for mouse=1:15
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    subplot(3,5,mouse)
    histogram(NREM_BeforeWake_MeanDur.sleep_pre.(Mouse_names{mouse})/60e4,20)
    hold on
    histogram(NREM_BeforeREM_MeanDur.sleep_pre.(Mouse_names{mouse})/60e4,20)
end

figure
histogram(NREM_BeforeWake_MeanDur.SalineSB.sleep_pre/60e4 ,'BinLimits',[1 15],'NumBins',20)
hold on
histogram(NREM_BeforeREM_MeanDur.SalineSB.sleep_pre/60e4 ,'BinLimits',[1 15],'NumBins',20)

Cols={[0 0 1],[0 0 .8],[1 .5 .5],[1 .7 .7]};
X=[1:4];
Legends={'NREM bef Wake, Saline','NREM bef REM, Saline','NREM bef Wake, Acute Flx','NREM bef REM, Acute Flx'};

