
%% Carole's mice

% 875
cd('/media/nas4/ProjetEmbReact/Mouse875/20190411/SpectrumDataL') % Baseline
load('Spectrum30.mat') % dHPC channel

figure
subplot(311)
imagesc(t,f,10*log10(Sp')), axis xy; makepretty

figure
plot(f,mean(10*(Sp)),'k','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
makepretty

% 1 month and 12 days after

cd('/media/nas4/ProjetEmbReact/Mouse875/20190523/SpectrumDataL') % Flx11
load('Spectrum30.mat') % dHPC channel

subplot(313)
imagesc(t,f,10*log10(Sp')), axis xy; makepretty; caxis([0 80])

plot(f,mean(10*(Sp)),'r','linewidth',2)

% 877, no more HPC channel




% 876, ref issue ?
cd('/media/nas4/ProjetEmbReact/Mouse876/20190411/SpectrumDataL') % Baseline
load('Spectrum0.mat') % dHPC channel
cd('/media/nas4/ProjetEmbReact/Mouse876/20190411') 
load('SleepScoring_OBGamma.mat')

figure
subplot(311)
imagesc(t,f,10*log10(Sp')), axis xy; makepretty; ylabel('Frequency (Hz)'); title('HPC spectrogram')
 xlabel('time (s)')

Sptsd = tsd(t*1E4,Sp);
SptsdREM=Restrict(Sptsd,REMEpoch);
SptsdSleep=Restrict(Sptsd,Sleep);
SptsdWake=Restrict(Sptsd,Wake);

subplot(212)
plot(f,mean(10*Data(SptsdWake)),'b','linewidth',2), ylabel('HPC Power'); xlabel('Frequency (Hz)'); hold on
plot(f,mean(10*Data(SptsdSleep)),'r','linewidth',2)
plot(f,mean(10*Data(SptsdREM)),'g','linewidth',2)
f=get(gca,'Children');
legend([f(3),f(2),f(1)],'Wake','Sleep','REM')
 title('HPC mean spectrum')
 axis square
makepretty

a=suptitle('Baseline sleep'); a.FontSize=20;

% 1 month and 3 days after

cd('/media/nas4/ProjetEmbReact/Mouse876/20190507/SpectrumDataL') % Flx2
load('Spectrum0.mat') % dHPC channel
cd('/media/nas4/ProjetEmbReact/Mouse876/20190507')
load('SleepScoring_OBGamma.mat')

figure
subplot(311)
imagesc(t,f,10*log10(Sp')), axis xy; makepretty; ylabel('OB');

Sptsd = tsd(t*1E4,Sp);
SptsdREM=Restrict(Sptsd,REMEpoch);
SptsdSleep=Restrict(Sptsd,Sleep);
SptsdWake=Restrict(Sptsd,Wake);

subplot(212)
plot(f,mean(10*Data(SptsdWake)),'b','linewidth',2), ylabel('OB'); xlabel('Frequency (Hz)'); hold on
plot(f,mean(10*Data(SptsdSleep)),'r','linewidth',2)
plot(f,mean(10*Data(SptsdREM)),'g','linewidth',2)
f=get(gca,'Children');
legend([f(3),f(2),f(1)],'Wake','Sleep','REM')
makepretty
a=suptitle('Flx2 sleep'); a.FontSize=20;


% Scoring with Ob only
sess={'/media/nas4/ProjetEmbReact/Mouse876/20190411','/media/nas4/ProjetEmbReact/Mouse876/20190507','/media/nas4/ProjetEmbReact/Mouse876/20190509','/media/nas4/ProjetEmbReact/Mouse876/20190516'};

for s=1:length(sess)
    cd(sess{s})
    
    load('SleepScoring_OBGamma','REMEpoch','SWSEpoch')
    TotDur(s)=sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch))+sum(Stop(Wake)-Start(Wake));
    
    % REM
    remHPC(s) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
    
    clear('REMEpoch','SWSEpoch','Sleep','Wake')
    load('SleepScoring_Accelero.mat','REMEpoch','SWSEpoch')
    remAcc(s) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
   
    clear('REMEpoch','SWSEpoch','Sleep','Wake')
    load('StateEpochSBAllOB.mat','REMEpoch','SWSEpoch','Wake','Sleep')
    remOB1015(s) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
  
    clear('REMEpoch','SWSEpoch','Sleep','Wake')
    load('StateEpochSBAllOB_Bis.mat','REMEpoch','SWSEpoch','Wake','Sleep')
    remOB1525(s) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
  
    clear('REMEpoch','SWSEpoch','Sleep','Wake')
    load('StateEpochSBAllOB_Ter.mat','REMEpoch','SWSEpoch','Wake','Sleep')
    remOB2030(s) = sum(Stop(REMEpoch)-Start(REMEpoch))./(sum(Stop(SWSEpoch)-Start(SWSEpoch))+sum(Stop(REMEpoch)-Start(REMEpoch)));
    
end

TotDur=TotDur/(3600*1e4);

figure
subplot(331)
bar(TotDur); xticks([1 2 3 4]); ylabel('Recording time (h)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('Total recording time')
makepretty
subplot(332)
bar(SleepDur([1 4 5 6],2)); xticks([1 2 3 4]); ylabel('Sleep time (h)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('Total sleep time')
makepretty
subplot(333)
bar(SleepDur([1 4 5 6],2)./(TotDur')); xticks([1 2 3 4]); ylabel('Sleep proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('Sleep time / Total time')
makepretty
subplot(334)
bar(remAcc); xticks([1 2 3 4]); ylabel('REM proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('Accelero and HPC scoring')
makepretty
subplot(336)
bar(remHPC); xticks([1 2 3 4]); ylabel('REM proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('OB and HPC scoring')
makepretty
subplot(337)
bar(remOB1015); xticks([1 2 3 4]); ylabel('REM proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('OB only scoring, 10-15')
makepretty
subplot(338)
bar(remOB1525); xticks([1 2 3 4]); ylabel('REM proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('OB only scoring, 15-25')
makepretty
subplot(339)
bar(remOB2030); xticks([1 2 3 4]); ylabel('REM proportion (%)')
xticklabels({'Baseline','Flx2','Flx5','Flx12','Flx18'}); 
title('OB only scoring, 20-30')
makepretty

a=suptitle('Sleep analysis, M876'); a.FontSize=20;


