MiceNumber=[490,507,508,509,510,512,514];
Dir=PathForExperimentsEmbReact('EPM');
AllVisitTime = [];
clf
for d=1:length(Dir.path)
    MouseNum_Dir(d) = Dir.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMice]=intersect(MouseNum_Dir,MiceNumber);
Dir2 = PathForExperimentsEmbReact('UMazeCond');
for d=1:length(Dir2.path)
    MouseNum_Dir2(d) = Dir2.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMice2]=intersect(MouseNum_Dir2,MiceNumber);

Cols  = {'r','b'};
for d=1:length(PosOfMice)
    for dd=1:length(Dir.path{PosOfMice(d)})
        cd(Dir.path{PosOfMice(d)}{dd})
        load('SpikeData.mat')
        load('behavResources_SB.mat')
        %         for i = 1:3
        %             subplot(3,1,i)
        %             Behav.ZoneEpoch{i} = mergeCloseIntervals(Behav.ZoneEpoch{i},1*1e4);
        %             Behav.ZoneEpoch{i} = dropShortIntervals(Behav.ZoneEpoch{i},1*1e4);
        %
        %             plot(Start(Behav.ZoneEpoch{i},'s'),Stop(Behav.ZoneEpoch{i},'s')-Start(Behav.ZoneEpoch{i},'s'))
        %             hold on
        %         end
        [Y,X] = hist(Range(Restrict(Behav.Xtsd,Behav.ZoneEpoch{1}),'s'),[0:40:1200]);
        MDZData.OpenOccup(d,:) = Y;
        [Y,X] = hist(Range(Restrict(Behav.Xtsd,Behav.ZoneEpoch{2}),'s'),[0:40:1200]);
        MDZData.ClosedOccup(d,:) = Y;
        [Y,X] = hist(Range(Restrict(Behav.Xtsd,Behav.ZoneEpoch{3}),'s'),[0:40:1200]);
        MDZData.CentreOccup(d,:) = Y;
        TotOccup = (MDZData.OpenOccup(d,:)) + (MDZData.ClosedOccup(d,:)) + (MDZData.CentreOccup(d,:));
        MDZData.CentreOccup(d,:) = MDZData.CentreOccup(d,:)./TotOccup;
        MDZData.OpenOccup(d,:) = MDZData.OpenOccup(d,:)./TotOccup;
        MDZData.ClosedOccup(d,:) = MDZData.ClosedOccup(d,:)./TotOccup;
        %         AllVisitTime = [AllVisitTime;(Range(Restrict(Behav.Xtsd,Behav.ZoneEpoch{3}),'s'))];
        %         AllVisitTime = [AllVisitTime;Start(Behav.ZoneEpoch{1},'s')];
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        S = S(numNeurons);
        Q = MakeQfromS(S,1*1e4);
        DatMat = full(zscore(Data(Q)))';
        [EigVect,EigVals]=PerformPCA(DatMat);
        Projtsd1 = tsd(Range(Q),(EigVect(:,1)'*DatMat)');
        Projtsd2 = tsd(Range(Q),(EigVect(:,2)'*DatMat)');
        subplot(5,7,d)
        Cols = {'r','b'}
        for i = 1:2
            plot(Data(Restrict(Projtsd1,and(Behav.ZoneEpoch{i},intervalSet(0,1200*1e4)))),Data(Restrict(Projtsd2,and(Behav.ZoneEpoch{i},intervalSet(0,1200*1e4)))),'.','color',Cols{i}), hold on
        end
        
        DatMat = tsd(Range(Q),full(zscore(Data(Q))));
        EPMAxis = nanmean(Data(Restrict(DatMat,Behav.ZoneEpoch{1})))-nanmean(Data(Restrict(DatMat,Behav.ZoneEpoch{2})));
        
        xlim([-10 10]),ylim([-10 10])
        %         subplot(4,7,d+7)
        %         for i = 1:2
        %             plot(Data(Restrict(Projtsd1,and(Behav.ZoneEpoch{i},intervalSet(600*1e4,1200*1e4)))),Data(Restrict(Projtsd2,and(Behav.ZoneEpoch{i},intervalSet(600*1e4,1200*1e4)))),'.'), hold on
        %         end
        %         xlim([-10 10]),ylim([-10 10])
        AllDatMat = [];
        AllDatMatFz = [];
        LinPos = [];
        LinPosFz = [];
        Time = [0];
        TimeFz = [0];
        
        
        S_Cond=ConcatenateDataFromFolders_SB(Dir2.path{PosOfMice2(d)},'spikes');
        Zones_Cond = ConcatenateDataFromFolders_SB(Dir2.path{PosOfMice2(d)},'zoneepoch');
        Freeze_Cond = ConcatenateDataFromFolders_SB(Dir2.path{PosOfMice2(d)},'freezeepoch');
        Noise_Cond = ConcatenateDataFromFolders_SB(Dir2.path{PosOfMice2(d)},'noiseepoch');

        for cond = 1:5
            cd(Dir2.path{PosOfMice2(d)}{cond})
            load('SpikeData.mat')
            S = S(numNeurons);
            Q = MakeQfromS(S,3*1e4);
            load('behavResources_SB.mat')
            TotEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
            load('StateEpochSB.mat','TotalNoiseEpoch')
            TotEpoch = TotEpoch - TotalNoiseEpoch;
            DatMat = full((Data(Restrict(Q,TotEpoch-Behav.FreezeAccEpoch))))';
            AllDatMat = [AllDatMat,DatMat];
            DatMat = full((Data(Restrict(Q,Behav.FreezeAccEpoch))))';
            AllDatMatFz = [AllDatMatFz,DatMat];
            LinPos = [LinPos;Data(Restrict(Behav.LinearDist,ts(Range(Restrict(Q,TotEpoch-Behav.FreezeAccEpoch)))))];
            LinPosFz = [LinPosFz;Data(Restrict(Behav.LinearDist,ts(Range(Restrict(Q,Behav.FreezeAccEpoch)))))];
            Time = [Time;Range(Restrict(Behav.LinearDist,ts(Range(Restrict(Q,TotEpoch-Behav.FreezeAccEpoch)))))+max(Time)];
            TimeFz = [TimeFz;Range(Restrict(Behav.LinearDist,ts(Range(Restrict(Q,Behav.FreezeAccEpoch)))))+max(TimeFz)];
        end
        
        
        
        AllDatMat = zscore(AllDatMat')';
        AllDatMatFz = zscore(AllDatMatFz')';
        subplot(3,7,d+7)
        [EigVect,EigVals]=PerformPCA((AllDatMat));
        %         plot(EigVect(:,2)'*AllDatMat,LinPos,'*'), hold on
        %         scatter(EigVect(:,1)'*AllDatMat,EigVect(:,2)'*AllDatMat,5,LinPos,'filled'), hold on
        scatter(UMazeAxis*AllDatMat,EPMAxis*AllDatMat,5,LinPos,'filled'), hold on
        
        %         xlim([-10 10]),ylim([-10 10])
        clim([0 1])
        
        subplot(3,7,d+14)
        [EigVect,EigVals]=PerformPCA((AllDatMatFz));
        %                 plot(EigVect(:,2)'*AllDatMatFz,LinPosFz,'*'), hold on
        
        %         scatter(EigVect(:,1)'*AllDatMatFz,EigVect(:,2)'*AllDatMatFz,5,LinPosFz,'filled'), hold on
        scatter(UMazeAxis*AllDatMatFz,EPMAxis*AllDatMatFz,5,LinPosFz,'filled'), hold on
        %         xlim([-10 10]),ylim([-10 10])
        clim([0 1])
        
        
        
        %
        %         for cond = 1:5
        %             cd(Dir2.path{PosOfMice2(d)}{cond})
        %
        %             load('SpikeData.mat')
        %             S = S(numNeurons);
        %             Q = MakeQfromS(S,1*1e4);
        %             load('behavResources_SB.mat')
        %             DatMat = full(zscore(Data(Q)))';
        %             TotEpoch = intervalSet(0,max(Range(Behav.Vtsd)));
        %
        %             Projtsd1 = tsd(Range(Q),(EigVect(:,1)'*DatMat)');
        %             Projtsd2 = tsd(Range(Q),(EigVect(:,2)'*DatMat)');
        %             subplot(4,7,d+14)
        %
        %             scatter(Data(Restrict(Projtsd1,Behav.FreezeAccEpoch)),Data(Restrict(Projtsd2,Behav.FreezeAccEpoch)),15,Data(Restrict(Behav.LinearDist,ts(Range(Restrict(Projtsd1,Behav.FreezeAccEpoch))))),'filled')
        %             hold on
        %             xlim([-10 10]),ylim([-10 10])
        %
        %             subplot(4,7,d+21)
        %             scatter(Data(Restrict(Projtsd1,TotEpoch-Behav.FreezeAccEpoch)),Data(Restrict(Projtsd2,TotEpoch-Behav.FreezeAccEpoch)),15,Data(Restrict(Behav.LinearDist,ts(Range(Restrict(Projtsd1,TotEpoch-Behav.FreezeAccEpoch))))),'filled')
        %             hold on
        %             xlim([-10 10]),ylim([-10 10])
        %
        %
        %         end
        %
        %                 for k = 1 :4
        %                     subplot(5,1,k)
        %                     Projtsd = tsd(Range(Q),(EigVect(:,k)'*DatMat)');
        %                     plot(Range(Projtsd,'s'),Data(Projtsd))
        %                     hold on
        %                     plot(Range(Restrict(Projtsd,Behav.ZoneEpoch{1}),'s'),Data(Restrict(Projtsd,Behav.ZoneEpoch{1})),'.')
        %                     plot(Range(Restrict(Projtsd,Behav.ZoneEpoch{2}),'s'),Data(Restrict(Projtsd,Behav.ZoneEpoch{2})),'.')
        %                     plot(Range(Restrict(Projtsd,Behav.ZoneEpoch{3}),'s'),Data(Restrict(Projtsd,Behav.ZoneEpoch{3})),'.')
        %                     legend('all','open','closed','center')
        %                 end
        %                 subplot(5,1,5)
        %                 plot(Range(Behav.Vtsd,'s'),Data(Behav.Vtsd))
    end
end