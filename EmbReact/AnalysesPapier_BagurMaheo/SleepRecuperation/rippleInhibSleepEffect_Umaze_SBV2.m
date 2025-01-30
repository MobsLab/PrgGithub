%% Sleep analysis

clear all

% preliminary variables
Drug_Group={'RipControl','RipInhib',};
groupId = [7,8];
Session_type={'sleep_pre','sleep_post'};
States={'Sleep','Wake','NREM','REM'};
MergeForLatencyCalculation = [1,5,10,20:20:100];



% % generate data
% % Have to change inside the "MeanValuesPhysiologicalParameters_BM" code
% % sleepstate --> sleepstats_accelero
% for group=1:length(Drug_Group)
%     Mouse.(Drug_Group{group}) = Drugs_Groups_UMaze_BM(groupId(group));
%     for sess=1:length(Session_type)
%         [OutPutData.(Session_type{sess}).(Drug_Group{group}) , Epoch1.(Session_type{sess}).(Drug_Group{group}) , NameEpoch] =...
%             MeanValuesPhysiologicalParameters_BM('all_saline', Mouse.(Drug_Group{group}) ,lower(Session_type{sess}),'ripples');
%         %heartrate','heartratevar','ob_low','hpc_low
%     end
% end
% cd /media/nas7/ProjetEmbReact/DataEmbReact/PaperData
% save('DataAnalyzeSleepPostRipInhib_VF.mat','OutPutData','Epoch1','NameEpoch','Mouse','-v7.3')

% or load the data
cd /media/nas7/ProjetEmbReact/DataEmbReact/PaperData
load('DataAnalyzeSleepPostRipInhib_VF.mat')


clear Prop_time MeanDur_time EpNum_time Prop MeanDur EpNum
for group=1:length(Drug_Group)
    %     subplot(1,2,group)
    Mouse=Drugs_Groups_UMaze_BM(groupId(group));
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:2
            Tot = Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,1};
            Wake = and(Tot,Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,2});
            SWSEpoch = and(Tot,Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,4});
            REMEpoch = and(Tot,Epoch1.(Session_type{sess}).(Drug_Group{group}){mouse,5});
            
            %% Latency to sleep, dependant on how consolidated sleep is
            for merge_i=1:length(MergeForLatencyCalculation)
                LitEpo =dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4);
                if not(isempty(Start(LitEpo)))
                    LatencyToSleep.(Session_type{sess}).(Drug_Group{group})(mouse,merge_i) = min(Start(dropShortIntervals(SWSEpoch,MergeForLatencyCalculation(merge_i)*1e4),'s'));
                else
                    LatencyToSleep.(Session_type{sess}).(Drug_Group{group})(mouse,merge_i) = NaN;
                end
            end
            
            %% Variables averaged during the first hour
            LitEpoch = intervalSet(0,60*60*1e4);
            [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
            SleepRipples = Restrict(OutPutData.(Session_type{sess}).(Drug_Group{group}).ripples.ts{mouse,4},LitEpoch);
            if length(SleepRipples) == 0
                RipplesDensity.(Session_type{sess}).(Drug_Group{group})(mouse) = NaN;
            else
                RipplesDensity.(Session_type{sess}).(Drug_Group{group})(mouse) = length(Range(SleepRipples))/sum(DurationEpoch(and(SWSEpoch,LitEpoch)));
            end
            [AllDur_Wk,Prop.(Session_type{sess}){group}.Tot(mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.Tot(mouse) = Prop.(Session_type{sess}){group}.Tot(mouse)/DurLitEpo;
            
            [AllDur_Wk,Prop.(Session_type{sess}){group}.Wake(mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.Wake(mouse) = Prop.(Session_type{sess}){group}.Wake(mouse)/DurLitEpo;
            
            [AllDur_SWS,Prop.(Session_type{sess}){group}.SWS(mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.SWS(mouse) = Prop.(Session_type{sess}){group}.SWS(mouse)/DurLitEpo;
            [AllDur_REM,Prop.(Session_type{sess}){group}.REM(mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
            Prop.(Session_type{sess}){group}.REM(mouse) = Prop.(Session_type{sess}){group}.REM(mouse)/DurLitEpo;
            
            % Mean episode dur in the state
            MeanDur.(Session_type{sess}){group}.Wake(mouse) = nanmean(AllDur_Wk);
            MeanDur.(Session_type{sess}){group}.SWS(mouse) = nanmean(AllDur_SWS);
            MeanDur.(Session_type{sess}){group}.REM(mouse) = nanmean(AllDur_REM);
            
            % Number of episodes in the state
            EpNum.(Session_type{sess}){group}.Wake(mouse) = length(AllDur_Wk);
            EpNum.(Session_type{sess}){group}.SWS(mouse) = length(AllDur_SWS);
            EpNum.(Session_type{sess}){group}.REM(mouse) = length(AllDur_REM);
            
            %% Variables in time
            for i = 1:10
                LitEpoch = intervalSet((i-1)*60*10*1E4,i*60*10*1E4);
                if sum(DurationEpoch(and(Tot,LitEpoch)))/1E4 >590
                    [~,DurLitEpo] = DurationEpoch(LitEpoch,'s');
                    % Amount of time in the state
                    [AllDur_Tot,Prop_time.(Session_type{sess}){group}.Tot(i,mouse)] = DurationEpoch(and(Tot,LitEpoch),'s');
                    %                     Prop_time.(Session_type{sess}){group}.Tot(i,mouse) = Prop_time.(Session_type{sess}){group}.Tot(i,mouse)/DurLitEpo;
                    [AllDur_Wk,Prop_time.(Session_type{sess}){group}.Wake(i,mouse)] = DurationEpoch(and(Wake,LitEpoch),'s');
                    %                     Prop_time.(Session_type{sess}){group}.Wake(i,mouse) = Prop_time.(Session_type{sess}){group}.Wake(i,mouse)/DurLitEpo;
                    [AllDur_SWS,Prop_time.(Session_type{sess}){group}.SWS(i,mouse)] = DurationEpoch(and(SWSEpoch,LitEpoch),'s');
                    %                     Prop_time.(Session_type{sess}){group}.SWS(i,mouse) = Prop_time.(Session_type{sess}){group}.SWS(i,mouse)/DurLitEpo;
                    [AllDur_REM,Prop_time.(Session_type{sess}){group}.REM(i,mouse)] = DurationEpoch(and(REMEpoch,LitEpoch),'s');
                    %                     Prop_time.(Session_type{sess}){group}.REM(i,mouse) = Prop_time.(Session_type{sess}){group}.REM(i,mouse)/DurLitEpo;
                    
                    % Mean episode dur in the state
                    MeanDur_time.(Session_type{sess}){group}.Wake(i,mouse) = nanmean(AllDur_Wk);
                    MeanDur_time.(Session_type{sess}){group}.SWS(i,mouse) = nanmean(AllDur_SWS);
                    MeanDur_time.(Session_type{sess}){group}.REM(i,mouse) = nanmean(AllDur_REM);
                    
                    % Number of episodes in the state
                    EpNum_time.(Session_type{sess}){group}.Wake(i,mouse) = length(AllDur_Wk);
                    EpNum_time.(Session_type{sess}){group}.SWS(i,mouse) = length(AllDur_SWS);
                    EpNum_time.(Session_type{sess}){group}.REM(i,mouse) = length(AllDur_REM);
                    
                else
                    Prop_time.(Session_type{sess}){group}.Tot(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    Prop_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    MeanDur_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    MeanDur_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    MeanDur_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    EpNum_time.(Session_type{sess}){group}.Wake(i,mouse) = NaN;
                    EpNum_time.(Session_type{sess}){group}.SWS(i,mouse) = NaN;
                    EpNum_time.(Session_type{sess}){group}.REM(i,mouse) = NaN;
                    
                    
                end
            end
            
            
        end
        
    end
end



%% Figures

figure
% Plot in time
Cols = {[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = [1:2];
NoLegends = {'',''};
timebins = 5:10:(size(Prop_time.(Session_type{sess}){1}.Wake,1)*10);
LimitGoodMouse = 500; % at least 500s not in noise
clear TempProfile
for sess=1:2
    for i = 1:2
        TempProfile{i}.Tot = Prop_time.(Session_type{sess}){i}.Tot;
        TempProfile{i}.Wake = smooth2a(Prop_time.(Session_type{sess}){i}.Wake./TempProfile{i}.Tot,1,0);
%         TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),1,0);
%         TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.SWS+Prop_time.(Session_type{sess}){i}.REM),1,0);
        TempProfile{i}.SWS = smooth2a(Prop_time.(Session_type{sess}){i}.SWS./(Prop_time.(Session_type{sess}){i}.Tot),1,0);
        TempProfile{i}.REM = smooth2a(Prop_time.(Session_type{sess}){i}.REM./(Prop_time.(Session_type{sess}){i}.Tot),1,0);
        PropTimeFul{sess}(i,:) = nanmean( TempProfile{i}.Tot);
        MnWk{i}(sess,:) = nanmean(TempProfile{i}.REM);
%         % Get rid of mice without full sessions
%         TempProfile{i}.Tot(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
%         TempProfile{i}.Wake(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
%         TempProfile{i}.SWS(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
%         TempProfile{i}.REM(:, PropTimeFul{sess}(i,:) <LimitGoodMouse) = [];
    end
    
    
    subplot(3,2,1+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.Wake'),stdError(TempProfile{1}.Wake'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.Wake'),stdError(TempProfile{2}.Wake'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('Prop WAKE')
    xlim([0 90])
    
    subplot(3,2,3+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.SWS'),stdError(TempProfile{1}.SWS'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.SWS'),stdError(TempProfile{2}.SWS'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('Prop NREM')
    xlim([0 90])
    
    subplot(3,2,5+(sess-1))
    errorbar(timebins,nanmean(TempProfile{1}.REM'),stdError(TempProfile{1}.REM'),'color',Cols{1})
    hold on
    errorbar(timebins,nanmean(TempProfile{2}.REM'),stdError(TempProfile{2}.REM'),'color',Cols{2})
    makepretty
    xlabel('time(min)')
    ylabel('Prop REM')
    xlim([0 90])
end
legend(Drug_Group)

%%
figure
subplot(121)
errorbar(MergeForLatencyCalculation,nanmean(LatencyToSleep.sleep_pre.RipControl),stdError(LatencyToSleep.sleep_pre.RipControl),'k')
hold on
errorbar(MergeForLatencyCalculation,nanmean(LatencyToSleep.sleep_pre.RipInhib),stdError(LatencyToSleep.sleep_pre.RipInhib),'r')

legend(Drug_Group)
subplot(122)
errorbar(MergeForLatencyCalculation,nanmean(LatencyToSleep.sleep_post.RipControl),stdError(LatencyToSleep.sleep_post.RipControl),'k')
hold on
errorbar(MergeForLatencyCalculation,nanmean(LatencyToSleep.sleep_post.RipInhib),stdError(LatencyToSleep.sleep_post.RipInhib),'r')



%%
A = {LatencyToSleep.sleep_pre.RipControl(:,5),LatencyToSleep.sleep_pre.RipInhib(:,5)};
figure,MakeSpreadAndBoxPlot_BM(A,{},[],{},1,0)


%%
plot(MnWk{1}(1,[1,2,4,5,6,8,9,10]),MnWk{1}(2,[1,2,4,5,6,8,9,10]),'.')
makepretty
hold on
plot(MnWk{2}(1,:),MnWk{2}(2,:),'.')
makepretty
axis square
ylim(xlim)
line([0 1],[0 1])
legend(Drug_Group)

subplot(121)
A = {MnWk{1}(1,[1,2,4,5,6,8,9,10]),MnWk{1}(2,[1,2,4,5,6,8,9,10])};
MakeSpreadAndBoxPlot_BM(A,{},[],{},1,1)

subplot(122)
MakeSpreadAndBoxPlot_BM({MnWk{2}(1,:),MnWk{2}(2,:)},{},[],{},1,1)


subplot(122)
MakeSpreadAndBoxPlot_BM({MnWk{1}(2,[1,2,4,5,6,8,9,10]),MnWk{2}(2,:)},{},[],{},1,0)
