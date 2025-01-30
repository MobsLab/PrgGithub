clear all
SessionNames = {'SleepPre','SleepPost','UMazeCond'};
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,514];

for mm = 1:length(MiceNumber)
    clear Dir DirTemp Ripples Spikes StimEpoch Q Epoch RippleSpiking
    DirTemp = GetAllMouseTaskSessions(MiceNumber(mm));
    
    for ss = 1:length(SessionNames)
        
        % Find the session files
        x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
        ToKeep = find(~cellfun(@isempty,x1));
        Dir.(SessionNames{ss}) = DirTemp(ToKeep);
        
        cd(Dir.(SessionNames{ss}){1})
        load('ChannelsToAnalyse/dHPC_rip.mat')
        
        Ripples.(SessionNames{ss}) = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
        Spikes.(SessionNames{ss}) = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
        [numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
        Spikes.(SessionNames{ss}) = Spikes.(SessionNames{ss})(numNeurons);
        
        StimEpoch.(SessionNames{ss}) = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','stimepoch');
        SleepEpochs.(SessionNames{ss}) = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem
        if ss~=3
            Ripples.(SessionNames{ss}) = Restrict(Ripples.(SessionNames{ss}), SleepEpochs.(SessionNames{ss}){2});
        end
        
        LFP = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'lfp','ChanNumber',channel);
        
        % Make Q from S for each session type
        Q.(SessionNames{ss}) = MakeQfromS(Spikes.(SessionNames{ss}),Binsize);
        
        RippleSpiking{ss} = [];
        datQ = Data(Q.(SessionNames{ss}));
        for nn = 1:length(numNeurons)
            [M,T] = PlotRipRaw(tsd(Range(Q.(SessionNames{ss})),zscore(datQ(:,nn))),Range(Ripples.(SessionNames{ss}),'s'),1000,0,0);
            RippleSpiking{ss} = [RippleSpiking{ss},zscore(M(:,2))];
            
        end
        
        % Template Epochs to use
        Epoch.(SessionNames{ss}).PostRipples = mergeCloseIntervals(intervalSet(Range(Ripples.(SessionNames{ss}))-0.0*1e4,Range(Ripples.(SessionNames{ss}))+0.1*1e4),0.05*1e4);
        Epoch.(SessionNames{ss}).PreRipples = (mergeCloseIntervals(intervalSet(Range(Ripples.(SessionNames{ss}))-0.8*1e4,Range(Ripples.(SessionNames{ss}))-0.7*1e4),0.05*1e4))-Epoch.(SessionNames{ss}).PostRipples;
        if ss==3
            StimEpochToRemove = intervalSet(Start(StimEpoch.(SessionNames{ss})),Start(StimEpoch.(SessionNames{ss}))+0.2*1e4);
            Epoch.(SessionNames{ss}).PostStim=intervalSet(Start(StimEpoch.(SessionNames{ss}))+0.3*1e4,Start(StimEpoch.(SessionNames{ss}))+0.9*1e4)-StimEpochToRemove;
            Epoch.(SessionNames{ss}).PreStim=intervalSet(Start(StimEpoch.(SessionNames{ss}))-2*1e4,Start(StimEpoch.(SessionNames{ss}))-1.4*1e4)-StimEpochToRemove;
        end
        
    end
    
    
    
    % Template is ripples
    RippleType = {'PostRipples','PreRipples'}
    for rr = 1:length(RippleType)
        for sstemp = 1 : length(SessionNames)
            
            % Get the template data
            QTemplate = Restrict(Q.(SessionNames{sstemp}),Epoch.(SessionNames{sstemp}).(RippleType{rr}));
            DatTemplate = Data(QTemplate);
            BadGuys = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
            DatTemplate(:,BadGuys) = [];
            DatTemplate = full(DatTemplate);
            
            
            % get the templates and calulcate rectivation strength
            %             [templates.(RippleType{rr}).(SessionNames{sstemp}),correlations.(RippleType{rr}).(SessionNames{sstemp}),eigenvalues.(RippleType{rr}).(SessionNames{sstemp}),eigenvectors.(RippleType{rr}).(SessionNames{sstemp}),lambdaMax.(RippleType{rr}).(SessionNames{sstemp})] = ActivityTemplates_SB(DatTemplate,0);
            
            for ssmatch = 1:length(SessionNames)
                
                % Match
                EpochTemp = mergeCloseIntervals(intervalSet(Range(Ripples.(SessionNames{ssmatch}))-1*1e4,Range(Ripples.(SessionNames{ssmatch}))+1*1e4),0.05*1e4);
                
                DatMatch = Data(Q.(SessionNames{ssmatch}));
                DatMatch(:,BadGuys) = [];
                DatMatch = full(DatMatch);
                
                
                
                %                 strength = ReactivationStrength_SB(DatMatch,templates.(RippleType{rr}).(SessionNames{sstemp}));
                [R,phi,PCs] = ReactStrength(DatTemplate,DatMatch);
                
                %                 for comp = 1:size(templates.(RippleType{rr}).(SessionNames{sstemp}),3)
                for comp = 1    : size(R,2)
                    
                    %                     Strtsd = tsd(Range(Q.(SessionNames{ssmatch})),strength(:,comp));
                    Strtsd = tsd(Range(Q.(SessionNames{ssmatch})),R(:,comp));
                    
                    if ssmatch == 3
                        [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch.(SessionNames{ssmatch}),'s'),3000,0,0);
                        SaveTriggeredStim.(RippleType{rr}).(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}(comp,:) = M(:,2);
                    end
                    
                    [M,T] = PlotRipRaw(Strtsd,Range(Ripples.(SessionNames{ssmatch}),'s'),1000,0,0);
                    SaveTriggeredRipples.(RippleType{rr}).(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}(comp,:) = M(:,2);
                    
                end
            end
        end
    end
    
    
    
    % Template is stim
    StimType = {'PostStim','PreStim'}
    for rr = 1:length(StimType)
        for sstemp = 3
            
            % Get the template data
            QTemplate = Restrict(Q.(SessionNames{sstemp}),Epoch.(SessionNames{sstemp}).(StimType{rr}));
            DatTemplate = Data(QTemplate);
            BadGuys = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
            DatTemplate(:,BadGuys) = [];
            DatTemplate = full(DatTemplate);
            
            
            % get the templates and calulcate rectivation strength
            %             [templates.(StimType{rr}).(SessionNames{sstemp}),correlations.(StimType{rr}).(SessionNames{sstemp}),eigenvalues.(StimType{rr}).(SessionNames{sstemp}),eigenvectors.(StimType{rr}).(SessionNames{sstemp}),lambdaMax.(StimType{rr}).(SessionNames{sstemp})] = ActivityTemplates_SB(DatTemplate,0);
            
            for ssmatch = 1:length(SessionNames)
                
                % Match
                DatMatch = Data(Q.(SessionNames{ssmatch}));
                DatMatch(:,BadGuys) = [];
                DatMatch = full(DatMatch);
                
                % strength = ReactivationStrength_SB(DatMatch,templates.(StimType{rr}).(SessionNames{sstemp}));
                [R,phi,PCs] = ReactStrength(DatTemplate,DatMatch);
                
                % for comp = 1:size(templates.(StimType{rr}).(SessionNames{sstemp}),3)
                for comp = 1    : size(R,2)
                    
                    %Strtsd = tsd(Range(Q.(SessionNames{ssmatch})),strength(:,comp));
                    Strtsd = tsd(Range(Q.(SessionNames{ssmatch})),R(:,comp));
                    
                    if ssmatch == 3
                        [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch.(SessionNames{ssmatch}),'s'),3000,0,0);
                        SaveTriggeredStim.(StimType{rr}).(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}(comp,:) = M(:,2);
                        tpsstim = M(:,1);
                    end
                    
                    [M,T] = PlotRipRaw(Strtsd,Range(Ripples.(SessionNames{ssmatch}),'s'),1000,0,0);
                    SaveTriggeredRipples.(StimType{rr}).(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}(comp,:) = M(:,2);
                    tpsrip = M(:,1);
                    
                end
            end
        end
    end
    
end


for sstemp = 1 : length(SessionNames)
    for ssmatch = 1:length(SessionNames)
        AllComp.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}) = [];
        AllComp.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}) = [];
        
        
        for mm = 1:length(MiceNumber)
            
            AllComp.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}) = [AllComp.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch});SaveTriggeredRipples.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}];
            AllComp.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}) = [AllComp.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch});SaveTriggeredRipples.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}];
            
        end
    end
end

figure
for sstemp = 1 : length(SessionNames)
    for ssmatch = 1:length(SessionNames)
        try
            subplot(3,3,sstemp+(ssmatch-1)*3)
            errorbar(tpsrip,nanmean(AllComp.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch})),stdError(AllComp.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch})),'k')
            hold on
            errorbar(tpsrip,nanmean(AllComp.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch})),stdError(AllComp.PostRipples.(SessionNames{sstemp}).(SessionNames{ssmatch})),'r')
        end
    end
end


figure
for sstemp = 1 : length(SessionNames)
    for ssmatch = 1:length(SessionNames)
        try
            subplot(3,3,sstemp+(ssmatch-1)*3)
            for mm = 1:length(MiceNumber)

            % plot(nanmean(SaveTriggeredStim.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}))
            plot(nanmean(SaveTriggeredRipples.PreRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}))
            hold on
            end
            ylim([0.1 2])
        end
    end
end


figure
for sstemp = 1 : length(SessionNames)
    for ssmatch = 1:length(SessionNames)
        try
            subplot(3,3,sstemp+(ssmatch-1)*3)
            for mm = 1:length(MiceNumber)

            plot(nanmean(SaveTriggeredStim.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}))
%             plot(nanmean(SaveTriggeredRipples.(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}))
            hold on
            end
            ylim([0.1 2])
        end
    end
end






%%%
mm=3;
DirTemp = GetAllMouseTaskSessions(MiceNumber(mm));

ss=3;
Binsize = 0.1*1e4;

SessionNames = {'SleepPre','SleepPost','UMazeCond'};
MiceNumber=[490,507,508,509,514];
% Find the session files
x1 = strfind(DirTemp,[SessionNames{ss} filesep]);
ToKeep = find(~cellfun(@isempty,x1));
Dir.(SessionNames{ss}) = DirTemp(ToKeep);

cd(Dir.(SessionNames{ss}){1})
load('ChannelsToAnalyse/dHPC_rip.mat')

Ripples = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'ripples');
Spikes = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'spikes');
[numNeurons, numtt, TT]=GetSpikesFromStructure('PFCx');
Spikes = Spikes(numNeurons);
SleepEpochs = ConcatenateDataFromFolders_SB(Dir.(SessionNames{ss}),'epoch','epochname','sleepstates'); % wake - nrem -rem


% Make Q from S for each session type
Q = MakeQfromS(Spikes,Binsize);


RipplesRest = Restrict(Ripples,SleepEpochs{2});
RipplesRest = Ripples;
% Get the template data
QTemplate = Restrict(Q,intervalSet(Range(RipplesRest)-0.4*1e4,Range(RipplesRest)-0.2*1e4));
DatTemplate = Data(Q);
BadGuys = find(sum(DatTemplate)==0); % get rid of neurons with zero spikes
DatTemplate(:,BadGuys) = [];
DatTemplate = full(DatTemplate);

% QMatch = Restrict(Q,mergeCloseIntervals(intervalSet(Range(Ripples)-1*1e4,Range(Ripples)+1*1e4),1*1e4));
% QMatchTime = Range(Restrict(Q,mergeCloseIntervals(intervalSet(Range(Ripples)-1*1e4,Range(Ripples)+1*1e4),1*1e4)));

DatMatch = Data(Q);

% BadGuys = find(sum(DatMatch)==0); % get rid of neurons with zero spikes
DatMatch(:,BadGuys) = [];
DatMatch = full(DatMatch);
[R,phi,PCs] = ReactStrength(DatTemplate,DatMatch);
Strtsd = tsd(Range(Q),R(:,1));
[M,T] = PlotRipRaw(Strtsd,(Range(RipplesRest,'s')),900,0,0);
plot(M(:,2))

figure
for rip = 1:3
    clear AllNeur
    RipplesRest = Restrict(ts(RipplesR(:,rip)*10),SWSEpoch);
    for k = 1:size(Spikes,2)
        Q = Restrict(MakeQfromS(S(k),Binsize),SWSEpoch);
        [M,T] = PlotRipRaw(LFP,(Range(RipplesRest,'s')),4000,0,0);
        AllNeur(k,:) = M(:,2);
    end
    subplot(2,3,rip)
    imagesc(M(:,1),1:99,nanzscore(AllNeur')')
    subplot(2,3,rip+3)
    plot(M(:,1),nanmean(nanzscore(AllNeur')'))
    line([0 0],ylim)
end

figure
for rip = 1:3
    clear AllNeur
    RipplesRest = Restrict(ts(RipplesR(:,rip)*10),SWSEpoch);
    for k = 1:size(Spikes,2)
        Q = MakeQfromS(S(k),Binsize);
        datQ = nanzscore(Data(Q));
        Q = tsd(Range(Q),datQ);
        [M,T] = PlotRipRaw(Q,(Range(RipplesRest,'s')),4000,0,0);
        AllNeur(k,:) = M(:,2);
    end
    subplot(2,3,rip)
    imagesc(M(:,1),1:99,(AllNeur')')
    subplot(2,3,rip+3)
    plot(M(:,1),nanmean((AllNeur')'))
    line([0 0],ylim)
end

figure
for rip = 1:3
    clear AllNeur
    RipplesRest = Restrict(ts(RipplesR(:,rip)*10),SWSEpoch);
    for k = 1:size(Spikes,2)
        Q = (MakeQfromS(S(k),Binsize));
        datQ = ((Data(Q))-nanmean(Data(Restrict(Q,SWSEpoch))))./std(Data(Restrict(Q,SWSEpoch)));
        Q = tsd(Range(Q),datQ);
        [M,T] = PlotRipRaw(Q,(Range(RipplesRest,'s')),4000,0,0);
        AllNeur(k,:) = M(:,2);
    end
    subplot(2,3,rip)
    imagesc(M(:,1),1:99,(AllNeur')')
    subplot(2,3,rip+3)
    plot(M(:,1),nanmean((AllNeur')'))
    line([0 0],ylim)
end




% get the templates and calulcate rectivation strength
%             [templates.(RippleType{rr}).(SessionNames{sstemp}),correlations.(RippleType{rr}).(SessionNames{sstemp}),eigenvalues.(RippleType{rr}).(SessionNames{sstemp}),eigenvectors.(RippleType{rr}).(SessionNames{sstemp}),lambdaMax.(RippleType{rr}).(SessionNames{sstemp})] = ActivityTemplates_SB(DatTemplate,0);

for ssmatch = 1:length(SessionNames)
    
    % Match
    EpochTemp = mergeCloseIntervals(intervalSet(Range(Ripples.(SessionNames{ssmatch}))-1*1e4,Range(Ripples.(SessionNames{ssmatch}))+1*1e4),0.05*1e4);
    
    DatMatch = Data(Restrict(Q.(SessionNames{ssmatch}),EpochTemp));
    DatMatch(:,BadGuys) = [];
    DatMatch = full(DatMatch);
    
    
    
    %                 strength = ReactivationStrength_SB(DatMatch,templates.(RippleType{rr}).(SessionNames{sstemp}));
    [R,phi,PCs] = ReactStrength(DatTemplate,DatMatch);
    
    %                 for comp = 1:size(templates.(RippleType{rr}).(SessionNames{sstemp}),3)
    for comp = 1    : size(R,2)
        
        %                     Strtsd = tsd(Range(Q.(SessionNames{ssmatch})),strength(:,comp));
        Strtsd = tsd(Range(Restrict(Q.(SessionNames{ssmatch}),EpochTemp)),R(:,comp));
        
        if ssmatch == 3
            [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch.(SessionNames{ssmatch}),'s'),3000,0,0);
            SaveTriggeredStim.(RippleType{rr}).(SessionNames{sstemp}).(SessionNames{ssmatch}){mm}(comp,:) = M(:,2);
        end
    end
end