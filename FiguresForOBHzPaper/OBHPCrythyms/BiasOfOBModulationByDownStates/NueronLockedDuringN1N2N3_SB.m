clear all
load('SpikeData.mat')

FileToLoad = {'LFPData/LocalBulb_left_Activity.mat',...
    'LFPData/LocalBulb_right_Activity.mat',...
    'LFPData/LocalHPC_left_Activity.mat',...
    'LFPData/LocalHPC_right_Activity.mat',...
    'LFPData/LFP28.mat',...
    'LFPData/LFP15.mat',...
    'LFPData/LFP1.mat',...
    'LFPData/LFP47.mat',...
    'LFPData/LFP45.mat'};

load('SleepSubstages.mat')
EpToUse = Epoch([1,2,3,4,5]);
EpochNames = NameEpoch([1,2,3,4,5]);
%% Define wake epoch with clean oscillations
load('B_Low_Spectrum.mat')
Sptsd_B = tsd(Spectro{2}*1e4,Spectro{1});
WakeSpec = Data(Restrict(Sptsd_B,EpToUse{5}));
WakeSpecPower = tsd(Range(Restrict(Sptsd_B,EpToUse{5})),nanmean(WakeSpec(:,40:60),2)-nanmean(WakeSpec(:,20:35),2));
HighEpoc = thresholdIntervals(WakeSpecPower,1.5*1e5,'Direction','Above');
HighEpoc = mergeCloseIntervals(HighEpoc,3*1e4);
HighEpoc = dropShortIntervals(HighEpoc,1*1e4);
EpToUse{6}  = HighEpoc;
EpochNames{6} = 'Wake_GoodOscill';
load('DownState.mat')
down_PFCx = mergeCloseIntervals(down_PFCx,3*1e4);
SleepNoDown = Epoch{7}-down_PFCx;
SleepNoDown = dropShortIntervals(SleepNoDown,3*1e4);
SleepNoDown = intervalSet(Start(SleepNoDown)+1*1e4,Stop(SleepNoDown)-1e4);
EpToUse{7}  = SleepNoDown;
EpochNames{7} = 'Sleep_NoDown';

FilterBands = [1:1:18;3:1:20];
for ff =  1:length(FileToLoad)
    load(FileToLoad{ff})
    disp(FileToLoad{ff})
    tic
    for ep = 7%1:length(EpToUse)
        [HS,PhaseSpikes,ModInfo,PhaseLFP]=RayleighFreq_SB(Restrict(LFP,EpToUse{ep}),Restrict(S,EpToUse{ep}),'FilterBands',FilterBands);
        save(['RayleighFreqAnalysis/Rayleigh_BandWidthSmall_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','PhaseSpikes','ModInfo','FilterBands','-v7.3')
        %     save(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'LFP.mat'],'PhaseLFP','FilterBands','-v7.3')
        clear('HS','PhaseSpikes','ModInfo','PhaseLFP')
    end
    toc
    clear LFP
end

% Get same but for up and down states
load('DownState.mat')
clear S
S{1} = ts(Start(down_PFCx));
S{2} = ts(Stop(down_PFCx));
S = tsdArray(S);
FilterBands = [1:1:18;3:1:20];
for ff =  2:length(FileToLoad)
    load(FileToLoad{ff})
    disp(FileToLoad{ff})
    tic
    for ep = 1:3
        [HS,PhaseSpikes,ModInfo,PhaseLFP]=RayleighFreq_SB(Restrict(LFP,EpToUse{ep}),Restrict(S,EpToUse{ep}),'FilterBands',FilterBands);
        save(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Delta.mat'],'HS','PhaseSpikes','ModInfo','FilterBands','-v7.3')
        %     save(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'LFP.mat'],'PhaseLFP','FilterBands','-v7.3')
        clear('HS','PhaseSpikes','ModInfo','PhaseLFP')
    end
    toc
    clear LFP
end

%%%% figure
clear all
FileToLoad = {'LFPData/LocalBulb_left_Activity.mat',...
    'LFPData/LocalHPC_left_Activity.mat',...
    'LFPData/LFP28.mat'};
FilterBands = [1:1:18;3:1:20];
load('SleepSubstages.mat')
EpToUse = Epoch([1,2,3,4,5]);
EpochNames = NameEpoch([1,2,3,4,5]);
EpochNames{6} = 'Sleep_NoDown';

Regions = {'OB_Local','HPC_Local','PFC'};
fig = figure(28);
FreqStep=3;
for neurnum = 1:150
    clf
    ha = tight_subplot(3,6);
    
    for ff =  1:length(Regions)
        for ep = 1:length(EpochNames)
            load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
            
            axes(ha((ff-1)*6+ep))
            imagesc([0:4*pi],mean(FilterBands),HS{neurnum}), axis xy
            colorbar
            if ff ==1
                title(EpochNames{ep})
            end
            if ep ==1
                ylabel(Regions{ff})
            end
            xlabel('Phase (rad)')
            MuPlot = ModInfo.mu.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum);
            KappaPlot = ModInfo.Kappa.Transf(ModInfo.pval.Transf(:,neurnum)<0.05,neurnum);
            
            FigArrow([MuPlot,FilterBands(1,find(ModInfo.pval.Transf(:,neurnum)<0.05))'+FreqStep/2],...
                KappaPlot,MuPlot,0.8)
            FigArrow([MuPlot+2*pi,FilterBands(1,find(ModInfo.pval.Transf(:,neurnum)<0.05))'+FreqStep/2],...
                KappaPlot,MuPlot,0.8)
            
        end
        
        
    end
    
    colormap jet
                saveas(28,['/media/DataMOBsRAIDN/ProjetAversion/ModulationneuronsDiffBrainStates/Mouse508_20170126_Neuron',...
                    num2str(neurnum),'RayleighFreq.png'])
    
end

figure
BandNumber=2;
clf
for ff =  1:length(Regions)
    for ep = 1:length(EpochNames)
        
        load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
        NumNeurMod.Transf(ff,ep) = sum(ModInfo.pval.Transf(BandNumber,:)<0.05);
        NumNeurMod.Nontransf(ff,ep) =  sum(ModInfo.pval.Nontransf(BandNumber,:)<0.05);
        %         pie([NumNeurMod.Transf(ff,ep)/size(ModInfo.pval.Transf,2),1-NumNeurMod.Transf(ff,ep)/size(ModInfo.pval.Transf,2)]);
    end
    subplot(3,1,ff)
    bar(NumNeurMod.Transf(ff,:)/size(ModInfo.pval.Transf,2))
    set(gca,'XTick',[1:6],'XTickLabel',EpochNames)
    title(Regions{ff})
    ylabel('% modulated neurons')
    ylim([0 1])
end

figure
clf
AngleMat = [2*pi/40:2*pi/20:2*pi-2*pi/40];
for ff =  1:length(Regions)
    for ep = 1:length(EpochNames)
        
        load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
        subplot(3,2,(ff-1)*2+1)
        hold on
        plot(mean(FilterBands),sum(ModInfo.pval.Transf'<0.05)/187,'linewidth',2)
        xlabel('Frquency (Hz)')
        ylabel('Prop neurons mod')
        subplot(3,2,(ff-1)*2+2)
        hold on
        for freq = 1:18
            KappaVals(freq,:) = ModInfo.Kappa.Transf(freq,:);
            KappaVals(freq,ModInfo.pval.Transf(freq,:)>0.05) = NaN;
        end

%         ModInfo.Kappa.Transf(ModInfo.pval.Transf'<0.05) = NaN;
        plot(mean(FilterBands),nanmean(KappaVals'),'linewidth',2)
        xlabel('Frquency (Hz)')
        ylabel('Mean Kappa of mod neurons')

        
    end
    title(Regions{ff})
    
end
subplot(3,2,1)
legend(EpochNames)

%% Phase
figure

for ff =  1:length(Regions)
    for ep = 1:length(EpochNames)
        load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
        
        subplot(3,6,(ff-1)*6+ep)
        for freq = 1:length(FilterBands)
            HistPhase(freq,:) = repmat(hist(ModInfo.mu.Transf(freq,ModInfo.pval.Transf(freq,:)'<0.05),AngleMat),1,2);
            HistPhase(freq,:) = zscore(HistPhase(freq,:));%/nansum(HistPhase(freq,:));
        end
        
        HistPhaseSmo=SmoothDec(HistPhase,[0.003,0.8]);
        HistPhaseSmo(:,40)=HistPhaseSmo(:,20);
        HistPhaseSmo(:,1)=HistPhaseSmo(:,21);
        
        imagesc([[2*pi/40:2*pi/20:2*pi-2*pi/40],[2*pi/40:2*pi/20:2*pi-2*pi/40]+2*pi],mean(FilterBands),HistPhaseSmo), axis xy
        if ff ==1
            title(EpochNames{ep})
        end
        if ep ==1
            ylabel(Regions{ff})
        end
        
    end
end
colormap jet


figure
clf
AngleMat = [2*pi/40:2*pi/20:2*pi-2*pi/40];
num=1;
for ff =  1
    for ep = [3,1,5]
        
        load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
        %subplot(1,3,num)
        %hold on
        %nhist(ModInfo.mu.Transf(3,ModInfo.pval.Transf(3,:)'<0.01))
        A{num} = ModInfo.mu.Transf(3,ModInfo.pval.Transf(3,:)'<0.0001);
        num = num+1;
    end
end
subplot(3,2,1)
legend(EpochNames)

A = {ModInfo.mu.Transf(3,ModInfo.pval.Transf(3,:)'<0.05)}

        
        %%% old stuff
        
        % FilterBands = [1:1:18;3:1:20];
        % for ff = 1:length(FileToLoad)
        %     load(FileToLoad{ff})
        %     disp(FileToLoad{ff})
        %
        %     [HS,Ph,ModTheta,phasectrl]=RayleighFreq_SB(LFP,S,'FilterBands',FilterBands);
        %     save(['RayleighFreqAnalysis/Rayleigh_BandWidth2_' FileToLoad{ff}(9:end-4) '.mat'],'HS','Ph','ModTheta','phasectrl','FreqRange','FreqStep','-v7.3')
        %     clear('HS','Ph','ModTheta','phasectrl','LFP','FilterBands')
        % end
        
        
        % FilterBands = [1:1:18;4:1:21];
        % for ff = 2:length(FileToLoad)
        %     load(FileToLoad{ff})
        %     disp(FileToLoad{ff})
        %     [HS,Ph,ModTheta,phasectrl]=RayleighFreq_SB(LFP,S,'FilterBands',FilterBands);
        %
        %     save(['RayleighFreqAnalysis/Rayleigh_LargeBandWidth_' FileToLoad{ff}(9:end-4) '.mat'],'HS','Ph','ModTheta','phasectrl','FilterBands','-v7.3')
        %     clear('HS','Ph','ModTheta','phasectrl','LFP')
        % end
        
        fi = 512;
        %% Need to get the filtered LFP also for phase correction
        FreqRange = [1 20];
        FreqStep = 1;
        FilterBands = [FreqRange(1):FreqStep:FreqRange(2);FreqRange(1)+FreqStep:FreqStep:FreqRange(2)+FreqStep];
        load('SleepSubstages.mat')
        EpToUse = Epoch([1,2,3,4,5,7,10,11]);
        load('StateEpochSB.mat','Epoch');
EpToUse{9} = Epoch;
EpochNames = NameEpoch([1,2,3,4,5,7,10,11]);
EpochNames{9} = 'AllData_NoNoise';

for ff = 2:length(FileToLoad)
    load(FileToLoad{ff})
    disp(FileToLoad{ff})
    for i = 1 : size(FilterBands,2)
        Filt=[FilterBands(1,i),FilterBands(2,i)];
        Fil=FilterLFP(LFP,Filt,fi);
        
        zr = hilbert(Data(Fil));
        phzr = atan2(imag(zr), real(zr));
        phzr(phzr < 0) = phzr(phzr < 0) + 2 * pi;
        Phase(i,:) = phzr;
        
    end
    phaseLFP_All =tsd(Range(LFP),Phase(i,:)');
    
    for ep = 1:length(EpToUse)
        phaseLFP = Restrict(phaseLFP_All,EpToUse{ep});
        [fedf,xedf]=ecdf(Data(phaseLFP));
        Funct=2*pi*(fedf)-pi;
        
        % Correct phases of LFP
        bins = discretize(Data(phaseLFP), xedf);
        
        TransPh=Funct(bins);
        
        PhasesLFP.(EpochNames{ep}).Nontransf = hist(Data(phaseLFP),60);
        PhasesLFP.(EpochNames{ep}).Transf = hist(TransPh,60);
        PhasesLFP.(EpochNames{ep}).Funct = Funct;
        PhasesLFP.(EpochNames{ep}).xedf = xedf;
        
    end
    disp('saving')
    save(['RayleighFreqAnalysis/FilteredSignalCorr_SmallBandWidth_' FileToLoad{ff}(9:end-4) '.mat'],'PhasesLFP','FilterBands','EpochNames','EpToUse','-v7.3')
    clear('Ph_LFP','LFP','PhasesLFP','phaseLFP_All','phaseLFP')
    
end

clf
for ep = [6,1,2,3]
    load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')

for freq = 1:18
    KappaVals(freq,:) = ModInfo.Kappa.Transf(freq,:);
    KappaVals(freq,ModInfo.pval.Transf(freq,:)>0.05) = NaN;
end
hold on
errorbar(nanmean(FilterBands),nanmedian(KappaVals'),stdError(KappaVals'),'linewidth',2)

end

ff=1
for ep = [7,1,2,3,4,6]
    load(['RayleighFreqAnalysis/Rayleigh_BandWidthLarge_' EpochNames{ep} '_' FileToLoad{ff}(9:end-4) 'Spike.mat'],'HS','ModInfo')
    for sp = 1:length(ModInfo.pval.Transf)
        Z{ep}(:,sp) = length(Restrict(S{sp},EpToUse{ep})) .* ModInfo.Rmean.Transf(:,sp).^2;
    end
end


for freq = 1:4
    subplot(1,4,freq)
    for ep = [7,1,2,3,4,6]
        [Y1,X1]=(hist(log(Z{ep}(freq,:)),100));
        plot(X1,100*(1-cumsum(Y1)/sum(Y1)),'linewidth',2), hold on
    end
    line([1.12 1.12],ylim,'linestyle','--','color','k')
    xlim([0 6]),ylim([0 100])
    box off
    xlabel('ln(Z)'), ylabel('% units')
    set(gca,'FontSize',10,'YTick',[0:20:100])
    title(['FreqBand: ',num2str( FilterBands(1,freq)), ':', num2str( FilterBands(2,freq)),'Hz'])
end