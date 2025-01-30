% Make basic figures to show neuronmodulation by OB% Calculate spectra,coherence and Granger
clear all
obx=0;
% Get data
OBXEphys=[230,249,250,291,297,298];
CtrlEphys=[244,243,253,254,258,259,299,394,395,402,403,450,451,248];
% close all
[params,movingwin,suffix]=SpectrumParametersML('low');
rmpath('/Users/sophiebagur/Dropbox/PrgMatlab/Fra/UtilsStats')
Dir=PathForExperimentFEAR('Fear-electrophy');
Dir=RestrictPathForExperiment(Dir,'nMice',CtrlEphys);
Dir=RestrictPathForExperiment(Dir,'Session','EXT-24h');
numNeurons=[];
num=1;
StrucNames={'OB' 'HPC'}
KeepFirstSessionOnly=[1,5:length(Dir.path)];
Ep={'Fz','NoFz'};
FieldNames={'OB1','HPCLoc'};
nbin=30;
mousenum = 0;
for mm=KeepFirstSessionOnly
    cd(Dir.path{mm})
    clear FreezeEpoch MovAcctsd
    load('behavResources.mat')
    FreezeEpoch = mergeCloseIntervals(FreezeEpoch,2*1e4);
    FreezeEpoch = dropShortIntervals(FreezeEpoch,4*1e4);
    
    if exist('NeuronLFPCoupling/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')>0
        clear PhasesSpikes mu
        load('NeuronLFPCoupling/AllEpochNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat')
        load('NeuronLFPCoupling/FzNeuronModFreqMiniMaxiPhaseCorrected_OB1.mat','mu','Kappa','pval')
        disp(Dir.path{mm})
        mousenum = mousenum+1;
        
        
        for sp = 1:length(mu.Real)
            
            mutemp = mu.Real{sp}.Nontransf;
            if mutemp>pi
                mutemp = mutemp-2*pi;
            end
            
            Dat = ((PhasesSpikes.Real{sp}.Nontransf)-mutemp);
            Dat(Dat<-pi) = 2*pi+Dat(Dat<-pi);
            Dat(Dat>pi) = Dat(Dat>pi)-2*pi;

            PhasetsdSub{sp} = tsd(Tps{sp},abs(Dat));
            pvalAll{mousenum}(sp) = pval.Real{sp}.Nontransf;
            subplot(211)
            hist(PhasesSpikes.Real{sp}.Nontransf,60)
            line([1 1]*mutemp,ylim,'color','r')
            subplot(212)
            hist(Dat,60)
            line([1 1]*-pi,ylim,'color','r')
            line([1 1]*pi,ylim,'color','r')
            pause(0.1)
            clf

        end
        
        for fz = 1:length(Start(FreezeEpoch))
            
            LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz))-2*1e4,Start(subset(FreezeEpoch,fz)));
            for sp = 1:length(mu.Real)
                PhaseDist{mousenum}(sp,fz,1) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
            end
            
            LittleEpoch = intervalSet(Start(subset(FreezeEpoch,fz)),Start(subset(FreezeEpoch,fz))+2*1e4);
            for sp = 1:length(mu.Real)
                PhaseDist{mousenum}(sp,fz,2) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
            end
            
            LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz))-2*1e4,Stop(subset(FreezeEpoch,fz)));
            for sp = 1:length(mu.Real)
                PhaseDist{mousenum}(sp,fz,3) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
            end
            
            LittleEpoch = intervalSet(Stop(subset(FreezeEpoch,fz)),Stop(subset(FreezeEpoch,fz))+2*1e4);
            for sp = 1:length(mu.Real)
                PhaseDist{mousenum}(sp,fz,4) = nanmean(Data(Restrict(PhasetsdSub{sp},LittleEpoch)));
            end
            
            DurEp{mousenum}(fz) = Stop(subset(FreezeEpoch,fz),'s') - Start(subset(FreezeEpoch,fz),'s');
        end
        
        
    end
    
    
end

AllData = [];
for mm = 1 :mousenum
    AllData = [AllData;squeeze(nanmean(PhaseDist{mousenum}(pvalAll{mousenum}<0.05,DurEp{mousenum}<10,:),2))];
end

