clear all
Dir=PathForExperimentsBasalSleepRhythms;
smootime = 3;
for mouse = 14:length(Dir.path)
    cd(Dir.path{mouse})
    try
        disp(num2str(mouse))
        if exist('ChannelsToAnalyse/PFCx_spindles.mat')>0 |exist('ChannelsToAnalyse/PFCx_sup.mat')>0
            % Load gamma
            load('ChannelsToAnalyse/Bulb_deep.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            GammaBand = FilterLFP(LFP,[50 70],1024);
            tEnveloppeGamma = tsd(Range(GammaBand), abs(hilbert(Data(GammaBand))) );
            SmoothGamma = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
                ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
            clf
            plot(Range(SmoothGamma,'s'),Data(SmoothGamma))
            [x,y] = ginput(1);
            SWSEpoch = thresholdIntervals(SmoothGamma,y,'Direction','Below')
            load('SleepScoring_OBGamma.mat', 'REMEpoch')
            SWSEpoch = SWSEpoch -REMEpoch;
            SWSEpoch = dropShortIntervals(SWSEpoch,5*1e4);
            hold on
            plot(Range(Restrict(SmoothGamma,SWSEpoch),'s'),Data(Restrict(SmoothGamma,SWSEpoch)))
            save('RestrictiveSleepForOScillAnalysis.m','SWSEpoch')
            keyboard
            
            % Get spindle
            smootime = 3;
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
            
            GammaBand = FilterLFP(LFP,[50 70],1024);
            tEnveloppeGamma = tsd(Range(GammaBand), abs(hilbert(Data(GammaBand))) );
            SmoothGammaPFC = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
                ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
            
            
            load('ChannelsToAnalyse/PFCx_deep.mat')
            load(['LFPData/LFP',num2str(channel),'.mat'])
            SpindleBand = FilterLFP(LFP,[10 15],1024);
            tEnveloppeSpindle = tsd(Range(SpindleBand), abs(hilbert(Data(SpindleBand))) );
            SmoothSpindle_Dp= tsd(Range(tEnveloppeSpindle), runmean(Data(tEnveloppeSpindle), ...
                ceil(smootime/median(diff(Range(tEnveloppeSpindle,'s'))))));
            
            GammaBand = FilterLFP(LFP,[50 70],1024);
            tEnveloppeGamma = tsd(Range(GammaBand), abs(hilbert(Data(GammaBand))) );
            SmoothGammaPFC_Dp = tsd(Range(tEnveloppeGamma), runmean(Data(tEnveloppeGamma), ...
                ceil(smootime/median(diff(Range(tEnveloppeGamma,'s'))))));
            
            
            % Get sleep
            
            %
            spinpfc = Data(Restrict(SmoothSpindle,SWSEpoch));
            spinpfc_dp = Data(Restrict(SmoothSpindle_Dp,SWSEpoch));
            gam = Data(Restrict(SmoothGamma,ts(Range(Restrict(SmoothSpindle,SWSEpoch)))));
            gampfc = Data(Restrict(SmoothGammaPFC,ts(Range(Restrict(SmoothSpindle,SWSEpoch)))));
            gampfc_dp = Data(Restrict(SmoothGammaPFC,ts(Range(Restrict(SmoothSpindle,SWSEpoch)))));
            
            
            [R_OBgam_spinsup(mouse),p_OBgam_spinsup(mouse)]=corr(zscore(spinpfc-runmean(spinpfc,1e5)),zscore(gam-runmean(gam,1e5)));
            [R_OBgam_spindp(mouse),p_OBgam_spindp(mouse)]=corr(zscore(spinpfc_dp-runmean(spinpfc_dp,1e5)),zscore(gam-runmean(gam,1e5)));
            
            [R_PFCgam_spinsup(mouse),p_PFCgam_spinsup(mouse)]=corr(zscore(spinpfc-runmean(spinpfc,1e5)),zscore(gampfc-runmean(gampfc,1e5)));
            [R_PFCgam_spindp(mouse),p_PFCgam_spindp(mouse)]=corr(zscore(spinpfc_dp-runmean(spinpfc_dp,1e5)),zscore(gampfc_dp-runmean(gampfc_dp,1e5)));
            disp(num2str(R_OBgam_spinsup(mouse)))
            
%             save('Oscillanalysis_SBForMullerEtAl.mat','spinpfc','spinpfc_dp','gam','gampfc','gampfc_dp')
%             
%             clf
%             plot(t,zscore(spinpfc-runmean(spinpfc,1e5)))
%             hold on
%             plot(t,zscore(gam-runmean(gam,1e5)))
%             keyboard
        end
    catch
        disp('problem')
    end
end

SpinChan = [];
for mouse = 1:length(Dir.path)
    cd(Dir.path{mouse})
    disp(num2str(mouse))
    if exist('ChannelsToAnalyse/PFCx_spindles.mat')>0
        SpinChan(mouse) = 1;
    else
        SpinChan(mouse) = 0;
    end
end

cd('/media/nas7/BathellierLabData/Analysis_MullerEtAl')
save('CorrelationAnalysis.mat','R_OBgam_spinsup','R_OBgam_spindp','R_PFCgam_spinsup','R_PFCgam_spindp','SpinChan')
%%
A = {R_OBgam_spinsup(SpinChan==1),R_OBgam_spinsup(SpinChan==0),R_OBgam_spindp,R_PFCgam_spinsup,R_PFCgam_spindp};
X = [1,2,3,5,6];
Cols = {[0.8,0.3,0.3],[0.8,0.3,0.3],[0.8,0.3,0.3],[0.3,0.3,0.3],[0.3,0.3,0.3]};
Legend = {'Spindles','PFCSup','PFCdeep','PFCSup','PFCdeep'};
MakeSpreadAndBoxPlot_SB(A,Cols,X,Legend,1,0)
xtickangle(45)
ylabel('Corr coeff')


% figure
subplot(311)
plot(t,zscore(spinpfc-runmean(spinpfc,1e5)))
hold on
plot(t,zscore(gam-runmean(gam,1e5)))
makepretty

subplot(312)
plot(t,zscore(spinpfc_dp-runmean(spinpfc_dp,1e5)))
hold on
plot(t,zscore(gam-runmean(gam,1e5)))
makepretty

subplot(313)
plot(t,zscore(spinpfc_dp-runmean(spinpfc_dp,1e5)))
hold on
plot(t,zscore(gampfc_dp-runmean(gampfc_dp,1e5)))
makepretty
samexaxis
xlim(xl)