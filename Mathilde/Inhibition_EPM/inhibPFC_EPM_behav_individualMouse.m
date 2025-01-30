%% parameters
IsInverted = 0;

if  IsInverted==0
    idx_open = 1;
    idx_close = 2;
else
    idx_open = 2;
    idx_close = 1;
end

idx_center = 3;

%% get data
load('behavResources.mat','Xtsd','Ytsd','Vtsd','Occup','ZoneEpoch','ZoneIndices','PosMat','MouseTemp_tsd');

%% trajectories in each zone
x_open=Data(Restrict(Xtsd,ZoneEpoch{idx_open}));
y_open=Data(Restrict(Ytsd,ZoneEpoch{idx_open}));

x_close=Data(Restrict(Xtsd,ZoneEpoch{idx_close}));
y_close=Data(Restrict(Ytsd,ZoneEpoch{idx_close}));

x_center=Data(Restrict(Xtsd,ZoneEpoch{idx_center}));
y_center=Data(Restrict(Ytsd,ZoneEpoch{idx_center}));

%% mean duration in each zone
time=300;
TotEpoch=intervalSet(0,time*1e4);
for izone = 1:length(ZoneIndices)
    dur(izone) = nanmean(Stop(TotEpoch-ZoneEpoch{izone},'s')-Start(TotEpoch-ZoneEpoch{izone},'s'));
    MeanDur(izone)=nanmean(Stop(TotEpoch-ZoneEpoch{izone},'s')-Start(TotEpoch-ZoneEpoch{izone},'s'));
end

MeanDurOpen=nanmean(Stop(TotEpoch-ZoneEpoch{idx_open},'s')-Start(TotEpoch-ZoneEpoch{idx_open},'s'));
MeanDurClosed=nanmean(Stop(TotEpoch-ZoneEpoch{idx_close},'s')-Start(TotEpoch-ZoneEpoch{idx_close},'s'));
MeanDurCenter=nanmean(Stop(TotEpoch-ZoneEpoch{idx_center},'s')-Start(TotEpoch-ZoneEpoch{idx_center},'s'));


%% Occupancy map
[Y_open,X_open] = hist(Range(Restrict(Xtsd,ZoneEpoch{idx_open}),'s'),[0:10:300]);
TimeOccupancyOpenArms = Y_open;
[Y_close,X_close] = hist(Range(Restrict(Xtsd,ZoneEpoch{idx_close}),'s'),[0:10:300]);
TimeOccupancyClosedArms = Y_close;
[Y_center,X_center] = hist(Range(Restrict(Xtsd,ZoneEpoch{idx_center}),'s'),[0:10:300]);
TimeOccupancyCenter = Y_center;

% %% Occupancy overtime
% x_coor=2;
% y_coor=6;
% 
% DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
% DataYtsd=Data(Ytsd);
% 
% X_Sup=DataXtsd>25;
% Xmin=min(DataXtsd); Ymin=min(DataYtsd); Xmax=max(DataXtsd); Ymax=max(DataYtsd(X_Sup));
% [p,S] = polyfit([Xmin,Xmax],[Ymin+1,Ymax-1],1);
% 
% %Center
% Xmid=(Xmax-Xmin)/2; Xmid=Xmid+Xmin;
% Ymid=(Ymax-Ymin)/2; Ymid=Ymid+Ymin;
% 
%  clear DataXtsd RangeXtsd DataYtsd
%         DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
%         DataYtsd=Data(Ytsd);
%         
% %         OALogical= DataXtsd>(DataYtsd-(p(2)-5)) | DataXtsd<(DataYtsd-(p(2)+5));% 1196
%         OALogical= DataXtsd>(DataYtsd-(p(2)-10)) | DataXtsd<(DataYtsd-(p(2)+10));%1197 %%%%p2
%         clear c; c=RangeXtsd(OALogical);
%         c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
%         TimeinOA=sum(c(c(:,2)<800,2))/1e4;
%         
% %         CenterLogical=DataXtsd<Xmid+4 & DataXtsd>Xmid-4 & DataYtsd<Ymid+4 & DataYtsd>Ymid-4;% pour 1196
%         CenterLogical=DataXtsd<Xmid+x_coor & DataXtsd>Xmid-x_coor & DataYtsd<Ymid+y_coor & DataYtsd>Ymid-y_coor; %pour 1197
%         clear c; c=RangeXtsd(CenterLogical);
%         c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
%         TimeinCenter=sum(c(c(:,2)<800,2))/1e4;
%         
%         % Check figure
%         X_OA=DataXtsd(OALogical);
%         Y_OA=DataYtsd(OALogical);
%         X_CA=DataXtsd(CenterLogical);
%         Y_CA=DataYtsd(CenterLogical);
% 
% %%occupancy overtime     
% indic=1;
% % for time_to_use=[20:20:300];
%     for time_to_use=[0:10:300];
% 
%     TotEpoch=intervalSet((time_to_use-20)*1e4,time_to_use*1e4);
%     clear DataXtsd RangeXtsd DataYtsd
%     DataXtsd=Data(Restrict(Xtsd,TotEpoch)) ; RangeXtsd=Range(Restrict(Xtsd,TotEpoch));
%     DataYtsd=Data(Restrict(Ytsd,TotEpoch));
%     
%     OALogical= DataXtsd>(DataYtsd-(p(2)-5)) | DataXtsd<(DataYtsd-(p(2)+5));
%     clear c; c=RangeXtsd(OALogical);
%     c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
%     TimeinOccupancyOpenArms(indic)=(sum(c(c(:,2)<800,2))/1e4)/20;
%     
%     CenterLogical=DataXtsd<Xmid+4 & DataXtsd>Xmid-4 & DataYtsd<Ymid+4 & DataYtsd>Ymid-4;
%     clear c; c=RangeXtsd(CenterLogical);
%     c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
%     TimeinOccupancyCenter(indic)=(sum(c(c(:,2)<800,2))/1e4)/20;
%     
%     indic=indic+1;
% end
% TimeinOccupancyClosedArms=(1-(TimeinOccupancyOpenArms+TimeinOccupancyCenter));

%%



%% number of entries
for izone = 1:length(ZoneIndices)
    if isempty(ZoneIndices{izone})
        num_entries(izone) = 0;
    else
        num_entries(izone)=length(find(diff(ZoneIndices{izone})>1))+1;
    end
end

%% first entry
for izone = 1:length(ZoneIndices)
    if isempty(ZoneIndices{izone})
        first_entry(izone) = 300;
    else
        first_entry_zoneIndices(izone) = ZoneIndices{izone}(1);
        first_entry(izone) = PosMat(first_entry_zoneIndices(izone),1);
    end
    
end
    %% speed
for izone = 1:length(ZoneIndices)
    if isempty(ZoneIndices{izone})
        speedZone_mean(izone) = 0;
    else
        speedtemp{izone}=Data(Vtsd);
        speedZone{izone}=speedtemp{izone}(ZoneIndices{izone}(1:end-1),1);
        speedZone_mean(izone)=nanmean(speedZone{izone},1);
    end
end

%% temperature
% temperature_open = Data(Restrict(MouseTemp_tsd,ZoneEpoch{idx_open}));
% temperature_close = Data(Restrict(MouseTemp_tsd,ZoneEpoch{idx_close}));
% temperature_center = Data(Restrict(MouseTemp_tsd,ZoneEpoch{idx_center}));

%% figure


figure,
subplot(3,4,[1,2]),plot([0:10:300],TimeOccupancyOpenArms./100,'-ko','MarkerSize',10,'MarkerFaceColor',[1 1 1])
hold on,plot([0:10:300],TimeOccupancyCenter./100,'--k+','MarkerSize',10,'MarkerFaceColor',[0 0 0])
hold on,plot([0:10:300],TimeOccupancyClosedArms./100,'-ko','MarkerSize',10,'MarkerFaceColor',[0.3 0.3 0.3])
legend({'Open arm','Center', 'Closed arm'})
ylabel('Time proportion')
xlabel('Time (s)')
makepretty


subplot(3,4,3)
plot(x_open,y_open,'color',[0.5 0.5 0.5]),hold on
plot(x_center,y_center,'color',[0.5 0.5 0.5])
plot(x_close,y_close,'color',[0.5 0.5 0.5])
makepretty


% subplot(3,4,[5,7]),plot(Range(MouseTemp_tsd)/1e4, runmean(Data(MouseTemp_tsd),5),'color',[.3 .3 .3])
% xlim([0 300])
% xlabel('Time (s)')
% ylabel('Temperature (°C)')
% makepretty

subplot(3,4,4),PlotErrorBarN_KJ({Occup(idx_open)*100 Occup(idx_close)*100 Occup(idx_center)*100},'newfig',0,'paired',0,'showPoints',0')
set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
xtickangle(45)
ylabel('Percentage of time (%)')
makepretty

subplot(3,4,9),PlotErrorBarN_KJ({num_entries(idx_open) num_entries(idx_close) num_entries(idx_center)},'newfig',0,'paired',0,'showPoints',0')
set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
xtickangle(45)
ylabel('Number of entries')
makepretty

subplot(3,4,10),PlotErrorBarN_KJ({first_entry(idx_open) first_entry(idx_close) first_entry(idx_center)},'newfig',0,'paired',0,'showPoints',0')
set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
xtickangle(45)
ylabel('Latency to the zone (s)')
makepretty

subplot(3,4,11),PlotErrorBarN_KJ({speedZone_mean(idx_open) speedZone_mean(idx_close) speedZone_mean(idx_center)},'newfig',0,'paired',0,'showPoints',0')
set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
xtickangle(45)
ylabel('Speed (cm/s)')
makepretty

subplot(3,4,12),PlotErrorBarN_KJ({MeanDur(idx_open) MeanDur(idx_close) MeanDur(idx_center)},'newfig',0,'paired',0,'showPoints',0')
set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
xtickangle(45)
ylabel('Mean duration (s)')
makepretty

% subplot(3,4,8)
% PlotErrorBarN_KJ({mean(temperature_open) mean(temperature_close) mean(temperature_center)},'newfig',0,'paired',0,'showPoints',0')
% set(gca,'Xtick',[1:3],'XtickLabel',{'Open arm','Closed arm','Center'});
% xtickangle(45)
% ylabel('Temperature (°C)')
% makepretty
