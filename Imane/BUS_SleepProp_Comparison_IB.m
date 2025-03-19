

%% comparison BUS to a pool of mice

%without 1147 because sleep pre did no sleep and SWSEpoch absent in
%Baseline
Mouse_BS=[1184,1189,1205,1251,1253,1254]; % baseline
Mouse1st=[9184,1189,9205,11251,11253,11254]; % first maze mice 
Mouse2nd=[11184,11189,11205,1251,1253,1254]; % second maze mice

Mouse_BS=[1144,1146,1147,1170,1171,1174,1184,1189,1205,1206,1207,1251,1252,1253,1254]; % all baseline
Mouse1st=[1144,1146,1147,1170,1171,1174,9184,1189,9205,11200,11206,11207,11251,11252,11253,11254]; % all first maze mice 
Mouse2nd_All=[1251,1253,1254,11147,11184,11189,11204,11205]; % all second maze mice


MouseFlxAcute=[740,750,775,778,794]; % all acute Flx
MouseFlxChro= [875,876,877,1001,1002,1095,1130]; % all chronic Flx mice

s.sleep_pre = NaN ; s.sleep_post= NaN; s1.slbs=NaN;

%% Baseline

Session_type={'slbs'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA_BS.(Session_type{sess}) , Epoch_BS.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse_BS,lower(Session_type{sess}),'ripples');
    TSD_DATA_BS.(Session_type{sess}).ripples.mean(TSD_DATA_BS.(Session_type{sess}).ripples.mean==0)=NaN;
end

All_REM_prop_BS=[];
All_Sleep_prop_BS=[];

for mouse = 1:length(Mouse_BS) % generate all sessions of interest
     Mouse_names_BS{mouse}=['M' num2str(Mouse_BS(mouse))];
   for sess=1:length(Session_type)
        REM_prop_BS.(Mouse_names_BS{mouse}).(Session_type{sess}) = sum(Stop(Epoch_BS.(Session_type{sess}){mouse,5})-Start(Epoch_BS.(Session_type{sess}){mouse,5}))./(sum(Stop(Epoch_BS.(Session_type{sess}){mouse,3})-Start(Epoch_BS.(Session_type{sess}){mouse,3})));
        Sleep_prop_BS.(Mouse_names_BS{mouse}).(Session_type{sess}) = sum(Stop(Epoch_BS.(Session_type{sess}){mouse,3})-Start(Epoch_BS.(Session_type{sess}){mouse,3}))./(sum(Stop(Epoch_BS.(Session_type{sess}){mouse,1})-Start(Epoch_BS.(Session_type{sess}){mouse,1})));
    end
    All_REM_prop_BS= [All_REM_prop_BS; REM_prop_BS.(Mouse_names_BS{mouse}) ];
    All_Sleep_prop_BS = [All_Sleep_prop_BS ; Sleep_prop_BS.(Mouse_names_BS{mouse})];
end

All_REM_prop_BS= [All_REM_prop_BS;s1];
All_Sleep_prop_BS = [All_Sleep_prop_BS ;s1];
 
%% First Maze

Session_type={'sleep_pre','sleep_post'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA1.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse1st,lower(Session_type{sess}),'ripples');
    TSD_DATA1.(Session_type{sess}).ripples.mean(TSD_DATA1.(Session_type{sess}).ripples.mean==0)=NaN;
end

All_REM_prop=[];
All_Sleep_prop=[];

for mouse = 1:length(Mouse1st) % generate all sessions of interest
     Mouse_names1{mouse}=['M' num2str(Mouse1st(mouse))];
   for sess=1:length(Session_type)
        REM_prop.(Mouse_names1{mouse}).(Session_type{sess}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,5})-Start(Epoch1.(Session_type{sess}){mouse,5}))./(sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3})));
        Sleep_prop.(Mouse_names1{mouse}).(Session_type{sess}) = sum(Stop(Epoch1.(Session_type{sess}){mouse,3})-Start(Epoch1.(Session_type{sess}){mouse,3}))./(sum(Stop(Epoch1.(Session_type{sess}){mouse,1})-Start(Epoch1.(Session_type{sess}){mouse,1})));
    end
    All_REM_prop = [All_REM_prop ; REM_prop.(Mouse_names1{mouse}) ];
    All_Sleep_prop = [All_Sleep_prop ; Sleep_prop.(Mouse_names1{mouse})];
end

 All_REM_prop = [All_REM_prop ;s];
 All_Sleep_prop = [All_Sleep_prop ;s];
 
%% Second Maze

Session_type={'sleep_pre','sleep_post'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA2.(Session_type{sess}) , Epoch2.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse2nd,lower(Session_type{sess}),'ripples');
    TSD_DATA2.(Session_type{sess}).ripples.mean(TSD_DATA2.(Session_type{sess}).ripples.mean==0)=NaN;
end

All_REM_prop2=[];
All_Sleep_prop2=[];

for mouse = 1:length(Mouse2nd) % generate all sessions of interest
     Mouse_names2{mouse}=['M' num2str(Mouse2nd(mouse))];
   for sess=1:length(Session_type)
        REM_prop2.(Mouse_names2{mouse}).(Session_type{sess}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,5})-Start(Epoch2.(Session_type{sess}){mouse,5}))./(sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3})));
        Sleep_prop2.(Mouse_names2{mouse}).(Session_type{sess}) = sum(Stop(Epoch2.(Session_type{sess}){mouse,3})-Start(Epoch2.(Session_type{sess}){mouse,3}))./(sum(Stop(Epoch2.(Session_type{sess}){mouse,1})-Start(Epoch2.(Session_type{sess}){mouse,1})));
    end
    All_REM_prop2= [All_REM_prop2 ; REM_prop2.(Mouse_names2{mouse}) ];
    All_Sleep_prop2=[All_Sleep_prop2 ; Sleep_prop2.(Mouse_names2{mouse})];
end

All_REM_prop2= [All_REM_prop2 ;s];
All_Sleep_prop2=[All_Sleep_prop2 ;s];

%% Flx acute

Session_type={'sleep_pre','sleep_post'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA_FlxAc.(Session_type{sess}) , Epoch_FlxAc.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(MouseFlxAcute,lower(Session_type{sess}),'ripples');
    TSD_DATA_FlxAc.(Session_type{sess}).ripples.mean(TSD_DATA_FlxAc.(Session_type{sess}).ripples.mean==0)=NaN;
end

All_REM_prop_FlxAc=[];
All_Sleep_prop_FlxAc=[];

for mouse = 1:length(MouseFlxAcute) % generate all sessions of interest
     Mouse_names_FlxAc{mouse}=['M' num2str(MouseFlxAcute(mouse))];
   for sess=1:length(Session_type)
        REM_prop_FlxAc.(Mouse_names_FlxAc{mouse}).(Session_type{sess}) = sum(Stop(Epoch_FlxAc.(Session_type{sess}){mouse,5})-Start(Epoch_FlxAc.(Session_type{sess}){mouse,5}))./(sum(Stop(Epoch_FlxAc.(Session_type{sess}){mouse,3})-Start(Epoch_FlxAc.(Session_type{sess}){mouse,3})));
        Sleep_prop_FlxAc.(Mouse_names_FlxAc{mouse}).(Session_type{sess}) = sum(Stop(Epoch_FlxAc.(Session_type{sess}){mouse,3})-Start(Epoch_FlxAc.(Session_type{sess}){mouse,3}))./(sum(Stop(Epoch_FlxAc.(Session_type{sess}){mouse,1})-Start(Epoch_FlxAc.(Session_type{sess}){mouse,1})));
   end
   
    All_REM_prop_FlxAc= [All_REM_prop_FlxAc ; REM_prop_FlxAc.(Mouse_names_FlxAc{mouse}) ];
    All_Sleep_prop_FlxAc=[All_Sleep_prop_FlxAc ; Sleep_prop_FlxAc.(Mouse_names_FlxAc{mouse})];
end


All_REM_prop_FlxAc= [All_REM_prop_FlxAc ; s ;s ];
All_Sleep_prop_FlxAc=[All_Sleep_prop_FlxAc ; s ; s ];


%% Flx chronic

Session_type={'sleep_pre','sleep_post'};

for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA_FlxChro.(Session_type{sess}) , Epoch_FlxChro.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(MouseFlxChro,lower(Session_type{sess}),'ripples');
    TSD_DATA_FlxChro.(Session_type{sess}).ripples.mean(TSD_DATA_FlxChro.(Session_type{sess}).ripples.mean==0)=NaN;
end

All_REM_prop_FlxChro=[];
All_Sleep_prop_FlxChro=[];

for mouse = 1:length(MouseFlxChro) % generate all sessions of interest
     Mouse_names_FlxChro{mouse}=['M' num2str(MouseFlxChro(mouse))];
   for sess=1:length(Session_type)
        REM_prop_FlxChro.(Mouse_names_FlxChro{mouse}).(Session_type{sess}) = sum(Stop(Epoch_FlxChro.(Session_type{sess}){mouse,5})-Start(Epoch_FlxChro.(Session_type{sess}){mouse,5}))./(sum(Stop(Epoch_FlxChro.(Session_type{sess}){mouse,3})-Start(Epoch_FlxChro.(Session_type{sess}){mouse,3})));
        Sleep_prop_FlxChro.(Mouse_names_FlxChro{mouse}).(Session_type{sess}) = sum(Stop(Epoch_FlxChro.(Session_type{sess}){mouse,3})-Start(Epoch_FlxChro.(Session_type{sess}){mouse,3}))./(sum(Stop(Epoch_FlxChro.(Session_type{sess}){mouse,1})-Start(Epoch_FlxChro.(Session_type{sess}){mouse,1})));
    end
    All_REM_prop_FlxChro= [All_REM_prop_FlxChro ; REM_prop_FlxChro.(Mouse_names_FlxChro{mouse}) ];
    All_Sleep_prop_FlxChro=[All_Sleep_prop_FlxChro ; Sleep_prop_FlxChro.(Mouse_names_FlxChro{mouse})];
end

All_REM_prop_FlxChro= [All_REM_prop_FlxChro ];
All_Sleep_prop_FlxChro=[All_Sleep_prop_FlxChro];

%% Buspirone data 
SleepFeatures_M1253_M1251_IB

cd ('/media/nas6/ProjetEmbReact/Mouse1253/20211214')
load('BUS_Baseline_DATA_M1251_M1253.mat')

%% -------------------------------------------------- GRAPHICS  ------------------------------------------%%
%% Paired data
figure
subplot(131)
X = [1:5];
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
Legends={'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPost_1_s_t','SleepPost_2_n_d'};
MakeSpreadAndBoxPlot2_SB([All_Sleep_prop_BS.slbs; All_Sleep_prop.sleep_pre; All_Sleep_prop2.sleep_pre; All_Sleep_prop.sleep_post ;All_Sleep_prop2.sleep_post ]',Cols,X,Legends,'showpoints',1,'paired',1)
title('Sleep proportion n=6');ylabel('% Sleep');

% MakeSpreadAndBoxPlot2_SB([All_REM_prop_BS.slbs;All_REM_prop.sleep_pre;All_REM_prop2.sleep_pre; All_REM_prop.sleep_post ;All_REM_prop2.sleep_post   ]',Cols,X,Legends,'showpoints',0,'paired',1)
% title('REM proportion');ylabel('%REM');


%%  Buspirone

    %%%% REM
figure
subplot(121)
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
X = [1 3 4 7 8];

Legends={};
MakeSpreadAndBoxPlot2_SB([All_REM_prop_BS.slbs;All_REM_prop.sleep_pre;All_REM_prop2.sleep_pre; All_REM_prop.sleep_post ;All_REM_prop2.sleep_post   ]',Cols,X,Legends,'showpoints',1,'paired',0)
    p3=plot([2 2],[REM_prop_BaselineBUS.M1251.slbs; REM_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
    p1=plot([5 5],All_REMProportion_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
    p2=plot([6 6],All_REMProportion_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
    plot([9 9],All_REMproportion_SleepPost_Drugs(:,3),'.r','MarkerSize',30)
    plot([10 10],All_REMproportion_SleepPost_Drugs(:,4),'.m','MarkerSize',30)
title('REM proportion');ylabel('%REM'); ylim([0 0.2]); xlim([0 11])
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')
xticks([1:10])
xticklabels({'BaselineSleep','BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPre','SleepPre','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost','SleepPost'})
    
    %%%% Sleep
subplot(122)
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
X = [1 3 4 7 8];
Legends={};
MakeSpreadAndBoxPlot2_SB([All_Sleep_prop_BS.slbs; All_Sleep_prop.sleep_pre; All_Sleep_prop2.sleep_pre; All_Sleep_prop.sleep_post ;All_Sleep_prop2.sleep_post ]',Cols,X,Legends,'showpoints',1,'paired',0)
    p3=plot([2 2],[Sleep_prop_BaselineBUS.M1251.slbs ;Sleep_prop_BaselineBUS.M1253.slbs],'.c','MarkerSize',30);
    p1=plot([5 5],All_SleepPre_Proportion_Drugs(:,3),'.r','MarkerSize',30);
    p2=plot([6 6],All_SleepPre_Proportion_Drugs(:,4),'.m','MarkerSize',30);
    plot([9 9],All_SleepPost_Proportion_Drugs(:,3),'.r','MarkerSize',30);
    plot([10 10],All_SleepPost_Proportion_Drugs(:,4),'.m','MarkerSize',30);
title('Sleep proportion');ylabel('%Sleep'); ylim([0 1.05]); xlim([0 11])
legend([p1 p2 ],'BUS Acute','BUS chronic','location','best')
xticklabels({'BaselineSleep','BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPre','SleepPre','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost','SleepPost'})
xticks([1:10]) 

%% Fluoxetine

    %%%REM
figure
subplot(121)
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[1 0 0 ],[1 0 1],[0 0 1],[0 0 1], [1 0 0 ],[1 0 1 ] };
X = [1 2 3 4 5 6 7 8 9]; 
Legends = {'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_F_l_x_C_h_r_o','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost_F_l_x','SleepPost_F_l_x_C_h_r_o'};
MakeSpreadAndBoxPlot2_SB([All_REM_prop_BS.slbs;All_REM_prop.sleep_pre;All_REM_prop2.sleep_pre;All_REM_prop_FlxAc.sleep_pre ;All_REM_prop_FlxChro.sleep_pre; All_REM_prop.sleep_post ;All_REM_prop2.sleep_post ;All_REM_prop_FlxAc.sleep_post; All_REM_prop_FlxChro.sleep_post]',Cols,X,Legends,'showpoints',1,'paired',0)
title('REM proportion');ylabel('%REM');

  %%% Sleep
subplot(122)
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[1 0 0 ],[1 0 1],[0 0 1],[0 0 1], [1 0 0 ],[1 0 1] };
X = [1 2 3 4 5 6 7 8 9]; 
MakeSpreadAndBoxPlot2_SB([All_Sleep_prop_BS.slbs;All_Sleep_prop.sleep_pre;All_Sleep_prop2.sleep_pre;All_Sleep_prop_FlxAc.sleep_pre;All_Sleep_prop_FlxChro.sleep_pre; All_Sleep_prop.sleep_post ;All_Sleep_prop2.sleep_post ;All_Sleep_prop_FlxAc.sleep_post ; All_Sleep_prop_FlxChro.sleep_post]',Cols,X,Legends,'showpoints',1,'paired',0)
Legends = {'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_F_l_x_C_h_r_o','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost_F_l_x','SleepPost_F_l_x_C_h_r_o'};
title('Sleep proportion');ylabel('%Sleep');

%% BUS + Flx

    %%%REM
figure
subplot(121)
Cols = {[.4 .4 1],[.6 0 0 ],[.6 0 .6],[0 0 1], [0.6 0 0 ],[.6 0 .6] };
X = [1 2 4 6 7 9]; 
MakeSpreadAndBoxPlot2_SB([All_REM_prop2.sleep_pre;All_REM_prop_FlxAc.sleep_pre;All_REM_prop_FlxChro.sleep_pre ;All_REM_prop2.sleep_post ;All_REM_prop_FlxAc.sleep_post; All_REM_prop_FlxChro.sleep_post]',Cols,X,Legends,'showpoints',1,'paired',0)
    p1=plot([3 3],All_REMProportion_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
    p2=plot([5 5],All_REMProportion_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
    plot([8 8],All_REMproportion_SleepPost_Drugs(:,3),'.r','MarkerSize',30)
    plot([10 10],All_REMproportion_SleepPost_Drugs(:,4),'.m','MarkerSize',30)
title('REM proportion');ylabel('%REM'); ylim([0 0.2]); xlim([0 11])
legend([p1 p2 ],'BUS Acute','BUS chronic','location','best')
xticks([1:10])
xticklabels({'SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_B_u_s_A_c','SleepPre_F_l_x_C_h_r_o','SleepPre_B_u_s_C_h_r_o','SleepPost_2_n_d','SleepPost_F_l_x_A_c','SleepPost_B_u_s_A_c','SleepPost_F_l_x_C_h_r_o','SleepPre_B_u_s_C_h_r_o'})
 
    %%% Sleep
subplot(122)
Cols = {[.4 .4 1],[.6 0 0 ],[.6 0 .6],[0 0 1], [.6 0 0 ],[.6 0 .6] };
X = [1 2 4 6 7 9]; 
Legends={};
MakeSpreadAndBoxPlot2_SB([All_Sleep_prop2.sleep_pre;All_Sleep_prop_FlxAc.sleep_pre ;All_Sleep_prop_FlxChro.sleep_pre ;All_Sleep_prop2.sleep_post ;All_Sleep_prop_FlxAc.sleep_post; All_Sleep_prop_FlxChro.sleep_post]',Cols,X,Legends,'showpoints',1,'paired',0)
    p1=plot([3 3],All_SleepPre_Proportion_Drugs(:,3),'.r','MarkerSize',30);
    p2=plot([5 5],All_SleepPre_Proportion_Drugs(:,4),'.m','MarkerSize',30);
    plot([8 8],All_SleepPost_Proportion_Drugs(:,3),'.r','MarkerSize',30);
    plot([10 10],All_SleepPost_Proportion_Drugs(:,4),'.m','MarkerSize',30);
title('Sleep proportion');ylabel('%Sleep'); xlim([0 11])
legend([p1 p2 ],'BUS Acute','BUS chronic','location','best')
xticks([1:10])
xticklabels({'SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_B_u_s_A_c','SleepPre_F_l_x_C_h_r_o','SleepPre_B_u_s_C_h_r_o','SleepPost_2_n_d','SleepPost_F_l_x_A_c','SleepPost_B_u_s_A_c','SleepPost_F_l_x_C_h_r_o','SleepPre_B_u_s_C_h_r_o'})

%% Ripples

    %%% BUS
figure
Cols = {[.9 .9 1],[.4 .4 1],[.4 .4 1],[0 0 1],[0 0 1]};
X = [1 3 4 7 8]; 
Legends = {'BaselineSleep','SleepPre_1_s_t','SleepPre_2_n_d','SleepPost_1st','SleepPost_2nd'};
MakeSpreadAndBoxPlot2_SB( [{TSD_DATA_BS.slbs.ripples.mean(:,4)  TSD_DATA1.sleep_pre.ripples.mean(:,4)  TSD_DATA2.sleep_pre.ripples.mean(:,4)  TSD_DATA1.sleep_post.ripples.mean(:,4)  TSD_DATA2.sleep_post.ripples.mean(:,4)}],Cols,X,Legends,'showpoints',1,'paired',0);
    p3=plot([2 2],TSD_DATA_BaselineBUS.slbs.ripples.mean(:,4), '.c','MarkerSize',30);
    p1=plot([5 5],All_RipplesDensity_SleepPre_Drugs(:,3),'.r','MarkerSize',30);
    p2=plot([6 6],All_RipplesDensity_SleepPre_Drugs(:,4),'.m','MarkerSize',30);
    plot([9 9],All_RipplesDensity_SleepPost_Drugs(:,3),'.r','MarkerSize',30);
    plot([10 10],All_RipplesDensity_SleepPost_Drugs(:,4),'.m','MarkerSize',30)
title('Ripples Density'); ylabel('Ripples/s'); ylim([0 1]);xlim([0 11])
legend([p1 p2 p3],'BUS Acute','BUS chronic','Baseline','location','best')
xticks([1:10])
xticklabels({'BaselineSleep','BaselineSleep','SleepPre__1st','SleepPre__2nd','SleepPre','SleepPre','SleepPost__1st','SleepPost__2nd','SleepPost','SleepPost'})

    %%% Fluoxetine
figure
Cols = {[.4 .4 1],[.4 .4 1],[1 0 0 ],[1 0 1], [0 0 1],[0 0 1],[1 0 0 ],[1 0 1]};
X = [1 2 3 4 5 6 7 8]; 
Legends = {'SleepPre_1_s_t','SleepPre_2_n_d','SleepPre_F_l_x_A_c','SleepPre_F_l_x_C_h_r_o','SleepPost_1_s_t','SleepPost_2_n_d','SleepPost_F_l_x_A_c','SleepPost_F_l_x_C_h_r_o'};
MakeSpreadAndBoxPlot2_SB( [{ TSD_DATA1.sleep_pre.ripples.mean(:,4) TSD_DATA2.sleep_pre.ripples.mean(:,4)} TSD_DATA_FlxAc.sleep_pre.ripples.mean(:,4) TSD_DATA_FlxChro.sleep_pre.ripples.mean(:,4) TSD_DATA1.sleep_post.ripples.mean(:,4)  TSD_DATA2.sleep_post.ripples.mean(:,4) TSD_DATA_FlxAc.sleep_post.ripples.mean(:,4) TSD_DATA_FlxChro.sleep_post.ripples.mean(:,4) ],Cols,X,Legends,'showpoints',1,'paired',0);
title('Ripples Density'); ylabel('Ripples/s');


%% other legends
%xticks([1:10])
%xticklabels({'BaselineSleep','','SleepPre__S1','SleepPre__S2','SleepPre','SleepPre','SleepPost__S1','SleepPost__S2','SleepPost','SleepPost'})
%xticklabels({'BaselineSleep','','','SleepPre','','','SleepPost','',''})
%xticklabels({'BaselineSleep','Before injection','','SleepPre','BUS_A_c','BUS_C_h_r','SleepPost','BUS_A_c','BUS_C_h_r',})


%% Mouse folder modification 

%MouseCopy=Mouse;
%MouseCopy_names=Mouse_names;
%Mouse=MouseCopy;
%Mouse_names=MouseCopy_names;

%Mouse=Mouse(:,[20:40]);
%Mouse_names=Mouse_names(:,[20:40]);

%MouseToDelete=[794,875,876,877,1001,1002,1095,1130];
%MouseFirstMaze= [1144,1146,1147,1170,1171,1174,9184,1189,9205,11200,11206,11207,11251,11252,11253,11254];
%MouseSecondmaze=[1251,1253,1254,11147,11184,11189,11204,11205];

%c=zeros(1,length(Mouse));
%for n=1:length(MouseSecondmaze)
    
    %b = Mouse==MouseSecondmaze(n);
    %c=b+c;
    %Mouse_names(Mouse==MouseToDelete(n))=[]
    %Mouse(Mouse==MouseToDelete(n))=[];
   % b = Mouse_names(Mouse==MouseSecondmaze(n))
%end

%for n=1:length(c)    
 %if c(n)==0
   
     %Mouse(n)=0;
     %Mouse_names(n)={0};
 %end
%end

%Mouse(Mouse==0)=[];


