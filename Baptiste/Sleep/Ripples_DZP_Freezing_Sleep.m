

%% Wake ripples
GetEmbReactMiceFolderList_BM

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};

Session_type={'Fear','Cond','Ext','CondPre','CondPost','TestPre','TestPost','sleep_pre','sleep_post'};
for sess=1:length(Session_type) % generate all data required for analyses
    [TSD_DATA.(Session_type{sess}) , Epoch1.(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'ripples');
end


for mouse=1:length(Mouse)
    Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sess=1:5
    
            Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,5);
            Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,6);
    
        end
    for sess=8:9
        SleepRipples.(Session_type{sess}).(Mouse_names{mouse}) = TSD_DATA.(Session_type{sess}).ripples.mean(mouse,4);
    end
    Mouse_names{mouse}
end


for group=1:length(Drug_Group)
    clear Mouse_names
    Drugs_Groups_UMaze_BM
    
    for sess=1:5
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            try
                Ripples.Shock.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Shock.(Session_type{sess}).(Mouse_names{mouse});
                Ripples.Safe.(Drug_Group{group}).(Session_type{sess})(mouse,:) = Ripples.Safe.(Session_type{sess}).(Mouse_names{mouse});
            end
        end
    end
    for sess=8:9
        for mouse=1:length(Mouse)
            Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
            SleepRipples.(Drug_Group{group}).(Session_type{sess})(mouse,:) = SleepRipples.(Session_type{sess}).(Mouse_names{mouse});
        end
    end
end

for sess=1:5
    for group=1:length(Drug_Group)
        Ripples.Figure.Shock.(Session_type{sess}){group} = Ripples.Shock.(Drug_Group{group}).(Session_type{sess});
        Ripples.Figure.Safe.(Session_type{sess}){group} = Ripples.Safe.(Drug_Group{group}).(Session_type{sess});
        Ripples.Figure.Shock.(Session_type{sess}){group}(Ripples.Figure.Shock.(Session_type{sess}){group}==0)=NaN;
        Ripples.Figure.Safe.(Session_type{sess}){group}(Ripples.Figure.Safe.(Session_type{sess}){group}==0)=NaN;
    end
end
for sess=8:9
    for group=1:length(Drug_Group)
        SleepRipples.Figure.(Session_type{sess}){group} = SleepRipples.(Drug_Group{group}).(Session_type{sess});
        SleepRipples.Figure.(Session_type{sess}){group}(SleepRipples.Figure.(Session_type{sess}){group}==0)=NaN;
    end
end


Cols = {[1 .5 .5],[.5 .5 1]};
X = [1,2];
Legends ={'Shock' 'Safe'};
NoLegends ={'' ''};

X2 = [1:8];
Cols2 = {[0, 0, 1],[1, 0, 0],[1, 0.5, 0.5],[0, 0.5, 0],[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.2, 0.645, 0.83],[0.75, 0.225, 0]};
Legends_Drugs2 ={'SalineSB' 'Chronic Flx' 'Acute Flx' 'Midazolam','Saline_Short','DZP_Short','Saline_Long','DZP_Long'};
NoLegends_Drugs2 ={'', '', '', '','','','',''};

Cols3 = {[0 0 1],[0 0 .5]};
Legends3 ={'Sleep Pre' 'Sleep Post'};

% paired by drug group, CondPre/CondPost/Ext
figure; m=1;
for sess=[4 5 3]
    n=1;
    for group=1:8
        subplot(3,8,n+(m-1)*8)
        try
            if m==3; MakeSpreadAndBoxPlot2_SB({Ripples.Figure.Shock.(Session_type{sess}){group} Ripples.Figure.Safe.(Session_type{sess}){group}},Cols,X,Legends,'showpoints',0);
            else; MakeSpreadAndBoxPlot2_SB({Ripples.Figure.Shock.(Session_type{sess}){group} Ripples.Figure.Safe.(Session_type{sess}){group}},Cols,X,NoLegends,'showpoints',0); end
            ylim([0 2])
            if group==1; ylabel('#/s'); u=text(-1.5,.7,Session_type{sess}); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold'); end
        end
        n=n+1;
        if m==1; title(Drug_Group{group}); end
    end
    m=m+1;
end
a=suptitle('Ripples density during freezing, UMaze'); a.FontSize=20;


% paired by drug group, Cond/Ext
figure; m=1;
for sess=[2 3]
    n=1;
    for group=1:8
        subplot(2,8,n+(m-1)*8)
        try
            if m==2; MakeSpreadAndBoxPlot2_SB({Ripples.Figure.Shock.(Session_type{sess}){group} Ripples.Figure.Safe.(Session_type{sess}){group}},Cols,X,Legends,'showpoints',0);
            else MakeSpreadAndBoxPlot2_SB({Ripples.Figure.Shock.(Session_type{sess}){group} Ripples.Figure.Safe.(Session_type{sess}){group}},Cols,X,NoLegends,'showpoints',0); end
        end
        ylim([0 2])
            if group==1; ylabel('#/s'); u=text(-1.5,.9,Session_type{sess}); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold'); end
        n=n+1;
        if m==1; title(Drug_Group{group}); end
    end
    m=m+1;
end
a=suptitle('Ripples density during freezing, UMaze'); a.FontSize=20;


% paired by session type, CondPre/CondPost/Ext
figure;
subplot(231)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Shock.CondPre,Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
title('CondPre'); ylabel('#/s')
u=text(-2.5,.8,'Shock'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');
subplot(232)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Shock.CondPost,Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
title('CondPost')
subplot(233)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Shock.Ext,Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
title('Ext')
subplot(234)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Safe.CondPre,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2]); ylabel('#/s')
u=text(-2.5,.8,'Safe'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');
subplot(235)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Safe.CondPost,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
subplot(236)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Safe.Ext,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])

a=suptitle('Ripples density during freezing, UMaze'); a.FontSize=20;


% paired by session type, Cond/Ext
figure;
subplot(221)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Shock.Cond,Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
title('Cond'); ylabel('#/s')
u=text(-2.5,.8,'Shock'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');
subplot(222)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Shock.Ext,Cols2,X2,NoLegends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])
title('Ext')
subplot(223)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Safe.Cond,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2]); ylabel('#/s')
u=text(-2.5,.8,'Safe'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');
subplot(224)
MakeSpreadAndBoxPlot2_SB(Ripples.Figure.Safe.Ext,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 2])

a=suptitle('Ripples density during freezing, UMaze'); a.FontSize=20;


% paired by drug group, SleepPre/SleepPost
figure; n=1;
for group=1:8
    subplot(1,8,n)
    try
        MakeSpreadAndBoxPlot2_SB({SleepRipples.Figure.sleep_pre{group} SleepRipples.Figure.sleep_post{group}},Cols3,X,Legends3,'showpoints',0);
        ylim([0 1])
        if group==1; ylabel('#/s'); end
    end
    n=n+1;
    title(Drug_Group{group})
end
a=suptitle('Ripples density during sleep, UMaze'); a.FontSize=20;


% paired by session type, SleepPre/SleepPost
figure;
subplot(121)
MakeSpreadAndBoxPlot2_SB(SleepRipples.Figure.sleep_pre,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 1])
title('Sleep Pre'); ylabel('#/s')
subplot(122)
MakeSpreadAndBoxPlot2_SB(SleepRipples.Figure.sleep_post,Cols2,X2,Legends_Drugs2,'showpoints',1,'paired',0);
ylim([0 1])
title('Sleep Post')

a=suptitle('Ripples density during sleep, UMaze'); a.FontSize=20;



%% Correlations ripples wake/sleep

for sess=1:length(Session_type) % generate all data required for analyses
    TSD_DATA.(Session_type{sess}).ripples.mean(TSD_DATA.(Session_type{sess}).ripples.mean==0)=NaN;
end

% shock/safe side freezing ripples density, fear with sleep
figure
subplot(221)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Fear.ripples.mean(:,5));
ylabel('Freezing, #/s'); ylim([0 1.5]); xlim([0 1])
title('Sleep Pre')
u=text(-.2,.6,'Shock'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(222)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Fear.ripples.mean(:,5));
ylim([0 1.5]); xlim([0 1])
title('Sleep Post')

subplot(223)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Fear.ripples.mean(:,6));
ylabel('Freezing, #/s'); xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])
u=text(-.2,.6,'Safe'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(224)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Fear.ripples.mean(:,6));
xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])

a=suptitle('Ripples density correlation between freezing and sleep'); a.FontSize=20;


% Cond/Ext shock freezing ripples density with sleep
figure
subplot(221)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Cond.ripples.mean(:,5));
ylabel('Freezing, #/s'); ylim([0 1.5]); xlim([0 1])
title('Sleep Pre')
u=text(-.2,.6,'Cond'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(222)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Cond.ripples.mean(:,5));
ylim([0 1.5]); xlim([0 1])
title('Sleep Post')

subplot(223)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Ext.ripples.mean(:,5));
ylabel('Freezing, #/s'); xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])
u=text(-.2,.6,'Ext'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(224)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Ext.ripples.mean(:,5));
xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])

a=suptitle('Ripples density correlation between shock freezing and sleep'); a.FontSize=20;


% Cond/Ext safe freezing ripples density with sleep
figure
subplot(221)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Cond.ripples.mean(:,6));
ylabel('Freezing, #/s'); ylim([0 1.5]); xlim([0 1])
title('Sleep Pre')
u=text(-.2,.6,'Cond'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(222)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Cond.ripples.mean(:,6));
ylim([0 1.5]); xlim([0 1])
title('Sleep Post')

subplot(223)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_pre.ripples.mean(:,4) , TSD_DATA.Ext.ripples.mean(:,6));
ylabel('Freezing, #/s'); xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])
u=text(-.2,.6,'Ext'); set(u,'FontSize',20,'Rotation',90,'FontWeight','bold');

subplot(224)
[R,P]=PlotCorrelations_BM(TSD_DATA.sleep_post.ripples.mean(:,4) , TSD_DATA.Ext.ripples.mean(:,6));
xlabel('Sleep, #/s'); ylim([0 1.5]); xlim([0 1])

a=suptitle('Ripples density correlation between safe freezing and sleep'); a.FontSize=20;


% Looking at my mice
figure
subplot(231)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,1) , TSD_DATA.Fear.wake_ripples.mean(27:end,5));
ylabel('Rip density shock, fear')

subplot(232)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,2) , TSD_DATA.Fear.wake_ripples.mean(27:end,5));

subplot(233)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,3) , TSD_DATA.Fear.wake_ripples.mean(27:end,5));

subplot(234)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,1) , TSD_DATA.Fear.wake_ripples.mean(27:end,6));
ylabel('Rip density safe, fear')
xlabel('Rip density Sleep Pre')

subplot(235)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,2) , TSD_DATA.Fear.wake_ripples.mean(27:end,6));
xlabel('Rip density Sleep Post Pre')
ylim([0 .8])

subplot(236)
[R,P]=PlotCorrelations_BM(RipplesDensityAll(27:end,3) , TSD_DATA.Fear.wake_ripples.mean(27:end,6));
xlabel('Rip density Sleep Post Post')

figure
for group=1:length(Drug_Group)
    subplot(2,4,group)
    try
        [R,P]=PlotCorrelations_BM(RipplesDensity.(Drug_Group{group})(:,3) , Ripples2.Figure.Safe.Cond{group});
    catch
        [R,P]=PlotCorrelations_BM(RipplesDensity.(Drug_Group{group})(:,2) , Ripples2.Figure.Safe.Cond{group});
    end
    xlim([0 .4]); ylim([0 .8])
end


%% Sleep ripples
clear all
GetEmbReactMiceFolderList_BM
for mouse =1:length(Mouse) % generate all sessions of interest
    AllSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
end

SleepSess={'SleepPre','SleepPost_Pre','SleepPost_Post'};
for mouse =1:length(Mouse) % generate all sessions of interest
    for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
        
        SleepEpoch.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'epoch','epochname','sleepstates');
        NREM_and_REM.(Mouse_names{mouse})=or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3});
        All_Epoch.(Mouse_names{mouse})=or(or(SleepEpoch.(Mouse_names{mouse}){2},SleepEpoch.(Mouse_names{mouse}){3}),SleepEpoch.(Mouse_names{mouse}){1});
        REM_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(SleepEpoch.(Mouse_names{mouse}){3})-Start(SleepEpoch.(Mouse_names{mouse}){3}))./(sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse}))))*100;
        Sleep_prop.(Mouse_names{mouse})(sleep_sess) = sum(Stop(NREM_and_REM.(Mouse_names{mouse}))-Start(NREM_and_REM.(Mouse_names{mouse})))./(sum(Stop(All_Epoch.(Mouse_names{mouse}))-Start(All_Epoch.(Mouse_names{mouse})))); Sleep_prop.(Mouse_names{mouse})(sleep_sess) = Sleep_prop.(Mouse_names{mouse})(sleep_sess)*100;
        
        % Ripples
        try
            Ripples.(Mouse_names{mouse})=ConcatenateDataFromFolders_SB(AllSleepSess.(Mouse_names{mouse})(sleep_sess),'sleep_ripples');
        catch
            RipplesDensity.(Mouse_names{mouse})(sleep_sess) = NaN;
        end
        if isempty(Ripples.(Mouse_names{mouse}))
            RipplesDensity.(Mouse_names{mouse})(sleep_sess) = NaN;
        else
            RipplesDensity.(Mouse_names{mouse})(sleep_sess) = length(Restrict(Ripples.(Mouse_names{mouse}),SleepEpoch.(Mouse_names{mouse}){2}))/(sum(Stop(SleepEpoch.(Mouse_names{mouse}){2})-Start(SleepEpoch.(Mouse_names{mouse}){2}))/1e4); % ripples density on SWS
        end
    end
    disp(Mouse_names{mouse})
end

Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','SalineBM_Short','Diazepam_Short','SalineBM_Long','Diazepam_Long'};
for group=1:length(Drug_Group)
    
    Drugs_Groups_UMaze_BM
    
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        for sleep_sess=1:length(AllSleepSess.(Mouse_names{mouse}))
            REM_prop.(Drug_Group{group})(mouse,sleep_sess)=REM_prop.(Mouse_names{mouse})(sleep_sess);
            Sleep_prop.(Drug_Group{group})(mouse,sleep_sess)=Sleep_prop.(Mouse_names{mouse})(sleep_sess);
            RipplesDensity.(Drug_Group{group})(mouse,sleep_sess)=RipplesDensity.(Mouse_names{mouse})(sleep_sess);
            RipplesDensity.(Drug_Group{group})(RipplesDensity.(Drug_Group{group})==0)=NaN;
        end
    end
end


Cols = {[0.66 0.66 1],[0 0 1],[0 0 0.33]};
X = [1,2,3];
Legends ={'SleepPre' 'SleepPost_Pre' 'SleepPost_Post'};
NoLegends ={'' '' ''};

a=figure; n=1;
for group=[1 5 6 7 8]
    subplot(1,5,n)
    MakeSpreadAndBoxPlot2_SB(RipplesDensity.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
    ylim([0 0.6])
    if group==1; ylabel('Ripples density'); end
    n=n+1;
    title(Drug_Group{group})
end

a=suptitle('Ripples density, sleep UMaze'); a.FontSize=20;

RipplesDensity.SalineBM_Long(5,3)=NaN;
RipplesDensity.Diazepam_Long(3,3)=RipplesDensity.Diazepam_Long(3,1);
RipplesDensity.Diazepam_Long(3,1)=NaN;
RipplesDensity.Diazepam_Long(4:6,3)=RipplesDensity.Diazepam_Long(4:6,2);
RipplesDensitySumUp.Saline(:,1) = [RipplesDensity.SalineBM_Short(:,1) ; RipplesDensity.SalineBM_Long(:,1)];
RipplesDensitySumUp.Saline(:,2) = [RipplesDensity.SalineBM_Short(:,2) ; RipplesDensity.SalineBM_Long(:,3)];
RipplesDensitySumUp.DZP(:,1) = [RipplesDensity.Diazepam_Short(:,1) ; RipplesDensity.Diazepam_Long(:,1)];
RipplesDensitySumUp.DZP(:,2) = [RipplesDensity.Diazepam_Short(:,2) ; RipplesDensity.Diazepam_Long(:,3)];

figure
subplot(121)
MakeSpreadAndBoxPlot2_SB(RipplesDensitySumUp.Saline,{[0.66 0.66 1],[0 0 1]},[1:2],{'SleepPre','SleepPost'},'showpoints',0);
ylim([0 .35]); ylabel('(#/s)')
title('Saline')
subplot(122)
MakeSpreadAndBoxPlot2_SB(RipplesDensitySumUp.DZP,{[0.66 0.66 1],[0 0 1]},[1:2],{'Pre','Post'},'showpoints',0);
ylim([0 .35])
title('DZP')

a=suptitle('Ripples density, Sleep UMaze'); a.FontSize=20;


a=figure; n=1;
for group=[1 5 6 7 8]
    subplot(1,5,n)
    MakeSpreadAndBoxPlot2_SB(REM_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
    %ylim([0 0.6])
    if group==1; ylabel('REM proportion'); end
    n=n+1;
    title(Drug_Group{group})
end

a=suptitle('Ripples density, sleep UMaze'); a.FontSize=20;


a=figure; n=1;
for group=[1 5 6 7 8]
    subplot(1,5,n)
    MakeSpreadAndBoxPlot2_SB(Sleep_prop.(Drug_Group{group}),Cols,X,Legends,'showpoints',0);
    %ylim([0 0.6])
    if group==1; ylabel('REM proportion'); end
    n=n+1;
    title(Drug_Group{group})
end


