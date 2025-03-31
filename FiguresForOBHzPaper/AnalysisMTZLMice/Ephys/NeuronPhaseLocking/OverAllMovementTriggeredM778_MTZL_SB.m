FileName{1} = '/media/nas4/ProjetMTZL/Mouse778/24102018';
FileName{2} = '/media/nas4/ProjetMTZL/Mouse778/20181213';
FileName{3} = '/media/nas4/ProjetMTZL/Mouse778/20181218';

clf
for f = 1:3
    cd(FileName{f})
    
    load('NeuronResponseToMovement/Results.mat','sq','sweeps','AccBurst')
    
    % Show accelero triggered events
    load('LFPData/LFP34.mat')
    a = Data(LFP);
    a(a<-3.5e4)=NaN;
    a(a>-1)=NaN;
    aint = naninterp(a);
    A=tsd(Range(LFP),[0;diff(aint)]);
    LFPClean = tsd(Range(LFP),aint);
    LFPClean = tsd(Range(LFP),Data(LFPClean)-movmean(Data(LFPClean),1250*60))
    
    [MAcc{f},TAcc{f}]=PlotRipRaw(LFPClean,Start(AccBurst,'s'),5000,0,0);
    
    % Get breathing phase
    load('BreathingInfo_ZeroCross.mat')
    AllPeaks=[0:2*pi:2*pi*(length(Data(Breathtsd))-1)];
    Y=interp1(Range(Breathtsd,'s'),AllPeaks,Range(LFP,'s'));
    PhaseInterpol=tsd(Range(LFP),mod(Y,2*pi));
    
    % Get breathing phase triggered on events
    for i=-5*10:5*10
        [hPhase{f}(i+5*10+1,:),b]=hist(Data(Restrict(PhaseInterpol,intervalSet(Start(AccBurst)+(i-1)*1E3,Start(AccBurst)+i*1E3))),[0.05:0.1:6.25]);
    end
    
    % Get neuron firing triggered on events
    for n = 1:length(sq)
        AllNeur{f}(n,:) = Data(sq{n});
    end
    
    
end
Cond = {'SAL','SAL','MTZL'};

figure
for f = 1:3
subplot(3,1,f)
imagesc(MAcc{f}(:,1),1:size(TAcc{f},1),zscore(TAcc{f}')')
clim([-2 2])
title(Cond{f})
xlabel('time to onset (s)')
ylabel('event num')
end

figure
for f = 1:3
plot(MAcc{f}(:,1),runmean(nanmean(zscore(TAcc{f}')'),10)), hold on
xlabel('time to onset (s)')
ylabel('Acc (AU)')
xlim([-2 2])
end
legend(Cond)

figure
for f = 1:3
subplot(3,1,f)
imagesc(MAcc{f}(:,1),[0.05:0.1:6.25],hPhase{f}(:,2:end-1)')
xlabel('time to onset (s)')
ylabel('BreathingPhase')
title(Cond{f})
end


figure
for f = 1:3
subplot(3,1,f)
imagesc(MAcc{f}(:,1),[0.05:0.1:6.25],zscore(hPhase{f}(:,2:end-1)'))
xlabel('time to onset (s)')
ylabel('BreathingPhase')
title(Cond{f})
end

figure
for f = 1:3
subplot(1,3,f)
Mat = zscore(AllNeur{f}(:,1:end-1)');
Mat = [nanmean(Mat(40:50,:));Mat];
Mat = sortrows(Mat')';
Mat(:,2:end);
imagesc(MAcc{f}(:,1),1:size(Mat,2),SmoothDec(Mat,0.8)')
clim([-2 2])
xlabel('time to onset (s)')
ylabel('Neuron Number')
title(Cond{f})
end


