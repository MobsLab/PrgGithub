function [numF,MatrixData,MatrixDatainfo,MatrixDataNames]=PlotBilanRespiML(NameDir,PlotSingleExperiment,Freq,FolderToSaveFigure)

% function PlotBilanRespiML
%
% inputs:
% - NameDir = (see PathForExperimentsML.m)
% - PlotSingleExperiment (optional) = 1 if display for every single experiment, or 0 
% - Freq (optional) = [2,5 ; 6,10] to calculate parameters between 2-5Hz and 6-10Hz
%
% outputs:
% - numF = number of figure
% - MatrixData = for all mice, mean of parameters (see MatrixDataNames var)
% - MatrixDatainfo = for all mice, strain.
% - MatrixDataNames = names of parameters in MatrixData
%
% !!! Papier Lisa !!!
% numF=PlotBilanRespiML('PLETHYSMO',1); % choose MovEpoch
 

%% Verifications of inputs

if exist('NameDir','var')==0
    error('Not enough input arguments')
end

if exist('PlotSingleExperiment','var')==0
    PlotSingleExperiment=0;
end

%InspirationTimes=Range(TidalVolume);

if exist('Freq','var')==0 || isequal(size(Freq),[2,2])==0
    FreqInf=[2 5];
    FreqSup=[6 10];
    disp(['Using default frequencies: ',num2str(FreqInf),'Hz and ',num2str(FreqSup),'Hz.'])
else
    FreqInf=Freq(1,:);
    FreqSup=Freq(2,:);
end

choice = questdlg('Choose Epoch:', 'State Epoch','Wake','SWS','REM','Wake');
switch choice
    case 'Wake'
        nameStateEpoch='MovEpoch';        
    case 'SWS'
        nameStateEpoch='SWSEpoch';        
    case 'REM'
        nameStateEpoch='REMEpoch'; 
end
%% initialisation variables

% load paths of experiments
Dir=PathForExperimentsML(NameDir);
strains=unique(Dir.group);
MiceNames=unique(Dir.name);


% TV=tidal volume
namePlots={'Tidal Volume (mL)','Respiration Frequency (Hz)','Inspiration flux (mL/s)','% Respi in each freq range'};
MatrixDataNames={'meanTV' 'meanTV2-5Hz' 'meanTV6-10Hz' 'meanF' 'meanF2-5Hz' 'meanF6-10Hz' 'meanRespi' 'meanRespi2-5Hz' 'meanRespi6-10Hz' '%2-5Hz' '%6-10Hz'};
MatrixData=nan(length(Dir.path),length(MatrixDataNames));

% initiate display parameters
colori={'b','r','k','g','c','m','b','r','k','g','c','m','b','r','k','g','c','m'};
typo={ '-','-','-','-','-','-','--','--','--','--','--','--','-.','-.','-.','-.','-.','-.'};
scrsz = get(0,'ScreenSize');

%% compute mean TidalVolume and Mean frequency for all experiments
for man=1:length(Dir.path)
    disp(' ');disp(['  * * ',Dir.path{man},' * *'])
    MatrixDataInfo(man,:)={Dir.group{man},Dir.name{man}(strfind(Dir.name{man},'Mouse')+6:end)};
    
    disp('... Loading Respi Info')
    % ---------------------------------------------------------------------
    % load respi info
    clear  TidalVolume Frequency RespiTSD indexInf indexSup
    load([Dir.path{man},'/LFPData.mat'],'TidalVolume','Frequency','RespiTSD')
    
    
    % ---------------------------------------------------------------------
    % load epoch
    disp(['... Loading Epochs: analyzing ',nameStateEpoch])
    clear MovEpoch NoiseEpoch GndNoiseEpoch WeirdEpoch epoch
    load([Dir.path{man},'/StateEpoch.mat'],'MovEpoch','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch','SWSEpoch','REMEpoch')
    %epoch=MovEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;
    eval(['epoch=',nameStateEpoch,'-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;'])
    
    % ---------------------------------------------------------------------
    % construct vectors of each parameters
    clear DataTV DataFrequency RangeFrequency DataRespi
    
    DataTV=Data(Restrict(TidalVolume,epoch));
    DataFrequency=Data(Restrict(Frequency,epoch));
    RangeFrequency=Range(Restrict(Frequency,epoch));
    
    disp('... Calculating Freq Dependent Respi')
    DataRespi=nan(length(DataFrequency)-1,1);
    for i=1:length(RangeFrequency)-1
        clear I
        I=intervalSet(RangeFrequency(i),RangeFrequency(i+1));
        DataRespi(i)=abs(min(Data(Restrict(RespiTSD,I))));
    end
    disp('Done')
    
    % ---------------------------------------------------------------------
    % calculate mean of respi parameters for each experiment
    indexInf=find(DataFrequency>FreqInf(1) & DataFrequency<FreqInf(2));
    indexSup=find(DataFrequency>FreqSup(1) & DataFrequency<FreqSup(2));
    
    MatrixData(man,1:3)=[mean(DataTV),mean(DataTV(indexInf)),mean(DataTV(indexSup))];
    MatrixData(man,4:6)=[mean(DataFrequency),mean(DataFrequency(indexInf)),mean(DataFrequency(indexSup))];
    MatrixData(man,7:9)=[mean(DataRespi),mean(DataRespi(indexInf(1:length(indexInf)-1))),mean(DataRespi(indexSup(1:length(indexSup)-1)))];
    MatrixData(man,10:11)=100*[length(indexInf) length(indexSup)]./length(DataFrequency);

end


%% plot data for each experiment if needed

if PlotSingleExperiment
    figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF2=gcf;
    
    for ii=1:length(MatrixDataNames)
        
        subplot(ceil(length(MatrixDataNames)/3),3,ii)
        
        hold on, bar(MatrixData(:,ii));
        title([nameStateEpoch,'-',MatrixDataNames{ii}])
        set(gca,'xtick',1:length(MatrixData(:,ii))+1); 
        xlim([0.5 length(MatrixData(:,ii))+0.5])
        set(gca,'xticklabel',MatrixDataInfo(:,2)')
    end
    
end

%% pool data from same mice

MatrixData_temp=[];MatrixDatainfo_temp=[];
for uu=1:length(MiceNames)
    index=find(strcmp(MatrixDataInfo(:,2),MiceNames{uu}(strfind(MiceNames{uu},'Mouse')+6:end)));
    if sum(isnan(nanmean(MatrixData(index,:),1)))~=size(MatrixData,2)
        MatrixData_temp=[MatrixData_temp;nanmean(MatrixData(index,:),1)];
        MatrixDatainfo_temp=[MatrixDatainfo_temp,unique(MatrixDataInfo(index,1))];
    end
    clear index
end

MatrixDatainfo=MatrixDatainfo_temp;
MatrixData=MatrixData_temp;


%% display difference between strains

BarPlotStrains_mean=[];
BarPlotStrains_std=[];
BarPlotStrains_legend=[];
for ss=1:length(strains)
    gg=find(strcmp(MatrixDatainfo,strains(ss)));
    BarPlotStrains_mean=[BarPlotStrains_mean;nanmean(MatrixData(gg,:),1)];
    BarPlotStrains_std=[BarPlotStrains_std;stdError(MatrixData(gg,:))];
    BarPlotStrains_legend=[BarPlotStrains_legend;{[strains{ss},' (n=',num2str(length(gg)),')']}];
end
%[H,p]=ttest2(MatrixData(find(strcmp(MatrixDatainfo,strains(1))),:),MatrixData(find(strcmp(MatrixDatainfo,strains(2))),:));
p=nan(1,size(MatrixData,2));
for i=1:size(MatrixData,2)
    index1=find(strcmp(MatrixDatainfo,strains(1)) & ~isnan(MatrixData(:,i))');
    index2=find(strcmp(MatrixDatainfo,strains(2)) & ~isnan(MatrixData(:,i))');
    [p_temp,H]=ranksum(MatrixData(index1,i),MatrixData(index2,i));
    p(i)=p_temp;
end
figure('Color',[1 1 1],'Position',[2 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]), numF=gcf;

for i=1:4
    clear index
    subplot(1,4,i),
    if i==4
        index=10:11;
    else
        index=3*i-2:3*i;
    end
    bar(BarPlotStrains_mean(:,index)');
    set(gca,'xtick',1:length(BarPlotStrains_mean(:,index)))
    xlim([0 length(BarPlotStrains_mean(:,index))+1])
    set(gca,'xticklabel',MatrixDataNames(:,index))
    title([nameStateEpoch,' - ',namePlots{i}]);
    try 
        hold on, 
        temp_mean=BarPlotStrains_mean(:,index)';
        temp_std=BarPlotStrains_std(:,index)';
        errorbar([[1:length(temp_mean)]-0.15;[1:length(temp_mean)]+0.15]',temp_mean,temp_std,'+','color','k');
    end
    
    temp_ybarplot=max(BarPlotStrains_mean(:,index));
    for ii=1:length(index)
        text(ii-0.2,temp_ybarplot(ii)*1.2,['p=',num2str(floor(1E4*p(index(ii)))/1E4)],'Color','r');
    end
    ylim([0 max(temp_ybarplot)*1.2])
end
legend(BarPlotStrains_legend)

%% save figures

if exist('FolderToSaveFigure','var')
    saveFigure(numF,'BILAN_RespiParameters_StrainEffect',FolderToSaveFigure);
    saveFigure(numF2,'BILAN_RespiParameters_AllExperiments',FolderToSaveFigure);
else
    disp('Figures have not been saved');
end
keyboard