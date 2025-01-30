close all
clear all
StepSizes = [0.5,1,1.5,2,3,4];
for st = 1:length(StepSizes)
    stepsize = StepSizes(st);
    
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'NoMemory.mat'])
    load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])
    cols = {'k','b','r'}
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            
            ErrMat = (PercFz-PercFz_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);
            Err_ActDur_GFP(st,k,l) = (DurActEp_GFP(k,l)-DurActEp(row)).^2;
            Err_FzDur_GFP(st,k,l) = (DurFzEp_GFP(k,l)-DurFzEp(row)).^2;
            Err_FreqInit_GFP(st,k,l) = (FreqInit_GFP(k,l)-FreqInit(row)).^2;
            
        end
    end
    
    for l = 2:size(DurFzEp_GFP,2)
        for k=1:size(DurFzEp_GFP,1)
            
            ErrMat = (PercFz-PercFz_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);
            Err_ActDur_CHR2(st,k,l) = (DurActEp_CHR2(k,l)-DurActEp(row)).^2;
            Err_FzDur_CHR2(st,k,l) = (DurFzEp_CHR2(k,l)-DurFzEp(row)).^2;
            Err_FreqInit_CHR2(st,k,l) = (FreqInit_CHR2(k,l)-FreqInit(row)).^2;
            
        end
    end
    
end

figure
subplot(311)
hold on
errorbar(StepSizes,nanmean(Err_ActDur_GFP(:,:,2)'),stdError(Err_ActDur_GFP(:,:,2)'),stdError(Err_ActDur_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
errorbar(StepSizes,nanmean(Err_ActDur_CHR2(:,:,2)'),stdError(Err_ActDur_CHR2(:,:,2)'),stdError(Err_ActDur_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
xlabel('Step size (s)')
ylabel('Err')
title('Act Dur')
box off

subplot(312)
a=patch([1.4 1.4 1.6 1.6],[0 0.015 0.015 0],[0.9 0.9 0.9]);a.EdgeColor = [0.9 0.9 0.9];
hold on
errorbar(StepSizes,nanmean(Err_FzDur_GFP(:,:,2)'),stdError(Err_FzDur_GFP(:,:,2)'),stdError(Err_FzDur_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
errorbar(StepSizes,nanmean(Err_FzDur_CHR2(:,:,2)'),stdError(Err_FzDur_CHR2(:,:,2)'),stdError(Err_FzDur_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
xlabel('Step size (s)')
ylabel('Err')
title('Fz Dur')
box off

subplot(313)
a=patch([1.4 1.4 1.6 1.6],[0 0.001 0.001 0],[0.9 0.9 0.9]);a.EdgeColor = [0.9 0.9 0.9];
hold on
errorbar(StepSizes,nanmean(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),stdError(Err_FreqInit_GFP(:,:,2)'),'color',[0.4 0.8 0.4],'linewidth',2)
errorbar(StepSizes,nanmean(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),stdError(Err_FreqInit_CHR2(:,:,2)'),'color',[0.4 0.4 0.8],'linewidth',2)
xlabel('Step size (s)')
ylabel('Err')
title('Number Episodes')
box off


st = 3;
stepsize = StepSizes(st);

fig = figure;
fig.Name=num2str(stepsize);
load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/SimulationFzOpto' num2str(stepsize),'NoMemory.mat'])
load(['/home/vador/Dropbox/Mobs_member/SophieBagur/BehaviourOptoDurationEvents/DataFzingStatesopto_' num2str(stepsize),'.mat'])

fig = figure;
subplot(321)
line([0 7],[0 7],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 7]), ylim([0 7]), hold on
xlabel('DurAct - data'), ylabel('DurAct - prediction')
title('no laser')
subplot(322)
line([0 15],[0 15],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 15]), ylim([0 15]), hold on
xlabel('DurAct - data'), ylabel('DurAct - prediction')
title(' laser')

subplot(323)
line([0 110],[0 110],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 110]), ylim([0 110]), hold on
xlabel('DurFz - data'), ylabel('DurFz - prediction')
subplot(324)
line([0 60],[0 60],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 60]), ylim([0 60]), hold on
xlabel('DurFz - data'), ylabel('DurFz - prediction')

subplot(325)
line([0 0.2],[0 0.2],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.2]), ylim([0 0.2]), hold on
xlabel('FreqInit - data'), ylabel('FreqInit - prediction')
subplot(326)
line([0 0.2],[0 0.2],'color',[0.6 0.6 0.6],'linewidth',1.5), xlim([0 0.2]), ylim([0 0.2]), hold on
xlabel('FreqInit - data'), ylabel('FreqInit - prediction')

for l = 2:size(DurFzEp_GFP,2)
    for k=1:size(DurFzEp_GFP,1)
        ErrMat = (PercFz-PercFz_GFP(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);
        
        subplot(3,2,(l-1)+0)
        plot(DurActEp(row),DurActEp_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        subplot(3,2,(l-1)+2)
        plot(DurFzEp(row),DurFzEp_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on
        subplot(3,2,(l-1)+4)
        plot(FreqInit(row),FreqInit_GFP(k,l),'.','color',[0.4 0.8 0.4],'MarkerSize',20),hold on

    end
end
for l = 2:size(PercFz_CHR2,2)
    for k=1:size(PercFz_CHR2,1)
        ErrMat = (PercFz-PercFz_CHR2(k,l)).^2;
            ErrMat = naninterp(ErrMat);
            ErrMat = SmoothDec(ErrMat,2);
            val = min(min(ErrMat));
            row = find(ErrMat == val);

        
        subplot(3,2,(l-1)+0)
        plot(DurActEp(row),DurActEp_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        subplot(3,2,(l-1)+2)
        plot(DurFzEp(row),DurFzEp_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on
        subplot(3,2,(l-1)+4)
        plot(FreqInit(row),FreqInit_CHR2(k,l),'.','color',[0.4 0.4 0.8],'MarkerSize',20),hold on

    end
end

