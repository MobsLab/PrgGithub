% Zscore Spectrum

%clear all; close all 
res=pwd;
%% inputs to change
StateEpochs={'SWSEpoch'};
InjectionEpochs={'PreEpoch','VEHEpoch','DPCPXEpoch'};
% choose structure between 'Bulb' 'PFCx_sup' 'PFCx_deep' 'PaCx_sup' 'PaCx_deep'
structure='Bulb';

Dir=PathForExperimentsML('DPCPX');
plotZscore=0;
PlotNotZscore=0;
pval=0.01;
Strains=unique(Dir.group);
MiceNames=unique(Dir.name);



%% compute
MatrixSp=nan(length(Dir.path),262);
infoMatrixSp=nan(length(Dir.path),2);

for man=1:length(Dir.path)
    infoMatrixSp(man,:)=[find(strcmp(Dir.group{man},Strains)),find(strcmp(Dir.name{man},MiceNames))];
    cd(Dir.path{man})
    name=strfind(Dir.path{man},'Mouse');
    name=Dir.path{man}(name(end):end);
    clear temp
   
    clear PreEpoch VEHEpoch DPCPXEpoch
    load('behavResources.mat','VEHEpoch','PreEpoch','DPCPXEpoch')
    
    clear NoiseEpoch GndNoiseEpoch WeirdNoiseEpoch SWSEpoch REMEpoch MovEpoch
    load('StateEpoch.mat','NoiseEpoch','GndNoiseEpoch','WeirdNoiseEpoch','SWSEpoch','REMEpoch','MovEpoch')
    
    clear channelToAnalyse channel
    if strcmp(structure,'Bulb')
        load('SpectrumDataL/UniqueChannelBulb.mat')
        load(['SpectrumDataL/Spectrum',num2str(channelToAnalyse)])
    else
        load(['ChannelsToAnalyse/',structure,'.mat'])
        load(['SpectrumDataL/Spectrum',num2str(channel)])
    end
    Spi=Sp;
    ti=t;
    freqfi=f;
    
    % figure, subplot(1,5,1:4), imagesc(ti,freqfi,10*log10(Spi)'), axis xy; caxis([15 60])
    % hold on, subplot(1,5,5), plot(freqfi,mean(Spi,1))
    
    if PlotNotZscore, figure('Color',[1 1 1]), FnotZscore=gcf;end
    if plotZscore, figure('Color',[1 1 1]), FZscore=gcf;end
    
    AllEpoch=intervalSet(ti(1)*1E4,ti(end)*1E4);
    [tA, SpA]=SpectroEpochML(Spi,ti,freqfi,AllEpoch-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch);
    zSpA=zscore(SpA,0,1);
    zSpA_imagesc=zscore(SpA,0,1)-min(min(zscore(SpA,0,1)));
    
    for i=1:length(InjectionEpochs)
        eval(['epoch=and(',InjectionEpochs{i},',',StateEpochs{:},')-NoiseEpoch-GndNoiseEpoch-WeirdNoiseEpoch;']);
        if PlotNotZscore
            [tEpoch, SpEpoch]=SpectroEpochML(Spi,ti,freqfi,epoch);
            figure(FnotZscore), subplot(length(InjectionEpochs),5,[1:4]+5*(i-1)),
            hold on, imagesc(tEpoch,freqfi,10*log10(SpEpoch)'), axis xy; caxis([15 60]), ylim([0 20])
            title(name)
            hold on, subplot(length(InjectionEpochs),5,5*i), plot(freqfi,mean(SpEpoch,1),'Linewidth',2);
            title([InjectionEpochs{i},' - ',StateEpochs{:}])
        end
        
        [tEpoch, SpEpoch]=SpectroEpochML(zSpA,tA,freqfi,epoch);
        if plotZscore
            figure(FZscore), subplot(length(InjectionEpochs),5,[1:4]+5*(i-1)),
            [tEpoch_imagesc, SpEpoch_imagesc]=SpectroEpochML(zSpA_imagesc,tA,freqfi,epoch);
            hold on, imagesc(tEpoch_imagesc,freqfi,10*log10(SpEpoch_imagesc)');axis xy;caxis([-25 5]), ylim([0 20])
            title(name)
            hold on, subplot(length(InjectionEpochs),5,5*i), plot(freqfi,mean(SpEpoch,1),'Linewidth',2); ylim([-3 3])
            title(['Zscored - ',InjectionEpochs{i},' - ',StateEpochs{:}])
        end
        %if strcmp(InjectionEpochs{i},'VEHEpoch')
        if strcmp(InjectionEpochs{i},'PreEpoch')
            temp=mean(SpEpoch,1);
        %elseif exist('temp','var') && strcmp(InjectionEpochs{i},'DPCPXEpoch')
        elseif exist('temp','var') && strcmp(InjectionEpochs{i},'VEHEpoch')
            MatrixSp(man,:)=mean(SpEpoch,1)-temp;
        end
        
    end
    
end


%% display strain effect

figure('Color',[1 1 1]), Fstrain=gcf;
legend_Fstrain=[];
colori={'b','r','g'};
for ss=1:length(Strains)
    poolss=find(infoMatrixSp(:,1)==ss);
    tempMatrix{ss}=MatrixSp(poolss,:);
    hold on, plot(freqfi,mean(MatrixSp(poolss,:)),colori{ss},'Linewidth',2)
    legend_Fstrain=[legend_Fstrain,{[Strains{ss},' (n=',num2str(length(poolss)),')']}];
end
%title([structure,'  DPCPX/VEH (Zscore)- ',StateEpochs{:}])
%title([structure,'  DPCPX/Pre (Zscore)- ',StateEpochs{:}])
title([structure,'  VEH/Pre (Zscore)- ',StateEpochs{:}])
xlabel('Frequencies (Hz)')
if size(tempMatrix{1},1)>1 && size(tempMatrix{2},1)>1
    [H,p]=ttest2(tempMatrix{1},tempMatrix{2});
    hold on, plot(freqfi(p<pval),ones(length(p(p<pval))),'g.');
    if sum(p<pval)>0, 
        legend_Fstrain=[legend_Fstrain,{['pvalue < ',num2str(pval)]}];
    end
end
legend(legend_Fstrain)

for ss=1:length(Strains)
    poolss=find(infoMatrixSp(:,1)==ss);
    
    hold on, plot(freqfi,mean(MatrixSp(poolss,:))+stdError(MatrixSp(poolss,:)),colori{ss})
    hold on, plot(freqfi,mean(MatrixSp(poolss,:))-stdError(MatrixSp(poolss,:)),colori{ss})
end

cd(res)
