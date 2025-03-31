

Mouse_names={'M666','M667','M668','M669','M739','M777','M849'};
Inner_perc = 75;
for i=1:length(Mouse_names)
    
    FearFz = Restrict(TailTemperature.(Mouse_names{i}).FearFz,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFz)));
    FearFzSafe = Restrict(TailTemperature.(Mouse_names{i}).FearFzSafe,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzSafe)));
    FearFzShock = Restrict(TailTemperature.(Mouse_names{i}).FearFzShock,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzShock)));
    
    
    Cond={'Fear','FearFz','FearFzSafe','FearFzShock'};
    for cond=1:length(Cond)
        if cond==1
            X = TailTemperatureEKG.HBRate.(Mouse_names{i}).(Cond{cond});
            Y = TailTemperature.(Mouse_names{i}).(Cond{cond});
        elseif cond==2
            X=TailTemperatureEKG.HBRate.(Mouse_names{i}).(Cond{cond});
            Y=FearFz;
        elseif cond==3
            X=TailTemperatureEKG.HBRate.(Mouse_names{i}).(Cond{cond});
            Y=FearFzSafe;
        else
            X=TailTemperatureEKG.HBRate.(Mouse_names{i}).(Cond{cond});
            Y=FearFzShock;
        end
        
        X_CenterDist = tsd(Range(X),abs(Data(X) - nanmean(Data(X))));
        Y_CenterDist = tsd(Range(Y),abs(Data(Y) - nanmean(Data(Y))));
        XY_CenterDist=tsd(Range(X),(abs(Data(X) - nanmean(Data(X))).*(abs(Data(Y) - nanmean(Data(Y))))));
        
        %X_CenterDist2=tsd(RangeCenterX,DataCenterX);
        
        Prc=prctile(Data(XY_CenterDist),Inner_perc); DataCenterXY=Data(XY_CenterDist);
        DataCenterX=Data(X_CenterDist); RangeCenterX=Range(X_CenterDist);
        DataX=Data(X); RangeX=Range(X);
        DataX2=DataX(DataCenterXY<Prc); RangeX2=RangeX(DataCenterXY<Prc);
        
        DataCenterY=Data(Y_CenterDist); RangeCenterY=Range(Y_CenterDist);
        DataY=Data(Y); RangeY=Range(Y);
        DataY2=DataY(DataCenterXY<Prc); RangeY2=RangeY(DataCenterXY<Prc);
                       
        intdat_X=DataX2;
        intdat_Y=DataY2;
        
        intdat_X=intdat_X(~ isnan(intdat_Y));
        intdat_Y=intdat_Y(~ isnan(intdat_Y));
        
        K=convhull(intdat_X,intdat_Y);
        Cont.(Mouse_names{i}).(Cond{cond})(1,:)=intdat_X(K);
        Cont.(Mouse_names{i}).(Cond{cond})(2,:)=intdat_Y(K);
    end
end

figure
i=1;
plot(Cont.(Mouse_names{i}).Fear(1,:),Cont.(Mouse_names{i}).Fear(2,:),'r','linewidth',2)
hold on;         plot(Cont.(Mouse_names{i}).FearFz(1,:),Cont.(Mouse_names{i}).FearFz(2,:),'c','linewidth',2)

for i=2:length(Mouse_names)
    plot(Cont.(Mouse_names{i}).Fear(1,:),Cont.(Mouse_names{i}).Fear(2,:),'r','linewidth',2)
end
for i=2:length(Mouse_names)
    plot(Cont.(Mouse_names{i}).FearFz(1,:),Cont.(Mouse_names{i}).FearFz(2,:),'c','linewidth',2)
end

xlabel('Heart Rate');       ylabel('Temperature'); 
title('Contour of Temperature=f(Heart Rate), Saline mice (n=7)')
legend('fear sessions','freezing')
xlim([2 18]);  ylim([15 40])

figure
i=1;
plot(Cont.(Mouse_names{i}).FearFzShock(1,:),Cont.(Mouse_names{i}).FearFzShock(2,:),'m','linewidth',2)
hold on;         plot(Cont.(Mouse_names{i}).FearFzSafe(1,:),Cont.(Mouse_names{i}).FearFzSafe(2,:),'g','linewidth',2)

for i=2:length(Mouse_names)
    plot(Cont.(Mouse_names{i}).FearFzShock(1,:),Cont.(Mouse_names{i}).FearFzShock(2,:),'m','linewidth',2)
end
for i=2:length(Mouse_names)
    plot(Cont.(Mouse_names{i}).FearFzSafe(1,:),Cont.(Mouse_names{i}).FearFzSafe(2,:),'g','linewidth',2)
end

xlabel('Heart Rate');       ylabel('Temperature'); 
title('Contour of Temperature=f(Heart Rate), Saline mice (n=7)')
legend('Shock freezing','Safe freezing')
xlim([2 18]);  ylim([15 40])

%% mean 

figure
for i=1:length(Mouse_names)
    
    FearFz = Restrict(TailTemperature.(Mouse_names{i}).FearFz,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFz)));
    FearFzSafe = Restrict(TailTemperature.(Mouse_names{i}).FearFzSafe,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzSafe)));
    FearFzShock = Restrict(TailTemperature.(Mouse_names{i}).FearFzShock,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzShock)));
    
    plot(mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).Fear)),nanmean(Data(TailTemperature.(Mouse_names{i}).Fear)),'.r','MarkerSize',30);
    hold on;    plot(mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFz)),nanmean(Data(FearFz)),'.c','MarkerSize',30);
    FigureMeanTempHR(1,i)=mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).Fear));
    FigureMeanTempHR(2,i)=nanmean(Data(TailTemperature.(Mouse_names{i}).Fear));
    FigureMeanTempHR(3,i)=mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFz));
    FigureMeanTempHR(4,i)=nanmean(Data(TailTemperature.(Mouse_names{i}).FearFz));
    
end

xlabel('Heart Rate');       ylabel('Temperature'); 
title('Temperature=f(Heart Rate), Mean values, Fear sessions / Freezing, Saline mice (n=7)')
xlim([8 13]);  ylim([26 31.5])
%lines
for i=1:length(Mouse_names)
    line([FigureMeanTempHR(1,i) FigureMeanTempHR(3,i)], [FigureMeanTempHR(2,i) FigureMeanTempHR(4,i)]', 'color',[0.6 0.6 0.6]);
end
legend('fear sessions','freezing')


figure
for i=1:length(Mouse_names)
    
    FearFzSafe = Restrict(TailTemperature.(Mouse_names{i}).FearFzSafe,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzSafe)));
    FearFzShock = Restrict(TailTemperature.(Mouse_names{i}).FearFzShock,ts(Range(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzShock)));
    
    plot(mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzShock)),nanmean(Data(TailTemperature.(Mouse_names{i}).FearFzShock)),'.m','MarkerSize',30);
    hold on;    plot(mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzSafe)),nanmean(Data(FearFzSafe)),'.g','MarkerSize',30);
    FigureMeanTempHR(5,i)=mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzShock));
    FigureMeanTempHR(6,i)=nanmean(Data(TailTemperature.(Mouse_names{i}).FearFzShock));
    FigureMeanTempHR(7,i)=mean(Data(TailTemperatureEKG.HBRate.(Mouse_names{i}).FearFzSafe));
    FigureMeanTempHR(8,i)=nanmean(Data(TailTemperature.(Mouse_names{i}).FearFzSafe));
end

xlabel('Heart Rate');       ylabel('Temperature'); 
title('Temperature=f(Heart Rate), Mean values, Shock Zones Freezing / Safe Zones Freezing, Saline mice (n=7)')
xlim([8 13]);  ylim([26 31.5])
%lines
for i=1:length(Mouse_names)
    if FigureMeanTempHR(6,i)>FigureMeanTempHR(8,i)
        line([FigureMeanTempHR(5,i) FigureMeanTempHR(7,i)], [FigureMeanTempHR(6,i) FigureMeanTempHR(8,i)]', 'color','r');
    else
        line([FigureMeanTempHR(5,i) FigureMeanTempHR(7,i)], [FigureMeanTempHR(6,i) FigureMeanTempHR(8,i)]', 'color','b');
    end
end
legend('Shock freezing','Safe freezing')



