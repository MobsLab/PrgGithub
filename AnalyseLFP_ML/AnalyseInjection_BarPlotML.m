function AnalyseInjection_BarPlotML(NameDrug,NameStructure,NameEpoch,option,FreqBand,SaveFig,NumF)

% AnalyseInjection_BarPlotML(NameDrug,NameStructure,NameEpoch,option,FreqBand,SaveFig,NumF)

%% initialization

ANALYNAME=['AnalyseInjection',NameDrug,'/Analyse',NameDrug,'_',NameStructure,option,'_',NameEpoch];

load([ANALYNAME,'.mat'])
try
    AllSpectro{1}(1); AllGroup{1}(1); Start(AllEpochs{1,1});
    if ~exist('freqfi','var'), freqfi=fi; save([res,'/',ANALYNAME,'.mat'],'-append','freqfi');end
catch
    error(['Run AnalyseInjectionML(',NameDrug,',',NameStructure,',',NameEpoch,',',option,') first!'])
end
Strains=unique(Dir.group);
MiceNames=unique(Dir.name);
pval=0.05;

%% restrain Spectro to Freq band

if length(FreqBand)==2 && FreqBand(1)<FreqBand(2)
    for inj=1:length(InjName)
        temp=AllSpectro{inj};
        index=find(freqfi>FreqBand(1) & freqfi<FreqBand(2));
        RestrictAllSpectro{inj}=mean(temp(:,index),2);
    end
else
    error('Invalid input FreqBand')
end



%% bar plot
try
    BarStd=[];
    BarLine=[];
    AnovFactor_Strains=[];
    AnovFactor_Injection=[];
    AnovData=[];
    
    fact_errorbar=-0.15:0.3/(length(Strains)-1):0.15;
    
    for inj=1:length(InjName)
        for gg=1:length(Strains)
            
            index_temp=find(AllGroup{inj}(:,1)==gg);
            Bartemp(inj,gg)=nanmean(RestrictAllSpectro{inj}(index_temp,1));
            BartempStd(inj,gg)=stdError(RestrictAllSpectro{inj}(index_temp,1));
            position_errorbar((inj-1)*length(Strains)+gg)=inj+fact_errorbar(gg);
            
            AnovData=[AnovData;RestrictAllSpectro{inj}(index_temp,1)];
            AnovFactor_Strains=[AnovFactor_Strains;zeros(length(index_temp),1)+gg];
            AnovFactor_Injection=[AnovFactor_Injection;zeros(length(index_temp),1)+inj];
            legend_strains{gg}=[Strains{gg},' (n=',num2str(length(index_temp)),')'];
        end
        BarStd=[BarStd,BartempStd(inj,:)];
        BarLine=[BarLine,Bartemp(inj,:)];
    end
catch
    keyboard
end
%% display
try
    if ~exist('NumF','var')
        figure('color',[1 1 1]), NumF=gcf;
        if ~SaveFig, disp('Figures will not been saved');end
    else
        SaveFig=0;
    end
    bar(Bartemp)
    legend(legend_strains)
    hold on, errorbar(position_errorbar,BarLine,BarStd,'+','color','k')
    set(gca,'xtick',[1:length(InjName)]);
    set(gca,'xticklabel',InjName);
    
    ylabel(['Spectrum power ',num2str(FreqBand(1)),'-',num2str(FreqBand(2)),'Hz']);
catch
    keyboard
end

%% stats

% ttest for each injection period

if length(Strains)==2
    for inj=1:length(InjName)
        Temp1 = AnovData(AnovFactor_Injection==inj & AnovFactor_Strains==1);
        Temp2 = AnovData(AnovFactor_Injection==inj & AnovFactor_Strains==2);
        p = ranksum(Temp1,Temp2);
        if p<pval
            text(inj,1.1*max(nanmean(Temp1),nanmean(Temp2)),['p=',num2str(floor(1000*p)/1000)],'Color','r')
        else
            text(inj,1.1*max(nanmean(Temp1),nanmean(Temp2)),['p=',num2str(floor(1000*p)/1000)])
        end
    end
    ylabel(['Spectrum power ',num2str(FreqBand(1)),'-',num2str(FreqBand(2)),'Hz    (p, ranksum)']);
end

try
    if length(InjName)>1 && length(Strains)>1
        [p,table] = anovan(AnovData,{AnovFactor_Strains AnovFactor_Injection},'model','full');
        title({['strains: p=',num2str(floor(1E4*p(1))/1E4),'; Injection: p=',num2str(floor(1E4*p(2))/1E4)],['ANOVA Interaction p=',num2str(floor(1E4*p(3))/1E4)]});
    elseif length(InjName)>1 && length(Strains)<2
        [p,table] = anovan(AnovData,{AnovFactor_Injection});
        title(['ANOVA Injection: p=',num2str(floor(1E4*p(1))/1E4)]);
    elseif length(InjName)<2 && length(Strains)>1
        [p,table] = anovan(AnovData,{AnovFactor_Strains});
        title(['ANOVA strains: p=',num2str(floor(1E4*p(1))/1E4)]);
    end
catch
    disp('problem stats');keyboard
end

%%

if SaveFig
    nameFolderSave=['AnalyseInjection',NameDrug,'/Figures',NameStructure,option,'_',NameEpoch];
    saveFigure(NumF,['strainsXinjections_',NameDrug,'_',num2str(round(FreqBand(1))),'-',num2str(round(FreqBand(2))),'Hz'],nameFolderSave)
end


