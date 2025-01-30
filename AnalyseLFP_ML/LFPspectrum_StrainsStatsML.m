function [numF2,MatrixTitles,MatrixData,AllSpectrum]=LFPspectrum_StrainsStatsML(NameDir,nameStructure,nameEpoch,FilterFrequencies,removeNoisyEpochs,FolderToSaveFigure)

% function LFPspectrum_StrainsStatsML
%
% inputs:
% - NameDir = name of path (see PathForExperimentsML.m)
% - nameStructure = brain structure to analyse (see makeDataBulb.m)
% - nameEpoch = epoch name in StateEpoch (see sleepscoringML.m)
% - FilterFrequencies = frequency to restrain spectrum to
%
% outputs:
% - numF = number gcf of figure
% - MatrixTitles = name of parameters
% - MatrixData = Matrix of parameter means for each experiment in Dir
% - AllSpectrum = Spectrum for each experiment in Dir
%
% !!! Papier Lisa !!!
% numF=LFPspectrum_StrainsStatsML('BASAL',{'Bulb' 'BO'},'MovEpoch',[2 4]);

MatrixTitles={'MaxAmplitude' 'Frequency' 'Strain' 'MouseName'};

%% initialization
res=pwd;

if exist('NameDir','var')==0 || exist('nameStructure','var')==0 || exist('nameEpoch','var')==0 || exist('FilterFrequencies','var')==0
    error('Not enough input arguments')
end

if exist('removeNoisyEpochs','var')==0
    removeNoisyEpochs=1;
end

if exist('FolderToSaveFigure','var')==0
    FolderToSaveFigure=res;
end

if length(nameStructure)>1
    StructName=nameStructure{1};
    StructNickName=nameStructure{2};
else
    StructName=nameStructure;
    StructNickName=nameStructure;
end

colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};
scrsz = get(0,'ScreenSize');
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF=gcf;
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF2=gcf;
%% params

params.Fs=1250; params.trialave=0;
params.err=[1 0.0500]; params.pad=2;
params.fpass=[0 20];
movingwin=[3 0.2]; params.tapers=[3 5];


%% strains and mice name
Dir=PathForExperimentsML(NameDir);
strains=unique(Dir.group);

for gg=1:length(strains)
    numSt(gg)=0;
    legendL{gg}=[];
end
miceNames=unique(Dir.name);


%% load spectrograms for all experiments in Dir

MatrixData=[];
AllSpectrum_temp=[];
for man=1:length(Dir.path)
    
    clear MovEpoch  SWSEpoch REMEpoch NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch listLFP
    clear LFP info UniqueChannelBO Sptemp Spi ti fi info temp_meanSp
    
    nameMan=Dir.path{man}(strfind(Dir.path{man},'BULB'):strfind(Dir.path{man},'BULB')+21);
    FileToSave=[res,'/',nameMan,'.mat'];
    disp(['* * * ',nameMan,' * * *'])
    
    % load asked epoch
    load([Dir.path{man},'/StateEpoch.mat'],nameEpoch,'NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch')
    if removeNoisyEpochs
        eval(['epoch=',nameEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
    else
        disp('problem NoiseEpochs')
        eval(['epoch=',nameEpoch,';'])
    end
    
    load([Dir.path{man},'/listLFP.mat'],'listLFP')
    
    if sum(strcmp(listLFP.name,StructName))~=0
        
        
        try
            load(FileToSave,['UniqueChannel',StructNickName]);
            eval(['channelToAnalyse=UniqueChannel',StructNickName,';'])
            
            % load spectrogram
            load(FileToSave,['Sp',StructNickName,num2str(channelToAnalyse)])
            eval(['Sptemp=Sp',StructNickName,num2str(channelToAnalyse),';'])
            Spi=Dir.CorrecAmpli(man)*Sptemp{1}; ti=Sptemp{2}; fi=Sptemp{3};
            
        catch
            keyboard
            disp(['Sp',StructNickName,num2str(channelToAnalyse),' not found... '])
            load([Dir.path{man},'/LFP',StructName,'.mat'],'LFP','info')
            [Spi,ti,fi]=ComputeSpectrogramML(LFP,movingwin,params,FileToSave,nameStructure,info);
        end
        
        [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,fi,epoch);
        
        
        % save restricted spectrum for each experiment 
        
        RestrictIndex=find(fi>FilterFrequencies(1) & fi<FilterFrequencies(2));
        RestrictFreq=fi(RestrictIndex);
        AllSpectrum_temp(man,:)=mean(SpEpoch(:,RestrictIndex),1);
%         temp_meanSp=mean(SpEpoch(:,RestrictIndex),1).*RestrictFreq;
        temp_meanSp=mean(SpEpoch(:,RestrictIndex),1);
        
        % ------------------------------------------------
        % ---------- display filtered spectrum ----------
        gg=find(strcmp(Dir.group{man},strains));
        numSt(gg)=numSt(gg)+1;
        
        figure(numF),
        subplot(2,length(strains)+1,gg),
        hold on, plot(RestrictFreq,AllSpectrum_temp(man,:),[colori{numSt(gg)},typo{numSt(gg)}],'linewidth',2)
        xlim([0 10]); ylim([0 3E6]); ylabel('Power ');
        title([strains{gg},' - ',nameEpoch,'  [',num2str(FilterFrequencies),']Hz'])
        
        subplot(2,length(strains)+1,length(strains)+1+gg),
        hold on, plot(RestrictFreq,temp_meanSp,[colori{numSt(gg)},typo{numSt(gg)}],'linewidth',2)
        xlim([0 10]); ylim([0 8E6]);ylabel('Power (normalized by 1/f');
        title([strains{gg},' - ',nameEpoch,' [',num2str(FilterFrequencies),']Hz'])
        
        legendL{gg}=[legendL{gg},{[Dir.group{man},'-',Dir.path{man}(min(strfind(Dir.path{man},'Mouse'))+6:min(strfind(Dir.path{man},'Mouse'))+7),' ch',num2str(channelToAnalyse)]}];
        legend(legendL{gg});
        % ------------------------------------------------
%         keyboard
%         if temp_meanSp(1)~=max(temp_meanSp);
            
%             MatrixData(man,:)=[max(temp_meanSp),RestrictFreq(find(temp_meanSp==max(temp_meanSp))),gg,find(strcmp(Dir.name{man},miceNames))];
            
            dth = diff(temp_meanSp)';
            dth1 = [0 dth'];
            dth2 = [dth' 0];
            clear dth;
            t = RestrictFreq;
            thpeaks = t(find (dth1 > 0 & dth2 < 0));
            
            if length(thpeaks)==1
            MatrixData(man,:)=[max(temp_meanSp),thpeaks,gg,find(strcmp(Dir.name{man},miceNames))];
            else
            MatrixData(man,:)=[max(temp_meanSp),nan,gg,find(strcmp(Dir.name{man},miceNames))];    
            end
            
%         end
        
        % 'MaxAmplitude' 'Frequency' 'Strain' 'MouseName'
    else
        disp(['No LFP ',StructName,' found'])
    end
end



%% Identify mice and strains group

for gg=1:length(strains)
    MaxAmplitude{gg}=[];
    FreqMaxAmp{gg}=[];
end

% pool experiments from the same mice

AllSpectrum=nan(length(miceNames),size(AllSpectrum_temp,2));
AllSpectrumGroup=2*ones(length(miceNames),1);

for uu=1:length(miceNames)
    
    clear TempMat TempFreq TempAmp
    
    TempMat=MatrixData(find(MatrixData(:,4)==uu),:);
    
    AllSpectrum(uu,:)=nanmean(AllSpectrum_temp(find(MatrixData(:,4)==uu),:),1);
    AllSpectrumGroup(uu)=unique(MatrixData(find(MatrixData(:,4)==uu),3));
    
    if isempty(TempMat)==0
        TempAmp=MaxAmplitude{unique(TempMat(:,3))};
        TempFreq=FreqMaxAmp{unique(TempMat(:,3))};
        
        MaxAmplitude{unique(TempMat(:,3))}=[TempAmp,nanmean(TempMat(:,1))];
        FreqMaxAmp{unique(TempMat(:,3))}=[TempFreq,nanmean(TempMat(:,2))];
    end
end


% ------------------------------------------------
% ---------- display filtered spectrum ----------
figure(numF),
for gg=1:length(strains)
    subplot(2,length(strains)+1,length(strains)+1),
    hold on, plot(RestrictFreq,nanmean(AllSpectrum(AllSpectrumGroup==gg,:),1),'Color',colori{gg},'Linewidth',2)
end
legend(strains)
for gg=1:length(strains)
    subplot(2,length(strains)+1,length(strains)+1),
    hold on, plot(RestrictFreq,nanmean(AllSpectrum(AllSpectrumGroup==gg,:),1)+stdError(AllSpectrum(AllSpectrumGroup==gg,:)),'Color',colori{gg})
    hold on, plot(RestrictFreq,nanmean(AllSpectrum(AllSpectrumGroup==gg,:),1)-stdError(AllSpectrum(AllSpectrumGroup==gg,:)),'Color',colori{gg})
    xlim([0 10]); ylim([0 3E6]);
end


% ------------------------------------------------


%% display final figure

figure(numF2),
% ------------------------------
% -------- FreqMaxAmp ----------
subplot(1,3,1)
bar([nanmean(FreqMaxAmp{1}) nanmean(FreqMaxAmp{2})]);

l=length([nanmean(FreqMaxAmp{1}) nanmean(FreqMaxAmp{2})]);
set(gca,'xtick',1:l); xlim([0 l+1])
set(gca,'xticklabel',[{[strains{1},' (n=',num2str(sum(~isnan(FreqMaxAmp{1}))),')']} {[strains{2},' (n=',num2str(sum(~isnan(FreqMaxAmp{2}))),')']}])

text(1,1.06*nanmean(FreqMaxAmp{1}),[num2str(floor(100*nanmean(FreqMaxAmp{1}))/100),'+/-',num2str(floor(100*nanstd(FreqMaxAmp{1}))/100)]);
text(2,1.06*nanmean(FreqMaxAmp{2}),[num2str(floor(100*nanmean(FreqMaxAmp{2}))/100),'+/-',num2str(floor(100*nanstd(FreqMaxAmp{2}))/100)]);

ylabel('Frequency (Hz)'); 
title('Frequency of spectrum peak') 

try hold on, errorbar(1:2,[nanmean(FreqMaxAmp{1}),nanmean(FreqMaxAmp{2})],[stdError(FreqMaxAmp{1}),stdError(FreqMaxAmp{2})],'+','color','k');end
%[H,p_Freq]=ttest2(FreqMaxAmp{1},FreqMaxAmp{2});
[p_Freq,H]=ranksum(FreqMaxAmp{1}(~isnan(FreqMaxAmp{1})),FreqMaxAmp{2}(~isnan(FreqMaxAmp{2})));
text(1.2,max(nanmean(FreqMaxAmp{1}),nanmean(FreqMaxAmp{2}))*1.15,['p=',num2str(floor(1E4*p_Freq)/1E4)],'Color','r');
ylim([0 max(nanmean(FreqMaxAmp{1}),nanmean(FreqMaxAmp{2}))*1.2])



% ------------------------------
% -------- MaxAmplitude --------
subplot(1,3,2),
bar([nanmean(MaxAmplitude{1}),nanmean(MaxAmplitude{2})]);

l=length([nanmean(MaxAmplitude{1}),nanmean(MaxAmplitude{2})]);
set(gca,'xtick',1:l); xlim([0 l+1])
set(gca,'xticklabel',[{[strains{1},' (n=',num2str(sum(~isnan(MaxAmplitude{1}))),')']} {[strains{2},' (n=',num2str(sum(~isnan(MaxAmplitude{2}))),')']}])

text(1,1.06*nanmean(MaxAmplitude{1}),[num2str(floor(nanmean(MaxAmplitude{1}))),'+/-',num2str(floor(nanstd(MaxAmplitude{1})))]);
text(2,1.06*nanmean(MaxAmplitude{2}),[num2str(floor(nanmean(MaxAmplitude{2}))),'+/-',num2str(floor(nanstd(MaxAmplitude{2})))]);

ylabel('Amplitude'); 
title('Power spectrum at individual peak');

try hold on, errorbar(1:2,[nanmean(MaxAmplitude{1}),nanmean(MaxAmplitude{2})],[stdError(MaxAmplitude{1}),stdError(MaxAmplitude{2})],'+','color','k');end
%[H,p_MaxAmp]=ttest2(MaxAmplitude{1},MaxAmplitude{2});
[p_MaxAmp,H]=ranksum(MaxAmplitude{1}(~isnan(MaxAmplitude{1})),MaxAmplitude{2}(~isnan(MaxAmplitude{2})));
text(1.2,max(nanmean(MaxAmplitude{1}),nanmean(MaxAmplitude{2}))*1.15,['p=',num2str(floor(1E4*p_MaxAmp)/1E4)],'Color','r');
ylim([0 max(nanmean(MaxAmplitude{1}),nanmean(MaxAmplitude{2}))*1.2])

% ------------------------------
% -------- Amp at mean FreqMax ----------
FreqMax_all=nanmean([FreqMaxAmp{strcmp(strains,'WT')}]);
[H,index_FmaxAll]=min(abs(1-RestrictFreq/FreqMax_all));
for gg=1:length(strains)
    AmpMeanFreq{gg}=AllSpectrum(find(AllSpectrumGroup==gg),index_FmaxAll);
end

subplot(1,3,3)
bar([nanmean(AmpMeanFreq{1}) nanmean(AmpMeanFreq{2})]);

l=length([nanmean(AmpMeanFreq{1}) nanmean(AmpMeanFreq{2})]);
set(gca,'xtick',1:l); xlim([0 l+1])
set(gca,'xticklabel',[{[strains{1},' (n=',num2str(sum(~isnan(AmpMeanFreq{1}))),')']} {[strains{2},' (n=',num2str(sum(~isnan(AmpMeanFreq{2}))),')']}])

text(1,1.06*nanmean(AmpMeanFreq{1}),[num2str(floor(nanmean(AmpMeanFreq{1}))),'+/-',num2str(floor(nanstd(AmpMeanFreq{1})))]);
text(2,1.06*nanmean(AmpMeanFreq{2}),[num2str(floor(nanmean(AmpMeanFreq{2}))),'+/-',num2str(floor(nanstd(AmpMeanFreq{2})))]);

ylabel('Amplitude'); 
title(['Power spectrum at WT max Frequency (',num2str(floor(FreqMax_all*100)/100),'Hz)']) 

try hold on, errorbar(1:2,[nanmean(AmpMeanFreq{1}),nanmean(AmpMeanFreq{2})],[stdError(AmpMeanFreq{1}),stdError(AmpMeanFreq{2})],'+','color','k');end
%[H,p_AmpFmaxAll]=ttest2(AmpMeanFreq{1},AmpMeanFreq{2});
[p_AmpFmaxAll,H]=ranksum(AmpMeanFreq{1}(~isnan(AmpMeanFreq{1})),AmpMeanFreq{2}(~isnan(AmpMeanFreq{2})));
text(1.2,max(nanmean(AmpMeanFreq{1}),nanmean(AmpMeanFreq{2}))*1.15,['p=',num2str(floor(1E4*p_AmpFmaxAll)/1E4)],'Color','r');
ylim([0 max(nanmean(AmpMeanFreq{1}),nanmean(AmpMeanFreq{2}))*1.2])

keyboard
%% save figures
saveFigure(numF,'ChosenChannels_MeanFilteredSpectrum_StrainEffect',FolderToSaveFigure);
saveFigure(numF2,'BILAN_MeanFilteredSpectrum_StrainEffect',FolderToSaveFigure);


