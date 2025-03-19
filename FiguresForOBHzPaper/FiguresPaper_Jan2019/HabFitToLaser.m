clear all
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 15];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;
Dir=PathForExperimentFEAR('Fear-electrophy-opto-for-paper');

for dd = 22 : 3 : 31%length(Dir.path)
    
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    load('ExpeInfo.mat')
    
    if ExpeInfo.nmouse==610
    else
        
        % cd right place
        load('ExpeInfo.mat')
        load('behavResources.mat')
        
        load('LFPData/LFP32.mat')
        
        for k = 1:length(StimTimes)
            Time{k} = Range(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Input{k} = Data(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Input{k} = runmean(Input{k}-nanmean(Input{k}(1:1000)),15);
            Input{k}(find(Time{k}<StimTimes(k))) = NaN;
            Input{k}(find(Time{k}>StimTimes(k)+40*1e4)) = NaN;
            Input{k} = nanzscore(Input{k});
            Input{k}(find(Time{k}<StimTimes(k))) = 0;
            Input{k}(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
            
        end
        
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        for k = 1:length(StimTimes)
            OutputOriginal{k} = Data(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Output{k} = OutputOriginal{k};
            %     Output{k}(find(Time{k}<StimTimes(k))) = 0;
            %     Output{k}(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
        end
        
        datatouse = iddata([Output{1};Output{2};Output{3}],[Input{1};Input{2};Input{3}],1/1250);
        
        % try to find best parameters
        clear MeanSpec
        Np = [1:4];
        Delays = [0:0.005:0.015];
        for npnp = 1:length(Np)
            tic
            Nz = [0:Np(npnp)-1];
            for nznz = 1 : length(Nz)
                for dd = 1:length(Delays)
                    sts = tfest(datatouse,Np(npnp),Nz(nznz),Delays(dd));
                    
                    
                    for k = 1:length(Input)
                        [yout,x] = lsim(sts,Input{k},Time{k}/1e4);
                        yout(find(Time{k}<StimTimes(k))) = 0;
                        yout(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
                        [Sp,t,f]=mtspecgramc(Output{k}-yout,movingwin,params);
                        MeanSpec(k,npnp,dd,nznz,:) = nanmean(Sp(1:find(t<55,1,'last'),:));
                    end
                    
                end
            end
            toc
        end
        save('FitTFToLaserResponse.mat','MeanSpec','Np','Delays','-V7.3')
        clear MeanSpec Output Input
    end
end



% Now lets evlauate the quality
clear all
[params,movingwin,suffix]=SpectrumParametersML('low'); % low or high
OptionsMiniMaxi.Fs=1250; % sampling rate of LFP
OptionsMiniMaxi.FilBand=[1 15];
OptionsMiniMaxi.std=[0.5 0.2];
OptionsMiniMaxi.TimeLim=0.07;
Dir=PathForExperimentFEAR('Fear-electrophy-opto-for-paper');

for dd = 22 : 3 : 31%length(Dir.path)
    
    cd(Dir.path{dd})
    disp(Dir.path{dd})
    load('ExpeInfo.mat')
    
        
        % cd right place
        load('behavResources.mat')
        
        load('LFPData/LFP32.mat')
        
        for k = 1:length(StimTimes)
            Time{k} = Range(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Input{k} = Data(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Input{k} = runmean(Input{k}-nanmean(Input{k}(1:1000)),15);
            Input{k}(find(Time{k}<StimTimes(k))) = NaN;
            Input{k}(find(Time{k}>StimTimes(k)+40*1e4)) = NaN;
            Input{k} = nanzscore(Input{k});
            Input{k}(find(Time{k}<StimTimes(k))) = 0;
            Input{k}(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
            
        end
        
        load('ChannelsToAnalyse/Bulb_deep.mat')
        load(['LFPData/LFP',num2str(channel),'.mat'])
        for k = 1:length(StimTimes)
            OutputOriginal{k} = Data(Restrict(LFP,intervalSet(StimTimes(k)-20*1e4,StimTimes(k)+60*1e4)));
            Output{k} = OutputOriginal{k};
            %     Output{k}(find(Time{k}<StimTimes(k))) = 0;
            %     Output{k}(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
        end
        
        load('FitTFToLaserResponse.mat')
        
        for k = 1:length(Input)
            [Sp,t,f]=mtspecgramc(Output{k},movingwin,params);
            MeanSpecReal(k,:) = nanmean(Sp(1:find(t<55,1,'last'),:));
        end
        
        
        % Spectra Error
        MeanSpectemp = MeanSpec;
        MeanSpecReal(:,150:190) = NaN;
        MeanSpectemp(:,:,:,:,150:190) = NaN;
        Np = [1:4];
        Delays = [0:0.005:0.015];
        for npnp = 1:length(Np)
            tic
            Nz = [0:Np(npnp)-1];
            for nznz = 1 : length(Nz)
                for del = 1:length(Delays)
                    for k = 1 :  size(MeanSpecReal,1)
                        SpectraError(k,npnp,del,nznz) = nanmean(abs(squeeze(MeanSpectemp(k,npnp,del,nznz,:))-MeanSpecReal(k,:)'));
                    end
                end
            end
        end
        
        SpectraError = squeeze(nanmean(SpectraError,1));
        
        % 13Hz power
        Power13Hz = squeeze(max(squeeze(nanmean(MeanSpec(:,:,:,:,165:175),5)),[],1));
        
        for gg= 1:4
            subplot(2,4,gg)
            imagesc(squeeze(SpectraError(gg,:,:)))
            clim([100 2000])
            subplot(2,4,gg+4)
            imagesc(squeeze(Power13Hz(gg,:,:)))
            clim([2*1e4 10*1e5])
        end
        
        SpectraError(SpectraError==0) = NaN;
        [v,loc] = nanmin(SpectraError(:));
        [ii,jj,kk] = ind2sub(size(SpectraError),loc);
        
        Power13Hz(Power13Hz==0) = NaN;
        [v,loc] = nanmin(Power13Hz(:));
        [ii2,jj2,kk2] = ind2sub(size(Power13Hz),loc);
        
        
        % Check it
        datatouse = iddata([Output{1};Output{2};Output{3}],[Input{1};Input{2};Input{3}],1/1250);
        Np = [1:4];
        Delays = [0:0.005:0.015];
        for npnp = ii2
            tic
            Nz = [0:Np(npnp)-1];
            for nznz =  kk2
                for del = jj2
                    sts = tfest(datatouse,Np(npnp),Nz(nznz),Delays(del));
%                     clf
%                     subplot(221)
%                     impulse(sts)
%                     subplot(222)
%                     step(sts)
%                     subplot(2,2,3:4)
%                     [yout,x] = lsim(sts,Input{3},Time{3}/1e4);
%                     hold on
%                     plot(Time{3},Output{3},'r')
%                     plot(Time{3},yout,'b')
                    
                    for k = 1:length(Input)
                        [yout,x] = lsim(sts,Input{k},Time{k}/1e4);
                        yout(find(Time{k}<StimTimes(k))) = 0;
                        yout(find(Time{k}>StimTimes(k)+40*1e4)) = 0;
                        subplot(2,length(Input),k)
                        [Sp,t,f]=mtspecgramc(Output{k},movingwin,params);
                        imagesc(t,f,log(Sp'))
                        axis xy
                        subplot(2,length(Input),k+length(Input))
                        [Sp,t,f]=mtspecgramc(Output{k}-yout,movingwin,params);
                        imagesc(t,f,log(Sp'))
                        axis xy
                    end
                    
                end
            end
        end
        ModelToUse = sts;
        Params.Np = Np(ii2);
        Params.Nz = Nz(kk2);
        Params.Np = Delays(jj2);

        save('FitTFToLaserResponse.mat','Params','ModelToUse','-append')

        
    end
end


% % calculate error on the rest of the spectra
% [Spreal,t,f]=mtspecgramc(Output{2},movingwin,params);
%
% MeanSpectemp = MeanSpec;
% MeanSpectemp(:,:,150:190) = NaN;
% Spreal(:,150:190) = NaN;
% for npnp = 1:length(Np)
%     npnp
%     for dd = 1:length(Delays)
%         dd
%         SpectraError(npnp,dd,:) = abs(squeeze(nanmean(MeanSpectemp(npnp,dd,:))-nanmean(Spreal)'))';
%     end
% end
% SpectraError = nanmean(SpectraError,3);
%
% % look at power around 13Hz
% Power13Hz = squeeze(nanmean(MeanSpec(:,:,165:175),3));
%
% FinalNP = 1;
% FinalDelay  =0.05;
% StimEpoch = intervalSet(StimTimes,(StimTimes+15*1e4));
% NoStimEpoch = intervalSet(StimTimes-25*1e4,(StimTimes-10*1e4));
%
% for k = 1:length(Output)
%     % Get spectrogram
%     sts = tfest(datatouse,FinalNP,[],FinalDelay);
%     [yout,x] = lsim(sts,Input{k},Time{k}/1E4);
%     yout(find(Time{k}<StimTimes(k))) = 0;
%     yout(find(Time{k}>StimTimes(k)+40*1E4)) = 0;
%
%     [Sp,t,f]=mtspecgramc(Output{k}-yout,movingwin,params);
%     imagesc(t,f,log(Sp'))
%     pause
%     MeanSpec_Corr(k,:,:) = Sp;
%     [Sp,t,f]=mtspecgramc(OutputOriginal{k},movingwin,params);
%     MeanSpec_Real(k,:,:) = Sp;
%
%     % Get trough peak
%     AllPeaks=FindPeaksForFrequency(tsd(Time{k},Output{k}-yout),OptionsMiniMaxi,0);
%     PeakDiff = tsd(AllPeaks(:,1)*1e4+min(Time{k}),0.5*[0;1./diff(AllPeaks(:,1))]);
%
%     MeanFreq_Stim(k,:) = hist(Data(Restrict(PeakDiff,subset(StimEpoch,k))),[0:0.3:15]);
%     MeanFreq_NoStim(k,:) = hist(Data(Restrict(PeakDiff,subset(NoStimEpoch,k))),[0:0.3:15]);
%
%
% end
%
%
%
%
%
%
% imagesc(SpectraError)
%
%
% clf
% subplot(221)
% impulse(sts)
% subplot(222)
% step(sts)
% subplot(2,2,3:4)
% [yout,x] = lsim(sts,Input{3},Time{3}/1e4);
% hold on
% plot(Time{3},Output{3},'r')
% plot(Time{3},yout,'b')
%
