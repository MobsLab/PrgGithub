

Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
for mouse = 1:length(Mouse_names)
    % Sess.(Mouse_names{mouse}) = GetAllMouseTaskSessions(Mouse(mouse));
    CondSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Cond')))));
    HabSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Habituation')))));
    TestSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Test')))));
    ExtSess.(Mouse_names{mouse}) = Sess.(Mouse_names{mouse})(find(not(cellfun(@isempty,strfind(Sess.(Mouse_names{mouse}) ,'Extinction')))));
end

CondSess.M666=[{CondSess.M666{1}} {CondSess.M666{4}} {CondSess.M666{7}} {CondSess.M666{8}}];
for mouse = 1:length(Mouse_names)
    AllSess.(Mouse_names{mouse})=[CondSess.(Mouse_names{mouse}) TestSess.(Mouse_names{mouse}) ExtSess.(Mouse_names{mouse}) HabSess.(Mouse_names{mouse}){3:end}];
end



Zones={'Tail','Mask'};
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Control = Temperature_MovementControl(Mouse(mouse),CondSess,Zones{zones});
        MovementControl.(Zones{zones}).(Mouse_names{mouse})=Control;
    end
end

for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        for col=1:9
            MovementControl.(Zones{zones}).FinalFigure(mouse,col)=MovementControl.(Zones{zones}).(Mouse_names{mouse}).Temp_Accelero(col);
        end
        MeanTempPerMice.(Zones{zones}).(Mouse_names{mouse})=nanmean(Data(MovementControl.(Zones{zones}).(Mouse_names{mouse}).FearTemp));
    end
end

for zones=1:length(Zones)
    for mouse=1:length(Mouse_names)
        MovementControl.(Zones{zones}).FinalFigure(mouse,3:5)=MovementControl.(Zones{zones}).FinalFigure(mouse,3:5)-MeanTempPerMice.(Zones{zones}).(Mouse_names{mouse});
    end
end

figure
a=suptitle('Temperature and Movement, Control Analysis, n=10');
a.FontSize=30;

u=subplot(1,3,1);
PlotErrorBarN_SL(MovementControl.Tail.FinalFigure(:,1:2),'newfig',0,'colorpoints',1)
title('Freezing infos')
ylabel('Pourcentage (%)')
xticks([1 2])
xticklabels({'Freezing rate','Freezing shock / Freezing'})
set(gca,'FontSize',20)
makepretty

v=subplot(1,3,2);
[pval,hb,eb]=PlotErrorBoxPlotN_BM(MovementControl.Tail.FinalFigure(:,[5 4]),'newfig',0,'colorpoints',1)
%ylim([8.5 12])
xticks([1 2 3])
xticklabels({'All time','Freezing','Active'})
title('Tail Temperature corrected')
ylabel('Temperature (°C)')
v.FontSize=8;
makepretty
set(hb, 'linewidth' ,2)

w=subplot(1,3,3);
PlotErrorBarN_SL(MovementControl.Tail.FinalFigure(:,6:9),'newfig',0,'colorpoints',1)
xticks([1 2 3 4])
xticklabels({'All time','Hot Tail','Cold Tail','Freezing'})
ylabel('Movement quantity')
title('Accelerometer informations')
w.FontSize=8;
suptitle('Linking Movement and Tail Temperature, n=10')
makepretty


%% T°=f(log(MovAcctsd)) 
dt_Temp_Mov(:,1)=Data(Mouse667.FearTempIntExplo);
dt_Temp_Mov(:,2)=Data(Mouse667.FearMovAcctsdExplo);

[dt_Temp_Mov(:,3),dt_Temp_Mov(:,4)]=sort(dt_Temp_Mov(:,2));
dt_Temp_Mov(:,5)=dt_Temp_Mov(dt_Temp_Mov(:,4),1);   
plot(log(dt_Temp_Mov(:,3)),dt_Temp_Mov(:,5),'.r')
xlabel('log(MovAcctsd)')
ylabel('T°')
title('T°=f(log(MovAcctsd)) Mouse 667 Fear sessions Explo time')


a(:,1)=Data(Mouse667.FearXcoord);
a(:,2)=Data(Mouse667.FearYcoord);
a(:,3)=Data(Mouse667.FearTemp);

