% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy-plethysmo');

EpLength = [6,14,22,40];

numNeurons=[];
num=1;
FieldNames={'OB1','PFCx'};
MiceDone = {};
nbin=30;
mousenum = 0;
for mm=1:length(Dir.path)
    if exist(Dir.path{mm})>0 && strcmp(Dir.group{mm},'CTRL') && sum(strcmp(MiceDone,Dir.name{mm}))==0
        cd(Dir.path{mm})
        
        if exist('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_Respi.mat')>0
            disp(Dir.path{mm})
            mousenum = mousenum+1;
            MiceDone{mousenum} = Dir.name{mm};
            
            for eplg = 1:length(EpLength)-1
                clear PhasetsdSub
                clear PhasesSpikes mu
                load('NeuronLFPCoupling_OB4HzPaper/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_Respi.mat')
                clear FreezeEpoch MovAcctsd
                load('behavResources.mat')
                FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
                FreezeEpoch = dropShortIntervals(FreezeEpoch,EpLength(eplg)*1e4);
                FreezeEpoch = dropLongIntervals(FreezeEpoch,EpLength(eplg+1)*1e4);
                keyboard
                
                for sp = 1:length(PhasesSpikes.Nontransf)
                    try
                        [mutemp, ~, pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)));
                    catch
                        mutemp = NaN;
                        pval = NaN;
                    end
                    
                    Dat = (Data(PhasesSpikes.Nontransf{sp})-mutemp);
                    Dat(Dat<-pi) = 2*pi+Dat(Dat<-pi);
                    Dat(Dat>pi) = Dat(Dat>pi)-2*pi;
                    
                    PhasetsdSub{sp} = tsd(Range(PhasesSpikes.Nontransf{sp}),(Dat));
                    pvalAll{mousenum,eplg}(sp) = pval;
                    
                    %                 subplot(211)
                    %                 hist(Data(Restrict(PhasesSpikes.Nontransf{sp},FreezeEpoch)),60)
                    %                 line([1 1]*mutemp,ylim,'color','r')
                    %                 title(num2str( pvalAll{mousenum}(sp) ))
                    %                 subplot(212)
                    %                 hist(Data(Restrict(PhasetsdSub{sp} ,FreezeEpoch)),60)
                    %                 line([1 1]*-pi,ylim,'color','r')
                    %                 line([1 1]*pi,ylim,'color','r')
                    %                 pause(0.1)
                    %                 clf
                    
                end
                
                load('Respi_Low_Spectrum.mat')
                sptsd=tsd(Spectro{2}*1e4,(Spectro{1}));
                load('BreathingInfo.mat')

                
                
                if length(Start(FreezeEpoch))==0
                    for sp = 1:length(PhasesSpikes.Nontransf)
                        PhaseDist{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        KappaLocal{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        FRLocal{mousenum,eplg}(sp,1,1:4) = nan(1,4);
                        

                    end
                    DurEp{mousenum,eplg}(fz) = 0;
                else
                    
                    
                    for fz = 1:length(Start(FreezeEpoch))
                        
                        LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz))-3*1e4,Start(subset(FreezeEpoch,fz)));
                        MeanSpec{mousenum,eplg}(fz,1,:) = nanmean(Data(Restrict(sptsd,LittleEpoch)));
                        BreathRed{mousenum,eplg}(fz,1) = nanstd(diff(Range(Restrict(Breathtsd,LittleEpoch),'s')));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,1) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,1) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,1) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,1) = NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz)),Start(subset(FreezeEpoch,fz))+3*1e4);
                        MeanSpec{mousenum,eplg}(fz,2,:) = nanmean(Data(Restrict(sptsd,LittleEpoch)));
                        BreathRed{mousenum,eplg}(fz,2) = nanstd(diff(Range(Restrict(Breathtsd,LittleEpoch),'s')));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,2) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,2) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,2) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,2) =NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz))-3*1e4,Stop(subset(FreezeEpoch,fz)));
                        MeanSpec{mousenum,eplg}(fz,3,:) = nanmean(Data(Restrict(sptsd,LittleEpoch)));
                        BreathRed{mousenum,eplg}(fz,3) = nanstd(diff(Range(Restrict(Breathtsd,LittleEpoch),'s')));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,3) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,3) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,3) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,3) = NaN;
                            end
                        end
                        
                        LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz)),Stop(subset(FreezeEpoch,fz))+3*1e4);
                        MeanSpec{mousenum,eplg}(fz,4,:) = nanmean(Data(Restrict(sptsd,LittleEpoch)));
                        BreathRed{mousenum,eplg}(fz,4) = nanstd(diff(Range(Restrict(Breathtsd,LittleEpoch),'s')));
                        for sp = 1:length(PhasesSpikes.Nontransf)
                            PhaseDist{mousenum,eplg}(sp,fz,4) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            FRLocal{mousenum,eplg}(sp,fz,4) = length(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
                            if not(isempty(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch))))
                                [mutemp, Kappatemp pval, ~, ~, ~,~,~] = CircularMean(Data(Restrict(PhasesSpikes.Nontransf{sp},LittleEpoch)));
                                KappaLocal{mousenum,eplg}(sp,fz,4) = Kappatemp;
                            else
                                KappaLocal{mousenum,eplg}(sp,fz,4) = NaN;
                            end
                        end
                        
                        DurEp{mousenum,eplg}(fz) = Stop(subset(FreezeEpoch,fz),'s') - Start(subset(FreezeEpoch,fz),'s');
                    end
                end
            end
            
        end
    end
end


alpha = 0.01;


figure
clf
for eplg = 1:length(EpLength)-1
    AllSpec = [];
    AllVar  = [];

    for mm = 1 :mousenum
        AllSpec(mm,:,:) = squeeze(nanmean(MeanSpec{mm,eplg}(:,:,:),1));
        AllVar(mm,:) = nanmean(BreathRed{mm,eplg});
    end

    subplot(3,3,1+(eplg-1)*3)
plot(Spectro{3},squeeze(nanmean(AllSpec(:,2:3,:),1))','linewidth',2)
legend('Beg','End')
title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
xlabel('frequency(Hz)')
ylabel('Respi power')

    subplot(3,3,2+(eplg-1)*3)
PlotErrorBarN_KJ(AllVar,'newfig',0)
title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
ylabel('Breath variability')

    subplot(3,3,3+(eplg-1)*3)
SNR = squeeze(nanmean(AllSpec(:,:,find(Spectro{3}<3,1,'last'):find(Spectro{3}<6,1,'last')),3))./squeeze(nanmean(AllSpec,3));
PlotErrorBarN_KJ(SNR,'newfig',0)
title(['Min Fz ep :', num2str(EpLength(eplg)) ' s' ])
set(gca,'XTick',[1:4],'XTickLabel',{'Pre','Beg','End','Post'})
ylabel('3-6Hz SNR')

end
