MiceNumber=[490,507,508,509,510,512,514];
AllVisitTime = [];
figure

% EPM
DirEPM=PathForExperimentsEmbReact('EPM');
for d=1:length(DirEPM.path)
    MouseNum_Dir(d) = DirEPM.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceEPM]=intersect(MouseNum_Dir,MiceNumber);

DirCond = PathForExperimentsEmbReact('UMazeCond');
for d=1:length(DirCond.path)
    MouseNum_DirCond(d) = DirCond.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceCond]=intersect(MouseNum_DirCond,MiceNumber);

DirHab = PathForExperimentsEmbReact('Habituation');
for d=1:length(DirHab.path)
    MouseNum_DirHab(d) = DirHab.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceHab]=intersect(MouseNum_DirHab,MiceNumber);

DirTestPre = PathForExperimentsEmbReact('TestPre');
for d=1:length(DirTestPre.path)
    MouseNum_DirTestPre(d) = DirTestPre.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceTestPre]=intersect(MouseNum_DirTestPre,MiceNumber);


DirExt = PathForExperimentsEmbReact('Extinction');
for d=1:length(DirExt.path)
    MouseNum_DirExt(d) = DirExt.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceExt]=intersect(MouseNum_DirExt,MiceNumber);

DirTestPost = PathForExperimentsEmbReact('TestPost');
for d=1:length(DirTestPost.path)
    MouseNum_DirTestPost(d) = DirTestPost.ExpeInfo{d}{1}.nmouse;
end
[~,PosOfMiceTestPost]=intersect(MouseNum_DirTestPost,MiceNumber);


Cols  = {'r','b'};
for d=1:length(PosOfMiceEPM)
    for dd=1:length(DirEPM.path{PosOfMiceEPM(d)})
        cd(DirEPM.path{PosOfMiceEPM(d)}{dd})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        
        % Conditioning
        S_Cond=ConcatenateDataFromFolders_SB(DirCond.path{PosOfMiceCond(d)},'spikes');
        Zones_Cond = ConcatenateDataFromFolders_SB(DirCond.path{PosOfMiceCond(d)},'epoch','epochname','zoneepoch');
        Freeze_Cond = ConcatenateDataFromFolders_SB(DirCond.path{PosOfMiceCond(d)},'epoch','epochname','freezeepoch');
        Noise_Cond = ConcatenateDataFromFolders_SB(DirCond.path{PosOfMiceCond(d)},'epoch','epochname','noiseepoch');
        LinPost_Cond= ConcatenateDataFromFolders_SB(DirCond.path{PosOfMiceCond(d)},'linearposition');
        TotEpoch = intervalSet(0,max(Range(LinPost_Cond)));
        TotEpoch = TotEpoch-Noise_Cond;
        Freeze_Cond = Freeze_Cond-Noise_Cond;
        for ep = 1:5
            Zones_Cond{ep} = Zones_Cond{ep} -  Noise_Cond;
        end
        ShockZone = or(Zones_Cond{1},Zones_Cond{4});
        SafeZone = or(Zones_Cond{2},Zones_Cond{5});
        S_Cond = S_Cond(numNeurons);
        Q_Cond = MakeQfromS((S_Cond),1*1e4);
        DatMat_Cond = tsd(Range(Q_Cond),full(zscore(Data(Q_Cond))));
        LinPost_Cond = Restrict(LinPost_Cond,ts(Range(DatMat_Cond)));
        
        
        % Habituation
        S_Hab=ConcatenateDataFromFolders_SB([DirHab.path{PosOfMiceHab(d)},DirTestPre.path{PosOfMiceTestPre(d)}],'spikes');
        Zones_Hab = ConcatenateDataFromFolders_SB(DirHab.path{PosOfMiceHab(d)},'epoch','epochname','zoneepoch');
        Freeze_Hab = ConcatenateDataFromFolders_SB(DirHab.path{PosOfMiceHab(d)},'epoch','epochname','freezeepoch');
        Noise_Hab = ConcatenateDataFromFolders_SB(DirHab.path{PosOfMiceHab(d)},'epoch','epochname','noiseepoch');
        LinPost_Hab= ConcatenateDataFromFolders_SB(DirHab.path{PosOfMiceHab(d)},'linearposition');
        TotEpoch = intervalSet(0,max(Range(LinPost_Hab)));
        TotEpoch = TotEpoch-Noise_Hab;
        Freeze_Hab = Freeze_Hab-Noise_Hab;
        for ep = 1:5
            Zones_Hab{ep} = Zones_Hab{ep} -  Noise_Hab;
        end
        ShockZoneHab = or(Zones_Hab{1},Zones_Hab{4});
        SafeZoneHab = or(Zones_Hab{2},Zones_Hab{5});
        S_Hab = S_Hab(numNeurons);
        Q_Hab = MakeQfromS((S_Hab),1*1e4);
        DatMat_Hab = tsd(Range(Q_Hab),full(zscore(Data(Q_Hab))));
        LinPost_Hab = Restrict(LinPost_Hab,ts(Range(DatMat_Hab)));

        % Extinction
        S_Ext=ConcatenateDataFromFolders_SB([DirExt.path{PosOfMiceExt(d)},DirTestPost.path{PosOfMiceTestPost(d)}],'spikes');
        Zones_Ext = ConcatenateDataFromFolders_SB(DirExt.path{PosOfMiceExt(d)},'epoch','epochname','zoneepoch');
        Freeze_Ext = ConcatenateDataFromFolders_SB(DirExt.path{PosOfMiceExt(d)},'epoch','epochname','freezeepoch');
        Noise_Ext = ConcatenateDataFromFolders_SB(DirExt.path{PosOfMiceExt(d)},'epoch','epochname','noiseepoch');
        LinPost_Ext= ConcatenateDataFromFolders_SB(DirExt.path{PosOfMiceExt(d)},'linearposition');
        TotEpoch = intervalSet(0,max(Range(LinPost_Ext)));
        TotEpoch = TotEpoch-Noise_Ext;
        Freeze_Ext = Freeze_Ext-Noise_Ext;
        for ep = 1:5
            Zones_Ext{ep} = Zones_Ext{ep} -  Noise_Ext;
        end
        ShockZoneExt = (Zones_Ext{1});
        SafeZoneExt = or(Zones_Ext{2},Zones_Ext{5});
        S_Ext = S_Ext(numNeurons);
        Q_Ext = MakeQfromS((S_Ext),1*1e4);
        DatMat_Ext = tsd(Range(Q_Ext),full(zscore(Data(Q_Ext))));
        LinPost_Ext = Restrict(LinPost_Ext,ts(Range(DatMat_Ext)));

        
        % EPM
        S_EPM=ConcatenateDataFromFolders_SB(DirEPM.path{PosOfMiceEPM(d)},'spikes');
        Zones_EPM = ConcatenateDataFromFolders_SB(DirEPM.path{PosOfMiceEPM(d)},'epoch','epochname','zoneepoch');
        Noise_EPM = ConcatenateDataFromFolders_SB(DirEPM.path{PosOfMiceEPM(d)},'epoch','epochname','noiseepoch');
        for ep = 1:3
            Zones_EPM{ep} = Zones_EPM{ep} -  Noise_EPM;
        end

        S_EPM = S_EPM(numNeurons);
        Q_EPM = MakeQfromS(S_EPM,1*1e4);
        DatMat_EPM = tsd(Range(Q_EPM),full(zscore(Data(Q_EPM))));
        
        EPMAxis = nanmean(Data(Restrict(DatMat_EPM,Zones_EPM{1})))-nanmean(Data(Restrict(DatMat_EPM,Zones_EPM{2})));
        UMazeAxisFz = nanmean(Data(Restrict(DatMat_Cond,and(ShockZone,Freeze_Cond))))-nanmean(Data(Restrict(DatMat_Cond,and(SafeZone,Freeze_Cond))));
        UMazeAxis = nanmean(Data(Restrict(DatMat_Cond,(ShockZone-Freeze_Cond))))-nanmean(Data(Restrict(DatMat_Cond,(SafeZone-Freeze_Cond))));
        UMazeAxisHab = nanmean(Data(Restrict(DatMat_Hab,(ShockZoneHab-Freeze_Hab))))-nanmean(Data(Restrict(DatMat_Hab,(SafeZoneHab-Freeze_Hab))));
        UMazeAxisExt = nanmean(Data(Restrict(DatMat_Ext,(ShockZoneExt-Freeze_Ext))))-nanmean(Data(Restrict(DatMat_Ext,(SafeZoneExt-Freeze_Ext))));
        UMazeAxisHab = UMazeAxisExt;
        
        subplot(5,7,d)
        Projtsd1 = tsd(Range(Q_EPM),(EPMAxis*Data(DatMat_EPM)')');
        Projtsd2 = tsd(Range(Q_EPM),(UMazeAxis*Data(DatMat_EPM)')');
        for i = 1:2
            plot(Data(Restrict(Projtsd1,and(Zones_EPM{i},intervalSet(0,1200*1e4)))),Data(Restrict(Projtsd2,and(Zones_EPM{i},intervalSet(0,1200*1e4)))),'.','color',Cols{i}), hold on
        end
        xlabel('EPMAx'), ylabel('UMazeAx')
        title('EPM data')
        
        subplot(5,7,d+7)
        DatMatAll = Restrict(DatMat_Cond,TotEpoch-Freeze_Cond);
        scatter(EPMAxis*Data(DatMatAll)',UMazeAxisHab*Data(DatMatAll)',5,Data(Restrict(LinPost_Cond,ts(Range(DatMatAll)))),'filled'), hold on
        xlabel('EPMAx'), ylabel('UMazeAx')
        title('UMaze data')
        clim([0 1])

        
        subplot(5,7,d+14)
        DatMatAll = Restrict(DatMat_Cond,TotEpoch-Freeze_Cond);
        scatter(UMazeAxisHab*Data(DatMatAll)',UMazeAxisFz*Data(DatMatAll)',5,Data(Restrict(LinPost_Cond,ts(Range(DatMatAll)))),'filled'), hold on
        xlabel('UMazeAx'), ylabel('UMazeAxFZ')
        title('UMaze data')
        clim([0 1])

        subplot(5,7,d+21)
        DatMatFzOnly = Restrict(DatMat_Cond,Freeze_Cond);
        scatter(EPMAxis*Data(DatMatFzOnly)',UMazeAxisFz*Data(DatMatFzOnly)',5,Data(Restrict(LinPost_Cond,ts(Range(DatMatFzOnly)))),'filled'), hold on
        xlabel('EPMAx'), ylabel('UMazeAxFZ')
        title('UMaze FZ data')
                clim([0 1])

        subplot(5,7,d+28)
        DatMatFzOnly = Restrict(DatMat_Cond,Freeze_Cond);
        scatter(UMazeAxisHab*Data(DatMatFzOnly)',UMazeAxisFz*Data(DatMatFzOnly)',5,Data(Restrict(LinPost_Cond,ts(Range(DatMatFzOnly)))),'filled'), hold on
        xlabel('UMazeAx'), ylabel('UMazeAxFZ')
        title('UMaze FZ data')
        clim([0 1])


        
        
    end
end