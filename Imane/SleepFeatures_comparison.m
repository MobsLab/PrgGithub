%% Tps en min diff stage
TpsSleep= sum(Stop(Sleep)-Start(Sleep))/(1e4*60)
TpsWake= sum(Stop(Wake)-Start(Wake))/(1e4*60)
TpsSWS= sum(Stop(SWSEpoch)-Start(SWSEpoch))/(1e4*60)
TpsREM = sum(Stop(REMEpoch)-Start(REMEpoch))/(1e4*60) 

(sum(Stop(Wake)-Start(Wake))/(1e4*60) ) + (sum(Stop(Sleep)-Start(Sleep))/(1e4*60))

MeanValuesPhysiologicalParameters_BM(Mouse , lower(Session_type{sess}) , 'ripples')
MeanValuesPhysiologicalParameters_BM(1147 , lower('sleep_pre') , 'ripples')

%% comparison BUS to a pool of mice
% Paired analyses with "perfect" mice
Mouse_BS=[1147,1184,1189,1205,1251,1253,1254]; % baseline
Mouse1st=[1147,9184,1189,9205,11251,11253,11254]; % first maze mice 
Mouse2nd=[11147,11184,11189,11205,1251,1253,1254]; % second maze mice

% Paired analyses with "non-perfect" mice
Mouse_BS_All=[1144,1146,1147,1170,1171,1174,1184,1189,1205,1206,1207,1251,1252,1253,1254]; % all baseline
Mouse1st_All=[1144,1146,1147,1170,1171,1174,9184,1189,9205,11200,11206,11207,11251,11252,11253,11254]; % all first maze mice 
Mouse2nd_All=[1251,1253,1254,11147,11184,11189,11204,11205]; % all second maze mice

% others
MouseFlxAcute=[740,750,775,778,794]; % all acute Flx
MouseFlxChro= [875,876,877,1001,1002,1095,1130]; % all chronic Flx mice



%% Baseline
Session_type={'slbs','sleep_pre','sleep_post'};
Mice_Groups={'Perfect','NonPerfect'};
Sleep_sess={'First','Second'};

for sess=1:length(Session_type) % generate all data required for analyses
    for mice_group= 1:length(Mice_Groups)
        for sleep_sess = 1 : length(Sleep_sess)
            
            if sess==1 % Baseline sleep
                if mice_group==1 % perfect mice
                    Mouse=[1147,1184,1189,1205,1251,1253,1254];
                elseif mice_group==2 % non perfect mice
                    Mouse=[1144,1146,1147,1170,1171,1174,1184,1189,1205,1206,1207,1251,1252,1253,1254];
                end
                
                [TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}) , Epoch.(Session_type{sess}).(Mice_Groups{mice_group}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse , lower(Session_type{sess}) , 'ripples');
                TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}).ripples.mean(TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}).ripples.mean==0)=NaN;

            elseif or(sess==2,sess==3) % Sleep Pre
                if mice_group==1 % perfect mice
                    if sleep_sess==1 % first maze
                        Mouse=[1147,9184,1189,9205,11251,11253,11254];
                    else % second maze
                        Mouse=[11147,11184,11189,11205,1251,1253,1254];
                    end
                    
                else % non-perfect mice
                    if sleep_sess==1 % first maze
                        Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,11200,11206,11207,11251,11252,11253,11254];
                    else % second maze
                        Mouse=[1251,1253,1254,11147,11184,11189,11204,11205];
                    end
                end
                
                [TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}) , Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse , lower(Session_type{sess}) , 'ripples');
                TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}).ripples.mean(TSD_DATA.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}).ripples.mean==0)=NaN;

            end
        end
    end
end

for sess=1:length(Session_type) % generate all data required for analyses
    for mice_group= 1:length(Mice_Groups)
        for sleep_sess = 1 : length(Sleep_sess)
            
            if sess==1 % Baseline sleep
                if mice_group==1 % perfect mice
                    Mouse=[1147,1184,1189,1205,1251,1253,1254];
                elseif mice_group==2 % non perfect mice
                    Mouse=[1144,1146,1147,1170,1171,1174,1184,1189,1205,1206,1207,1251,1252,1253,1254];
                end
                
                for mouse = 1:length (Mouse)
                    Mouse_Name{mouse}=['M' num2str(Mouse(mouse))];
                    REM_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}) = sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,5})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,5}))./(sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,3})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,3})));
                    Sleep_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}) = sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,3})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,3}))./(sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,1})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}){mouse,1})));
                    Sleep_prop_all.(Session_type{sess}).(Mice_Groups {mice_group})(mouse)=Sleep_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group});
                    REM_prop_all.(Session_type{sess}).(Mice_Groups {mice_group})(mouse)=REM_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group});
                end

             elseif or(sess==2,sess==3) % Sleep Pre
                if mice_group==1 % perfect mice
                    if sleep_sess==1 % first maze
                        Mouse=[1147,9184,1189,9205,11251,11253,11254];
                    else % second maze
                        Mouse=[11147,11184,11189,11205,1251,1253,1254];
                    end
                    
                else % non-perfect mice
                    if sleep_sess==1 % first maze
                        Mouse=[1144,1146,1147,1170,1171,1174,9184,1189,9205,11200,11206,11207,11251,11252,11253,11254];
                    else % second maze
                        Mouse=[1251,1253,1254,11147,11184,11189,11204,11205];
                    end       
                end
                
                for mouse = 1:length (Mouse)
                    Mouse_Name{mouse}=['M' num2str(Mouse(mouse))];
                    REM_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess}) = sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,5})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,5}))./(sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,3})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,3})));
                    Sleep_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess}) = sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,3})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,3}))./(sum(Stop(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,1})-Start(Epoch.(Session_type{sess}).(Mice_Groups{mice_group}).(Sleep_sess{sleep_sess}){mouse,1})));
                    Sleep_prop_all.(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess})(mouse)= Sleep_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess}) ;
                    REM_prop_all.(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess})(mouse)= REM_prop.(Mouse_Name{mouse}).(Session_type{sess}).(Mice_Groups {mice_group}).(Sleep_sess{sleep_sess}) ;    
                end 
            end
        end
    end
end



%% Buspirone data 
SleepFeatures_M1253_M1251_IB

cd ('/media/nas6/ProjetEmbReact/Mouse1253/20211214')
load('BUS_Baseline_DATA_M1251_M1253.mat')

%% -------------------------------------------------- GRAPHICS  ------------------------------------------%%
%% Sleep Proportion
figure
subplot(121) % paired data
X = [1:5];
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
Legends={'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPost_1_s_t','SleepPost_2_n_d'};
MakeSpreadAndBoxPlot2_SB({Sleep_prop_all.slbs.Perfect(2:end) , Sleep_prop_all.sleep_pre.Perfect.First(2:end), Sleep_prop_all.sleep_pre.Perfect.Second(2:end) , Sleep_prop_all.sleep_post.Perfect.First(2:end) , Sleep_prop_all.sleep_post.Perfect.Second(2:end) },Cols,X,Legends,'showpoints',0,'paired',1)
title('Sleep proportion Paired n=6 ');ylabel('% Sleep');

subplot(122) %all data included BUS
MakeSpreadAndBoxPlot2_SB({Sleep_prop_all.slbs.NonPerfect , Sleep_prop_all.sleep_pre.NonPerfect.First(5:end), Sleep_prop_all.sleep_pre.NonPerfect.Second , Sleep_prop_all.sleep_post.NonPerfect.First , Sleep_prop_all.sleep_post.NonPerfect.Second },Cols,X,Legends,'showpoints',1,'paired',0)
title(' Sleep proportion');ylabel('% Sleep');

p3=plot([1 1],[Sleep_prop_BaselineBUS.M1251.slbs ;Sleep_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
hold on
p1=plot([3 3],All_SleepPre_Proportion_Drugs(:,3),'.r','MarkerSize',30);
hold on 
p2=plot([3 3],All_SleepPre_Proportion_Drugs(:,4),'.m','MarkerSize',30);
hold on 
plot([5 5],All_SleepPost_Proportion_Drugs(:,3),'.r','MarkerSize',30);
hold on 
plot([5 5],All_SleepPost_Proportion_Drugs(:,4),'.m','MarkerSize',30);
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')

figure %BUS alone
p3=plot([1 1],[Sleep_prop_BaselineBUS.M1251.slbs ;Sleep_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
hold on
p1=plot([2 2],All_SleepPre_Proportion_Drugs(:,3),'.r','MarkerSize',30);
hold on 
p2=plot([3 3],All_SleepPre_Proportion_Drugs(:,4),'.m','MarkerSize',30);
hold on 
plot([4 4],All_SleepPost_Proportion_Drugs(:,3),'.r','MarkerSize',30);
hold on 
plot([5 5],All_SleepPost_Proportion_Drugs(:,4),'.m','MarkerSize',30);
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')

title('Sleep proportion');ylabel('%Sleep');
xticklabels({'BaselineSleep','SleepPre__Ac','SleepPre__Chro','SleepPost__Ac','SleepPost__Chro'})
xticks([1:5]); xlim([0,6]); xtickangle(45)

%% REM proportion
figure
subplot(121)% paired data
X = [1:5];
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
Legends={'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPost_1_s_t','SleepPost_2_n_d'};
MakeSpreadAndBoxPlot2_SB({REM_prop_all.slbs.Perfect(2:end) , REM_prop_all.sleep_pre.Perfect.First(2:end), REM_prop_all.sleep_pre.Perfect.Second(2:end) , REM_prop_all.sleep_post.Perfect.First(2:end) , REM_prop_all.sleep_post.Perfect.Second(2:end)},Cols,X,Legends,'showpoints',0,'paired',1)
title('REM proportion Paired n=6 ');ylabel('% REM');

subplot(122)  %all data included BUS
MakeSpreadAndBoxPlot2_SB({REM_prop_all.slbs.NonPerfect , REM_prop_all.sleep_pre.NonPerfect.First(4:end), REM_prop_all.sleep_pre.NonPerfect.Second , REM_prop_all.sleep_post.NonPerfect.First , REM_prop_all.sleep_post.NonPerfect.Second },Cols,X,Legends,'showpoints',1,'paired',0)
title(' REM proportion');ylabel('% REM');

p3=plot([1 1],[REM_prop_BaselineBUS.M1251.slbs ;REM_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
hold on
p1=plot([3 3],All_REMProportion_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
hold on 
p2=plot([3 3],All_REMProportion_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
hold on 
plot([5 5],All_REMproportion_SleepPost_Drugs(:,3),'.r','MarkerSize',30);
hold on 
plot([5 5],All_REMproportion_SleepPost_Drugs(:,4),'.m','MarkerSize',30);
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')

% BUS alone
figure 
p3=plot([1 1],[REM_prop_BaselineBUS.M1251.slbs ;REM_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
hold on
p1=plot([3 3],All_REMProportion_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
hold on 
p2=plot([3 3],All_REMProportion_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
hold on 
plot([5 5],All_REMproportion_SleepPost_Drugs(:,3),'.r','MarkerSize',30);
hold on 
plot([5 5],All_REMproportion_SleepPost_Drugs(:,4),'.m','MarkerSize',30);
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')
title('REM proportion');ylabel('%REM');
xticklabels({'BaselineSleep','SleepPre__Ac','SleepPre__Chro','SleepPost__Ac','SleepPost__Chro'})
xticks([1:5]); xlim([0,6]); xtickangle(45)

%% Ripples
figure
subplot(121)% paired data
X = [1:5];
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
Legends={'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPost_1_s_t','SleepPost_2_n_d'};

MakeSpreadAndBoxPlot2_SB({TSD_DATA.slbs.Perfect.ripples.mean(:,4)' , TSD_DATA.sleep_pre.Perfect.First.ripples.mean(2:end,4)', TSD_DATA.sleep_pre.Perfect.Second.ripples.mean(2:end,4)' , TSD_DATA.sleep_post.Perfect.First.ripples.mean(2:end,4)' , TSD_DATA.sleep_post.Perfect.Second.ripples.mean(2:end,4)'},Cols,X,Legends,'showpoints',0,'paired',1)
title('Ripples Density Paired n=6 ');ylabel('Ripples/s');xlim([0,6]);

subplot(122) %all data with BUS
MakeSpreadAndBoxPlot2_SB({TSD_DATA.slbs.NonPerfect.ripples.mean(:,4)' , TSD_DATA.sleep_pre.NonPerfect.First.ripples.mean(3:end,4)', TSD_DATA.sleep_pre.NonPerfect.Second.ripples.mean1(:,4)' , TSD_DATA.sleep_post.NonPerfect.First.ripples.mean(3:end,4)' , TSD_DATA.sleep_post.NonPerfect.Second.ripples.mean1(:,4)'},Cols,X,Legends,'showpoints',1,'paired',0)
title('Ripples Density');ylabel('Ripples/s');xlim([0,6]);

p3=plot([1 1],TSD_DATA_BaselineBUS.slbs.ripples.mean(:,4), '.c','MarkerSize',30);
hold on    
p1=plot([3 3],All_RipplesDensity_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
hold on
p2=plot([3 3],All_RipplesDensity_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
hold on
plot([5 5],All_RipplesDensity_SleepPost_Drugs(:,3),'.r','MarkerSize',30);
hold on
plot([5 5],All_RipplesDensity_SleepPost_Drugs(:,4),'.m','MarkerSize',30);
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best');



% title('Ripples Density'); ylabel('Ripples/s'); ylim([0 1]);xlim([0 11])
% legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')
% xticks([1:10])
% xticklabels({'BaselineSleep','BaselineSleep','SleepPre__1st','SleepPre__2nd','SleepPre','SleepPre','SleepPost__1st','SleepPost__2nd','SleepPost','SleepPost'})
% 
%     %%% Fluoxetine
% figure
% Cols = {[.4 .4 1],[.4 .4 1],[1 0 0 ],[1 0 1], [0 0 1],[0 0 1],[1 0 0 ],[1 0 1]};
% X = [1 2 3 4 5 6 7 8]; 
% Legends = {'SleepPre_1_s_t','SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_F_l_x_C_h_r_o','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost_F_l_x_A_c','SleepPost_F_l_x_C_h_r_o'};
% MakeSpreadAndBoxPlot2_SB( [{ TSD_DATA1.sleep_pre.ripples.mean(:,4) TSD_DATA2.sleep_pre.ripples.mean(:,4)} TSD_DATA_FlxAc.sleep_pre.ripples.mean(:,4) TSD_DATA_FlxChro.sleep_pre.ripples.mean(:,4) TSD_DATA1.sleep_post.ripples.mean(:,4)  TSD_DATA2.sleep_post.ripples.mean(:,4) TSD_DATA_FlxAc.sleep_post.ripples.mean(:,4) TSD_DATA_FlxChro.sleep_post.ripples.mean(:,4) ],Cols,X,Legends,'showpoints',1,'paired',0);
% title('Ripples Density'); ylabel('Ripples/s');


%% other legends
%xticks([1:10])
%xticklabels({'BaselineSleep','','SleepPre__S1','SleepPre__S2','SleepPre','SleepPre','SleepPost__S1','SleepPost__S2','SleepPost','SleepPost'})
%xticklabels({'BaselineSleep','','','SleepPre','','','SleepPost','',''})
%xticklabels({'BaselineSleep','Before injection','','SleepPre','BUS_A_c','BUS_C_h_r','SleepPost','BUS_A_c','BUS_C_h_r',})



