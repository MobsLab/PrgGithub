clear all, close all
cd /media/DataMOBsRAIDN/ProjectEmbReact/Figures/FiguresAllMice
MiceNumber=[490,507,508,509,510,512,514];

Binsize = 0.1*1e4;
SpeedLim = 2;

for mm=1:length(MiceNumber)
    
    mm
    clear Dir
    Dir = GetAllMouseTaskSessions(MiceNumber(mm));
    x1 = strfind(Dir,'TestPost');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir_TP = Dir(ToKeep);
    
    x1 = strfind(Dir,'UMazeCond');
    ToKeep = find(~cellfun(@isempty,x1));
    Dir = Dir(ToKeep);
    Ripples = ConcatenateDataFromFolders_SB(Dir,'ripples');
    
    if not(isempty(Ripples))
        cd(Dir{1})
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes = ConcatenateDataFromFolders_SB(Dir,'spikes');
        Spikes = Spikes(numNeurons);
        
        NoiseEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','noiseepochclosestims');
        FreezeEpoch = ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','freezeepoch');
        StimEpoch= ConcatenateDataFromFolders_SB(Dir,'epoch','epochname','stimepoch');
        
        LinPos = ConcatenateDataFromFolders_SB(Dir,'linearposition');
        PosXY = ConcatenateDataFromFolders_SB(Dir,'alignedposition');
        
        Vtsd = ConcatenateDataFromFolders_SB(Dir,'speed');
        MovEpoch = thresholdIntervals(Vtsd,SpeedLim,'Direction','Above');
        MovEpoch = mergeCloseIntervals(MovEpoch,2*1e4);
        
        % Clean epochs
        TotEpoch = intervalSet(0,max(Range(Vtsd)));
        TotEpoch = TotEpoch-NoiseEpoch;
        FreezeEpoch = FreezeEpoch-NoiseEpoch;
        MovEpoch = MovEpoch - NoiseEpoch;
        Ripples = Restrict(Ripples,TotEpoch);
        
        % If need to remove stims of ripples
        StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+3*1e4);
        RipEpochToRemove = intervalSet(Range(Ripples),Range(Ripples)+0.001*1e4);
        
        % Task performance
        for t = 1:4
            ZoneEpochTestPost = ConcatenateDataFromFolders_SB(Dir_TP(t),'epoch','epochname','zoneepoch');
            ShockTime(t) = sum(Stop(ZoneEpochTestPost{1},'s') - Start(ZoneEpochTestPost{1},'s'));
            if ShockTime(t)>0
                EntryTime(t) = min(Start(ZoneEpochTestPost{1},'s'));
            else
                EntryTime(t) = 200;
            end
        end
        
        save(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'],...
            'Spikes','Ripples','MovEpoch','LinPos','FreezeEpoch','PosXY','StimEpoch','ShockTime','EntryTime')
        
    end
end


figure
for mm=1:length(MiceNumber)
    try
    load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
    
    % Template
    TemplateEpoch= intervalSet(Start(StimEpoch)-3*1E4,Start(StimEpoch)+3*1e4);
    Q = MakeQfromS(Spikes,Binsize);
    QTemplate = Restrict(Q,TemplateEpoch);
    QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));
    
    dat = Data(QTemplate);
    BadGuys = find(sum(isnan(Data(QTemplate))));
    for i = 1:length(BadGuys)
        dat(:,BadGuys(i)) = zeros(size(dat,1),1);
    end
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(dat,1);
    
    
    RipplesEp = intervalSet(Range(Ripples)-3*1E4,Range(Ripples)+3*1E4);
    RipplesEpMerge = mergeCloseIntervals(RipplesEp,3*1E4);
    Q = MakeQfromS(Spikes,1000);
    Q = Restrict(Q,RipplesEpMerge);
    
    % Shuffle cell identity
    Qdat =  Data(Q);
    for tps = 1:length(Qdat)
        Qdat(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
    end
    QShuff = tsd(Range(Q),Qdat);
    
    strength = ReactivationStrength_SB((Data(Q)),templates);
    strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates);
    
    RipplesEp = intervalSet(Range(Ripples),Range(Ripples)+1*1E4);
    RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
    RipplesClean = ts(Start(RipplesEpMerge));
    
    num=1;
    clear SaveTriggeredRipZ SaveTriggeredRip SaveTriggeredRipZ_Shuff SaveTriggeredRip_Shuff SaveTriggeredRip_All
    for comp = 1:size(strength,2)
        if eigenvalues(comp)/lambdaMax>1
            
            % trigger react stregnth on stims
            Strtsd = tsd(Range(Q),strength(:,comp));
            
            [M,T] = PlotRipRaw(Strtsd,Range(RipplesClean,'s'),1000,0,0);
            SaveTriggeredRipZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            SaveTriggeredRip(num,:) = M(:,2);
            SaveTriggeredRip_All(num,:,:) = T;
            
            Strtsd = tsd(Range(Q),strengthShuff(:,comp));
            [M,T] = PlotRipRaw(Strtsd,Range(RipplesClean,'s'),1000,0,0);
            SaveTriggeredRipZ_Shuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            SaveTriggeredRip_Shuff(num,:) = M(:,2);
            
            tpsrip = M(:,1);
            num = num+1;
        end
    end
    
    clear RipplePos
    for rr = 1:length(Start(RipplesEpMerge))
        RipplePos(rr) = nanmean(Data(Restrict(LinPos,subset(RipplesEpMerge,rr))));
    end
    
    subplot(7,4,(mm-1)*4+1)
    plot(tpsrip,nanmean(SaveTriggeredRip))
    hold on
    plot(tpsrip,nanmean(SaveTriggeredRip_Shuff))
    
    subplot(7,4,(mm-1)*4+2)
    plot(squeeze(nanmean(nanmean(SaveTriggeredRip_All(:,:,12:18),3),1)),RipplePos+randn(size(RipplePos))*0.01,'.')
    
    subplot(7,4,(mm-1)*4+3)
    bar(EntryTime)
    
    subplot(7,4,(mm-1)*4+4)
    bar(ShockTime)
    end
end