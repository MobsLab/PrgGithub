%% Room Temperature

%Evolution of Temperature along the day
Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
for i=1:length(Mouse_names);
error={};
tps = 0; % this variable counts the total time of all concatenated data
for ff=1:length(FolderList.(Mouse_names{i}).Fear)
    try cd([FolderList.(Mouse_names{i}).Fear{ff} '/Temperature'])
        
file=dir('*.avi'); filename=file.name;
pathname=pwd;
pathAVI=fullfile(pathname,filename);

movie=importdata(pathAVI);

frame=round(length(movie)/2);
VideoFrame=movie(frame).cdata(:,:,1);
VideoFrameCelcius=IR2DEG(cd,VideoFrame);
load('behavResources.mat')
RoomTemp=VideoFrameCelcius(logical(mask));
RoomTemperature.(Mouse_names{i})(ff)=mean(RoomTemp);
RoomTemperature_all.(Mouse_names{i})(ff)=mean(mean(VideoFrameCelcius));
    catch error{ff}=FolderList.(Mouse_names{i}).Fear{ff};
    end
end
end

figure
for i=1:length(Mouse_names);
    plot(RoomTemperature.(Mouse_names{i}),'Linewidth',2)
    hold on
end
legend('M666','M667','M668','M669','M688','M739','M777','M779','M849','M893')
xlabel('sessions number')
ylabel('Room Temperature (°C)')
title('Room Temperature Evolution for saline mice during test day')

%Mean evolution for all the mice
for i=1:length(Mouse_names)
    RoomTemperature.all_mice(i,1:length(RoomTemperature.(Mouse_names{i})))=RoomTemperature.(Mouse_names{i});
end
RoomTemperature.all_mice(RoomTemperature.all_mice==0)=NaN;

RoomTemperature.all_mice(end+1,:)=nanmean(RoomTemperature.all_mice);

figure
plot(RoomTemperature.all_mice(11,:),'Linewidth',2)
xlabel('sessions number')
ylabel('Room Temperature (°C)')
title('Room Temperature Evolution for saline mice during test day')




%% Correlation with Temperature mean values

%Making an array with :
% - mean room temperature during the day
% - mean tail temperature
% - mean body temperature
% - body/tail temperature difference
% - mean Paris temperature the day of experiment
% (https://www.infoclimat.fr/climatologie/annee/2019/paris-montsouris/valeurs/07156.html)
for i=1:length(Mouse_names);
    RoomTemperature.analysis(1,i)=nanmean(Data(TemperatureDistribution.Room.(Mouse_names{i}).Total));
    RoomTemperature.analysis(2,i)=nanmean(Data(TemperatureDistribution.Tail.(Mouse_names{i}).Total));
    RoomTemperature.analysis(3,i)=nanmean(Data(TemperatureDistribution.Body.(Mouse_names{i}).Total));
    RoomTemperature.analysis(4,i)=nanmean(Data(TemperatureDistribution.Mouse.(Mouse_names{i}).Total));
    RoomTemperature.analysis(5,i)=RoomTemperature.analysis(3,i)-RoomTemperature.analysis(2,i);
end
% find line equation
p=polyfit(RoomTemperature.analysis(1,:),RoomTemperature.analysis(2,:),1)
p2=polyfit(RoomTemperature.analysis(1,:),RoomTemperature.analysis(3,:),1)
p3=polyfit(RoomTemperature.analysis(1,:),RoomTemperature.analysis(4,:),1)
x=20:26;
y=x.*p(1)+p(2);
y2=p2(1).*x+p2(2);
y3=p3(1).*x+p3(2);

[R,P] = corrcoef(RoomTemperature.analysis(1,:),RoomTemperature.analysis(2,:))
[R2,P2] = corrcoef(RoomTemperature.analysis(1,:),RoomTemperature.analysis(3,:))
[R3,P3] = corrcoef(RoomTemperature.analysis(1,:),RoomTemperature.analysis(4,:))

plot(x,y); plot(x,y2); plot(x,y3)
xlim([20 26])
xlabel('Mean Room Temperature (°C)')
ylabel('Mean Body Part Temperature (°C)')
% Make lines between body and tail temperature
for i=1:length(Mouse_names)
        line([RoomTemperature.analysis(1,i) RoomTemperature.analysis(1,i)], [RoomTemperature.analysis(2,i) RoomTemperature.analysis(3,i)]', 'color','k');
end
legend('Tail Temperature','Body Temperature','Mouse Temperature',['y=' num2str(p(1)) 'x+' num2str(p(2)) '  R=' num2str(R(1,2)) '   p-val=' num2str(P(1,2))],['y=' num2str(p2(1)) 'x+' num2str(p2(2)) '  R=' num2str(R2(1,2)) '   p-val=' num2str(P2(1,2))],['y=' num2str(p3(1)) 'x+' num2str(p3(2)) '  R=' num2str(R3(1,2)) '   p-val=' num2str(P3(1,2))])
title('Influence of Room Temperature on Tail/Body/Mouse Temperature (n=10 mice)')

figure
plot(RoomTemperature.analysis(1,:),RoomTemperature.analysis(5,:),'.m','MarkerSize',30)
xlabel('Room Temperature (°C)')
ylabel('Difference Body T°-Tail T° (°C)')
title('Influence of Room Temperature on Body-Tail-Mouse Temperature Difference (n=10)')
legend('Body-Tail Temperature Difference')

RoomTemperature.analysis(7,:)=[4 7 7 4 20 23 33 6 18.5];
figure
plot(RoomTemperature.analysis(6,:),RoomTemperature.analysis(1,:),'.g','MarkerSize',30)
xlabel('Mean Temperature in Paris for the experiment day (°C)')
ylabel('Room Temperature (°C)')
title('Influence of outside temperature on room Temperature')
xlim([-1 35])


%% Intra-variability


Mouse_names={'M688'};
i=1;
error={};
tps = 0; % this variable counts the total time of all concatenated data
for ff=1:16
    try cd([FolderList.(Mouse_names{i}).Fear{ff}  '/Temperature'])
        load('Temperature.mat')
Mouse688.ColdRoom(1,ff)=nanmean(Data(Temp.TailTemperatureTSD));
Mouse688.ColdRoom(2,ff)=nanmean(Data(Temp.BodyTemperatureTSD));
        
    catch error{ff}=FolderList.(Mouse_names{i}).Fear{ff};
    end
end
plot(Mouse688.ColdRoom','Linewidth',2)
hold on
plot(RoomTemperature.M688,'Linewidth',2)
 
xlabel('sessions number')
ylabel('Temperature (°C)')
title('Influence of room temperature change on body/tail temperature (Mouse 688)')
legend('Tail Temperature','Body Temperature','Room Temperature')



%% all the room

for i=1:length(Mouse_names)
    a(i,1:length(RoomTemperature_all.(Mouse_names{i})))=RoomTemperature_all.(Mouse_names{i});
end
a(a==0)=NaN;
b=a-RoomTemperature.all_mice(1:10,:);
figure; plot(b,'Linewidth',2)
xlabel('sessions number')
ylabel('Difference between Room-Mask Temperature (°C)')
title('Difference betweem Room and Mask Temperature survey')
legend('M666','M667','M668','M669','M688','M739','M777','M779','M849','M893')

%% make a room temperature tsd

Mouse_names={'M666','M667','M668','M669','M688','M739','M777','M779','M849','M893'};
for mouse=1:length(Mouse_names);
    error={};
    tps = 0; % this variable counts the total time of all concatenated data
    for ff=1:length(FolderList.(Mouse_names{mouse}).Total)
        try cd([FolderList.(Mouse_names{mouse}).Total{ff} '/Temperature'])
          
            TrackingTemperature
            ff
            ff=ff+1;

        catch error{ff}=FolderList.(Mouse_names{mouse}).Total{ff};
        end
    end
end



