clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.07*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
Lims = [0:0.1:0.7;0.3:0.1:1];

for mm=1:length(MiceNumber)
    if mm ~=5 & mm~=6 % exclude 510 and 512, no ripples
        clear eigenvalues Spikes StimEpoch Ripples StimEpoch templates
        load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
        
        % Bin the spikes
        Q = MakeQfromS(Spikes,Binsize);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        clear dat
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples)-1e4,Range(Ripples)+1*1E4); % was 1
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        for ll = 1:size(Lims,2)
            
            TemplateEpoch =  thresholdIntervals(LinPos,Lims(1,ll),'Direction','Above');
            TemplateEpoch =  and(TemplateEpoch,thresholdIntervals(LinPos,Lims(2,ll),'Direction','Below'));
            TemplateEpoch = TemplateEpoch - RipplesEpMerge;
            QTemplate = Restrict(Q,TemplateEpoch);
            
            % Clean up the template by getting rid of neurons with nans
            dat{ll} = Data(QTemplate);
            BadGuys = find(sum(isnan(Data(QTemplate))));
            for i = 1:length(BadGuys)
                dat{ll}(:,BadGuys(i)) = zeros(size(dat,1),1);
            end
            LengthPerZone(mm,ll) = size(dat{ll},1);
            
        end
        
        %% Get same number of data points for each part
        CommonLength = min(LengthPerZone(mm,:));
        for ll = 1:size(Lims,2)
            dat{ll} = dat{ll}(randperm(size(dat{ll},1),CommonLength),:);
        end
        
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples),Range(Ripples)+1*1E4); % was 1
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        for ll = 1:size(Lims,2)
            
            % PCA on data
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB((dat{ll}),1);
            
            % Geterate data to match and the same data with shuffled cell identity at each timestep
            QMatch = Q;
            Qdat =  Data(QMatch);
            for tps = 1:length(Qdat)
                Qdat(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
            end
            QShuff = tsd(Range(QMatch),Qdat);
            
            % Project match + shuffled match onto templates
            strength = ReactivationStrength_SB((Data(QMatch)),templates);
            strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates);
            
            
            for comp = 1:size(strength,2)
                if eigenvalues(comp)/lambdaMax>1
                    
                    % make tsd from projections
                    Strtsd = tsd(Range(Q),strength(:,comp));
                    StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
                    
                    % Trigger on Stim
                    [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
                    SaveTriggeredStim(num,:) = M(:,2);
                    SaveTriggeredStimZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    
                    [M,T] = PlotRipRaw(StrtsdShuff,Start(StimEpoch,'s'),5000,0,0);
                    SaveTriggeredStimShuff(num,:) = M(:,2);
                    SaveTriggeredStimZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    tpsstim = M(:,1);
                    
                    % Trigger on Ripples
                    [M,T] = PlotRipRaw(Strtsd,Range(RipplesClean,'s'),1000,0,0);
                    SaveTriggeredRip(num,:) = M(:,2);
                    SaveTriggeredRipZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    [M,T] = PlotRipRaw(StrtsdShuff,Range(RipplesClean,'s'),1000,0,0);
                    SaveTriggeredRipShuff(num,:) = M(:,2);
                    SaveTriggeredRipZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    tpsrip = M(:,1);
                    
                    MouseId(num) = mm;
                    num = num+1;
                    
                end
            end
            
            TriggeredRipples(ll,:) = runmean(nanmean(SaveTriggeredRipZ),1);
            
        end
    end
end

% figure
% errorbar(tpsstim,nanmean(SaveTriggeredStimZ),stdError(SaveTriggeredStimZ))
% hold on
% errorbar(tpsstim,nanmean(SaveTriggeredStimZShuff),stdError(SaveTriggeredStimZShuff))
%





%% Template is ripples, look in space
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
Lims = [0:0.1:0.7;0.3:0.1:1];

figure
for mm=1:length(MiceNumber)
    if mm ~=5 & mm~=6 % exclude 510 and 512, no ripples
        clear eigenvalues Spikes StimEpoch Ripples StimEpoch templates
        load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
        
        Q = MakeQfromS(Spikes,Binsize);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        
        % Template
        TemplateEpoch= intervalSet(Range(Ripples)-0.2*1E4,Range(Ripples)+0.2*1e4);
        TemplateEpoch = mergeCloseIntervals(TemplateEpoch,0.2*1e4);
        QTemplate = Restrict(Q,TemplateEpoch);
        
        datrip = Data(QTemplate);
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for i = 1:length(BadGuys)
            datrip(:,BadGuys(i)) = zeros(size(datrip,1),1);
        end
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB((datrip),1);
        
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples)-1e4,Range(Ripples)+1*1E4); % was 1
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        
        for ll = 1:size(Lims,2)
            
            TemplateEpoch =  thresholdIntervals(LinPos,Lims(1,ll),'Direction','Above');
            TemplateEpoch =  and(TemplateEpoch,thresholdIntervals(LinPos,Lims(2,ll),'Direction','Below'));
            TemplateEpoch = TemplateEpoch - RipplesEpMerge;
            QTemplate = Restrict(Q,TemplateEpoch);
            
            % Clean up the template by getting rid of neurons with nans
            dat{ll} = Data(QTemplate);
            BadGuys = find(sum(isnan(Data(QTemplate))));
            for i = 1:length(BadGuys)
                dat{ll}(:,BadGuys(i)) = zeros(size(dat,1),1);
            end
            LengthPerZone(mm,ll) = size(dat{ll},1);
            
        end
        
        %% Get same number of data points for each part
        CommonLength = min(LengthPerZone(mm,:));
        for ll = 1:size(Lims,2)
            dat{ll} = dat{ll}(randperm(size(dat{ll},1),CommonLength),:);
        end
        
        
        for comp = 1:size(templates,2)
            if eigenvalues(comp)/lambdaMax>1
                for ll = 1:size(Lims,2)
                    strength = ReactivationStrength_SB(dat{ll},templates);
                    % make tsd from projections
                    ReactStr(num,ll) = nanmean(strength(:,comp));
                end
                num = num+1;
                
                
            end
        end
    end
end



%% Focus on freezing
clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.07*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff
Lims = [0,0.6;0.4,1];

for mm=1:length(MiceNumber)
    if mm ~=5 & mm~=6 % exclude 510 and 512, no ripples
        clear eigenvalues Spikes StimEpoch Ripples StimEpoch templates
        load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
        
        % Bin the spikes
        Q = MakeQfromS(Spikes,Binsize);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        clear dat
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples)-1e4,Range(Ripples)+1*1E4); % was 1
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        for ll = 1:size(Lims,2)
            
            TemplateEpoch =  thresholdIntervals(LinPos,Lims(1,ll),'Direction','Above');
            TemplateEpoch =  and(TemplateEpoch,thresholdIntervals(LinPos,Lims(2,ll),'Direction','Below'));
            TemplateEpoch = and(FreezeEpoch,TemplateEpoch - RipplesEpMerge);
            QTemplate = Restrict(Q,TemplateEpoch);
            
            % Clean up the template by getting rid of neurons with nans
            dat{ll} = Data(QTemplate);
            BadGuys = find(sum(isnan(Data(QTemplate))));
            for i = 1:length(BadGuys)
                dat{ll}(:,BadGuys(i)) = zeros(size(dat,1),1);
            end
            LengthPerZone(mm,ll) = size(dat{ll},1);
            
        end
        
        %% Get same number of data points for each part
        CommonLength = min(LengthPerZone(mm,:));
        for ll = 1:size(Lims,2)
            dat{ll} = dat{ll}(randperm(size(dat{ll},1),CommonLength),:);
        end
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples),Range(Ripples)+1*1E4); % was 1
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        for ll = 1:size(Lims,2)
            
            % PCA on data
            [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(zscore(dat{ll}),1);
            
            % Geterate data to match and the same data with shuffled cell identity at each timestep
            QMatch = Q;
            Qdat =  Data(QMatch);
            for tps = 1:length(Qdat)
                Qdat(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
            end
            QShuff = tsd(Range(QMatch),Qdat);
            
            % Project match + shuffled match onto templates
            strength = ReactivationStrength_SB((Data(QMatch)),templates);
            strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates);
            
            
            for comp = 1:size(strength,2)
                if eigenvalues(comp)/lambdaMax>1
                    
                    % make tsd from projections
                    Strtsd = tsd(Range(Q),strength(:,comp));
                    StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp));
                    
                    % Trigger on Stim
                    [M,T] = PlotRipRaw(Strtsd,Start(StimEpoch,'s'),5000,0,0);
                    SaveTriggeredStim(num,:) = M(:,2);
                    SaveTriggeredStimZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    
                    [M,T] = PlotRipRaw(StrtsdShuff,Start(StimEpoch,'s'),5000,0,0);
                    SaveTriggeredStimShuff(num,:) = M(:,2);
                    SaveTriggeredStimZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    tpsstim = M(:,1);
                    
                    % Trigger on Ripples
                    [M,T] = PlotRipRaw(Strtsd,Range(RipplesClean,'s'),1000,0,0);
                    SaveTriggeredRip(num,:) = M(:,2);
                    SaveTriggeredRipZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    [M,T] = PlotRipRaw(StrtsdShuff,Range(RipplesClean,'s'),1000,0,0);
                    SaveTriggeredRipShuff(num,:) = M(:,2);
                    SaveTriggeredRipZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
                    tpsrip = M(:,1);
                    
                    MouseId(num) = mm;
                    num = num+1;
                    
                end
            end
            
            TriggeredRipples(ll,:) = runmean(nanmean(SaveTriggeredRipZ),1);
            
        end
    end
end