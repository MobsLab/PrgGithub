clear all
Dir = PathForExperimentsEmbReact('MidazolamDoseResponse_EPM');

EpOI = intervalSet(0,180*1e4);
for mm = 1:length(Dir.path)
    cd(Dir.path{mm}{1})
    
    MDZData.DrugDose(mm) = Dir.ExpeInfo{mm}{1}.drugdose;
    load('behavResources.mat')
    MDZData.MouseNumber(mm) = Dir.ExpeInfo{mm}{1}.nmouse;

    Centre = [nanmean(Data(Restrict(Xtsd,ZoneEpoch{3}))),nanmean(Data(Restrict(Ytsd,ZoneEpoch{3})))];
    [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{1}),'s'),[0:40:900]);
    MDZData.OpenOccup(mm,:) = Y;
    [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{2}),'s'),[0:40:900]);
    MDZData.ClosedOccup(mm,:) = Y;
    [Y,X] = hist(Range(Restrict(Xtsd,ZoneEpoch{3}),'s'),[0:40:900]);
    MDZData.CentreOccup(mm,:) = Y;
    
    for z = 1:3
    ZoneEpoch{z} = and(ZoneEpoch{z},EpOI);
    end
    FreezeEpoch = and(FreezeEpoch,EpOI);
    Xtsd = Restrict(Xtsd,EpOI);
    Ytsd = Restrict(Ytsd,EpOI);

    MDZData.PropTimeOpenArm(mm) = sum(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'))/sum(Stop(EpOI,'s')-Start(EpOI,'s'));

    MDZData.PropEntriesOpenArm(mm) = length(Stop(ZoneEpoch{1},'s'))./(length(Stop(ZoneEpoch{1},'s'))+length(Stop(ZoneEpoch{2},'s')));

    MDZData.MeanEpDurOpenArm(mm) = mean(Stop(ZoneEpoch{1},'s')-Start(ZoneEpoch{1},'s'));

    MDZData.MeanEpDurClosedArm(mm) = mean(Stop(ZoneEpoch{2},'s')-Start(ZoneEpoch{2},'s'));
    
    MDZData.MeanSpeed(mm) = nanmean(Data(Restrict(Vtsd,EpOI)));

    MDZData.ImmobTime(mm) = sum(Stop(FreezeEpoch,'s')-Start(FreezeEpoch,'s'))./sum(Stop(EpOI,'s')-Start(EpOI,'s'));
    
    Temptsd = tsd(MouseTemp(:,1)*1e4,MouseTemp_InDegrees);
    MDZData.Temperature(mm) = nanmean(Data(Restrict(Temptsd,EpOI)));
    MDZData.TemperatureOpen(mm) = nanmean(Data(Restrict(Temptsd,ZoneEpoch{1})));
    MDZData.TemperatureClose(mm) = nanmean(Data(Restrict(Temptsd,ZoneEpoch{2})));
    
    
    [nn,xx,yy] = hist2d(Data(Xtsd)-Centre(1),Data(Ytsd)-Centre(2),[-45:1:45],[-60:1:60]);
    MDZData.MeanDistClosed(mm) = nanmean(abs(Data(Restrict(Ytsd,ZoneEpoch{2})-Centre(2))));
    MDZData.MeanDistOpen(mm) = nanmean(abs(Data(Restrict(Xtsd,ZoneEpoch{1})-Centre(1))));
    MDZData.Hist2D(mm,:,:) = nn;

end

Dir = PathForExperimentsEmbReact('MidazolamDoseResponse_Plethysmo');
for mm = 1:length(Dir.path)
    cd(Dir.path{mm}{1})
    load('BreathingInfo.mat')
    MDZDataBr.DrugDose(mm) = Dir.ExpeInfo{mm}{1}.drugdose;
    MDZDataBr.Breathing(mm,:) = hist(Data(Frequecytsd),[0:0.2:20]);
    MDZDataBr.BreathingFreq(mm,:) = nanmean(Data(Frequecytsd));
end


% Open vs closed arm
AllDoses = sort(unique(MDZData.DrugDose));
AllFields = {'PropTimeOpenArm','PropEntriesOpenArm','MeanEpDurOpenArm','MeanEpDurClosedArm','MeanDistClosed','MeanDistClosed'};
figure

for FName = 1:6
    subplot(3,2,FName)
    for dd = 1 : length(AllDoses)
        DatToPlot{dd} = MDZData.(AllFields{FName})(MDZData.DrugDose == AllDoses(dd));
    end
    PlotErrorBarN_KJ(DatToPlot','newfig',0,'paired',0)
    title(AllFields{FName})
    set(gca,'XTick',[1:5],'XTickLabel',{'0','0.25','0.5','1','1.5'})
    
end


% Open vs closed arm
AllDoses = sort(unique(MDZData.DrugDose));
AllFields = {'PropTimeOpenArm','PropEntriesOpenArm','MeanEpDurOpenArm','MeanEpDurClosedArm','MeanDistClosed','MeanDistClosed'};
col = fliplr(gray(length(AllDoses)+1)')';
for d = 1:length(AllDoses)
    
   Cols2{d} = col(d,:);
end

figure
for FName = 2
    clear p

    subplot(2,1,FName)
    for dd = 1 : length(AllDoses)
        DatToPlot{dd} = MDZData.(AllFields{FName})(MDZData.DrugDose == AllDoses(dd));
        MenVal(FName,dd) = nanmean(DatToPlot{dd}*100);
        StdVal(FName,dd) = stdError(DatToPlot{dd}*100);
    end
        MakeSpreadAndBoxPlot_SB(DatToPlot,Cols2,1:5,{},1,0)
        for d = 2:length(AllDoses)
        [p(d),h,stats]=ranksum(DatToPlot{1},DatToPlot{d});
        stat(d) = stats.ranksum;
        sigstar({{1,d}},p(d))
        end
        

    ylabel(AllFields{FName})
   xlabel('MDZ dose')
    set(gca,'XTick',[1:5],'XTickLabel',{'0','0.25','0.5','1','1.5'},'FontSize',15,'linewidth',2 )
    
end



% General physiology
AllFields = {'MeanSpeed','ImmobTime','Temperature'};

for FName = 1:3
    subplot(3,1,FName)
    for dd = 1 : length(AllDoses)
        DatToPlot{dd} = MDZData.(AllFields{FName})(MDZData.DrugDose == AllDoses(dd));
    end
    MakeSpreadAndBoxPlot_SB(DatToPlot,Cols2,1:5,{},1,0)
            for d = 2:length(AllDoses)
        [p(d),h,stats]=ranksum(DatToPlot{1},DatToPlot{d});
        stat(d) = stats.ranksum;
        sigstar({{1,d}},p(d))
        end

    ylabel(AllFields{FName})
    xlabel('MDZ dose')
    set(gca,'XTick',[1:5],'XTickLabel',{'0','0.25','0.5','1','1.5'},'FontSize',15,'linewidth',2 )
    xtickangle(45)
    

end

figure
File = PathForExperimentsMtzlProject('SoundHab_Plethysmo_PreMTZL')
for f = 1:length(File.path)
    cd(File.path{f}{1})
        load('BreathingInfo_ZeroCross.mat')
    MDZDataBr.DrugDose(end+1) = 0;
    MDZDataBr.BreathingFreq(end+1,:) = nanmean(Data(Frequecytsd));

end


subplot(2,2,4)
clear DatToPlot
for dd = 1 : length(AllDoses)
    DatToPlot{dd} = MDZDataBr.BreathingFreq(MDZDataBr.DrugDose == AllDoses(dd));
end
MakeSpreadAndBoxPlot_SB(DatToPlot,Cols2,1:5,{},1,0)
ylabel('BreathingFreq')
xlabel('MDZ dose')
xtickangle(45)

    set(gca,'XTick',[1:5],'XTickLabel',{'0','0.25','0.5','1','1.5'},'FontSize',15,'linewidth',2 )

figure
FName=3;
    for dd = 1 : length(AllDoses)
        DatToPlot{dd} = MDZData.(AllFields{FName})(MDZData.DrugDose == AllDoses(dd));
    end
    PlotErrorBarN_KJ(DatToPlot','newfig',0,'paired',0)
    title(AllFields{FName})
    set(gca,'XTick',[1:5],'XTickLabel',{'0','0.25','0.5','1','1.5'})

%% Focus on 0.25
RegionOccup = {'OpenOccup','ClosedOccup','CentreOccup'};
TotOccup = MDZData.OpenOccup(4,:)+MDZData.CentreOccup(4,:)+MDZData.ClosedOccup(4,:);
figure
cols = viridis(2);
for z = 1:3
    subplot(3,1,z)
    for dd = 1 : 2
            errorbar(X,nanmean(MDZData.(RegionOccup{z})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup,...
                (stdError(MDZData.(RegionOccup{z})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup),'color',cols(dd,:),'linewidth',4)
        hold on
    end
    ylim([0 1])
    title(RegionOccup{z})
    xlabel('time (s)')
    ylabel('Prop time')
    if z ==1
    legend('0','0.25')
    end
    box off
end

figure
for dd = 1 : 2
    subplot(2,1,dd)
    bar(X,[(nanmean(MDZData.(RegionOccup{1})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup);(nanmean(MDZData.(RegionOccup{3})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup);(nanmean(MDZData.(RegionOccup{2})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup)]','stacked')
   if dd==1
       legend('Open','Middle','Closed')
   end
       xlabel('time (s)')
    ylabel('Prop time')
   title(num2str(AllDoses(dd)))
   box off
end
    

%% occup map
figure
for dd = 1 : 2
    subplot(1,2,dd)
    imagesc(xx,yy,log(squeeze(nanmean(MDZData.Hist2D(MDZData.DrugDose == AllDoses(dd),:,:),1))))
end

%%
figure
% Some correlations
subplot(121)
for dd = 1 : length(AllDoses)
    plot(MDZData.PropEntriesOpenArm(MDZData.DrugDose == AllDoses(dd)),MDZData.MeanSpeed(MDZData.DrugDose == AllDoses(dd)),'.','MarkerSize',20,'color',cols(dd,:))
    hold on
end
dd = 2;
A = MDZData.PropEntriesOpenArm(MDZData.DrugDose == AllDoses(dd));
B = MDZData.MeanSpeed(MDZData.DrugDose == AllDoses(dd));
plot([A(1),A(end)],[B(1),B(end)],'o','MarkerSize',40,'color',cols(dd,:))

xlabel('Prop Entries Open Arm')
ylabel('Speed')
legend('0','0.25','0.5','1','1.5')

subplot(122)
for dd = 1 : length(AllDoses)
    plot(MDZData.PropTimeOpenArm(MDZData.DrugDose == AllDoses(dd)),MDZData.Temperature(MDZData.DrugDose == AllDoses(dd)),'.','MarkerSize',20,'color',cols(dd,:))
    
    hold on
end
dd=2;
A = MDZData.PropTimeOpenArm(MDZData.DrugDose == AllDoses(dd));
B = MDZData.Temperature(MDZData.DrugDose == AllDoses(dd));
plot([A(1),A(end)],[B(1),B(end)],'o','MarkerSize',40,'color',cols(dd,:))

xlabel('Prop Time Open Arm')
ylabel('Temperature')
legend('0','0.25','0.5','1','1.5')

figure
% Some correlations
subplot(121)
for dd = 1 :2
    plot(MDZData.PropEntriesOpenArm(MDZData.DrugDose == AllDoses(dd)),MDZData.MeanSpeed(MDZData.DrugDose == AllDoses(dd)),'.','MarkerSize',20,'color',cols(dd,:))
    hold on
end
dd = 2;
A = MDZData.PropEntriesOpenArm(MDZData.DrugDose == AllDoses(dd));
B = MDZData.MeanSpeed(MDZData.DrugDose == AllDoses(dd));
plot([A(1),A(end)],[B(1),B(end)],'o','MarkerSize',40,'color',cols(dd,:))

xlabel('Prop Entries Open Arm')
ylabel('Speed')
legend('0','0.25')

subplot(122)
for dd = 1 : 2
    plot(MDZData.PropTimeOpenArm(MDZData.DrugDose == AllDoses(dd)),MDZData.Temperature(MDZData.DrugDose == AllDoses(dd)),'.','MarkerSize',20,'color',cols(dd,:))
    
    hold on
end
dd=2;
A = MDZData.PropTimeOpenArm(MDZData.DrugDose == AllDoses(dd));
B = MDZData.Temperature(MDZData.DrugDose == AllDoses(dd));
plot([A(1),A(end)],[B(1),B(end)],'o','MarkerSize',40,'color',cols(dd,:))

xlabel('Prop Time Open Arm')
ylabel('Temperature')
legend('0','0.25')


%%%

figure
clf
cols = inferno(6);
RegionOccup = {'OpenOccup','ClosedOccup','CentreOccup'};
TotOccup = MDZData.OpenOccup(4,:)+MDZData.CentreOccup(4,:)+MDZData.ClosedOccup(4,:);
for z = 1:3
    subplot(3,1,z)
    for dd = 1 : length(AllDoses)
        %     errorbar(nanmean(MDZData.OpenOccup(MDZData.DrugDose == AllDoses(dd),:)),...
        %         (stdError(MDZData.OpenOccup(MDZData.DrugDose == AllDoses(dd),:))),'color',cols(dd,:),'linewidth',4)
        plot(nanmean(MDZData.(RegionOccup{z})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup,...
            'color',cols(dd,:),'linewidth',4)
        hold on
    end
    ylim([0 1])
    title(RegionOccup{z})
    if z ==1
    legend(sprintfc('%d',AllDoses))
    end
end

figure
for dd = 1 : length(AllDoses)
    subplot(5,1,dd)
    bar([(nanmean(MDZData.(RegionOccup{1})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup);(nanmean(MDZData.(RegionOccup{3})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup);(nanmean(MDZData.(RegionOccup{2})(MDZData.DrugDose == AllDoses(dd),:))./TotOccup)]','stacked')
   if dd==1
       legend('Open','Middle','Closed')
   end
   title(num2str(AllDoses(dd)))
end




figure
for dd = 1 : 6
    subplot(1,5,dd)
    imagesc(xx,yy,log(squeeze(nanmean(MDZData.Hist2D(MDZData.DrugDose == AllDoses(dd),:,:),1))))
end


%% Effect size - random permutation
subplot(311)
A = MDZData.PropTimeOpenArm(MDZData.DrugDose ==0);
B = MDZData.PropTimeOpenArm(MDZData.DrugDose ==0.25);
ToPerm = [A,B] ;
Realp = ranksum(A,B);
RealEffSize = (mean(A)-mean(B));
clear AllEffSize
for k = 1:1000
%     AfterPermA = A(randperm(8));
%     AfterPermB = B(randperm(8));
%     NewA = [AfterPermA(1:4),AfterPermB(1:4)];
%     NewB = [AfterPermA(5:end),AfterPermB(5:end)];
    
    AfterPerm = [A,B];
    AfterPerm = AfterPerm(randperm(16));
NewA = AfterPerm(1:8);
NewB = AfterPerm(9:end);

    [p,h] = ranksum(NewA,NewB);
    AllPs(k) = p;
    AllEffSize(k) = (mean(NewA)-mean(NewB));
end

hist(AllEffSize,200)
line([1 1]*RealEffSize,ylim)
title(num2str(1-sum(AllEffSize>RealEffSize)/1000))

subplot(312)
A = MDZData.PropEntriesOpenArm(MDZData.DrugDose ==0);
B = MDZData.PropEntriesOpenArm(MDZData.DrugDose ==0.25);
ToPerm = [A,B] ;
Realp = ranksum(A,B);
RealEffSize = (mean(A)-mean(B))./mean([std(A),std(B)]);

for k = 1:5000
    
    AfterPerm = ToPerm(randperm(16));
    [p,h] = ranksum(AfterPerm(1:8),AfterPerm(9:end));
    AllPs(k) = p;
    AllEffSize(k) = (mean(AfterPerm(1:8))-mean(AfterPerm(9:end)))./mean([std(AfterPerm(1:8)),std(AfterPerm(9:end))]);
end
hist(AllEffSize,200)
line([1 1]*RealEffSize,ylim)
title(num2str(1-sum(AllEffSize>RealEffSize)/5000))

subplot(313)
A = MDZData.MeanSpeed(MDZData.DrugDose ==0);
B = MDZData.MeanSpeed(MDZData.DrugDose ==0.25);
ToPerm = [A,B] ;
Realp = ranksum(A,B);
RealEffSize = (mean(A)-mean(B))./mean([std(A),std(B)]);

for k = 1:5000
    
    AfterPerm = ToPerm(randperm(16));
    [p,h] = ranksum(AfterPerm(1:8),AfterPerm(9:end));
    AllPs(k) = p;
    AllEffSize(k) = (mean(AfterPerm(1:8))-mean(AfterPerm(9:end)))./mean([std(AfterPerm(1:8)),std(AfterPerm(9:end))]);
end
hist(AllEffSize,200)
line([1 1]*RealEffSize,ylim)
title(num2str(1-sum(AllEffSize>RealEffSize)/5000))

