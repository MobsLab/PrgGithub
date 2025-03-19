%% 
Mouse_number=extractBetween(pwd,'VideosToAnalyze/','/');

% Temp_Freezing structure with .temp : temperature values for
% zones/freezing in zones, .time : time spending freezing in zones,
% .temp_proportional : product of temperature during freezing and freezing time
names = {'Tail','Nose','Neck','Body'};
names2 = {'TailValues','NoseValues','NeckValues','BodyValues'};

for ind = 1:length(names)
    for session=1:length(Dir)
        cd(Dir{session})
        load('behavResources_SB.mat')
       try load('Temperature.mat')
           %lines are sessions, columns are temperature for zones,
           %the first are for exploration epoch, the last for freezing
           %epoch
           Temp_Freezing.(names{ind}).temp(session,1:7)=TempResults.(names2{ind})(1,1:7);
           Temp_Freezing.(names{ind}).temp(session,8:14)=TempResults.(names2{ind})(2,1:7);
           %lines are sessions, columns are temperature for zones, the first
           %seven columns are for time spend in zones, the seven last for the
           %time spent freezing in this zones
           Temp_Freezing.(names{ind}).time(session,1:7)=Results.Occup(1,:);
           Temp_Freezing.(names{ind}).time(session,8:14)=Results.FreezeAccTime(1,:);
         
           %product of time and temperature
           Temp_Freezing.(names{ind}).temp_proportional(session,:)=Temp_Freezing.(names{ind}).temp(session,:).*Temp_Freezing.(names{ind}).time(session,:);
       catch
       end
    end
end


%Array with first line for mean temperature for each zone, second line is
%mean temperature during freezing for each zone
for ind = 1:length(names)
    if length(Dir)==1
        Temp_Freezing.(names{ind}).sumup(1,:)=Temp_Freezing.(names{ind}).temp(:,1:7);
        Temp_Freezing.(names{ind}).sumup(2,:)=Temp_Freezing.(names{ind}).temp(:,8:14);
    else
        Temp_Freezing.(names{ind}).sumup(1,:)=nansum(Temp_Freezing.(names{ind}).temp_proportional(:,1:7))./nansum(Temp_Freezing.(names{ind}).time(:,1:7));;
        Temp_Freezing.(names{ind}).sumup(2,:)=nansum(Temp_Freezing.(names{ind}).temp_proportional(:,8:14))./nansum(Temp_Freezing.(names{ind}).time(:,8:14));
    end
end

%Sum up for Safe Zones = zones 2,5
for ind = 1:length(names)
        if length(Dir)==1
Temp_Freezing.(names{ind}).sumup(3,1)=nansum(Temp_Freezing.(names{ind}).time(:,[1 4]).*Temp_Freezing.(names{ind}).sumup(1,[1 4]))/(nansum(Temp_Freezing.(names{ind}).time(:,[1 4])));
Temp_Freezing.(names{ind}).sumup(4,1)=nansum(Temp_Freezing.(names{ind}).time(:,[8 11]).*Temp_Freezing.(names{ind}).sumup(2,[1 4]))/(nansum(Temp_Freezing.(names{ind}).time(:,[8 11])));
Temp_Freezing.(names{ind}).sumup(3,2)=nansum((Temp_Freezing.(names{ind}).time(:,[2 5])).*(Temp_Freezing.(names{ind}).sumup(1,[2 5])))/(nansum(Temp_Freezing.(names{ind}).time(:,[2 5])));
Temp_Freezing.(names{ind}).sumup(4,2)=nansum((Temp_Freezing.(names{ind}).time(:,[9 12])).*(Temp_Freezing.(names{ind}).sumup(2,[2 5])))/(nansum(Temp_Freezing.(names{ind}).time(:,[9 12])));
        else
Temp_Freezing.(names{ind}).sumup(3,1)=nansum((sum(Temp_Freezing.(names{ind}).time(:,[1 4]))).*(Temp_Freezing.(names{ind}).sumup(1,[1 4])))/(nansum(sum(Temp_Freezing.(names{ind}).time(:,[1 4]))));
Temp_Freezing.(names{ind}).sumup(4,1)=nansum((sum(Temp_Freezing.(names{ind}).time(:,[8 11]))).*(Temp_Freezing.(names{ind}).sumup(2,[1 4])))/(nansum(sum(Temp_Freezing.(names{ind}).time(:,[8 11]))));
Temp_Freezing.(names{ind}).sumup(3,2)=nansum((sum(Temp_Freezing.(names{ind}).time(:,[2 5]))).*(Temp_Freezing.(names{ind}).sumup(1,[2 5])))/(nansum(sum(Temp_Freezing.(names{ind}).time(:,[2 5]))));
Temp_Freezing.(names{ind}).sumup(4,2)=nansum((sum(Temp_Freezing.(names{ind}).time(:,[9 12]))).*(Temp_Freezing.(names{ind}).sumup(2,[2 5])))/(nansum(sum(Temp_Freezing.(names{ind}).time(:,[9 12]))));
        end
%non-normalized for zones
%Temp_Freezing.(names{ind}).sumup(3,2)=nanmean(Temp_Freezing.(names{ind}).sumup(1,[2:3 5:7]));
%Temp_Freezing.(names{ind}).sumup(4,2)=nanmean(Temp_Freezing.(names{ind}).sumup(2,[2:3 5:7]));
end

if length(Dir)>1
    cd('../')
    save('Temp_Freezing.mat','Temp_Freezing');
    save('Temp_Freezing.mat','Dir','-append')
else
    save('Temp_Freezing.mat','Temp_Freezing');
    save('Temp_Freezing.mat','Dir','-append')
end

choose=input('choose Tail/Nose/Neck/Body : ','s');
DataForPlot=NaN(7,6);
%Gathering info in a matrix
for sess=1:length(Dir)
 for Zones=1:7
     DataForPlot(Zones,2*sess-1)= Temp_Freezing.(choose).temp(sess,Zones);
     DataForPlot(Zones,2*sess) = Temp_Freezing.(choose).temp(sess,Zones+7);
 end
end

min_y=min(min(DataForPlot));
max_y=max(max(DataForPlot));
dir=dir;
figure
%Plot each session (x3) and the average temperature at the end
Zone = [1:7];
if length(Dir)>1
    subplot(4,1,1)
    bar(Zone,DataForPlot(:,1:2))
    ylim([min_y-0.5;max_y+0.5])
    ylabel('Temperature °C')
    xlabel('Zones')
    title_=['Average ' choose   ' Temperature'];
    legend(title_,[title_ ' during freezing'])
    title(dir(3).name)
    subplot(4,1,2)
    bar(Zone,DataForPlot(:,3:4))
    ylim([min_y-0.5;max_y+0.5])
    title(dir(4).name);
    xlabel('Zones');
    ylabel('Temperature °C');
    subplot(4,1,3)
    bar(Zone,DataForPlot(:,5:6))
    ylim([min_y-0.5;max_y+0.5])
    title(dir(5).name);
    xlabel('Zones');
    ylabel('Temperature °C');
    subplot(4,1,4)
    bar(Zone,Temp_Freezing.(choose).sumup(1:2,:)')
    ylim([min_y-0.5;max_y+0.5])
    title('Summary');
    xlabel('Zones');
    ylabel('Temperature °C');
    
    newStr = extractBetween([pwd 'tutut'],[strcat(Mouse_number,'/')],'tutut');
    suptitle(newStr)
    
else
    bar(Zone,Temp_Freezing.(choose).sumup(1:2,:)')
    ylim([min_y-0.5;max_y+0.5])
    title('Summary');
    xlabel('Zones');
    ylabel('Temperature °C');
end

  figure
  %Plot mean temperature for safe and shock freezing compared to
  %non-freezing period. Safe zones are summed
  min_y=min(min(Temp_Freezing.(choose).sumup(3:4,1:2)));
  max_y=max(max(Temp_Freezing.(choose).sumup(3:4,1:2)));
  x_axis={'Shock Zone';'Safe Zones'};
  bar(Temp_Freezing.(choose).sumup(3:4,1:2)')
  ylim([min_y-0.5;max_y+0.5])
  ylabel('Temperature °C');
  set(gca,'xticklabel',x_axis)
  legend(['Average ' choose ' Temperature'],['Average ' choose ' Temperature during freezing'])
  title('Temperature change during freezing')

  
