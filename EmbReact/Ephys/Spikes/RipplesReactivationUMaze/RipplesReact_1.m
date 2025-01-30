clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.07*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff

for mm=1:length(MiceNumber)
    if mm ~=5 & mm~=6 % exclude 510 and 512, no ripples
        clear eigenvalues Spikes StimEpoch Ripples StimEpoch templates
        load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
        
        % Bin the spikes
        Q = MakeQfromS(Spikes,Binsize);
        Q = tsd(Range(Q),nanzscore(Data(Q)));
        
        % Template = 5s arouns the shock
        TemplateEpoch =  intervalSet(Start(StimEpoch)+0.3*1e4,Start(StimEpoch)+2.5*1e4);
        
%        TemplateEpoch1 =  intervalSet(Start(StimEpoch)+0.1*1e4-3*1e4,Start(StimEpoch)+2.5*1e4-3*1e4);
%         TemplateEpoch2 =  intervalSet(Start(StimEpoch)-15*1e4,Start(StimEpoch)-5*1e4);
%         TemplateEpoch = TemplateEpoch2-TemplateEpoch1;
        
        QTemplate = Restrict(Q,TemplateEpoch);
        
        % Clean up the template by getting rid of neurons with nans
        dat = Data(QTemplate);
        BadGuys = find(sum(isnan(Data(QTemplate))));
        for i = 1:length(BadGuys)
            dat(:,BadGuys(i)) = zeros(size(dat,1),1);
        end
        
        % PCA on data
        [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB((dat),1);
        
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
        
        
        % Make sure all ripples are at least 1s a part (to get nice peak)
        RipplesEp = intervalSet(Range(Ripples),Range(Ripples)+1*1E4);
        RipplesEpMerge = mergeCloseIntervals(RipplesEp,1*1E4);
        RipplesClean = ts(Start(RipplesEpMerge));
        
        for comp = 1:size(strength,2)
            if eigenvalues(comp)/lambdaMax>1
                
                % make tsd from projections
                Strtsd = tsd(Range(Q),strength(:,comp).*(strength(:,comp)>prctile(strength(:,comp),99)));
                StrtsdShuff = tsd(Range(QShuff),strengthShuff(:,comp).*(strengthShuff(:,comp)>prctile(strengthShuff(:,comp),99)));
                
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
        
    end
end

figure
errorbar(tpsrip,runmean(nanmean(abs(SaveTriggeredRipZ)),1),stdError(SaveTriggeredRipZ))
hold on
errorbar(tpsrip,runmean(nanmean(abs(SaveTriggeredRipZShuff)),1),stdError(SaveTriggeredRipZShuff))

% figure
% errorbar(tpsstim,nanmean(SaveTriggeredStimZ),stdError(SaveTriggeredStimZ))
% hold on
% errorbar(tpsstim,nanmean(SaveTriggeredStimZShuff),stdError(SaveTriggeredStimZShuff))
%

