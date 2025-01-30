Mice = [756 758 761 763 765 ; 757 759 762 764 760];
Gr(1,1)=5;
Gr(1,2)=5;

MatNum=[];
MiceNumber = [756 757 758 759 760 761 762 763 764 765];
for k = 1:size(Mice,1)
    for j = 1 : Gr(1,k)
        MatNum(k,j) = find(MiceNumber==Mice(k,j));
    end
end

% variables BEFORE injection
for i = 1 : length(MiceNumber)
    
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/BeforeInjection/FEAR-Mouse-',num2str(MiceNumber(i)),'-12062018-Hab_00'])
    load('behavResources.mat')
    
    % recalculate speed
    Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
    Denom = diff(Range(Xtsd,'s'));
    tps = Range(Xtsd);
    tps = tps(1:end-1);
    Vtsd = tsd(tps,Numer./Denom);
    
    % mean speed
    Temp_Vtsd = (Data(Vtsd));
    Temp_Vtsd(Temp_Vtsd<2) = [];
    MeanVtsd(i) = mean(Temp_Vtsd);
    
    % speed in time
    speed{i} = Data(Vtsd);
    
    %mean freezing period
    Freeze(i) = (sum((Stop(FreezeEpoch, 's') - Start(FreezeEpoch, 's')))/900);

    %mean freezing period duration
    FreezeDur(i) = (nanmean((Stop(FreezeEpoch, 's') - Start(FreezeEpoch, 's'))));

    % total distance
    TotDist(i) = sum(sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2));
    
    % total imdiff
    TotImDiff(i) = mean(Data(Imdifftsd));
    
end


% variables AFTER injection
for i = 1 : length(MiceNumber)
    cd(['/media/DataMOBsRAIDN/ProjetAversion/DATA-Fear/MethimazoleBehaviourExperiment/4DqysPost/FEAR-Mouse-',num2str(MiceNumber(i)),'-16062018-Hab_00'])
    load('behavResources.mat')
    
    % recalculate speed
    Numer = sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2);
    Denom = diff(Range(Xtsd,'s'));
    tps = Range(Xtsd);
    tps = tps(1:end-1);
    Vtsd = tsd(tps,Numer./Denom);
    
    % mean speed
    Temp_Vtsd = (Data(Vtsd));
    Temp_Vtsd(Temp_Vtsd<2) = [];
    MeanVtsd_a(i) = mean(Temp_Vtsd);
    
    % speed in time
    speed{i} = Data(Vtsd);
    
    %mean freezing period
    Freeze_a(i) = (sum((Stop(FreezeEpoch, 's') - Start(FreezeEpoch, 's')))/900);
   
    %mean freezing period duration
    FreezeDur_a(i) = (nanmean((Stop(FreezeEpoch, 's') - Start(FreezeEpoch, 's'))));


    % total distance
    TotDist_a(i) = sum(sqrt(diff(Data(Xtsd)).^2+diff(Data(Ytsd)).^2));
    
    % total imdiff
    TotImDiff_a(i) = mean(Data(Imdifftsd));
  

end

% time freezing before after
Vals = {(Freeze(MatNum(1,:)))*100,(Freeze(MatNum(2,:)))*100,(Freeze_a(MatNum(1,:)))*100  ,(Freeze_a(MatNum(2,:)))*100};
Legends = {'Ctrl','MTZL','Ctrl','MTZL'};
X = [1 2 4 5];
Cols = {[0.8 0.8 0.8],[1 0.4 0.4],[ 0.8 0.8 0.8],[1 0.4 0.4]}
figure
MakeSpreadAndBoxPlot_SB(Vals,Cols,X,Legends)
ylabel('% time freezing')



% Barplot (freezing, dist, speed, mov)

% freezing
PlotBarCrossProtocol((Freeze(MatNum(1,:))),(Freeze(MatNum(2,:))),(Freeze_a(MatNum(1,:)))  ,(Freeze_a(MatNum(2,:))),1)
xticks(1:2)
xticklabels({'Before','After'});
ylabel('Freezing (% Time)')
ylim([0 0.40])

% movment
PlotBarCrossProtocol((TotImDiff(MatNum(1,:))),(TotImDiff(MatNum(2,:))),(TotImDiff_a(MatNum(1,:)))  ,(TotImDiff_a(MatNum(2,:))),1)
xticks(1:2)
xticklabels({'Before','After'});
ylabel('Mean qty of mov (AU)')
ylim([0 130])

% distance
PlotBarCrossProtocol((TotDist(MatNum(1,:))),(TotDist(MatNum(2,:))),(TotDist_a(MatNum(1,:)))  ,(TotDist_a(MatNum(2,:))),1)
xticks(1:2)
xticklabels({'Before','After'});
ylabel('Total distance (cm)')
ylim([0 4000])

% speed
PlotBarCrossProtocol((MeanVtsd(MatNum(1,:))),(MeanVtsd(MatNum(2,:))),(MeanVtsd_a(MatNum(1,:)))  ,(MeanVtsd_a(MatNum(2,:))),1)
xticks(1:2)
xticklabels({'Before','After'});
ylabel('Mean speed (cm/s)')
ylim([0 10])

% freezing
PlotBarCrossProtocol((FreezeDur(MatNum(1,:))),(FreezeDur(MatNum(2,:))),(FreezeDur_a(MatNum(1,:)))  ,(FreezeDur_a(MatNum(2,:))),1)
xticks(1:2)
xticklabels({'Before','After'});
ylabel('Freezing (% Time)')
ylim([0 0.40])