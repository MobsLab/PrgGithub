
%%

%% Sleep analysis

clear all

% preliminary variables
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline','RipInhib2','Diazepam','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Group=[13 15];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
sta = [3 2 4 5];

% generate data
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:length(Session_type) 
        [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] =...
            MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples','heartrate','heartratevar','ob_low','hpc_low');
    end
end

% gather them
n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            for state=1:length(States)
                
                if state==1 % sleep
                    Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3}; Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                elseif state==2 % wake
                    Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,2}; Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
                elseif state==3 % NREM
                    Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4}; Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                elseif state==4 % REM
                    Epoch_to_use{1} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,5}; Epoch_to_use{2} = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                end
                
                Prop.(States{state}).(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                MeanDur.(States{state}).(Session_type{sess}){n}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                MedianDur.(States{state}).(Session_type{sess}){n}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                EpNumb.(States{state}).(Session_type{sess}){n}(mouse) = length(Start(Epoch_to_use{1}));
                try
                    LatencyToState_pre.(States{state}).(Session_type{sess}){n}{mouse} = Start(Epoch_to_use{1})/1e4;
                    State_Duration.(States{state}).(Session_type{sess}){n}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                    LatencyToState.(States{state}).(Session_type{sess}){n}(mouse) = LatencyToState_pre.(States{state}).(Session_type{sess}){n}{mouse}(find(State_Duration.(States{state}).(Session_type{sess}){n}{mouse}>20,1));
                end
                
                % HR
                HR.(States{state}).(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartrate.tsd{mouse,1} , Epoch_to_use{1})));
                % HRVar
                HRVar.(States{state}).(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).heartratevar.tsd{mouse,1} , Epoch_to_use{1})));
                % OB Low
                OB_Low.(States{state}).(Session_type{sess}){n}(mouse,:) = OutPutData.(Session_type{sess}).(Drug_Group{group}).ob_low.mean(mouse,sta(state),:);
                % HPC Low
                HPC_Low.(States{state}).(Session_type{sess}){n}(mouse,:) = OutPutData.(Session_type{sess}).(Drug_Group{group}).hpc_low.mean(mouse,sta(state),:);
                
            end
            try
                RipplesDensity.(Session_type{sess}){n}(mouse) = length(Range(OutPutData.(Session_type{sess}).(Drug_Group{group}).ripples.ts{mouse,4}))/(sum(DurationEpoch(Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4}))/1e4);
            catch
                RipplesDensity.(Session_type{sess}){n}(mouse) = NaN;
            end
            TotDur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1}))/3600e4;
                  
            SFI.(Session_type{sess}){n} = EpNumb.(States{state}).(Session_type{sess}){n}./(sum(DurationEpoch(Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,3}))/3600e4);

        end
    end
    n=n+1;
end

Prop.Sleep.sleep_pre{3}(3)=NaN;
for state=1:length(States)
    Prop.(States{state}).sleep_pre{1}([1 2 9])=NaN;
    MeanDur.(States{state}).sleep_pre{1}([1 2 9])=NaN;
    EpNumb.(States{state}).sleep_pre{1}([1 2 9])=NaN;
end
SFI.(Session_type{1}){1}([1 2 9])=NaN;


for n=1:4
    for sess=1:2
        for state=1:length(States)
            HR_Ratio.(States{state}){n} = HR.(States{state}).sleep_post{n}./HR.(States{state}).sleep_pre{n};
            HRVar_Ratio.(States{state}){n} = HRVar.(States{state}).sleep_post{n}./HRVar.(States{state}).sleep_pre{n};
        end
    end
end



%% figures
Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098]};
X = [1:2];
Legends = {'Saline','DZP'};
NoLegends = {'',''};

for state=2:4
    figure
    for sess=1:2
        subplot(2,3,1+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(Prop.(States{state}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Proportion'); end
        if state==2; ylim([0 1]); elseif state==3;  ylim([.78 1]); elseif state==4; ylim([0 .21]); end
        ylabel('proportion')
        
        subplot(2,3,2+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(MeanDur.(States{state}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Mean duration'); end
        ylabel('time (s)')
        
        subplot(2,3,3+(sess-1)*3)
        MakeSpreadAndBoxPlot3_SB(EpNumb.(States{state}).(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
        if sess==1; title('Episodes number'); end
        ylabel('#')
    end
    a=suptitle(States{state}); a.FontSize=20;
end

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(TotDur.sleep_pre,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 6]), ylabel('time (h)'), title('Sleep Pre')

subplot(122)
MakeSpreadAndBoxPlot3_SB(TotDur.sleep_post,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([0 6]), ylabel('time (h)'), title('Sleep Post')


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(RipplesDensity.sleep_pre,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.2 .95]), ylabel('ripples occurence (#/s)'), title('Sleep Pre')

subplot(122)
MakeSpreadAndBoxPlot3_SB(RipplesDensity.sleep_post,Cols,X,Legends,'showpoints',1,'paired',0);
ylim([.2 .95]), ylabel('ripples occurence (#/s)'), title('Sleep Post')



figure
for state=1:length(States)
    subplot(2,4,state)
    MakeSpreadAndBoxPlot3_SB(HR_Ratio.(States{state}),Cols,X,Legends,'showpoints',1,'paired',0);

    subplot(2,4,state+4)
    MakeSpreadAndBoxPlot3_SB(HRVar_Ratio.(States{state}),Cols,X,Legends,'showpoints',1,'paired',0);
end

figure
MakeSpreadAndBoxPlot3_SB(HR_Ratio.(States{2})(3:4),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('HR frequency Wake (sleep post/sleep pre)')
hline(1,'--r')


Color_to_use = {'r','b'};

figure
for state=1:length(States)
    for n=1:4
        subplot(4,4,(state-1)*4+n)
        for sess=1:2
            [~ , MaxPowerValues{state}{sess}{n} , Freq_Max{state}{sess}{n}] = Plot_MeanSpectrumForMice_BM(OB_Low.(States{state}).(Session_type{sess}){n} , 'Color' , Color_to_use{sess}, 'threshold' , 26);
            xlim([0 10])
        end
    end
end

figure
for state=1:length(States)
    for n=1:4
        subplot(4,4,(state-1)*4+n)
        for sess=1:2
            [~ , MaxPowerValues2{state}{sess}{n} , Freq_Max2{state}{sess}{n}] = Plot_MeanSpectrumForMice_BM(HPC_Low.(States{state}).(Session_type{sess}){n} , 'Color' , Color_to_use{sess}, 'threshold' , 26);
        end
    end
end


figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({MaxPowerValues{4}{2}{3}./MaxPowerValues{4}{1}{3} MaxPowerValues{4}{2}{4}./MaxPowerValues{4}{1}{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power (sleep post)/(sleep pre)')
subplot(122)
MakeSpreadAndBoxPlot3_SB({Freq_Max{4}{2}{3} Freq_Max{4}{2}{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power (sleep post)/(sleep pre)')


figure
subplot(121)
MakeSpreadAndBoxPlot4_SB({([MaxPowerValues{4}{2}{1} MaxPowerValues{4}{2}{3}])./([MaxPowerValues{4}{1}{1} MaxPowerValues{4}{1}{3}])},{[1 0 0]},[1],{'saline'},'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power during REM (sleep post)/(sleep pre)')

subplot(122)
MakeSpreadAndBoxPlot3_SB({MaxPowerValues{4}{2}{3}./MaxPowerValues{4}{1}{3} MaxPowerValues{4}{2}{4}./MaxPowerValues{4}{1}{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power during REM (sleep post)/(sleep pre)')



figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({MaxPowerValues2{4}{2}{3}./MaxPowerValues2{4}{1}{3} MaxPowerValues2{4}{2}{4}./MaxPowerValues2{4}{1}{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power (sleep post)/(sleep pre)')
subplot(122)
MakeSpreadAndBoxPlot3_SB({Freq_Max2{4}{2}{3}./Freq_Max2{4}{1}{3} Freq_Max2{4}{2}{4}./Freq_Max2{4}{1}{4}},Cols2,X2,Legends2,'showpoints',1,'paired',0);
hline(1,'--r')
ylabel('OB power (sleep post)/(sleep pre)')





%% more precise for rip inhib
Epoch2 = Epoch1; Epoch3 = Epoch2;

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            for state=1:2%length(States)
                
                if state==1 % sleep
%                     Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,3} , intervalSet(0,3600e4));
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = mergeCloseIntervals(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} , 2e4);
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = dropShortIntervals(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} , 20e4);
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3}; Epoch_to_use{2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,1} , intervalSet(0,3600e4));
                elseif state==2 % wake
%                     Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,2} , intervalSet(0,3600e4));
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} = mergeCloseIntervals(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} , 2e4);
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} = dropShortIntervals(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} , 5e4);
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2}; Epoch_to_use{2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,1} , intervalSet(0,3600e4));
                elseif state==3 % NREM
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,4}; Epoch_to_use{2} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                elseif state==4 % REM
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,5}; Epoch_to_use{2} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                end
                
                Prop.(States{state}).(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Epoch_to_use{1}))/sum(DurationEpoch(Epoch_to_use{2}));
                MeanDur.(States{state}).(Session_type{sess}){n}(mouse) = nanmean(DurationEpoch(Epoch_to_use{1}))/1e4;
                MedianDur.(States{state}).(Session_type{sess}){n}(mouse) = nanmedian(DurationEpoch(Epoch_to_use{1}))/1e4;
                EpNumb.(States{state}).(Session_type{sess}){n}(mouse) = length(Start(Epoch_to_use{1}));
                try
                    LatencyToState_pre.(States{state}).(Session_type{sess}){n}{mouse} = Start(Epoch_to_use{1})/1e4;
                    State_Duration.(States{state}).(Session_type{sess}){n}{mouse} = DurationEpoch(Epoch_to_use{1})/1e4;
                    j=1;
                    for i=20:20:400
                        LatencyToState.(States{state}).(Session_type{sess}){n}(mouse,j) = LatencyToState_pre.(States{state}).(Session_type{sess}){n}{mouse}(find(State_Duration.(States{state}).(Session_type{sess}){n}{mouse}>i,1));
                        j=j+1;
                    end
                end
                
            end
            try
                RipplesDensity.(Session_type{sess}){n}(mouse) = length(Range(OutPutData.(Session_type{sess}).(Drug_Group{group}).ripples.ts{mouse,3}))/(sum(DurationEpoch(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3}))/1e4);
            catch
                RipplesDensity.(Session_type{sess}){n}(mouse) = NaN;
            end
            %    TotDur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,1}))/3600e4;
            %% CAREFUL THE LINE BELOW HAS A MISTAKE!!! --> his is not generally how we define sleep fragmentation, here you are calculatin /duration
            %% And stateis not redefined as 3
            SFI.(Session_type{sess}){n} = EpNumb.(States{state}).(Session_type{sess}){n}./(sum(DurationEpoch(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3}))/3600e4);
        end
    end
    Rip_corr{n} = RipplesDensity.sleep_post{n}./RipplesDensity.sleep_pre{n};
    
    n=n+1;
end


Cols2 = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X2 = [1:2];
Legends2 = {'RipControl','RipInhib'};
NoLegends2 = {'',''};

sess=2; state=1;
figure
subplot(121)
MakeSpreadAndBoxPlot3_SB(Prop.(States{state}).(Session_type{sess})(3:4),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('sleep proportion')

subplot(122)
MakeSpreadAndBoxPlot3_SB(MeanDur.(States{state}).(Session_type{sess})(3:4),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('sleep mean duration (s)')
set(gca,'YScale','log')


% SFI
figure
MakeSpreadAndBoxPlot3_SB(SFI.(Session_type{2})(3:4),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Sleep fragmentation index (a.u.)')

figure
MakeSpreadAndBoxPlot3_SB({SFI.(Session_type{1}){3} SFI.(Session_type{2}){3}},{[1 0 0],[0 0 1]},[1 2],{'sleep pre','sleep post'},'showpoints',1,'paired',0);
ylabel('Sleep fragmentation index (a.u.)')




figure
for i=1:20
    subplot(3,7,i)
    MakeSpreadAndBoxPlot3_SB({LatencyToState.(States{state}).(Session_type{sess}){3}(:,i) LatencyToState.(States{state}).(Session_type{sess}){4}(:,i)},Cols2,X2,Legends2,'showpoints',1,'paired',0);
end



figure
for mouse=1:10
    subplot(2,10,mouse)
    hist(State_Duration.(States{1}).(Session_type{2}){3}{mouse},30), xlim([0 1e3]), ylim([0 20])
    subplot(2,10,mouse+10)
    hist(State_Duration.(States{1}).(Session_type{2}){4}{mouse},30), xlim([0 1e3]), ylim([0 20])
end





%% Sleep
GetEmbReactMiceFolderList_BM
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','RipSham','RipInhib','PAG','All_eyelid','All_saline','Elisa','Saline_short','Saline2','DZP_short','DZP2','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','Sal_Maze1_1stMaze','Sal_Maze4_1stMaze','DZP_Maze1_1stMaze','DZP_Maze4_1stMaze'};
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','NREM','REM'};
Group=[13 15 7 8];


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        for sess=1:2
            cd(UMazeSleepSess.(Mouse_names{mouse}){sess})
            
            clear Wake SWSEpoch REMEpoch Sleep Epoch tRipples
            load('StateEpochSB.mat', 'Wake' , 'SWSEpoch' , 'REMEpoch' , 'Sleep' , 'Epoch');
            
            try; load('SWR.mat','tRipples'); end
            Sleep_prop.(Mouse_names{mouse})(sess) = sum(Stop(Sleep)-Start(Sleep))/sum(Stop(Epoch)-Start(Epoch));
            Sleep_MeanDur.(Mouse_names{mouse})(sess) = nanmean(DurationEpoch(Sleep))/1e4;
            Sleep_EpNumb.(Mouse_names{mouse})(sess) = length(Start(Sleep));
            
            NREM_prop.(Mouse_names{mouse})(sess) = sum(Stop(SWSEpoch)-Start(SWSEpoch))/sum(Stop(Sleep)-Start(Sleep));
            NREM_MeanDur.(Mouse_names{mouse})(sess) = nanmean(DurationEpoch(SWSEpoch))/1e4;
            NREM_EpNumb.(Mouse_names{mouse})(sess) = length(Start(SWSEpoch));
            
            REM_prop.(Mouse_names{mouse})(sess) = sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
            REM_MeanDur.(Mouse_names{mouse})(sess) = nanmean(DurationEpoch(REMEpoch))/1e4;
            REM_EpNumb.(Mouse_names{mouse})(sess) = length(Start(REMEpoch));
            
            try
                Ripples_density.(Mouse_names{mouse})(sess) = length(Range(Restrict(tRipples,SWSEpoch)))/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
            catch
                Ripples_density.(Mouse_names{mouse})(sess) = NaN;
            end
        end
    end
end

n=1;
for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=1:2
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Prop_all.(States{1}).(Session_type{sess}){n}(mouse) = Sleep_prop.(Mouse_names{mouse})(sess);
            Sleep_MeanDur_all.(Session_type{sess}){n}(mouse) = Sleep_MeanDur.(Mouse_names{mouse})(sess);
            Sleep_EpNumb_all.(Session_type{sess}){n}(mouse) = Sleep_EpNumb.(Mouse_names{mouse})(sess);
            
            Prop_all.(States{1}).(Session_type{sess}){n}(mouse) = NREM_prop.(Mouse_names{mouse})(sess);
            NREM_MeanDur_all.(Session_type{sess}){n}(mouse) = NREM_MeanDur.(Mouse_names{mouse})(sess);
            NREM_EpNumb_all.(Session_type{sess}){n}(mouse) = NREM_EpNumb.(Mouse_names{mouse})(sess);
            
            Prop_all.(States{1}).(Session_type{sess}){n}(mouse) = REM_prop.(Mouse_names{mouse})(sess);
            REM_MeanDur_all.(Session_type{sess}){n}(mouse) = REM_MeanDur.(Mouse_names{mouse})(sess);
            REM_EpNumb_all.(Session_type{sess}){n}(mouse) = REM_EpNumb.(Mouse_names{mouse})(sess);
            
            Ripples_density_all.(Session_type{sess}){n}(mouse) = Ripples_density.(Mouse_names{mouse})(sess);
            
        end
        %         REM_prop_all.(Session_type{sess}){1}([1:3 6 7])=NaN;
        %         REM_prop_all.(Session_type{sess}){2}([1:2])=NaN;
        %         Ripples_density_all.(Session_type{sess}){1}([1:3 6 7])=NaN;
        %         Ripples_density_all.(Session_type{sess}){2}([1:2])=NaN;
    end
    n=n+1;
end



Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:4];
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

figure
for sess=1:2
    subplot(2,3,1+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(Sleep_prop_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    if sess==1; title('Sleep proportion'); u=text(-1,.3,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    if sess==2; u=text(-1,.3,'Sleep Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90); end
    ylim([0 .9])
    ylabel('proportion')
    
    subplot(2,3,2+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(REM_prop_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([0 .17])
    if sess==1; title('REM proportion'); end
    ylabel('proportion')
    
    subplot(2,3,3+(sess-1)*3)
    MakeSpreadAndBoxPlot3_SB(Ripples_density_all.(Session_type{sess}),Cols,X,Legends,'showpoints',1,'paired',0);
    ylim([0 1.5])
    if sess==1; title('Ripples density'); end
    ylabel('Frequency (Hz)')
end


Mouse=[1266,1267,1268,1269,1304,1305,1349,1350,1351,1352 , 41266,41268,41269,41305,41349,41350,41351,41352];
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    REM_Prop_All_SleepPost(mouse) = REM_prop.(Drug_Group{group}).(Mouse_names{mouse})(2);
end

cd('/media/nas6/ProjetEmbReact/DataEmbReact'); load('Stim_VHC_numb.mat'); RealStimEpoch_All(3)=NaN;


figure
subplot(131)
PlotCorrelations_BM(RealStimEpoch_All , REM_Prop_All_SleepPost ,30,0,'k')
title('all mice, n=18'); ylabel('REM (%)'); xlabel('VHC stims (#)')
subplot(132)
PlotCorrelations_BM(RealStimEpoch_All(1:5) , REM_Prop_All_SleepPost(1:5) , 30,0,'k')
title('rip inhib mice, n=10'); ylabel('REM (%)'); xlabel('VHC stims (#)')
subplot(133)
PlotCorrelations_BM(RealStimEpoch_All(6:8) ,REM_Prop_All_SleepPost(6:8) , 30,0,'k')
title('control mice, n=8'); ylabel('REM (%)'); xlabel('VHC stims (#)')

a=suptitle('%REM = f(VHC stims #)'); a.FontSize=20;

