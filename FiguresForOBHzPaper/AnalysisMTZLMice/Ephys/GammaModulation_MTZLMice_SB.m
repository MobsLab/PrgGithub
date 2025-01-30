clear all
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
for d = 3:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        
        disp(Dir.path{d}{dd})
        
        load('ChannelsToAnalyse/Bulb_deep.mat'), chOB = channel;
        load(['LFPData/LFP',num2str(chOB),'.mat'])
        load('BreathingInfo_ZeroCross.mat')
        load('SleepScoring_Accelero.mat','Epoch','TotalNoiseEpoch')
        NoNoiseEpoch = Epoch-TotalNoiseEpoch;
        RespiEpoch = load('RespiNoise.mat','TotalNoiseEpoch');
        NoNoiseEpoch = NoNoiseEpoch-RespiEpoch.TotalNoiseEpoch;
        clear Epoch
        load('SleepSubstages.mat')
        BreathtsdRand = ts(sort(Range(Breathtsd)+randn(length(Range(Breathtsd)),1)*5*1e4));
        LFPEp = LFP;
        num = 1;
        for g = 20:5:150
            tic
            disp(num2str(g))
            FilLFP = FilterLFP(LFPEp,[g,g+10],1024);
            HilGamma=hilbert(Data(FilLFP));
            H=abs(HilGamma);
            tot_ghi=(tsd(Range(LFPEp),H));
            
            for ep = 1:5
                
                rg = Range(Restrict(Breathtsd,and(NoNoiseEpoch,Epoch{ep})),'s');
                rg = rg(1:1000);
                [M,T]=PlotRipRaw(tot_ghi,rg,500,0,0);
                Triggered_Gamma_temp{ep}{num} = T;
                
                rg = Range(Restrict(BreathtsdRand,and(NoNoiseEpoch,Epoch{ep})),'s');
                rg = rg(1:1000);
                [M,T]=PlotRipRaw(tot_ghi,rg,500,0,0);
                Triggered_Gamma_Rand_temp{ep}{num} = T;
                
                
            end
            num=num+1;
            toc
        end
        
        for ep = 1:5
            Triggered_Gamma = Triggered_Gamma_temp{ep};
            Triggered_Gamma_Rand = Triggered_Gamma_Rand_temp{ep};
            save([cd filesep 'RespiEvokedPotentials/GammaOnRespi',NameEpoch{ep},'.mat'],'Triggered_Gamma','Triggered_Gamma_Rand','Epoch','Breathtsd','-v7.3')
        end
        clear Triggered_Gamma LFP Epoch NoNoiseEpoch chOB Triggered_Gamma_Rand Triggered_Gamma_Rand_temp Triggered_Gamma_temp
        
    end
end


%%

clf
for ep = 1:5
    subplot(3,5,ep)
    imagesc(M(:,1),[20:5:150],SmoothDec((Triggered_Gamma{ep}(:,5:end-5)),[2 1])), axis xy
    
    subplot(3,5,5+ep)
    imagesc(M(:,1),[20:5:150],SmoothDec((Triggered_Gamma{ep}(:,5:end-5)),[2 1])), axis xy
    clim([0 500])
    
    subplot(3,5,10+ep)
    imagesc(M(:,1),[20:5:150],SmoothDec(nanzscore(Triggered_Gamma{ep}(:,5:end-5)')',[2 1])), axis xy
    clim([-2.5 2.5])
    
end

clear all
close all
num = 1;
Dir = PathForExperimentsMtzlProject('SleepPlethysmograph');
for d = 1:length(Dir.path)
    for dd = 1:length(Dir.path{d})
        cd(Dir.path{d}{dd})
        disp(Dir.path{d}{dd})
        if not(Dir.ExpeInfo{d}{dd}.nmouse==776)
        load('SleepSubstages.mat')
        for ep = 1:5
            load([cd filesep 'RespiEvokedPotentials/GammaOnRespi',NameEpoch{ep},'.mat'])
            for f = 1:length(Triggered_Gamma)
                AvGamma(f,:) = nanmean(Triggered_Gamma{f});
                AvGammaRand(f,:) = nanmean(Triggered_Gamma_Rand{f});
            end
            figure(1)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],zscore(AvGamma')')
            axis xy
            clim([-3 3])
            colormap jet
            
            figure(2)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],(AvGamma))
            axis xy
            clim([0 500])
            colormap jet
            
            figure(3)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],(AvGamma))
            axis xy
            colormap jet

            figure(4)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],zscore(AvGammaRand')')
            axis xy
            clim([-3 3])
            colormap jet
            
            figure(5)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],(AvGammaRand))
            axis xy
            clim([0 500])
            colormap jet
            
            figure(6)
            subplot(8,5,(num-1)*5+ep)
            imagesc([-500:500],[20:5:150],(AvGammaRand))
            axis xy
            colormap jet
        end
        num = num+1;
        end
    end
end



