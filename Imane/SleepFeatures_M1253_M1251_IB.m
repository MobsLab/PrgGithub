
% 1) paths
Mice=[1251 1253 11251 11253 21251 21253 31251 31253];
for mouse = 1:length(Mice) % generate all sessions of interest
    Mouse_names{mouse}=['M' num2str(Mice(mouse))];
end

SleepPath.M1251{1} = '/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_SleepPre';
SleepPath.M1251{2} = '/media/nas6/ProjetEmbReact/Mouse1251/20211228/ProjectEmbReact_M1251_20211228_SleepPost';
SleepPath.M11251{1} = '/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_SleepPre';
SleepPath.M11251{2} = '/media/nas6/ProjetEmbReact/Mouse1251/20211214/ProjectEmbReact_M1251_20211214_SleepPost';
SleepPath.M21251{1} = '/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_SleepPre';
SleepPath.M21251{2} = '/media/nas6/ProjetEmbReact/Mouse1251/20220128/ProjectEmbReact_M1251_20220128_SleepPost';
SleepPath.M31251{1} = '/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_SleepPre';
SleepPath.M31251{2} = '/media/nas6/ProjetEmbReact/Mouse1251/20220218/ProjectEmbReact_M1251_20220218_SleepPost';

SleepPath.M1253{1} = '/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_SleepPre';
SleepPath.M1253{2} = '/media/nas6/ProjetEmbReact/Mouse1253/20220104/ProjectEmbReact_M1253_20220104_SleepPost';
SleepPath.M11253{1} = '/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_SleepPre';
SleepPath.M11253{2} = '/media/nas6/ProjetEmbReact/Mouse1253/20211216/ProjectEmbReact_M1253_20211216_SleepPost';
SleepPath.M21253{1} = '/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_SleepPre';
SleepPath.M21253{2} = '/media/nas6/ProjetEmbReact/Mouse1253/20220128/ProjectEmbReact_M1253_20220128_SleepPost';
SleepPath.M31253{1} = '/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_SleepPre';
SleepPath.M31253{2} = '/media/nas6/ProjetEmbReact/Mouse1253/20220218/ProjectEmbReact_M1253_20220218_SleepPost';



% 2) Generate Sleep Proportion  and Ripples Density
for mouse=1:length(Mice)
    for sess=1:2
        
        cd(SleepPath.(Mouse_names{mouse}){sess})
        
        load('SWR.mat')
        load('StateEpochSB.mat')
        
        SleepProportion.(Mouse_names{mouse})(sess) = sum(Stop(Sleep)-Start(Sleep))/sum(Stop(TotalEpoch)-Start(TotalEpoch));
        Ripples_During_SWS = Restrict(tRipples , SWSEpoch);
        RipplesDensity.(Mouse_names{mouse})(sess) = length(Ripples_During_SWS)/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4);
        REMProportion.(Mouse_names{mouse})(sess)=  sum(Stop(REMEpoch)-Start(REMEpoch))/sum(Stop(Sleep)-Start(Sleep));
    end
end


%R = Range(Ripples_During_SWS);
%Tps_total_SWS_Minutes= (sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4)/60 
%Ripples_Density_during_SWS = length(Ripples_During_SWS)/(sum(Stop(SWSEpoch)-Start(SWSEpoch))/1e4)

% 3) Generate Graphs

All_SleepPre_Proportion_Drugs= [SleepProportion.M11251(1) SleepProportion.M1251(1) SleepProportion.M21251(1) SleepProportion.M31251(1) ; ...
    SleepProportion.M11253(1), SleepProportion.M1253(1),SleepProportion.M21253(1), SleepProportion.M31253(1)];
All_SleepPost_Proportion_Drugs= [SleepProportion.M11251(2) SleepProportion.M1251(2) SleepProportion.M21251(2) SleepProportion.M31251(2) ; ...
    SleepProportion.M11253(2), SleepProportion.M1253(2),SleepProportion.M21253(2), SleepProportion.M31253(2)];

All_RipplesDensity_SleepPre_Drugs= [RipplesDensity.M1251(1) RipplesDensity.M11251(1) RipplesDensity.M21251(1) RipplesDensity.M31251(1); ...
    RipplesDensity.M1253(1) RipplesDensity.M11253(1) RipplesDensity.M21253(1) RipplesDensity.M31253(1)];
All_RipplesDensity_SleepPost_Drugs= [RipplesDensity.M1251(2) RipplesDensity.M11251(2) RipplesDensity.M21251(2) RipplesDensity.M31251(2); ...
    RipplesDensity.M1253(2) RipplesDensity.M11253(2) RipplesDensity.M21253(2) RipplesDensity.M31253(2)];

All_REMProportion_SleepPre_Drugs= [REMProportion.M1251(1) REMProportion.M11251(1) REMProportion.M21251(1) REMProportion.M31251(1); ...
    REMProportion.M1253(1) REMProportion.M11253(1) REMProportion.M21253(1) REMProportion.M31253(1)];
All_REMproportion_SleepPost_Drugs= [REMProportion.M1251(2) REMProportion.M11251(2) REMProportion.M21251(2) REMProportion.M31251(2); ...
    REMProportion.M1253(2) REMProportion.M11253(2) REMProportion.M21253(2) REMProportion.M31253(2)];

%% Graph Parameter

% Cols = {[0.3 0.3 0.3],[0 0 1],[1 0 0],[1 0 1]};
% X = [1:4];
% Legends = {'DZP','Saline','Acute BUS','Chronic BUS'};
% 
% %% Sleep Propotion
% 
%         % Sleep Pre
% subplot(2,2,1)
% MakeSpreadAndBoxPlot2_SB(All_SleepPre_Proportion_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Pre');ylabel('%Sleep'); ylim([0 1]);
% xtickangle(45)
% 
% 
%         % Sleep Post
% subplot(2,2,2)
% MakeSpreadAndBoxPlot2_SB(All_SleepPost_Proportion_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Post');ylabel('%Sleep');ylim([0 1]);
% xtickangle(45)
% 
% Legends = {'Saline','DZP','Acute BUS','Chronic BUS'};
% 
% 
% %t1= [SleepProportion.M11251(1), SleepProportion.M1251(1),SleepProportion.M21251(1), SleepProportion.M31251(1)];
% %t2= [SleepProportion.M11253(1), SleepProportion.M1253(1),SleepProportion.M21253(1), SleepProportion.M31253(1)];
% 
% t1= [ SleepProportion.M11251(1),SleepProportion.M11251(2);
%     SleepProportion.M1251(1),SleepProportion.M1251(2);
%     SleepProportion.M21251(1),SleepProportion.M21251(2);
%     SleepProportion.M31251(1),SleepProportion.M31251(2)];
% 
% t2= [SleepProportion.M11253(1),SleepProportion.M11253(2);
%     SleepProportion.M1253(1),SleepProportion.M1253(2);
%     SleepProportion.M21253(1),SleepProportion.M21253(2); 
%     SleepProportion.M31253(1),SleepProportion.M31253(2)];
% 
% 
% subplot(2,2,3)
% bar(t1)
% xticklabels({'sess1','sess2','sess3', 'sess4'})
% xtickangle(45)
% title('Sleep M1251')
% ylabel('% Sleep')
% ylim([0 1])
% 
% 
% subplot(224)
% bar(t2)
% 
% xticklabels({'sess1','sess2','sess3', 'sess4'})
% xtickangle(45)
% title('Sleep  M1253')
% ylabel('% Sleep')
% ylim([0 1])
% a=suptitle('Sleep features, UMaze sleep sessions, n=2'); a.FontSize=20;
% 
% hold on 
% bar(t1)
% 
% %% Ripples
%     %Ripples Density during Sleep Pre
% figure
% subplot(1,2,1)
% MakeSpreadAndBoxPlot2_SB(All_RipplesDensity_SleepPre_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Pre');
% ylabel('Ripples/s');ylim([0 1]);
% xtickangle(45)
% 
%     %Ripples Density during Sleep Post
% subplot(1,2,2)
% MakeSpreadAndBoxPlot2_SB(All_RipplesDensity_SleepPost_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Post');
% ylabel('Ripples/s');ylim([0 1]);
% xtickangle(45)
% 
% a=suptitle('Ripples Density, UMaze sleep sessions, n=2'); a.FontSize=20;
% 
% 
% RipplesDensity_M1251_Drugs= [RipplesDensity.M11251(1) RipplesDensity.M11251(2);
%     RipplesDensity.M1251(1) RipplesDensity.M1251(2);
%     RipplesDensity.M21251(1) RipplesDensity.M21251(2);
%     RipplesDensity.M31251(1) RipplesDensity.M31251(2)];
% 
% RipplesDensity_M1253_Drugs= [RipplesDensity.M11253(1) RipplesDensity.M11253(2);
%     RipplesDensity.M1253(1) RipplesDensity.M1253(2);
%     RipplesDensity.M21253(1) RipplesDensity.M21253(2);
%     RipplesDensity.M31253(1) RipplesDensity.M31253(2)];
% 
% y1= [ SleepProportion.M1251(1),SleepProportion.M1251(2);
%     SleepProportion.M11251(1),SleepProportion.M11251(2);
%     SleepProportion.M21251(1),SleepProportion.M21251(2);
%     SleepProportion.M31251(1),SleepProportion.M31251(2)];
% 
% y2= [ SleepProportion.M1253(1),SleepProportion.M1253(2);
%     SleepProportion.M11253(1),SleepProportion.M11253(2);
%     SleepProportion.M21253(1),SleepProportion.M21253(2); 
%     SleepProportion.M31253(1),SleepProportion.M31253(2)];
% 
% figure
% subplot(1,2,1)
% bar(RipplesDensity_M1251_Drugs)
% xticklabels({'DIAZ','Saline','BUS acute', 'BUS chronic'})
% xtickangle(45)
% title('Sleep M1251')
% ylabel('% Sleep')
% ylim([0 0.9])
% legend('Sleep Pre' , 'Sleep Post')
% 
% subplot(122)
% bar(RipplesDensity_M1253_Drugs)
% xticklabels({'DIAZ','Saline','BUS acute', 'BUS chronic'})
% xtickangle(45)
% title('Sleep M1253')
% ylabel('% Sleep')
% ylim([0 0.9])
% 
% %% REM proportion
%     %Ripples Density during Sleep Pre
% figure
% subplot(1,2,1)
% MakeSpreadAndBoxPlot2_SB(All_REMProportion_SleepPre_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Pre');
% ylabel('%REM');ylim([0 1]);
% xtickangle(45)
% 
%     %Ripples Density during Sleep Post
% subplot(1,2,2)
% MakeSpreadAndBoxPlot2_SB(All_REMProportion_SleepPost_Drugs ,Cols,X,Legends,'showpoints',1,'paired',0);
% title('Sleep Post');
% ylabel('%REM');ylim([0 1]);
% xtickangle(45)
% 
% a=suptitle('Ripples Density, UMaze sleep sessions, n=2'); a.FontSize=20;
% saveFigure(2,'Ripples_Density_M1251-3','/home/mobshamilton/Desktop/Baptiste/FinalFigures/')
