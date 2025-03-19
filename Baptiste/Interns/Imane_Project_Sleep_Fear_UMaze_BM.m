

%% Imane's codes
clear all
load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat') % behaviour data
load('/media/nas6/ProjetEmbReact/DataEmbReact/Imane_code_Data.mat') % physio/neuro data

% load spectrograms range 
cd('/media/nas4/ProjetEmbReact/Mouse688/20180209/ProjectEmbReact_M688_20180209_TestPre_PreDrug/TestPre2')
load('H_Low_Spectrum.mat'); RangeLow=Spectro{3};
load('B_Middle_Spectrum.mat'); RangeMiddle=Spectro{3};
load('B_High_Spectrum.mat'); RangeHigh=Spectro{3};
load('H_VHigh_Spectrum.mat'); RangeVHigh=Spectro{3};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','All','All_Saline','Saline_NoFlx'};

% Load all necessary sessions for mice
cd('/media/nas6/ProjetEmbReact/transfer')
load('Sess.mat')
GetEmbReactMiceFolderList_BM
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Session_type2={'sleep_pre','sleep_post'};
Mouse2=Mouse;
Type={'All','Shock','Safe','Ratio'};



%% generate data and epoch
% run only if you didn't load data
for sess=1:length(Session_type2) 
    [OutPutData.(Session_type2{sess}) , Epoch1.(Session_type2{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type2{sess}),'accelero');
end

% Transforming some variables
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    % Sleep data
    for sess=1:length(Session_type2)
        
        Sleep_TotalDur.(Session_type2{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type2{sess}){mouse,3})-Start(Epoch1.(Session_type2{sess}){mouse,3}))/1e4;
 
        REM_MeanDur.(Session_type2{sess}).(Mouse_names{mouse}) = (Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/1e4;
        REM_TotalDur.(Session_type2{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/1e4;
        Number_of_REM_Episodes.(Session_type2{sess}).(Mouse_names{mouse}) = length(Start(Epoch1.(Session_type2{sess}){mouse,5}));
       
        REM_prop.(Session_type2{sess}).(Mouse_names{mouse}) = sum(Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/sum(Stop(Epoch1.(Session_type2{sess}){mouse,3})-Start(Epoch1.(Session_type2{sess}){mouse,3}));
        LongREM_MeanDur.(Session_type2{sess}).(Mouse_names{mouse}) = REM_MeanDur.(Session_type2{sess}).(Mouse_names{mouse})(REM_MeanDur.(Session_type2{sess}).(Mouse_names{mouse})>15);

        [aft_cell.(Session_type2{sess}).(Mouse_names{mouse}) , bef_cell.(Session_type2{sess}).(Mouse_names{mouse})] = transEpoch(Epoch1.(Session_type2{sess}){mouse,5} , or(Epoch1.(Session_type2{sess}){mouse,4} , Epoch1.(Session_type2{sess}){mouse,2}));
        ind_to_use = ((Stop(bef_cell.(Session_type2{sess}).(Mouse_names{mouse}){2,1}) - Start(bef_cell.(Session_type2{sess}).(Mouse_names{mouse}){2,1}))/60e4)<2.5; % less than 3 minutes between REM episodes
        clear REM_Start_After_Other REM_Stop_After_Other
        REM_Start_Before_Other = Start(aft_cell.(Session_type2{sess}).(Mouse_names{mouse}){1,2});
        REM_Stop_Before_Other = Stop(aft_cell.(Session_type2{sess}).(Mouse_names{mouse}){1,2});

        Number_of_Sequential_REM_Episodes.(Session_type2{sess}).(Mouse_names{mouse}) = sum(ind_to_use);
        Number_of_Single_REM_Episodes.(Session_type2{sess}).(Mouse_names{mouse}) = sum(~ind_to_use);
        MeanDuration_of_Sequential_REM_Episodes.(Session_type2{sess}).(Mouse_names{mouse}) = nanmean(REM_Stop_Before_Other(ind_to_use)-REM_Start_Before_Other(ind_to_use))/1e4;
        MeanDuration_of_Single_REM_Episodes.(Session_type2{sess}).(Mouse_names{mouse}) = nanmean(REM_Stop_Before_Other(~ind_to_use)-REM_Start_Before_Other(~ind_to_use))/1e4;
        TotalDuration_Sequential_REM.(Session_type2{sess}).(Mouse_names{mouse}) = sum(REM_Stop_Before_Other(ind_to_use)-REM_Start_Before_Other(ind_to_use))/1e4;
        TotalDuration_Single_REM.(Session_type2{sess}).(Mouse_names{mouse}) = sum(REM_Stop_Before_Other(~ind_to_use)-REM_Start_Before_Other(~ind_to_use))/1e4;
        Sequential_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse}) = TotalDuration_Sequential_REM.(Session_type2{sess}).(Mouse_names{mouse})/Sleep_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
        Single_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse}) = TotalDuration_Single_REM.(Session_type2{sess}).(Mouse_names{mouse})/Sleep_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
        Sequential_REM_Proportion_inREM.(Session_type2{sess}).(Mouse_names{mouse}) = TotalDuration_Sequential_REM.(Session_type2{sess}).(Mouse_names{mouse})/REM_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
        Single_REM_Proportion_inREM.(Session_type2{sess}).(Mouse_names{mouse}) = TotalDuration_Single_REM.(Session_type2{sess}).(Mouse_names{mouse})/REM_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
                
    end
end

% Mice without HPC
for sess=1:length(Session_type2)
    for mouse=[30 31 32 38 39 42 43 49]
        REM_prop.(Session_type2{sess}).(Mouse_names{mouse}) = NaN;
        Sequential_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse}) = NaN;
        Single_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse}) = NaN;
    end
end

% REM diff
for mouse=1:length(Mouse)
    REM_diff.(Mouse_names{mouse}) = REM_prop.(Session_type2{1}).(Mouse_names{mouse}) - REM_prop.(Session_type2{2}).(Mouse_names{mouse});
    Sequential_REM_diff.(Mouse_names{mouse}) = Sequential_REM_Proportion.(Session_type2{1}).(Mouse_names{mouse}) - Sequential_REM_Proportion.(Session_type2{2}).(Mouse_names{mouse});
    Single_REM_diff.(Mouse_names{mouse}) = Single_REM_Proportion.(Session_type2{1}).(Mouse_names{mouse}) - Single_REM_Proportion.(Session_type2{2}).(Mouse_names{mouse});
end

% Gather for all saline
for group=1:length(Drug_Group)
    for sess=1:length(Session_type2)
        
        Drugs_Groups_UMaze2_BM
        
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            REM_prop.(Drug_Group{group}).(Session_type2{sess})(mouse) =  REM_prop.(Session_type2{sess}).(Mouse_names{mouse});
            REM_TotalDur.(Drug_Group{group}).(Session_type2{sess})(mouse) =  REM_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
            Sleep_TotalDur.(Drug_Group{group}).(Session_type2{sess})(mouse) =  Sleep_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
            Sleep_TotalDur.(Drug_Group{group}).(Session_type2{sess})(mouse) =  Sleep_TotalDur.(Session_type2{sess}).(Mouse_names{mouse});
            Proportion_of_REM_Episodes_Split_By_Less_Than_3min.(Drug_Group{group}).(Session_type2{sess})(mouse) = Proportion_of_REM_Episodes_Split_By_Less_Than_3min.(Session_type2{sess}).(Mouse_names{mouse});
            Number_of_Sequential_REM_Episodes.(Drug_Group{group}).(Session_type2{sess})(mouse) = Number_of_REM_Episodes_Split_By_Less_Than_3min.(Session_type2{sess}).(Mouse_names{mouse});
            Number_of_Single_REM_Episodes.(Drug_Group{group}).(Session_type2{sess})(mouse) = Number_of_REM_Episodes_Split_By_More_Than_3min.(Session_type2{sess}).(Mouse_names{mouse});
            MeanDuration_of_Sequential_REM_Episodes.(Drug_Group{group}).(Session_type2{sess})(mouse) = MeanDuration_of_REM_Episodes_Split_By_Less_Than_3min.(Session_type2{sess}).(Mouse_names{mouse});
            MeanDuration_of_Single_REM_Episodes.(Drug_Group{group}).(Session_type2{sess})(mouse) = MeanDuration_of_REM_Episodes_Split_By_More_Than_3min.(Session_type2{sess}).(Mouse_names{mouse});
            TotalDuration_Sequential_REM.(Drug_Group{group}).(Session_type2{sess})(mouse) = TotalDuration_Sequential_REM.(Session_type2{sess}).(Mouse_names{mouse});
            TotalDuration_Single_REM.(Drug_Group{group}).(Session_type2{sess})(mouse) = TotalDuration_Single_REM.(Session_type2{sess}).(Mouse_names{mouse});
            Sequential_REM_Proportion.(Drug_Group{group}).(Session_type2{sess})(mouse) = Sequential_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse});
            Single_REM_Proportion.(Drug_Group{group}).(Session_type2{sess})(mouse) = Single_REM_Proportion.(Session_type2{sess}).(Mouse_names{mouse});
            Sequential_REM_Proportion_inREM.(Drug_Group{group}).(Session_type2{sess})(mouse) = Sequential_REM_Proportion_inREM.(Session_type2{sess}).(Mouse_names{mouse});
            Single_REM_Proportion_inREM.(Drug_Group{group}).(Session_type2{sess})(mouse) = Single_REM_Proportion_inREM.(Session_type2{sess}).(Mouse_names{mouse});
            
            REM_diff.(Drug_Group{group})(mouse) =  REM_diff.(Mouse_names{mouse});
            Sequential_REM_diff.(Drug_Group{group})(mouse) =  Sequential_REM_diff.(Mouse_names{mouse});
            Single_REM_diff.(Drug_Group{group})(mouse) =  Single_REM_diff.(Mouse_names{mouse});
        end
    end
end


% Behaviour for good groups
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze2_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                FreezingProportion.All.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.All.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Ratio.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Ratio.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingProportion.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingProportion.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneOccupancy.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneOccupancy.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneOccupancy.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                OccupancyMeanTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                OccupancyMeanTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OccupancyMeanTime.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                StimNumb.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb.(Session_type{sess}).(Mouse_names{mouse});
                StimNumb_Blocked.(Drug_Group{group}).(Session_type{sess})(mouse,:) = StimNumb_Blocked.(Session_type{sess}).(Mouse_names{mouse});
                ExtraStim.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
                
                ZoneEntries.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse});
                ZoneEntries.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = ZoneEntries.Safe.(Session_type{sess}).(Mouse_names{mouse});
                
                Total_Time.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Total_Time.(Session_type{sess}).(Mouse_names{mouse});
                
                Latency.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Latency.Shock.(Session_type{sess}).(Mouse_names{mouse});
                
                FreezingTime.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Shock.(Session_type{sess}).(Mouse_names{mouse});
                FreezingTime.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = FreezingTime.Safe.(Session_type{sess}).(Mouse_names{mouse}) ;
                
                RA.(Drug_Group{group}).(Session_type{sess})(mouse) = RA.(Session_type{sess}).(Mouse_names{mouse});
                Stim_By_SZ_entries.(Drug_Group{group}).(Session_type{sess})(mouse) = ZoneEntries.Shock.(Session_type{sess}).(Mouse_names{mouse})./ExtraStim.(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end



%% Sequential & Single REM
edit Sequential_REM_Analysis_BM.m



%% Plot section %%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Cols2 = {[.8 .8 1],[1 .8 .8],[.8 1 .8]};
Cols = {[.6 .6 1],[1 .6 .6],[.6 1 .6]};

Legends ={'Saline' 'Flx chronique' 'Flx aigue'};
NoLegends ={'', '', ''};
X = [1:3];
%% I. Maze and behaviour
figure
subplot(141)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.All.SalineSB.TestPre*100 FreezingProportion.All.SalineSB.Cond*100}, {[.2 .2 .2],[.5 .5 .5]},[1:2] , {'Test Pre','Conditionnement' } ,'showpoints',0,'paired',1);
ylabel('Freezing (%)')
title('Proportion de freezing')

subplot(142)
MakeSpreadAndBoxPlot2_SB({RA.SalineSB.TestPre RA.SalineSB.Cond}, {[.2 .2 .2],[.5 .5 .5]},[1:2] , {'Test Pre','Conditionnement' } ,'showpoints',0,'paired',1);
ylabel('#/min')
title('Évaluation de risque')

subplot(143)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.SalineSB.TestPre*100 ZoneOccupancy.Safe.SalineSB.TestPre*100}, {[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]},[1:2] , {'Zone choc','Zone sans choc' } ,'showpoints',0,'paired',1);
ylabel('Exploration (%)')
title('Exploration en Test Pre')
ylim([0 110])

subplot(144)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Shock.SalineSB.TestPost*100 ZoneOccupancy.Safe.SalineSB.TestPost*100}, {[0.9290 0.6940 0.1250],[0.4940 0.1840 0.5560]},[1:2] , {'Zone choc','Zone sans choc' } ,'showpoints',0,'paired',1);
ylabel('Exploration (%)')
title('Exploration en Test Post')
ylim([0 110])


%% II. Sleep and fluoxetine
figure
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100 }, {[.6 .6 1],[1 .6 .6]},[1:2] , {'Saline','Flx chronique' } ,'showpoints',1,'paired',0);
ylabel('REM (%)')
title('Pourcentage de REM pendant une session sommeil'); 


%% III. Sleep and UMaze: Saline and fluo
figure
subplot(242)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100 REM_prop.AcuteFlx.sleep_pre*100},Cols2,X,Legends,'showpoints',1,'paired',0);
ylabel('%REM')
ylim([0 18])
title('Sommeil Pre')
subplot(243)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_post*100 REM_prop.ChronicFlx.sleep_post*100 REM_prop.AcuteFlx.sleep_post*100},Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 18])
ylabel('%REM')
title('Sommeil Post')

subplot(257)
MakeSpreadAndBoxPlot2_SB({REM_prop.SalineSB.sleep_pre*100 REM_prop.SalineSB.sleep_post*100},{[.8 .8 1],[.6 .6 1]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1); 
ylim([0 18])
ylabel('%REM')
title('Saline, n=7')
subplot(258)
MakeSpreadAndBoxPlot2_SB({REM_prop.ChronicFlx.sleep_pre*100 REM_prop.ChronicFlx.sleep_post*100},{[1 .8 .8],[1 .6 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1)
ylim([0 18])
ylabel('%REM')
title('Flx chronique, n=7')
subplot(259)
MakeSpreadAndBoxPlot2_SB({REM_prop.AcuteFlx.sleep_pre*100 REM_prop.AcuteFlx.sleep_post*100},{[.8 1 .8],[.6 1 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1,'optiontest','ttest')
ylim([0 18])
ylabel('%REM')
title('Flx aigue, n=5')

%a=suptitle('REM percentage along sleep session, UMaze conditions'); a.FontSize=20;
%a=suptitle('Pourcentage de REM au cours des sessions de sommeil pendant le protocole du UMaze'); a.FontSize=20;

%% IV. Fluo and behaviour
figure
subplot(131)
MakeSpreadAndBoxPlot2_SB({FreezingProportion.Figure.Shock.Cond{1}*100 FreezingProportion.Figure.Shock.Cond{2}*100 FreezingProportion.Figure.Shock.CondPost{3}*100},Cols2,X,Legends,'showpoints',1,'paired',0)
title('Proportion de freezing en zone choc ')
ylabel('freezing (%)')

subplot(132)
[pval , stats_out] = MakeSpreadAndBoxPlot2_SB({RA.SalineSB.Cond RA.ChronicFlx.Cond RA.AcuteFlx.Cond},Cols2,X,Legends,'showpoints',1,'paired',0,'optiontest','ttest')
title('Evaluation du risque')
ylabel('#/min')

subplot(133)
MakeSpreadAndBoxPlot2_SB({ZoneOccupancy.Figure.Shock.TestPost{1}*100 ZoneOccupancy.Figure.Shock.TestPost{2}*100 ZoneOccupancy.Figure.Shock.TestPost{3}*100},Cols2,X,Legends,'showpoints',1,'paired',0)
title('Exploration de la zone choc')
ylabel( 'exploration (%)')

a=suptitle('Analyses comportementales dans le UMaze en condition saline et avec fluoxétine'); a.FontSize=20;


%% V. Correlations
sess=2; type=2;
sess=2; type=2;

figure
subplot(231)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100 REM_prop.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
title('REM Total')
ylabel('Freezing (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-5,3,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(234)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_post*100 REM_prop.ChronicFlx.sleep_post*100 REM_prop.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
ylabel('Freezing (%)')
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-5,3,'Sommeil Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)


% Sequential REM correlations
subplot(232)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_pre*100 Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 Sequential_REM_Proportion.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
title('REM séquentiel')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(235)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_post*100 Sequential_REM_Proportion.ChronicFlx.sleep_post*100 Sequential_REM_Proportion.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])


% Singlr REM correlations
subplot(233)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_pre*100 Single_REM_Proportion.ChronicFlx.sleep_pre*100 Single_REM_Proportion.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 30])
axis square
title('REM isolé')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(236)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_post*100 Single_REM_Proportion.ChronicFlx.sleep_post*100 Single_REM_Proportion.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 30])
axis square
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

a=suptitle(['Freezing ' Type{type} ', ' Session_type{sess} ' = f(REM proportion)']); a.FontSize=20;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% VI. Electrophy
edit Imane_Master2_Electrophy_BM.m

figure
subplot(131)
clear DATA; DATA = HPC_Spec_REM.(Drug_Group{group}).sleep_pre./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = HPC_Spec_Fz.(Drug_Group{group}).Cond./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = HPC_Spec_REM.(Drug_Group{group}).sleep_post./HPC_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('HPC'); xlim([0 12]); makepretty
f=get(gca,'Children'); a=legend([f(9),f(5),f(1)],'Sleep Pre','Freezing','Sleep Post');
xlabel('Frequency (Hz)'); ylabel('Power (a.u.)')


subplot(132)
clear DATA; DATA = OB_Spec_REM.(Drug_Group{group}).sleep_pre./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = OB_Spec_Fz.(Drug_Group{group}).Cond./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = OB_Spec_REM.(Drug_Group{group}).sleep_post./OB_Max_REM.Saline.sleep_pre';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('OB'); xlim([0 12]); ylim([0 1.5]); makepretty
xlabel('Frequency (Hz)');


subplot(133)
[a,b] = max(PFC_Spec_REM.(Drug_Group{group}).sleep_pre(:,70:118)');
clear DATA; DATA = PFC_Spec_REM.(Drug_Group{group}).sleep_pre./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-b',1); hold on;
    
clear DATA; DATA = PFC_Spec_Fz.(Drug_Group{group}).Cond./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-k',1); hold on;
   
clear DATA; DATA = PFC_Spec_REM.(Drug_Group{group}).sleep_post./a';
Conf_Inter=nanstd(DATA)/sqrt(size(DATA,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(DATA);
shadedErrorBar(Spectro{3} , Mean_All_Sp , Conf_Inter,'-r',1); hold on;
   
title('PFC'); xlim([0 12]); ylim([0 3.5]); makepretty
xlabel('Frequency (Hz)');



%% others
figure
subplot(231)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100 REM_prop.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
title('Total REM')
ylabel('freezing(%) ')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-.05,.03,'Sommeil Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(234)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_post REM_prop.ChronicFlx.sleep_post REM_prop.AcuteFlx.sleep_post] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_post , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_post , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_post , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
ylabel('Proportion freezing ')
xlabel('REM proportion ')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-.05,.03,'Sleep Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)


% Sequential REM correlations
subplot(232)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_pre Sequential_REM_Proportion.ChronicFlx.sleep_pre Sequential_REM_Proportion.AcuteFlx.sleep_pre] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_pre , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_pre , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_pre , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
title('Sequential REM')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(235)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_post Sequential_REM_Proportion.ChronicFlx.sleep_post Sequential_REM_Proportion.AcuteFlx.sleep_post] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_post , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_post , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_post , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
xlabel('REM proportion ')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])


% Singlr REM correlations
subplot(233)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_pre Single_REM_Proportion.ChronicFlx.sleep_pre Single_REM_Proportion.AcuteFlx.sleep_pre] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_pre , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_pre , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_pre , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
title('Single REM')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(236)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_post Single_REM_Proportion.ChronicFlx.sleep_post Single_REM_Proportion.AcuteFlx.sleep_post] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_post , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_post , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_post , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
ylabel('Proportion freezing ')
xlabel('REM proportion ')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

a=suptitle('Freezing total, (Session_type{sess}) = f(REM proportion)'); a.FontSize=20;



%% Imane figures acute / chronic fluoxetine
figure
subplot(231)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_pre*100 REM_prop.ChronicFlx.sleep_pre*100 REM_prop.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
title('REM Total')
ylabel('Freezing (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-5,3,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

subplot(234)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_post*100 REM_prop.ChronicFlx.sleep_post*100 REM_prop.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
ylabel('Freezing (%)')
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-5,3,'Sommeil Post'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)


% Sequential REM correlations
subplot(232)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_pre*100 Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 Sequential_REM_Proportion.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
title('REM séquentiel')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(235)
[u1,v1]=PlotCorrelations_BM([Sequential_REM_Proportion.SalineSB.sleep_post*100 Sequential_REM_Proportion.ChronicFlx.sleep_post*100 Sequential_REM_Proportion.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Sequential_REM_Proportion.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Sequential_REM_Proportion.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Sequential_REM_Proportion.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 15])
axis square
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])


% Singlr REM correlations
subplot(233)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_pre*100 Single_REM_Proportion.ChronicFlx.sleep_pre*100 Single_REM_Proportion.AcuteFlx.sleep_pre*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_pre*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_pre*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_pre*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 30])
axis square
title('REM isolé')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

subplot(236)
[u1,v1]=PlotCorrelations_BM([Single_REM_Proportion.SalineSB.sleep_post*100 Single_REM_Proportion.ChronicFlx.sleep_post*100 Single_REM_Proportion.AcuteFlx.sleep_post*100] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100 FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100 FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100],30,0,'k')
[u2,v2]=PlotCorrelations_BM(Single_REM_Proportion.SalineSB.sleep_post*100 , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})'*100,30,0,'b')
[u3,v3]=PlotCorrelations_BM(Single_REM_Proportion.ChronicFlx.sleep_post*100 , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})'*100,30,0,'r')
[u4,v4]=PlotCorrelations_BM(Single_REM_Proportion.AcuteFlx.sleep_post*100 , FreezingProportion.(Type{type}).AcuteFlx.CondPost'*100,30,0,'g')
xlim([0 20]); ylim([0 30])
axis square
xlabel('REM (%)')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])

a=suptitle(['Freezing ' Type{type} ', ' Session_type{sess} ' = f(REM proportion)']); a.FontSize=20;









%% Trash from Ripples_Inhibition_Ana
%% PeakSpectrum
GetEmbReactMiceFolderList_BM

figure
for sess=1:length(Session_type) % generate all data required for analyses
    for mouse = 1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for side=1:length(Side)
            try
                % h=histogram(Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                h=histogram(Data(OutPutData.(Session_type{sess}).respi_freq_bm.tsd{mouse,Side_ind(side)}),'BinLimits',[1 8],'NumBins',91); % 91=nansum(and(1<Spectro{3},Spectro{3}<8))
                HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = h.Values;
                MeanRespi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}) = nanmedian(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse}));
            end
        end
    end
end

for group=[5 group_numb]
    
   Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            for side=1:length(Side)
                try
                    if isnan(runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3))
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                    else
                        HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = runmean(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})/nansum(HistData.(Side{side}).(Session_type{sess}).(Mouse_names{mouse})),3);
                    end
                catch
                    HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = NaN(1,91);
                end
                MeanRespi.(Side{side}).(Drug_Group{group}).(Session_type{sess})(mouse,:) = MeanRespi.(Side{side}).(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
end


% Time spent freezing figures
m=1; clf
for group=[5 group_numb]
     n=1; 
    for sess=2:4
        
        subplot(2,3,3*(m-1)+n)
        
        Conf_Inter=nanstd(HistData.Shock.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Shock.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Shock.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'r',1); hold on;
        Conf_Inter=nanstd(HistData.Safe.(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.Safe.(Drug_Group{group}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.Safe.(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'b',1); hold on;
        makepretty; grid on
        a=ylim; ylim([0 a(2)]);
        if and(n==1,m==1); title('CondPre'); end
        if and(n==2,m==1); title('CondPost'); end
        if and(n==3,m==1); title('Ext'); end
        if m==2; xlabel('Frequency (Hz)'); end
        if and(n==1,m==1); f=get(gca,'Children'); legend([f(8),f(4)],'Shock','Safe'); ylabel('Saline'); end
        if and(n==1,m==2); ylabel('Drug'); end
        
        n=n+1;
    end
    m=m+1;
end


m=1;
for group=[5 group_numb]
    n=1;
    for sess=2:4
        
        axes('Position',[.3+(n-1)*.28 .85-(m-1)*.45 .05 .05]); box on
        a= pie([nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.All.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
        axes('Position',[.3+(n-1)*.28 .77-(m-1)*.45 .05 .05]); box on
        a= pie([nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess})) 1-nanmean(FreezingProp.Shock.(Drug_Group{group}).(Session_type{sess}))]); set(a(1), 'FaceColor', [1 0.5 0.5]); set(a(3), 'FaceColor', [0.5 0.5 1]);
        
        n=n+1;
    end
    m=m+1;
end
a=suptitle('Breathing frequency during freezing, spent time analysis'); a.FontSize=20;


% Comparing drug to Saline
figure;
for group=[5 group_numb]
    n=1;
    for sess=2:4
        for side=2:3
            subplot(2,3,3*(side-2)+n)
            if group==5
                if  side==2
                    Conf_Inter=nanstd(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}),1));
                    shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'r',1); hold on;
                else
                    Conf_Inter=nanstd(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}),1));
                    shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'b',1); hold on;
                end
            else
                Conf_Inter=nanstd(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}))/sqrt(size(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess}),1));
                shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.(Side{side}).(Drug_Group{group}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
                makepretty; grid on
                if side==2; title(Session_type{sess}); end
                if side==3; xlabel('Frequency (Hz)'); end
                if sess==2; ylabel(Side{side}); end
                a=ylim; ylim([0 a(2)]); xlim([0 8])
                if or(and(n==1,side==2) , and(n==1,side==3)); f=get(gca,'Children'); legend([f(5),f(1)],'Saline','Drug');  end
            end
        end
        n=n+1;
    end
end
a=suptitle('Breathing frequency during freezing, spent time analysis, saline comparison'); a.FontSize=20;


%% respi
figure
subplot(131); sess=2;
MakeSpreadAndBoxPlot2_SB({Respi.Shock.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Shock.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) },Cols,X,Legends,'showpoints',1,'paired',0);
ylabel('Frequency (Hz)');
ylim([3 6.5])
title('CondPre')

subplot(132); sess=3;
MakeSpreadAndBoxPlot2_SB({Respi.Shock.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Shock.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) },Cols,X,Legends,'showpoints',1,'paired',0);
ylim([3 6.5])
title('CondPost')

subplot(133); sess=4;
MakeSpreadAndBoxPlot2_SB({Respi.Shock.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Shock.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(1)}).(Session_type{sess}) , Respi.Safe.(Drug_Group{GroupsToUse(2)}).(Session_type{sess}) },Cols,X,Legends,'showpoints',1,'paired',0);
ylim([3 6.5])
title('Ext')

a=suptitle('Breathing during freezing, ripples inhibition experiments, n=4'); a.FontSize=20;
a=suptitle('Breathing during freezing, chronic buspirone experiments, n=5'); a.FontSize=20;


% All freezing, time analysis
figure; n=1;
for sess=2:4
    for side=1
        subplot(1,3,n)
        Conf_Inter=nanstd(HistData.All.SalineBM_Short.(Session_type{sess}))/sqrt(size(HistData.All.SalineBM_Short.(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.SalineBM_Short.(Session_type{sess})),Conf_Inter,'m',1); hold on;
        Conf_Inter=nanstd(HistData.All.(Drug_Group{group_numb}).(Session_type{sess}))/sqrt(size(HistData.All.(Drug_Group{group_numb}).(Session_type{sess}),1));
        shadedErrorBar(Spectro{3}(13:103),nanmean(HistData.All.(Drug_Group{group_numb}).(Session_type{sess})),Conf_Inter,'k',1); hold on;
        makepretty; grid on
        title(Session_type{sess}); xlabel('Frequency (Hz)');
        a=ylim; ylim([0 a(2)]); xlim([0 8])
        if and(n==1,side==1); f=get(gca,'Children'); legend([f(5),f(1)],'Saline',Drug_Group{group_numb}); end
        
    end
    n=n+1;
end


n=1;
for sess=2:4
    
    axes('Position',[.25+(n-1)*.28 .85 .1 .1]); box on
    a= pie([nansum(nansum(HistData.All.SalineBM_Short.(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.SalineBM_Short.(Session_type{sess}))) 1-nansum(nansum(HistData.All.SalineBM_Short.(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.SalineBM_Short.(Session_type{sess})))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
    axes('Position',[.25+(n-1)*.28 .7 .1 .1]); box on
    a= pie([nansum(nansum(HistData.All.(Drug_Group{group_numb}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group_numb}).(Session_type{sess}))) 1-nansum(nansum(HistData.All.(Drug_Group{group_numb}).(Session_type{sess})(:,40:end)))/nansum(nansum(HistData.All.(Drug_Group{group_numb}).(Session_type{sess})))]); set(a(1), 'FaceColor', [0 0 0]); set(a(3), 'FaceColor', [1 1 1]);
    
    n=n+1;
end
a=suptitle('Saline groups comparison'); a.FontSize=20;





%% OB gamma
Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,1251,1253,1254,31251 31253 31266 31268 31269];
Mouse=[41266,41268,41269,41305, 1266,1267,1268,1269,1304,1305]; % ripples

for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    for sess=1:length(Session_type)
        OB_High_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.mean(mouse,5);
        OB_High_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.mean(mouse,6);
        % Max freq
        OB_High_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.max_freq(mouse,5);
        OB_High_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.max_freq(mouse,6);
        % power
        OB_High_Power.Shock.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.power(mouse,5);
        OB_High_Power.Safe.(Session_type{sess}).(Mouse_names{mouse}) = OutPutData.(Session_type{sess}).ob_high.power(mouse,6);
    end
    Mouse_names{mouse}
end
    
    
for group=GroupsToUse
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type)
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            OB_High_Spec.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Spec.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_High_Spec.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Spec.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_High_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_MaxFreq.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_High_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_MaxFreq.Safe.(Session_type{sess}).(Mouse_names{mouse});
            
            OB_High_Power.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Power.Shock.(Session_type{sess}).(Mouse_names{mouse});
            OB_High_Power.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = OB_High_Power.Safe.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
end

for sess=1:length(Session_type)
    for group=GroupsToUse
        OB_High_Spec.Shock.Figure.(Session_type{sess}){group} = OB_High_Spec.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_High_Spec.Safe.Figure.(Session_type{sess}){group} = OB_High_Spec.Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_High_MaxFreq.Shock.Figure.(Session_type{sess}){group} = OB_High_MaxFreq.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_High_MaxFreq.Safe.Figure.(Session_type{sess}){group} = OB_High_MaxFreq.Safe.(Drug_Group{group}).(Session_type{sess});
        
        OB_High_Power.Shock.Figure.(Session_type{sess}){group} = OB_High_Power.Shock.(Drug_Group{group}).(Session_type{sess});
        OB_High_Power.Safe.Figure.(Session_type{sess}){group} = OB_High_Power.Safe.(Drug_Group{group}).(Session_type{sess});
    end
end


figure; sess=2;
subplot(231)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
f=get(gca,'Children'); a=legend([f(5),f(1)],'Saline',Drug_Group{group_numb});
makepretty; ylabel('Power (a.u.)'); xlim([20 100]); ylim([0 1])
title('CondPre')

subplot(234)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
h.mainLine.Color=[0 0 .5]; h.patch.FaceColor=[1 1 1];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
f=get(gca,'Children'); a=legend([f(1),f(5)],'Saline',Drug_Group{group_numb});
makepretty; ylabel('Power (a.u.)'); xlim([20 100]); ylim([0 1]); xlabel('Frequency (Hz)')

sess=3;
subplot(232)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
makepretty; xlim([20 100]); ylim([0 1])
title('CondPost')

subplot(235)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
h.mainLine.Color=[0 0 .5]; h.patch.FaceColor=[1 1 1];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
makepretty; xlim([20 100]); ylim([0 1]); xlabel('Frequency (Hz)')

sess=4;
subplot(233)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,5,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-r',1); hold on;
h.mainLine.Color=[0.7 0 0]; h.patch.FaceColor=[1 0.6 0.6];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--r')
makepretty; xlim([20 100]); ylim([0 1])
title('CondPost')

subplot(236)
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(1:n-1,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
[a,b] = max(squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,9:end))');
Data_to_use = squeeze(OutPutData.(Session_type{sess}).ob_high.mean(n:end,6,:))./a';
Conf_Inter=nanstd(Data_to_use)/sqrt(size(Data_to_use,1));
clear Mean_All_Sp; Mean_All_Sp=nanmean(Data_to_use);
h=shadedErrorBar(RangeHigh , Mean_All_Sp,Conf_Inter,'-b',1); hold on;
h.mainLine.Color=[0 0 .5]; h.patch.FaceColor=[1 1 1];
[c,d]=max(Mean_All_Sp(9:end));
vline(RangeHigh(d+8),'--b')
makepretty; xlim([20 100]); ylim([0 1]); xlabel('Frequency (Hz)')

a=suptitle('OB mean spectrum, saline comparison'); a.FontSize=20;



%% Occupancy maps / Trajectories
Session_type={'TestPre','CondPre','CondPost','TestPost'};
sizeMap = 50;
sizeMap2 = 9;

clear Mouse Mouse_names;
Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,1251,1253,1254,31251 31253 31266 31268 31269];
Mouse=[41266,41268,41269,41305, 1266,1267,1268,1269,1304,1305]; % ripples
for mouse = 1:length(Mouse) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
end


for mouse=1:length(Mouse)
    for sess=1:length(Session_type)
        
        if sess==1; Sess_To_use=TestPreSess;
        elseif sess==2; Sess_To_use=CondPreSess;
        elseif sess==3; Sess_To_use=CondPostSess;
        elseif sess==4 Sess_To_use=TestPostSess;
        end
        
        Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'speed');
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'AlignedPosition');
        Position.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
        Position.(Mouse_names{mouse}).(Session_type{sess})(or(Position.(Mouse_names{mouse}).(Session_type{sess})<0 , Position.(Mouse_names{mouse}).(Session_type{sess})>1)) = NaN;
        Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) = tsd(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess})) , Position.(Mouse_names{mouse}).(Session_type{sess}));
        
        if or(sess==2 , sess==3)
            StimEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','stimepoch');
            BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = ConcatenateDataFromFolders_SB(Sess_To_use.(Mouse_names{mouse}),'epoch','epochname','blockedepoch');
            StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}) = and(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}),BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) = intervalSet(0,max(Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}))));
            UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}) = TotEpoch.(Mouse_names{mouse}).(Session_type{sess}) - BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess});
            
            Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , BlockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Blocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Blocked.(Mouse_names{mouse}).(Session_type{sess}));
            Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Data(Position_tsd_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));
            Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}) = Restrict(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}) , UnblockedEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            
            clear Range_to_use Stim_times Stim_times_Blocked;
            Range_to_use = Range(Position_tsd.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times = Start(StimEpoch.(Mouse_names{mouse}).(Session_type{sess}));
            Stim_times_Blocked = Start(StimEpochBlocked.(Mouse_names{mouse}).(Session_type{sess}));
            
            for stim=1:length(Stim_times)
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times(stim));
            end
            try
                rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})=rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})(find(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess})~=0));
            end
            for stim=1:length(Stim_times_Blocked)
                rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess})(stim) = sum(Range_to_use<Stim_times_Blocked(stim));
            end
            try
                PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_useExplo.(Mouse_names{mouse}).(Session_type{sess}),:);
                PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess}) = Position.(Mouse_names{mouse}).(Session_type{sess})(rank_to_use_blocked.(Mouse_names{mouse}).(Session_type{sess}),:);
            end
        end
    end
    disp(Mouse_names{mouse})
end

% gather data
for mouse=1:length(Mouse_names)
    for sess=1:length(Session_type)
        %try
        if or(sess==2 , sess==3)
            try
                [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
            catch
                try
                    [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;0;0;0;1;0;1] , sizeMap , sizeMap);
                catch
                    [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position_Unblocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_Unblocked.(Mouse_names{mouse}).(Session_type{sess}));0;0;0;0;0;0;1;0;1] , sizeMap , sizeMap);
                end
            end
        else
            [OccupMap.(Mouse_names{mouse}).(Session_type{sess}) , SpeedMap.(Mouse_names{mouse}).(Session_type{sess})] = hist3d_BM([Position.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1] , [Position.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1] , [Data(Speed_tsd.(Mouse_names{mouse}).(Session_type{sess}));0;1;0;1] , sizeMap , sizeMap);
        end
        OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})/sum(OccupMap.(Mouse_names{mouse}).(Session_type{sess})(:));
        OccupMap.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess})';
        
        OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
        OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
        
        OccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(OccupMap.(Mouse_names{mouse}).(Session_type{sess}));
        OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(OccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
        
        if or(sess==2 , sess==3)
            try
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(StimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(StimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
                
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = hist2d([PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimExplo.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2)-hist2d([PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,1) ;0; 0; 1; 1],[PositionStimBlocked.(Mouse_names{mouse}).(Session_type{sess})(:,2);0;1;0;1],sizeMap2,sizeMap2);
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})/20;
                FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess})';
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess}) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_binary.(Mouse_names{mouse}).(Session_type{sess})>0) = 1;
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess}) = log(FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess}));
                FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})(FreeStimOccupMap_log.(Mouse_names{mouse}).(Session_type{sess})==-Inf) = -1e4;
            end
        end
        disp(Mouse_names{mouse})
        %end
    end
end

% Gather by drug group
clear StimOccupMap_squeeze StimOccupMap_log_squeeze FreeStimOccupMap_squeeze FreeStimOccupMap_log_squeeze OccupMap_log_squeeze OccupMap_squeeze
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for sess=1:length(Session_type) % generate all data required for analyses
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            try
                OccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = OccupMap.(Mouse_names{mouse}).(Session_type{sess});
                SpeedMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = SpeedMap.(Mouse_names{mouse}).(Session_type{sess});
                if or(sess==2 , sess==3)
                    try
                        StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = StimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                        FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = FreeStimOccupMap.(Mouse_names{mouse}).(Session_type{sess});
                    end
                end
            catch
                OccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap,sizeMap);
                SpeedMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap,sizeMap);
                if or(sess==2 , sess==3)
                    try
                        StimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap2,sizeMap2);
                        FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})(mouse,:,:) = NaN(sizeMap2,sizeMap2);
                    end
                end
            end
        end
        try
            OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(OccupMap.(Drug_Group{group}).(Session_type{sess})));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(OccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(OccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(StimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(StimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(StimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
            
            FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(FreeStimOccupMap.(Drug_Group{group}).(Session_type{sess})));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess}) = log(FreeStimOccupMap_squeeze.(Drug_Group{group}).(Session_type{sess}));
            FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})(FreeStimOccupMap_log_squeeze.(Drug_Group{group}).(Session_type{sess})==-Inf) = -1e4;
        end
        SpeedMap_squeeze.(Drug_Group{group}).(Session_type{sess}) = squeeze(nanmean(SpeedMap.(Drug_Group{group}).(Session_type{sess})));
    end
end


%% figures
%% Occupancy maps
figure; n=1;
a=suptitle(['Occupancy maps, ' Drug_Group{group}]); a.FontSize=20;
for mouse=1:length(Mouse)
    
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        subplot(length(Mouse),4,4*(mouse-1)+1);
        imagesc(OccupMap_log.(Mouse_names{mouse}).TestPre)
        axis xy; caxis([-10 -5])
        if mouse==1; title('Test Pre'); end
        ylabel(num2str(Mouse_names{mouse})); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
        Maze_Frame_BM
    end
    subplot(length(Mouse),4,4*(mouse-1)+2);
    imagesc(OccupMap_log.(Mouse_names{mouse}).CondPre)
    axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Pre'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+3);
    imagesc(OccupMap_log.(Mouse_names{mouse}).CondPost)
    axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Post'); end
    Maze_Frame_BM
    
    subplot(length(Mouse),4,4*(mouse-1)+4);
    imagesc(OccupMap_log.(Mouse_names{mouse}).TestPost)
    axis xy; caxis([-10 -5]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Test Post'); end
    Maze_Frame_BM
    
    colormap jet
end


figure
group=5;
subplot(241);
imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
axis xy; caxis ([0 1e-3])
if group==1; title('Test Pre'); end
ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM

subplot(242);
imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPre)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Cond Pre'); end
Maze_Frame_BM

subplot(243);
imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPost)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Cond Post'); end
Maze_Frame_BM

subplot(244);
imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Test Post'); end
Maze_Frame_BM

group=group_numb;
subplot(245);
imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPre)
axis xy; caxis ([0 1e-3])
if group==1; title('Test Pre'); end
ylabel(Drug_Group{group}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
Maze_Frame_BM

subplot(246);
imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPre)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Cond Pre'); end
Maze_Frame_BM

subplot(247);
imagesc(OccupMap_squeeze.(Drug_Group{group}).CondPost)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Cond Post'); end
Maze_Frame_BM

subplot(248);
imagesc(OccupMap_squeeze.(Drug_Group{group}).TestPost)
axis xy; caxis ([0 1e-3])
set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
if group==1; title('Test Post'); end
Maze_Frame_BM

colormap jet

a=suptitle('Occupancy maps for all drugs groups'); a.FontSize=20;



figure; n=1;
for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
    try
        subplot(length(Mouse),4,4*n-3)
        plot(Position.(Mouse_names{mouse}).TestPre(:,1),Position.(Mouse_names{mouse}).TestPre(:,2));
        xlim([0 1]); ylim([0 1])
        if mouse==1; title('Test Pre'); end
        ylabel(Mouse_names{mouse}); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    end
    subplot(length(Mouse),4,4*n-2)
    plot(Position_Unblocked.(Mouse_names{mouse}).CondPre(:,1),Position_Unblocked.(Mouse_names{mouse}).CondPre(:,2));
    hold on
    plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
    try; plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10); end
    xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Pre'); end
    
    subplot(length(Mouse),4,4*n-1)
    plot(Position_Unblocked.(Mouse_names{mouse}).CondPost(:,1),Position_Unblocked.(Mouse_names{mouse}).CondPost(:,2));
    hold on
    try
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
        plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
    end
    xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Cond Post'); end
    
    subplot(length(Mouse),4,4*n)
    try
        plot(Position.(Mouse_names{mouse}).TestPost(:,1),Position.(Mouse_names{mouse}).TestPost(:,2)); hold on
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPre(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPre(:,2),'.r','MarkerSize',10);
        plot(PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPre(:,2),'.b','MarkerSize',10);
        plot(PositionStimExplo.(Mouse_names{mouse}).CondPost(:,1) , PositionStimExplo.(Mouse_names{mouse}).CondPost(:,2),'.k','MarkerSize',10);
        plot(PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,1) , PositionStimBlocked.(Mouse_names{mouse}).CondPost(:,2),'.m','MarkerSize',10);
    end
    xlim([0 1]); ylim([0 1]); set(gca,'YTickLabel',[]); set(gca,'XTickLabel',[]);
    if mouse==1; title('Test Post');
        f=get(gca,'Children'); l=legend([f(4),f(3),f(2),f(1)],'stim explo pre','stim blocked pre','stim explo post','stim blocked post'); l.Position=[0.8 0.9 0.1 0.1]; end
    
    n=n+1;
end
a=suptitle(['Trajectories, ' Drug_Group{group}]); a.FontSize=20;





