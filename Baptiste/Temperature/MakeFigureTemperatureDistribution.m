



Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
Mouse=[666 667 668 669 688 739 777 779 849 893];
Zones={'Tail','Mask'};
for zones=1:length(Zones)
    for mouse=1:length(Mouse)
        Distribution = Temperature_Distribution(Mouse(mouse),Sess2,Zones{zones})
        TemperatureDistribution.Tail_Room.(Mouse_names{mouse})=Distribution;
    end
end





