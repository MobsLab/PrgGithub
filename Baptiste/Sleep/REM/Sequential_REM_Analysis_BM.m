
%% Imane's codes
clear all
% load('/media/nas6/ProjetEmbReact/DataEmbReact/Create_Behav_Drugs_BM.mat') % behaviour data
% load('/media/nas6/ProjetEmbReact/DataEmbReact/Imane_code_Data.mat') % physio/neuro data

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


for group=1
    clear Mouse
    Drugs_Groups_UMaze_BM
    for sess=1:length(Session_type2)
        [OutPutData.(Session_type2{sess}) , Epoch1.(Session_type2{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type2{sess}),'accelero');
    end
end


% Transforming some variables
for sess=1:length(Session_type2)
    n=1;
    for group=[1]
        Drugs_Groups_UMaze_BM
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            
            Sleep_TotalDur.(Session_type2{sess}){n}(mouse) = sum(Stop(Epoch1.(Session_type2{sess}){mouse,3})-Start(Epoch1.(Session_type2{sess}){mouse,3}))/1e4;
            
            REM_MeanDur.(Session_type2{sess}){n}(mouse) = nanmean(Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/1e4;
            REM_TotalDur.(Session_type2{sess}){n}(mouse)  = sum(Stop(Epoch1.(Session_type2{sess}){mouse,5})-Start(Epoch1.(Session_type2{sess}){mouse,5}))/1e4;
            Number_of_REM_Episodes.(Session_type2{sess}){n}(mouse)  = length(Start(Epoch1.(Session_type2{sess}){mouse,5}));
            
            REM_prop.(Session_type2{sess}){n}(mouse)  = REM_TotalDur.(Session_type2{sess}){n}(mouse)./Sleep_TotalDur.(Session_type2{sess}){n}(mouse);
            
            [aft_cell.(Session_type2{sess}){n}{mouse}  , bef_cell.(Session_type2{sess}){n}{mouse} ] = transEpoch(Epoch1.(Session_type2{sess}){mouse,5} , or(Epoch1.(Session_type2{sess}){mouse,4} , Epoch1.(Session_type2{sess}){mouse,2}));
            ind_to_use = ((Stop(bef_cell.(Session_type2{sess}){n}{mouse}{2,1}) - Start(bef_cell.(Session_type2{sess}){n}{mouse}{2,1}))/60e4)<2.5; % less than 3 minutes between REM episodes
            clear REM_Start_After_Other REM_Stop_After_Other
            REM_Start_Before_Other = Start(aft_cell.(Session_type2{sess}){n}{mouse}{1,2});
            REM_Stop_Before_Other = Stop(aft_cell.(Session_type2{sess}){n}{mouse}{1,2});
            
            Number_of_Sequential_REM_Episodes.(Session_type2{sess}){n}(mouse) = sum(ind_to_use);
            Number_of_Single_REM_Episodes.(Session_type2{sess}){n}(mouse) = sum(~ind_to_use);
            MeanDuration_of_Sequential_REM_Episodes.(Session_type2{sess}){n}(mouse) = nanmean(REM_Stop_Before_Other(ind_to_use)-REM_Start_Before_Other(ind_to_use))/1e4;
            MeanDuration_of_Single_REM_Episodes.(Session_type2{sess}){n}(mouse) = nanmean(REM_Stop_Before_Other(~ind_to_use)-REM_Start_Before_Other(~ind_to_use))/1e4;
            TotalDuration_Sequential_REM.(Session_type2{sess}){n}(mouse) = sum(REM_Stop_Before_Other(ind_to_use)-REM_Start_Before_Other(ind_to_use))/1e4;
            TotalDuration_Single_REM.(Session_type2{sess}){n}(mouse) = sum(REM_Stop_Before_Other(~ind_to_use)-REM_Start_Before_Other(~ind_to_use))/1e4;
            Sequential_REM_Proportion.(Session_type2{sess}){n}(mouse) = TotalDuration_Sequential_REM.(Session_type2{sess}){n}(mouse)/Sleep_TotalDur.(Session_type2{sess}){n}(mouse);
            Single_REM_Proportion.(Session_type2{sess}){n}(mouse) = TotalDuration_Single_REM.(Session_type2{sess}){n}(mouse)/Sleep_TotalDur.(Session_type2{sess}){n}(mouse);
            Sequential_REM_Proportion_inREM.(Session_type2{sess}){n}(mouse) = TotalDuration_Sequential_REM.(Session_type2{sess}){n}(mouse)/REM_TotalDur.(Session_type2{sess}){n}(mouse);
            Single_REM_Proportion_inREM.(Session_type2{sess}){n}(mouse) = TotalDuration_Single_REM.(Session_type2{sess}){n}(mouse)/REM_TotalDur.(Session_type2{sess}){n}(mouse);
            
        end
        LongREM_MeanDur.(Session_type{sess}){n} = REM_MeanDur.(Session_type{sess}){n}(REM_MeanDur.(Session_type{sess}){n} >15);
    end
end



%% Look at REM episodes 
Cols = {[.8 .8 1],[1 .8 .8],[.8 1 .8]};
Legends ={'SalineSB' 'Chronic Flx' 'Acute Flx'};
NoLegends ={'', '', ''};
X = [1:3];

% Porportion
figure
subplot(232)
MakeSpreadAndBoxPlot2_SB({REM_prop.sleep_pre{1} REM_prop.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('REM')
ylabel('proportion')
subplot(246)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.sleep_pre{1} Sequential_REM_Proportion.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Sequential REM')
subplot(247)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.sleep_pre{1} Single_REM_Proportion.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Single REM')

subplot(349)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion_inREM.sleep_pre{1} Sequential_REM_Proportion_inREM.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('of REM')
ylabel('proportion')
subplot(3,4,12)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion_inREM.sleep_pre{1} Single_REM_Proportion_inREM.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('of REM')

a=suptitle('Proportion'); a.FontSize=20;


% Mean duration
figure
subplot(232)
MakeSpreadAndBoxPlot2_SB({REM_MeanDur.sleep_pre{1} REM_MeanDur.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('REM')
ylabel('time (s)')
subplot(246)
MakeSpreadAndBoxPlot2_SB({MeanDuration_of_Sequential_REM_Episodes.sleep_pre{1} MeanDuration_of_Sequential_REM_Episodes.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Sequential REM')
ylabel('time (s)')
subplot(247)
MakeSpreadAndBoxPlot2_SB({MeanDuration_of_Single_REM_Episodes.sleep_pre{1} MeanDuration_of_Single_REM_Episodes.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Single REM')

a=suptitle('Mean duration'); a.FontSize=20;


% Number of episodes
figure
subplot(232)
MakeSpreadAndBoxPlot2_SB({Number_of_REM_Episodes.sleep_pre{1} Number_of_REM_Episodes.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('REM')
ylabel('#')
subplot(246)
MakeSpreadAndBoxPlot2_SB({Number_of_Sequential_REM_Episodes.sleep_pre{1} Number_of_Sequential_REM_Episodes.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Sequential REM')
ylabel('#')
subplot(247)
MakeSpreadAndBoxPlot2_SB({Number_of_Single_REM_Episodes.sleep_pre{1} Number_of_Single_REM_Episodes.sleep_post{1}}, {[.8 .8 1],[.5 .5 1]},[1:2] , {'Sleep Pre','Sleep Post' } ,'showpoints',0,'paired',1);
title('Single REM')

a=suptitle('Number of episodes'); a.FontSize=20;




%% Fluo mice and Saline, sum up
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

a=suptitle('Total REM'); a.FontSize=20;



figure
subplot(242)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.SalineSB.sleep_pre*100 Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 Sequential_REM_Proportion.AcuteFlx.sleep_pre*100},Cols2,X,Legends,'showpoints',1,'paired',0);
ylabel('%REM')
ylim([0 18])
title('Sommeil Pre')
subplot(243)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.SalineSB.sleep_post*100 Sequential_REM_Proportion.ChronicFlx.sleep_post*100 Sequential_REM_Proportion.AcuteFlx.sleep_post*100},Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 18])
ylabel('%REM')
title('Sommeil Post')

subplot(257)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.SalineSB.sleep_pre*100 Sequential_REM_Proportion.SalineSB.sleep_post*100},{[.8 .8 1],[.6 .6 1]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1); 
ylim([0 18])
ylabel('%REM')
title('Saline, n=7')
subplot(258)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.ChronicFlx.sleep_pre*100 Sequential_REM_Proportion.ChronicFlx.sleep_post*100},{[1 .8 .8],[1 .6 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1)
ylim([0 18])
ylabel('%REM')
title('Flx chronique, n=7')
subplot(259)
MakeSpreadAndBoxPlot2_SB({Sequential_REM_Proportion.AcuteFlx.sleep_pre*100 Sequential_REM_Proportion.AcuteFlx.sleep_post*100},{[.8 1 .8],[.6 1 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1,'optiontest','ttest')
ylim([0 18])
ylabel('%REM')
title('Flx aigue, n=5')

a=suptitle('Sequential REM'); a.FontSize=20;

figure
subplot(242)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.SalineSB.sleep_pre*100 Single_REM_Proportion.ChronicFlx.sleep_pre*100 Single_REM_Proportion.AcuteFlx.sleep_pre*100},Cols2,X,Legends,'showpoints',1,'paired',0);
ylabel('%REM')
ylim([0 18])
title('Sommeil Pre')
subplot(243)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.SalineSB.sleep_post*100 Single_REM_Proportion.ChronicFlx.sleep_post*100 Single_REM_Proportion.AcuteFlx.sleep_post*100},Cols,X,Legends,'showpoints',1,'paired',0); 
ylim([0 18])
ylabel('%REM')
title('Sommeil Post')

subplot(257)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.SalineSB.sleep_pre*100 Single_REM_Proportion.SalineSB.sleep_post*100},{[.8 .8 1],[.6 .6 1]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1); 
ylim([0 18])
ylabel('%REM')
title('Saline, n=7')
subplot(258)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.ChronicFlx.sleep_pre*100 Single_REM_Proportion.ChronicFlx.sleep_post*100},{[1 .8 .8],[1 .6 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1)
ylim([0 18])
ylabel('%REM')
title('Flx chronique, n=7')
subplot(259)
MakeSpreadAndBoxPlot2_SB({Single_REM_Proportion.AcuteFlx.sleep_pre*100 Single_REM_Proportion.AcuteFlx.sleep_post*100},{[.8 1 .8],[.6 1 .6]},[1:2],{'Sommeil Pre','Sommeil Post'},'showpoints',0,'paired',1,'optiontest','ttest')
ylim([0 18])
ylabel('%REM')
title('Flx aigue, n=5')

a=suptitle('Single REM'); a.FontSize=20;



%% Correlations
Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost'};
Type={'All','Shock','Safe','Ratio'};

type=2; sess=2;
% Total REM
figure
subplot(231)
[u1,v1]=PlotCorrelations_BM([REM_prop.SalineSB.sleep_pre REM_prop.ChronicFlx.sleep_pre REM_prop.AcuteFlx.sleep_pre] , [FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})' FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})' FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})'],30,0,'k')
[u2,v2]=PlotCorrelations_BM(REM_prop.SalineSB.sleep_pre , FreezingProportion.(Type{type}).SalineSB.(Session_type{sess})',30,0,'b')
[u3,v3]=PlotCorrelations_BM(REM_prop.ChronicFlx.sleep_pre , FreezingProportion.(Type{type}).ChronicFlx.(Session_type{sess})',30,0,'r')
[u4,v4]=PlotCorrelations_BM(REM_prop.AcuteFlx.sleep_pre , FreezingProportion.(Type{type}).AcuteFlx.(Session_type{sess})',30,0,'g')
xlim([0 .2]); ylim([0 .3])
axis square
title('Total REM')
ylabel('Proportion freezing ')
f=get(gca,'Children'); legend([f(8),f(6),f(4),f(2)],['Tous groupes (R = ' num2str(round(u1(2,1),2)) ', P = ' num2str(round(v1(2,1),2)) ')'],['Saline (R = ' num2str(round(u2(2,1),2)) ', P = ' num2str(round(v2(2,1),2)) ')'],['Flx chronique (R = ' num2str(round(u3(2,1),2)) ', P = ' num2str(round(v3(2,1),2)) ')'],['Flx aigue (R = ' num2str(round(u4(2,1),2)) ', P = ' num2str(round(v4(2,1),2)) ')'])
u=text(-.05,.03,'Sleep Pre'); set(u,'FontSize',20,'FontWeight','bold','Rotation',90)

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

a=suptitle(['Freezing ' Type{type} ', ' Session_type{sess} ' = f(REM proportion)']); a.FontSize=20;

