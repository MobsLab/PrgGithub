% function [SpREMstart,SpREMend,freq,temps] = TriggerAvSpectroOnREMep_SingleMouse_MC(Spectro,plo)
function [SpREMstart,SpREMend,freq,temps] = TriggerAvSpectroOnREMep_SingleMouse_MC(plo)


% OUTPUTS : 
% averaged spectro triggered on starts or ends of REM episodes
% frequencies
% time

% INPUT :
% spectro of the structure you want

try
    plo;
catch
    plo=0;
end

%% load
load SleepScoring_OBGamma REMEpochWiNoise SWSEpochWiNoise WakeWiNoise
REMEp  =mergeCloseIntervals(REMEpochWiNoise,1E4);
% SWSEp  =mergeCloseIntervals(SWSEpochWiNoise,1E4);
% WakeEp  =mergeCloseIntervals(WakeWiNoise,1E4);

%% load spectro
load H_Low_Spectrum
Spectre=Spectro;
freq=Spectro{3};
sptsd= tsd(Spectre{2}*1e4, Spectre{1});

% load Bulb_deep_Low_Spectrum
% SpectroB=Spectro;
% freq=Spectro{3};
% sptsd= tsd(SpectroB{2}*1e4, SpectroB{1});

% %to smooth the high freq spectro
% clear datOBnew
% datOB = Spectro{1};
% for k = 1:size(datOB,2)
%     datOBnew(:,k) = runmean(datOB(:,k),500);
% end
% sptsdB=tsd(SpectroB{2}*1e4, datOBnew); % make tsd

%% compute average spectro
%to average the spectro on every starts or ends of REM episodes
[M_REMstart,S_REMstart,tps]=AverageSpectrogram(sptsd,freq,ts(Start(REMEp)),500,500,0);
[M_REMend,S_REMend,tps]=AverageSpectrogram(sptsd,freq,ts(End(REMEp)),500,500,0);
% 
% [M_Wakestart,S_Wakestart,tps]=AverageSpectrogram(sptsd,freq,ts(Start(WakeEp)),500,500,0);
% [M_Wakeend,S_Wakeend,tps]=AverageSpectrogram(sptsd,freq,ts(End(WakeEp)),500,500,0);
% SpREMstart=M_REMstart;
% SpREMend=M_REMend;

%if you want to normalize the spectro
SpREMstart=M_REMstart/median(M_REMstart(:));
SpREMend=M_REMend/median(M_REMend(:));

% SpWakestart=M_Wakestart/median(M_Wakestart(:));
% SpWakeend=M_Wakeend/median(M_Wakeend(:));
% SpectroBrem=MB_REM/mean(MB_REM(1:floor(length(MB_REM))/2))*100;

temps=tps/1E3;

%% plot
if plo
    figure('color',[1 1 1]),subplot(211),imagesc(temps,freq, log(SpREMstart)),axis xy
%     caxis([7 9.9])
%     ylim([10 30])
    xlim([-60 +60])
    colorbar
    line([0 0],ylim,'color','w','linestyle','-')
    title('start')
    subplot(212),imagesc(temps,freq, log(SpREMend)),axis xy
%     caxis([7 9.9])
%     ylim([10 30])
    xlim([-60 +60])
    colorbar
    line([0 0],ylim,'color','w','linestyle','-')
    title('end')
%     suptitle('OB REM')
    suptitle('HPC SWS')
end
end
