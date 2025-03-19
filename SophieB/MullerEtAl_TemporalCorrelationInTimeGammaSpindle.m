
clear all
close all
Dir=PathForExperimentsBasalSleepRhythms;
smootime = 3;
for mouse = 8:length(Dir.path)
    cd(Dir.path{mouse})
    
    disp(num2str(mouse))
    if exist('ChannelsToAnalyse/PFCx_spindles.mat')>0 |exist('ChannelsToAnalyse/PFCx_sup.mat')>0
        % Load gamma
        load('RestrictiveSleepForOScillAnalysis.mat','SWSEpoch')
        % Spindle power
        try
            load('ChannelsToAnalyse/PFCx_spindles.mat')
        catch
            load('ChannelsToAnalyse/PFCx_sup.mat')
        end
        load(['LFPData/LFP',num2str(channel),'.mat'])
        SpindleBand = FilterLFP(LFP,[10 15],1024);
        tEnveloppeSpindle = tsd(Range(SpindleBand), abs(hilbert(Data(SpindleBand))) );
        SmoothSpindle= tsd(Range(tEnveloppeSpindle), runmean(Data(tEnveloppeSpindle), ...
            ceil(smootime/median(diff(Range(tEnveloppeSpindle,'s'))))));
        
        % Gamma power
        load('StateEpochSB.mat', 'smooth_ghi')
        
        figure
        subplot(311)
        spinpfc = Data(Restrict(SmoothSpindle,SWSEpoch));
        [c_spin(mouse,:),lags] = xcorr(zscore(spinpfc-runmean(spinpfc,1e5)),floor(500/median(diff(Range(SmoothSpindle,'s')))));
        plot(lags*median(diff(Range(SmoothSpindle,'s'))),c_spin(mouse,:))
        
        subplot(312)
        gam  = Data(Restrict(smooth_ghi,SWSEpoch));
        [c_gam(mouse,:),lags] = xcorr(zscore(gam-runmean(gam,1e5)),floor(500/median(diff(Range(SmoothSpindle,'s')))));
        plot(ccc,c_gam(mouse,:))
        
        subplot(313)
        [c_spin_gam(mouse,:),lags] = xcorr(zscore(spinpfc-runmean(spinpfc,1e5)),zscore(gam-runmean(gam,1e5)),floor(500/median(diff(Range(SmoothSpindle,'s')))));
        plot(lags*median(diff(Range(smooth_ghi,'s'))),c_spin_gam(mouse,:))
        
    end
    
end