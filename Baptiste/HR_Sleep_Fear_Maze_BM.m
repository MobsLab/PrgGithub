
clear all
GetEmbReactMiceFolderList_BM

Session_type={'Cond','Ext','sleep_pre','sleep_post'};
Drug_Group={'SalineSB','ChronicFlx','AcuteFlx','Midazolam','Saline','Diazepam','RipControl','RipInhib','Saline1','Saline2','DZP1','DZP2','RipInhib','ChronicBUS','AcuteBUS','RipControl','RipInhib1','RipControl1','RipInhibPaired','RipControlPaired','SalineMaze1Time1','DZPMaze1Time1','DZPMaze4Time1'};

Cols = {[0, 0, 1],[1, 0, 0],[1, .5, .5],[0, .5, 0],[.3, .745, .93],[.85, .325, .098],[.65, .75, 0],[.63, .08, .18]};
Legends = Drug_Group;
X = 1:8;
NoLegends = {'','','','','','','',''};

ind=1:5;
Group=1:8;


for group=Group
    Mouse=Drugs_Groups_UMaze_BM(group);
    for sess=2%:length(Session_type) % generate all data required for analyses
        [OutPutData.(Drug_Group{group}).(Session_type{sess}) , Epoch1.(Drug_Group{group}).(Session_type{sess}) , NameEpoch] = MeanValuesPhysiologicalParameters_BM(Mouse,lower(Session_type{sess}),'heartrate','heartratevar');
    end
end

for group=Group
    for sess=2%1:length(Session_type) % generate all data required for analyses
        OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean(OutPutData.(Drug_Group{group}).(Session_type{sess}).heartratevar.mean==0) = NaN;
        OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean(OutPutData.(Drug_Group{group}).(Session_type{sess}).heartrate.mean==0) = NaN;
    end
end

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OutPutData.RipControl.Cond.heartratevar.mean(:,5) OutPutData.RipControl.Cond.heartratevar.mean(:,6)},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1);
ylim([0 .18])
subplot(122)
MakeSpreadAndBoxPlot3_SB({OutPutData.RipInhib.Cond.heartratevar.mean(:,5) OutPutData.RipInhib.Cond.heartratevar.mean(:,6)},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1);

figure
subplot(121)
MakeSpreadAndBoxPlot3_SB({OutPutData.RipControl.Cond.heartrate.mean(:,5) OutPutData.RipControl.Cond.heartrate.mean(:,6)},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1);
ylim([9.5 12.6])
subplot(122)
MakeSpreadAndBoxPlot3_SB({OutPutData.RipInhib.Cond.heartrate.mean(:,5) OutPutData.RipInhib.Cond.heartrate.mean(:,6)},{[1 .5 .5],[.5 .5 1]},1:2,{'Shock','Safe'},'showpoints',0,'paired',1);



figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)...
        OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,5)...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,6)...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,5)...
        },{[.5 1 .5],[.7 1 .7],[1 .5 1],[1 .7 1],[1 .5 .5],[.5 .5 1]},1:6,{'SWS pre','REM pre','SWS post','REM post','Fz safe','Fz shock'},'showpoints',0,'paired',1);
    ylim([6 14.5])
    grid on
end

figure
for group=1:8
    subplot(1,8,group)
    try
        MakeSpreadAndBoxPlot3_SB({...
            OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)...
            OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)...
            OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,4)...
            OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,5)...
            OutPutData.(Drug_Group{group}).Ext.heartrate.mean(:,6)...
            OutPutData.(Drug_Group{group}).Ext.heartrate.mean(:,5)...
            },{[.5 1 .5],[.7 1 .7],[1 .5 1],[1 .7 1],[1 .5 .5],[.5 .5 1]},1:6,{'SWS pre','REM pre','SWS post','REM post','Fz safe','Fz shock'},'showpoints',0,'paired',1);
    end
    ylim([6 14.5])
    grid on
end




figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,5)./OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,6)./OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,5)./OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)...
        OutPutData.(Drug_Group{group}).Cond.heartrate.mean(:,6)./OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)...
        },{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'Fz shock/SWS','Fz safe/SWS','Fz shock/REM','Fz safe/REM'},'showpoints',0,'paired',1);
%     ylim([6 14.5])
    grid on
end



figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,5) OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,6)...
        OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,5)},{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'SWS','REM','Fz safe','Fz shock'},'showpoints',0,'paired',1);
%     ylim([6 14.5])
    grid on
end

figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,5)...
        OutPutData.(Drug_Group{group}).Ext.heartratevar.mean(:,6)...
        OutPutData.(Drug_Group{group}).Ext.heartratevar.mean(:,5)},{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'SWS','REM','Fz safe','Fz shock'},'showpoints',0,'paired',1);
%     ylim([6 14.5])
    grid on
end


figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,5)./OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,4)...
        OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,6)./OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,4)...
        OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,5)./OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,5)...
        OutPutData.(Drug_Group{group}).Cond.heartratevar.mean(:,6)./OutPutData.(Drug_Group{group}).sleep_pre.heartratevar.mean(:,5)...
        },{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'Fz shock/SWS','Fz safe/SWS','Fz shock/REM','Fz safe/REM'},'showpoints',0,'paired',1);
%     ylim([6 14.5])
    grid on
end


figure
for group=1:8    
    subplot(1,8,group)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)./OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)./OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,5)...
        },{[.5 1 .5],[1 .5 1]},1:2,{'SWS pre / SWS post','REM pre / REM post'},'showpoints',0,'paired',1);
    ylim([.75 1.25])
    grid on
end

figure
MakeSpreadAndBoxPlot3_SB({...
    OutPutData.(Drug_Group{5}).sleep_pre.heartrate.mean(:,4)./OutPutData.(Drug_Group{5}).sleep_post.heartrate.mean(:,4)...
OutPutData.(Drug_Group{6}).sleep_pre.heartrate.mean(:,4)./OutPutData.(Drug_Group{6}).sleep_post.heartrate.mean(:,4)...
},{[.3, .745, .93],[.85, .325, .098]},1:2,{'Saline','DZP'},'showpoints',1,'paired',0);


figure
for group=1:8    
    subplot(2,8,group)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,4)...
        OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,4)...
        },{[.5 1 .5],[1 .5 1]},1:2,{'SWS pre','SWS post'},'showpoints',0,'paired',1);
    ylim([6 9.5])
    grid on
    
        subplot(2,8,group+8)
    MakeSpreadAndBoxPlot3_SB({...
        OutPutData.(Drug_Group{group}).sleep_pre.heartrate.mean(:,5)...
        OutPutData.(Drug_Group{group}).sleep_post.heartrate.mean(:,5)...
        },{[.5 1 .5],[1 .5 1]},1:2,{'REM pre','REM post'},'showpoints',0,'paired',1);
    ylim([7 10.6])
    grid on
end




%%

n=1;
for group=1:8
    Mouse=Drugs_Groups_UMaze_BM(group);
    for mouse=1:length(Mouse)
        Mouse_names{mouse}=['M' num2str(Mouse(mouse))];
        UMazeSleepSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Sleep')))));
        for sess=1:2
            cd(UMazeSleepSess.(Mouse_names{mouse}){sess})
            
            clear Wake SWSEpoch REMEpoch Sleep Epoch tRipples
            load('StateEpochSB.mat', 'Wake' , 'SWSEpoch' , 'REMEpoch' , 'Sleep' , 'Epoch');
            try
                load('HeartBeatInfo.mat')
                
                HR_SWS.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(EKG.HBRate,SWSEpoch)));
                HR_REM.(Session_type{sess}){n}(mouse) = nanmean(Data(Restrict(EKG.HBRate,REMEpoch)));
            end
        end
    end
    n=n+1;
end


Cols = {[0.3, 0.745, 0.93],[0.85, 0.325, 0.098],[0.75, 0.75, 0],[0.6350, 0.0780, 0.1840]};
X = 1:4;
Legends = {'Saline','DZP','RipControl','RipInhib'};
NoLegends = {'','','',''};

figure
for i=1:4
    HR_SWS.sleep_pre{i}(HR_SWS.sleep_pre{i}==0)=NaN; HR_REM.sleep_pre{i}(HR_REM.sleep_pre{i}==0)=NaN;
    HR_Shock.Cond{i}(HR_Shock.Cond{i}==0)=NaN; HR_Safe.Cond{i}(HR_Safe.Cond{i}==0)=NaN;
    
    subplot(1,4,i)
    MakeSpreadAndBoxPlot3_SB({HR_SWS.sleep_pre{i} HR_REM.sleep_pre{i} HR_Shock.Cond{i} HR_Safe.Cond{i}},{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'SWS','REM','Fz shock','Fz safe'},'showpoints',0,'paired',1);
    ylim([6 14])
end

figure
for i=1:4
    
    subplot(1,4,i)
    MakeSpreadAndBoxPlot3_SB({HR_Shock.Cond{i}./HR_SWS.sleep_pre{i} HR_Shock.Cond{i}./HR_REM.sleep_pre{i}  HR_Safe.Cond{i}./HR_SWS.sleep_pre{i} HR_Safe.Cond{i}./HR_REM.sleep_pre{i}},{[1 .7 .7],[1 .5 .5],[1 .3 .3],[1 .15 .15]},1:4,{'Fz shock/SWS','Fz shock/REM','Fz safe/SWS','Fz safe/REM'},'showpoints',0,'paired',1);
end




