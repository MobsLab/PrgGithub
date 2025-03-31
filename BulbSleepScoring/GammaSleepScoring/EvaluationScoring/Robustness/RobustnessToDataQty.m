clear all
ThetaI=[3 3]; %merge and drop
mindur=3; %abs cut off for events;
Ratio_Sleep = [0.1:0.2:0.9];
TotDur_Sleep = [30:30:120]*60; % in sec
Ratio_REM = [0.05:0.05:0.2];
TotDur_REM = [10:10:120]*60;% in sec
m=0;
m=m+1;Filename{m} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse490/20161124/ProjectEmbReact_M490_20161124_BaselineSleep';
m=m+1;Filename{m} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse508/20170126/ProjectEmbReact_M508_20170126_BaselineSleep';
m=m+1;Filename{m} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse507/20170126/ProjectEmbReact_M507_20170126_BaselineSleep';
m=m+1;Filename{m} = '/media/DataMOBsRAIDN/ProjectEmbReact/Mouse510/20170203/ProjectEmbReact_M510_20170203_BaselineSleep';
m=m+1;Filename{m} = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice243-244/20150329/Breath-Mouse-243-244-29032015/Mouse243';
m=m+1;Filename{m} = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150518/Breath-Mouse-251-252-18052015/Mouse251/';
m=m+1;Filename{m} = '/media/DataMOBsRAID/ProjetBreathDeltaFeedback/Mice251-252/20150519/Breath-Mouse-251-252-19052015/Mouse252/';
m=m+1;Filename{m} = '/media/DataMOBsRAIDN/ProjetNREM/Mouse403/20160830';
for mm=1:m
    cd(Filename{mm})
    load('StateEpochSB.mat')
    % sleep and wake
    AllSleepData = Data(Restrict(smooth_ghi,Sleep));
    AllWakeData = Data(Restrict(smooth_ghi,Wake));
    dt = median(diff(Range(smooth_ghi,'s')));
    figure
    for r = 1:length(Ratio_Sleep)
        for tps = 1:length(TotDur_Sleep)
            
            NumSleepPoints = Ratio_Sleep(r)*TotDur_Sleep(tps)/dt;
            NumWakePoints = (1-Ratio_Sleep(r))*TotDur_Sleep(tps)/dt;
            gamma_thresh_downsampled(r,tps)=GetGammaThresh([AllSleepData(1:NumSleepPoints);AllWakeData(1:NumWakePoints)],1,0);
            clf
        end
    end
    close all
    
    % REM and NREM
    AllREMData = Data(Restrict(smooth_Theta,REMEpoch));
    AllSWSData = Data(Restrict(smooth_Theta,SWSEpoch));
    dt = median(diff(Range(smooth_Theta,'s')));
    
    for r = 1:length(Ratio_REM)
        for tps = 1:length(TotDur_REM)
            
            NumREMPoints = Ratio_REM(r)*TotDur_REM(tps)/dt;
            NumSWSPoints = (1-Ratio_REM(r))*TotDur_REM(tps)/dt;
            theta_thresh_downsampled(r,tps)=GetThetaThresh(log([AllREMData(1:NumREMPoints);AllSWSData(1:NumSWSPoints)]),0,0);
            
        end
    end
    
%     save('DownSampledThresholds.mat','gamma_thresh_downsampled','theta_thresh_downsampled','Ratio_Sleep','TotDur_Sleep','Ratio_REM','TotDur_REM')
     save('DownSampledThresholds.mat','theta_thresh_downsampled','Ratio_REM','TotDur_REM','-append')
    clear theta_thresh_downsampled gamma_thresh_downsampled AllREMData AllSWSData AllWakeData AllSleepData
end

for mm=1:m
    clear sleepper_new ThetaEpoch_new
    cd(Filename{mm})
    load('StateEpochSB.mat')
    load('DownSampledThresholds.mat')
    
    %% Sleep/wake overlap
    for r = 1:length(Ratio_Sleep)
        for tps = 1:length(TotDur_Sleep)
            
            sleepper_new{r,tps}=thresholdIntervals(smooth_ghi,exp(gamma_thresh_downsampled(r,tps)),'Direction','Below');
            sleepper_new{r,tps}=mergeCloseIntervals(sleepper_new{r,tps},mindur*1e4);
            sleepper_new{r,tps}=dropShortIntervals(sleepper_new{r,tps},mindur*1e4);
        end
    end
    
    
    TotEpoch=intervalSet(0,max(Range(smooth_ghi)));
    for r = 1:length(Ratio_Sleep)
        for tps = 1:length(TotDur_Sleep)
            
            % observed agreement between observers
            Agree(1)=length(Restrict(smooth_ghi,and(sleepper,sleepper_new{r,tps})));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new{r,tps}));
            % observed agreement between observers
            Agree(2)=length(Restrict(smooth_ghi,and(TotEpoch-sleepper,TotEpoch-sleepper_new{r,tps})));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new{r,tps}));
            po=sum(Agree)/sum(Overall);
            
            % chance agreement
            Agree(1)=length(Restrict(smooth_ghi,sleepper)).*length(Restrict(smooth_ghi,sleepper_new{r,tps}));
            Overall(1)=length(Restrict(smooth_ghi,sleepper_new{r,tps}));
            Agree(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper)).*length(Restrict(smooth_ghi,TotEpoch-sleepper_new{r,tps}));
            Overall(2)=length(Restrict(smooth_ghi,TotEpoch-sleepper_new{r,tps}));
            pe=sum(Agree)/sum(Overall).^2;
            
            % Kappa
            Kap_Sleep(r,tps)=(po-pe)/(1-pe);
            
            % Overall overlap
            TotAgreement = length(Restrict(smooth_ghi,and(sleepper,sleepper_new{r,tps})))+length(Restrict(smooth_ghi,and(TotEpoch-sleepper,TotEpoch-sleepper_new{r,tps})));
            Total = length(Restrict(smooth_ghi,TotEpoch));
            
            Overlap_Sleep(r,tps) = TotAgreement ./ Total;
        end
    end
    
    
    %% SWS/REM overlap
    for r = 1:length(Ratio_REM)
        for tps = 1:length(TotDur_REM)
            
            theta_thresh=exp(theta_thresh_downsampled(r,tps));
            ThetaEpoch_new{r,tps}=thresholdIntervals(smooth_Theta,theta_thresh,'Direction','Above');
            ThetaEpoch_new{r,tps}=mergeCloseIntervals(ThetaEpoch_new{r,tps},ThetaI(1)*1E4);
            ThetaEpoch_new{r,tps}=dropShortIntervals(ThetaEpoch_new{r,tps},ThetaI(2)*1E4);
            ThetaEpoch_new{r,tps} = and(ThetaEpoch_new{r,tps},sleepper);
        end
    end
    
    for r = 1:length(Ratio_REM)
        for tps = 1:length(TotDur_REM)
            
            % observed agreement between observers
            Agree(1)=length(Restrict(smooth_Theta,and(ThetaEpoch,ThetaEpoch_new{r,tps})));
            Overall(1)=length(Restrict(smooth_Theta,ThetaEpoch_new{r,tps}));
            % observed agreement between observers
            Agree(2)=length(Restrict(smooth_Theta,and(sleepper-ThetaEpoch,sleepper-ThetaEpoch_new{r,tps})));
            Overall(2)=length(Restrict(smooth_Theta,sleepper-ThetaEpoch_new{r,tps}));
            po=sum(Agree)/sum(Overall);
            
            % chance agreement
            Agree(1)=length(Restrict(smooth_Theta,ThetaEpoch)).*length(Restrict(smooth_Theta,ThetaEpoch_new{r,tps}));
            Overall(1)=length(Restrict(smooth_Theta,ThetaEpoch_new{r,tps}));
            Agree(2)=length(Restrict(smooth_Theta,sleepper-ThetaEpoch)).*length(Restrict(smooth_Theta,sleepper-ThetaEpoch_new{r,tps}));
            Overall(2)=length(Restrict(smooth_Theta,sleepper-ThetaEpoch_new{r,tps}));
            pe=sum(Agree)/sum(Overall).^2;
            
            % Kappa
            Kap_Rem(r,tps)=(po-pe)/(1-pe);
            
            % Overall overlap
            TotAgreement = length(Restrict(smooth_ghi,and(ThetaEpoch,ThetaEpoch_new{r,tps})))+length(Restrict(smooth_ghi,and(sleepper-ThetaEpoch,sleepper-ThetaEpoch_new{r,tps})));
            Total = length(Restrict(smooth_ghi,sleepper));
            
            Overlap_Rem(r,tps) = TotAgreement ./ Total;
        end
    end
    
    save('DownSampledThresholds.mat','Overlap_Rem','Kap_Rem','Overlap_Sleep','Kap_Sleep','-append')
%      save('DownSampledThresholds.mat','Overlap_Rem','Kap_Rem','-append')

end


for mm=1:m
    clear sleepper_new ThetaEpoch_new
    cd(Filename{mm})
    load('DownSampledThresholds.mat')
    AllOverlapSleep(mm,:,:)=Overlap_Sleep;
    AllKappaSleep(mm,:,:)=Kap_Sleep;
    AllOverlap_Rem(mm,:,:)=Overlap_Rem;
    AllKappa_Rem(mm,:,:)=Kap_Rem;

end

% overlap
figure
imagesc(Ratio_Sleep,TotDur_Sleep/60,squeeze(nanmean(AllOverlapSleep,1)*100)')
set(gca,'XTick',Ratio_Sleep,'Ytick',TotDur_Sleep/60)
clim([0.92 1]*100),
colorbar
xlabel('Proportion of sleep')
ylabel('Total duration - min')
vals = squeeze(nanmean(AllOverlapSleep,1));
for r=1:length(Ratio_Sleep)
    for t=1:length(TotDur_Sleep)
        text(Ratio_Sleep(r)-0.05,TotDur_Sleep(t)/60,num2str(round(vals(r,t)*100)),'color','w','fontsize',12)
    end
end
title('% Overlap')

figure
imagesc(Ratio_REM,TotDur_REM/60,squeeze(nanmean(AllOverlap_Rem,1)*100)')
set(gca,'XTick',Ratio_REM,'Ytick',TotDur_REM/60)
clim([0.8 1]*100),
colorbar
xlabel('Proportion of REM in total sleep')
ylabel('Total duration - min')
vals = squeeze(nanmean(AllOverlap_Rem,1));
for r=1:length(Ratio_REM)
    for t=1:length(TotDur_REM)
        text(Ratio_REM(r)-0.01,TotDur_REM(t)/60,num2str(round(vals(r,t)*100)),'color','w','fontsize',12)
    end
end

% Kappa
figure
imagesc(Ratio_Sleep,TotDur_Sleep/60,squeeze(nanmean(AllKappaSleep,1))')
set(gca,'XTick',Ratio_Sleep,'Ytick',TotDur_Sleep/60)
clim([0.92 1]),
colorbar
xlabel('Proportion of sleep')
ylabel('Total duration - min')
vals = squeeze(nanmean(AllKappaSleep,1));
for r=1:length(Ratio_Sleep)
    for t=1:length(TotDur_Sleep)
        text(Ratio_Sleep(r)-0.05,TotDur_Sleep(t)/60,num2str(round(vals(r,t),2)),'color','w','fontsize',12)
    end
end
title('Cohen''s Kappa')

figure
imagesc(Ratio_REM,TotDur_REM/60,squeeze(nanmean(AllKappa_Rem,1))')
set(gca,'XTick',Ratio_REM,'Ytick',TotDur_REM/60)
clim([0.8 1]),
colorbar
xlabel('Proportion of REM in total sleep')
ylabel('Total duration - min')
vals = squeeze(nanmean(AllKappa_Rem,1));
for r=1:length(Ratio_REM)
    for t=1:length(TotDur_REM)
        text(Ratio_REM(r)-0.01,TotDur_REM(t)/60,num2str(round(vals(r,t),2)),'color','w','fontsize',12)
    end
end
title('Cohen''s Kappa')
