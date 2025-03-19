
close all
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509];
num = 1;
cd /home/mobsrick/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples

clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
for mm=1:length(MiceNumber)
    mm
    
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch strength templates correlations eigenvectors lambdaMax
    load(['RippleReactInfo_NewRipples_M',num2str(MiceNumber(mm)),'.mat'])
    Q = MakeQfromS(Spikes,Binsize); % data from the conditionning session
    
    
    % Template epochs
    StimEpochToRemove = intervalSet(Start(StimEpoch),Start(StimEpoch)+0.2*1e4);
    RipEpochToRemove = intervalSet(Range(Ripples)-0.2*1e4,Range(Ripples)+0.4*1e4);
    TotEpoch = intervalSet(0,max(Range(Vtsd)));
    Ripples = Restrict(Ripples,TotEpoch-NoiseEpoch);
    Ripples = Restrict(Ripples,thresholdIntervals(LinPos,0.6,'Direction','Above'));
    
    clear Epoch_Template Epoch_Match
    Epoch_Match.Poststim=intervalSet(Start(StimEpoch)+0.1*1E4,Start(StimEpoch)+3*1e4)-StimEpochToRemove;
    Epoch_Match.PreStim=intervalSet(Start(StimEpoch)-3*1e4,Start(StimEpoch))-StimEpochToRemove;
    
    %MatchEpochToFocusOn
    Epoch_Template.PostRipples=mergeCloseIntervals(intervalSet(Range(Ripples)-0.05*1e4,Range(Ripples)+0.20*1e4),0.5*1e4)-StimEpochToRemove;
    Epoch_Template.PreRipples=(mergeCloseIntervals(intervalSet(Range(Ripples)-2.05*1e4,Range(Ripples)-1.8*1e4),0.5*1e4)-StimEpochToRemove)-Epoch_Template.PostRipples;
    
    EpochNames_Template = fieldnames(Epoch_Template);
    EpochNames_Match = fieldnames(Epoch_Match);
    
    clear templates correlations eigenvalues eigenvectors lambdaMax DatPoints GlobalCorr
    for k = 1:length(EpochNames_Template)
        QTemplate = Restrict(Q,Epoch_Template.(EpochNames_Template{k}));
        % z-score the template epoch
        QTemplate = tsd(Range(QTemplate),nanzscore(Data(QTemplate)));
        dat = Data(QTemplate);
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for spk = 1:length(BadGuys)
            dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
        end
        DatPoints.(EpochNames_Template{k}) = size(dat,1);
        [templates.(EpochNames_Template{k}),correlations.(EpochNames_Template{k}),eigenvalues.(EpochNames_Template{k}),eigenvectors.(EpochNames_Template{k}),lambdaMax.(EpochNames_Template{k})] = ActivityTemplates_SB(dat,0);
    end
    
    QMatch = tsd(Range(Q),nanzscore(Data(Q)));
    
    %% Get the reactivation strength
    
    for temp = 1:length(EpochNames_Template)
        for match = 1:length(EpochNames_Match)
            
%             QMatch = tsd(Range(Restrict(Q,Epoch_Match.(EpochNames_Match{match}))),nanzscore(Data(Restrict(Q,Epoch_Match.(EpochNames_Match{match})))));
            BadGuys = find(sum(isnan(Data(QMatch))));
            for spk = 1:length(BadGuys)
                dat(:,BadGuys(spk)) = zeros(size(dat,1),1);
            end
                        dat = Data(Restrict(QMatch,Epoch_Match.(EpochNames_Match{match})));

            strength = ReactivationStrength_SB(dat,templates.(EpochNames_Template{temp}));
            
            MnStrength{mm}{temp,match}(:) = nanmean(strength,1);
            
            
            
        end
    end
end


for temp = 1:length(EpochNames_Template)
    for match = 1:length(EpochNames_Match)
        AllReact{temp}{match} = [];
        
        for mm = 1:length(MnStrength)
                    AllReact{temp}{match} = [AllReact{temp}{match},MnStrength{mm}{temp,match}];

        end
        
    end
end

A{1} = AllReact{1}{1} ;
A{2} = AllReact{1}{2} ;
A{3} = AllReact{2}{1} ;
A{4} = AllReact{2}{2} ;
