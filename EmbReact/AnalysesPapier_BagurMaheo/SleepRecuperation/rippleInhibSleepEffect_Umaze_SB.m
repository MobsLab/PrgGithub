%% Sleep analysis

clear all

% preliminary variables
Drug_Group={'RipInhib','RipControl'};
groupId = [7,8];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
sta = [3 2 4 5];
%
%
% % generate data
% for group=1:length(Drug_Group)
%     Mouse=Drugs_Groups_UMaze_BM(groupId(group));
%     for sess=1:length(Session_type)
%         [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] =...
%             MeanValuesPhysiologicalParameters_BM('all_saline',Mouse,lower(Session_type{sess}),'ripples','heartrate','heartratevar','ob_low','hpc_low');
%     end
% end

% or load the data
cd /media/nas7/ProjetEmbReact/DataEmbReact/PaperData
load('DataAnalyzeSleepPostRipInhib.mat')

%% analyses restricted to first hour
Epoch2 = Epoch1; Epoch3 = Epoch2;
n=1;
for group=1:length(Drug_Group)
    Mouse=Drugs_Groups_UMaze_BM(groupId(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            for state=1:2%length(States)
                
                if state==1 % sleep
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,3} , intervalSet(0,3600e4));
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,3};
                    Epoch_to_use{2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,1} , intervalSet(0,3600e4));
                elseif state==2 % wake
                    Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,2} , intervalSet(0,3600e4));
                    Epoch_to_use{1} = Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,2};
                    Epoch_to_use{2} = and(Epoch2.(Session_type{sess}).(Drug_Group{group}){mouse,1} , intervalSet(0,3600e4));
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
            %    TotDur.(Session_type{sess}){n}(mouse) = sum(DurationEpoch(Epoch3.(Session_type{sess}).(Drug_Group{group}){mouse,1}))/3600e;
            state = 1;
            SFI.(Session_type{sess}){n} = EpNumb.(States{state}).(Session_type{sess}){n}./ MeanDur.(States{state}).(Session_type{sess}){n};
            TotSleep.(Session_type{sess}){n} = Prop.(States{state}).(Session_type{sess}){n};
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
MakeSpreadAndBoxPlot3_SB(Prop.(States{state}).(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('sleep proportion')

subplot(122)
MakeSpreadAndBoxPlot3_SB(MeanDur.(States{state}).(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('sleep mean duration (s)')
set(gca,'YScale','log')


% SFI
figure
MakeSpreadAndBoxPlot3_SB(SFI.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Sleep fragmentation index (a.u.)')

% TotSleep
figure
MakeSpreadAndBoxPlot3_SB(TotSleep.(Session_type{sess}),Cols2,X2,Legends2,'showpoints',1,'paired',0);
ylabel('Sleep proportion')


% Latency to state

LatencyToState.Sleep.sleep_pre{1}(LatencyToState.Sleep.sleep_pre{1}==0) = NaN;
LatencyToState.Sleep.sleep_post{1}(LatencyToState.Sleep.sleep_post{1}==0) = NaN;
LatencyToState.Sleep.sleep_pre{2}(LatencyToState.Sleep.sleep_pre{2}==0) = NaN;
LatencyToState.Sleep.sleep_post{2}(LatencyToState.Sleep.sleep_post{2}==0) = NaN;

sleepdur = [20:20:400];
Lim = 10;% don't take all points, some data missing for some mice
% subplot(211)
% errorbar(sleepdur(1:Lim),nanmean(LatencyToState.Sleep.sleep_pre{1}(:,1:Lim)),stdError(LatencyToState.Sleep.sleep_pre{1}(:,1:Lim)),'color',Cols2{1})
% hold on
% errorbar(sleepdur(1:Lim),nanmean(LatencyToState.Sleep.sleep_pre{2}(:,1:Lim)),stdError(LatencyToState.Sleep.sleep_pre{2}(:,1:Lim)),'color',Cols2{2})
% 
% subplot(212)

figure
errorbar(sleepdur(1:Lim),nanmean(LatencyToState.Sleep.sleep_post{1}(:,1:Lim))/60,stdError(LatencyToState.Sleep.sleep_post{1}(:,1:Lim))/60,'color',Cols2{1})
hold on
errorbar(sleepdur(1:Lim),nanmean(LatencyToState.Sleep.sleep_post{2}(:,1:Lim))/60,stdError(LatencyToState.Sleep.sleep_post{2}(:,1:Lim))/60,'color',Cols2{2})
makepretty
xlim([0 220])
xlabel('Min sleep duration')
ylim([0 40])
ylabel('Latency (min)')


%% Variables in time
val=60;
clear Prop
n=1;
for group=1:length(Drug_Group)
%     subplot(1,2,group)
    Mouse=Drugs_Groups_UMaze_BM(groupId(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=2% Correct to check preslep stt
            thr = mouse;
            Tot = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
            Wake = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,2};
            SWSEpoch = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4};
            REMEpoch = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,5};
                    
            for i = 1:9
                LitEpoch = intervalSet((i-1)*60*10*1E4,i*60*10*1E4);
                if sum(DurationEpoch(and(Tot,LitEpoch)))/1E4 >590
                    [~,Prop{group}.Wake(i,mouse)] = DurationEpoch(and(Wake,LitEpoch));
                    [~,Prop{group}.SWS(i,mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch));
                    [~,Prop{group}.REM(i,mouse)] = DurationEpoch(and(REMEpoch,LitEpoch));
                else
                    Prop{group}.Wake(i,mouse) = NaN;
                    Prop{group}.SWS(i,mouse) = NaN;
                    Prop{group}.REM(i,mouse) = NaN;
                    
                end
            end
            
%             
%             
%             line([begin endin],[thr thr],'linewidth',10,'color','w')
%             
%             clear sleepstart sleepstop
%             sleepstart=Start(Wake);
%             sleepstop=Stop(Wake);
%             for k=1:length(sleepstart)
%                 line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','b','linewidth',5);
%             end
%             
%             clear sleepstart sleepstop
%             sleepstart=Start(SWSEpoch);
%             sleepstop=Stop(SWSEpoch);
%             for k=1:length(sleepstart)
%                 line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','r','linewidth',5);
%             end
%             
%             clear sleepstart sleepstop
%             sleepstart=Start(REMEpoch);
%             sleepstop=Stop(REMEpoch);
%             for k=1:length(sleepstart)
%                 line([sleepstart(k)/(val*1e4) sleepstop(k)/(val*1e4)],[thr thr],'color','g','linewidth',5);
%             end
%             
%             xlim([0 60])

            
            
        end
        
    end
end

 Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
Legends = {'RipControl','RipInhib'};
NoLegends = {'',''};

timebins = 5:10:85;
for i = 1:2ddd
    Prop{i}.Wake = smooth2a(Prop{i}.Wake/600E4,1,0);
    Prop{i}.SWS = smooth2a(Prop{i}.SWS/600E4,1,0);
    Prop{i}.REM = smooth2a(Prop{i}.REM/600E4,1,0);
end

    
    figure

subplot(311)
errorbar(timebins,nanmean(Prop{1}.Wake'),stdError(Prop{1}.Wake'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(Prop{2}.Wake'),stdError(Prop{2}.Wake'),'color',Cols{2})
makepretty
xlabel('time(s)')
ylabel('Prop WAKE')
xlim([0 90])

subplot(312)
errorbar(timebins,nanmean(Prop{1}.SWS'),stdError(Prop{1}.SWS'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(Prop{2}.SWS'),stdError(Prop{2}.SWS'),'color',Cols{2})
makepretty
xlabel('time(s)')
ylabel('Prop NREM')
xlim([0 90])

subplot(313)
errorbar(timebins,nanmean(Prop{1}.REM'),stdError(Prop{1}.REM'),'color',Cols{1})
hold on
errorbar(timebins,nanmean(Prop{2}.REM'),stdError(Prop{2}.REM'),'color',Cols{2})
makepretty
xlabel('time(s)')
ylabel('Prop REM')
xlim([0 90])
