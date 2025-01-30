names = {'Tail','Nose','Neck','Body'};

for ind=1:length(names)
    for mouse=1:length(Dir2)
        cd(Dir2{mouse})
        load('Temp_Freezing.mat')
        Figure.(names{ind})(mouse,1)=Temp_Freezing.(names{ind}).sumup(3,1);
        Figure.(names{ind})(mouse,2)=Temp_Freezing.(names{ind}).sumup(4,1);
        Figure.(names{ind})(mouse,3)=Temp_Freezing.(names{ind}).sumup(3,2);
        Figure.(names{ind})(mouse,4)=Temp_Freezing.(names{ind}).sumup(4,2);
    end
end

for i=1:4
choose=input('choose Tail/Nose/Neck/Body : ','s');

b=min(min(Figure.(choose)));
c=max(max(Figure.(choose)));

figure
clf
subplot(1,2,1)
PlotErrorBarN_KJ(Figure.(choose)(:,1:2),'newfig',0)
ylim([b-0.5 c+0.5])
ylabel('Temperature °C');
xticks([1 2])
xticklabels({'Exploration','Freezing'})
title('Change Temperature Shock zones')
subplot(1,2,2)
PlotErrorBarN_KJ(Figure.(choose)(:,3:4),'newfig',0)
ylim([b-0.5 c+0.5])
xticks([1 2])
xticklabels({'Exploration','Freezing'})
ylabel('Temperature °C');
title('Change Temperature Safe zones')
suptitle([choose ' Temperature'])

end 

  

