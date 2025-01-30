

% Defining Open arm and closed arms from the first mouse
mice=1; group=1;
if Mice.(Group{group})(mice)<10
    cd([Base '_0' num2str(Mice.(Group{group})(mice))])
else
    cd([Base '_' num2str(Mice.(Group{group})(mice))])
end
load('behavResources.mat')

DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
DataYtsd=Data(Ytsd);

X_Sup=DataXtsd>25;
Xmin=min(DataXtsd); Ymin=min(DataYtsd); Xmax=max(DataXtsd); Ymax=max(DataYtsd(X_Sup));
[p,S] = polyfit([Xmin,Xmax],[Ymin+1,Ymax-1],1);

% Center time
Xmid=(Xmax-Xmin)/2; Xmid=Xmid+Xmin;
Ymid=(Ymax-Ymin)/2; Ymid=Ymid+Ymin;

for group=1:length(Group)
    for mice = 1 :length(Mice.(Group{group}))
        
        if Mice.(Group{group})(mice)<10
            cd([Base '_0' num2str(Mice.(Group{group})(mice))])
        else
            cd([Base '_' num2str(Mice.(Group{group})(mice))])
        end
        load('behavResources.mat')
        load('Temperature.mat', 'Temp')
        
        TotEpoch=intervalSet(0,time*1e4);
        
        NumEntry.(Group{group})(mice)= length(Start(and(ZoneEpoch{1},TotEpoch),'s'));
        Tot_Arm_Entries.(Group{group})(mice)=length(Start(and(ZoneEpoch{1},TotEpoch),'s'))+length(Start(and(ZoneEpoch{2},TotEpoch),'s'));
        
        MeanSpeed.(Group{group})(mice)=nanmean(Data(Restrict(Vtsd,TotEpoch))) ;
        MeanTemp.(Group{group})(mice)=nanmean(Data(Restrict(Temp.MouseTemperatureTSD,TotEpoch)));
        
        MeanDurOpen.(Group{group})(mice)=nanmean(Stop(TotEpoch-ZoneEpoch{2},'s')-Start(TotEpoch-ZoneEpoch{2},'s'));
        MeanDurClosed.(Group{group})(mice)=nanmean(Stop(TotEpoch-ZoneEpoch{1},'s')-Start(TotEpoch-ZoneEpoch{1},'s'));
          
        TimeOA.(Group{group})(mice)=sum(Stop(and(ZoneEpoch{1},TotEpoch),'s')-Start(and(ZoneEpoch{1},TotEpoch),'s'));
        TimeCA.(Group{group})(mice)=sum(Stop(and(ZoneEpoch{2},TotEpoch),'s')-Start(and(ZoneEpoch{2},TotEpoch),'s'));
        TimeCenter.(Group{group})(mice)=sum(Stop(and(ZoneEpoch{3},TotEpoch),'s')-Start(and(ZoneEpoch{3},TotEpoch),'s'));
        
        % Occupancy map
        [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{1}),'s'),[20:20:300]);
        TimeOccupancy.OpenArms.(Group{group})(mice,:) = Y;
        [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{2}),'s'),[20:20:300]);
        TimeOccupancy.ClosedArms.(Group{group})(mice,:) = Y;
        [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{3}),'s'),[20:20:300]);
        TimeOccupancy.Center.(Group{group})(mice,:) = Y;
        
        
        % If ZoneEpoch are not good
        clear DataXtsd RangeXtsd DataYtsd
        DataXtsd=Data(Xtsd); RangeXtsd=Range(Xtsd);
        DataYtsd=Data(Ytsd);
        
        OALogical= DataXtsd>(DataYtsd-(p(2)-5)) | DataXtsd<(DataYtsd-(p(2)+5));
        clear c; c=RangeXtsd(OALogical);
        c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
        TimeinOA.(Group{group})(mice)=sum(c(c(:,2)<800,2))/1e4;
        
        CenterLogical=DataXtsd<Xmid+4 & DataXtsd>Xmid-4 & DataYtsd<Ymid+4 & DataYtsd>Ymid-4;
        clear c; c=RangeXtsd(CenterLogical);
        c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
        TimeinCenter.(Group{group})(mice)=sum(c(c(:,2)<800,2))/1e4;
        
        % Check figure
        X_OA=DataXtsd(OALogical);
        Y_OA=DataYtsd(OALogical);
        X_CA=DataXtsd(CenterLogical);
        Y_CA=DataYtsd(CenterLogical);
        
        % Occupancy along time
        indic=1;
        for time_to_use=[20:20:300];
            
            TotEpoch=intervalSet((time_to_use-20)*1e4,time_to_use*1e4);
            clear DataXtsd RangeXtsd DataYtsd
            DataXtsd=Data(Restrict(Xtsd,TotEpoch)) ; RangeXtsd=Range(Restrict(Xtsd,TotEpoch));
            DataYtsd=Data(Restrict(Ytsd,TotEpoch));
            
            OALogical= DataXtsd>(DataYtsd-(p(2)-5)) | DataXtsd<(DataYtsd-(p(2)+5));
            clear c; c=RangeXtsd(OALogical);
            c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
            TimeinOccupancy.OpenArms.(Group{group})(mice,indic)=(sum(c(c(:,2)<800,2))/1e4)/20;
            
            CenterLogical=DataXtsd<Xmid+4 & DataXtsd>Xmid-4 & DataYtsd<Ymid+4 & DataYtsd>Ymid-4;
            clear c; c=RangeXtsd(CenterLogical);
            c(1:end-1,2)=c(2:end,1)-c(1:end-1,1);
            TimeinOccupancy.Center.(Group{group})(mice,indic)=(sum(c(c(:,2)<800,2))/1e4)/20;
            
            indic=indic+1;
            
        end
            
    end
end






