clear all
%% Trigger on stim
SortByEigVal = 1;
Binsize = 0.1*1e4;
MiceNumber=[490,507,508,509,510,512,514];
num = 1;
cd /home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples
clear SaveTriggeredStim SaveTriggeredStimZ EigVal SaveTriggeredStimShuff SaveTriggeredStimZShuff

figure
for mm=1:length(MiceNumber)
    clear eigenvalues Spikes StimEpoch Ripples StimEpoch templates
    load(['/home/gruffalo/Dropbox/Mobs_member/SophieBagur/Figures/phD/ReactivationRipples/UsefulInfo_RippleReact_M',num2str(mm),'.mat'])
    
    Q = MakeQfromS(Spikes,Binsize);
    Q = tsd(Range(Q),nanzscore(Data(Q)));
    
    % Template
    TemplateEpoch= intervalSet(Range(Ripples)-0.2*1E4,Range(Ripples)+0.2*1e4);
    TemplateEpoch = mergeCloseIntervals(TemplateEpoch,0.2*1e4);
    QTemplate = Restrict(Q,TemplateEpoch);
    
    dat = Data(QTemplate);
    BadGuys = find(sum(isnan(Data(QTemplate))));
    for i = 1:length(BadGuys)
        dat(:,BadGuys(i)) = zeros(size(dat,1),1);
    end
    [templates,correlations,eigenvalues,eigenvectors,lambdaMax] = ActivityTemplates_SB(zscore(dat),1);
    
    
    % Shuffle cell identity
    Qdat =  Data(Q);
    for tps = 1:length(Qdat)
        Qdat(tps,:) = Qdat(tps,randperm(size(Qdat,2)));
    end
    QShuff = tsd(Range(Q),Qdat);
    
    strength = ReactivationStrength_SB((Data(Q)),templates);
    strengthShuff = ReactivationStrength_SB((Data(QShuff)),templates);
    
    
    for comp = 1:size(strength,2)
        if eigenvalues(comp)/lambdaMax>1
            
            % trigger react stregnth on stims
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
            
           try, % Trigger on Ripples
            [M,T] = PlotRipRaw(Strtsd,Range(Ripples,'s'),2000,0,0);
            SaveTriggeredRip(num,:) = M(:,2);
            SaveTriggeredRipZ(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            [M,T] = PlotRipRaw(StrtsdShuff,Range(Ripples,'s'),2000,0,0);
            SaveTriggeredRipShuff(num,:) = M(:,2);
            SaveTriggeredRipZShuff(num,:) = ZScoreWiWindowSB(M(:,2)',[1:floor(length(M(:,2))/2)-2])';
            tpsrip = M(:,1);
           end
           
            MouseId(num) = mm;
            num = num+1;
            
        end
    end
    
    
    
end


figure
errorbar(tpsrip,nanmean(SaveTriggeredRipZ),stdError(SaveTriggeredRipZ))
hold on
errorbar(tpsrip,nanmean(SaveTriggeredRipZShuff),stdError(SaveTriggeredRipZShuff))

figure
errorbar(tpsstim,nanmean(SaveTriggeredStimZ),stdError(SaveTriggeredStimZ))
hold on
errorbar(tpsstim,nanmean(SaveTriggeredStimZShuff),stdError(SaveTriggeredStimZShuff))


